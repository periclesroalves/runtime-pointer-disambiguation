
#pragma once

#include "llvm/ADT/StringRef.h"         // for StringRef, operator==
#include <vector>

namespace llvm {

class Function;
class BasicBlock;
class Instruction;
class Module;
class raw_ostream;

namespace yaml {
	class Input;
}

/// Stores information on region we performed cloning on.
/// These insertion points must be valid both in the original program
/// and the version with cloning.
class RegionCloningInfo {
public:
	RegionCloningInfo()
	 : function{nullptr}
	 , guard_start{nullptr}
	 , guard_end{nullptr}
	 , entering_block{nullptr}
	 , exiting_block{nullptr}
	{}

	/// Function containing the region
	Function *function;

	/// First instruction before and last instruction after the inserted checks
	Instruction *guard_start, *guard_end;

	/// Unique entering and exiting basic blocks of region.
	/// These blocks must have exactly one successor/predecessor so they
	/// uniquely identify the region
	BasicBlock *entering_block, *exiting_block;

	static std::vector<RegionCloningInfo> parseYaml(StringRef yaml, Module *module);
	static void                           writeYaml(const std::vector<RegionCloningInfo>& regions, raw_ostream &out);
};


} // end namespace llvm
