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

  static unsigned getNameMDKindID();
  static unsigned getNameMDKindID(LLVMContext&);

  /// Return name or empty string
  static StringRef getName(const Value *v);
  /// Return name or abort
  static StringRef getNameOrFail(const Pass *caller, const Value *v);
  static StringRef getNameOrFail(StringRef   caller, const Value *v);

  template<typename IRBuilder>
  static Value* getNameAsValue(const Pass *caller, IRBuilder& irb, const Value *v) {
    StringRef name = getNameOrFail(caller, v);

    return irb.CreateGlobalStringPtr(name);
  }

  static void setName(LLVMContext& ctx, Value *v, StringRef name);
  static void setNameIfAbsent(LLVMContext& ctx, Value *v, StringRef name);

  static Value* lookup(Function *fn, StringRef name);
};

} // end namespace llvm

#endif //_FULL_INST_NAMER_H_
