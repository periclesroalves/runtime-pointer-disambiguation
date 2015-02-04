//===- ScalarEvolutionMustDependenceAnalysis.cpp - SCEV-based Alias Analysis -------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the TileUnroll pass, which implements a
// simple alias analysis implemented in terms of ScalarEvolution queries.
//
// This differs from traditional loop dependence analysis in that it tests
// for dependencies within a single iteration of a loop, rather than
// dependencies between different iterations.
//
// ScalarEvolution has a more complete understanding of pointer arithmetic
// than BasicAliasAnalysis' collection of ad-hoc analyses.
//
//===----------------------------------------------------------------------===//


/*
scev diff in both directions
shaddow edge removes an anti dep
if shaddow edge has negetive dist it removes dep
mem dep compute in bot directions (split flow and anti)
  - what to do with output and input? double dependence in both directions?


*/

/*
http://llvm.org/docs/doxygen/html/IndVarSimplify_8cpp_source.html
 */

//#define LLVM_ENABLE_THREADS = 0

#include <typeinfo>
#include <algorithm>
#include <vector>
#include <utility>

#include "llvm/Transforms/Scalar.h"
#include "llvm/Analysis/AssumptionTracker.h"
#include "llvm/Analysis/CodeMetrics.h"
#include "llvm/Analysis/FunctionTargetTransformInfo.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/DiagnosticInfo.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Metadata.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/UnrollLoop.h"
#include <climits>

#include "PassTools.h"
#include "ParseTools.h"


//Copied the below from lib/Support/Valgrind.cpp because otherwise I got libTileUnroll.so: undefined symbol: AnnotateIgnoreWritesBegin
#if LLVM_ENABLE_THREADS != 0 && !defined(NDEBUG)
// These functions require no implementation, tsan just looks at the arguments
// they're called with. However, they are required to be weak as some other
// application or library may already be providing these definitions for the
// same reason we are.
extern "C" {
LLVM_ATTRIBUTE_WEAK void AnnotateHappensAfter(const char *file, int line,
                                              const volatile void *cv);
void AnnotateHappensAfter(const char *file, int line, const volatile void *cv) {
}
LLVM_ATTRIBUTE_WEAK void AnnotateHappensBefore(const char *file, int line,
                                               const volatile void *cv);
void AnnotateHappensBefore(const char *file, int line,
                           const volatile void *cv) {}
LLVM_ATTRIBUTE_WEAK void AnnotateIgnoreWritesBegin(const char *file, int line);
void AnnotateIgnoreWritesBegin(const char *file, int line) {}
LLVM_ATTRIBUTE_WEAK void AnnotateIgnoreWritesEnd(const char *file, int line);
void AnnotateIgnoreWritesEnd(const char *file, int line) {}
}
#endif


using namespace llvm;

#define DEBUG_TYPE "loop-unroll"


namespace llvm {
  class PassRegistry;
  class FunctionPass;
  void initializeTileUnrollPass(PassRegistry&);
  FunctionPass *createTileUnrollPass();

  cl::opt<unsigned> UnrollFactor(
      "unroll-factor",cl::init(1), 
      cl::desc("Specify unroll factor for analised loop")
  );  

  cl::opt<std::string> SelectedLoopNames(
      "selected-loop-names", 
      cl::desc("Specify loop name")
  );
    /*
  cl::opt<unsigned>
  UnrollThreshold("unroll-threshold", cl::init(150), cl::Hidden,
  cl::desc("The cut-off point for automatic loop unrolling"));

  cl::opt<unsigned>
  UnrollCount("unroll-count", cl::init(0), cl::Hidden,
  cl::desc("Use this unroll count for all loops including those with "
           "unroll_count pragma values, for testing purposes"));

  cl::opt<bool>
  UnrollAllowPartial("unroll-allow-partial", cl::init(false), cl::Hidden,
  cl::desc("Allows loops to be partially unrolled until "
           "-unroll-threshold loop size is reached."));

  cl::opt<bool>
  UnrollRuntime("unroll-runtime", cl::ZeroOrMore, cl::init(false), cl::Hidden,
  cl::desc("Unroll loops with run-time trip counts"));

  cl::opt<unsigned>
  PragmaUnrollThreshold("pragma-unroll-threshold", cl::init(16 * 1024), cl::Hidden,
  cl::desc("Unrolled size limit for loops with an unroll(full) or "
           "unroll_count pragma."));
    */
}


namespace {
class TileUnroll : public LoopPass{
 ScalarEvolution *seaa;

public:
  static char ID; // Class identification, replacement for typeinfo

    /// A magic value for use with the Threshold parameter to indicate
    /// that the loop unroll should be performed regardless of how much
    /// code expansion would result.
    static const unsigned NoThreshold = UINT_MAX;

    // Threshold to use when optsize is specified (and there is no
    // explicit -unroll-threshold).
    static const unsigned OptSizeUnrollThreshold = 50;

    // Default unroll count for loops with run-time trip count if
    // -unroll-count is not set
    static const unsigned UnrollRuntimeCount = 8;

    const unsigned PragmaUnrollThreshold = 0;

    unsigned CurrentCount;
    unsigned CurrentThreshold;
    bool     CurrentAllowPartial;
    bool     CurrentRuntime;
    bool     UserCount;            // CurrentCount is user-specified.
    bool     UserThreshold;        // CurrentThreshold is user-specified.
    bool     UserAllowPartial;     // CurrentAllowPartial is user-specified.
    bool     UserRuntime;          // CurrentRuntime is user-specified.

    /// This transformation requires natural loop information & requires that
    /// loop preheaders be inserted into the CFG...
    ///
    void getAnalysisUsage(AnalysisUsage &AU) const override {
      AU.addRequired<AssumptionTracker>();
      AU.addRequired<LoopInfo>();
      AU.addPreserved<LoopInfo>();
      AU.addRequiredID(LoopSimplifyID);
      AU.addPreservedID(LoopSimplifyID);
      AU.addRequiredID(LCSSAID);
      AU.addPreservedID(LCSSAID);
      AU.addRequired<ScalarEvolution>();
      AU.addPreserved<ScalarEvolution>();
      AU.addRequired<TargetTransformInfo>();
      AU.addRequired<FunctionTargetTransformInfo>();
      // FIXME: Loop unroll requires LCSSA. And LCSSA requires dom info.
      // If loop unroll does not preserve dom info then LCSSA pass on next
      // loop will receive invalid dom info.
      // For now, recreate dom info, if loop is unrolled.
      AU.addPreserved<DominatorTreeWrapperPass>();
    }

    // Fill in the UnrollingPreferences parameter with values from the
    // TargetTransformationInfo.
    void getUnrollingPreferences(Loop *L, const FunctionTargetTransformInfo &FTTI,
                                 TargetTransformInfo::UnrollingPreferences &UP) {
      UP.Threshold = CurrentThreshold;
      UP.OptSizeThreshold = OptSizeUnrollThreshold;
      UP.PartialThreshold = CurrentThreshold;
      UP.PartialOptSizeThreshold = OptSizeUnrollThreshold;
      UP.Count = CurrentCount;
      UP.MaxCount = UINT_MAX;
      UP.Partial = CurrentAllowPartial;
      UP.Runtime = CurrentRuntime;
      FTTI.getUnrollingPreferences(L, UP);
    }

    // Select and return an unroll count based on parameters from
    // user, unroll preferences, unroll pragmas, or a heuristic.
    // SetExplicitly is set to true if the unroll count is is set by
    // the user or a pragma rather than selected heuristically.
    unsigned
    selectUnrollCount(const Loop *L, unsigned TripCount, bool PragmaFullUnroll,
                      unsigned PragmaCount,
                      const TargetTransformInfo::UnrollingPreferences &UP,
                      bool &SetExplicitly);

    // Select threshold values used to limit unrolling based on a
    // total unrolled size.  Parameters Threshold and PartialThreshold
    // are set to the maximum unrolled size for fully and partially
    // unrolled loops respectively.
    void selectThresholds(const Loop *L, bool HasPragma,
                          const TargetTransformInfo::UnrollingPreferences &UP,
                          unsigned &Threshold, unsigned &PartialThreshold) {
      // Determine the current unrolling threshold.  While this is
      // normally set from UnrollThreshold, it is overridden to a
      // smaller value if the current function is marked as
      // optimize-for-size, and the unroll threshold was not user
      // specified.
      Threshold = UserThreshold ? CurrentThreshold : UP.Threshold;
      PartialThreshold = UserThreshold ? CurrentThreshold : UP.PartialThreshold;
      if (!UserThreshold &&
          L->getHeader()->getParent()->getAttributes().
              hasAttribute(AttributeSet::FunctionIndex,
                           Attribute::OptimizeForSize)) {
        Threshold = UP.OptSizeThreshold;
        PartialThreshold = UP.PartialOptSizeThreshold;
      }
      if (HasPragma) {
        // If the loop has an unrolling pragma, we want to be more
        // aggressive with unrolling limits.  Set thresholds to at
        // least the PragmaTheshold value which is larger than the
        // default limits.
        if (Threshold != NoThreshold)
          Threshold = std::max<unsigned>(Threshold, PragmaUnrollThreshold);
        if (PartialThreshold != NoThreshold)
          PartialThreshold =
              std::max<unsigned>(PartialThreshold, PragmaUnrollThreshold);
      }
    }

  TileUnroll() :
    LoopPass(ID),
    seaa(0)
  {
    
    // CurrentThreshold = (T == -1) ? UnrollThreshold : unsigned(T);
    // CurrentCount = (C == -1) ? UnrollCount : unsigned(C);
    // CurrentAllowPartial = (P == -1) ? UnrollAllowPartial : (bool)P;
    // CurrentRuntime = (R == -1) ? UnrollRuntime : (bool)R;
    
    // UserThreshold = (T != -1) || (UnrollThreshold.getNumOccurrences() > 0);
    // UserAllowPartial = (P != -1) || (UnrollAllowPartial.getNumOccurrences() > 0);
    UserRuntime = true;
    CurrentRuntime = true;
    
    UserCount = UnrollFactor;
    CurrentCount = UnrollFactor;

    int tmpThreshold = 500;    
    UserThreshold = tmpThreshold;
    CurrentThreshold = tmpThreshold;
 
    // initializeTileUnrollPass(*PassRegistry::getPassRegistry());
  }

  /// getAdjustedAnalysisPointer - This method is used when a pass implements
  /// an analysis interface through multiple inheritance.  If needed, it
  /// should override this to adjust the this pointer as needed for the
  /// specified pass info.

private:
  virtual bool runOnLoop(Loop *loop, LPPassManager &LPM);
};
}  // End of anonymous namespace


// Register this pass...
INITIALIZE_PASS_BEGIN(TileUnroll, "tile-unroll",
                   "Unrolling pass for the purpose of tiling", false, false)
INITIALIZE_AG_DEPENDENCY(TargetTransformInfo)
INITIALIZE_PASS_DEPENDENCY(AssumptionTracker)
INITIALIZE_PASS_DEPENDENCY(FunctionTargetTransformInfo)
INITIALIZE_PASS_DEPENDENCY(LoopInfo)
INITIALIZE_PASS_DEPENDENCY(LoopSimplify)
INITIALIZE_PASS_DEPENDENCY(LCSSA)
INITIALIZE_PASS_DEPENDENCY(ScalarEvolution)
INITIALIZE_PASS_END(TileUnroll, "tile-unroll",
                    "Unrolling pass for the purpose of tiling", false, false)


/// ApproximateLoopSize - Approximate the size of the loop.
static unsigned ApproximateLoopSize(const Loop *L, unsigned &NumCalls,
                                    bool &NotDuplicatable,
                                    const TargetTransformInfo &TTI,
                                    AssumptionTracker *AT) {
  SmallPtrSet<const Value *, 32> EphValues;
  CodeMetrics::collectEphemeralValues(L, AT, EphValues);

  CodeMetrics Metrics;
  for (Loop::block_iterator I = L->block_begin(), E = L->block_end();
       I != E; ++I)
    Metrics.analyzeBasicBlock(*I, TTI, EphValues);
  NumCalls = Metrics.NumInlineCandidates;
  NotDuplicatable = Metrics.notDuplicatable;

  unsigned LoopSize = Metrics.NumInsts;

  // Don't allow an estimate of size zero.  This would allows unrolling of loops
  // with huge iteration counts, which is a compile time problem even if it's
  // not a problem for code quality.
  if (LoopSize == 0) LoopSize = 1;

  return LoopSize;
}

// Returns the loop hint metadata node with the given name (for example,
// "llvm.loop.unroll.count").  If no such metadata node exists, then nullptr is
// returned.
static const MDNode *GetUnrollMetadata(const Loop *L, StringRef Name) {
  MDNode *LoopID = L->getLoopID();
  if (!LoopID)
    return nullptr;

  // First operand should refer to the loop id itself.
  assert(LoopID->getNumOperands() > 0 && "requires at least one operand");
  assert(LoopID->getOperand(0) == LoopID && "invalid loop id");

  for (unsigned i = 1, e = LoopID->getNumOperands(); i < e; ++i) {
    const MDNode *MD = dyn_cast<MDNode>(LoopID->getOperand(i));
    if (!MD)
      continue;

    const MDString *S = dyn_cast<MDString>(MD->getOperand(0));
    if (!S)
      continue;

    if (Name.equals(S->getString()))
      return MD;
  }
  return nullptr;
}

// Returns true if the loop has an unroll(full) pragma.
static bool HasUnrollFullPragma(const Loop *L) {
  return GetUnrollMetadata(L, "llvm.loop.unroll.full");
}

// Returns true if the loop has an unroll(disable) pragma.
static bool HasUnrollDisablePragma(const Loop *L) {
  return GetUnrollMetadata(L, "llvm.loop.unroll.disable");
}

// If loop has an unroll_count pragma return the (necessarily
// positive) value from the pragma.  Otherwise return 0.
static unsigned UnrollCountPragmaValue(const Loop *L) {
  const MDNode *MD = GetUnrollMetadata(L, "llvm.loop.unroll.count");
  if (MD) {
    assert(MD->getNumOperands() == 2 &&
           "Unroll count hint metadata should have two operands.");
    unsigned Count = cast<ConstantInt>(MD->getOperand(1))->getZExtValue();
    assert(Count >= 1 && "Unroll count must be positive.");
    return Count;
  }
  return 0;
}

// Remove existing unroll metadata and add unroll disable metadata to
// indicate the loop has already been unrolled.  This prevents a loop
// from being unrolled more than is directed by a pragma if the loop
// unrolling pass is run more than once (which it generally is).
static void SetLoopAlreadyUnrolled(Loop *L) {
  MDNode *LoopID = L->getLoopID();
  if (!LoopID) return;

  // First remove any existing loop unrolling metadata.
  SmallVector<Value *, 4> Vals;
  // Reserve first location for self reference to the LoopID metadata node.
  Vals.push_back(nullptr);
  for (unsigned i = 1, ie = LoopID->getNumOperands(); i < ie; ++i) {
    bool IsUnrollMetadata = false;
    MDNode *MD = dyn_cast<MDNode>(LoopID->getOperand(i));
    if (MD) {
      const MDString *S = dyn_cast<MDString>(MD->getOperand(0));
      IsUnrollMetadata = S && S->getString().startswith("llvm.loop.unroll.");
    }
    if (!IsUnrollMetadata) Vals.push_back(LoopID->getOperand(i));
  }

  // Add unroll(disable) metadata to disable future unrolling.
  LLVMContext &Context = L->getHeader()->getContext();
  SmallVector<Value *, 1> DisableOperands;
  DisableOperands.push_back(MDString::get(Context, "llvm.loop.unroll.disable"));
  MDNode *DisableNode = MDNode::get(Context, DisableOperands);
  Vals.push_back(DisableNode);

  MDNode *NewLoopID = MDNode::get(Context, Vals);
  // Set operand 0 to refer to the loop id itself.
  NewLoopID->replaceOperandWith(0, NewLoopID);
  L->setLoopID(NewLoopID);
}

unsigned TileUnroll::selectUnrollCount(
    const Loop *L, unsigned TripCount, bool PragmaFullUnroll,
    unsigned PragmaCount, const TargetTransformInfo::UnrollingPreferences &UP,
    bool &SetExplicitly) {
  SetExplicitly = true;

  // User-specified count (either as a command-line option or
  // constructor parameter) has highest precedence.
  unsigned Count = UserCount ? CurrentCount : 0;

  // If there is no user-specified count, unroll pragmas have the next
  // highest precendence.
  if (Count == 0) {
    if (PragmaCount) {
      Count = PragmaCount;
    } else if (PragmaFullUnroll) {
      Count = TripCount;
    }
  }

  if (Count == 0)
    Count = UP.Count;

  if (Count == 0) {
    SetExplicitly = false;
    if (TripCount == 0)
      // Runtime trip count.
      Count = UnrollRuntimeCount;
    else
      // Conservative heuristic: if we know the trip count, see if we can
      // completely unroll (subject to the threshold, checked below); otherwise
      // try to find greatest modulo of the trip count which is still under
      // threshold value.
      Count = TripCount;
  }
  if (TripCount && Count > TripCount)
    return TripCount;
  return Count;
}


bool TileUnroll::runOnLoop(Loop *L, LPPassManager &LPM) {
  PassTools::incrLoopCnt();
  
  //loop->print(errs());
  //we are interested only in innermost loops
  seaa = &getAnalysis<ScalarEvolution>();

  if (L->getSubLoops().size() > 0)
    return false;

  //get loop name
  string loopName = PassTools::getLoopName(L);
  if(loopName.size()==0){  
      loopName = PassTools::getCurrentLoopName();
  }  
  assert(loopName.size()>0);
  PassTools::setLoopName(L,loopName);

  //if some loop is selected  
  if(!PassTools::processLoop(SelectedLoopNames,L)){
    return false;
  }
          
  errs() << "\n";
  errs() << "loopName: " << loopName << "\n";
  errs() << "loopData: "<< PassTools::getLoopData(L) << "\n";
  
  /*
  bool UnrollLoop(Loop *L, unsigned Count, unsigned TripCount, bool 28,
                  unsigned TripMultiple, LoopInfo *LI, Pass *29AllowRuntime,
                  LPPassManager *LPM, AssumptionTracker *AT);  
  */

  errs() << "=== Loop\n";
  L->print(errs());
  /*
  for (Loop::block_iterator blockIt = L->block_begin(); blockIt != L->block_end(); ++blockIt) {
    BasicBlock *block = *blockIt;
    errs() << "=== Block";
    block->print(errs());    
  }
  */

  const SCEVAddRecExpr* indVarScev = 0;
  Instruction *indVarInstr = 0;
  int indVarIncr=-1;
  int indVarDivUnroll = -1; 
  PassTools::findInductionVariable(L,seaa,indVarScev,indVarInstr,indVarIncr);


  std::vector<Instruction*> loopInstrAr;
  std::map<Value*,int> instrOrderMap;
  std::unordered_set<Instruction*> extDefSet;
  PassTools::fillInInstructionCollections(L,PassTools::WHOLE_LOOP,loopInstrAr,instrOrderMap,extDefSet);


  //ORIGINAL LLVM LOOP UNROLL PASS STARTS HERE
  if (skipOptnoneFunction(L))
    return false;

  LoopInfo *LI = &getAnalysis<LoopInfo>();
  ScalarEvolution *SE = &getAnalysis<ScalarEvolution>();
  const TargetTransformInfo &TTI = getAnalysis<TargetTransformInfo>();
  const FunctionTargetTransformInfo &FTTI =
      getAnalysis<FunctionTargetTransformInfo>();
  AssumptionTracker *AT = &getAnalysis<AssumptionTracker>();

  BasicBlock *Header = L->getHeader();
  errs() << "Loop Unroll: F[" << Header->getParent()->getName()
        << "] Loop %" << Header->getName() << "\n";

  if (HasUnrollDisablePragma(L)) {
    return false;
  }
  bool PragmaFullUnroll = HasUnrollFullPragma(L);
  unsigned PragmaCount = UnrollCountPragmaValue(L);
  bool HasPragma = PragmaFullUnroll || PragmaCount > 0;

  TargetTransformInfo::UnrollingPreferences UP;
  getUnrollingPreferences(L, FTTI, UP);

  // Find trip count and trip multiple if count is not available
  unsigned TripCount = 0;
  unsigned TripMultiple = 1;
  // If there are multiple exiting blocks but one of them is the latch, use the
  // latch for the trip count estimation. Otherwise insist on a single exiting
  // block for the trip count estimation.
  BasicBlock *ExitingBlock = L->getLoopLatch();
  if (!ExitingBlock || !L->isLoopExiting(ExitingBlock))
    ExitingBlock = L->getExitingBlock();
  if (ExitingBlock) {
    TripCount = SE->getSmallConstantTripCount(L, ExitingBlock);
    TripMultiple = SE->getSmallConstantTripMultiple(L, ExitingBlock);
  }

  // Select an initial unroll count.  This may be reduced later based
  // on size thresholds.
  bool CountSetExplicitly;
  unsigned Count = selectUnrollCount(L, TripCount, PragmaFullUnroll,
                                     PragmaCount, UP, CountSetExplicitly);

  unsigned NumInlineCandidates;
  bool notDuplicatable;
  unsigned LoopSize =
      ApproximateLoopSize(L, NumInlineCandidates, notDuplicatable, TTI, AT);
  errs() << "  Loop Size = " << LoopSize << "\n";
  uint64_t UnrolledSize = (uint64_t)LoopSize * Count;
  if (notDuplicatable) {
    errs() << "  Not unrolling loop which contains non-duplicatable"
                 << " instructions.\n";
    return false;
  }
  if (NumInlineCandidates != 0) {
    errs() << "  Not unrolling loop with inlinable calls.\n";
    return false;
  }

  unsigned Threshold, PartialThreshold;
  selectThresholds(L, HasPragma, UP, Threshold, PartialThreshold);

  // Given Count, TripCount and thresholds determine the type of
  // unrolling which is to be performed.
  enum { Full = 0, Partial = 1, Runtime = 2 };
  int Unrolling;
  if (TripCount && Count == TripCount) {
    if (Threshold != NoThreshold && UnrolledSize > Threshold) {
      errs() << "  Too large to fully unroll with count: " << Count
                   << " because size: " << UnrolledSize << ">" << Threshold
                   << "\n";
      Unrolling = Partial;
    } else {
      Unrolling = Full;
    }
  } else if (TripCount && Count < TripCount) {
    Unrolling = Partial;
  } else {
    Unrolling = Runtime;
  }

  // Reduce count based on the type of unrolling and the threshold values.
  unsigned OriginalCount = Count;
  bool AllowRuntime = UserRuntime ? CurrentRuntime : UP.Runtime;
  if (Unrolling == Partial) {
    bool AllowPartial = UserAllowPartial ? CurrentAllowPartial : UP.Partial;
    if (!AllowPartial && !CountSetExplicitly) {
      errs() << "  will not try to unroll partially because "
                   << "-unroll-allow-partial not given\n";
      return false;
    }
    if (PartialThreshold != NoThreshold && UnrolledSize > PartialThreshold) {
      // Reduce unroll count to be modulo of TripCount for partial unrolling.
      Count = PartialThreshold / LoopSize;
      while (Count != 0 && TripCount % Count != 0)
        Count--;
    }
  } else if (Unrolling == Runtime) {
    errs() << "AllowRuntime: " << AllowRuntime << " CountSetExplicitly: "<< CountSetExplicitly <<"\n"; 
    if (!AllowRuntime && !CountSetExplicitly) {
      errs() << "  will not try to unroll loop with runtime trip count "
                   << "-unroll-runtime not given\n";
      return false;
    }
    // Reduce unroll count to be the largest power-of-two factor of
    // the original count which satisfies the threshold limit.
    while (Count != 0 && UnrolledSize > PartialThreshold) {
      Count >>= 1;
      UnrolledSize = LoopSize * Count;
    }
    if (Count > UP.MaxCount)
      Count = UP.MaxCount;
    errs() << "  partially unrolling with count: " << Count << "\n";
  }

  if (HasPragma) {
    if (PragmaCount != 0)
      // If loop has an unroll count pragma mark loop as unrolled to prevent
      // unrolling beyond that requested by the pragma.
      SetLoopAlreadyUnrolled(L);

    // Emit optimization remarks if we are unable to unroll the loop
    // as directed by a pragma.
    DebugLoc LoopLoc = L->getStartLoc();
    Function *F = Header->getParent();
    LLVMContext &Ctx = F->getContext();
    if (PragmaFullUnroll && PragmaCount == 0) {
      if (TripCount && Count != TripCount) {
        emitOptimizationRemarkMissed(
            Ctx, DEBUG_TYPE, *F, LoopLoc,
            "Unable to fully unroll loop as directed by unroll(full) pragma "
            "because unrolled size is too large.");
      } else if (!TripCount) {
        emitOptimizationRemarkMissed(
            Ctx, DEBUG_TYPE, *F, LoopLoc,
            "Unable to fully unroll loop as directed by unroll(full) pragma "
            "because loop has a runtime trip count.");
      }
    } else if (PragmaCount > 0 && Count != OriginalCount) {
      emitOptimizationRemarkMissed(
          Ctx, DEBUG_TYPE, *F, LoopLoc,
          "Unable to unroll loop the number of times directed by "
          "unroll_count pragma because unrolled size is too large.");
    }
  }

  if (Unrolling != Full && Count < 2) {
    // Partial unrolling by 1 is a nop.  For full unrolling, a factor
    // of 1 makes sense because loop control can be eliminated.
    return false;
  }

  // Unroll the loop.
  errs() <<"unrollParams:{ Count: "<<Count<<", TripCount: "<<TripCount<<", AllowRuntime: "<<AllowRuntime<<", TripMultiple: "<<TripMultiple<<"\n";
  
  if(Count<UnrollFactor){
    errs() << "Unable to unroll"<<"\n";
    return false;
  }
  
  if (!UnrollLoop(L, Count, TripCount, AllowRuntime, TripMultiple, LI, this, &LPM, AT)){
      errs() << "Unroll failed"<<"\n";
    return false;
  }else{
      errs() << "Unroll successfull"<<"\n";
  }

  if(false){
    seaa->forgetLoop(L);
    for (Loop::block_iterator blockIt = L->block_begin(); blockIt != L->block_end(); ++blockIt) {
        BasicBlock *block = *blockIt;
        for (BasicBlock::iterator instrIt = block->begin();  instrIt != block->end(); ++instrIt) {
            Instruction *instr = instrIt;
            errs() <<"Instr: "<<*instr<<"\n";
            errs() <<"  SCEV: "<<*seaa->getSCEV(instr)<<"\n";
            if(PassTools::getVarId(instr,false).compare("")>0){
                //instr->setName(PassTools::getVarId(instr,false)+string(""));
            }
        }
    }
  }
        
  //PassTools::inserIndvarAfterPhi(L,SE,LI);
  PassTools::removeIndvarNext(L, UnrollFactor, SE,LI);
  return true;

}


char TileUnroll::ID = 0;
static RegisterPass<TileUnroll> X("tile-unroll",
    "Unrolling pass for the purpose of tiling", false, false);

