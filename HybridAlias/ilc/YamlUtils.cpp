/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include "ilc/YamlUtils.h"
#include <llvm/Transforms/Utils/FullInstNamer.h>
#include "ilc/Common.h"

#include "llvm/IR/Function.h"           // for Function
#include "llvm/IR/Instructions.h"       // for CallInst, LoadInst
#include "llvm/IR/Module.h"             // for Module, operator<<
#include "llvm/IR/ValueSymbolTable.h"   // for ValueSymbolTable
#include "llvm/Support/YAMLTraits.h"    // for IO, Input, operator>>, etc
#include "llvm/Support/raw_ostream.h"   // for raw_ostream, errs, etc
#include "llvm/Support/Debug.h"

using namespace llvm;
using namespace ilc;

#define DEBUG_TYPE "yaml-utils"

/// if you have to ask, ... don't
template<typename T>
using Ptr = T*;

struct YamlContext {
	YamlContext(Module *m) : module{m}, function{nullptr} {}

	Module   *const module;
	Function       *function;
};

namespace llvm {
namespace yaml {

template<>
struct ScalarTraits<Ptr<Function>> {
	/// Function to convert a string to a value.  Returns the empty
	/// StringRef on success or an error string if string is malformed:
	static StringRef input(StringRef scalar, void *ctxt, Ptr<Function>& value)
	{
		assert(ctxt);
		YamlContext *yaml = reinterpret_cast<YamlContext*>(ctxt);

		assert(yaml->module);
		auto function = yaml->module->getFunction(scalar);

		if (!function)
			return "could not find function";

		value = function;
		return StringRef{};
	}

	static void output(const Ptr<Function> &val, void*, llvm::raw_ostream &out)
	{
		out << val->getName();
	}

	static bool mustQuote(StringRef) { return true; }
};

template<>
struct ScalarTraits<Ptr<BasicBlock>> {
	/// Function to convert a string to a value.  Returns the empty
	/// StringRef on success or an error string if string is malformed:
	static StringRef input(StringRef scalar, void *ctxt, Ptr<BasicBlock> &value)
	{
		assert(ctxt);
		YamlContext *yaml = reinterpret_cast<YamlContext*>(ctxt);

		assert(yaml->function);
		auto obj = FullInstNamer::lookup(yaml->function, scalar);

		if (!obj)
			return "basic block does not exist";

		auto bb = dyn_cast<BasicBlock>(obj);

		if (!bb)
			return "value is not a basic block";

		value = bb;
		return StringRef{};
	}

	static void output(const Ptr<BasicBlock> &val, void*, llvm::raw_ostream &out) {
		out << val->getName();
	}

	static bool mustQuote(StringRef) { return true; }
};

} // end namespace yaml
} // end namespace llvm

//*******************************************************************
// ***** ALIAS INFO

enum class AliasStatus {
	ShouldAliasExact,  // base ptrs are equal
	ShouldAlias,       // base ptrs point to same malloc
	ShouldNotAlias,    // base ptrs don't point to same malloc
};

struct AliasTrace {
	Value *ptr1;
	Value *ptr2;
	AliasStatus alias;
};
struct LoopTrace {
	Function               *function;
	BasicBlock             *loop_header;
	std::vector<AliasTrace> alias_pairs;
};

// static AliasInfo parseYaml(StringRef yaml, Module *m);

namespace llvm {
namespace yaml {

template<>
struct ScalarTraits<Ptr<Value>> {
	/// Function to convert a string to a value.  Returns the empty
	/// StringRef on success or an error string if string is malformed:
	static StringRef input(StringRef scalar, void *ctxt, Ptr<Value> &value)
	{
		assert(ctxt);
		YamlContext *yaml = reinterpret_cast<YamlContext*>(ctxt);

		assert(yaml->function);
		auto val = FullInstNamer::lookup(yaml->function, scalar);

		if (!val)
			return "value does not exist";

		value = val;
		return StringRef{};
	}

	static void output(const Ptr<Value> &val, void*, llvm::raw_ostream &out)
	{
		out << val->getName();
	}

	static bool mustQuote(StringRef) { return true; }
};

template <>
struct ScalarEnumerationTraits<AliasStatus> {
	static void enumeration(IO &io, AliasStatus &value) {
		io.enumCase(value, "should-alias",       AliasStatus::ShouldAlias);
		io.enumCase(value, "should-alias-exact", AliasStatus::ShouldAliasExact);
		io.enumCase(value, "should-not-alias",   AliasStatus::ShouldNotAlias);
	}
};

template <>
struct MappingTraits<AliasTrace> {
	static void mapping(IO &io, AliasTrace& data) {
		// DBG("MappingTraits<AliasTrace>::mapping");

		io.mapRequired("ptr1",  data.ptr1);
		io.mapRequired("ptr2",  data.ptr2);
		io.mapRequired("alias", data.alias);
	}
};

template <>
struct MappingTraits<LoopTrace> {
	static void mapping(IO &io, LoopTrace& data) {
		void *ctxt = io.getContext();
		assert(ctxt);
		YamlContext *yaml = reinterpret_cast<YamlContext*>(ctxt);

		io.mapRequired("function", data.function);

		yaml->function = data.function;

		io.mapRequired("loop",        data.loop_header);
		io.mapRequired("alias_pairs", data.alias_pairs);

		yaml->function = nullptr;
	}
};

} // end namespace yaml
} // end namespace llvm

LLVM_YAML_IS_SEQUENCE_VECTOR(AliasTrace)
LLVM_YAML_IS_DOCUMENT_LIST_VECTOR(LoopTrace)

AliasInfo AliasInfo::parseYaml(llvm::StringRef yaml, llvm::Module *module)
{
	DBG("AliasInfo::parseYaml");

	YamlContext ctx{module};

	std::vector<LoopTrace> trace;

	yaml::Input input{yaml, (void*) &ctx};

	input >> trace;

	DBG("read " << trace.size() << " loop traces");

	if (auto error = input.error()) {
		ERR("Could not parse alias trace: " << error.message());
		exit(1);
	}

	DBG("creating map");

	AliasInfo ai;

	for (auto& loop : trace) {
		DBG("loop " << loop.function->getName() << " " << loop.loop_header->getName());
		DBG("\t" << loop.alias_pairs.size() << " alias pairs");

		auto& loop_data = ai.data[loop.function];

		assert(loop_data.find(loop.loop_header) == loop_data.end());

		auto& pairs = loop_data[loop.loop_header];

		for (AliasTrace& pair : loop.alias_pairs) {
			switch (pair.alias) {
				case AliasStatus::ShouldAliasExact:
					pairs.should_alias_exact.insert(orderedPair(pair.ptr1, pair.ptr2));
					break;
				case AliasStatus::ShouldAlias:
					pairs.should_alias.insert(orderedPair(pair.ptr1, pair.ptr2));
					break;
				case AliasStatus::ShouldNotAlias:
					pairs.should_not_alias.insert(orderedPair(pair.ptr1, pair.ptr2));
					break;
				default:
					llvm_unreachable("Invalid AliasStatus");
			}
		}
	}

	return ai;
}

//*******************************************************************
// ***** CLONING INFO

namespace llvm {
namespace yaml {

template<>
struct ScalarTraits<InsertionPoint> {
	/// Function to convert a string to a value.  Returns the empty
	/// StringRef on success or an error string if string is malformed:
	static StringRef input(StringRef scalar, void *ctxt, InsertionPoint &value)
	{
		assert(ctxt);
		YamlContext *yaml = reinterpret_cast<YamlContext*>(ctxt);

		assert(yaml->function);
		auto obj = FullInstNamer::lookup(yaml->function, scalar);

		if (!obj)
			return "insertion point does not exist";

		if (auto inst = dyn_cast<Instruction>(obj)) {
			value = inst;
			return StringRef{};
		}

		if (auto bb = dyn_cast<BasicBlock>(obj)) {
			value = bb;
			return StringRef{};
		}

		return "insertion point is neither an instruction nor a basic block";
	}

	static void output(const InsertionPoint &val, void*, llvm::raw_ostream &out)
	{
		out << val->getName();
	}

	static bool mustQuote(StringRef) { return true; }
};

template <>
struct MappingTraits<CloningInfo> {
	static void mapping(IO &io, CloningInfo& data) {
		void *ctxt = io.getContext();
		assert(ctxt);
		YamlContext *yaml = reinterpret_cast<YamlContext*>(ctxt);

		io.mapRequired("function", data.function);

		yaml->function = data.function;

		io.mapRequired("header", data.header);
		io.mapRequired("start",  data.start);
		io.mapRequired("end",    data.end);

		yaml->function = nullptr;
	}
};

} // end namespace yaml
} // end namespace llvm

LLVM_YAML_IS_DOCUMENT_LIST_VECTOR(CloningInfo)

std::vector<CloningInfo> CloningInfo::parseYaml(StringRef yaml, Module *module)
{
	YamlContext ctx{module};

	std::vector<CloningInfo> regions;

	yaml::Input input{yaml, (void*) &ctx};

	input >> regions;

	if (auto error = input.error()) {
		errs() << "Could not parse region cloning list: " << error.message() << "\n";
		exit(1);
	}

	return std::move(regions);
}

void CloningInfo::writeYaml(raw_ostream &out) const
{
	YamlContext ctx{nullptr};

	yaml::Output output{out, (void*) &ctx};

	output << *const_cast<CloningInfo*>(this);
}

