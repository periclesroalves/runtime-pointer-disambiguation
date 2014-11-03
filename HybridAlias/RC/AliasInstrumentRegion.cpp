
#include <assert.h>                     // for assert
#include <llvm/Support/Debug.h>         // for DEBUG
#include <stddef.h>                     // for size_t
#include <stdlib.h>                     // for exit
#include <list>                         // for list, list<>::iterator, etc
#include <map>                          // for _Rb_tree_const_iterator, etc
#include <set>                          // for set, set<>::iterator
#include <string>                       // for string
#include <tuple>                        // for tie, tuple
#include <utility>                      // for pair, make_pair
#include <vector>                       // for vector
#include "llvm/ADT/APInt.h"             // for APInt
#include "llvm/ADT/ArrayRef.h"          // for ArrayRef
#include "llvm/ADT/StringRef.h"         // for StringRef
#include "llvm/ADT/Twine.h"             // for operator+, Twine
#include "llvm/ADT/ilist.h"             // for ilist_iterator
#include "llvm/Analysis/AliasAnalysis.h"  // for AliasAnalysis::Location, etc
#include "llvm/Analysis/RegionInfo.h"     // for Region, etc
#include "llvm/Analysis/RegionPass.h"     // for LPPassManager (ptr only), etc
#include "llvm/IR/Attributes.h"         // for Attribute, etc
#include "llvm/IR/BasicBlock.h"         // for BasicBlock, etc
#include "llvm/IR/Constant.h"           // for Constant
#include "llvm/IR/Constants.h"          // for ConstantInt, etc
#include "llvm/IR/DerivedTypes.h"       // for PointerType, FunctionType, etc
#include "llvm/IR/Dominators.h"         // for DominatorTreeWrapperPass, etc
#include "llvm/IR/Function.h"           // for Function, etc
#include "llvm/IR/GlobalValue.h"        // for GlobalValue, etc
#include "llvm/IR/GlobalVariable.h"     // for GlobalVariable
#include "llvm/IR/IRBuilder.h"          // for IRBuilder
#include "llvm/IR/Instruction.def"
#include "llvm/IR/Instruction.h"        // for Instruction
#include "llvm/IR/Instructions.h"       // for AtomicCmpXchgInst, etc
#include "llvm/IR/Module.h"             // for Module
#include "llvm/IR/OperandTraits.h"
#include "llvm/IR/Type.h"               // for Type
#include "llvm/IR/Value.h"              // for Value
#include "llvm/Pass.h"                  // for ModulePass
#include "llvm/PassAnalysisSupport.h"   // for AnalysisUsage, etc
#include "llvm/PassSupport.h"           // for RegisterPass
#include "llvm/Support/Casting.h"       // for isa, dyn_cast
#include "llvm/Support/CommandLine.h"   // for desc, initializer, opt, etc
#include "llvm/Support/raw_ostream.h"   // for errs, raw_ostream
#include "../ilc/FullInstNamer.h"       // for FullInstNamer
#include "../ilc/BasePtrInfo.h"
#include "../ilc/Common.h"

namespace llvm { class Argument; }
namespace llvm { class LLVMContext; }

#define DEBUG_TYPE "alias-instrument-region"

//#define STATS

using namespace llvm;
using namespace std;
using namespace ilc;

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

struct AliasInstrumentRegions : public RegionPass
{
	static char ID;

	AliasInstrumentRegions() : RegionPass(ID) {}

	const char *getPassName() const override { return "AliasInstrumentRegions"; }

	bool runOnRegion(Region *L, RGPassManager &RGM) override;

	void getAnalysisUsage(AnalysisUsage &AU) const override
	{
		// TODO: LLVM doc states that transformation passes should
		//       not be chained with addRequire but with a custom
		//       PassManager
		AU.addRequired<FullInstNamer>();
		AU.addRequired<DeclareTraceFunction>();

		AU.addRequired<DominatorTreeWrapperPass>();
		AU.addRequired<AliasAnalysis>();
	}
private:
	Region              *currRegion;
	list<Region*>        clonedRegions;
	DominatorTree       *domTree;
	map<string, Value*>  global_strings;

	Value* createGlobalStringPointer(LLVMContext& ctx, Module *m, StringRef str);

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

char AliasInstrumentRegions::ID = 0;
static RegisterPass<AliasInstrumentRegions> Y(
	"alias-instrument-regions",
	"Instrument regions for alias profiling"
);

cl::opt<string> InstrumentOnlyPrefix(
	"instrument-only",
	cl::desc("Instrument only regions in a function whose (mangled!) name has the given prefix"),
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

	trace_fn->addAttribute(1, Attribute::NoCapture);
	trace_fn->addAttribute(2, Attribute::NoCapture);
	trace_fn->addAttribute(3, Attribute::NoCapture);
	trace_fn->addAttribute(4, Attribute::NoCapture);
	trace_fn->addAttribute(5, Attribute::NoCapture);

	return true;
}

/// prototypes for helper functions

static bool         isInterestingPointer(Value *v);
static bool         notDefinedIn(const Region *loop, const Value *V);
static bool         hasPrefix(const std::string& str, const std::string& prefix);
static bool         isGlobalOrArgument(const Value *v);
static Instruction* nextOf(Instruction *i);
static BasicBlock*  lastOf(BasicBlock *bb1, BasicBlock *bb2);
static valuePair    orderedPair(Value *v1, Value *v2);


bool AliasInstrumentRegions::runOnRegion(Region *region, RGPassManager &rpm)
{
  //we are interested only in innermost loops
  if(region->getEnteringBlock() && region->getExitingBlock())
  	return false;

  DEBUG(dbgs() << "trace alias\n");

  FullInstNamer        &FIN = getAnalysis<FullInstNamer>();
  DominatorTree        &DT  = getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  AliasAnalysis        &AA  = getAnalysis<AliasAnalysis>();
  DeclareTraceFunction &DTF = getAnalysis<DeclareTraceFunction>();

  DEBUG(dbgs() << "A\n");
  BasePtrInfo basePtrInfo{region, DT, AA};
  DEBUG(dbgs() << "B\n");

  Function *trace_fn = DTF.getTraceFn();

  BasicBlock  *entry    = region->getEntry();
  Function*    function = entry->getParent();
  Module*      module   = function->getParent();
  LLVMContext& ctx      = module->getContext();

  StringRef   functionName = FIN.getNameOrFail(this, function);
  StringRef   headerName   = FIN.getNameOrFail(this, entry);
  string      loopName     = (functionName + "::" + headerName).str();

  DEBUG(dbgs() << "========================================================\n");
  DEBUG(dbgs() << "AliasInstrumentRegions::runOnLoop(" << loopName << ")\n");
  DEBUG(dbgs() << "========================================================\n");

  set<ValuePair> &basePtrPairs = basePtrInfo.getBasePtrPairs();

  for(set<ValuePair>::iterator I = basePtrPairs.begin(), IE = basePtrPairs.end(); I != IE; ++I)
  {
    Value *l = I->first;
    Value *r = I->second;

    DEBUG(dbgs() << "--------------------------------------------------------\n");
    DEBUG(dbgs() << "Tracing pair \n");
    DEBUG(dbgs() << "--------------------------------------------------------\n");
    DEBUG(dbgs() << *l << "\n");
    DEBUG(dbgs() << "--------------------------------------------------------\n");
    DEBUG(dbgs() << *r << "\n");
    DEBUG(dbgs() << "--------------------------------------------------------\n");

    // try to hoist the insertion point
    auto insertBefore = getInsertionPoint(function, l, r);

    IRBuilder<> IRB(insertBefore);

    // cast to Int8PtrTy if needed
    Value *ptr1  = l->getType() == IRB.getInt8PtrTy() ? l : IRB.CreatePointerCast(l, IRB.getInt8PtrTy());
    Value *ptr2  = r->getType() == IRB.getInt8PtrTy() ? r : IRB.CreatePointerCast(r, IRB.getInt8PtrTy());

    Value *loop_name = createGlobalStringPointer(ctx, module, loopName);
    Value *ptr1_name = createGlobalStringPointer(ctx, module, FIN.getNameOrFail(this, l));
    Value *ptr2_name = createGlobalStringPointer(ctx, module, FIN.getNameOrFail(this, r));

    IRB.CreateCall5(trace_fn, loop_name, ptr1_name, ptr1, ptr2_name, ptr2);
  }

  return true;
}


/***
 * Creates a global string constant and returns a pointer to it
 */
Value *AliasInstrumentRegions::createGlobalStringPointer(LLVMContext& ctx, Module *m, StringRef str)
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
