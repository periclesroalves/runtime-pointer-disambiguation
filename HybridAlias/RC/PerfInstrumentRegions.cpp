
#include <assert.h>                     // for assert
#include <llvm/IR/ValueSymbolTable.h>   // for ValueSymbolTable
#include <stddef.h>                     // for size_t
#include <stdlib.h>                     // for exit
#include <sys/types.h>                  // for int32_t, int64_t
#include <memory>                       // for unique_ptr
#include <string>                       // for string, allocator, etc
#include <system_error>                 // for error_code
#include <type_traits>                  // for remove_reference<>::type
#include <utility>                      // for make_pair
#include <vector>                       // for vector
#include "llvm/ADT/APInt.h"             // for APInt
#include "llvm/ADT/ArrayRef.h"          // for ArrayRef
#include "llvm/ADT/StringMap.h"         // for StringMap, StringMapEntry, etc
#include "llvm/ADT/StringRef.h"         // for StringRef, operator==
#include "llvm/IR/Attributes.h"         // for AttrBuilder, Attribute, etc
#include "llvm/IR/BasicBlock.h"         // for BasicBlock, etc
#include "llvm/IR/CallingConv.h"        // for ::C
#include "llvm/IR/Constant.h"           // for Constant
#include "llvm/IR/Constants.h"          // for ConstantInt, ConstantArray, etc
#include "llvm/IR/DerivedTypes.h"       // for PointerType, ArrayType, etc
#include "llvm/IR/Function.h"           // for Function
#include "llvm/IR/GlobalValue.h"        // for GlobalValue, etc
#include "llvm/IR/GlobalVariable.h"     // for GlobalVariable
#include "llvm/IR/IRBuilder.h"          // for IRBuilder
#include "llvm/IR/Instructions.h"       // for CallInst, LoadInst
#include "llvm/IR/LLVMContext.h"        // for LLVMContext (ptr only), etc
#include "llvm/IR/Module.h"             // for Module, operator<<
#include "llvm/IR/OperandTraits.h"      // for ConstantArray::getOperand
#include "llvm/IR/Type.h"               // for Type
#include "llvm/IRReader/IRReader.h"     // for parseIR
#include "llvm/Support/Casting.h"       // for cast, dyn_cast
#include "llvm/Support/CommandLine.h"   // for desc, opt, initializer, etc
#include "llvm/Support/ErrorOr.h"       // for ErrorOr
#include "llvm/Support/FileSystem.h"    // for OpenFlags::F_Text
#include "llvm/Support/MemoryBuffer.h"  // for MemoryBuffer
#include "llvm/Support/SourceMgr.h"     // for SMDiagnostic
#include "llvm/Support/YAMLTraits.h"    // for IO, Input, operator>>, etc
#include "llvm/Support/raw_ostream.h"   // for raw_ostream, errs, etc

#define DEBUG_TYPE "perf-instrument-region"

//#define STATS

using namespace llvm;
using namespace llvm::yaml;
using namespace std;

namespace llvm {
namespace yaml {

// stores names of entry/exit blocks of region
// (both in the original program and the version with cloning)
struct YamlRegion {
	std::string function;

	// original version
	std::string entry;
	std::string exit;

	// version with cloning
	// std::string cloned_entry;
	// std::string cloned_exit;
};

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

template <>
struct MappingTraits<YamlRegion> {
	static void mapping(IO &io, YamlRegion& data) {
		io.mapRequired("function",     data.function);
		io.mapRequired("entry",        data.entry);
		io.mapRequired("exit",         data.exit);
		// io.mapRequired("cloned_entry", data.cloned_entry);
		// io.mapRequired("cloned_exit",  data.cloned_exit);
	}
};

} // end namespace yaml
} // end namespace llvm

cl::opt<string> original_ir_file{
	cl::Positional,
	cl::Required,
	cl::desc("<original IR file>"),
};
cl::opt<string> ir_file_with_cloning{
	cl::Positional,
	cl::Required,
	cl::desc("<IR file with cloning>"),
};
cl::opt<string> region_file{
	cl::Positional,
	cl::Required,
	cl::desc("<Region file>"),
};

cl::opt<bool> verify_regions{
	"verify-regions",
	cl::desc("Check if regions from region file are valid regions in the program"),
	cl::init(false),
};

static llvm::raw_ostream& fancy_errs(llvm::StringRef prefix = "error", llvm::raw_ostream::Colors color = raw_ostream::RED);

static std::unique_ptr<Module> parseIR(StringRef ir_file)
{
	auto buffer = MemoryBuffer::getFile(ir_file);

	if (std::error_code ec = buffer.getError()) {
		fancy_errs() << "Could not open IR file '" << ir_file << "': " << ec.message() << "\n";
		exit(1);
	}

	SMDiagnostic err;

	std::unique_ptr<Module> module = llvm::parseIR(buffer->get()->getMemBufferRef(), err, getGlobalContext());

	if (!module) {
		err.print("", errs());
		exit(1);
	}

	return module;
}

static ConstantInt *getConstI32(LLVMContext& ctx, int32_t value) {
	return ConstantInt::get(ctx, APInt(32, value));
}

static ConstantInt *getConstI64(LLVMContext& ctx, int64_t value) {
	return ConstantInt::get(ctx, APInt(64, value));
}

static Constant* getPointerTo(LLVMContext& ctx, GlobalValue *global) {
	ConstantInt* zero = getConstI64(ctx, 0);

	std::vector<Constant*> indices{zero, zero};

	return ConstantExpr::getGetElementPtr(global, indices);
}

/// Helper for creating string constants
struct StringBuilder {
	StringBuilder(Module *mod)
		: module{mod}
		, ctx{mod->getContext()}
	{}

	Constant* create(StringRef str)
	{
		assert(!str.empty() && "Tried to create empty string constant");

		auto global_entry = cache.find(str);

		if (global_entry != cache.end())
			return global_entry->second;

		// create global variable

		auto constant_data = ConstantDataArray::getString(ctx, str);

		auto global = new GlobalVariable{
			*module,
			constant_data->getType(),
			true,
			GlobalValue::PrivateLinkage,
			constant_data,
			".str"
		};
		global->setAlignment(1);

		// create pointer to start of global

		auto global_ptr = getPointerTo(ctx, global);

		cache.insert(make_pair(str, global_ptr));

		return global_ptr;
	}
private:
	Module              *module;
	LLVMContext&         ctx;
	StringMap<Constant*> cache;
};

static string removeSuffix(string str, string suffix);

int main(int argc, char **argv) {
	// **** HANDLE COMMAND LINE OPTIONS

	// ** hide all regular options

	StringMap<cl::Option*> options;
	cl::getRegisteredOptions(options);

	for (auto& mapping : options) {
		auto name   = mapping.first();
		auto option = mapping.second;

		if ((name == "help") || (name == "print-only") || (name == "program-type"))
			continue;

		option->setHiddenFlag(cl::Hidden);
	}

	// ** parse command line options

	cl::ParseCommandLineOptions(argc, argv, "Inserts performance profiling code for regions");

	// **** PARSE INPUT FILES

	// ** Parse the input LLVM IR file into a module.

	std::unique_ptr<Module> original_module     = parseIR(original_ir_file);
	std::unique_ptr<Module> module_with_cloning = parseIR(ir_file_with_cloning);

	// ** Parse the YAML region list

	vector<YamlRegion> regions;

	{
		auto file = MemoryBuffer::getFile(region_file);

		if (auto error = file.getError()) {
			fancy_errs() << "Could not open region list file '" << region_file << "': " << error.message() << "\n";
			exit(1);
		}

		Input input{file.get()->getBuffer()};

		input >> regions;

		if (auto error = input.error()) {
			fancy_errs() << "Could not parse region list file '" << region_file << "': " << error.message() << "\n";
			exit(1);
		}
	}

	// **** VALIDATE INPUT

	// run through all regions and check if their entry/exit blocks exist
	// optionally also builds the region graph and checks if regions are valid

	struct ProfilingPoint {
		Function *function;

		BasicBlock *entry;
		BasicBlock *exit;
	};

	vector<ProfilingPoint> original_profiling_points;
	vector<ProfilingPoint> cloned_profiling_points;

	for (auto region : regions)
	{
		auto original_function     = original_module->getFunction(region.function);
		auto function_with_cloning = module_with_cloning->getFunction(region.function);

		if (!original_function || !function_with_cloning)
		{
			fancy_errs() << "function '" << region.function << "' from region file could not be found\n";
			exit(1);
		}

		auto get_bb = [&](Function *function, StringRef name) {
			auto value = function->getValueSymbolTable().lookup(name);

			if (!value)
			{
				fancy_errs() << "in function '" << region.function << "': basic block '" << name << "' from region file could not be found\n";
				exit(1);
			}

			auto bb = dyn_cast<BasicBlock>(value);

			if (!bb)
			{
				fancy_errs() << "In function '" << region.function << "': '" << name << "' from region file is not a basic block!\n";
				exit(1);
			}

			return bb;
		};

		auto entry        = get_bb(original_function,     region.entry);
		auto exit         = get_bb(original_function,     region.exit);
		auto cloned_entry = get_bb(function_with_cloning, region.entry);
		auto cloned_exit  = get_bb(function_with_cloning, region.exit);

		// TODO: verify that the region really exists in the IR and is valid

		original_profiling_points.push_back({
			original_function,
			entry, exit,
		});
		cloned_profiling_points.push_back({
			function_with_cloning,
			cloned_entry, cloned_exit
		});
	}

	// **** INSTRUMENT CODE

	auto instrument = [&](Module *module, vector<ProfilingPoint>& profiling_points) {
		StringBuilder strings{module};

		// Type Definitions
		LLVMContext& ctx = module->getContext();

		Type*        void_ty   = Type::getVoidTy(ctx);
		Type*        i8_ty     = Type::getInt8Ty(ctx);
		Type*        i32_ty    = Type::getInt32Ty(ctx);
		Type*        i64_ty    = Type::getInt64Ty(ctx);
		PointerType* i8_ptr_ty = Type::getInt8PtrTy(ctx);

		ArrayType*   char_array_4_ty     = ArrayType::get(i8_ty, 4);
		PointerType* char_array_4_ptr_ty = PointerType::get(char_array_4_ty, 0);

		std::vector<Type*> ProfilePoint_ty_fields{
			i8_ptr_ty,
			i8_ptr_ty,
			i64_ty,
		};
		StructType  *ProfilePoint_ty     = StructType::create(ProfilePoint_ty_fields, "struct.ProfilePoint");
		PointerType *ProfilePoint_ptr_ty = PointerType::get(ProfilePoint_ty, 0);

		// ** create global array to store profiling data

		ArrayType*   ProfilePoint_array_ty     = ArrayType::get(ProfilePoint_ty, profiling_points.size());
		PointerType* ProfilePoint_array_ptr_ty = PointerType::get(ProfilePoint_array_ty, 0);

		vector<Constant*> ProfilePoint_array_elements;

		auto zero = getConstI64(ctx, 0);

		for (auto& pp : profiling_points)
		{
			Constant *fields[3] = {
				strings.create(pp.function->getName()),
				strings.create(pp.entry->getName()),
				zero
			};

			ProfilePoint_array_elements.push_back(
				ConstantStruct::get(ProfilePoint_ty, fields)
			);
		}

		auto ProfilePoints_array = ConstantArray::get(ProfilePoint_array_ty, ProfilePoint_array_elements);

		auto num_profile_points = getConstI64(ctx, profiling_points.size());

		GlobalVariable* gvar_array_profile_points = new GlobalVariable{
			*module,
			ProfilePoint_array_ty,
			false,
			GlobalValue::InternalLinkage,
			ProfilePoints_array,
			"profile_points"
		};
		gvar_array_profile_points->setAlignment(16);

		// ** INSERT ACTUAL PROFILING CODE

		// declare i64 @llvm.readcyclecounter()

		Function* llvm_readcyclecounter = Function::Create(
			FunctionType::get(i64_ty, false),
			GlobalValue::ExternalLinkage,
			"llvm.readcyclecounter",
			module
		);

		// get time at entry/exit, update counter slot

		size_t slot_num = 0;

		for (auto pp : profiling_points)
		{
			assert(pp.entry->size());

			IRBuilder<> irb_entry{pp.entry, --pp.entry->end()};

			auto start_time = irb_entry.CreateCall(llvm_readcyclecounter);

			IRBuilder<> irb_exit{pp.exit, pp.exit->getFirstInsertionPt()};

			auto stop_time = irb_exit.CreateCall(llvm_readcyclecounter);
			auto time      = irb_exit.CreateSub(stop_time, start_time, "time");

			ConstantInt* zero         = getConstI64(ctx, 0);
			ConstantInt* slot_offset  = getConstI64(ctx, slot_num);
			ConstantInt* count_offset = getConstI32(ctx, 2);

			std::vector<Constant*> indices{zero, slot_offset, count_offset};

			auto slot = ConstantExpr::getGetElementPtr(gvar_array_profile_points, indices);

			auto old_count = irb_exit.CreateLoad(slot, "old_count");
			auto new_count = irb_exit.CreateAdd(old_count, time, "new_count");

			irb_exit.CreateStore(new_count, slot);

			slot_num++;
		}

		// ** GLOBAL DESTRUCTOR THAT CREATES PROFILING SUMMARY

		// Function Declarations

		std::vector<Type*>perf_printSummary_ty_args{
			i8_ptr_ty,
			i64_ty,
			ProfilePoint_ptr_ty,
		};
		FunctionType* perf_printSummary_ty = FunctionType::get(
			void_ty,
			perf_printSummary_ty_args,
			false
		);

		FunctionType* global_dtor_fn_ty     = FunctionType::get(void_ty, false);
		PointerType*  global_dtor_fn_ptr_ty = PointerType::get(global_dtor_fn_ty, 0);

		Function* func_perf_printSummary_dtor = Function::Create(
			global_dtor_fn_ty,
			GlobalValue::ExternalLinkage,
			"perf_printSummary_dtor",
			module
		);
		func_perf_printSummary_dtor->setCallingConv(CallingConv::C);

		Function* func_perf_printSummary = Function::Create(
			perf_printSummary_ty,
			GlobalValue::ExternalLinkage,
			"perf_printSummary",
			module
		); // (external, no body)
		func_perf_printSummary->setCallingConv(CallingConv::C);

		{
			AttrBuilder B;
			B.addAttribute(Attribute::NoUnwind);
			B.addAttribute(Attribute::UWTable);

			func_perf_printSummary->setAttributes(AttributeSet::get(ctx, ~0, B));
			func_perf_printSummary_dtor->setAttributes(AttributeSet::get(ctx, ~0, B));
		}

		std::vector<Type*> global_dtor_ty_fields{i32_ty, global_dtor_fn_ptr_ty, i8_ptr_ty};

		StructType *global_dtor_ty = StructType::get(ctx, global_dtor_ty_fields, false);

		ArrayType*   global_dtor_array_ty     = ArrayType::get(global_dtor_ty, 1);
		PointerType* global_dtor_array_ptr_ty = PointerType::get(global_dtor_array_ty, 0);

		std::vector<Constant*> perf_printSummary_dtor_fields{
			getConstI32(ctx, 65535),
			func_perf_printSummary_dtor,
			ConstantExpr::getBitCast(getPointerTo(ctx, gvar_array_profile_points), i8_ptr_ty),
		};

		// Construct the new element we'll be adding.
		auto global_dtor = ConstantStruct::get(global_dtor_ty, perf_printSummary_dtor_fields);

		// If llvm.global_dtors exists, make a copy of the things in its list and
		// delete it, to replace it with one that has a larger array type.
		vector<Constant*> dtors;

		if (GlobalVariable *global_dtors = module->getNamedGlobal("llvm.global_dtors")) {
			ConstantArray *InitList = cast<ConstantArray>(global_dtors->getInitializer());

			for (unsigned i = 0, e = InitList->getType()->getNumElements(); i != e; ++i)
				dtors.push_back(cast<Constant>(InitList->getOperand(i)));
			global_dtors->eraseFromParent();
		}

		// Build up llvm.global_dtors with our new item in it.
		dtors.push_back(global_dtor);

		auto global_dtors_array_ty = ArrayType::get(global_dtor_ty, dtors.size());

		GlobalVariable *global_dtors = new GlobalVariable{
			*module,
			global_dtors_array_ty,
			false,
			GlobalValue::AppendingLinkage,
			ConstantArray::get(global_dtors_array_ty, dtors),
			"llvm.global_dtors"
		};

		// Function Definitions

		// Function: perf_printSummary_dtor (func_perf_printSummary_dtor)
		{
			BasicBlock* entry = BasicBlock::Create(ctx, "entry", func_perf_printSummary_dtor, 0);

			AttrBuilder B;
			B.addAttribute(Attribute::NoUnwind);

			IRBuilder<> irb{entry};

			CallInst* call = irb.CreateCall3(
				func_perf_printSummary,
				strings.create(module->getModuleIdentifier()),
				num_profile_points,
				getPointerTo(ctx, gvar_array_profile_points)
			);
			call->setCallingConv(CallingConv::C);
			call->setTailCall(true);
			call->setAttributes(AttributeSet::get(ctx, ~0, B));

			irb.CreateRetVoid();
		}

	};

	instrument(original_module.get(),     original_profiling_points);
	instrument(module_with_cloning.get(), cloned_profiling_points);

	auto write_module = [](string path, string banner, Module *mod) {
		error_code err;

		raw_fd_ostream file{path, err, sys::fs::F_Text};

		if (err) {
			fancy_errs() << "Could not open file '" << path << "' for writing\n";
			exit(1);
		}

		file << banner << *mod;
	};

	write_module(
		removeSuffix(original_ir_file, ".ll") + ".cpuperf.ll",
		"; GCG CPU perf instrumented",
		original_module.get()
	);
	write_module(
		removeSuffix(ir_file_with_cloning, ".ll") + ".cpuperf.ll",
		"; GCG CPU perf instrumented",
		module_with_cloning.get()
	);

	return 0;
}

static string removeSuffix(string str, string suffix)
{
	size_t pos = str.rfind(suffix);

	if (pos == string::npos)
		return str;

	return str.substr(0, pos);
}

static llvm::raw_ostream& fancy_errs(StringRef prefix, raw_ostream::Colors color)
{
	raw_ostream& stream = errs();

	if (prefix.size())
	{
		stream.changeColor(color, true);
		stream << "error";
		stream.resetColor();
		stream << ": ";
	}

	return stream;
}
