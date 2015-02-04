#include "ParseTools.h"

bool ParseTools::testIsArrayElement(std::basic_ifstream<char> &is, int indent)
{
    streampos pos = is.tellg();
    bool returnVal=false;

    const char* keyTest = "-";
    string token;
    std::getline(is,token,'\n');
    int indentNew = std::distance(token.begin(),std::find_if(token.begin(), token.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
    
    StringTools::trim(token);
    if(token.compare(keyTest)==0  && (indent==ParseTools::IGNORE_INDENT? true : indent == indentNew)){                        
        returnVal=true;
    }

    is.seekg(pos);

    if(ParseTools::verbose){
        errs()<< "test:  isArrayElement ";
        (indent==ParseTools::IGNORE_INDENT? errs()<<"": errs()<<"with indent "<<indent<< " ");
        errs() << (returnVal?"true":"false") <<"\n";
    }        

    return returnVal;

}

bool ParseTools::testIsNull(std::basic_ifstream<char> &is)
{
    streampos pos = is.tellg();
    bool returnVal=false;

    const char* keyTest = "~";
    string token;
    std::getline(is,token,'\n');
    StringTools::trim(token);
    if(token.compare(keyTest)==0){                        
        returnVal=true;
    }

    is.seekg(pos);

    if(ParseTools::verbose){
        errs()<< "test:  isNull "<< returnVal <<"\n";
    }        

    return returnVal;

}


bool ParseTools::testIsAnyKeyVal(std::basic_ifstream<char> &is)
{
    streampos pos = is.tellg();
    bool returnVal=true;

    string line;
    std::getline(is,line,'\n');
    int colonPos = line.find(':');
    is.seekg(pos);
    if(colonPos==string::npos){
        return false;
    }

    string tokenKey;
    std::getline(is,tokenKey,':');
    StringTools::trim(tokenKey);
    if(tokenKey.size()==0){                        
        returnVal = false;
    }

    string tokenVal;
    std::getline(is,tokenVal,'\n');
    StringTools::trim(tokenVal);
    if(tokenVal.size()==0){                        
        returnVal = false;
    }        

    is.seekg(pos);        

    if(ParseTools::verbose){
        errs()<< "test:  isAnyKeyVal "<< returnVal <<"\n";
    }        


    return returnVal;

}


int  ParseTools::consumeArrayElement(std::basic_ifstream<char> &is, int indent)
{
    const char* keyTest = "-";
    string token;
    std::getline(is,token,'\n');
    int indentNew = std::distance(token.begin(),std::find_if(token.begin(), token.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
    
    if(indent!=ParseTools::IGNORE_INDENT && indent != indentNew)
    {
        errs()<<"Wrong indent, was expecting "<<indent<<" got "<< indentNew<<"\n";
    }
    
    StringTools::trim(token);
    if(token.compare(keyTest)!=0){                        
        errs()<< "Wrong key, was expecting: "<<keyTest<<"\n";
    }

    if(ParseTools::verbose){
        errs()<< "consumed: "<< keyTest<<" with indent "<< indentNew <<"\n";
    }
    
    return indentNew;
}

void  ParseTools::consumeNull(std::basic_ifstream<char> &is)
{
    const char* keyTest = "~";
    string token;
    std::getline(is,token,'\n');
    StringTools::trim(token);
    if(token.compare(keyTest)!=0){                        
        errs()<< "Wrong key, was expecting: "<<keyTest<<"\n";
    }

    if(ParseTools::verbose){
        errs()<< "consumed: "<< keyTest<<"\n";
    }
}


void  ParseTools::consumeEmptyLines(std::basic_ifstream<char> &is)
{
    while(ParseTools::testIsEmptyLine(is)){
        ParseTools::consumeEmptyLine(is);            
    }
}

void ParseTools::consumeEmptyLine(std::basic_ifstream<char> &is)
{        
    streampos pos = is.tellg();    
        
    string token;
    std::getline(is,token);
    StringTools::trim(token);
    if(pos==is.tellg()){
        errs()<< "Wrong key, it is not an empty line, but end of file\n";
    }
    else if(token.length()>0){                        
        errs()<< "Wrong key, it is not an empty line\n";
    }

    if(ParseTools::verbose){
        errs()<< "consumed: "<< "newline"<<"\n";
    }

}


bool  ParseTools::testIsEmptyLine(std::basic_ifstream<char> &is)
{    
    streampos pos = is.tellg(); 
    bool isEmptyLine=false;

    string token;
    std::getline(is,token);
    StringTools::trim(token);
    if(is.eof()){
        isEmptyLine = false;
    }
    else if(token.length()==0){                        
        isEmptyLine = true;
    }
    is.seekg(pos);

    if(ParseTools::verbose){
        errs()<< "test:  isEmptyLine "<< isEmptyLine <<"\n";
    }        


    return isEmptyLine;

}

bool ParseTools::testIsEof(std::basic_ifstream<char> &is){
    streampos pos = is.tellg();    

    bool returnVal=false;        
    string token;
    std::getline(is,token);
    if(token.length() == 0 && is.eof()){
        returnVal=true;
    }
    is.seekg(pos);        

    if(ParseTools::verbose){
        errs()<< "test:  isEof "<< returnVal <<"\n";
    }        

    return returnVal;
}


void ParseTools::consumeEof(std::basic_ifstream<char> &is){
    streampos pos = is.tellg();    
        
    string token;
    std::getline(is,token);
    StringTools::trim(token);
    if(token.length() >0 || pos!=is.tellg()){
        errs()<< "Wrong key, it is not EOF\n";
    }

    if(ParseTools::verbose){
        errs()<< "consumed: EOF\n";
    }
}


std::map<string,string> ParseTools::consumeAllKeyValStr(std::basic_ifstream<char> &is)
{

    std::map<string,string> keyValMap;
    while(ParseTools::testIsAnyKeyVal(is)){
        string key;
        string val = ParseTools::consumeUnknownKeyValStr(is,key);
        keyValMap[key]=val;
    } 
    return keyValMap;

}

string ParseTools::consumeUnknownKeyValStr(std::basic_ifstream<char> &is,string &key)
{
    std::getline(is,key,':');
    StringTools::trim(key);

    string token;
    std::getline(is,token,'\n');
    StringTools::trim(token);
    StringTools::stripQuotes(token);

    if(ParseTools::verbose){
        errs()<< "consumed: "<< key << "\n";
    }

    return token;
}


string ParseTools::consumeKeyValStr(std::basic_ifstream<char> &is,const char* keyTest)
{
    string token;
    std::getline(is,token,':');
    StringTools::trim(token);
    if(token.compare(keyTest)!=0){                        
        errs()<< "Wrong key, was expecting: "<<keyTest<<"\n";
    }
    std::getline(is,token,'\n');
    StringTools::trim(token);
    StringTools::stripQuotes(token);

    if(ParseTools::verbose){
        errs()<< "consumed: "<< keyTest<<":"<<token <<"\n";
    }

    return token;
}

void ParseTools::consumeKey(std::basic_ifstream<char> &is,const char* keyTest)
{
    string token;
    std::getline(is,token,':');
    StringTools::trim(token);
    if(token.compare(keyTest)!=0){                        
        errs()<< "Wrong key, was expecting: "<<keyTest<<"\n";
    }
    std::getline(is,token,'\n');
    StringTools::trim(token);
    if(token.size()>0){
        errs()<< "Wrong value, was expecting empty string for key: "<<keyTest<<"\n";
    }

    if(ParseTools::verbose){
        errs()<< "consumed: "<< keyTest<<"\n";
    }
}


int ParseTools::consumeKeyValInt(std::basic_ifstream<char> &is,const char* keyTest)
{    
    string intStr = consumeKeyValStr(is,keyTest);
    return atoi(intStr.c_str());
}
