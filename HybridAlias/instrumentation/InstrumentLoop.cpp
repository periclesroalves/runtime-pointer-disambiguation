#include "llvm/Transforms/Instrumentation.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Pass.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Function.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/CommandLine.h"
#include <llvm/Support/Debug.h>
#include <string.h>
#include <string>
#include <list>
#include <set>
#include <map>

#define DEBUG_TYPE "alias-instrument-loop"

//#define STATS

using namespace llvm;
using namespace std;

typedef pair<Value*, Value*> valuePair;

// Make sure this matches the name of the tracer function in libmemtrack.a
static const char *const traceFunctionName = "gcg_trace_alias_pair";

namespace {

/***
 * Declare external refernce to alias tracing function
 */
struct DeclareTraceFunction : public ModulePass
{
	static char ID;

	DeclareTraceFunction() : ModulePass(ID), trace_fn(nullptr) {}

	const char *getPassName() const override { return "DeclareTraceFunction"; }

	virtual bool runOnModule(Module& m) override;

	Function *getTraceFn() {
		assert(trace_fn);

		return trace_fn;
	}
private:
	Function *trace_fn;
};

struct AliasInstrumentLoops : public LoopPass
{
	static char ID;

	AliasInstrumentLoops() : LoopPass(ID) {}

	const char *getPassName() const override { return "AliasInstrumentLoops"; }

	bool runOnLoop(Loop *L, LPPassManager &LPM) override;

	void getAnalysisUsage(AnalysisUsage &AU) const override
	{
		// TODO: LLVM doc states that transformation passes should
		//       not be chained with addRequire but with a custom
		//       PassManager
		AU.addRequired<DeclareTraceFunction>();

		AU.addRequired<DominatorTreeWrapperPass>();
		AU.addRequired<AliasAnalysis>();
	}
private:
	Loop                *currLoop;
	list<Loop*>          clonedLoops;
	DominatorTree       *domTree;
	map<string, Value*>  global_strings;

	Value*    createGlobalStringPointer(LLVMContext& ctx, Module *m, StringRef str);
	valuePair createInputForAliasTracerFn(LLVMContext& ctx, Module *m, IRBuilder<>& irb, Value *ptr);

	Value *getOrInsertMagic(Value *basePtr);

	void getBasePtrs(Value *ptr, set<Value*>& basePtrs);
	void getBasePtrs(Value *ptr, set<Value*>& basePtrs, set<Value*>& visited);
};

} // end anonymous namespace

char DeclareTraceFunction::ID = 0;
static RegisterPass<DeclareTraceFunction> X(
	"declare-trace-function",
	"Declare external refernce to alias tracing function"
);

char AliasInstrumentLoops::ID = 0;
static RegisterPass<AliasInstrumentLoops> Y(
	"alias-instrument-loops",
	"Instrument loops for alias profiling"
);

cl::opt<string> InstrumentOnlyPrefix(
	"instrument-only",
	cl::desc("Instrument only loops in a function whose (mangled!) name has the given prefix"),
	cl::init("")
);

bool DeclareTraceFunction::runOnModule(Module &M)
{
	DEBUG(dbgs() << "DeclareTraceFunction::runOnModule\n");

	// ** declare alias tracing function

	LLVMContext& ctx = M.getContext();

	Type *char_ptr_type = Type::getInt8PtrTy(ctx);

	Type *return_type = Type::getInt32Ty(ctx);

	std::vector<Type*> parameter_types{
		char_ptr_type, // const char *loop
		char_ptr_type, // const char *name1
		char_ptr_type, // void *ptr1
		char_ptr_type, // const char *name2
		char_ptr_type  // void *ptr2
	};

	trace_fn = Function::Create(
		FunctionType::get(return_type, parameter_types, false),
		GlobalValue::ExternalLinkage,
		traceFunctionName,
		&M
	);

	trace_fn->addAttribute(1, Attribute::ReadOnly);
	trace_fn->addAttribute(2, Attribute::ReadOnly);
	trace_fn->addAttribute(3, Attribute::ReadOnly);
	trace_fn->addAttribute(4, Attribute::ReadOnly);
	trace_fn->addAttribute(5, Attribute::ReadOnly);

	return true;
}

/// prototypes for helper functions

static bool         isInterestingPointer(Value *v);
static bool         notDefinedIn(const Loop *loop, const Value *V);
static bool         hasPrefix(const std::string& str, const std::string& prefix);
static bool         isGlobalOrArgument(const Value *v);
static Instruction* nextOf(Instruction *i);
static BasicBlock*  lastOf(BasicBlock *bb1, BasicBlock *bb2);
static valuePair    orderedPair(Value *v1, Value *v2);


bool AliasInstrumentLoops::runOnLoop(Loop *L, LPPassManager &LPM)
{
	//we are interested only in innermost loops
	if(L->getSubLoops().size() > 0) return false;

	//do not run on cloned loop
	for(list<Loop*>::iterator I = clonedLoops.begin(), IE = clonedLoops.end(); I != IE; ++I) if(L == *I) return false;

	DEBUG(dbgs() << "========================================================\n");
	DEBUG(dbgs() << "ILC::runOnLoop(Function = " << L->getHeader()->getParent()->getName() << ", Loop = " << L->getHeader()->getName());
	DEBUG(dbgs() << "========================================================\n");

	// list of mod/ref locations
	list<AliasAnalysis::Location> ModRefLocations;
	// list of may-alias location pairs
	set<valuePair> MayAliasPairs;
	// list of conditionals
	list<Value*> conditionals;

	//set instance variables
	currLoop = L;
	domTree  = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();

	AliasAnalysis&        aliasAnalysis = getAnalysis<AliasAnalysis>();
	DeclareTraceFunction& dtf           = getAnalysis<DeclareTraceFunction>();

	Function *trace_fn = dtf.getTraceFn();

	// XXX: is it legal to read-only access containing fn and module?
	BasicBlock *header = L->getHeader();
	Function   *fn     = header->getParent();
	Module     *module = fn->getParent();

	BasicBlock *preheader = L->getLoopPreheader();
	BasicBlock *entry     = &fn->getEntryBlock();
	LLVMContext& ctx      = module->getContext();

	assert((!header->getName().empty()) && "You must run the `instnamer' pass before using alias-tracer");
	assert(preheader && "Loop was not of simple form");

	StringRef fn_name = fn->getName();

	if (InstrumentOnlyPrefix.size() && !hasPrefix(fn_name, InstrumentOnlyPrefix))
		return false;

	std::string loop_name = (fn_name + "::" + header->getName()).str();

	Value *loop_name_global = createGlobalStringPointer(ctx, module, loop_name);

	Instruction *Branch = &L->getLoopPreheader()->back();
	Value       *add;

  // find all memory accesses in the loop body
  for(Loop::block_iterator B = L->block_begin(), BE = L->block_end(); B != BE; ++B)
  {
    BasicBlock *BB = *B;
    for(BasicBlock::iterator I = BB->begin(), IE = BB->end(); I != IE; ++I)
    {
       Instruction *instr = I;
       AliasAnalysis::Location loc;
       /* TODO: check the above cases
          - MemTransfer    --
          - MemIntrinsic    |
          - Fence           | May Read/Write
          - GetElementPtr   | memory operations
          - Invoke          |
          - Call           --
       */
       switch(instr->getOpcode())
       {
         case Instruction::Load:
           loc = AliasAnalysis::Location(aliasAnalysis.getLocation((const LoadInst *)instr));
           break;
         case Instruction::Store:
           loc = AliasAnalysis::Location(aliasAnalysis.getLocation((const StoreInst *)instr));
           break;
         case Instruction::VAArg:
           loc = AliasAnalysis::Location(aliasAnalysis.getLocation((const VAArgInst *)instr));
           break;
         case Instruction::AtomicCmpXchg:
           loc = AliasAnalysis::Location(aliasAnalysis.getLocation((const AtomicCmpXchgInst *)instr));
           break;
        case Instruction::AtomicRMW:
           loc = AliasAnalysis::Location(aliasAnalysis.getLocation((const AtomicRMWInst *)instr));
           break;
        default:
        	assert(!instr->mayReadOrWriteMemory());
          continue;
       }
       ModRefLocations.push_back(loc);
    }
  }

  // check each possible pair of memory accesses that may alias
  while(!ModRefLocations.empty())
  {
    for(list<AliasAnalysis::Location>::iterator I = ModRefLocations.begin(), IE = ModRefLocations.end(); ++I != IE;)
    {
	    AliasAnalysis::Location loc1 = ModRefLocations.front();
      AliasAnalysis::Location loc2 = *I;

      if(aliasAnalysis.alias(loc1, loc2) == AliasAnalysis::MayAlias)
      	MayAliasPairs.insert(orderedPair(const_cast<Value*>(loc1.Ptr), const_cast<Value*>(loc2.Ptr)));
    }
    ModRefLocations.pop_front();
  }

  // check if all location pairs have null base pointers
  // in that case abort cloning
  int nullBasePtrs = 0;
  for(set<valuePair>::iterator I = MayAliasPairs.begin(), IE = MayAliasPairs.end(); I != IE; ++I)
  {
    set<Value*> basePtrs1;
    getBasePtrs(I->first, basePtrs1);

    set<Value*> basePtrs2;
    getBasePtrs(I->second, basePtrs2);

    if(basePtrs1.find(nullptr) != basePtrs1.end() || basePtrs2.find(nullptr) != basePtrs2.end()) ++nullBasePtrs;
  }
  if(nullBasePtrs == MayAliasPairs.size()) return false;

  // find the base pointers of each pair of may-alias instructions and create pairs of magic numbers corresponding to the base pointers
  for(set<valuePair>::iterator I = MayAliasPairs.begin(), IE = MayAliasPairs.end(); I != IE; ++I)
  {
    // debug print
    DEBUG(dbgs() << "-----------------------------------------------------------\n");
    DEBUG(dbgs() << "may-alias locations\n");
    DEBUG(dbgs() << "-----------------------------------------------------------\n");
    DEBUG(dbgs() << *(I->first)  << "\n");
    DEBUG(dbgs() << *(I->second) << "\n");

    set<Value*> basePtrs1;
		getBasePtrs(I->first, basePtrs1);

    set<Value*> basePtrs2;
    getBasePtrs(I->second, basePtrs2);

    // it seems we reached a load instruction, thus we cannot decide for aliasing
    if(basePtrs1.find(nullptr) != basePtrs1.end() || basePtrs2.find(nullptr) != basePtrs2.end()) continue;

    // debug print
    DEBUG(dbgs() << "-----------------------------------------------------------\n");
    DEBUG(dbgs() << "base ptrs loc1\n");
    DEBUG(dbgs() << "-----------------------------------------------------------\n");
    for(set<Value*>::iterator I1 = basePtrs1.begin(), IE1 = basePtrs1.end(); I1 != IE1; ++I1) { DEBUG(dbgs() << *I1 << "\n"); }
		DEBUG(dbgs() << "-----------------------------------------------------------\n");
		DEBUG(dbgs() << "base ptrs loc2\n");
		DEBUG(dbgs() << "-----------------------------------------------------------\n");
    for(set<Value*>::iterator I2 = basePtrs2.begin(), IE2 = basePtrs2.end(); I2 != IE2; ++I2) { DEBUG(dbgs() << *I2 << "\n"); }

    // create metadata describing the must no alias pairs of the cloned loop
    for(set<Value*>::iterator I1 = basePtrs1.begin(), IE1 = basePtrs1.end(); I1 != IE1; ++I1)
    {
      for(set<Value*>::iterator I2 = basePtrs2.begin(), IE2 = basePtrs2.end(); I2 != IE2; ++I2)
      {
      	Value *ptr1 = *I1;
      	Value *ptr2 = *I2;

        if(ptr1 == ptr2) continue;

				DEBUG(dbgs() << "inserted alias pair trace " << (isGlobalOrArgument(ptr1) && isGlobalOrArgument(ptr2)) << "\n");

				// try to hoist check to function entry block
				BasicBlock *dest = (isGlobalOrArgument(ptr1) && isGlobalOrArgument(ptr2)) ? entry : preheader;

				// we insert tracing code before the terminator basic block
				assert(!(dest->empty()) && "Invalid empty basic block");

				IRBuilder<> irb{dest, --dest->end()};

				Value *void_ptr_1, *void_ptr_2;
				Value *name_ptr_1, *name_ptr_2;

				tie(void_ptr_1, name_ptr_1) = createInputForAliasTracerFn(ctx, module, irb, ptr1);
				tie(void_ptr_2, name_ptr_2) = createInputForAliasTracerFn(ctx, module, irb, ptr2);

		    irb.CreateCall5(trace_fn, loop_name_global, name_ptr_1, void_ptr_1, name_ptr_2, void_ptr_2);
      }
    }
  }

  return true;
}


/***
 * Creates a global string constant and returns a pointer to it
 */
Value *AliasInstrumentLoops::createGlobalStringPointer(LLVMContext& ctx, Module *m, StringRef str)
{
	assert(!str.empty() && "Tried to create empty string constant");

	auto global_entry = global_strings.find(str);

	if (global_entry != global_strings.end())
		return global_entry->second;

	// create global variable

	auto constant_data = ConstantDataArray::getString(ctx, str);

	auto global = new GlobalVariable(
		*m,
		constant_data->getType(),
		true,
		GlobalValue::PrivateLinkage,
		0, // has initializer, specified below
		".str"
	);
	global->setAlignment(1);
	global->setInitializer(constant_data);

	// create pointer to start of global

	auto int_8 = ConstantInt::get(ctx, APInt(64, StringRef("0"), 10));
	std::vector<Constant*> ptr_indices{int_8, int_8};

	auto global_ptr = ConstantExpr::getGetElementPtr(global, ptr_indices);

	global_strings.insert(global_entry, make_pair(str, global_ptr));

	return global_ptr;
}


/***
 * Takes an arbitrary pointer, casts it to a u8* and creates global variable holding it's name.
 */
valuePair AliasInstrumentLoops::createInputForAliasTracerFn(LLVMContext& ctx, Module *m, IRBuilder<>& irb, Value *ptr) {
	StringRef name_str = ptr->getName();

	assert(!name_str.empty() && "You must run the `instnamer' pass before using alias-tracer");

	size_t size = -1;

	auto void_ptr = irb.CreatePointerCast(ptr,  Type::getInt8PtrTy(ctx));
	auto name_ptr = createGlobalStringPointer(ctx, m, name_str);

	return make_pair(void_ptr, name_ptr);
}


void AliasInstrumentLoops::getBasePtrs(Value *pointerVal, set<Value*>& basePtrs)
{
	set<Value*> visited;

	getBasePtrs(pointerVal, basePtrs, visited);
}

void AliasInstrumentLoops::getBasePtrs(Value *ModRefVal, set<Value*>& basePtrs, set<Value*>& visited)
{
  if (visited.count(ModRefVal))
  	return;
  visited.insert(ModRefVal);

	Instruction *ModRefInstr = dyn_cast<Instruction>(ModRefVal);

	assert(isa<Instruction>(ModRefVal) || isGlobalOrArgument(ModRefVal));

	if(isGlobalOrArgument(ModRefVal) || domTree->dominates(ModRefInstr->getParent(), currLoop->getLoopPreheader()))
	{
    basePtrs.insert(ModRefVal);
    return;
	}

  // TODO: think if we need to check more cases
  switch(ModRefInstr->getOpcode())
  {
    case Instruction::Load:
    case Instruction::Call:
      // we cannot tell about indirections
      basePtrs.insert(nullptr);
      return;
    case Instruction::Store:
      ModRefVal = ((StoreInst *)ModRefInstr)->getPointerOperand();
      break;
    case Instruction::GetElementPtr:
      ModRefVal = ((GetElementPtrInst *)ModRefInstr)->getPointerOperand();
      break;
    case Instruction::VAArg:
      ModRefVal = ((VAArgInst *)ModRefInstr)->getPointerOperand();
     break;
    case Instruction::AtomicCmpXchg:
      ModRefVal = ((AtomicCmpXchgInst *)ModRefInstr)->getPointerOperand();
      break;
    case Instruction::AtomicRMW:
      ModRefVal = ((AtomicRMWInst *)ModRefInstr)->getPointerOperand();
      break;
    case Instruction::PtrToInt:
      ModRefVal = ((PtrToIntInst *)ModRefInstr)->getPointerOperand();
      break;
    case Instruction::BitCast:
      ModRefVal = ((BitCastInst *)ModRefInstr)->getOperand(0);
      break;
    case Instruction::Select:
    case Instruction::PHI:
      for(int i=0; i<ModRefInstr->getNumOperands(); ++i)
      {
        Value *pointerOp = ModRefInstr->getOperand(i);
        // do not track the condition operand of the select instruction
        if(!pointerOp->getType()->isPointerTy()) continue;
        getBasePtrs(pointerOp, basePtrs, visited);
      }
      return;
    default:
      ModRefInstr->print(errs());
      assert(false);
  }

	getBasePtrs(ModRefVal, basePtrs, visited);
}


static valuePair orderedPair(Value *v1, Value *v2) {
	return (v1 < v2) ? valuePair(v1,v2) : valuePair(v2,v1);
}

static bool hasPrefix(const std::string& str, const std::string& prefix) {
	return str.compare(0, prefix.size(), prefix) == 0;
}

static bool isGlobalOrArgument(const Value *v) {
	return isa<GlobalValue>(v) || isa<Argument>(v);
}


static Instruction *nextOf(Instruction *i)
{
  return (Instruction *)++((BasicBlock::iterator)i);
}

static BasicBlock *lastOf(BasicBlock *bb1, BasicBlock *bb2)
{
  assert(bb1->getParent() == bb2->getParent());

  Function::BasicBlockListType &bbs = bb1->getParent()->getBasicBlockList();
  for(Function::iterator B = bbs.begin(), BE = bbs.end(); B != BE; ++B)
  {
    if((BasicBlock *)B == bb1) return bb2;
    if((BasicBlock *)B == bb2) return bb1;
  }
  return nullptr;
}

