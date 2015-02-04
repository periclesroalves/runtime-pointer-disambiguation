#pragma once

#include "llvm/Support/raw_ostream.h"

#include <string>
#include <fstream>
#include <map>
#include <algorithm>
#include <cassert>

#include "StringTools.h"

using namespace llvm;
using namespace std;

namespace llvm {   

    class ParseTools
    {
    public:
        static const bool verbose = false;
        static const int IGNORE_INDENT = -1;
        
        static bool testIsArrayElement(std::basic_ifstream<char> &is,int indent = ParseTools::IGNORE_INDENT);
        static bool testIsAnyKeyVal(std::basic_ifstream<char> &is);
        static bool testIsEmptyLine(std::basic_ifstream<char> &is);    
        static bool testIsNull(std::basic_ifstream<char> &is);       
        static bool testIsEof(std::basic_ifstream<char> &is);       
    
        static int   consumeArrayElement(std::basic_ifstream<char> &is, int indent = ParseTools::IGNORE_INDENT);
        static void  consumeNull(std::basic_ifstream<char> &is);
        static void  consumeEmptyLines(std::basic_ifstream<char> &is);
        static void  consumeEmptyLine(std::basic_ifstream<char> &is);
        static std::map<string,string> consumeAllKeyValStr(std::basic_ifstream<char> &is);    
        static string consumeUnknownKeyValStr(std::basic_ifstream<char> &is,string &key);        
        static string consumeKeyValStr(std::basic_ifstream<char> &is,const char* keyTest);    
        static void consumeKey(std::basic_ifstream<char> &is,const char* keyTest);    
        static int consumeKeyValInt(std::basic_ifstream<char> &is,const char* keyTest);
        static void consumeEof(std::basic_ifstream<char> &is);
                
    };
}
