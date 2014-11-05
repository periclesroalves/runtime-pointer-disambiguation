
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
#include "llvm/Support/Debug.h"
#include "llvm/IR/TypeBuilder.h"
#include "llvm/Transforms/Utils/FullInstNamer.h"
#include "llvm/Transforms/Utils/RegionCloningYaml.h"

#include "perflib.h"

#define DEBUG_TYPE "perf-instrument-region"

//#define STATS

using namespace llvm;
using namespace std;

cl::opt<string> original_ir_file{
	cl::Positional,
	cl::Required,
	cl::desc("<original IR file>"),
};
cl::opt<string> modified_ir_file{
	cl::Positional,
	cl::Required,
	cl::desc("<modified IR file>"),
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

static llvm::raw_ostream& fancy_errs();
static llvm::raw_ostream& fancy_dbgs();

/// Get successor of instruction, unless the instruction is a terminator.
/// In that case return the instruction itself
static Instruction* nextInsertionPoint(Instruction*);

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

static ConstantInt *getConstI(LLVMContext& ctx, unsigned bit_width, uint64_t value) {
	return ConstantInt::get(ctx, APInt(bit_width, value));
}

static ConstantInt *getConstSizeT(LLVMContext& ctx, size_t value) {
	return ConstantInt::get(TypeBuilder<size_t, false>::get(ctx), value);
}

static ConstantInt *getConstI32(LLVMContext& ctx, uint32_t value) {
	return getConstI(ctx, 32, value);
}

static ConstantInt *getConstI64(LLVMContext& ctx, uint64_t value) {
	return getConstI(ctx, 64, value);
}

static Constant* getPointerTo(LLVMContext& ctx, GlobalValue *global) {
	ConstantInt* zero = getConstI64(ctx, 0);

	std::vector<Constant*> indices{zero, zero};

	return ConstantExpr::getInBoundsGetElementPtr(global, indices);
}

/// sanity check for layout of struct ProfilingData in C and LLVM
static void checkProfilingDataStructLayout(const DataLayout *dl, StructType *pp_ty);

/// Helper for creating string constants
struct GlobalStringBuilder {
	GlobalStringBuilder(Module *mod)
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

static void emitIncrementProfileData(LLVMContext& ctx, IRBuilder<>& irb, Constant *profile_data, uint32_t field, Value *increment)
{
	DEBUG(fancy_dbgs() << "\t\t\t\tincrementing profile data field " << field << "\n");

	std::vector<Constant*> indices{getConstI64(ctx, 0), getConstI32(ctx, field)};

	Constant *field_ptr = ConstantExpr::getInBoundsGetElementPtr(profile_data, indices);

	auto old_val = irb.CreateLoad(field_ptr, "old_val");
	auto new_val = irb.CreateAdd(old_val, increment, "new_val");

	irb.CreateStore(new_val, field_ptr);
}

int main(int argc, char **argv) {
	if (argc < 1)
		return 1;

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

	std::unique_ptr<Module> original_module = parseIR(original_ir_file);
	std::unique_ptr<Module> modified_module = parseIR(modified_ir_file);

	// ** Parse the YAML region list

	vector<RegionCloningInfo> original_regions;
	vector<RegionCloningInfo> modified_regions;

	{
		auto file_or_error = MemoryBuffer::getFile(region_file);

		if (auto error = file_or_error.getError()) {
			fancy_errs() << "Could not open region list file '" << region_file << "': " << error.message() << "\n";
			exit(1);
		}

		auto file = std::move(file_or_error.get());

		original_regions = RegionCloningInfo::parseYaml(file.get()->getBuffer(), original_module.get());
		modified_regions = RegionCloningInfo::parseYaml(file.get()->getBuffer(), modified_module.get());
	}

	assert(original_regions.size() == modified_regions.size());

	DEBUG(fancy_dbgs() << "got " << original_regions.size() << " region(s)\n");

	// **** VALIDATE INPUT

	// TODO: optionally build the region graph and checks if regions are valid

	// **** INSTRUMENT CODE

	FullInstNamer fin;

	auto instrument = [&](Module *module, vector<RegionCloningInfo>& regions) {
		DEBUG(fancy_dbgs() << "Instrumenting " << module->getModuleIdentifier() << "\n");

		GlobalStringBuilder strings{module};

		// ** Type Definitions
		DEBUG(fancy_dbgs() << "\tCreating LLVM types\n");

		LLVMContext& ctx = module->getContext();

		Type*        void_ty   = Type::getVoidTy(ctx);
		Type*        i32_ty    = Type::getInt32Ty(ctx);
		Type*        i64_ty    = Type::getInt64Ty(ctx);
		PointerType* i8_ptr_ty = Type::getInt8PtrTy(ctx);

		Type *const_char_ptr_ty = TypeBuilder<const char*, false>::get(ctx);
		Type *size_t_ty         = TypeBuilder<size_t,      false>::get(ctx);

		std::vector<Type*> ProfilingData_ty_fields{
			const_char_ptr_ty,
			const_char_ptr_ty,
			size_t_ty,
			size_t_ty,
			size_t_ty,
			size_t_ty,
		};
		StructType  *ProfilingData_ty     = StructType::create(ProfilingData_ty_fields, "struct.ProfilingData");
		PointerType *ProfilingData_ptr_ty = PointerType::get(ProfilingData_ty, 0);

		checkProfilingDataStructLayout(module->getDataLayout(), ProfilingData_ty);

		// ** create global array to store profiling data

		DEBUG(fancy_dbgs() << "\tCreating llvm.global.dtors array\n");

		ArrayType* ProfilingData_array_ty = ArrayType::get(ProfilingData_ty, regions.size());

		vector<Constant*> ProfilingData_array_elements;

		auto zero = getConstI64(ctx, 0);

		for (auto& region : regions)
		{
			vector<Constant*> fields = {
				strings.create(fin.getNameOrFail(argv[0], region.function)),
				strings.create(fin.getNameOrFail(argv[0], region.entering_block)),
				zero,
				zero,
				zero,
				zero,
			};

			assert(ProfilingData_ty_fields.size() == fields.size());

			ProfilingData_array_elements.push_back(
				ConstantStruct::get(ProfilingData_ty, fields)
			);
		}

		auto ProfilingDatas_array = ConstantArray::get(ProfilingData_array_ty, ProfilingData_array_elements);

		auto num_profile_points = getConstI64(ctx, regions.size());

		GlobalVariable* gvar_array_ProfileData = new GlobalVariable{
			*module,
			ProfilingData_array_ty,
			false,
			GlobalValue::InternalLinkage,
			ProfilingDatas_array,
			"profile_points"
		};
		gvar_array_ProfileData->setAlignment(16);

		// ** INSERT ACTUAL PROFILING CODE

		DEBUG(fancy_dbgs() << "\tInserting profiling code\n");

		// declare i64 @llvm.readcyclecounter()

		Function* llvm_readcyclecounter = Function::Create(
			FunctionType::get(i64_ty, false),
			GlobalValue::ExternalLinkage,
			"llvm.readcyclecounter",
			module
		);

		// insert timing code

		size_t slot_num = 0;

		for (auto& region : regions)
		{
			DEBUG(fancy_dbgs() << "\t\tregion: " << region.function->getName() << "::" << region.entering_block->getName() << "\n");

			assert(region.entering_block->size());

			/// index into global array storing the profiling data

			DEBUG(fancy_dbgs() << "\t\t\tindex into ProfileData table\n");

			ConstantInt* zero        = getConstI64(ctx, 0);
			ConstantInt* slot_offset = getConstI64(ctx, slot_num);

			std::vector<Constant*> indices{zero, slot_offset};

			auto profile_data = ConstantExpr::getInBoundsGetElementPtr(gvar_array_ProfileData, indices);

			/// time guard code

			DEBUG(fancy_dbgs() << "\t\t\ttime guard code\n");

			auto guard_start = nextInsertionPoint(region.guard_start);
			auto guard_end   = region.guard_end;

			assert(guard_start);
			assert(guard_start->getParent());
			assert(guard_end);
			assert(guard_end->getParent());

			IRBuilder<> irb{guard_start->getParent(), guard_start};

			// fancy_dbgs() << *(region.guard_start) << "\n";

			auto guard_start_time = irb.CreateCall(llvm_readcyclecounter);

			irb.SetInsertPoint(guard_end->getParent(), guard_end);

			auto guard_stop_time = irb.CreateCall(llvm_readcyclecounter);
			auto guard_time      = irb.CreateSub(guard_stop_time, guard_start_time, "guard_time");

			emitIncrementProfileData(ctx, irb, profile_data, 2, getConstSizeT(ctx, 1));
			emitIncrementProfileData(ctx, irb, profile_data, 3, guard_time);

			// time region body

			DEBUG(fancy_dbgs() << "\t\t\ttime region body\n");

			// fancy_dbgs() << *region.function << "\n";

			auto entering_terminator = region.entering_block->getTerminator();
			auto exiting_point       = region.exiting_block->getFirstInsertionPt();

			assert(entering_terminator);
			assert(entering_terminator->getParent());
			assert(exiting_point);
			assert(exiting_point->getParent());

			irb.SetInsertPoint(entering_terminator->getParent(), entering_terminator);

			auto region_start_time = irb.CreateCall(llvm_readcyclecounter);

			irb.SetInsertPoint(exiting_point->getParent(), exiting_point);

			auto region_stop_time = irb.CreateCall(llvm_readcyclecounter);
			auto region_time      = irb.CreateSub(region_stop_time, region_start_time, "region_time");

			emitIncrementProfileData(ctx, irb, profile_data, 4, getConstSizeT(ctx, 1));
			emitIncrementProfileData(ctx, irb, profile_data, 5, region_time);

			// advance to next profile data slot

			slot_num++;
		}

		// ** GLOBAL DESTRUCTOR THAT CREATES PROFILING SUMMARY

		DEBUG(fancy_dbgs() << "\t\tadd global ctor that creates profiling summary\n");

		// Function Declarations

		std::vector<Type*>perf_printSummary_ty_args{
			i8_ptr_ty,
			i64_ty,
			ProfilingData_ptr_ty,
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

		std::vector<Constant*> perf_printSummary_dtor_fields{
			getConstI32(ctx, 65535),
			func_perf_printSummary_dtor,
			ConstantExpr::getBitCast(getPointerTo(ctx, gvar_array_ProfileData), i8_ptr_ty),
		};

		// Construct the new element we'll be adding.
		auto global_dtor = ConstantStruct::get(global_dtor_ty, perf_printSummary_dtor_fields);

		vector<Constant*> global_dtors;

		// Copy already existing global dtors into our list
		if (GlobalVariable *llvm_global_dtors = module->getNamedGlobal("llvm.global_dtors")) {
			ConstantArray *initializer = cast<ConstantArray>(llvm_global_dtors->getInitializer());

			for (auto dtor : initializer->operand_values())
				global_dtors.push_back(cast<Constant>(dtor));

			llvm_global_dtors->eraseFromParent();
		}

		// add our new dtor
		global_dtors.push_back(global_dtor);

		auto global_dtors_array_ty = ArrayType::get(global_dtor_ty, global_dtors.size());

		// create global var holding dtors
		new GlobalVariable{
			*module,
			global_dtors_array_ty,
			false,
			GlobalValue::AppendingLinkage,
			ConstantArray::get(global_dtors_array_ty, global_dtors),
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
				getPointerTo(ctx, gvar_array_ProfileData)
			);
			call->setCallingConv(CallingConv::C);
			call->setTailCall(true);
			call->setAttributes(AttributeSet::get(ctx, ~0, B));

			irb.CreateRetVoid();
		}

	};

	instrument(original_module.get(), original_regions);
	instrument(modified_module.get(), modified_regions);

	auto write_module = [](string path, string banner, Module *mod) {
		DEBUG(fancy_dbgs() << "Writing module " << mod->getModuleIdentifier() << " to file " << path << "\n");

		error_code err;

		raw_fd_ostream file{path, err, sys::fs::F_Text};

		if (err) {
			fancy_errs() << "Could not open file '" << path << "' for writing\n";
			exit(1);
		}

		file << banner << *mod;
	};

	write_module(
		removeSuffix(original_ir_file, ".ll") + ".perf.ll",
		"; GCG CPU perf instrumented",
		original_module.get()
	);
	write_module(
		removeSuffix(modified_ir_file, ".ll") + ".perf.ll",
		"; GCG CPU perf instrumented",
		modified_module.get()
	);

	return 0;
}

static void checkProfilingDataStructLayout(const DataLayout *dl, StructType *pp_ty)
{
	if (!dl) {
		fancy_errs() << "Missing data layout\n";
		exit(1);
	}

	const StructLayout *layout = dl->getStructLayout(pp_ty);

	size_t C_size      = sizeof(ProfileData);
	size_t C_alignment = alignof(ProfileData);

	size_t LLVM_size      = layout->getSizeInBytes();
	size_t LLVM_alignment = layout->getAlignment();

	if (C_size != LLVM_size) {
		fancy_errs() << "size of struct ProfileData in C (" << C_size << ") and LLVM (" << LLVM_size << ") don't match\n";
		exit(1);
	}
	if (C_alignment != LLVM_alignment) {
		fancy_errs() << "alignment of struct ProfileData in C (" << C_alignment << ") and LLVM (" << LLVM_alignment << ") don't match\n";
		exit(1);
	}
}

static string removeSuffix(string str, string suffix)
{
	size_t pos = str.rfind(suffix);

	if (pos == string::npos)
		return str;

	return str.substr(0, pos);
}

static llvm::raw_ostream& fancy_ostream(StringRef prefix, raw_ostream& os, raw_ostream::Colors color)
{
	raw_ostream& stream = errs();

	if (prefix.size())
	{
		stream.changeColor(color, true);
		stream << prefix;
		stream.resetColor();
		stream << ": ";
	}

	return stream;
}

static raw_ostream& fancy_errs() { return fancy_ostream("error", errs(), raw_ostream::RED); }
static raw_ostream& fancy_dbgs() { return fancy_ostream("debug", errs(), raw_ostream::BLUE); }

static Instruction* nextInsertionPoint(Instruction *i)
{
	assert(i);

	if (isa<TerminatorInst>(i))
		return i;

	Instruction *next = i->getNextNode();

	assert(next);

	return next;
}
