#pragma once

#include "llvm/IR/Instruction.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Use.h"

using namespace llvm;
using namespace std;

namespace {

	class PassTools
	{
        public:

        static std::string getVarId(Value* instr, bool testValExists=true)
        {
            //TODO: if instnamer pas wass run the getName function will return var names
        
            //print to string
            std::string tmp;
            llvm::raw_string_ostream sstream(tmp);
            sstream << *instr;
            //
            size_t eqIndex = tmp.find("=");
            if(string::npos != eqIndex)
            {                    
                tmp = tmp.substr(0,eqIndex);
                size_t firstChar = tmp.find_first_not_of(" ");
                size_t lastChar = tmp.find_first_of(" ",firstChar);
                tmp = tmp.substr(firstChar,lastChar-firstChar);
            
                return tmp;
            }
            else
            {
                assert(!testValExists);
                return string("");
            }
        }


        static std::string getStoreArgName(Instruction* instr)
        {
            if(const StoreInst * storeInst = dyn_cast<StoreInst>(instr))
            {
                for(User::op_iterator opIt = instr->op_begin(); opIt != instr->op_end(); ++opIt)
                {
                    Use *use = opIt;
                    Value *useValue = (use->operator llvm::Value *());
                    
                    if((dyn_cast<GetElementPtrInst>(useValue)?1:0))
                    {
                        //this is the pointer argument skip it
                    }
                    else
                    {
                        if(Instruction * useInst = dyn_cast<Instruction>(useValue))
                        {
                            return PassTools::getVarId(useInst);
                        }
                    }
                }
            }
            else
            {
                //it has to be a store instruction
                assert(false);
            }
						return std::string("");
        }
        
        
	};
}
