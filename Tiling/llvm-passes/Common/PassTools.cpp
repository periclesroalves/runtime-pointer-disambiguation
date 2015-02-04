#include "PassTools.h"

using namespace llvm;
using namespace std;

int PassTools::loopCnt = 0;
int PassTools::recompInstrCnt = 0;
const std::string PassTools::RECOMP_PFX  = "rcadd";

void PassTools::incrLoopCnt()
{
    PassTools::loopCnt++;
}

int PassTools::guessUnrollFactor(Loop *loop){
    int estimatedIterCnt=1;    

    for (Loop::block_iterator blockIt = loop->block_begin(); blockIt != loop->block_end(); ++blockIt) {
        BasicBlock *block = *blockIt;
        for (BasicBlock::iterator instrIt = block->begin();  instrIt != block->end(); ++instrIt) {
            Instruction *instr = instrIt;
            string varId = PassTools::getVarId(instr,false);

            //try to estimate unrolling factor
            string iSuffixNext="."+itostr(estimatedIterCnt);      
            if(StringTools::suffixMatch(varId,iSuffixNext)){
                estimatedIterCnt++;
            }                                                
        }
    }

    return estimatedIterCnt;
}

void PassTools::fillInInstructionCollections(
    Loop *loop, 
    int iter,
    std::vector<Instruction*> &loopInstrAr,
    std::map<Value*,int> &instrOrderMap, 
    std::unordered_set<Instruction*> &extDefSet
    )
{

    std::unordered_set<int> ignoredNodeTypes;
    //ignoredNodeTypes.insert(NodePhi);
    //ignoredNodeTypes.insert(NodeBranch);
    //ignoredNodeTypes.insert(NodeCmp);

    bool startFilling = false;
    string iSuffixFind,iSuffixFindP1;
    
    if(iter==PassTools::WHOLE_LOOP){
        startFilling = true;
        ignoredNodeTypes.clear();
        iSuffixFind="";
        iSuffixFindP1 = "never end";
    }
    else if(iter==0){
        startFilling=false;
        iSuffixFind="";      
        iSuffixFindP1="."+itostr(iter+1);        
    }
    else{
        startFilling=false;
        iSuffixFind="."+itostr(iter);      
        iSuffixFindP1="."+itostr(iter+1);      
    }
    
    string iNextRegexBase = "indvar[.](i.*[.])?next(i.*[.])?[0-9]+"; 
    SmallVector<StringRef, 1> Matches;
    Regex iNextRegex  ((iNextRegexBase + (iter  <2 ? "$" : "[.]"+itostr(iter-1  )+"$")).c_str());
    Regex iNextRegexP1((iNextRegexBase + (iter+1<2 ? "$" : "[.]"+itostr(iter-1+1)+"$")).c_str());
    
    
    for (Loop::block_iterator blockIt = loop->block_begin(); blockIt != loop->block_end(); ++blockIt) {
        BasicBlock *block = *blockIt;
        for (BasicBlock::iterator instrIt = block->begin();  instrIt != block->end(); ++instrIt) {
            Instruction *instr = instrIt;
            string varId = PassTools::getVarId(instr,false);
            
            if(varId.size()>0){
                if(!startFilling && StringTools::suffixMatch(varId,iSuffixFind)){
                    startFilling = true;
                }
                else if(iNextRegex.match(varId)){
                    startFilling = true;
                }
       
                if(startFilling && StringTools::suffixMatch(varId,iSuffixFindP1)){
                    startFilling = false;
                }
                else if(iNextRegexP1.match(varId)){
                    startFilling = false;
                }
            }
            
            if(startFilling){
                //if(!ignoredNodeTypes.count(Node::getNodeType(instr)))
                {                        
                    loopInstrAr.push_back(instr);
                    instrOrderMap[instr] = loopInstrAr.size() - 1;            
                }
            }                        
        }
    }
    
    //get external definitions
    for (int i = 0; i < loopInstrAr.size(); i++) {
        Instruction* instr = loopInstrAr[i];
        for (User::op_iterator opIt = instr->op_begin(); opIt != instr->op_end(); ++opIt) {
            Use *use = opIt;
            Value *useValue = (use->operator Value *());
            if (Instruction * useInst = dyn_cast<Instruction>(useValue)) {
            
                if (instrOrderMap.count(useInst)) {
                    //not external, ignore
                } else {
                    //remember this external definition
                    extDefSet.insert(useInst);
                }                
            } else {
                //It is not an inscruction
            }
        }
    }
    
    //Line for debugging
    //errs() << "==== extDefSet"<<"\n"; for(auto it = extDefSet.begin(); it != extDefSet.end(); ++it) {errs()<< **it << "\n";}

}

void PassTools::setLoopName(Loop* loop, string loopName)
{
    assert(loopName.substr(0,1).compare("L")==0);
    assert(loopName.substr(1,loopName.size()-1).find_first_not_of("0123456789")==string::npos);
    
    for (Loop::block_iterator blockIt = loop->block_begin();blockIt != loop->block_end(); ++blockIt) {
        BasicBlock *block = *blockIt;

        string blockName(block->getName());
        size_t loopNameStart = blockName.find_first_of("-",0);        
        string blockNameBase = blockName;
        if(loopNameStart!=string::npos){
            size_t loopNameEnd = blockName.find_first_not_of("0123456789",loopNameStart+2);
            if(loopNameEnd == string::npos){
                loopNameEnd = blockName.size();
            }            
            //remove the old loop name if exists
            blockNameBase = blockName.erase(loopNameStart,loopNameEnd-loopNameStart);
        }

        
        string blockNewName=blockNameBase+"-"+loopName;
        block->setName(blockNewName.c_str());
    }
}

std::string PassTools::getLoopName(Loop* loop)
{
    string loopName("");
    for (Loop::block_iterator blockIt = loop->block_begin();
        blockIt != loop->block_end(); ++blockIt) {
        BasicBlock *block = *blockIt;
        string blockName(block->getName());
        size_t loopNameStart = blockName.find_first_of("-",0);
        if(loopNameStart!=string::npos){
            size_t loopNameEnd = blockName.find_first_not_of("0123456789",loopNameStart+2);
            if(loopNameEnd == string::npos){
                loopNameEnd = blockName.size();
            }            
            
            string loopNameRaw = blockName.substr(loopNameStart+1,loopNameEnd - loopNameStart-1);
            if(loopName.size()==0){
                loopName=loopNameRaw;
            }
            else{
                assert(loopName.compare(loopNameRaw)==0);    
            }
        }
    }
    
    return loopName;
}


std::string PassTools::getCurrentLoopName()
{
    return std::string("L") +(PassTools::loopCnt<10?"0":"")+ itostr(PassTools::loopCnt);
}

std::string PassTools::getVarId(Value* instr, bool testValExists)
{
    //TODO: if instnamer pas wass run the getName function will return var names

    //print to string
    std::string instrStr;
    std::string varId;
    llvm::raw_string_ostream sstream(instrStr);
    sstream << *instr;
    //
    size_t eqIndex = instrStr.find("=");
    if(string::npos != eqIndex)
    {                    
        varId = instrStr.substr(0,eqIndex);
        size_t firstChar = varId.find_first_not_of(" ");
        size_t lastChar = varId.find_first_of(" ",firstChar);
        varId = varId.substr(firstChar,lastChar-firstChar);

        return varId;
    }
    else
    {
        //errs() << *instr << "\n";
        assert(!testValExists);        
        return string("");
    }
}

std::string PassTools::getInstrId(Value* instr)
{
    if(instr->getType()->isVoidTy()){
        return PassTools::getVoidTyInstrId(instr);
    }
    else{
        return PassTools::getVarId(instr,true);
    }
}

std::string PassTools::getVoidTyInstrId(Value* instr)
{
    std::string instrStr;
    llvm::raw_string_ostream sstream(instrStr);
    sstream << *instr;
    
    assert(instrStr.find("=")==string::npos);
    size_t nameStartIdx = instrStr.find_first_not_of(" ");
    size_t nameEndIdx = instrStr.find_first_of(" ",nameStartIdx);
    string instrName = instrStr.substr(nameStartIdx,nameEndIdx-nameStartIdx);
    
    //errs() << instrName << "\n";
    vector<string> argNameAr;   
    size_t argNameStartIdx = nameEndIdx;
    
    argNameStartIdx = instrStr.find_first_of("%",argNameStartIdx);
    while(argNameStartIdx!=string::npos){
        size_t argNameEndIdx  = instrStr.find_first_of(", \n",argNameStartIdx);
        string argName = instrStr.substr(argNameStartIdx,argNameEndIdx-argNameStartIdx);
        //errs() << argName << "\n";
        argNameAr.push_back(argName);
        argNameStartIdx = instrStr.find_first_of("%",argNameEndIdx);
    }
    
    string voidTyInstrId = instrName+"(";
    for(int i=0;i<argNameAr.size();i++){
        if(i>0){
            voidTyInstrId+=",";
        }
        voidTyInstrId += argNameAr[i];
    }     
    voidTyInstrId+=")";

    //errs() << voidTyInstrId << "\n";
    return voidTyInstrId;
}

int PassTools::getLoadStoreByteSize(const Instruction* instr)
{
    const Value *ptrInstr = nullptr;
    if(const StoreInst *storeInst = dyn_cast<StoreInst>(instr)){
        ptrInstr = storeInst->getPointerOperand();
        //errs() <<"ptrInstr "<< *ptrInstr << "\n";
        //errs() <<"alignment "<<storeInst->getAlignment() << "\n";
    }
    else if(const LoadInst *loadInst = dyn_cast<LoadInst>(instr)){
        ptrInstr = loadInst->getPointerOperand();    
        //errs() <<"ptrInstr "<< *ptrInstr << "\n";
        //errs() <<"alignment "<<loadInst->getAlignment() << "\n";
    }
    else{
        assert(false);
    }
    
    //errs() <<"ptrInstr"<< *ptrInstr << "\n";
    //errs() << *(ptrInstr->getType()) << "\n";
    //errs() << ptrInstr->getType()->getScalarSizeInBits() << "\n";
    //errs() << *(ptrInstr->getType()->getPointerElementType()) << "\n";
    //errs() << ptrInstr->getType()->getPointerElementType()->getScalarSizeInBits() << "\n";
    int bitCnt = ptrInstr->getType()->getPointerElementType()->getScalarSizeInBits();
    //make sure that bit cont is a multiple of 8
    assert (bitCnt % 8 == 0);
    int sizeInBytes = bitCnt / 8; 
    return sizeInBytes;

}


std::string PassTools::getStoreArgName(Instruction* instr)
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


void PassTools::findInductionVariable(
    Loop* loop, 
    ScalarEvolution *seaa, 
    const SCEVAddRecExpr *& indVarScev,
    Instruction *& indVarInstr,
    int &indVarIncr,
    bool verbose
)
{
    PHINode *indVarCanon = loop->getCanonicalInductionVariable();
    if (indVarCanon) {
        if(verbose){errs() << "canonIndVar: "<<*indVarCanon<<"\n";}
    }

    for (Loop::block_iterator blockIt = loop->block_begin(); blockIt != loop->block_end(); ++blockIt) {
        BasicBlock *block = *blockIt;
            for (BasicBlock::iterator instrIt = block->begin();  instrIt != block->end(); ++instrIt) {
                Instruction *instr = instrIt;

                if (!seaa->isSCEVable(instr->getType()))
                    continue;

                const SCEV *scev = seaa->getSCEV(instr);
                if (isa<PHINode>(instr)) {
                    if (const SCEVAddRecExpr *sare = dyn_cast<SCEVAddRecExpr>(scev)) {
                        if (sare->getLoop() == loop) {
                            if(!indVarScev){
                                if(verbose){errs() <<"Found candidate for indVar"<<"\n";}
                                indVarScev = sare;
                                indVarInstr = instr;
                                if (const SCEVAddRecExpr *indVarSare = dyn_cast<SCEVAddRecExpr>(indVarScev)) {
                                    if (indVarSare->isAffine()) {
                                        const SCEVConstant * indVarAff = dyn_cast<SCEVConstant>(indVarSare->getOperand(1));    
                                        indVarIncr = indVarAff->getValue()->getSExtValue();
                                    }
                                }
                            }
                            else
                            {
                                if(verbose){errs() <<"Another candidate for indVar ..."<<"\n";}
                            }
                            
                            if(verbose){errs() << "indVar: " << *instr << "\n";}
                            if(verbose){errs() << "indVarScev: " << *sare << "\n";}    
                       }
                  }
             }
        }
    }
        
    if(indVarCanon){
        assert(indVarCanon == indVarInstr);
    }
}

std::string PassTools::getLoopData(Loop* loop){
    string str;
    llvm::raw_string_ostream sstream(str);
    BasicBlock *header = loop->getHeader();
    sstream <<"{ " <<"parentFun: " << header->getParent()->getName() << ", header: %" << header->getName()<<" }";
    return str;
}


bool PassTools::processLoop(string SelectedLoopNames, Loop  *loop){
    string loopName = PassTools::getLoopName(loop);
    string funName = loop->getHeader()->getParent()->getName();
    assert(loopName.size()>0);
    
    /*
    if(SelectedFunNames.size()>0){
        vector<string> selectedFunNameAr = StringTools::split(SelectedFunNames,',');
        if(!StringTools::arrayContains(selectedFunNameAr,funName))
        {
            return false;
        }
    } 
    */ 
        
    if(SelectedLoopNames.size()>0){
        vector<string> selectedLoopNameAr = StringTools::split(SelectedLoopNames,',');
        if(!StringTools::arrayContains(selectedLoopNameAr,loopName))
        {
            return false;
        }
    }  
    return true;
}

void PassTools::inserIndvarAfterPhi(Loop* loop, ScalarEvolution *seaa, LoopInfo *loopInfo){        
    const SCEVAddRecExpr* indVarScev = 0;
    Instruction *indVarInstr = 0;
    int indVarIncr=-1;
    PassTools::findInductionVariable(loop,seaa,indVarScev,indVarInstr,indVarIncr,true);
    
    errs() <<"A "<<""<<"\n";
    if(indVarInstr){
        errs() <<"A1"<<*indVarInstr<<"\n";
        //create an add instruction of the same type as the phi, adding a constant of 0
        Constant* zero = ConstantInt::get(indVarInstr->getType(), 0);
        BinaryOperator *addInstr =  BinaryOperator::Create( Instruction::Add,indVarInstr, zero, "indvar.next.my");
        addInstr->insertAfter(indVarInstr);
        errs() <<"A1a"<<*addInstr<<"\n";

        PassTools::substituteUses(indVarInstr,addInstr, loop, loopInfo);
    }
}

void PassTools::substituteUses(Value* valueUsed, Value* valueSubst, Loop* loop, LoopInfo *loopInfo){
    for(auto itUse = valueUsed->user_begin(); itUse != valueUsed->user_end(); itUse++){
        Instruction *userInstr =  dyn_cast<Instruction>(*itUse);
        //if         
        if(userInstr && userInstr != valueSubst && ((loop && loopInfo) ? loop == loopInfo->getLoopFor(userInstr->getParent()) : true )) {
            errs() <<"B1\n";
            for(auto itOp = userInstr->op_begin();  itOp != userInstr->op_end(); itOp++ ){
                Value *op = *itOp;
                errs() <<"B2 "<<(dyn_cast<Instruction>(op)? *((Instruction*)op) :*op)<<"\n";
                //if this operatnd is the induction var
                if(op==valueUsed){
                    errs() <<"B3\n";
                    *itOp = valueSubst;
                }
            }
        }
    } 
}


void PassTools::removeIndvarNext(Loop* loop, unsigned unrollFactor, ScalarEvolution *seaa, LoopInfo *loopInfo){
    
    bool dbg = false;
        
    seaa->forgetLoopDispositions(loop);
    seaa->forgetLoop(loop);

    string loopName = PassTools::getLoopName(loop);

    const SCEVAddRecExpr* indVarScev = 0;
    Instruction *indVarInstr = 0;
    int indVarIncr=-1;
    PassTools::findInductionVariable(loop,seaa,indVarScev,indVarInstr,indVarIncr,true);
        
    SCEVExpander *scevExpander = new SCEVExpander(*seaa,"myName");
    
    struct Replacement {
        Instruction* where;
        Value* what;
        Value* with;
    };
    
    std::vector<Replacement*> replAr;
    std::list<Instruction*> removeLi;
    
    std::map<string,int> recompIterIdxMap; 
    
    //for each indvar.next*
    for (Loop::block_iterator blockIt = loop->block_begin(); blockIt != loop->block_end(); ++blockIt) {
        BasicBlock *block = *blockIt;
        for (BasicBlock::iterator instrIt = block->begin();  instrIt != block->end(); ++instrIt) {
            Instruction *instr = instrIt;
            string varId = PassTools::getVarId(instr,false);
            string indvarNextPfx = string("%indvar.next");
            string indvarPfx = string("%indvar");
            //errs() <<"A0 "<<*instr<<"\n";
            //if this is the phi or the indvar.next instruction
            if((isa<PHINode>(instr) && StringTools::prefixMatch(varId,indvarPfx,true)) || StringTools::prefixMatch(varId,indvarNextPfx,true)){
                //for each use of indvar.next*
                //seaa->forgetLoopDispositions(loop);
                //seaa->forgetLoop(loop);

                Instruction *indvarNextInstr = instr;                 
                removeLi.push_back(indvarNextInstr);
                const SCEV *indvarNextScev = seaa->getSCEV(indvarNextInstr);
                const SCEVAddRecExpr *indVarNextSare = dyn_cast<SCEVAddRecExpr>(indvarNextScev);
                
                if(dbg){errs() <<"A1 "<<*indvarNextInstr<<"\n";}
                if(dbg){errs() <<"A1a "<<*indvarNextScev<<"\n";}

                for(auto itUse = indvarNextInstr->user_begin(); itUse != indvarNextInstr->user_end(); itUse++){
                    Instruction *userOfIVNext =  dyn_cast<Instruction>(*itUse);
                    if(userOfIVNext && !isa<PHINode>(userOfIVNext) && loop == loopInfo->getLoopFor(indVarInstr->getParent())){                                                                                            
                        if(dbg){errs() <<"A2 "<<*userOfIVNext<<"\n";}
                        if(dbg){errs() <<"A2a "<<*seaa->getSCEV(userOfIVNext)<<"\n";}
                        if ( indVarNextSare && indVarNextSare->getLoop() == loop && indVarNextSare->isAffine()) {
                            const SCEVConstant * constOffset = dyn_cast<SCEVConstant>(indVarNextSare->getOperand(0));
                            const SCEVConstant * constMutiplier = dyn_cast<SCEVConstant>(indVarNextSare->getOperand(1));
                            if(constOffset){
                                int incrInt = constOffset->getValue()->getSExtValue();
                                assert(constMutiplier->getValue()->getSExtValue() % unrollFactor ==0);
                                
                                //if the consumer is an add with a constant, modify it instead of creating a new
                                if(isa<BinaryOperator>(userOfIVNext) && userOfIVNext->getOpcode() == Instruction::Add &&  
                                  (isa<Constant>(userOfIVNext->getOperand(0)) || isa<Constant>(userOfIVNext->getOperand(1))))
                                {
                                    Constant* addOldConst = dyn_cast<Constant>(isa<Constant>(userOfIVNext->getOperand(0)) ? userOfIVNext->getOperand(0) : userOfIVNext->getOperand(1));     
                                    Instruction* indInstr = dyn_cast<Instruction>(isa<Instruction>(userOfIVNext->getOperand(0)) ? userOfIVNext->getOperand(0) : userOfIVNext->getOperand(1)); 
                                    
                                    Constant* offsetConst = ConstantInt::get(addOldConst->getType(), incrInt);                                     
                                    Constant* addNewConst = ConstantInt::get(indVarInstr->getType(), offsetConst->getUniqueInteger() + addOldConst->getUniqueInteger());
                                    
                                    Replacement* replInd = new Replacement();
                                    replInd->where = userOfIVNext;  
                                    replInd->what = indvarNextInstr;
                                    replInd->with = indVarInstr; 
                                    replAr.push_back(replInd);                                                

                                    Replacement* replConst = new Replacement();
                                    replConst->where = userOfIVNext;  
                                    replConst->what = addOldConst;
                                    replConst->with = addNewConst; 
                                    replAr.push_back(replConst); 
                                    
                                    if(dbg){errs() << "hit\n";}                                                                  
                                }
                                else
                                {
                                    //if this is some consumer
                                    string iterIdxSfx = getInstrUnrollIdx(PassTools::getVarId(userOfIVNext,false));                                    
                                        
                                    Constant* incrConst = ConstantInt::get(indVarInstr->getType(), incrInt);
                                    //create add instruction
                                    if(recompIterIdxMap.count(iterIdxSfx)==0){recompIterIdxMap[iterIdxSfx]=0;}
                                    recompIterIdxMap[iterIdxSfx]++;                                        
                                    
                                    string loopNameSfx = "_"+loopName;
                                    string instrIdxSfx = "_i"+itostr(++PassTools::recompInstrCnt);
                                    string recompIdxSfx= "_r"+itostr(recompIterIdxMap[iterIdxSfx]);
                                    string recompInstrName = PassTools::RECOMP_PFX+loopNameSfx+instrIdxSfx+iterIdxSfx; 
                                    BinaryOperator *addInstr =  BinaryOperator::Create( Instruction::Add, indVarInstr, incrConst, recompInstrName);                             
                                    addInstr->insertBefore(userOfIVNext);

                                    Replacement* repl = new Replacement();
                                    repl->where = userOfIVNext;  
                                    repl->what = indvarNextInstr;
                                    repl->with = addInstr; 
                                    replAr.push_back(repl);                                                

                                    //push it to the remove array, in case the add has no uses
                                    removeLi.push_back(addInstr);
                                    
                                }
                            }                                                                                            
                        }                                                                                                                                    
                    }
                }                        
            }
        }
    } 
    
    for(int i=0; i<replAr.size(); i++){
        Replacement* repl = replAr[i];
                
        for(auto itOp = repl->where->op_begin();  itOp != repl->where->op_end(); itOp++ ){
            Value *op = *itOp;
            if(dbg){errs() <<"B2 "<<(dyn_cast<Instruction>(op)? *((Instruction*)op) :*op)<<"\n";}
            //if this operatnd is the induction var
            if(op==repl->what){
                if(dbg){errs() <<"B3\n";}
                *itOp = repl->with;
            }
        }
        
        delete repl;
    }   
                        
    for(int pass=0; pass<2 ;pass++)
    {        
        for(auto it =  removeLi.begin(); it != removeLi.end(); it++){
            Instruction* instr = *it;
            if(dbg){errs() <<*instr << "\n";}               
            if(instr->hasNUses(0)){
                instr->eraseFromParent();
                it = removeLi.erase(it);
            }               
        }
    }
    //for each indvar.next
    //if it does not have any uses remove it    
    
    delete scevExpander;
}

string PassTools::getInstrUnrollIdx(string varId){

    Regex instrNameRegex(string("^.*([.][1-9][0-9]*)$")); 
    SmallVector< StringRef, 2 >  matches; 
    std::string iterIdxSfx;
    if(instrNameRegex.match(varId,&matches))                                    
        iterIdxSfx = string("")+matches[1].str();
    else
        iterIdxSfx = string("");                                    

    return iterIdxSfx;
}

