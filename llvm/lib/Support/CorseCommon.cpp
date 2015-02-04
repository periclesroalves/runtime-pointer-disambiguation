/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include <llvm/Support/CorseCommon.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/GlobalValue.h>
#include <llvm/IR/Argument.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Function.h>
#include <llvm/Support/Debug.h>
#include <cassert>

using namespace llvm;
using namespace std;

BasicBlock *llvm::lastOf(BasicBlock *bb1, BasicBlock *bb2)
{
  assert(bb1->getParent() == bb2->getParent());

  Function::BasicBlockListType &bbs = bb1->getParent()->getBasicBlockList();
  for(Function::iterator B = bbs.begin(), BE = bbs.end(); B != BE; ++B)
  {
    if(cast<BasicBlock>(B) == bb1) return bb2;
    if(cast<BasicBlock>(B) == bb2) return bb1;
  }
  return nullptr;
}

static llvm::raw_ostream& fancy_ostream(StringRef type, StringRef prefix, raw_ostream& os, raw_ostream::Colors color)
{
	raw_ostream& stream = errs();

	if (prefix.size())
	{
		stream.changeColor(color, true);
		stream << type;
		stream << ": ";
		stream << prefix;
		stream.resetColor();
		stream << ": ";
	}

	return stream;
}

raw_ostream& llvm::fancy_errs(StringRef prefix) { return fancy_ostream("error", prefix, errs(), raw_ostream::RED);  }
raw_ostream& llvm::fancy_dbgs(StringRef prefix) { return fancy_ostream("debug", prefix, dbgs(), raw_ostream::BLUE); }
