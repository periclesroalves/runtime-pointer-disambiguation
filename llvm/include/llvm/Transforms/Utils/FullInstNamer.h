#ifndef _FULL_INST_NAMER_H_
#define _FULL_INST_NAMER_H_

#include <llvm/Pass.h>
#include <llvm/ADT/StringRef.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/Metadata.h>
#include <llvm/IR/MDBuilder.h>
#include <llvm/IR/LLVMContext.h>

#include <string>
#include <cassert>

namespace llvm {

class FullInstNamer : public FunctionPass {
  public:
  static char ID;

  FullInstNamer();

  virtual const char *getPassName()                         const override { return "FullInstNamer"; }
  virtual void        getAnalysisUsage(AnalysisUsage &Info) const override { Info.setPreservesAll(); }
  virtual bool        runOnFunction(Function &F) override;

  unsigned getNameMDKindID() const;
  unsigned getNameMDKindID(LLVMContext&) const;

  /// Return name or empty string
  StringRef getName(const Value *v) const;
  /// Return name or abort
  StringRef getNameOrFail(const Pass *caller, const Value *v) const;
  StringRef getNameOrFail(StringRef   caller, const Value *v) const;

  void setName(LLVMContext& ctx, Value *v, StringRef name) const;
  void setNameIfAbsent(LLVMContext& ctx, Value *v, StringRef name) const;

  static Value* lookup(Function *fn, StringRef name);
};

} // end namespace llvm

#endif //_FULL_INST_NAMER_H_
