
#include "llvm/Pass.h"
#include "llvm/Pass.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Support/Debug.h"
#include "polly/RegisterPasses.h"

using namespace llvm;

#define DEBUG_TYPE "clone-aa"

namespace {

class IgnoreClonesAA final : public ImmutablePass, public AliasAnalysis {
public:
  static char ID; // Class identification, replacement for typeinfo
  IgnoreClonesAA() : ImmutablePass(ID) {
    initializeIgnoreClonesAAPass(*PassRegistry::getPassRegistry());
  }

  void initializePass() override { InitializeAliasAnalysis(this); }

  const char *getPassName() const override { return "IgnoreClonesAA"; }

  /// getAdjustedAnalysisPointer - This method is used when a pass implements
  /// an analysis interface through multiple inheritance.  If needed, it
  /// should override this to adjust the this pointer as needed for the
  /// specified pass info.
  void *getAdjustedAnalysisPointer(const void *PI) override {
    if (PI == &AliasAnalysis::ID)
      return (AliasAnalysis*)this;
    return this;
  }
private:
  void getAnalysisUsage(AnalysisUsage &AU) const override;
  AliasResult alias(const Location &LocA, const Location &LocB) override;
  bool pointsToConstantMemory(const Location &Loc, bool OrLocal) override;
  ModRefBehavior getModRefBehavior(ImmutableCallSite CS) override;
  ModRefBehavior getModRefBehavior(const Function *F) override;
  ModRefResult getModRefInfo(ImmutableCallSite CS,
                             const Location &Loc) override;
  ModRefResult getModRefInfo(ImmutableCallSite CS1,
                             ImmutableCallSite CS2) override;

  bool isClone(const Location&);
};
}  // End of anonymous namespace

// Register this pass...
char IgnoreClonesAA::ID = 0;
INITIALIZE_AG_PASS(
	IgnoreClonesAA,
	AliasAnalysis,
	"clone-aa",
	"Alias Analysis that ignores cloned instructions",
	false,
	true,
	false
)

namespace llvm {
	ImmutablePass *createIgnoreClonesAAPass();
}

ImmutablePass *llvm::createIgnoreClonesAAPass() {
  return new IgnoreClonesAA();
}

void
IgnoreClonesAA::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.setPreservesAll();
  AliasAnalysis::getAnalysisUsage(AU);
}

AliasAnalysis::AliasResult IgnoreClonesAA::alias(const Location &LocA, const Location &LocB) {
  DEBUG(dbgs() << "IgnoreClonesAA::alias\n");

  if (isClone(LocA) || isClone(LocB))
    return AliasAnalysis::NoAlias;

  // Chain to the next AliasAnalysis.
  return AliasAnalysis::alias(LocA, LocB);
}

bool IgnoreClonesAA::isClone(const Location&) {
  // TODO
  return false;
}

bool IgnoreClonesAA::pointsToConstantMemory(const Location &Loc, bool OrLocal) {
  return AliasAnalysis::pointsToConstantMemory(Loc, OrLocal);
}

AliasAnalysis::ModRefBehavior IgnoreClonesAA::getModRefBehavior(ImmutableCallSite CS) {
  return AliasAnalysis::getModRefBehavior(CS);
}

AliasAnalysis::ModRefBehavior IgnoreClonesAA::getModRefBehavior(const Function *F) {
  return AliasAnalysis::getModRefBehavior(F);
}

AliasAnalysis::ModRefResult IgnoreClonesAA::getModRefInfo(ImmutableCallSite CS, const Location &Loc) {
  return AliasAnalysis::getModRefInfo(CS, Loc);
}

AliasAnalysis::ModRefResult IgnoreClonesAA::getModRefInfo(ImmutableCallSite CS1, ImmutableCallSite CS2) {
  return AliasAnalysis::getModRefInfo(CS1, CS2);
}


