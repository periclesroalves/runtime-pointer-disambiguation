/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#pragma once

#include <llvm/Support/CommandLine.h>
#include <string>

extern llvm::cl::opt<std::string> TraceFile;
extern llvm::cl::opt<std::string> CloneInfoFile;
