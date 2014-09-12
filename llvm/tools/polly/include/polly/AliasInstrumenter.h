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
class SCEV;
class Value;
class Region;
}

namespace polly {
class ScopDetection;

// Returns the maximum value a SCEV can assume.
llvm::Value *getSCEVUpperBound(const polly::ScopDetection *sd, const llvm::Region *r, const llvm::SCEV *s);

// Returns the maximum value a SCEV can assume.
llvm::Value *getSCEVLowerBound(const polly::ScopDetection *sd, const llvm::Region *r, const llvm::SCEV *s);
}

#endif
