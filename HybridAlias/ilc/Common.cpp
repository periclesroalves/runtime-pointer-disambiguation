/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include "ilc/Common.h"
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

namespace ilc
{

BasicBlock *lastOf(BasicBlock *bb1, BasicBlock *bb2)
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

Instruction *getInsertionPoint(Function *fn, Value *val1, Value *val2)
{
  Instruction *i1 = dyn_cast<Instruction>(val1);
  Instruction *i2 = dyn_cast<Instruction>(val2);

  if(isGlobalOrArgument(val1) &&  isGlobalOrArgument(val2)) return fn->getEntryBlock().getFirstInsertionPt();
  if(isGlobalOrArgument(val1) && !isGlobalOrArgument(val2)) return cast<Instruction>(&i2->getParent()->back());
  if(isGlobalOrArgument(val2) && !isGlobalOrArgument(val1)) return cast<Instruction>(&i1->getParent()->back());

  return cast<Instruction>(&lastOf(i1->getParent(), i2->getParent())->back());
}

std::string makeLoopName(llvm::Loop *l)
{
	auto entry = l->getHeader();

	assert(entry);

	auto fn = entry->getParent();

	assert(fn);

	return (fn->getName() + "::" + entry->getName()).str();
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

raw_ostream& fancy_errs(StringRef prefix) { return fancy_ostream("error", prefix, errs(), raw_ostream::RED);  }
raw_ostream& fancy_dbgs(StringRef prefix) { return fancy_ostream("debug", prefix, dbgs(), raw_ostream::BLUE); }

} // end namespace ilc
