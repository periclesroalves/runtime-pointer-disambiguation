/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.

 * Canonicalize
 *	Apply passes required for cloning toolchain
 *  - mem2reg        ... so the .ll files are human readable
 *  - loop-simplify  ... so loops have a pre-header and dedicated exits
 *  - full-instnamer ... so all instructions have a name
 */

#include "ilc/BasePtrInfo.h"
#include "ilc/FullInstNamer.h"

#include "llvm/InitializePasses.h"
#include <llvm/Pass.h>
#include <llvm/Analysis/LoopPass.h>
#include <llvm/Analysis/AliasAnalysis.h>
#include <llvm/IR/Dominators.h>
#include "llvm/Support/CommandLine.h"
#include <string>


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
#include "ilc/Common.h"

#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Pass.h"
#include "llvm/PassManager.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/SourceMgr.h"

using namespace llvm;
using namespace std;

#define DEBUG_TYPE "canonicalize"

static Pass *getPass(std::string name) {
	PassRegistry *pr = PassRegistry::getPassRegistry();

	if (!pr) {
		ERR("Could not access pass registry");
		exit(1);
	}

	const PassInfo *info = pr->getPassInfo(name);

	if (!info) {
		ERR("Could not find pass '" << name << "'");
		exit(1);
	}

	Pass *pass = info->createPass();

	if (!pass) {
		ERR("Could not instantiate pass '" << name << "'");
		exit(1);
	}

	return pass;
}

cl::opt<string> IrFile(cl::Positional, cl::desc("<IR file>"), cl::Required);

cl::opt<string> OutputFilename(
	"o",
	cl::desc("Override output filename"),
	cl::init("")
);

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

	cl::ParseCommandLineOptions(argc, argv, "Brings programs into canonical form for cloning");

	// **** PARSE INPUT FILES

	// ** Parse the input LLVM IR file into a module.

	if (IrFile.empty())
		// read from stdin
		IrFile = "-";

	auto buffer = MemoryBuffer::getFileOrSTDIN(IrFile);

	if (std::error_code ec = buffer.getError()) {
		ERR("Could not open file '" << IrFile << "': " << ec.message());
		return 1;
	}

	SMDiagnostic err;

	std::unique_ptr<Module> module{parseIR(buffer->get()->getMemBufferRef(), err, getGlobalContext())};

	if (!module) {
		err.print(argv[0], errs());
		return 1;
	}

	// ** setup & run passes

	PassRegistry& Registry = *PassRegistry::getPassRegistry();

	initializeInstNamerPass(Registry);
	initializeAnalysis(Registry);
	initializeTransformUtils(Registry);

	PassManager pm;

	pm.add(getPass("mem2reg"));
	pm.add(getPass("full-instnamer"));
	pm.add(getPass("loop-simplify"));

	pm.run(*module);

	if (OutputFilename.size()) {
		DBG("Writing module " << module->getModuleIdentifier() << " to file " << OutputFilename);

		error_code err;

		raw_fd_ostream file{OutputFilename, err, sys::fs::F_Text};

		if (err) {
			ERR("Could not open file '" << OutputFilename << "' for writing");
			exit(1);
		}

		file << *module;
	} else {
		outs() << *module;
	}

	return 0;
}

