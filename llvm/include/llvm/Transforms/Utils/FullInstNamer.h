#ifndef _FULL_INST_NAMER_H_
#define _FULL_INST_NAMER_H_

#include <llvm/IR/Function.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/Metadata.h>
#include <llvm/IR/MDBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/Pass.h>

#include <string>
#include <cassert>

class FullInstNamer : public llvm::FunctionPass
{
    public:
    static char ID;

    FullInstNamer();

    virtual const char *getPassName()                               const override { return "FullInstNamer"; }
    virtual void        getAnalysisUsage(llvm::AnalysisUsage &Info) const override { Info.setPreservesAll(); }
    virtual bool        runOnFunction(llvm::Function &F) override;

	unsigned getNameMDKindID() const;
	unsigned getNameMDKindID(llvm::LLVMContext&) const;

	/// Return name or empty string
	llvm::StringRef getName(const llvm::Value *v) const;
	/// Return name or abort
	llvm::StringRef getNameOrFail(const llvm::Pass *caller, const llvm::Value *v) const;
	llvm::StringRef getNameOrFail(llvm::StringRef   caller, const llvm::Value *v) const;

	void setName(llvm::LLVMContext& ctx, llvm::Value *v, llvm::StringRef name) const;
	void setNameIfAbsent(llvm::LLVMContext& ctx, llvm::Value *v, llvm::StringRef name) const;

	static llvm::Value* lookup(llvm::Function *fn, llvm::StringRef name);
};

#endif //_FULL_INST_NAMER_H_
