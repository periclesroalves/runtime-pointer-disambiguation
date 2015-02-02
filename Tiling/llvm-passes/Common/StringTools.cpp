#include "StringTools.h"

std::string &StringTools::ltrim(std::string &s) {
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
    return s;
}

// trim from end
std::string &StringTools::rtrim(std::string &s) {
    s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
    return s;
}

// trim from both ends
std::string &StringTools::trim(std::string &s) {
    return ltrim(rtrim(s));
}

string &StringTools::stripQuotes(std::string &s)
{
    if(s.at(0)=='"')
    {
        assert(s.at(s.length()-1)=='"');
        s.erase(0,1);
        s.erase(s.length()-1,1);
    }

    return s;
}


std::vector<std::string> &StringTools::split(const std::string &str, char delim, std::vector<std::string> &elems){
    //    llvm::raw_string_ostream ss(str);
    std::stringstream ss(str);
    std::string item;
    while (std::getline(ss, item, delim)) {
        //trim(item);
        if(item.size()>0)
            elems.push_back(item);
    }
    return elems;
}

std::vector<std::string> StringTools::split(const std::string &str, char delim){
    std::vector<std::string> elems;
    split(str, delim, elems);
    return elems;
}

bool StringTools::arrayContains(std::vector<std::string> &elems, const std::string &str, bool substringMode){
    bool contains = false;
    for(auto it = elems.begin();it!=elems.end();it++){
        string &elem = *it;
        if(substringMode){
            contains |= (elem.find(str) != string::npos);
        }
        else{
            contains |= (str.compare(elem)==0);    
        }
    }
    return contains;
}

bool StringTools::suffixMatch(string &strRef,string &sfx,bool equalAllowed){
    return (equalAllowed ? strRef.size()>=sfx.size() : strRef.size()>sfx.size()) && strRef.substr(strRef.size()-sfx.size(),sfx.size()).compare(sfx)==0;
}

bool StringTools::prefixMatch(string &strRef,string &pfx,bool equalAllowed){
    return (equalAllowed ? strRef.size()>=pfx.size() : strRef.size()>pfx.size()) && strRef.substr(0,pfx.size()).compare(pfx)==0;
}

bool StringTools::prefixMatchNoRef(string strRef,string pfx,bool equalAllowed){
    return prefixMatch(strRef,pfx,equalAllowed);
}



