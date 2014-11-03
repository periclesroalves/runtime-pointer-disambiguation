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
typedef std::map<llvm::Instruction*, ValueSet*>           InstructionMap;

class BasePtrInfo
{
  const llvm::BasicBlock* const entry;
  const llvm::DominatorTree&    domTree;
  llvm::AliasAnalysis&          aliasAnalysis;
  std::set<ValuePair>           basePtrPairs;
  InstructionMap                basePtrs_for_instruction;
  ValueSet                      allBasePtrs;

  ValueSet&                     getOrInsertBasePtrs(llvm::Instruction *i);
  void                          getBasePtrs(llvm::Value *ptr, ValueSet& basePtrs, ValueSet& visited);
  bool                          mayReadOrWriteMemory(llvm::Instruction *i);
  llvm::AliasAnalysis::Location getLocation(llvm::Instruction *i);
  void                          buildInfo(std::list<llvm::Instruction*>& mem_instrs);
  void                          rebuildAllBasePtrs();

  public:

  BasePtrInfo(llvm::Loop*   loop,   llvm::DominatorTree& tree, llvm::AliasAnalysis& aa);
  BasePtrInfo(llvm::Region* region, llvm::DominatorTree& tree, llvm::AliasAnalysis& aa);

  ~BasePtrInfo();

  void                 filter(const std::set<ValuePair>& badPairs);
  std::set<ValuePair>& getBasePtrPairs();
  ValueSet&            getBasePtrs(llvm::Instruction *i);
  const ValueSet&      getAllBasePtrs() const;
  InstructionMap&      getInstructionMap();
};

#endif // _BASE_PTR_INFO_H_
