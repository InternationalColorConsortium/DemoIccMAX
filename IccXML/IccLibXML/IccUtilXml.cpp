/** @file
    File:       IccUtilXml.cpp

    Contains:   Implementation of XML conversion utilities

    Version:    V1

    Copyright:  © see ICC Software License
*/

/*
 * The ICC Software License, Version 0.2
 *
 *
 * Copyright (c) 2003-2012 The International Color Consortium. All rights 
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer. 
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. In the absence of prior written permission, the names "ICC" and "The
 *    International Color Consortium" must not be used to imply that the
 *    ICC organization endorses or promotes products derived from this
 *    software.
 *
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE INTERNATIONAL COLOR CONSORTIUM OR
 * ITS CONTRIBUTING MEMBERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the The International Color Consortium. 
 *
 *
 * Membership in the ICC is encouraged when this software is used for
 * commercial purposes. 
 *
 *  
 * For more information on The International Color Consortium, please
 * see <http://www.color.org/>.
 *  
 * 
 */

#include <time.h>
#include "IccUtilXml.h"
#include "IccConvertUTF.h"

#ifdef WIN32
#include <windows.h>
#ifdef GetClassName
#undef GetClassName
#endif
#endif
#include <cstring> /* C strings strcpy, memcpy ... */

icTagSigType tagSignatureMap[] ={
	{ icSigChromaticityType			        , "chromaticityType"},
	{ icSigColorantOrderType		        , "colorantOrderType"},
	{ icSigColorantTableType            , "colorantTableType"},
	{ icSigCurveType                    , "curveType"},
  { icSigSegmentedCurveType           , "segmentedCurveType"},
	{ icSigDataType                     , "dataType"},
	{ icSigDateTimeType                 , "dateTimeType"},
  { icSigDictType                     , "dictType"},
  { icSigFloat16ArrayType             , "float16NumberType"},
  { icSigFloat32ArrayType             , "float32NumberType"},
  { icSigFloat64ArrayType             , "float64NumberType"},
  { icSigGamutBoundaryDescType        , "gamutBoundaryDescType"},
	{ icSigLut16Type                    , "lut16Type"},
	{ icSigLut8Type                     , "lut8Type"},
	{ icSigLutAtoBType                  , "lutAtoBType"},
	{ icSigLutBtoAType                  , "lutBtoAType"},
	{ icSigMeasurementType              , "measurementType"},
	{ icSigMultiLocalizedUnicodeType    , "multiLocalizedUnicodeType"},
	{ icSigMultiProcessElementType      , "multiProcessElementType"},
	{ icSigNamedColor2Type              , "namedColor2Type"},
	{ icSigParametricCurveType          , "parametricCurveType"},
	{ icSigProfileSequenceDescType      , "profileSequenceDescType"},
	{ icSigProfileSequceIdType          , "profileSequenceIdentifierType"},
	{ icSigResponseCurveSet16Type       , "responseCurveSet16Type"},
	{ icSigS15Fixed16ArrayType          , "s15Fixed16NumberType"},
	{ icSigSignatureType                , "signatureType"},
  { icSigSparseMatrixArrayType        , "sparseMatrixArrayType"},
  { icSigSpectralDataInfoType         , "spectralDataInfoType"},
  { icSigSpectralViewingConditionsType, "spectralViewingConditionsType"},
  { icSigTagArrayType                 , "tagArrayType"},
  { icSigTagStructType                , "tagStructureType"},
	{ icSigTextType                     , "textType"},
	{ icSigTextDescriptionType          , "textDescriptionType"},
	{ icSigU16Fixed16ArrayType          , "u16Fixed16NumberType"},
	{ icSigUInt16ArrayType              , "uInt16NumberType"},
	{ icSigUInt32ArrayType              , "uInt32NumberType"},
	{ icSigUInt64ArrayType              , "uInt64NumberType"},
	{ icSigUInt8ArrayType               , "uInt8NumberType"},
  { icSigUtf8TextType                 , "utf8TextType"},
  { icSigUtf16TextType                , "utf16TextType"},
	{ icSigViewingConditionsType        , "viewingConditionsType"},
	{ icSigXYZType                      , "XYZType"},
	{ icSigXYZArrayType                 , "XYZType"},
  { icSigZipUtf8TextType              , "zipUtf8TextType"},
  { icSigZipXmlType                   , "zipXmlType"},
	{ icSigUnknownType				          , "PrivateType"}
};
#define tagSignatureMapSize (sizeof(tagSignatureMap)/sizeof(tagSignatureMap[0]))


CIccUTF16String::CIccUTF16String()
{
  m_alloc=64;
  m_len = 0;
  m_str = (icUInt16Number*)calloc(m_alloc, sizeof(icUInt16Number));
}

CIccUTF16String::CIccUTF16String(const icUInt16Number *uzStr)
{
  m_len = WStrlen(uzStr);
  m_alloc = AllocSize(m_len);

  m_str = (icUInt16Number *)malloc(m_alloc*sizeof(icUInt16Number));
  memcpy(m_str, uzStr, m_len+1*sizeof(icUInt16Number));
}

CIccUTF16String::CIccUTF16String(const char *szStr)
{
  size_t sizeSrc = strlen(szStr);

  if (sizeSrc) {
    m_alloc = AllocSize(sizeSrc*2);
    m_str = (UTF16 *)calloc(m_alloc, sizeof(icUInt16Number)); //overallocate to allow for up to 4 bytes per character
    UTF16 *szDest = m_str;
    icConvertUTF8toUTF16((const UTF8 **)&szStr, (const UTF8 *)&szStr[sizeSrc], &szDest, &szDest[m_alloc], lenientConversion);
    if (m_str[0]==0xfeff) {
      size_t i;
      for (i=1; m_str[i]; i++)
        m_str[i-1] = m_str[i];
      m_str[i-1] = 0;
    }
    m_len = WStrlen(m_str);
  }
  else {
    m_alloc = 64;
    m_len = 0;
    m_str = (icUInt16Number*)calloc(m_alloc, sizeof(icUInt16Number));
  }
}

CIccUTF16String::CIccUTF16String(const CIccUTF16String &str)
{
  m_alloc = str.m_alloc;
  m_len = str.m_len;
  m_str = (icUInt16Number*)malloc(m_alloc*sizeof(icUInt16Number));

  memcpy(m_str, str.m_str, (m_alloc)*sizeof(icUInt16Number));
}

CIccUTF16String::~CIccUTF16String()
{
  free(m_str);
}

void CIccUTF16String::Clear()
{
  m_len = 0;
  m_str[0] = 0;
}

void CIccUTF16String::Resize(size_t len)
{
  if (len>m_alloc) {
    size_t nAlloc = AllocSize(len);

    m_str = (icUInt16Number*)realloc(m_str, m_alloc*sizeof(icUInt16Number));
  }

  if (len>m_len) {
    memset(&m_str[m_len], 0x0020, (len-m_len)*sizeof(icUInt16Number));
  }
  m_len = len;
  m_str[m_len] = 0;
}

size_t CIccUTF16String::WStrlen(const icUInt16Number *uzStr)
{
  size_t n=0;
  while(uzStr[n]) n++;

  return n;
}

CIccUTF16String& CIccUTF16String::operator=(const CIccUTF16String &wstr)
{
  if (m_alloc<=wstr.m_alloc) {
    m_str = (icUInt16Number*)realloc(m_str, m_alloc*sizeof(icUInt16Number));
    m_alloc = wstr.m_alloc;
  }
  m_len = wstr.m_len;

  memcpy(m_str, wstr.m_str, (m_len+1)*sizeof(icUInt16Number));

  return *this;
}

CIccUTF16String& CIccUTF16String::operator=(const char *szStr)
{
  FromUtf8(szStr, 0);

  return *this;
}

CIccUTF16String& CIccUTF16String::operator=(const icUInt16Number *uzStr)
{
  size_t n = WStrlen(uzStr);
  size_t nAlloc = AllocSize(n);

  if (m_alloc<=nAlloc) {
    m_str = (icUInt16Number*)realloc(m_str, m_alloc*sizeof(icUInt16Number));
    m_alloc =nAlloc;
  }
  m_len = n;

  memcpy(m_str, uzStr, (m_len+1)*sizeof(icUInt16Number));

  return *this;
}


void CIccUTF16String::FromUtf8(const char *szStr, size_t sizeSrc)
{
  if (!sizeSrc)
    sizeSrc = strlen(szStr);

  if (sizeSrc) {
    size_t nAlloc = AllocSize(sizeSrc*2);
    if (m_alloc<=nAlloc) {
      m_str = (icUInt16Number*)realloc(m_str, m_alloc*sizeof(icUInt16Number));
      m_alloc = nAlloc;
    }
    UTF16 *szDest = m_str;
    icConvertUTF8toUTF16((const UTF8 **)&szStr, (const UTF8 *)&szStr[sizeSrc], &szDest, &szDest[m_alloc], lenientConversion);
    if (m_str[0]==0xfeff) {
      size_t i;
      for (i=1; m_str[i]; i++)
        m_str[i-1] = m_str[i];
      m_str[i-1] = 0;
    }
    m_len = WStrlen(m_str);
  }
  else {
    m_len = 0;
    m_str[0] = 0;
  }
}

const char *CIccUTF16String::ToUtf8(std::string &buf)
{
  return icUtf16ToUtf8(buf, m_str, (int)m_len);
}

const wchar_t *CIccUTF16String::ToWString(std::wstring &buf)
{
  size_t i;

  buf.clear();

  for (i=0; i<m_len; i++) {
    buf += (wchar_t)m_str[i];
  }

  return buf.c_str();
}

const char *icFixXml(std::string &buf, const char *szStr)
{
  buf = "";
  while (*szStr) {
    switch (*szStr) {
    case '\'':
      buf += "&apos;";
      break;
    case '&':
      buf += "&amp;";
      break;
    case '\"':
      buf += "&quot;";
      break;
    case '<':
      buf += "&lt;";
      break;
    case '>':
      buf += "&gt;";
      break;
    default:
      buf += *szStr;
    }
    szStr++;
  }

  return buf.c_str();
}

const char *icFixXml(char *szDest, const char *szStr)
{
  char *ptr = szDest; 

  while (*szStr) {
    switch (*szStr) {
    case '\'':
      strcpy(ptr, "&apos;");
      ptr += 6;
      break;
    case '&':
      strcpy(ptr, "&amp;");
      ptr += 5;
      break;
    case '\"':
      strcpy(ptr, "&quot;");
      ptr += 6;
      break;
    case '<':
      strcpy(ptr, "&lt;");
      ptr += 4;
      break;
    case '>':
      strcpy(ptr, "&gt;");
      ptr += 4;
      break;
    default:
      *ptr++ = *szStr;
    }
    szStr++;
  }
  *ptr = '\0';

  return szDest;
}

const char *icUtf16ToUtf8(std::string &buf, const icUInt16Number *szSrc, int sizeSrc/*=0*/) 
{
  if (!sizeSrc) {
    sizeSrc = (int)CIccUTF16String::WStrlen(szSrc);
  }

  int n = sizeSrc*4;

  if (n) {
    char *szBuf = (char *)malloc(n+1);
    char *szDest = szBuf;
    icConvertUTF16toUTF8(&szSrc, &szSrc[sizeSrc], (UTF8**)&szDest, (UTF8*)&szDest[n+1], lenientConversion);
    *szDest= '\0';

    buf = szBuf;
    free(szBuf);
  }
  else {
    buf.clear();
  }

  return buf.c_str();
}

const unsigned short *icUtf8ToUtf16(CIccUTF16String &buf, const char *szSrc, int sizeSrc/*=0*/) 
{ 
  buf.FromUtf8(szSrc, sizeSrc);

  return buf.c_str();
}

const char *icAnsiToUtf8(std::string &buf, const char *szSrc)
{
#ifdef WIN32
  size_t len = strlen(szSrc)+1;
  wchar_t *szUnicodeBuf = (wchar_t*)malloc(len*sizeof(icUInt16Number)*2);
  char *szBuf = (char*)malloc(len*2);

  size_t n;

  n=MultiByteToWideChar(CP_ACP, 0, szSrc, (int)len-1, szUnicodeBuf, (int)len*2);
  szUnicodeBuf[n] = '\0';

  n = WideCharToMultiByte(CP_UTF8, 0, (const wchar_t*)szUnicodeBuf, (int)n, szBuf, (int)len*2, 0, NULL);
  szBuf[n] = '\0';

  buf = szBuf;

  free(szBuf);
  free(szUnicodeBuf);
#else
  buf = szSrc;
#endif
  return buf.c_str();
}

const char *icUtf8ToAnsi(std::string &buf, const char *szSrc)
{
#ifdef WIN32
  size_t len = strlen(szSrc)+1;
  wchar_t *szUnicodeBuf = (wchar_t*)malloc(len*sizeof(icUInt16Number)*2);
  char *szBuf = (char*)malloc(len*2);

  size_t n;

  n=MultiByteToWideChar(CP_UTF8, 0, szSrc, (int)len, szUnicodeBuf, (int)len*2);
  szUnicodeBuf[n] = '\0';

  n = WideCharToMultiByte(CP_ACP, 0, (const wchar_t*)szUnicodeBuf, (int)n, szBuf, (int)len*2, "?", NULL);
  szBuf[n] = '\0';

  buf = szBuf;

  free(szBuf);
  free(szUnicodeBuf);
#else
  buf = szSrc;
#endif
  return buf.c_str();
}

class CIccDumpXmlCLUT : public IIccCLUTExec
{
public:
  CIccDumpXmlCLUT(std::string *xml, icConvertType nType, std::string blanks, icUInt16Number nSamples, icUInt8Number nPixelsPerRow)
  {
    m_xml = xml;
    m_nType = nType;
    m_blanks = blanks;
    m_nSamples = nSamples;
    m_nPixelsPerRow = nPixelsPerRow;
    m_nCurPixel = 0;
  }

  virtual void PixelOp(icFloatNumber* pGridAdr, icFloatNumber* pData)
  {
    int i;
    char buf[128];

    if (!(m_nCurPixel % m_nPixelsPerRow))
      *m_xml += m_blanks;

    switch(m_nType) {
      case icConvert8Bit:
        for (i=0; i<m_nSamples; i++) {
          sprintf(buf, " %3d", (icUInt8Number)(pData[i]*255.0 + 0.5));
          *m_xml += buf;
        }
        break;
      case icConvert16Bit:
        for (i=0; i<m_nSamples; i++) {
          sprintf(buf, " %5d", (icUInt16Number)(pData[i]*65535.0 + 0.5));
          *m_xml += buf;
        }
        break;
      case icConvertFloat:
      default:
        for (i=0; i<m_nSamples; i++) {
          sprintf(buf, " %13.8f", pData[i]);
          *m_xml += buf;
        }
        break;
    }
    m_nCurPixel++;
    if (!(m_nCurPixel % m_nPixelsPerRow)) {
      *m_xml += "\n";
    }
  }

  void Finish()
  {
    if (m_nCurPixel % m_nPixelsPerRow) {
      *m_xml += "\n";
    }
  }

  std::string *m_xml;
  icConvertType m_nType;
  std::string m_blanks;
  icUInt16Number m_nSamples;
  icUInt8Number m_nPixelsPerRow;
  icUInt32Number m_nCurPixel;
};

bool icCLUTDataToXml(std::string &xml, CIccCLUT *pCLUT, icConvertType nType, std::string blanks, 
                     bool bSaveGridPoints/*=false*/)
{
  char buf[128];
  if (nType == icConvertVariable) {
    nType = pCLUT->GetPrecision()==1 ? icConvert8Bit : icConvert16Bit;
  }

  if (bSaveGridPoints) {
    xml += blanks + "  <GridPoints>";
    int i;

    for (i=0; i<pCLUT->GetInputDim(); i++) {
      if (i)
        sprintf(buf, " %d", pCLUT->GridPoint(i));
      else
        sprintf(buf, "%d", pCLUT->GridPoint(i));
      xml += buf;
    }
    xml += "</GridPoints>\n";
  }

  int nPixelsPerRow = pCLUT->GridPoint(0);

  // if the CLUT has no GridPoints, profile is invalid
  if (nPixelsPerRow == 0) {
    printf("\nError! - CLUT Table not found.\n");
    return false;
  }

  CIccDumpXmlCLUT dumper(&xml, nType, blanks + "   ", pCLUT->GetOutputChannels(), nPixelsPerRow);

  xml += blanks + "  <TableData>\n";
  pCLUT->Iterate(&dumper);

  dumper.Finish();

  xml += blanks + "  </TableData>\n";

  return true;

}

bool icCLUTToXml(std::string &xml, CIccCLUT *pCLUT, icConvertType nType, std::string blanks, 
                 bool bSaveGridPoints/*=false*/, const char *szExtraAttrs/*=""*/, const char *szName/*="CLUT"*/)
{
  char buf[128];
  xml += blanks + "<" + szName;
 
  if (!bSaveGridPoints) {
    sprintf(buf, " GridGranularity=\"%d\"", pCLUT->GridPoint(0));
    xml += buf;
  }

   if (szExtraAttrs && *szExtraAttrs) {
    xml += szExtraAttrs;
  }
  xml += ">\n";

  icCLUTDataToXml(xml, pCLUT, nType, blanks, bSaveGridPoints);

  xml += blanks + "</" + szName + ">\n";
  return true;
}

icFloatNumber icXmlStrToFloat(const xmlChar *szStr)
{
  float f=0.0;
  sscanf((const char*)szStr, "%f", &f);

  return (icFloatNumber)f;
}

icSignature icXmlStrToSig(const char *szStr)
{
  return icGetSigVal(szStr);
}

const char *icXmlAttrValue(xmlAttr *attr, const char *szDefault)
{
  if (attr && attr->children && attr->children->type == XML_TEXT_NODE && attr->children->content)
    return (const char*)attr->children->content;

  return szDefault;
}

const char *icXmlAttrValue(xmlNode *pNode, const char *szName, const char *szDefault)
{
  xmlAttr *attr = icXmlFindAttr(pNode, szName);
  if (attr) {
    return icXmlAttrValue(attr, szDefault);
  }
  return szDefault;
}

icUInt32Number icXmlGetChildSigVal(xmlNode *pNode)
{
  if (!pNode || !pNode->children || !pNode->children->content)
    return 0;

  return icGetSigVal((const char*)pNode->children->content);
}

static int hexValue(char c)
{
  if (c>='0' && c<='9')
    return c-'0';
  if (c>='A' && c<='F')
    return c-'A'+10;
  if (c>='a' && c<='f')
    return c-'a'+10;
  return -1;
}


icUInt32Number icXmlGetHexData(void *pBuf, const char *szText, icUInt32Number nBufSize)
{
  unsigned char *pDest = (unsigned char*)pBuf;
  icUInt32Number rv =0;

  while(*szText && rv<nBufSize) {
    int c1=hexValue(szText[0]);
    int c2=hexValue(szText[1]);
    if (c1>=0 && c2>=0) {
      *pDest = c1*16+ c2;
      pDest++;
      szText +=2;
      rv++;
    }
    else {
      szText++;
    }
  }
  return rv;
}

icUInt32Number icXmlGetHexDataSize(const char *szText)
{
  icUInt32Number rv =0;

  while(*szText) {
    int c1=hexValue(szText[0]);
    int c2=hexValue(szText[1]);
    if (c1>=0 && c2>=0) {
      szText +=2;
      rv++;
    }
    else {
      szText++;
    }
  }
  return rv;
}

icUInt32Number icXmlDumpHexData(std::string &xml, std::string blanks, void *pBuf, icUInt32Number nBufSize)
{
  icUInt8Number *ptr = (icUInt8Number *)pBuf;
  char buf[15];
  icUInt32Number i;

  for (i=0; i<nBufSize; i++, ptr++) {
    if (!(i%32)) {
      if (i)
        xml += "\n";
      xml += blanks;
    }
    sprintf(buf, "%02x", *ptr);
    xml += buf; 
  }
  if (i) {
    xml += "\n";
  }
  return i;
}

xmlAttr *icXmlFindAttr(xmlNode *pNode, const char *szAttrName)
{
  if (!pNode) return NULL;

  xmlAttr *attr;

  for (attr = pNode->properties; attr; attr = attr->next) {
    if (attr->type != XML_ATTRIBUTE_NODE)
      continue;

    if (!icXmlStrCmp(attr->name, szAttrName)) {
      return attr;
    }
  }

  return NULL;
}

xmlNode *icXmlFindNode(xmlNode *pNode, const char *szNodeName)
{
  if (!pNode) return NULL;

  for (; pNode; pNode = pNode->next) {
    if (pNode->type != XML_ELEMENT_NODE)
      continue;

    if (!icXmlStrCmp(pNode->name, szNodeName)) {
      return pNode;
    }
  }

  return NULL;
}

icUInt32Number icXmlNodeCount(xmlNode *pNode, const char *szNodeName)
{
  icUInt32Number rv = 0;
  for (; pNode; pNode = pNode->next) {
    if (pNode->type == XML_ELEMENT_NODE &&
        !icXmlStrCmp(pNode->name, szNodeName)) {
      rv++;
    }
  }
  return rv;
}

template <class T, icTagTypeSignature Tsig>
CIccXmlArrayType<T, Tsig>::CIccXmlArrayType()
{
  m_pBuf = NULL;
  m_nSize = 0;
}

template <class T, icTagTypeSignature Tsig>
CIccXmlArrayType<T, Tsig>::~CIccXmlArrayType()
{
  if (m_pBuf) {
    free(m_pBuf);
  }
}

template <class T, icTagTypeSignature Tsig>
bool CIccXmlArrayType<T, Tsig>::ParseArray(xmlNode *pNode)
{
  char *scanType = (Tsig == icSigFloatArrayType ? "f" : "n");
  icUInt32Number n = icXmlNodeCount(pNode, scanType);
  
  if (n) {
    if (!SetSize(n))
      return false;
    return ParseArray(m_pBuf, m_nSize, pNode);
  }

  for ( ;pNode && pNode->type!= XML_TEXT_NODE; pNode=pNode->next);

  if (!pNode || !pNode->content)
    return false;

  n = ParseTextCount((const char*)pNode->content);

  if (!n || !SetSize(n))
    return false;

  return ParseArray(m_pBuf, m_nSize, pNode);
}

template <class T, icTagTypeSignature Tsig>
bool CIccXmlArrayType<T, Tsig>::ParseTextArray(const char *szText)
{
  icUInt32Number n = ParseTextCount(szText);

  if (n) {
    if (!SetSize(n))
      return false;

    return ParseText(m_pBuf, m_nSize, szText)==m_nSize;
  }

  return false;
}

template <class T, icTagTypeSignature Tsig>
bool CIccXmlArrayType<T, Tsig>::ParseTextArray(xmlNode *pNode)
{
  if (pNode->children && pNode->children->type==XML_TEXT_NODE) {
    return ParseTextArray((const char*)pNode->children->content);
  }
  return false;
}

template <class T, icTagTypeSignature Tsig>
bool CIccXmlArrayType<T, Tsig>::ParseTextArrayNum(const char *szText, icUInt32Number num, std::string &parseStr)
{
  icUInt32Number n = ParseTextCountNum(szText, num, parseStr);
  if (n) {	  
    if (!SetSize(n))
      return false;
    return ParseText(m_pBuf, m_nSize, szText)==m_nSize;
  }

  return false;
}

template <class T, icTagTypeSignature Tsig>
bool CIccXmlArrayType<T, Tsig>::DumpArray(std::string &xml, std::string blanks, T *buf, icUInt32Number nBufSize, 
                                          icConvertType nType,  icUInt8Number nColumns)
{
  char str[200];

  if (!nColumns) nColumns = 1;
  icUInt32Number i;

  for (i=0; i<nBufSize; i++) {
    if (!(i%nColumns)) {
      xml += blanks;
    }
    else {
      xml += " ";
    }

    switch (Tsig) {
      case icSigUInt8ArrayType:
        switch (nType) {
          case icConvert8Bit:
          default:
            sprintf(str, "%u", buf[i]);
            break;

          case icConvert16Bit:
            sprintf(str, "%u", (icUInt16Number)((icFloatNumber)buf[i] * 65535.0 / 255.0 + 0.5));
            break;

          case icConvertFloat:
            sprintf(str, "%.8f", (icFloatNumber)buf[i] / 255.0);
            break;
        }
        break;

      case icSigUInt16ArrayType:
        switch (nType) {
          case icConvert8Bit:
            sprintf(str, "%u", (icUInt16Number)((icFloatNumber)buf[i] * 255.0 / 65535.0 + 0.5));
            break;

          case icConvert16Bit:
          default:
            sprintf(str, "%u", buf[i]);
            break;

          case icConvertFloat:
            sprintf(str, "%.8f", (icFloatNumber)buf[i] / 65535.0);
            break;
        }
        break;

      case icSigUInt32ArrayType:
        sprintf(str, "%u", buf[i]);
        break;

      case icSigFloatArrayType:
      case icSigFloat32ArrayType:
      case icSigFloat64ArrayType:
        switch (nType) {
          case icConvert8Bit:
            sprintf(str, "%u", (icUInt8Number)(buf[i] * 255.0 + 0.5));
            break;

          case icConvert16Bit:
            sprintf(str, "%u", (icUInt16Number)(buf[i] * 65535.0 + 0.5));
            break;

          case icConvertFloat:
          default:
            sprintf(str, "%.8f", buf[i]);
        }
        break;
    }
    xml += str;
    if (i%nColumns == nColumns-1) {
      xml += "\n";
    }
  }

  if (i%nColumns) {
    xml += "\n";
  }

  return true;
}

// for multi-platform support
// replaced "_inline" with "inline"
static inline bool icIsNumChar(char c)
{
  if ((c>='0' && c<='9') || c=='.' || c=='+' || c=='-' || c=='e')
    return true;
  return false;
}

// function used when checking contents of a file
// count the number of entries.
template <class T, icTagTypeSignature Tsig>
icUInt32Number CIccXmlArrayType<T, Tsig>::ParseTextCountNum(const char *szText, icUInt32Number num, std::string &parseStr)
{
  icUInt32Number n = 0;
  bool bInNum = false;
  //icUInt32Number count = 1;
  
  //while (*szText) {
  for (icUInt32Number i=0; i<num; i++) {
	  if (icIsNumChar(*szText)) {
		  if (!bInNum) {
			  bInNum = true;
		  }
	  }
    else if (bInNum && !strncmp(szText, "#QNAN", 5)) { //Handle 1.#QNAN000 (non a number)
      i+=4;
      szText+=4;
    }
	  // an invalid character is encountered (not digit and not space)
	  else if (!isspace(*szText) && i <= num ){
		  char line[100];
		  sprintf(line, "Data '%c' in position %d is not a number. ", *szText, i);
		  parseStr += line;
		  return false;
	  }
	  else if (bInNum) { //char is a space
		  n++;
		  bInNum = false;
	  }	  
	  szText++;
	  //count++;
  }
  if (bInNum) {
    n++;
  }

  return n;
}

template <class T, icTagTypeSignature Tsig>
icUInt32Number CIccXmlArrayType<T, Tsig>::ParseTextCount(const char *szText)
{
  icUInt32Number n = 0;
  bool bInNum = false;

  while (*szText) {
    if (icIsNumChar(*szText)) {
      if (!bInNum) {
        bInNum = true;
      }
    }
    else if (bInNum && !strncmp(szText, "#QNAN", 5)) { //Handle 1.#QNAN000 (non a number)
      szText+=4;
    }
    else if (bInNum) {
      n++;
      bInNum = false;
    }
    szText++;
  }
  if (bInNum) {
    n++;
  }

  return n;
}

template <class T, icTagTypeSignature Tsig>
icUInt32Number CIccXmlArrayType<T, Tsig>::ParseText(T* pBuf, icUInt32Number nSize, const char *szText)
{	
  icUInt32Number n = 0, b;
  bool bInNum = false;
  char num[256];

  while (*szText && n<nSize) {	  
	  if (icIsNumChar(*szText)) {
      if (!bInNum) {
        bInNum = true;
        b=0;
      }
      num[b] = *szText;
 
      if (b+2<sizeof(num))
        b++;
    }
    else if (bInNum) {
      num[b] = 0;
      pBuf[n] = (T)atof(num);
      n++;
      bInNum = false;
    }
    szText++;
  }
  if (bInNum) {
    num[b] = 0;
    pBuf[n] = (T)atof(num);
    n++;
  } 

  return n;
}

template <class T, icTagTypeSignature Tsig>
bool CIccXmlArrayType<T, Tsig>::ParseArray(T* pBuf, icUInt32Number nSize, xmlNode *pNode)
{
  icUInt32Number n;
  if (Tsig==icSigFloatArrayType) {
    n = icXmlNodeCount(pNode, "f");

    if (!n) {
      if (pNode->type!=XML_TEXT_NODE || !pNode->content)
        return false;

      n = ParseTextCount((const char*)pNode->content);
      if (!n || n>nSize)
        return false;

      ParseText(pBuf, n, (const char*)pNode->content);
    }
    else {
      if (n>nSize)
        return false;

      icUInt32Number i;
      for (i=0; i<nSize && pNode; pNode = pNode->next) {
        if (pNode->type == XML_ELEMENT_NODE &&
          !icXmlStrCmp(pNode->name, "f") &&
          pNode->children &&
          pNode->children->content) {
            float f;
            sscanf((const char *)(pNode->children->content), "%f", &f);
            pBuf[i] = (T)f;
            i++;
        }
      }
    }
  }
  else {
    n = icXmlNodeCount(pNode, "n");

    if (!n) {
      if (pNode->type!=XML_TEXT_NODE || !pNode->content)
        return false;

      n = ParseTextCount((const char *)pNode->content);
      if (!n || n>nSize)
        return false;

      n = ParseText(pBuf, n, (const char *)pNode->content);
    }
    else {
      if (n>nSize)
        return false;

      icUInt32Number i;
      for (i=0; i<nSize && pNode; pNode = pNode->next) {
        if (pNode->type == XML_ELEMENT_NODE &&
          !icXmlStrCmp(pNode->name, "n") &&
          pNode->children &&
          pNode->children->content) {
            pBuf[i] = (T)atol((const char *)(pNode->children->content));
            i++;
        }
      }
    }
  }
  return nSize==n;
}


template <class T, icTagTypeSignature Tsig>
bool CIccXmlArrayType<T, Tsig>::SetSize(icUInt32Number nSize)
{
  if (m_pBuf) {
    free(m_pBuf);
  }
  m_pBuf = (T*)malloc(nSize * sizeof(T));
  if (!m_pBuf) {
    m_nSize = 0;
    return false;
  }
  m_nSize = nSize;

  return true;
}

//Make sure typedef classes get built
template class CIccXmlArrayType<icUInt8Number, icSigUInt8ArrayType>;
template class CIccXmlArrayType<icUInt16Number, icSigUInt16ArrayType>;
template class CIccXmlArrayType<icUInt32Number, icSigUInt32ArrayType>;
template class CIccXmlArrayType<icUInt64Number, icSigUInt64ArrayType>;
template class CIccXmlArrayType<icFloatNumber, icSigFloatArrayType>;
template class CIccXmlArrayType<icFloat32Number, icSigFloat32ArrayType>;
template class CIccXmlArrayType<icFloat64Number, icSigFloat64ArrayType>;


const icRenderingIntent icGetRenderingIntentValue (icChar *szRenderingIntent)
{
  if (szRenderingIntent == "Perceptual")
	  return icPerceptual;
  else if (szRenderingIntent == "Media-relative colorimetric")
	  return icRelativeColorimetric;
  else if (szRenderingIntent == "Saturation")
	  return icSaturation;
  else if (szRenderingIntent == "ICC-absolute colorimetric")
	  return icAbsoluteColorimetric;
  
  return icPerceptual;
}

const icChar* icGetTagSigTypeName(icTagTypeSignature tagSig)
{
  //loop through the list of all tag signatures
  for (int i=0; i<tagSignatureMapSize; i++) {
	if ( tagSignatureMap[i].tagSig == tagSig )
		return tagSignatureMap[i].szTagType;
  } 
  
  // if  the tag signature is not found, it is a custom type.
  return "PrivateType";
}

const icTagTypeSignature icGetTypeNameTagSig(const icChar* szTagType)
{	
  //loop through the list of all tag signatures
  for (int i=0; i<tagSignatureMapSize; i++) {
   if (!strcmp((const char*)tagSignatureMap[i].szTagType, szTagType))  
	 return tagSignatureMap[i].tagSig;
  }

   // if  the tag signature is not found, it is a custom type.
  return icSigUnknownType;
}

icStandardObserver icGetNamedStandardObserverValue(const icChar* str)
{
  if (!strcmp(str, "Unknown observer"))
	  return icStdObsUnknown;

  if (!strcmp(str, "CIE 1931 standard colorimetric observer"))
	  return icStdObs1931TwoDegrees;

  if (!strcmp(str, "CIE 1964 standard colorimetric observer"))
	  return icStdObs1964TenDegrees;   

  return icStdObsCustom;
}


icMeasurementGeometry icGeNamedtMeasurementGeometryValue(const icChar* str)
{
  if (!strcmp(str, "Geometry Unknown"))
  	return icGeometryUnknown;
 
  if (!strcmp(str, "Geometry 0-45 or 45-0"))
	  return icGeometry045or450;

  if (!strcmp(str, "Geometry 0-d or d-0"))
	  return icGeometry0dord0;

  if (!strcmp(str, "Max Geometry"))
	  return icMaxEnumGeometry;  

  return icGeometryUnknown;
}

icMeasurementFlare icGetNamedMeasurementFlareValue(const icChar * str)
{
  if (!strcmp(str, "Flare 0"))
	  return icFlare0;
 
  if (!strcmp(str, "Flare 100"))
	  return icFlare100;
  
  if (!strcmp(str, "Max Flare"))
	  return icMaxEnumFlare;

  return icFlare0;
}

icIlluminant icGetIlluminantValue(const icChar* str)
{
  if (!strcmp(str, "Illuminant Unknown"))
	  return icIlluminantUnknown;
 
  if (!strcmp(str, "Illuminant D50") || !strcmp(str, "D50"))  
	  return icIlluminantD50;  

  if (!strcmp(str, "Illuminant D65") || !strcmp(str, "D65"))
	  return icIlluminantD65;

  if (!strcmp(str, "Illuminant D93") || !strcmp(str, "D93"))
	  return icIlluminantD93;

  if (!strcmp(str, "Illuminant F2") || !strcmp(str, "F2"))
	  return icIlluminantF2;
  
  if (!strcmp(str, "Illuminant D55") || !strcmp(str, "D55"))
	  return icIlluminantD55;
  
  if (!strcmp(str, "Illuminant A") || !strcmp(str, "A"))
	  return icIlluminantA;  

  if (!strcmp(str, "Illuminant EquiPowerE") || !strcmp(str, "Illuminant E") || !strcmp(str, "E"))
	  return icIlluminantEquiPowerE;

  if (!strcmp(str, "Illuminant F8") || !strcmp(str, "F8"))
	  return icIlluminantF8; 
  
  if (!strcmp(str, "Illuminant Black Body") || !strcmp(str, "Black Body"))
    return icIlluminantBlackBody;

  if (!strcmp(str, "Illuminant Daylight") || !strcmp(str, "Daylight"))
    return icIlluminantDaylight;

  if (!strcmp(str, "Illuminant B") || !strcmp(str, "B"))
    return icIlluminantB;

  if (!strcmp(str, "Illuminant C") || !strcmp(str, "C"))
    return icIlluminantC;

  if (!strcmp(str, "Illuminant F1") || !strcmp(str, "F1"))
    return icIlluminantF1;

  if (!strcmp(str, "Illuminant F3") || !strcmp(str, "F3"))
    return icIlluminantF3;

  if (!strcmp(str, "Illuminant F4") || !strcmp(str, "F4"))
    return icIlluminantF4;

  if (!strcmp(str, "Illuminant F5") || !strcmp(str, "F5"))
    return icIlluminantF5;

  if (!strcmp(str, "Illuminant F6") || !strcmp(str, "F6"))
    return icIlluminantF6;

  if (!strcmp(str, "Illuminant F7") || !strcmp(str, "F7"))
    return icIlluminantF7;

  if (!strcmp(str, "Illuminant F9") || !strcmp(str, "F9"))
    return icIlluminantF9;

  if (!strcmp(str, "Illuminant F10") || !strcmp(str, "F10"))
    return icIlluminantF10;

  if (!strcmp(str, "Illuminant F11") || !strcmp(str, "F11"))
    return icIlluminantF11;

  if (!strcmp(str, "Illuminant F12") || !strcmp(str, "F12"))
    return icIlluminantF12;
  
  return icIlluminantCustom;
}

const icChar* icGetStandardObserverName(icStandardObserver str)
{
  switch (str) {
  case icStdObsUnknown:
    return "Unknown Observer";

  case icStdObs1931TwoDegrees:
    return "CIE 1931 standard colorimetric observer";

  case icStdObs1964TenDegrees:
    return "CIE 1964 standard colorimetric observer";

  default:    
    return "Unknown Observer";
  }
}

icDateTimeNumber icGetDateTimeValue(const icChar* str)
{
	unsigned int day=0, month=0, year=0, hours=0, minutes=0, seconds=0;
	icDateTimeNumber dateTime;	

  if (!stricmp(str, "now")) {
    time_t rawtime;
    struct tm * timeinfo;

    time ( &rawtime );
    timeinfo = localtime ( &rawtime );
    year = timeinfo->tm_year+1900;
    month = timeinfo->tm_mon+1;
    day = timeinfo->tm_mday;
    hours = timeinfo->tm_hour;
    minutes = timeinfo->tm_min;
    seconds = timeinfo->tm_sec;
  }
  else {
  	sscanf(str, "%d-%02d-%02dT%02d:%02d:%02d", &year, &month, &day, &hours, &minutes, &seconds);
  }

	dateTime.year = year;
	dateTime.month = month;
	dateTime.day = day;
	dateTime.hours = hours;
	dateTime.minutes = minutes;
	dateTime.seconds = seconds;
	
	return dateTime;		
}

icUInt64Number icGetDeviceAttrValue(xmlNode *pNode)
{	
	icUInt64Number devAttr = 0;
	xmlAttr *attr = icXmlFindAttr(pNode, "ReflectiveOrTransparency");
  if (attr && !strcmp(icXmlAttrValue(attr), "transparency")) {
    devAttr |= icTransparency;
  }

	attr = icXmlFindAttr(pNode, "GlossyOrMatte");
  if (attr && !strcmp(icXmlAttrValue(attr), "matte")) {
    devAttr |= icMatte;
	}

	attr = icXmlFindAttr(pNode, "MediaPolarity");
  if (attr && !strcmp(icXmlAttrValue(attr), "negative")) {
    devAttr |= icMediaNegative;
  }

	attr = icXmlFindAttr(pNode, "MediaColour");
  if (attr && !strcmp(icXmlAttrValue(attr), "blackAndWhite")) {
		devAttr |= icMediaBlackAndWhite;
	}
	
  attr = icXmlFindAttr(pNode, "VendorSpecific");
  if (attr) {
    icUInt64Number vendor;
    sscanf(icXmlAttrValue(attr), "%I64x", &vendor);
    devAttr |= vendor;
  }

	return devAttr;
}

icColorantEncoding icGetColorantValue(const icChar* str)
{
	if (!strcmp(str, "ITU-R BT.709"))  
		return icColorantITU;  

	if (!strcmp(str, "SMPTE RP145-1994"))  
		return icColorantSMPTE;  

	if (!strcmp(str, "EBU Tech.3213-E"))  
		return icColorantEBU;  

	if (!strcmp(str, "P22"))  
		return icColorantP22;  

  return icColorantUnknown;
}

icMeasurementUnitSig icGetMeasurementValue(const icChar* str)
{
	if (!strcmp(str, "Status A"))  
		return icSigStatusA;  

	if (!strcmp(str, "Status E"))  
		return icSigStatusE;  

	if (!strcmp(str, "Status I"))  
		return icSigStatusI;  

	if (!strcmp(str, "Status T"))  
		return icSigStatusT;  

	if (!strcmp(str, "Status M"))  
		return icSigStatusM;  

	if (!strcmp(str, "DIN with no polarizing filter"))  
		return icSigDN;  

	if (!strcmp(str, "DIN with polarizing filter"))  
		return icSigDNP;  

	if (!strcmp(str, "Narrow band DIN with no polarizing filter"))  
		return icSigDNN;  

	if (!strcmp(str, "Narrow band DIN with polarizing filter"))  
		return icSigDNNP; 

  return icSigStatusA;
}

const std::string icGetDeviceAttrName(icUInt64Number devAttr)
{
	char line[256];
	std::string xml;
		
	if (devAttr & icTransparency)
		sprintf(line, "<DeviceAttributes ReflectiveOrTransparency=\"transparency\"");
	else
		sprintf(line, "<DeviceAttributes ReflectiveOrTransparency=\"reflective\"");	 
	xml += line;
 
	
	if (devAttr & icMatte)
		sprintf(line, " GlossyOrMatte=\"matte\"");
	else
		sprintf(line, " GlossyOrMatte=\"glossy\"");	
	xml += line;
	
	
	if (devAttr & icMediaNegative)
		sprintf(line, " MediaPolarity=\"negative\"");
	else
		sprintf(line, " MediaPolarity=\"positive\"");
	xml += line;
	
	if (devAttr & icMediaBlackAndWhite)
		sprintf(line, " MediaColour=\"blackAndwhite\"");		
	else
		sprintf(line, " MediaColour=\"colour\"");	
	xml += line;

  icUInt64Number otherAttr = ~((icUInt64Number)icTransparency|icMatte|icMediaNegative|icMediaBlackAndWhite);

  if (devAttr & otherAttr) {
    sprintf(line, " VendorSpecific=\"%016I64x\"", devAttr & otherAttr);
    xml += line;  		
  }

  xml += "/>\n";

	return xml;
}

const std::string icGetHeaderFlagsName(icUInt32Number flags)
{
	char line[256];
	std::string xml;	

  if (flags & icEmbeddedProfileTrue)
		sprintf(line, "<ProfileFlags EmbeddedInFile=\"true\" ");
	else
	  sprintf(line, "<ProfileFlags EmbeddedInFile=\"false\" ");	
	xml += line;

	if (flags & icUseWithEmbeddedDataOnly)
		sprintf(line, "UseWithEmbeddedDataOnly=\"true\"");
	else
		sprintf(line, "UseWithEmbeddedDataOnly=\"false\"");
	xml += line;

  icUInt32Number otherFlags = ~(icEmbeddedProfileTrue|icUseWithEmbeddedDataOnly);

  if (flags & otherFlags) {
    sprintf(line, " VendorFlags=\"%08x\"", flags & otherFlags);
    xml += line;  		
  }

  xml += "/>\n";

  return xml;
}

const std::string icGetPadSpace(double value)
{
  std::string space = "";  
  if ( value >=0 && value < 10)
    space = "    ";
  if ( value >=10 && value < 100)
	space = "   ";
   if ( value >=100 && value < 1000 )
	space = "  ";

   return space;
}

