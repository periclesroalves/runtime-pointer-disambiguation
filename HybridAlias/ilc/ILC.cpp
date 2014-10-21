
#include "ilc/BasePtrInfo.hpp"

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
private:
	Loop*     cloneLoop(llvm::Loop *OrigL, LPPassManager& LPM);
	void      addAliasScopeMetadata(LLVMContext& ctx, string loop_name, Loop *loop, BasePtrInfo& info);
	StringRef getNameOrFail(const Value* v);

	set<Loop*> cloned_loops;
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
static Instruction*                    nextOf(Instruction *i);
static Value*                          lookupValue(Function *fn, StringRef name);
static BasicBlock*                     lastOf(BasicBlock *bb1, BasicBlock *bb2);

template<typename T>
static pair<T*, T*> orderedPair(T* a, T* b);

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

/// Helper class for looking up values in a functions symbol table.
/// Provides error messages for missing values.
struct SymbolTableWrapper
{
	SymbolTableWrapper(Function *fn, StringRef region_name)
	: function_name{fn->getName()}
	, region_name{region_name}
	, table{fn->getValueSymbolTable()}
	{}

	Value* lookup(StringRef name)
	{
		Value* val = table.lookup(name);

		if (!val)
		{
			errs() << "Could not find value '" << name << "' in function '" << function_name << "'\n";
			exit(1);
		}

		return val;
	}
private:
	SymbolTableWrapper(const SymbolTableWrapper&) = delete;
	SymbolTableWrapper(SymbolTableWrapper&&)      = delete;

	StringRef         function_name;
	StringRef         region_name;
	ValueSymbolTable& table;
};

/// Helper for creating and caching calls to `magic' function
struct MagicBuilder {
	MagicBuilder(BasicBlock *function_entry, Function *getBasePtr_fn)
		: function_entry{function_entry}
		, getBasePtr_fn{getBasePtr_fn}
	{}

	Instruction *create(Value *basePtr)
	{
	  // look up in map
	  auto I = basePtr2magic.find(basePtr);

	  if(I != basePtr2magic.end())
	  	return I->second;

		Instruction *firstInsertPt = (function_entry)->getFirstInsertionPt();
		Instruction *insertBefore  = isGlobalOrArgument(basePtr) ? firstInsertPt : nextOf((Instruction *)basePtr);

		IRBuilder<> IRB(insertBefore);

		auto operand  = basePtr->getType() == IRB.getInt8PtrTy() ? basePtr : IRB.CreatePointerCast(basePtr, IRB.getInt8PtrTy());
		auto magicNum = IRB.CreateCall(getBasePtr_fn, operand);

		// update map
		basePtr2magic[basePtr] = magicNum;

		return magicNum;
	}
private:
	BasicBlock *function_entry;
	Function *getBasePtr_fn;
	ValueMap<Value*, Instruction*> basePtr2magic;
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

	StringRef fn_name = getNameOrFail(fn);

	if (CloneOnlyPrefix.size() && !hasPrefix(fn_name, CloneOnlyPrefix))
		return false;

	std::string loop_name = (fn_name + "::" + getNameOrFail(header)).str();

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

	// ** find pairs of bases that are likely to alias (used for filtering)

	SymbolTableWrapper symbol_table{fn, loop_name};
	set<BasePtrPair> probable_aliases;

	unsigned probable_noaliases_count = 0;

	for (auto& at : *alias_trace)
	{
		if (at.noalias_probability() > .9)
		{
			probable_noaliases_count++;
			continue;
		}

		Value* ptr1 = symbol_table.lookup(at.ptr1);
		Value* ptr2 = symbol_table.lookup(at.ptr2);

		probable_aliases.insert(orderedPair(ptr1, ptr2));
	}

	DEBUG(dbgs() << "found " << probable_noaliases_count << " probable noalias pairs\n");
	DEBUG(dbgs() << "found " << probable_aliases.size()  << " probable alias   pairs\n");

	if (probable_noaliases_count == 0)
		return false;

	// ** compute base pointers

	AliasAnalysis&     aa      = getAnalysis<AliasAnalysis>();
	DominatorTree&     domTree = getAnalysis<DominatorTreeWrapperPass>().getDomTree();

	DEBUG(dbgs() << "recomputing base ptrs\n");

	BasePtrInfo info = BasePtrInfo::compute(loop, domTree, aa);

	DEBUG(dbgs() << "filtering base ptr pairs with profile information\n");

	info.filter(probable_aliases);

	if (info.getBasePtrPairs().empty())
		return false;

	DEBUG(dbgs() << "cloning loop\n");

	// ** add instrumentation code

	LLVMContext& ctx = module->getContext();

	BasicBlock *preheader = loop->getLoopPreheader();
	BasicBlock *entry     = &fn->getEntryBlock();

	DeclareGetBasePtr& dgbp = getAnalysis<DeclareGetBasePtr>();

	MagicBuilder magic{entry, dgbp.getGetBasePtrFn()};

	Loop *cloned_loop = cloneLoop(loop, LPM);
	cloned_loops.insert(cloned_loop);

	// ** decide which loop to go into

	DEBUG(dbgs() << "creating runtime checks\n");

	assert(preheader && "Loop was not of simple form");
	assert(!preheader->empty());

	assert(cloned_loop->getHeader());
	assert(loop->getHeader());

	vector<Instruction*> conditionals;

	// compare the magic numbers for each pair
	// "and" the list of conditionals on loop preheader

	for (auto aliases : info.getBasePtrPairs()) {
		auto l = magic.create(aliases.first);
		auto r = magic.create(aliases.second);

		// TODO: hoist to least dominator

		// add the cmp just before the last instruction of the bb (maybe it is a branch, adding after it would break the control flow)
		IRBuilder<> IRB_ICmpNE(cast<Instruction>(&(lastOf(l->getParent(), r->getParent())->back())));

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

	// TODO: either add llvm.speculate or branch weights to tell LLVM
	//       to prefer the loop with noalias metadata

	IRBuilder<> irb{preheader, --preheader->end()};

	irb.CreateCondBr(
		conditionals.front(),
		cloned_loop->getHeader(), // true path
		// loop->getHeader(),        // debug
		loop->getHeader()         // false path
	);
	// remove original branch
	preheader->back().eraseFromParent();

	// ** Insert noalias metadata

	DEBUG(dbgs() << "Inserting no-alias metadata\n");

	addAliasScopeMetadata(ctx, loop_name, loop, info);

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


/// Add new alias scopes for each pair of loop inputs we speculate to have no alias,
/// tag the mapped noalias parameters with noalias metadata specifying the new scope,
/// and tag all non-derived loads, stores and memory intrinsics with the new alias scopes.
void CloneLoopPass::addAliasScopeMetadata(LLVMContext& ctx, string loop_name, Loop *loop, BasePtrInfo& info) {
	MDBuilder builder{ctx};

	MDNode *domain = builder.createAnonymousAliasScopeDomain(loop_name + ".domain");
	ValueMap<Value*, MDNode*> newScopes;

	for (auto basePtr : info.getAllBasePtrs())
	{
		newScopes[basePtr] = builder.createAnonymousAliasScope(domain, getNameOrFail(basePtr));
	}

	// for (pair<Instruction*, set<Value*>>& mapping : info)
	for (auto& mapping : info)
	{
		Instruction* memInstr = mapping.first;
		set<Value*>& basePtrs = mapping.second;

		// add alias.scope metadata for each base ptr of mem instr
		SmallVector<Value*, 4> scopes;

		for (auto basePtr : basePtrs)
		{
			assert(newScopes.count(basePtr));

			scopes.push_back(newScopes[basePtr]);
		}

		memInstr->setMetadata(
			LLVMContext::MD_alias_scope,
			MDNode::concatenate(
				memInstr->getMetadata(LLVMContext::MD_alias_scope),
				MDNode::get(ctx, scopes)
			)
		);

		// add noalias metadata for each base ptr that is not a base of mem instr
		SmallVector<Value*, 4> noAliases;

		for (auto basePtr : info.getAllBasePtrs())
		{
			if (basePtrs.count(basePtr) == 0)
				noAliases.push_back(newScopes[basePtr]);
		}

		memInstr->setMetadata(
			LLVMContext::MD_noalias,
			MDNode::concatenate(
				memInstr->getMetadata(LLVMContext::MD_noalias),
				MDNode::get(ctx, noAliases)
			)
		);

		DEBUG(dbgs() << *memInstr << "\n");
		DEBUG(dbgs() << "\t" << *(memInstr->getMetadata(LLVMContext::MD_alias_scope)) << "");
		DEBUG(dbgs() << "\t" << *(memInstr->getMetadata(LLVMContext::MD_noalias))     << "");
	}
}

StringRef CloneLoopPass::getNameOrFail(const Value* v) {
	StringRef name = v->getName();

	if (name.empty()) {
		errs() << "You must run the `instnamer' pass before using " << getPassName() << "\n";
		exit(1);
	}

	return name;
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

template<typename T>
static pair<T*, T*> orderedPair(T* a, T* b)
{
	return (a < b ? make_pair(a, b) : make_pair(b, a));
}
