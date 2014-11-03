#ifndef _ILC_H_
#define _ILC_H_

#include <llvm/IR/Value.h>
#include <llvm/IR/GlobalValue.h>
#include <llvm/IR/Argument.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Function.h>
#include <cassert>
#include <string>

namespace ilc
{

inline bool isGlobalOrArgument(const llvm::Value *v) { return llvm::isa<llvm::GlobalValue>(v) || llvm::isa<llvm::Argument>(v); }

inline bool hasPrefix(const std::string& str, const std::string& prefix) { return str.compare(0, prefix.size(), prefix) == 0; }

inline llvm::Instruction *nextOf(llvm::Instruction *i) { return llvm::cast<llvm::Instruction>(++((llvm::BasicBlock::iterator)i)); }

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

extern llvm::BasicBlock *lastOf(llvm::BasicBlock *bb1, llvm::BasicBlock *bb2);

extern llvm::Instruction *getInsertionPoint(llvm::Function *fn, llvm::Value *val1, llvm::Value *val2);

}

#endif // _ILC_H_
