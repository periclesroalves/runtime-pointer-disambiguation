//===--- SpeculativeAliasAnalysis.h - Speculative alias analysis *- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef POLLY_SPECULATIVE_ALIAS_ANALYSIS_H
#define POLLY_SPECULATIVE_ALIAS_ANALYSIS_H

#include <llvm/Pass.h>
#include <assert.h>

namespace llvm {
	class AliasAnalysis;
  class Value;
}

namespace polly {

using namespace llvm;

enum class SpeculativeAliasResult {
  /// speculative no alias
  NoHeapAlias = 1, /// pointers to different parts of the heap,
                   /// or one points to the heap and the other to the stack or
                   /// a global.
  NoRangeOverlap = 2, /// semi-static range check shows no aliasing.

  /// all of the above
  NoAlias = NoHeapAlias | NoRangeOverlap,

  /// speculative must alias
  ExactAlias = 4, /// base pointers of the queried pointers point to exactly the
                  /// same address in memory.

  ProbablyAlias = 8, /// speculate that the two pointers are likely to alias

  /// speculative may alias
  DontKnow = 0,
};

class SpeculativeAliasAnalysis {
public:
  static char ID; // Class identification, replacement for typeinfo
  virtual ~SpeculativeAliasAnalysis() {}

  SpeculativeAliasResult
  virtual speculativeAlias(const Function *f, const Value *a, const Value *b) = 0;

  bool probablyAlias(const Function *f, const Value *a, const Value *b) {
    return speculativeAlias(f, a, b) == SpeculativeAliasResult::ProbablyAlias;
  }
private:
  virtual void anchor();
};

} // end namespace polly

#endif // #if POLLY_SPECULATIVE_ALIAS_ANALYSIS_H
