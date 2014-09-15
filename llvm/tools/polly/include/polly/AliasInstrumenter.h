//===------------- AliasInstrumenter.h --------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// Instruments a program with dynamic alias checks.
//===----------------------------------------------------------------------===//

#ifndef POLLY_ALIAS_INSTRUMENTER_H
#define POLLY_ALIAS_INSTRUMENTER_H

namespace llvm {
class ScalarEvolution;
class SCEV;
class Value;
class Region;
}

namespace polly {
class ScopDetection;

// Returns the maximum value a SCEV can assume.
llvm::Value *generateSCEVUpperBound(llvm::ScalarEvolution *se,
                               const polly::ScopDetection *sd, llvm::Region *r,
                               const llvm::SCEV *s);

// Returns the maximum value a SCEV can assume.
llvm::Value *generateSCEVLowerBound(llvm::ScalarEvolution *se,
                               const polly::ScopDetection *sd, llvm::Region *r,
                               const llvm::SCEV *s);
}

#endif
