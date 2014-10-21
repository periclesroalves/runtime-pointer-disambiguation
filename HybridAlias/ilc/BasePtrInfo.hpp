
#ifndef GCG_BASE_PTR_INFO_HPP_
#define GCG_BASE_PTR_INFO_HPP_

#include <llvm/Pass.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Support/Debug.h>
#include <map>
#include <set>
#include <utility>

namespace llvm {
	class AliasAnalysis;
	class Value;
}

using BasePtrPair = std::pair<llvm::Value*, llvm::Value*>;
using BasePtrSet  = std::set<llvm::Value*>;

/// all base ptrs and related data for a code region
struct BasePtrInfo {
	using InstructionMap = std::map<llvm::Instruction*, std::set<llvm::Value*>>;

	static BasePtrInfo compute(llvm::Loop*          loop,
	                           llvm::DominatorTree& tree,
	                           llvm::AliasAnalysis& aa);

	BasePtrInfo();

	const std::set<llvm::Value*>& getAllBasePtrs();
	const std::set<BasePtrPair>&  getBasePtrPairs();
	const std::set<llvm::Value*>& getBasePtrsForInstruction(const llvm::Instruction *i);

	InstructionMap::iterator begin() { return basePtrs_for_instruction.begin(); }
	InstructionMap::iterator end()   { return basePtrs_for_instruction.end(); }

	/// remove all data for the given set of base ptr pairs
	void filter(const std::set<BasePtrPair>& badPairs);
private:
	bool dirty; // need to recompute allBasePtrs
	std::set<llvm::Value*> allBasePtrs;
	std::set<BasePtrPair>  basePtrPairs;
	InstructionMap         basePtrs_for_instruction;

	friend struct BasePtrBuilder;
};

#endif // GCG_BASE_PTR_INFO_HPP_
