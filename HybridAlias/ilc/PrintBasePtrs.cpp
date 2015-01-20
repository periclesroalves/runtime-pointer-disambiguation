/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.

  PrintBasePtrs
  Print base pointer information for loops as YAML.
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

namespace {

struct PrintBasePtrs : public LoopPass {
	static char ID;

	PrintBasePtrs() : LoopPass(ID) {}

	const char *getPassName() const override { return "PrintBasePtrs"; }

	bool runOnLoop(Loop *L, LPPassManager &LPM) override;

	void getAnalysisUsage(AnalysisUsage &AU) const override
	{
		AU.setPreservesAll();

		AU.addRequired<AliasAnalysis>();
		AU.addRequired<DominatorTreeWrapperPass>();
	}
private:
	StringRef getNameOrFail(const Value* v) const;

	FullInstNamer fin;
};

} // end anonymous namespace

char PrintBasePtrs::ID;
static RegisterPass<PrintBasePtrs> X(
	"print-base-ptrs",
	"Print base pointer information for loops to stderr as YAML"
);

cl::opt<string> PrintOnlyPrefix(
	"print-only",
	cl::desc("Only print base pointers for loops in a function whose (mangled!) name has the given prefix"),
	cl::init("")
);

static bool hasPrefix(const std::string& str, const std::string& prefix);

bool PrintBasePtrs::runOnLoop(Loop *loop, LPPassManager &LPM)
{
	// we are interested only in cloneable, non-empty, innermost loops
	if (!loop->isSafeToClone() || (loop->getNumBlocks() == 0) || (loop->getSubLoops().size() > 0))
		return false;

	// ** get fully qualified name of loop

	// XXX: is it legal to read-only access containing fn and module?
	// XXX: fingers crossed, do BBs have unique names?

	BasicBlock *header = loop->getHeader();
	Function   *fn     = header->getParent();

	StringRef fn_name = getNameOrFail(fn);

	if (PrintOnlyPrefix.size() && !hasPrefix(fn_name, PrintOnlyPrefix))
		return false;

	std::string loop_name = (fn_name + "::" + getNameOrFail(header)).str();

	// ** compute base pointers

	AliasAnalysis& aa      = getAnalysis<AliasAnalysis>();
	DominatorTree& domTree = getAnalysis<DominatorTreeWrapperPass>().getDomTree();

	BasePtrInfo info{loop, domTree, aa};

	outs() << "- \"" << loop_name << "\":\n";

	outs() << "    base_pointers: !!set {\n";
	for (auto basePtr : info.getAllBasePtrs()) {
		outs() << "        \"" << getNameOrFail(basePtr) << "\",\n";
	}
	outs() << "    }\n";

	outs() << "    base_pointer_pairs: !!set {\n";
	for (auto basePtrPair : info.getBasePtrPairs()) {
		outs() << "        !!set {\"" << getNameOrFail(basePtrPair.first) << "\", \"" << getNameOrFail(basePtrPair.second) << "\"},\n";
	}
	outs() << "    }\n";

	outs() << "    instructions:\n";
	for (auto& mapping : info.getInstructionMap()) {
		outs() << "        \"" << getNameOrFail(mapping.first) << "\": !!set { ";
		for (auto basePtr : *mapping.second) {
			outs() << "\"" << getNameOrFail(basePtr) << "\", ";
		}
		outs() << "}\n";
	}

	outs() << "\n";

	return false;
}

StringRef PrintBasePtrs::getNameOrFail(const Value* v) const {
	return fin.getNameOrFail(this, v);
}


static bool hasPrefix(const std::string& str, const std::string& prefix)
{
	return str.compare(0, prefix.size(), prefix) == 0;
}

static Pass *getPass(std::string name) {
	PassRegistry *pr = PassRegistry::getPassRegistry();

	if (!pr) {
		errs() << "Could not access pass registry\n";
		exit(1);
	}

	const PassInfo *info = pr->getPassInfo(name);

	if (!info) {
		errs() << "Could not find pass '" << name << "'\n";
		exit(1);
	}

	Pass *pass = info->createPass();

	if (!pass) {
		errs() << "Could not instantiate pass '" << name << "'\n";
		exit(1);
	}

	return pass;
}

cl::opt<string> IrFile(cl::Positional, cl::desc("<IR file>"), cl::Required);

int main(int argc, char **argv) {
	// ** hide all regular options

	StringMap<cl::Option*> options;
	cl::getRegisteredOptions(options);

	for (auto& mapping : options) {
		auto name   = mapping.first();
		auto option = mapping.second;

		if ((name == "help") || (name == "print-only"))
			continue;

		option->setHiddenFlag(cl::Hidden);
	}

	// ** parse command line options

	cl::ParseCommandLineOptions(argc, argv, "This is a small program to demo the LLVM CommandLine API");

	// ** Parse the input LLVM IR file into a module.

	if (IrFile.empty())
		// read from stdin
		IrFile = "-";

	auto buffer = MemoryBuffer::getFileOrSTDIN(IrFile);

	if (std::error_code ec = buffer.getError()) {
		errs() << "Could not open file '" << IrFile << "': " << ec.message() << "\n";
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
	pm.add(getPass("print-base-ptrs"));

	pm.run(*module);

	return 0;
}

