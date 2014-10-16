
#include <llvm/Pass.h>
#include <llvm/ADT/STLExtras.h>
#include <llvm/ADT/SetVector.h>
#include <llvm/ADT/StringExtras.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/LoopPass.h>
#include <llvm/Analysis/AliasAnalysis.h>
#include <llvm/Analysis/DominanceFrontier.h>
#include <llvm/Analysis/ValueTracking.h>
#include <llvm/Analysis/ValueTracking.h>
#include <llvm/Analysis/CaptureTracking.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Dominators.h>
#include <llvm/IR/MDBuilder.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/ValueSymbolTable.h>
#include <llvm/Transforms/Instrumentation.h>
#include "llvm/Support/CommandLine.h"
#include <llvm/Support/Debug.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Support/YAMLParser.h>
#include <llvm/Support/YAMLTraits.h>
#include <llvm/Support/MemoryBuffer.h>
#include <llvm/Transforms/Utils/Cloning.h>
#include <llvm/Analysis/LoopPass.h>
#include <llvm/Analysis/DominanceFrontier.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Dominators.h>
#include <llvm/IR/Instructions.h>
#include <llvm/ADT/DenseMap.h>

#include <cstring>
#include <string>
#include <list>
#include <set>
#include <map>
#include <tuple>

#include <memory>
#include <stdexcept>
#include <cstdint>
#include <cassert>
#include <map>
#include <iostream>
#include <string>
#include <list>
#include <set>
#include <cstring>

#define DEBUG_TYPE "clone-loop"

//#define STATS

using namespace llvm;
using namespace llvm::yaml;
using namespace std;

typedef SetVector<Value *> ValueSet;

// Make sure this matches the name of the getBasePtr function in libmemtrack.a
static const char *const gcg_getBasePtr_name = "gcg_getBasePtr";

namespace {

struct DeclareGetBasePtr : public ModulePass {
	static char ID;

	DeclareGetBasePtr() : ModulePass(ID), getBasePtr_fn(nullptr) {}

	const char *getPassName() const override { return "DeclareGetBasePtr"; }

	bool runOnModule(Module &M) override;

	Function *getGetBasePtrFn() {
		assert(getBasePtr_fn);

		return getBasePtr_fn;
	}
private:
	Function *getBasePtr_fn;
};

struct CloneLoopPass : public LoopPass {
	static char ID;

	CloneLoopPass() : LoopPass(ID) {}

	const char *getPassName() const override { return "CloneLoopPass"; }

	bool runOnLoop(Loop *L, LPPassManager &LPM) override;

	void getAnalysisUsage(AnalysisUsage &AU) const override
	{
		// TODO: LLVM doc states that transformation passes should
		//       not be chained with addRequire but with a custom
		//       PassManager
		AU.addRequired<DeclareGetBasePtr>();

		AU.addRequired<AliasAnalysis>();
		AU.addRequired<DominatorTreeWrapperPass>();
		AU.addRequired<DominanceFrontier>();
		AU.addRequired<LoopInfo>();
	}

	Function *getGetBasePtrFn() {
		assert(getBasePtr_fn);

		return getBasePtr_fn;
	}
private:
	Loop*        cloneLoop(llvm::Loop *OrigL, LPPassManager& LPM);
	void         addAliasScopeMetadata(LLVMContext& ctx, string loop_name, Loop *loop, set<Value*> inputs);
	Instruction* getOrInsertMagic(Value *basePtr);

	Function*   getBasePtr_fn;
	Loop*       currLoop;
	set<Loop*>  cloned_loops;
	map<Value*, Instruction*> basePtr2magic;
};

} // end anonymous namespace

char DeclareGetBasePtr::ID = 0;
static RegisterPass<DeclareGetBasePtr> X(
	"declare-getBasePtr",
	"Declare external refernce to getBasePtr function"
);

char CloneLoopPass::ID = 0;
static RegisterPass<CloneLoopPass> Y(
	"clone-loop",
	"Speculatively clone loop and insert aliasing guards"
);

cl::opt<string> CloneOnlyPrefix(
	"clone-only",
	cl::desc("Clone only loops in a function whose (mangled!) name has the given prefix"),
	cl::init("")
);

cl::opt<string> TraceFile(
	"trace-file",
	cl::desc("The name of the file to read alias profiling data from"),
	cl::init("alias.yaml")
);

bool DeclareGetBasePtr::runOnModule(Module &M) {
	DEBUG(dbgs() << "DeclareGetBasePtr::runOnModule\n");

	// ** declare getBasePtr function

	LLVMContext& ctx = M.getContext();

	Type *void_ptr_type = Type::getInt8PtrTy(ctx);

	Type *return_type = void_ptr_type;

	std::vector<Type*> parameter_types{
		void_ptr_type
	};

	getBasePtr_fn = Function::Create(
		FunctionType::get(return_type, parameter_types, false),
		GlobalValue::ExternalLinkage,
		gcg_getBasePtr_name,
		&M
	);

	getBasePtr_fn->addAttribute(1, Attribute::ReadOnly);

	return true;
}

/// prototypes for helper functions

static bool                            hasPrefix(const std::string& str, const std::string& prefix);
static bool                            isGlobalOrArgument(const Value *v);
static pair<Instruction*,Instruction*> orderedPair(Instruction* v1, Instruction* v2);
static Instruction*                    nextOf(Instruction *i);
static BasicBlock*                     lastOf(BasicBlock *bb1, BasicBlock *bb2);

struct ModuleTrace;
struct FunctionTrace;
struct LoopTrace;

struct AliasTrace {
	string ptr1;
	string ptr2;
	size_t alias_count;
	size_t noalias_count;

	size_t total_count() const {
		return alias_count + noalias_count;
	}

	double noalias_probability() const {
		return ((double) noalias_count) / ((double) total_count());
	}

	bool operator==(const AliasTrace& that) const {
		return (ptr1 == that.ptr1) && (ptr2 == that.ptr2);
	}
};
struct LoopTrace {
	string             name;
	vector<AliasTrace> alias_pairs;
};

namespace std {
	template <>
	struct hash<AliasTrace> {
		std::size_t operator()(const AliasTrace& at) const {
			size_t hash = 0;

			hash_combine(hash, at.ptr1);
			hash_combine(hash, at.ptr2);

			return hash;
		}

		// from boost,
		// only god & bjarne know why this isn't in std
		template <class T>
		static void hash_combine(std::size_t& seed, const T& v) {
			std::hash<T> hasher;
			seed ^= hasher(v) + 0x9e3779b9 + (seed<<6) + (seed>>2);
		}
	};
} // end namespace std

template<typename T>
struct SequenceTraits<std::vector<T>> {
	static size_t size(IO& io, std::vector<T>& seq) {
		return seq.size();
	}
	static T& element(IO& io, std::vector<T>& seq, size_t index) {
		if (index >= seq.size())
			seq.resize(index+1);
		return seq[index];
	}
};

template <>
struct MappingTraits<LoopTrace> {
	static void mapping(IO &io, LoopTrace &lt) {
		io.mapRequired("loop",        lt.name);
		io.mapRequired("alias_pairs", lt.alias_pairs);
	}
};

template <>
struct MappingTraits<AliasTrace> {
  static void mapping(IO &io, AliasTrace &at) {
    io.mapRequired("ptr1",    at.ptr1);
    io.mapRequired("ptr2",    at.ptr2);
    io.mapRequired("alias",   at.alias_count);
    io.mapRequired("noalias", at.noalias_count);
  }
};

struct AliasInfo {
	AliasInfo() {
		// ** read YAML trace data

		auto yaml_file = MemoryBuffer::getFile(TraceFile);

		if (!yaml_file) {
			auto error = yaml_file.getError();

			errs() << "Could not open alias trace '" << TraceFile << "': " << error.message() << "\n";
			exit(1);
		}

		yaml::Input yaml_input{yaml_file.get()->getBuffer()};

		vector<LoopTrace> trace;

		yaml_input >> trace;

		if (auto error = yaml_input.error()) {
			errs() << "Could not parse alias trace '" << TraceFile << "': " << error.message() << "\n";
			exit(1);
		}

		for (auto& loop : trace) {
			assert(loops.count(loop.name) == 0);

			loops.emplace(std::move(loop.name), std::move(loop.alias_pairs));
		}
	}

	const vector<AliasTrace> *getAliasTrace(StringRef loop_name) {
		auto it = loops.find(loop_name);

		if (it != loops.end())
			return &(it->second);
		else
			return nullptr;
	}
private:
	map<string, vector<AliasTrace>> loops;
};

bool CloneLoopPass::runOnLoop(Loop *loop, LPPassManager &LPM)
{
	// we are interested only in cloneable, non-empty, innermost loops
	if (!loop->isSafeToClone() || (loop->getNumBlocks() == 0) || (loop->getSubLoops().size() > 0))
		return false;

	// don't clone twice
	if (cloned_loops.count(loop))
		return false;

	// ** get fully qualified name of loop

	// XXX: is it legal to read-only access containing fn and module?
	// XXX: fingers crossed, do BBs have unique names?

	BasicBlock *header = loop->getHeader();
	Function   *fn     = header->getParent();
	Module     *module = fn->getParent();

	currLoop = loop;

	assert((!header->getName().empty()) && "You must run the `instnamer' pass before using alias-tracer");

	StringRef fn_name = fn->getName();

	if (CloneOnlyPrefix.size() && !hasPrefix(fn_name, CloneOnlyPrefix))
		return false;

	std::string loop_name = (fn_name + "::" + header->getName()).str();

	DEBUG(dbgs() << "========================================================\n");
	DEBUG(dbgs() << "CloneLoopPass::runOnLoop(" << loop_name << ")\n");

	// ** read YAML trace data

	// TODO: hoist parsing into module pass and just use getAnalysis here.

	AliasInfo ai;

	const vector<AliasTrace>* alias_trace = ai.getAliasTrace(loop_name);

	if (!alias_trace)
		return false;

	DEBUG(dbgs() << " " << alias_trace->size() << " alias pairs" << "\n");
	for (auto& alias_pair : *alias_trace) {
		DEBUG(dbgs() << "\t" << alias_pair.ptr1 << " vs " << alias_pair.ptr2 << "\n");
	}

	DEBUG(dbgs() << "========================================================\n");

	if(alias_trace->empty())
		return false;

	// ** find worthwile candidates for instrumentation

	std::vector<AliasTrace> probable_noaliases;

	std::copy_if(alias_trace->begin(), alias_trace->end(), std::back_inserter(probable_noaliases),
		[](const AliasTrace& at) {
			return at.noalias_probability() > .9;
		}
	);

	DEBUG(dbgs() << "found " << probable_noaliases.size() << " probable no-alias-pairs\n");

	if (probable_noaliases.empty())
		return false;

	// ** add instrumentation code

	LLVMContext& ctx = module->getContext();

	set<pair<Instruction*, Instruction*>> alias_pairs;
	set<Value*>                           all_aliases;

	BasicBlock *preheader = loop->getLoopPreheader();
	BasicBlock *entry     = &fn->getEntryBlock();

	DeclareGetBasePtr& dgbp = getAnalysis<DeclareGetBasePtr>();

	this->getBasePtr_fn = dgbp.getGetBasePtrFn();

	auto& symbol_table = fn->getValueSymbolTable();

	for (auto& alias_pair : probable_noaliases) {
		Value *val1 = symbol_table.lookup(alias_pair.ptr1);
		Value *val2 = symbol_table.lookup(alias_pair.ptr2);

		assert(val1);
		assert(val2);

		auto val1_base = getOrInsertMagic(val1);
		auto val2_base = getOrInsertMagic(val2);

		alias_pairs.insert(orderedPair(val1_base, val2_base));

//		all_aliases.insert(val1);
//		all_aliases.insert(val2);
	}

	DEBUG(dbgs() << "inserted magic\n");

	Loop *cloned_loop = cloneLoop(loop, LPM);

	addAliasScopeMetadata(ctx, loop_name, loop, all_aliases);

	cloned_loops.insert(cloned_loop);

	// ** decide which loop to go into

	assert(preheader && "Loop was not of simple form");
	assert(!preheader->empty());

	IRBuilder<> irb{preheader, --preheader->end()};

	vector<Instruction*> conditionals;

	// compare the magic numbers for each pair
	// "and" the list of conditionals on loop preheader

	for (auto aliases : alias_pairs) {
		auto l = aliases.first;
		auto r = aliases.second;

		DEBUG(dbgs() << "inserted alias pair trace\n");

		// TODO: hoist to least dominator

		// add the cmp just before the last instruction of the bb (maybe it is a branch, adding after it would break the control flow)
		IRBuilder<> IRB_ICmpNE((Instruction *)&(lastOf(l->getParent(), r->getParent())->back()));

    	Instruction *cmp = cast<Instruction>(IRB_ICmpNE.CreateICmpNE(l, r));

		conditionals.push_back(cmp);
	}

	assert(!conditionals.empty());

	while (conditionals.size() > 1) {
		Instruction *a = conditionals.back();
		conditionals.pop_back();

		Instruction *b = conditionals.back();
		conditionals.pop_back();

		// add the add just before the last instruction of the bb (maybe it is a branch, adding after it would break the control flow)
		IRBuilder<> IRB_And((Instruction *)&(lastOf(a->getParent(), b->getParent())->back()));

		auto cond = cast<Instruction>(IRB_And.CreateAnd(a, b));

		conditionals.push_back(cond);
	}

	assert(conditionals.size() == 1);
	assert(cloned_loop->getHeader());
	assert(loop->getHeader());

//	Value *specluated_conditional = irb.

	irb.CreateCondBr(
		conditionals.front(),
		cloned_loop->getHeader(), // true path
		loop->getHeader()         // false path
	);
	// remove original branch
	loop->getLoopPreheader()->back().eraseFromParent();

	return true;
}

/// CloneDominatorInfo - Clone basicblock's dominator tree and, if available,
/// dominance info. It is expected that basic block is already cloned.
static void CloneDominatorInfo(BasicBlock *BB,
                               ValueMap<const Value*, WeakVH> &VMap,
                               //DenseMap<const Value *, Value *> &VMap,
                               DominatorTree *DT,
                               DominanceFrontier *DF) {
  assert (DT && "DominatorTree is not available");
  //DenseMap<const Value *, Value*>
  ValueMap<const Value*, WeakVH>::iterator BI = VMap.find(BB);
  assert (BI != VMap.end() && "BasicBlock clone is missing");
  BasicBlock *NewBB = cast<BasicBlock>(BI->second);

  // NewBB already got dominator info.
  if (DT->getNode(NewBB))
    return;

  assert (DT->getNode(BB) && "BasicBlock does not have dominator info");
  // Entry block is not expected here. Infinite loops are not to cloned.
  assert (DT->getNode(BB)->getIDom() && "BasicBlock does not have immediate dominator");
  BasicBlock *BBDom = DT->getNode(BB)->getIDom()->getBlock();

  // NewBB's dominator is either BB's dominator or BB's dominator's clone.
  BasicBlock *NewBBDom = BBDom;
  //DenseMap<const Value *, Value*>
  ValueMap<const Value*, WeakVH>::iterator BBDomI = VMap.find(BBDom);
  if (BBDomI != VMap.end()) {
    NewBBDom = cast<BasicBlock>(BBDomI->second);
    if (!DT->getNode(NewBBDom))
      CloneDominatorInfo(BBDom, VMap, DT, DF);
  }
  DT->addNewBlock(NewBB, NewBBDom);

  // Copy cloned dominance frontiner set
  if (DF) {
    DominanceFrontier::DomSetType NewDFSet;
    DominanceFrontier::iterator DFI = DF->find(BB);
    if ( DFI != DF->end()) {
      DominanceFrontier::DomSetType S = DFI->second;
        for (DominanceFrontier::DomSetType::iterator I = S.begin(), E = S.end();
             I != E; ++I) {
          BasicBlock *DB = *I;
          //DenseMap<const Value*, Value*>
          ValueMap<const Value*, WeakVH>::iterator IDM = VMap.find(DB);
          if (IDM != VMap.end())
            NewDFSet.insert(cast<BasicBlock>(IDM->second));
          else
            NewDFSet.insert(DB);
        }
    }
    DF->addBasicBlock(NewBB, NewDFSet);
  }
}

/// CloneLoop - Clone Loop. Clone dominator info. Populate VMap
/// using old blocks to new blocks mapping.
Loop *CloneLoopPass::cloneLoop(Loop *OrigL, LPPassManager& LPM)
{
  ValueMap<const Value*, WeakVH> VMap;

  LoopInfo&          LI = getAnalysis<LoopInfo>();
  DominatorTree&     DT = getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  DominanceFrontier& DF = getAnalysis<DominanceFrontier>();

  SmallVector<BasicBlock *, 16> NewBlocks;

  // Populate loop nest.
  SmallVector<Loop *, 8> LoopNest;
  LoopNest.push_back(OrigL);


  Loop *NewParentLoop = NULL;
  while (!LoopNest.empty()) {
    Loop *L = LoopNest.back();
    LoopNest.pop_back();
    Loop *NewLoop = new Loop();

    if (!NewParentLoop)
      NewParentLoop = NewLoop;

    LPM.insertLoop(NewLoop, L->getParentLoop());

    // Clone Basic Blocks.
    for (BasicBlock *BB : L->getBlocks())
    {
      BasicBlock *NewBB = CloneBasicBlock(BB, VMap, ".clone");
      VMap[BB] = NewBB;
      LPM.cloneBasicBlockSimpleAnalysis(BB, NewBB, L);
      NewLoop->addBasicBlockToLoop(NewBB, LI.getBase());
      NewBlocks.push_back(NewBB);
    }

    // Clone dominator info.
//    if (DT)
//      for (Loop::block_iterator I = L->block_begin(), E = L->block_end(); I != E; ++I) {
//        BasicBlock *BB = *I;
//        CloneDominatorInfo(BB, VMap, DT, DF);
//      }

    // Process sub loops
    for (Loop::iterator I = L->begin(), E = L->end(); I != E; ++I)
      LoopNest.push_back(*I);
  }

  // Remap instructions to reference operands from VMap.
  for(SmallVector<BasicBlock *, 16>::iterator NBItr = NewBlocks.begin(),
        NBE = NewBlocks.end();  NBItr != NBE; ++NBItr) {
    BasicBlock *NB = *NBItr;
    for(BasicBlock::iterator BI = NB->begin(), BE = NB->end();
        BI != BE; ++BI) {
      Instruction *Insn = BI;
      for (unsigned index = 0, num_ops = Insn->getNumOperands(); index != num_ops; ++index)
      {
        Value *Op = Insn->getOperand(index);
        //DenseMap<const Value *, Value *>
        ValueMap<const Value*, WeakVH>::iterator OpItr = VMap.find(Op);
        if (OpItr != VMap.end()) Insn->setOperand(index, OpItr->second);

        // Fix phi-functions
        if(Insn->getOpcode() == Instruction::PHI)
        {
          PHINode *phiNode = (PHINode *)Insn;
          ValueMap<const Value*, WeakVH>::iterator I = VMap.find(phiNode->getIncomingBlock(index));
          if(I != VMap.end()) phiNode->setIncomingBlock(index, cast<BasicBlock>(I->second));
        }
      }
    }
  }

  BasicBlock *Latch = OrigL->getLoopLatch();
  Function *F = Latch->getParent();
  F->getBasicBlockList().insert(OrigL->getHeader(),
                                NewBlocks.begin(), NewBlocks.end());

  return NewParentLoop;
}


/// Add new alias scopes for each loop input we speculate to have no alias,
/// tag the mapped noalias parameters with noalias metadata specifying the new scope,
/// and tag all non-derived loads, stores and memory intrinsics with the new alias scopes.
void CloneLoopPass::addAliasScopeMetadata(LLVMContext& ctx, string loop_name, Loop *loop, set<Value*> inputs) {
	AliasAnalysis&    AA = getAnalysis<AliasAnalysis>();
	const DataLayout* DL = AA.getDataLayout();
	DominatorTree&    DT = getAnalysis<DominatorTreeWrapperPass>().getDomTree();

	DEBUG(dbgs() << "building NoAliasArgs\n");

	SmallVector<Value *, 4> NoAliasArgs;


	for (auto I : inputs) {
		if (!I->hasNUses(0))
			NoAliasArgs.push_back(I);
	}

	if (NoAliasArgs.empty())
		return;

	DEBUG(dbgs() << "building NoAliasArgs.size() == " << NoAliasArgs.size() << "\n");

	// To do a good job, if a noalias variable is captured, we need to know if
	// the capture point dominates the particular use we're considering.
//	DominatorTree DT;
//	DT.recalculate(const_cast<Function&>(*CalledFunc));

	// noalias indicates that pointer values based on the argument do not alias
	// pointer values which are not based on it. So we add a new "scope" for each
	// noalias function argument. Accesses using pointers based on that argument
	// become part of that alias scope, accesses using pointers not based on that
	// argument are tagged as noalias with that scope.

	DenseMap<const Value *, MDNode *> NewScopes;
	MDBuilder MDB(ctx);

	// Create a new scope domain for this function.
	MDNode *NewDomain = MDB.createAnonymousAliasScopeDomain(loop_name);

	for (unsigned i = 0, e = NoAliasArgs.size(); i != e; ++i) {
		const Value *A = NoAliasArgs[i];

		std::string Name = loop_name;
		if (A->hasName()) {
			Name += ": %";
			Name += A->getName();
		} else {
			Name += ": argument ";
			Name += utostr(i);
		}

		// Note: We always create a new anonymous root here. This is true regardless
		// of the linkage of the callee because the aliasing "scope" is not just a
		// property of the callee, but also all control dependencies in the caller.
		MDNode *NewScope = MDB.createAnonymousAliasScope(NewDomain, Name);
		NewScopes.insert(std::make_pair(A, NewScope));
	}

	DEBUG(dbgs() << "Created " << NewScopes.size() << " new alias scopes\n");

	DenseMap<const Instruction*, MDNode*> NewMD;

	auto handler = [&](Value *v) {
		if (Instruction *I = dyn_cast<Instruction>(v)) {
			bool IsArgMemOnlyCall = false, IsFuncCall = false;
			SmallVector<const Value *, 2> PtrArgs;

			if (const LoadInst *LI = dyn_cast<LoadInst>(I))
				PtrArgs.push_back(LI->getPointerOperand());
			else if (const StoreInst *SI = dyn_cast<StoreInst>(I))
				PtrArgs.push_back(SI->getPointerOperand());
			else if (const VAArgInst *VAAI = dyn_cast<VAArgInst>(I))
				PtrArgs.push_back(VAAI->getPointerOperand());
			else if (const AtomicCmpXchgInst *CXI = dyn_cast<AtomicCmpXchgInst>(I))
				PtrArgs.push_back(CXI->getPointerOperand());
			else if (const AtomicRMWInst *RMWI = dyn_cast<AtomicRMWInst>(I))
				PtrArgs.push_back(RMWI->getPointerOperand());
			else if (ImmutableCallSite ICS = ImmutableCallSite(I)) {
				// If we know that the call does not access memory, then we'll still
				// know that about the inlined clone of this call site, and we don't
				// need to add metadata.
				if (ICS.doesNotAccessMemory())
					return;

				IsFuncCall = true;
				AliasAnalysis::ModRefBehavior MRB = AA.getModRefBehavior(ICS);

				if (MRB == AliasAnalysis::OnlyAccessesArgumentPointees
				    || MRB == AliasAnalysis::OnlyReadsArgumentPointees)
					IsArgMemOnlyCall = true;

				for (auto AI = ICS.arg_begin(), AE = ICS.arg_end(); AI != AE; ++AI) {
					// We need to check the underlying objects of all arguments, not just
					// the pointer arguments, because we might be passing pointers as
					// integers, etc.
					// However, if we know that the call only accesses pointer arguments,
					// then we only need to check the pointer arguments.
					if (IsArgMemOnlyCall && !(*AI)->getType()->isPointerTy())
						continue;

					PtrArgs.push_back(*AI);
				}
			}

			// If we found no pointers, then this instruction is not suitable for
			// pairing with an instruction to receive aliasing metadata.
			// However, if this is a call, this we might just alias with none of the
			// noalias arguments.
			if (PtrArgs.empty() && !IsFuncCall)
				return;

			// It is possible that there is only one underlying object, but you
			// need to go through several PHIs to see it, and thus could be
			// repeated in the Objects list.
			SmallPtrSet<Value *, 4> ObjSet;
			SmallVector<Value *, 4> Scopes, NoAliases;

			for (unsigned i = 0, ie = PtrArgs.size(); i != ie; ++i) {
				SmallVector<Value *, 4> Objects;
				GetUnderlyingObjects(const_cast<Value*>(PtrArgs[i]), Objects, DL, /* MaxLookup = */ 0);

				for (Value *O : Objects)
					ObjSet.insert(O);
			}

			// Figure out if we're derived from anything that is not a noalias
			// argument.
			bool CanDeriveViaCapture = false, UsesAliasingPtr = false;
			for (Value *V : ObjSet) {
				// Is this value a constant that cannot be derived from any pointer
				// value (we need to exclude constant expressions, for example, that
				// are formed from arithmetic on global symbols).
				bool IsNonPtrConst = isa<ConstantInt>(V)         ||
				                     isa<ConstantFP>(V)          ||
				                     isa<ConstantPointerNull>(V) ||
				                     isa<ConstantDataVector>(V)  ||
				                     isa<UndefValue>(V);

				if (IsNonPtrConst)
					continue;

				// If this is anything other than a noalias argument, then we cannot
				// completely describe the aliasing properties using alias.scope
				// metadata (and, thus, won't add any).
//				if (const Argument *A = dyn_cast<Argument>(V)) {
//					if (!A->hasNoAliasAttr())
//						UsesAliasingPtr = true;
				// if it's in the set of loop inputs we assume noalias
				if (inputs.count(V)) {
				} else {
					UsesAliasingPtr = true;
				}

				// If this is not some identified function-local object (which cannot
				// directly alias a noalias argument), or some other argument (which,
				// by definition, also cannot alias a noalias argument), then we could
				// alias a noalias argument that has been captured).
				if (!isa<Argument>(V) &&
						!isIdentifiedFunctionLocal(const_cast<Value*>(V)))
					CanDeriveViaCapture = true;
			}

			// A function call can always get captured noalias pointers (via other
			// parameters, globals, etc.).
			if (IsFuncCall && !IsArgMemOnlyCall)
				CanDeriveViaCapture = true;

			// First, we want to figure out all of the sets with which we definitely
			// don't alias. Iterate over all noalias set, and add those for which:
			//   1. The noalias argument is not in the set of objects from which we
			//      definitely derive.
			//   2. The noalias argument has not yet been captured.
			// An arbitrary function that might load pointers could see captured
			// noalias arguments via other noalias arguments or globals, and so we
			// must always check for prior capture.
			for (Value *A : NoAliasArgs) {
				if (!ObjSet.count(A) && (!CanDeriveViaCapture ||
				                         // It might be tempting to skip the
				                         // PointerMayBeCapturedBefore check if
				                         // A->hasNoCaptureAttr() is true, but this is
				                         // incorrect because nocapture only guarantees
				                         // that no copies outlive the function, not
				                         // that the value cannot be locally captured.
				                         !PointerMayBeCapturedBefore(A,
				                                /* ReturnCaptures */ false,
				                                 /* StoreCaptures */ false, I, &DT)))
					NoAliases.push_back(NewScopes[A]);
			}

			if (!NoAliases.empty()) {
				I->setMetadata(LLVMContext::MD_noalias, MDNode::concatenate(
					I->getMetadata(LLVMContext::MD_noalias),
						MDNode::get(ctx, NoAliases)));

				DEBUG(dbgs() << "BAM! NoAliases " << *I << "\n");
			}

			// Next, we want to figure out all of the sets to which we might belong.
			// We might belong to a set if the noalias argument is in the set of
			// underlying objects. If there is some non-noalias argument in our list
			// of underlying objects, then we cannot add a scope because the fact
			// that some access does not alias with any set of our noalias arguments
			// cannot itself guarantee that it does not alias with this access
			// (because there is some pointer of unknown origin involved and the
			// other access might also depend on this pointer). We also cannot add
			// scopes to arbitrary functions unless we know they don't access any
			// non-parameter pointer-values.
			bool CanAddScopes = !UsesAliasingPtr;
			if (CanAddScopes && IsFuncCall)
				CanAddScopes = IsArgMemOnlyCall;

			if (CanAddScopes)
				for (Value *A : NoAliasArgs) {
					if (ObjSet.count(A))
						Scopes.push_back(NewScopes[A]);
				}

			if (!Scopes.empty()) {
				I->setMetadata(LLVMContext::MD_alias_scope, MDNode::concatenate(
					I->getMetadata(LLVMContext::MD_alias_scope),
						MDNode::get(ctx, Scopes)));

				DEBUG(dbgs() << "BAM! Scopes " << *I << "\n");
			}
		}
	};

	// Iterate over all instructions in the loop; for all memory-access
	// instructions, add the alias scope metadata.
	for (auto bb : loop->getBlocks()) {
		for (BasicBlock::iterator it = bb->begin(), end = bb->end(); it != end; ++it) {
			Instruction *inst = it;

			handler(inst);
		}
	}

	// also add alias scope metadata to the loops `inputs'
	for (auto input : inputs) {
		handler(input);
	}
}

Instruction *CloneLoopPass::getOrInsertMagic(Value *basePtr)
{
  // look up in map
  auto I = basePtr2magic.find(basePtr);

  if(I != basePtr2magic.end()) return I->second;
    Instruction *firstInsertPt = ((BasicBlock *)currLoop->getHeader()->getParent()->begin())->getFirstInsertionPt();
    Instruction *insertBefore  = isGlobalOrArgument(basePtr) ? firstInsertPt : nextOf((Instruction *)basePtr);

  IRBuilder<> IRB(insertBefore);

  auto operand  = basePtr->getType() == IRB.getInt8PtrTy() ? basePtr : IRB.CreatePointerCast(basePtr, IRB.getInt8PtrTy());
  auto magicNum = IRB.CreateCall(getGetBasePtrFn(), operand);

  // update map
  basePtr2magic[basePtr] = magicNum;

  return magicNum;
}

static bool hasPrefix(const std::string& str, const std::string& prefix)
{
	return str.compare(0, prefix.size(), prefix) == 0;
}

static bool isGlobalOrArgument(const Value *v)

{
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
  assert(false);
  return nullptr;
}

static pair<Instruction*,Instruction*> orderedPair(Instruction* v1, Instruction* v2)
{
	return (v1 < v2 ? make_pair(v1,v2) : make_pair(v2,v1));
}
