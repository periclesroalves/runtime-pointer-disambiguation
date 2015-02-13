
#ifndef POLLY_SPECULATIVEALIASANALYSIS_H
#define POLLY_SPECULATIVEALIASANALYSIS_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/IR/CallSite.h"
#include "llvm/IR/Metadata.h"

namespace llvm {
	class Value;
}

namespace polly {

using namespace llvm;

enum class SpeculativeAliasResult {
	NoRangeOverlap = 1,
	NoHeapAlias    = 2,
	NoAlias        = NoRangeOverlap | NoHeapAlias,
	ExactAlias     = 4,
	ProbablyAlias  = 8,
	DontKnow       = 0,
};

class SpeculativeAliasAnalysis {
public:
	static char ID;
	virtual ~SpeculativeAliasAnalysis() {}

	virtual SpeculativeAliasResult speculativeAlias(const Value *, const Value *) = 0;
private:
	virtual void anchor();
};

} // End polly namespace

#endif // #if POLLY_SPECULATIVEALIASANALYSIS_H
