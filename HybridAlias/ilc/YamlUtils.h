/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#pragma once

#include <llvm/IR/Value.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/BasicBlock.h>
#include "llvm/ADT/StringRef.h"         // for StringRef, operator==
#include <vector>
#include <string>
#include <map>
#include <set>

namespace llvm {
	class Value;
	class Function;
	class BasicBlock;
	class Instruction;
	class Module;
	class raw_ostream;

namespace yaml {
	class Input;
}
}

using BasePair = std::pair<llvm::Value*, llvm::Value*>;

struct AliasPairs {
	std::set<BasePair> should_alias_exact;
	std::set<BasePair> should_alias;
	std::set<BasePair> should_not_alias;

	size_t size() const
	{
		return should_alias_exact.size()
		     + should_alias.size()
		     + should_not_alias.size();
	}

	bool empty() const
	{
		return should_alias_exact.empty()
		    && should_alias.empty()
		    && should_not_alias.empty();
	}
};
struct AliasInfo {
	using LoopData = std::map<llvm::BasicBlock*, AliasPairs>;
	using Data     = std::map<llvm::Function*, LoopData>;

	static AliasInfo parseYaml(llvm::StringRef yaml, llvm::Module *m);

	AliasPairs* getAliasPairs(llvm::Function *fn, llvm::BasicBlock *header)
	{
		auto it1 = data.find(fn);

		if (it1 == data.end())
			return nullptr;

		auto it2 = it1->second.find(header);

		if (it2 == it1->second.end())
			return nullptr;

		return &it2->second;
	}

	AliasInfo()            = default;
	AliasInfo(AliasInfo&&) = default;
private:
	AliasInfo(const AliasInfo&) = delete;

	Data data;
};

struct InsertionPoint {
	InsertionPoint() : val{nullptr} {}
	InsertionPoint(llvm::Instruction *i) : val{i} {}
	InsertionPoint(llvm::BasicBlock  *b) : val{b} {}

	llvm::Instruction* toInstruction()
	{
		using namespace llvm;

		if (auto i = dyn_cast<Instruction>(val))
			return i;
		auto bb = cast<BasicBlock>(val);

		return bb->getFirstInsertionPt();
	}

	bool isBasicBlock()  const { return llvm::isa<llvm::BasicBlock>(val); }
	bool isInstruction() const { return llvm::isa<llvm::Instruction>(val); }

	llvm::Instruction *getInstruction()
	{
		return llvm::dyn_cast<llvm::Instruction>(val);
	}

	llvm::Value*       operator->()       { return val; }
	const llvm::Value* operator->() const { return val; }
private:
	llvm::Value *val;
};

/// Stores information on loop/region we performed cloning on.
/// These insertion points must be valid both in the original program
/// and the version with cloning.
class CloningInfo {
public:
	CloningInfo()
	 : function{nullptr}
	 , header{nullptr}
	{}

	CloningInfo(llvm::Function *f, llvm::BasicBlock *h, InsertionPoint start, InsertionPoint end)
	: function(f), header(h), start(start), end(end) {}

	/// Function containing the region
	llvm::Function *function;

	/// Header to uniquely identify loop
	llvm::BasicBlock *header;

	/// First instruction before the inserted checks
	InsertionPoint start;

	/// Unique exiting basic blocks of loop.
	InsertionPoint end;

	static std::vector<CloningInfo> parseYaml(llvm::StringRef yaml, llvm::Module *module);

	void writeYaml(llvm::raw_ostream &out) const;
};
