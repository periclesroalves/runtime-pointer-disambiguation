
#include "llvm/Transforms/Utils/RegionCloningYaml.h"

#include "llvm/IR/Function.h"           // for Function
#include "llvm/IR/Instructions.h"       // for CallInst, LoadInst
#include "llvm/IR/Module.h"             // for Module, operator<<
#include "llvm/IR/ValueSymbolTable.h"   // for ValueSymbolTable
#include "llvm/Transforms/Utils/FullInstNamer.h"
#include "llvm/Support/YAMLTraits.h"    // for IO, Input, operator>>, etc
#include "llvm/Support/raw_ostream.h"   // for raw_ostream, errs, etc

using namespace llvm;

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

template<typename T>
struct SequenceTraits<std::vector<T>> {
	static size_t size(IO& io, std::vector<T>& seq) {
		return seq.size();
	}
	static T& element(IO& io, std::vector<T>& seq, size_t index) {
		if (index >= seq.size())
			seq.resize(index+1);
		return seq[index];
	}
};

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

template<>
struct ScalarTraits<Ptr<Instruction>> {
	/// Function to convert a string to a value.  Returns the empty
	/// StringRef on success or an error string if string is malformed:
	static StringRef input(StringRef scalar, void *ctxt, Ptr<Instruction> &value)
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
			value = bb->getFirstInsertionPt();
			return StringRef{};
		}

		return "insertion point is neither an instruction nor a basic block";
	}

	static void output(const Ptr<Instruction> &val, void*, llvm::raw_ostream &out)
	{
		out << val->getName();
	}

	static bool mustQuote(StringRef) { return true; }
};

template <>
struct MappingTraits<RegionCloningInfo> {
	static void mapping(IO &io, RegionCloningInfo& data) {
		void *ctxt = io.getContext();
		assert(ctxt);
		YamlContext *yaml = reinterpret_cast<YamlContext*>(ctxt);

		io.mapRequired("function", data.function);

		yaml->function = data.function;

		io.mapRequired("guard_start",    data.guard_start);
		io.mapRequired("guard_end",      data.guard_end);
		io.mapRequired("entering_block", data.entering_block);
		io.mapRequired("exiting_block",  data.exiting_block);

		yaml->function = nullptr;
	}
};

} // end namespace yaml
} // end namespace llvm

std::vector<RegionCloningInfo> RegionCloningInfo::parseYaml(StringRef yaml, Module *module)
{
	YamlContext ctx{module};

	std::vector<RegionCloningInfo> regions;

	yaml::Input input{yaml, (void*) &ctx};

	input >> regions;

	if (auto error = input.error()) {
		errs() << "Could not parse region cloning list: " << error.message() << "\n";
		exit(1);
	}

	return regions;
}


void RegionCloningInfo::writeYaml(const std::vector<RegionCloningInfo>& regions, raw_ostream &out)
{
	YamlContext ctx{nullptr};

	yaml::Output output{out, (void*) &ctx};

	// can't declare yaml traits for const vector, ARG!
	output << const_cast<std::vector<RegionCloningInfo>&>(regions);
}

