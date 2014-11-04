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
#include "llvm/Transforms/Utils/FullInstNamer.h"
#include "Common.h"
#include "BasePtrInfo.h"

#include <string.h>
#include <string>
#include <list>
#include <set>
#include <map>

//#define DEBUG(x) x
#define DEBUG_TYPE "trace-loop-alias"

using namespace llvm;
using namespace std;
using namespace ilc;

// Make sure this matches the name of the tracer function in libmemtrack.a
static const char *const dumpTrace_fname = "gcg_trace_alias_pair";

namespace 
{

class DeclareTraceFunction : public ModulePass
{
  Function *trace_fn;

  public:
  static char ID;

  DeclareTraceFunction() : ModulePass(ID), trace_fn(nullptr) {}

  virtual bool  runOnModule(Module& m) override;
  const char   *getPassName()    const override { return "DeclareTraceFunction"; }
  Function     *getTraceFn()                    { assert(trace_fn); return trace_fn; }
};

class TraceLoopAlias: public LoopPass
{
  Instruction      *insertBefore;
  StringMap<Value*> string2Value;

  Value* getOrInsertGlobalString(StringRef str);

  public:
  static char ID;

  TraceLoopAlias() : LoopPass(ID) {}

  bool        runOnLoop(Loop *L, LPPassManager &LPM)    override;
  const char *getPassName()                       const override { return "TraceLoopAlias"; }
  void        getAnalysisUsage(AnalysisUsage &AU) const override
  {
    // TODO: LLVM doc states that transformation passes should
    //       not be chained with addRequire but with a custom
    //       PassManager
    AU.addRequired<FullInstNamer>();
    AU.addRequired<DeclareTraceFunction>();

    AU.addRequired<DominatorTreeWrapperPass>();
    AU.addRequired<AliasAnalysis>();
  }
};

} // end anonymous namespace


/****************** PRIVATE API *****************/

// Creates a global string constant and returns a pointer to it
Value *TraceLoopAlias::getOrInsertGlobalString(StringRef str)
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


/********************* PUBLIC API ***********************/

char DeclareTraceFunction::ID = 0;
static RegisterPass<DeclareTraceFunction> X(
	"declare-trace-function",
	"Declare external refernce to alias tracing function"
);

char TraceLoopAlias::ID = 0;
static RegisterPass<TraceLoopAlias> Y(
	"trace-loop-alias",
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

  DEBUG(dbgs() << "get basic types\n");

  LLVMContext  &ctx           = M.getContext();
  Type         *char_ptr_type = Type::getInt8PtrTy(ctx);
  Type         *return_type   = Type::getInt32Ty(ctx);

  vector<Type*> parameter_types
  {
    char_ptr_type, // const char *loop
    char_ptr_type, // const char *name1
    char_ptr_type, // void *ptr1
    char_ptr_type, // const char *name2
    char_ptr_type  // void *ptr2
  };

  DEBUG(dbgs() << "create declaration of trace function\n");

  trace_fn = Function::Create(
    FunctionType::get(return_type, parameter_types, false),
    GlobalValue::ExternalLinkage,
    dumpTrace_fname,
    &M);

  trace_fn->addAttribute(1, Attribute::ReadOnly);
  trace_fn->addAttribute(2, Attribute::ReadOnly);
  trace_fn->addAttribute(3, Attribute::ReadOnly);
  trace_fn->addAttribute(4, Attribute::ReadOnly);
  trace_fn->addAttribute(5, Attribute::ReadOnly);

  return true;
}

bool TraceLoopAlias::runOnLoop(Loop *L, LPPassManager &LPM)
{
  //we are interested only in innermost loops
  if(L->getSubLoops().size() > 0) return false;

  DEBUG(dbgs() << "trace alias\n");

  DominatorTree        &DT  = getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  FullInstNamer        &FIN = getAnalysis<FullInstNamer>();
  AliasAnalysis        &AA  = getAnalysis<AliasAnalysis>();
  DeclareTraceFunction &DTF = getAnalysis<DeclareTraceFunction>();

  DEBUG(dbgs() << "A\n");
  BasePtrInfo basePtrInfo{L, DT, AA};
  DEBUG(dbgs() << "B\n");

  Function *trace_fn = DTF.getTraceFn();

  StringRef functionName = FIN.getName(L->getHeader()->getParent());
  StringRef headerName   = FIN.getName(L->getHeader());
  string    loopName     = functionName.str() + "::" + headerName.str();

  if (InstrumentOnlyPrefix.size() && !ilc::hasPrefix(functionName, InstrumentOnlyPrefix))
    return false;

  DEBUG(dbgs() << "========================================================\n");
  DEBUG(dbgs() << "TraceLoopAlias::runOnLoop(" << loopName << ")\n");
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
