/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#ifndef CORSE_COMMON_H_
#define CORSE_COMMON_H_ 1

#include <llvm/IR/Value.h>
#include <llvm/IR/GlobalValue.h>
#include <llvm/IR/Argument.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Function.h>
#include <cassert>
#include <string>

namespace llvm {

class Loop;

inline bool isGlobalOrArgument(const llvm::Value *v) { return llvm::isa<llvm::GlobalValue>(v) || llvm::isa<llvm::Argument>(v); }

inline bool hasPrefix(const std::string& str, const std::string& prefix) { return str.compare(0, prefix.size(), prefix) == 0; }

inline llvm::Instruction *nextOf(llvm::Instruction *i) {
	assert(i);

	llvm::Instruction *next = i->getNextNode();

	assert(next);

	return next;
}

template<typename T>
std::pair<T*, T*> orderedPair(T* a, T* b)
{
  return (a < b) ? std::make_pair(a, b) : std::make_pair(b, a);
}

template<typename T>
T* getComplement(T *val, std::pair<T*, T*> &pair)
{
  if(val == pair.first)  return pair.second;
  if(val == pair.second) return pair.first;
  return nullptr;
}

llvm::BasicBlock *lastOf(llvm::BasicBlock *bb1, llvm::BasicBlock *bb2);

llvm::raw_ostream& fancy_errs(llvm::StringRef prefix = "");
llvm::raw_ostream& fancy_dbgs(llvm::StringRef prefix = "");

#define ERR(EXPR)      (llvm::fancy_errs(DEBUG_TYPE) << EXPR << "\n")

#define DBG(EXPR) DEBUG(llvm::fancy_dbgs(DEBUG_TYPE) << EXPR << "\n")

} // end namespace llvm

#endif // CORSE_COMMON_H_
