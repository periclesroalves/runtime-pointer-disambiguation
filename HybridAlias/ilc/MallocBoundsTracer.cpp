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
#include "llvm/IR/TypeBuilder.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/CommandLine.h"
#include <llvm/Support/Debug.h>
#include <llvm/Transforms/Utils/FullInstNamer.h>
#include "Common.h"
#include "BasePtrInfo.h"

#include <string.h>
#include <string>
#include <list>
#include <set>
#include <map>

//#define DEBUG(x) x
#define DEBUG_TYPE "print-malloc-bounds"

using namespace llvm;
using namespace std;
using namespace ilc;

// Make sure this matches the name of the tracer function in libmemtrack.a
static const char *const dumpTrace_fname = "gcg_trace_malloc_chunk";

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

class MallocBoundsTracer: public LoopPass
{
  Instruction      *insertBefore;
  StringMap<Value*> string2Value;

  Value* getOrInsertGlobalString(StringRef str);

  public:
  static char ID;

  MallocBoundsTracer() : LoopPass(ID) {}

  bool        runOnLoop(Loop *L, LPPassManager &LPM)    override;
  const char *getPassName()                       const override { return "MallocBoundsTracer"; }
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
Value *MallocBoundsTracer::getOrInsertGlobalString(StringRef str)
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
	"declare-malloc-trace-function",
	"Declare external refernce to malloc tracing function"
);

char MallocBoundsTracer::ID = 0;
static RegisterPass<MallocBoundsTracer> Y(
	"trace-malloc-chunks",
	"Instrument loops for malloc chunk size profiling"
);

cl::opt<string> MallocInstrumentOnlyPrefix(
	"malloc-instrument-only",
	cl::desc("Instrument only loops in a function whose (mangled!) name has the given prefix"),
	cl::init("")
);

bool DeclareTraceFunction::runOnModule(Module &M)
{
  DEBUG(dbgs() << "DeclareTraceFunction::runOnModule\n");

  DEBUG(dbgs() << "get basic types\n");

  LLVMContext  &ctx           = M.getContext();
  Type         *char_ptr_type = Type::getInt8PtrTy(ctx);
  Type         *return_type   = Type::getVoidTy(ctx);

  vector<Type*> parameter_types
  {
    char_ptr_type, // const char *loop
    char_ptr_type, // const char *ptr_name
    char_ptr_type, // void *ptr
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

  trace_fn->addAttribute(1, Attribute::NoCapture);
  trace_fn->addAttribute(2, Attribute::NoCapture);
  trace_fn->addAttribute(3, Attribute::NoCapture);

  return true;
}

bool MallocBoundsTracer::runOnLoop(Loop *L, LPPassManager &LPM)
{
  //we are interested only in innermost loops
  if(L->getSubLoops().size() > 0) return false;

  DEBUG(dbgs() << "trace alias\n");

  DominatorTree        &DT  = getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  FullInstNamer        &FIN = getAnalysis<FullInstNamer>();
  AliasAnalysis        &AA  = getAnalysis<AliasAnalysis>();
  DeclareTraceFunction &DTF = getAnalysis<DeclareTraceFunction>();

  DEBUG(dbgs() << "A\n");
  BasePtrInfo basePtrInfo = BasePtrInfo::build(L, DT, AA);
  DEBUG(dbgs() << "B\n");

  Function *trace_fn = DTF.getTraceFn();

  BasicBlock *header = L->getHeader();
  assert(header);
  Function *current_function = header->getParent();

  StringRef functionName = FIN.getName(current_function);
  StringRef headerName   = FIN.getName(header);
  string    loopName     = functionName.str() + "::" + headerName.str();

  if (MallocInstrumentOnlyPrefix.size() && !ilc::hasPrefix(functionName, MallocInstrumentOnlyPrefix))
    return false;

  DEBUG(dbgs() << "========================================================\n");
  DEBUG(dbgs() << "MallocBoundsTracer::runOnLoop(" << loopName << ")\n");
  DEBUG(dbgs() << "========================================================\n");

  for (auto base_ptr : basePtrInfo.getAllBasePtrs())
  {
    DEBUG(dbgs() << "--------------------------------------------------------\n");
    DEBUG(dbgs() << "Malloc tracing base ptr\n");
    DEBUG(dbgs() << "--------------------------------------------------------\n");
    DEBUG(dbgs() << *base_ptr << "\n");
    DEBUG(dbgs() << "--------------------------------------------------------\n");

	Instruction *insertion_point = nullptr;

  	if (isGlobalOrArgument(base_ptr)) {
		insertion_point = current_function->getEntryBlock().getFirstInsertionPt();
	} else {
		insertion_point = nextOf(cast<Instruction>(base_ptr));
	}

    IRBuilder<> IRB(insertion_point);

    // cast to Int8PtrTy if needed
    Value *ptr = base_ptr->getType() == IRB.getInt8PtrTy() ? base_ptr : IRB.CreatePointerCast(base_ptr, IRB.getInt8PtrTy());

    Value *loop_name = getOrInsertGlobalString(loopName);
    Value *ptr_name  = getOrInsertGlobalString(FIN.getName(base_ptr));

    IRB.CreateCall3(trace_fn, loop_name, ptr_name, ptr);
  }

  return true;
}
