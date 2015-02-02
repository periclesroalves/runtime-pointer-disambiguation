#pragma once

#include "llvm/IR/Instructions.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Use.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/Analysis/ScalarEvolutionExpander.h"
#include "llvm/Support/Regex.h"

#include "StringTools.h"


#include <string>
#include <unordered_set>
#include <list>

using namespace llvm;
using namespace std;

namespace llvm{

	class PassTools
	{
        private:
            static int loopCnt;
            static int recompInstrCnt;
        public:
        
            static const int WHOLE_LOOP = -1;
            static const string RECOMP_PFX; 
            
            static void incrLoopCnt();
            static std::string getCurrentLoopName();
            static std::string getLoopName(Loop* loop);
            static std::string getLoopData(Loop* loop);
            static void setLoopName(Loop* loop, string loopName);
            static std::string getVarId(Value* instr, bool testValExists=true);
            static std::string getStoreArgName(Instruction* instr);        
            static int getLoadStoreByteSize(const Instruction* instr);
            static void inserIndvarAfterPhi(Loop* loop,ScalarEvolution *seaa,LoopInfo *loopInfo);
            static void removeIndvarNext(Loop* loop, unsigned unrollFactor, ScalarEvolution *seaa, LoopInfo *loopInfo);
            static void substituteUses(Value* valueUsed, Value* valueSubst, Loop* loop = nullptr , LoopInfo *loopInfo = nullptr );

            static void fillInInstructionCollections(
                Loop *loop,
                int iter,
                std::vector<Instruction*> &loopInstrAr,
                std::map<Value*,int> &instrOrderMap, 
                std::unordered_set<Instruction*> &extDefSet
                );
            static std::string getVoidTyInstrId(Value* instr);
            static std::string getInstrId(Value* instr);
            static void findInductionVariable(
                Loop* loop, 
                ScalarEvolution *seaa, 
                const SCEVAddRecExpr *& indVarScev,
                Instruction *& indVarInstr,
                int &indVarIncr,
                bool verbose = true

            );
            static int guessUnrollFactor(Loop *loop);
            static bool processLoop(string SelectedLoopNames, Loop *loop);
            
            static string getInstrUnrollIdx(string varId);

	};
}
