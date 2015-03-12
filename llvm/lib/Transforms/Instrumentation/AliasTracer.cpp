/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include "llvm/Pass.h"
#include "llvm/ADT/StringMap.h"
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
#include "llvm/IR/TypeBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/ValueMap.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/CommandLine.h"
#include <llvm/Support/Debug.h>
#include <llvm/Transforms/Utils/FullInstNamer.h>
#include <llvm/Transforms/Instrumentation.h>
#include <llvm/InitializePasses.h>

#include <llvm/Support/CorseCommon.h>
#include <llvm/Analysis/BasePointers.h>

#include <string.h>
#include <string>
#include <list>
#include <set>
#include <map>

//#define DEBUG(x) x
#define DEBUG_TYPE "trace-loop-alias"

using namespace llvm;
using namespace std;

// Make sure this matches the name of the tracer function in libmemtrack.a/so
static const char *const dumpTrace_fname = "memtrack_traceAlias";

namespace {

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

    Instruction *insertBefore = [&]() -> Instruction* {
      if (auto phi = dyn_cast<PHINode>(basePtr))
        return phi->getParent()->getFirstInsertionPt();
      if (auto inst = dyn_cast<Instruction>(basePtr))
        return nextOf(inst);
      return function_entry->getFirstInsertionPt();
    }();

    assert(insertBefore);

    IRBuilder<> IRB(insertBefore);

    auto operand  = IRB.CreatePointerCast(basePtr, IRB.getInt8PtrTy());
    auto magicNum = IRB.CreateCall(getBasePtr_fn, operand);

    // update map
    basePtr2magic[basePtr] = magicNum;

    return magicNum;
  }
private:
  BasicBlock                     *function_entry;
  Function                       *getBasePtr_fn;
  ValueMap<Value*, Instruction*>  basePtr2magic;
};

struct AliasTracer: public LoopPass {
public:
  static char ID;

  AliasTracer();

  bool runOnLoop(Loop *L, LPPassManager &LPM) override;
  const char *getPassName() const override {
    return "AliasTracer";
  }
  void getAnalysisUsage(AnalysisUsage &AU) const override
  {
    AU.addRequired<DominatorTreeWrapperPass>();
    AU.addRequired<AliasAnalysis>();
  }
private:
  Function* declareTraceFn(Module *M)
  {
    using TraceFnTy  = void(const char*, const char*, const char *, uint8_t, uint8_t);

    DEBUG(dbgs() << "AliasTracer::initialize\n");

    auto trace_fn = M->getFunction(dumpTrace_fname);

    if (trace_fn)
      return trace_fn;

    DEBUG(dbgs() << "get basic types\n");

    auto &ctx = M->getContext();
    auto type = TypeBuilder<TraceFnTy, false>::get(ctx);

    DEBUG(dbgs() << "create declaration of trace function\n");

    trace_fn = Function::Create(
      type,
      GlobalValue::ExternalLinkage,
      dumpTrace_fname,
      M
    );

    trace_fn->addAttribute(1, Attribute::ReadOnly);
    trace_fn->addAttribute(2, Attribute::ReadOnly);
    trace_fn->addAttribute(3, Attribute::ReadOnly);

    trace_fn->addAttribute(1, Attribute::NoCapture);
    trace_fn->addAttribute(2, Attribute::NoCapture);
    trace_fn->addAttribute(3, Attribute::NoCapture);

    return trace_fn;
  }
  Function *declareGetBasePtrFn(Module *M) {
    auto getBasePtr_fn = M->getFunction("gcg_getBasePtr");

    if (getBasePtr_fn)
      return getBasePtr_fn;

    // ** declare getBasePtr function

    LLVMContext& ctx = M->getContext();

    Type *void_ptr_type = Type::getInt8PtrTy(ctx);

    Type *return_type = void_ptr_type;

    std::vector<Type*> parameter_types{
      void_ptr_type
    };

    getBasePtr_fn = Function::Create(
      FunctionType::get(return_type, parameter_types, false),
      GlobalValue::ExternalLinkage,
      "gcg_getBasePtr",
      M
    );

    getBasePtr_fn->addAttribute(1, Attribute::ReadOnly);
    getBasePtr_fn->addAttribute(1, Attribute::NoCapture);

    return getBasePtr_fn;
  }
};

} // end anonymous namespace

char AliasTracer::ID = 0;

INITIALIZE_PASS(AliasTracer,
  "alias-tracer",
  "Instrument loops for alias profiling",
  false,
  false
)

LoopPass *llvm::createAliasTracerPass() {
  return new AliasTracer();
}

AliasTracer::AliasTracer() : LoopPass(ID) {
  initializeAliasTracerPass(*PassRegistry::getPassRegistry());
}


/****************** PRIVATE API *****************/

static Instruction* getInsertionPoint(Function *fn, Value *val1, Value *val2);

/********************* PUBLIC API ***********************/

cl::opt<string> InstrumentOnlyPrefix(
	"instrument-only",
	cl::desc("Instrument only loops in a function whose (mangled!) name has the given prefix"),
	cl::init("")
);

bool AliasTracer::runOnLoop(Loop *L, LPPassManager &LPM)
{
  //we are interested only in innermost loops
  if(L->getSubLoops().size() > 0) return false;

  DEBUG(dbgs() << "trace alias\n");

  using FIN = FullInstNamer;

  auto loop_header    = L->getHeader();
  auto function       = loop_header->getParent();
  auto module         = function->getParent();
  auto function_entry = &function->getEntryBlock();

  StringRef functionName = FIN::getName(function);
  StringRef headerName   = FIN::getName(loop_header);

  if (InstrumentOnlyPrefix.size() && !hasPrefix(functionName, InstrumentOnlyPrefix))
    return false;

  DominatorTree &DT  = getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  AliasAnalysis &AA  = getAnalysis<AliasAnalysis>();

  DEBUG(dbgs() << "========================================================\n");
  DEBUG(dbgs() << "AliasTracer::runOnLoop(" << functionName << "::" << headerName << ")\n");
  DEBUG(dbgs() << "========================================================\n");

  auto trace_fn      = declareTraceFn(module);
  auto getBasePtr_fn = declareGetBasePtrFn(module);

  MagicBuilder magic{function_entry, getBasePtr_fn};

  BasePtrInfo basePtrInfo = BasePtrInfo::build(L, DT, AA);

  set<ValuePair> &basePtrPairs = basePtrInfo.getBasePtrPairs();

  IRBuilder<> IRB(function_entry);

  Value *functionNameVal = FIN::getNameAsValue(this, IRB, function);

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

    auto ptr1 = magic.create(l);
    auto ptr2 = magic.create(r);

    // try to hoist the insertion point
    Instruction *insertBefore = getInsertionPoint(function, ptr1, ptr2);

    IRBuilder<> IRB(insertBefore);

    Value* check;

    check = IRB.CreateICmpNE(ptr1, ptr2);
    check = IRB.CreateSExtOrTrunc(check, IRB.getInt8Ty());

    IRB.CreateCall5(
      trace_fn,
      functionNameVal,
      FIN::getNameAsValue(this, IRB, l),
      FIN::getNameAsValue(this, IRB, r),
      check,
      IRB.getInt8(1) // from alias_profiler.h
    );
  }

  return true;
}

Instruction *getInsertionPoint(Function *fn, Value *val1, Value *val2)
{
  if (auto inst1 = dyn_cast<Instruction>(val1)) {
    if (auto inst2 = dyn_cast<Instruction>(val2)) {
      return &lastOf(inst1->getParent(), inst2->getParent())->back();
    } else {
      return &inst1->getParent()->back();
    }
  } else {
    if (auto inst2 = dyn_cast<Instruction>(val2)) {
      return &inst2->getParent()->back();
    } else {
      return fn->getEntryBlock().getFirstInsertionPt();
    }
  }
}

