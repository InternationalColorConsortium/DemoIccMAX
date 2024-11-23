#ifndef _ICCJSONUTIL_H
#define _ICCJSONUTIL_H

#include <nlohmann/json.hpp>
#include "../../../IccProfLib/IccDefs.h"

using namespace nlohmann;

template <class T>
std::string arrayToJson(T *a, int nCount);

template<typename T>
std::string valueToJson(const char* name, T v);

template<>
std::string valueToJson(const char* name, const char* v);

template<>
std::string valueToJson(const char* name, char* v);

std::string valueToJson(const char* name, const char* v, bool& bPreviousLine);

template<>
std::string valueToJson(const char* name, float v);

template<>
std::string valueToJson(const char* name, double v);

template<>
std::string valueToJson(const char* name, const std::string &);

std::string valueToJsonUuid(const char* name, const char* v, bool bBinary=false);

std::string fixJsonString(const char* v);

template <typename T>
bool jsonToValue(const json& j, T& nValue);

template <>
bool jsonToValue(const json& j, bool& nValue);

template <>
bool jsonToValue(const json& j, std::string& nValue);

bool jsonToString(const json& j, std::string& value);

template <typename T>
bool jsonToArray(const json& v, T* vals, int n);

template <typename T>
bool jsonToArray(const json& v, std::vector<T>& vals);

bool jsonToArray(const json& v, std::vector<std::string>& vals);

bool jsonToList(const json& v, std::list<std::string>& vals);

bool jsonToCStr(const json& j, char* str, int nSize);

bool jsonToColorSpace(const json& j, icColorSpaceSignature& sig);

bool saveJsonAs(const json& j, const char* szFname, int indent=1);
bool loadJsonFrom(json& j, const char* szFname);

#endif //_JSONUTIL
