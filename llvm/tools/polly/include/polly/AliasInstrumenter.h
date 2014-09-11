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
}

namespace polly {
// Returns the maximum value a SCEV can assume.
llvm::Value *getSCEVUpperBound(const llvm::SCEV *s);

// Returns the maximum value a SCEV can assume.
llvm::Value *getSCEVLowerBound(const llvm::SCEV *s);
}

#endif
