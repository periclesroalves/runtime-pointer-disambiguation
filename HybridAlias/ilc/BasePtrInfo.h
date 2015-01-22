/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#ifndef _BASE_PTR_INFO_H_
#define _BASE_PTR_INFO_H_

#include <llvm/Pass.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/AliasAnalysis.h>
#include <llvm/Support/Debug.h>
#include <llvm/IR/Dominators.h>
#include "llvm/IR/Value.h"
#include "llvm/IR/Instructions.h"
#include <utility>
#include <map>
#include <set>
#include <list>

namespace llvm {
	class Region;
}

typedef std::pair<llvm::Instruction*, llvm::Instruction*> InstrPair;
typedef std::pair<llvm::Value*, llvm::Value*>             ValuePair;
typedef std::set<llvm::Value*>                            ValueSet;
typedef std::map<llvm::Instruction*, ValueSet>            InstructionMap;

struct BasePtrInfo
{
  static BasePtrInfo build(llvm::Loop*   loop,   llvm::DominatorTree& tree, llvm::AliasAnalysis& aa);
  static BasePtrInfo build(llvm::Region* region, llvm::DominatorTree& tree, llvm::AliasAnalysis& aa);

  void                 filter(const std::set<ValuePair>& badPairs);
  std::set<ValuePair>& getBasePtrPairs();
  ValueSet&            getBasePtrs(llvm::Instruction *i);
  const ValueSet&      getAllBasePtrs() const;
  InstructionMap&      getInstructionMap();
private:
  void rebuildAllBasePtrs();

  std::set<ValuePair> basePtrPairs;
  InstructionMap      basePtrs_for_instruction;
  ValueSet            allBasePtrs;

  friend struct BasePtrBuilder;
};

#endif // _BASE_PTR_INFO_H_
