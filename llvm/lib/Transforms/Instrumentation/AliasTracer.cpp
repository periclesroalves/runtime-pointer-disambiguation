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
#include "llvm/IR/LLVMContext.h"
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

// Make sure this matches the name of the tracer function in libmemtrack.a
static const char *const dumpTrace_fname = "gcg_trace_alias_pair";

namespace {

class AliasTracer: public LoopPass {
  Instruction      *insertBefore;
  StringMap<Value*> string2Value;

  Value* getOrInsertGlobalString(StringRef str);
public:
  static char ID;

  AliasTracer();

  bool        runOnLoop(Loop *L, LPPassManager &LPM)    override;
  const char *getPassName()                       const override { return "AliasTracer"; }
  void        getAnalysisUsage(AnalysisUsage &AU) const override
  {
    AU.addRequired<DominatorTreeWrapperPass>();
    AU.addRequired<AliasAnalysis>();
  }
};

struct AliasTracerModuleHelper : public ModulePass {
  static char ID;

  AliasTracerModuleHelper();

  virtual bool  runOnModule(Module& m) override;
  const char   *getPassName()    const override { return "AliasTracerModuleHelper"; }

  static Function *getTraceFn(Module *m) {
    assert(m);

    auto fn = m->getFunction(dumpTrace_fname);

    assert(fn && "Trying to get alias trace function, but AliasTracerModuleHelper has not been run");

    return fn;
  }
};

} // end anonymous namespace

char AliasTracer::ID = 0;
char AliasTracerModuleHelper::ID = 0;

INITIALIZE_PASS(AliasTracer,
  "alias-tracer",
  "Instrument loops for alias profiling",
  false,
  false
)

INITIALIZE_PASS(AliasTracerModuleHelper,
  "alias-tracer-module-helper",
  "Declare external reference to alias tracing function",
  false,
  false
)

LoopPass *llvm::createAliasTracerPass() {
  return new AliasTracer();
}
ModulePass *llvm::createAliasTracerModuleHelperPass() {
  return new AliasTracerModuleHelper();
}

AliasTracer::AliasTracer() : LoopPass(ID) {
  initializeAliasTracerPass(*PassRegistry::getPassRegistry());
}

AliasTracerModuleHelper::AliasTracerModuleHelper() : ModulePass(ID) {
  initializeAliasTracerModuleHelperPass(*PassRegistry::getPassRegistry());
}


/****************** PRIVATE API *****************/

// Creates a global string constant and returns a pointer to it
Value *AliasTracer::getOrInsertGlobalString(StringRef str)
{
  assert(!str.empty() && "Tried to create empty string constant");

  // look up in map
  StringMap<Value*>::iterator I = string2Value.find(str);

  if(I != string2Value.end()) return I->second;

  IRBuilder<> IRB(insertBefore);

  Value *globalStr = IRB.CreateGlobalStringPtr(str);

  // update map
  string2Value[str] = globalStr;

  return globalStr;
}


static Instruction* getInsertionPoint(Function *fn, Value *val1, Value *val2);

/********************* PUBLIC API ***********************/

cl::opt<string> InstrumentOnlyPrefix(
	"instrument-only",
	cl::desc("Instrument only loops in a function whose (mangled!) name has the given prefix"),
	cl::init("")
);

bool AliasTracerModuleHelper::runOnModule(Module &M)
{
  DEBUG(dbgs() << "AliasTracerModuleHelper::runOnModule\n");

  DEBUG(dbgs() << "get basic types\n");

  LLVMContext  &ctx           = M.getContext();
  Type         *char_ptr_type = Type::getInt8PtrTy(ctx);
  Type         *return_type   = Type::getVoidTy(ctx);

  vector<Type*> parameter_types
  {
    char_ptr_type, // const char *loop
    char_ptr_type, // const char *name1
    char_ptr_type, // void *ptr1
    char_ptr_type, // const char *name2
    char_ptr_type  // void *ptr2
  };

  DEBUG(dbgs() << "create declaration of trace function\n");

  auto trace_fn = Function::Create(
    FunctionType::get(return_type, parameter_types, false),
    GlobalValue::ExternalLinkage,
    dumpTrace_fname,
    &M);

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

bool AliasTracer::runOnLoop(Loop *L, LPPassManager &LPM)
{
  //we are interested only in innermost loops
  if(L->getSubLoops().size() > 0) return false;

  DEBUG(dbgs() << "trace alias\n");

  const FullInstNamer FIN;

  auto loop_header = L->getHeader();
  auto function    = loop_header->getParent();
  auto module      = function->getParent();

  StringRef functionName = FIN.getName(function);
  StringRef headerName   = FIN.getName(loop_header);
  string    loopName     = functionName.str() + "::" + headerName.str();

  if (InstrumentOnlyPrefix.size() && !hasPrefix(functionName, InstrumentOnlyPrefix))
    return false;

  DominatorTree &DT  = getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  AliasAnalysis &AA  = getAnalysis<AliasAnalysis>();

  DEBUG(dbgs() << "========================================================\n");
  DEBUG(dbgs() << "AliasTracer::runOnLoop(" << loopName << ")\n");
  DEBUG(dbgs() << "========================================================\n");

  auto trace_fn = AliasTracerModuleHelper::getTraceFn(module);

  BasePtrInfo basePtrInfo = BasePtrInfo::build(L, DT, AA);

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
    insertBefore = getInsertionPoint(L->getHeader()->getParent(), l, r);

    IRBuilder<> IRB(insertBefore);

    // cast to Int8PtrTy if needed
    Value *ptr1  = l->getType() == IRB.getInt8PtrTy() ? l : IRB.CreatePointerCast(l, IRB.getInt8PtrTy());
    Value *ptr2  = r->getType() == IRB.getInt8PtrTy() ? r : IRB.CreatePointerCast(r, IRB.getInt8PtrTy());

    Value *loop_name = getOrInsertGlobalString(StringRef(loopName));
    Value *ptr1_name = getOrInsertGlobalString(FIN.getName(l));
    Value *ptr2_name = getOrInsertGlobalString(FIN.getName(r));

    IRB.CreateCall5(trace_fn, loop_name, ptr1_name, ptr1, ptr2_name, ptr2);
  }

  return true;
}

Instruction *getInsertionPoint(Function *fn, Value *val1, Value *val2)
{
  if (isGlobalOrArgument(val1)) {
    if (isGlobalOrArgument(val2)) {
      return fn->getEntryBlock().getFirstInsertionPt();
    } else {
      return &cast<Instruction>(val2)->getParent()->back();
    }
  } else {
    if (isGlobalOrArgument(val2)) {
      return &cast<Instruction>(val1)->getParent()->back();
    } else {
      auto i1 = cast<Instruction>(val1);
      auto i2 = cast<Instruction>(val2);

      return &lastOf(i1->getParent(), i2->getParent())->back();
    }
  }
}
