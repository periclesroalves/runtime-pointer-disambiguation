#pragma once

#include "llvm/Support/raw_ostream.h"

#include <string>
#include <iostream>
#include <map>
#include <algorithm>
#include <cassert>
#include <sstream>


using namespace llvm;
using namespace std;

namespace llvm {   

    class StringTools
    {
    public:

        static std::string &ltrim(std::string &s);        
        static std::string &rtrim(std::string &s);
        static std::string &trim(std::string &s);    
        static string &stripQuotes(std::string &s);
        
        static std::vector<std::string> &split(const std::string &str, char delim, std::vector<std::string> &elems);
        static std::vector<std::string> split(const std::string &str, char delim);
        
        static bool arrayContains(std::vector<std::string> &elems, const std::string &str, bool substringMode = false);

        static bool suffixMatch(string &strRef,string &sfx,bool equalAllowed=false);
        static bool prefixMatch(string &strRef,string &pfx,bool equalAllowed=false);
        static bool prefixMatchNoRef(string strRef,string pfx,bool equalAllowed=false);

    };
}
