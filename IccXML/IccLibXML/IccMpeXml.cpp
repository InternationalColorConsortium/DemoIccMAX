/** @file
    File:       IccMpeXml.cpp

    Contains:   Implementation of MultiProcessElementType Element XML
                conversion functionality

    Version:    V1

    Copyright:  (c) see ICC Software License
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
#include "IccTagXml.h"
#include "IccMpeXml.h"
#include "IccUtilXml.h"
#include "IccIoXml.h"
#include "IccCam.h"

#include <cstring> /* C strings strcpy, memcpy ... */

#ifdef WIN32
#include <windows.h>
#ifdef GetClassName
#undef GetClassName
#endif
#endif

#ifdef USEREFICCMAXNAMESPACE
namespace refIccMAX {
#endif

bool CIccMpeXmlUnknown::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  icUInt8Number *ptr = m_pData;

  char line[256];
  char buf[256];
  char fix[256];
  sprintf(line, "<UnknownElement Type=\"%s\" InputChannels=\"%d\" OutputChannels=\"%d\"", 
           icFixXml(fix, icGetSigStr(buf, GetType())), NumInputChannels(), NumOutputChannels());
  xml += blanks + line;

  if (m_nReserved) {
    sprintf(line, " Reserved=\"%u\"", m_nReserved);
    xml += buf;
  }
  xml += ">\n";

  icXmlDumpHexData(xml, blanks + "  ", m_pData, m_nSize);

  xml += blanks + "</UnknownElement>\n";
  return true;
}


bool CIccMpeXmlUnknown::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  SetType((icElemTypeSignature)icXmlStrToSig(icXmlAttrValue(pNode, "type")));
  SetChannels(atoi(icXmlAttrValue(pNode, "InputChannels")), atoi(icXmlAttrValue(pNode, "OutputChannels")));

  if (pNode->children && pNode->children->type == XML_TEXT_NODE && pNode->children->content) {
    icUInt32Number nSize = icXmlGetHexDataSize((const char *)pNode->children->content);

    if (!SetDataSize(nSize, false)) 
      return false;

    icXmlGetHexData(m_pData, (const char *)pNode->children->content, nSize);
  }
  else {
    SetDataSize(0);
  }
  return true;
}


class CIccFormulaCurveSegmentXml : public CIccFormulaCurveSegment
{
public:
  CIccFormulaCurveSegmentXml(icFloatNumber start, icFloatNumber end) : CIccFormulaCurveSegment(start, end) {}

  bool ToXml(std::string &xml, std::string blanks/* = ""*/);
  bool ParseXml(xmlNode *pNode, std::string &parseStr);
};

static char* icSegPos(char *buf, icFloatNumber pos)
{
  if (pos==icMinFloat32Number)
    strcpy(buf, "-infinity");
  else if (pos==icMaxFloat32Number)
    strcpy(buf, "+infinity");
  else
    sprintf(buf, "%.8" ICFLOATSFX, pos);

  return buf;
}

icFloatNumber icGetSegPos(const char *str)
{
  if (!strncmp(str, "-inf", 4)) {
    return icMinFloat32Number;
  }
  if (!strncmp(str, "+inf", 4)) {
    return icMaxFloat32Number;
  }

  return (icFloatNumber)atof(str);
}


bool CIccFormulaCurveSegmentXml::ToXml(std::string &xml, std::string blanks)
{
  char buf[256];
  char line[256];

  sprintf(line, "<FormulaSegment Start=\"%s\"", icSegPos(buf, m_startPoint));
  xml += blanks + line;

  sprintf(line, " End=\"%s\"",icSegPos(buf, m_endPoint));
  xml += line;
    
  sprintf(line, " FunctionType=\"%d\"", m_nFunctionType);
  xml += line;

  if (m_nReserved) {
    sprintf(line, " Reserved=\"%d\"", m_nReserved);
    xml += line;
  }
  if (m_nReserved2) {
    sprintf(line, " Reserved2=\"%d\"", m_nReserved2);
    xml += line;
  }
  xml += ">\n";

  CIccFloatArray::DumpArray(xml, blanks+"  ", m_params, m_nParameters, icConvertFloat, 8);

  xml += blanks + "</FormulaSegment>\n";

  return true;
}


bool CIccFormulaCurveSegmentXml::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  xmlAttr *funcType = icXmlFindAttr(pNode, "FunctionType");

  if (!funcType) {
    parseStr += "Bad FunctionType in Formula Segment\n";
    return false;
  }

  m_nReserved2 = atoi(icXmlAttrValue(pNode, "Reserved2"));
  m_nFunctionType = atoi(icXmlAttrValue(funcType));

  switch(m_nFunctionType) {
    case 0x0000:
      m_nParameters = 4;
      break;

    case 0x0001:
    case 0x0002:
    case 0x0003:
      m_nParameters = 5;
      break;

    default:
      parseStr += "Unsupported FunctionType value in Formula Segment\n";
      return false;
  }

  CIccFloatArray args;

  if (!args.ParseArray(pNode->children))
    return false;

  if (args.GetSize()>m_nParameters)
    return false;

  if (m_params) {
    free(m_params);
  }

  if (m_nParameters) {
    m_params = (icFloatNumber*)malloc(m_nParameters * sizeof(icFloatNumber));
    if (!m_params)
      return false;

    memcpy(m_params, args.GetBuf(), m_nParameters * sizeof(icFloatNumber));
  }
  else
    m_params = NULL;

  return true;
}


class CIccSampledCurveSegmentXml : public CIccSampledCurveSegment
{
public:
  CIccSampledCurveSegmentXml(icFloatNumber start, icFloatNumber end) : CIccSampledCurveSegment(start, end) {}

  bool ToXml(std::string &xml, std::string blanks/* = ""*/);
  bool ParseXml(xmlNode *pNode, std::string &parseStr);
};

bool CIccSampledCurveSegmentXml::ToXml(std::string &xml, std::string blanks)
{
  char buf[256];
  char line[256];

  sprintf(line, "<SampledSegment Start=\"%s\"", icSegPos(buf, m_startPoint));
  xml += blanks + line;

  sprintf(line, " End=\"%s\">\n",icSegPos(buf, m_endPoint));
  xml += line;

  CIccFloatArray::DumpArray(xml, blanks+"  ", m_pSamples, m_nCount, icConvertFloat, 8);

  xml += blanks + "</SampledSegment>\n";

  return true;
}


bool CIccSampledCurveSegmentXml::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  const char *filename = icXmlAttrValue(pNode, "Filename");

  // file exists
  if (filename[0]) {
    CIccIO *file = IccOpenFileIO(filename, "rb");
    if (!file){
      parseStr += "Error! - File '";
      parseStr += filename;
      parseStr +="' not found.\n";
      delete file;
      return false;
    }

    const char *format = icXmlAttrValue(pNode, "Format");

    // format is text
    if (!strcmp(format, "text")) {
      icUInt32Number num = file->GetLength();
      char *buf = (char *) new char[num];

      if (!buf) {          
        perror("Memory Error");
        parseStr += "'";
        parseStr += filename;
        parseStr += "' may not be a valid text file.\n";
        delete buf;
        delete file;
        return false;
      }

      if (file->Read8(buf, num) !=num) {
        perror("Read-File Error");
        parseStr += "'";
        parseStr += filename;
        parseStr += "' may not be a valid text file.\n";
        delete buf;
        delete file;             
        return false;
      }   

      CIccFloatArray data;

      //if (!data.ParseTextArray(buf)) {
      if (!data.ParseTextArrayNum(buf, num, parseStr)){
        parseStr += "File '";
        parseStr += filename;
        parseStr += "' is not a valid text file.\n";
        SetSize(0);
        delete buf;
        delete file;
        return false;
      }

      else {
        SetSize(data.GetSize());
        icFloatNumber *src = data.GetBuf();
        icFloatNumber *dst = m_pSamples;          

        icUInt32Number i;
        for (i=0; i<data.GetSize(); i++) {
          *dst = *src; 
          dst++;
          src++;
        }
      }  

      delete buf;
      delete file;
      return true;

    }
    // format is binary
    else if (!strcmp(format, "binary")) {
      const char *order = icXmlAttrValue(pNode, "Endian");
      bool little_endian = !strcmp(order, "little");

      icUInt16Number storageType = icValueTypeFloat32;
      xmlAttr *attr = icXmlFindAttr(pNode, "StorageType");
      if (attr) {
       storageType = (icUInt16Number)atoi(icXmlAttrValue(attr));
      }

      if (storageType == icValueTypeUInt8){
        icUInt32Number num = file->GetLength();
        icUInt8Number value;

        SetSize(num);
        icFloatNumber *dst =  m_pSamples;
        icUInt32Number i;
        for (i=0; i<num; i++) {
          if (!file->Read8(&value)) { 
            perror("Read-File Error");
            parseStr += "'";
            parseStr += filename;
            parseStr += "' may not be a valid binary file.\n";
            delete file;
            return false;
          } 
          *dst++ = (icFloatNumber)value / 255.0f;
        }         
        delete file;
        return true;
      }        
      else if (storageType == icValueTypeUInt16){
        icUInt32Number num = file->GetLength() / sizeof(icUInt16Number);
        icUInt16Number value;
        icUInt8Number *ptr = (icUInt8Number*)&value;

        SetSize(num);
        icFloatNumber *dst = m_pSamples;
        icUInt32Number i;
        for (i=0; i<num; i++) {
          if (!file->Read16(&value)) {  //assumes data is big endian
            perror("Read-File Error");
            parseStr += "'";
            parseStr += filename;
            parseStr += "' may not be a valid binary file.\n";
            delete file;              
            return false;
          }
#ifdef ICC_BYTE_ORDER_LITTLE_ENDIAN
          if (little_endian) {
#else
          if (!little_endian) {
#endif
            icUInt8Number t = ptr[0];
            ptr[0] = ptr[1];
            ptr[1] = t;
          }
          *dst++ = (icFloatNumber)value / 65535.0f;
        }
        delete file;
        return true;
      }
      else if (storageType == icValueTypeFloat16){
        icUInt32Number num = file->GetLength() / sizeof(icFloat16Number);
        icFloat16Number value;
        icUInt8Number *ptr = (icUInt8Number*)&value;

        SetSize(num);
        icFloatNumber *dst = m_pSamples;
        icUInt32Number i;
        for (i=0; i<num; i++) {
          if (!file->Read16(&value)) { //assumes data is big endian
            perror("Read-File Error");
            parseStr += "'";
            parseStr += filename;
            parseStr += "' may not be a valid binary file.\n";
            delete file;              
            return false;
          }
#ifdef ICC_BYTE_ORDER_LITTLE_ENDIAN
          if (little_endian) {
#else
          if (!little_endian) {
#endif
            icUInt8Number t = ptr[0];
            ptr[0] = ptr[1];
            ptr[1] = t;
          }
          *dst++ = icF16toF(value);
        }
        delete file;
        return true;
      }
      else if (storageType == icValueTypeFloat32) {
        icUInt32Number num = file->GetLength()/sizeof(icFloat32Number);
        icFloat32Number value;
        icUInt8Number *ptr = (icUInt8Number*)&value;

        SetSize(num);
        icFloatNumber *dst = m_pSamples;

        icUInt32Number i;
        for (i=0; i<num; i++) {
          if (!file->ReadFloat32Float(&value)) {  //assumes data is big endian
            perror("Read-File Error");
            parseStr += "'";
            parseStr += filename;
            parseStr += "' may not be a valid binary file.\n";
            delete file;
            return false;
          }
#ifdef ICC_BYTE_ORDER_LITTLE_ENDIAN
          if (little_endian) {
#else
          if (!little_endian) {
#endif
            icUInt8Number tmp;
            tmp = ptr[0]; ptr[0] = ptr[3]; ptr[3] = tmp;
            tmp = ptr[1]; ptr[1] = ptr[2]; ptr[2] = tmp;
          }
          *dst++ = value;
        }        
        delete file;
        return true;
      }
      else { //not 8bit/16bit/float        
        delete file;
        return false;
      } 
    }
  }
  else {
    CIccFloatArray samples;

    if (!samples.ParseArray(pNode->children)) {
      return false;
    }

    if (!SetSize(samples.GetSize())) {
      return false;
    }

    memcpy(m_pSamples, samples.GetBuf(), samples.GetSize() * sizeof(icFloatNumber));
  }

  return true;
}


class CIccSingleCurveSegmentXml : public CIccSingleCurveSegment
{
public:
  CIccSingleCurveSegmentXml(icFloatNumber start, icFloatNumber end) : CIccSingleCurveSegment(start, end) {}

  bool ToXml(std::string &xml, std::string blanks/* = ""*/);
  bool ParseXml(xmlNode *pNode, std::string &parseStr);
};

bool CIccSingleCurveSegmentXml::ToXml(std::string &xml, std::string blanks)
{
  char buf[256];
  char line[256];

  sprintf(line, "<SingleSampledSegment Start=\"%s\"", icSegPos(buf, m_startPoint));
  xml += blanks + line;

  sprintf(line, " End=\"%s\"",icSegPos(buf, m_endPoint));
  xml += line;

  sprintf(line, " FirstEntry=\"%.8f\"", m_firstEntry);
  xml += line;

  sprintf(line, " LastEntry=\"%.8f\"", m_lastEntry);
  xml += line;

  sprintf(line, " StorageType=\"%u\"", m_storageType);
  xml += line;

  sprintf(line, " ExtensionType=\"%u\">\n", m_segmentType);
  xml += line;

  CIccFloatArray::DumpArray(xml, blanks+"  ", m_pSamples, m_nCount, icConvertFloat, 8);

  xml += blanks + "</SingleSampledSegment>\n";

  return true;
}


bool CIccSingleCurveSegmentXml::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  xmlAttr *attr = icXmlFindAttr(pNode, "FirstEntry");

  if (!attr) {
    parseStr += "Bad FirstEntry in Simple Sampled Segment\n";
    return false;
  }

  m_firstEntry = (icFloatNumber)atof(icXmlAttrValue(attr));

  attr = icXmlFindAttr(pNode, "LastEntry");

  if (!attr) {
    parseStr += "Bad LastEntry in Simple Sampled Segment\n";
    return false;
  }

  m_lastEntry = (icFloatNumber)atof(icXmlAttrValue(attr));

  m_storageType = icValueTypeFloat32;
  attr = icXmlFindAttr(pNode, "StorageType");
  if (attr) {
    m_storageType = (icUInt16Number)atoi(icXmlAttrValue(attr));
  }

  m_segmentType = icClipSingleSegment;
  attr = icXmlFindAttr(pNode, "ExtensionType");
  if (attr) {
    m_segmentType = (icUInt16Number)atoi(icXmlAttrValue(attr));
  }

  const char *filename = icXmlAttrValue(pNode, "Filename");

  // file exists
  if (filename[0]) {
    CIccIO *file = IccOpenFileIO(filename, "rb");
    if (!file){
      parseStr += "Error! - File '";
      parseStr += filename;
      parseStr +="' not found.\n";
      delete file;
      return false;
    }

    const char *format = icXmlAttrValue(pNode, "Format");

    // format is text
    if (!strcmp(format, "text")) {
      icUInt32Number num = file->GetLength();
      char *buf = (char *) new char[num];

      if (!buf) {          
        perror("Memory Error");
        parseStr += "'";
        parseStr += filename;
        parseStr += "' may not be a valid text file.\n";
        free(buf);
        delete file;
        return false;
      }

      if (file->Read8(buf, num) !=num) {
        perror("Read-File Error");
        parseStr += "'";
        parseStr += filename;
        parseStr += "' may not be a valid text file.\n";
        free(buf);
        delete file;             
        return false;
      }         

      // lut8type
      if (m_storageType == icValueTypeUInt8) {
        CIccUInt8Array data;

        //if (!data.ParseTextArray(buf)) {
        if (!data.ParseTextArrayNum(buf, num, parseStr)){
          parseStr += "File '";
          parseStr += filename;
          parseStr += "' is not a valid text file.\n";
          SetSize(0);
          free(buf);
          delete file;
          return false;
        }

        else {
          SetSize(data.GetSize());
          icUInt8Number *src = data.GetBuf();
          icFloatNumber *dst = m_pSamples;

          icUInt32Number i;
          for (i=0; i<data.GetSize(); i++) {  
            *dst = (icFloatNumber)(*src) / 255.0f;              
            dst++;
            src++;
          }

          //if (i!=256) {
          //printf("Error! - Input/Output table does not have 256 entries.\n");                            
          //SetSize(0);
          //return false;
          //}
          delete file;
          return true;
        }
      } 

      //lut16type
      else if (m_storageType == icValueTypeUInt16) {
        CIccUInt16Array data;

        //if (!data.ParseTextArray(buf)) {
        if (!data.ParseTextArrayNum(buf, num, parseStr)){
          parseStr += "File '";
          parseStr += filename;
          parseStr += "' is not a valid text file.\n";
          SetSize(0);
          free(buf);
          delete file;
          return false;
        }

        else {
          SetSize(data.GetSize());

          icUInt16Number *src = data.GetBuf();
          icFloatNumber *dst = m_pSamples;

          icUInt32Number i;
          for (i=0; i<data.GetSize(); i++) {
            *dst = (icFloatNumber)(*src) / 65535.0f; 
            dst++;
            src++;
          }
        }
        delete file;
        return true;
      }

      //float type
      else if (m_storageType == icValueTypeFloat32){
        CIccFloatArray data;

        //if (!data.ParseTextArray(buf)) {
        if (!data.ParseTextArrayNum(buf, num, parseStr)){
          parseStr += "File '";
          parseStr += filename;
          parseStr += "' is not a valid text file.\n";
          SetSize(0);
          free(buf);
          delete file;
          return false;
        }

        else {
          SetSize(data.GetSize());
          icFloatNumber *src = data.GetBuf();
          icFloatNumber *dst = m_pSamples;          

          icUInt32Number i;
          for (i=0; i<data.GetSize(); i++) {
            *dst = *src; 
            dst++;
            src++;
          }
        }  
        delete file;
        return true;
      }        
      else {
        delete file;
        return false;
      }
    }
    // format is binary
    else if (!strcmp(format, "binary")) {
      const char *order = icXmlAttrValue(pNode, "Endian");
      bool little_endian = !strcmp(order, "little");    

      if (m_storageType == icValueTypeUInt8){
        icUInt32Number num = file->GetLength();
        icUInt8Number value;

        SetSize(num);
        icFloatNumber *dst =  m_pSamples;
        icUInt32Number i;
        for (i=0; i<num; i++) {
          if (!file->Read8(&value)) { 
            perror("Read-File Error");
            parseStr += "'";
            parseStr += filename;
            parseStr += "' may not be a valid binary file.\n";
            delete file;
            return false;
          } 
          *dst++ = (icFloatNumber)value / 255.0f;
        }         
        delete file;
        return true;
      }        
      else if (m_storageType == icValueTypeUInt16){
        icUInt32Number num = file->GetLength() / sizeof(icUInt16Number);
        icUInt16Number value;
        icUInt8Number *ptr = (icUInt8Number*)&value;

        SetSize(num);
        icFloatNumber *dst = m_pSamples;
        icUInt32Number i;
        for (i=0; i<num; i++) {
          if (!file->Read16(&value)) { //assumes data is big endian
            perror("Read-File Error");
            parseStr += "'";
            parseStr += filename;
            parseStr += "' may not be a valid binary file.\n";
            delete file;              
            return false;
          }
#ifdef ICC_BYTE_ORDER_LITTLE_ENDIAN
          if (little_endian) {
#else
          if (!little_endian) {
#endif
            icUInt8Number t = ptr[0];
            ptr[0] = ptr[1];
            ptr[1] = t;
          }
          *dst++ = (icFloatNumber)value / 65535.0f;
        }
        delete file;
        return true;
      }
      else if (m_storageType == icValueTypeFloat16){
        icUInt32Number num = file->GetLength() / sizeof(icFloat16Number);
        icFloat16Number value;
        icUInt8Number *ptr = (icUInt8Number*)&value;

        SetSize(num);
        icFloatNumber *dst = m_pSamples;
        icUInt32Number i;
        for (i=0; i<num; i++) {
          if (!file->Read16(&value)) {  //assumes data is big endian
            perror("Read-File Error");
            parseStr += "'";
            parseStr += filename;
            parseStr += "' may not be a valid binary file.\n";
            delete file;              
            return false;
          }
#ifdef ICC_BYTE_ORDER_LITTLE_ENDIAN
          if (little_endian) {
#else
          if (!little_endian) {
#endif
            icUInt8Number t = ptr[0];
            ptr[0] = ptr[1];
            ptr[1] = t;
          }
          *dst++ = icF16toF(value);
        }
        delete file;
        return true;
      }
      else if (m_storageType == icValueTypeFloat32) {
        icUInt32Number num = file->GetLength()/sizeof(icFloat32Number);
        icFloat32Number value;
        icUInt8Number *ptr = (icUInt8Number*)&value;

        SetSize(num);
        icFloatNumber *dst = m_pSamples;

        icUInt32Number i;
        for (i=0; i<num; i++) {
          if (!file->ReadFloat32Float(&value)) {
            perror("Read-File Error");
            parseStr += "'";
            parseStr += filename;
            parseStr += "' may not be a valid binary file.\n";
            delete file;
            return false;
          }
#ifdef ICC_BYTE_ORDER_LITTLE_ENDIAN
          if (little_endian) {
#else
          if (!little_endian) {
#endif
            icUInt8Number tmp;
            tmp = ptr[0]; ptr[0] = ptr[3]; ptr[3] = tmp;
            tmp = ptr[1]; ptr[1] = ptr[2]; ptr[2] = tmp;
          }
          *dst++ = value;
        }        
        delete file;
        return true;
      }
      else { //not 8bit/16bit/float        
        delete file;
        return false;
      } 
    }       
    else {//not text/binary
      delete file;
      return false;
    }
  }    
  // no file
  else{
    CIccFloatArray samples;

    if (!samples.ParseArray(pNode->children)) {
      return false;
    }

    if (!SetSize(samples.GetSize())) {
      return false;
    }

    memcpy(m_pSamples, samples.GetBuf(), samples.GetSize() * sizeof(icFloatNumber));
  }

  return true;
}


bool CIccSegmentedCurveXml::ToXml(std::string &xml, std::string blanks)
{
  CIccCurveSegmentList::iterator seg;
  xml += blanks + "<SegmentedCurve>\n";
  for (seg = m_list->begin(); seg!=m_list->end(); seg++) {
    CIccCurveSegment* pSeg = *seg;
    if (pSeg && pSeg->GetType() == icSigFormulaCurveSeg) {
      if (!((CIccFormulaCurveSegmentXml*)pSeg)->ToXml(xml, blanks+"  "))
        return false;
    }
    else if (pSeg && pSeg->GetType() == icSigSampledCurveSeg) {
      if (!((CIccSampledCurveSegmentXml*)pSeg)->ToXml(xml, blanks+"  "))
        return false;
    }
    else if (pSeg && pSeg->GetType() == icSigSingleSampledCurveSeg) {
      if (!((CIccSingleCurveSegmentXml*)pSeg)->ToXml(xml, blanks+"  "))
        return false;
    }
    else
      return false;
  }
  xml += blanks + "</SegmentedCurve>\n";
  return true;
}


bool CIccSegmentedCurveXml::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  m_list->clear();
  for (pNode=pNode->children; pNode; pNode=pNode->next) {
    if (pNode->type == XML_ELEMENT_NODE) {
      icFloatNumber start = icGetSegPos(icXmlAttrValue(pNode, "Start"));
      icFloatNumber end = icGetSegPos(icXmlAttrValue(pNode, "End"));

      if (!icXmlStrCmp(pNode->name, "FormulaSegment")) {
        CIccFormulaCurveSegmentXml *pSegXml = new CIccFormulaCurveSegmentXml(start, end);

        if (!pSegXml->ParseXml(pNode, parseStr)) {
          parseStr += "Unable to parse FormulaSegment\n";
          delete pSegXml;
          return false;
        }
        m_list->push_back(pSegXml);
      }
      else if (!icXmlStrCmp(pNode->name, "SampledSegment")) {
        CIccSampledCurveSegmentXml *pSegXml = new CIccSampledCurveSegmentXml(start, end);

        if (!pSegXml->ParseXml(pNode, parseStr)) {
          parseStr += "Unable to parse SampledSegment\n";
          delete pSegXml;
          return false;
        }
        m_list->push_back(pSegXml);
      }
      else if (!icXmlStrCmp(pNode->name, "SingleSampledSegment")) {
        CIccSingleCurveSegmentXml *pSegXml = new CIccSingleCurveSegmentXml(start, end);

        if (!pSegXml->ParseXml(pNode, parseStr)) {
          parseStr += "Unable to parse SingleSampledSegment\n";
          delete pSegXml;
          return false;
        }
        m_list->push_back(pSegXml);
      }
      else {
        parseStr += "Bad Segment Type\n";
        return false;
      }
    }
  }
  return true;
}


bool CIccMpeXmlCurveSet::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char line[256];
  sprintf(line, "<CurveSetElement InputChannels=\"%d\" OutputChannels=\"%d\"", NumInputChannels(), NumOutputChannels());
  xml += blanks + line;

  if (m_nReserved) {
    sprintf(line, " Reserved=\"%u\"", m_nReserved);
    xml += line;
  }
  xml += ">\n";

  int i;

  for (i=0; i<NumInputChannels(); i++) {
    CIccSegmentedCurveXml *ptr = (CIccSegmentedCurveXml*)m_curve[i];
    
    if (!(ptr->ToXml(xml, blanks+"  ")))
      return false;
  }

  xml += blanks + "</CurveSetElement>\n";
  return true;
}


bool CIccMpeXmlCurveSet::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  icUInt16Number nChannels = (icUInt16Number)atoi(icXmlAttrValue(pNode, "InputChannels"));

  if (!nChannels || atoi(icXmlAttrValue(pNode, "OutputChannels")) != nChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In CurveSetElement\n";
    return false;
  }

  SetSize(nChannels);
  int nIndex = 0;
  for (pNode = icXmlFindNode(pNode->children, "SegmentedCurve"), nIndex = 0;
       pNode && nIndex<nChannels;
       pNode=icXmlFindNode(pNode->next,"SegmentedCurve"), nIndex++) {
    CIccSegmentedCurveXml *pCurve = new CIccSegmentedCurveXml();

    if (!pCurve->ParseXml(pNode, parseStr)) {
      delete pCurve;
      return false;
    }
    if (!SetCurve(nIndex, pCurve))
      return false;
  }

  if (!pNode && nIndex == nChannels)
    return true;

  return false;
}


bool CIccMpeXmlMatrix::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char buf[128];
  sprintf(buf, "<MatrixElement InputChannels=\"%d\" OutputChannels=\"%d\"", NumInputChannels(), NumOutputChannels());
  xml += blanks + buf;

  if (m_nReserved) {
    sprintf(buf, " Reserved=\"%u\"", m_nReserved);
    xml += buf;
  }
  xml += ">\n";

  int i, j, n;

  if (m_pMatrix) {
    xml += blanks + "  <MatrixData>\n";

    for (n=0, j=0; j<NumOutputChannels(); j++) {
      xml += blanks + "   ";
      for (i=0; i<NumInputChannels(); i++, n++) {
         sprintf(buf, " %.8f", m_pMatrix[n]);
         xml += buf;
      }
      xml += "\n";
    }
    xml += blanks + "  </MatrixData>\n";
  }

  if (m_pConstants) {
    xml += blanks + "  <ConstantData>\n";

    xml += blanks + "   ";
    for (i=0; i<NumOutputChannels(); i++) {
      sprintf(buf, " %.8f", m_pConstants[i]);
      xml += buf;
    }
    xml += "\n";

    xml += blanks + "  </ConstantData>\n";
  }

  xml += blanks + "</MatrixElement>\n";

  return true;
}


bool CIccMpeXmlMatrix::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  icUInt16Number nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  icUInt16Number nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));
  if (!nInputChannels || !nOutputChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In MatrixElement\n";
    return false;
  }

  xmlNode *pData;

  pData = icXmlFindNode(pNode->children, "MatrixData");
  if (pData) {
    SetSize(nInputChannels, nOutputChannels);

    if (!CIccFloatArray::ParseArray(m_pMatrix, m_nInputChannels*m_nOutputChannels, pData->children))
      return false;
  }
  else { //Having no MatrixData implies having a matrix full of zeros which is represented by m_pMatrix set to NULL
    SetSize(0, nOutputChannels); //Initialize with m_pMatrix set to NULL
    m_nInputChannels = nInputChannels; //Fix m_nInputChannels
  }

  pData = icXmlFindNode(pNode->children, "ConstantData");
  if (pData) {
    if (!CIccFloatArray::ParseArray(m_pConstants, m_nOutputChannels, pData->children))
      return false;
  }
  return true;
}

bool CIccMpeXmlEmissionMatrix::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char buf[128];
  sprintf(buf, "<EmissionMatrixElement InputChannels=\"%d\" OutputChannels=\"%d\"", NumInputChannels(), NumOutputChannels());
  xml += blanks + buf;

  if (m_nReserved) {
    sprintf(buf, " Reserved=\"%u\"", m_nReserved);
    xml += buf;
  }
  xml += ">\n";

  sprintf(buf, "  <Wavelengths start=\"%.8f\" end=\"%.8f\" steps=\"%d\"/>\n", icF16toF(m_Range.start), icF16toF(m_Range.end), m_Range.steps);
  xml += blanks + buf;

  int i, j, n;

  if (m_pWhite) {
    xml += blanks + "  <WhiteData>\n";

    xml += blanks + "   ";
    for (i=0; i<(int)m_Range.steps; i++) {
      sprintf(buf, " %.8f", m_pWhite[i]);
      xml += buf;
    }
    xml += "\n";

    xml += blanks + "  </WhiteData>\n";
  }

  if (m_pMatrix) {
    xml += blanks + "  <MatrixData>\n";

    for (n=0, j=0; j<numVectors(); j++) {
      xml += blanks + "   ";
      for (i=0; i<(int)m_Range.steps; i++, n++) {
        sprintf(buf, " %.8f", m_pMatrix[n]);
        xml += buf;
      }
      xml += "\n";
    }
    xml += blanks + "  </MatrixData>\n";
  }

  if (m_pOffset) {
    xml += blanks + "  <OffsetData>\n";

    xml += blanks + "   ";
    for (i=0; i<(int)m_Range.steps; i++) {
      sprintf(buf, " %.8f", m_pOffset[i]);
      xml += buf;
    }
    xml += "\n";

    xml += blanks + "  </OffsetData>\n";
  }

  xml += blanks + "</EmissionMatrixElement>\n";

  return true;
}


bool CIccMpeXmlEmissionMatrix::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  icUInt16Number nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  icUInt16Number nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));

  if (!nInputChannels || !nOutputChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In MatrixElement\n";
    return false;
  }

  xmlNode *pData;

  pData = icXmlFindNode(pNode->children, "Wavelengths");
  if (pData) {
    icFloatNumber dStart = (icFloatNumber)atof(icXmlAttrValue(pData, "start"));
    icFloatNumber dEnd = (icFloatNumber)atof(icXmlAttrValue(pData, "end"));
    icUInt16Number nSteps = atoi(icXmlAttrValue(pData, "steps"));

    if (!nSteps) {
      parseStr += "Invalid Spectral Range\n";
      return false;
    }
    m_Range.start = icFtoF16(dStart);
    m_Range.end = icFtoF16(dEnd);
    m_Range.steps = nSteps;
  }

  SetSize(nInputChannels, nOutputChannels, m_Range);
  if (!m_pWhite || !m_pMatrix || !m_pOffset) {
    parseStr += "Unable to SetSize\n";
    return false;
  }

  pData = icXmlFindNode(pNode->children, "WhiteData");
  if (pData) {

    if (!CIccFloatArray::ParseArray(m_pWhite, m_Range.steps, pData->children))
      return false;
  }
  else {
    parseStr += "Missing MatrixData";
  }

  pData = icXmlFindNode(pNode->children, "MatrixData");
  if (pData) {

    if (!CIccFloatArray::ParseArray(m_pMatrix, numVectors()*(int)m_Range.steps, pData->children))
      return false;
  }
  else {
    parseStr += "Missing MatrixData";
  }

  pData = icXmlFindNode(pNode->children, "OffsetData");
  if (pData) {
    if (!CIccFloatArray::ParseArray(m_pOffset, m_Range.steps, pData->children))
      return false;
  }
  else {
    memset(m_pOffset, 0, (int)m_Range.steps*sizeof(icFloatNumber));
  }
  return true;
}

bool CIccMpeXmlInvEmissionMatrix::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char buf[128];
  sprintf(buf, "<InvEmissionMatrixElement InputChannels=\"%d\" OutputChannels=\"%d\"", NumInputChannels(), NumOutputChannels());
  xml += blanks + buf;

  if (m_nReserved) {
    sprintf(buf, " Reserved=\"%u\"", m_nReserved);
    xml += buf;
  }
  xml += ">\n";

  sprintf(buf, "  <Wavelengths start=\"%.8f\" end=\"%.8f\" steps=\"%d\"/>\n", icF16toF(m_Range.start), icF16toF(m_Range.end), m_Range.steps);
  xml += blanks + buf;

  int i, j, n;

  if (m_pWhite) {
    xml += blanks + "  <WhiteData>\n";

    xml += blanks + "   ";
    for (i=0; i<(int)m_Range.steps; i++) {
      sprintf(buf, " %.8f", m_pWhite[i]);
      xml += buf;
    }
    xml += "\n";

    xml += blanks + "  </WhiteData>\n";
  }

  if (m_pMatrix) {
    xml += blanks + "  <MatrixData>\n";

    for (n=0, j=0; j<numVectors(); j++) {
      xml += blanks + "   ";
      for (i=0; i<(int)m_Range.steps; i++, n++) {
        sprintf(buf, " %.8f", m_pMatrix[n]);
        xml += buf;
      }
      xml += "\n";
    }
    xml += blanks + "  </MatrixData>\n";
  }

  if (m_pOffset) {
    xml += blanks + "  <OffsetData>\n";

    xml += blanks + "   ";
    for (i=0; i<(int)m_Range.steps; i++) {
      sprintf(buf, " %.8f", m_pOffset[i]);
      xml += buf;
    }
    xml += "\n";

    xml += blanks + "  </OffsetData>\n";
  }

  xml += blanks + "</InvEmissionMatrixElement>\n";

  return true;
}


bool CIccMpeXmlInvEmissionMatrix::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  icUInt16Number nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  icUInt16Number nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));

  if (!nInputChannels || !nOutputChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In MatrixElement\n";
    return false;
  }

  xmlNode *pData;

  pData = icXmlFindNode(pNode->children, "Wavelengths");
  if (pData) {
    icFloatNumber dStart = (icFloatNumber)atof(icXmlAttrValue(pData, "start"));
    icFloatNumber dEnd = (icFloatNumber)atof(icXmlAttrValue(pData, "end"));
    icUInt16Number nSteps = atoi(icXmlAttrValue(pData, "steps"));

    if (!nSteps) {
      parseStr += "Invalid Spectral Range\n";
      return false;
    }
    m_Range.start = icFtoF16(dStart);
    m_Range.end = icFtoF16(dEnd);
    m_Range.steps = nSteps;
  }

  SetSize(nInputChannels, nOutputChannels, m_Range);
  if (!m_pWhite || !m_pMatrix || !m_pOffset) {
    parseStr += "Unable to SetSize\n";
    return false;
  }

  pData = icXmlFindNode(pNode->children, "WhiteData");
  if (pData) {

    if (!CIccFloatArray::ParseArray(m_pWhite, m_Range.steps, pData->children))
      return false;
  }
  else {
    parseStr += "Missing White Data";
  }

  pData = icXmlFindNode(pNode->children, "MatrixData");
  if (pData) {

    if (!CIccFloatArray::ParseArray(m_pMatrix, numVectors()*(int)m_Range.steps, pData->children))
      return false;
  }
  else {
    parseStr += "Missing Matrix Data";
  }

  pData = icXmlFindNode(pNode->children, "OffsetData");
  if (pData) {
    if (!CIccFloatArray::ParseArray(m_pOffset, m_Range.steps, pData->children))
      return false;
  }
  else {
    memset(m_pOffset, 0, (int)m_Range.steps*sizeof(icFloatNumber));
  }
  return true;
}

bool CIccMpeXmlTintArray::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char buf[128], line[128];
  sprintf(buf, "<TintArrayElement InputChannels=\"%d\" OutputChannels=\"%d\"", NumInputChannels(), NumOutputChannels());
  xml += blanks + buf;

  if (m_nReserved) {
    sprintf(buf, " Reserved=\"%u\"", m_nReserved);
    xml += buf;
  }
  xml += ">\n";

  IIccExtensionTag *pTagEx;
  if (m_Array && (pTagEx=m_Array->GetExtension()) && !strcmp(pTagEx->GetExtClassName(), "CIccTagXml")) {
    CIccTagXml *pTagXml = (CIccTagXml*)m_Array;
    const icChar* tagSig = icGetTagSigTypeName(m_Array->GetType());

    sprintf(line, "  <%s>\n",  tagSig); //parent node is the tag type
    xml += line; 				

    //convert the rest of the tag to xml
    if (!pTagXml->ToXml(xml, "    ")) {
      printf("Unable to output tag with type %s\n", icGetSigStr(buf, m_Array->GetType()));
      return false;
    }
    sprintf(line, "  </%s>\n",  tagSig);
    xml += line; 	
  }

  xml += blanks + "</TintArrayElement>\n";

  return true;
}


bool CIccMpeXmlTintArray::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  icUInt16Number nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  icUInt16Number nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));
  if (!nInputChannels || !nOutputChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In MatrixElement\n";
    return false;
  }
  m_nInputChannels = nInputChannels;
  m_nOutputChannels = nOutputChannels;

  for (pNode = pNode->children; pNode && pNode->type != XML_ELEMENT_NODE; pNode = pNode->next);
  if (pNode) {
    CIccTag *pTag = NULL;
    icSignature sigTag = (icSignature)0;

    // get the tag signature
    std::string nodeName = (icChar*) pNode->name;
    icTagTypeSignature sigType = icGetTypeNameTagSig (nodeName.c_str());

    if (sigType==icSigUnknownType){
      xmlAttr *attr = icXmlFindAttr(pNode, "type");
      sigType = (icTagTypeSignature)icGetSigVal((icChar*) icXmlAttrValue(attr));
    }

    CIccInfo info;

    // create a tag based on the signature
    pTag = CIccTag::Create(sigType);

    if (!pTag && !pTag->IsNumArrayType()) {
      parseStr+= "Invalid data type for Tint Array!\n";
      delete pTag;
      return false;
    }

    IIccExtensionTag *pExt;

    if (pTag && (pExt = pTag->GetExtension()) && !strcmp(pExt->GetExtClassName(), "CIccTagXml")) {
      CIccTagXml* pXmlTag = (CIccTagXml*)pExt;
      xmlAttr *attr;

      if (pXmlTag->ParseXml(pNode->children, parseStr)) {
        if ((attr=icXmlFindAttr(pNode, "reserved"))) {
          sscanf(icXmlAttrValue(attr), "%u", &pTag->m_nReserved);
        }
        m_Array = (CIccTagNumArray*)pTag;
      }
      else {
        parseStr += "Unable to Parse \"";
        parseStr += info.GetTagTypeSigName(sigType);
        parseStr += "\" (";
        parseStr += nodeName;
        parseStr += ") Tint Tag\n";
        delete pTag;
        return false;
      }
    }
    else {
      parseStr += "Invalid tag extension for \"";
      parseStr += info.GetTagTypeSigName(sigType);
      parseStr += "\" (";
      parseStr += nodeName;
      parseStr += ") Tint Tag\n";
      if (pTag)
        delete pTag;
      return false;
    }
  }
  else {
    parseStr += "Tint Array missing tit values\n";
    return false;
  }
  return true;
}


extern CIccCLUT *icCLutFromXml(xmlNode *pNode, int nIn, int nOut, icConvertType nType, std::string &parseStr);

bool CIccMpeXmlCLUT::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char attrs[256];

  if (m_nReserved) {
    sprintf(attrs, " InputChannels=\"%d\" OutputChannels=\"%d\" Reserved=\"%u\"", NumInputChannels(), NumOutputChannels(), m_nReserved);
  }
  else {
    sprintf(attrs, " InputChannels=\"%d\" OutputChannels=\"%d\"", NumInputChannels(), NumOutputChannels());
  }

  return icCLUTToXml(xml, m_pCLUT, icConvertFloat, blanks, true, attrs, "CLutElement");
}

bool CIccMpeXmlCLUT::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  m_nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  m_nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));

  if (!m_nInputChannels || !m_nOutputChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In CLutElement\n";
    return false;
  }

  CIccCLUT *pCLut = icCLutFromXml(pNode, m_nInputChannels, m_nOutputChannels, icConvertFloat, parseStr);
  if (pCLut) {
    SetCLUT(pCLut);
    if (m_pCLUT)
      return true;
  }

  return false;
}

bool CIccMpeXmlExtCLUT::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char attrs[256];
  std::string reserved;

  if (m_nReserved) {
    sprintf(attrs, " Reserved=\"%u\"", m_nReserved);
    reserved = attrs;
  }

  if (m_nReserved2) {
    sprintf(attrs, " Reserved2=\"%u\"", m_nReserved2);
    reserved += attrs;
  }

  sprintf(attrs, " InputChannels=\"%d\" OutputChannels=\"%d\"%s", NumInputChannels(), NumOutputChannels(), reserved.c_str());

  return icCLUTToXml(xml, m_pCLUT, icConvertFloat, blanks, true, attrs, "CLutElement");
}

bool CIccMpeXmlExtCLUT::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  m_storageType = (icUInt16Number)atoi(icXmlAttrValue(pNode, "StorageType", "0"));
  m_nReserved2 = atoi(icXmlAttrValue(pNode, "Reserved2", "0"));

  m_nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  m_nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));

  if (!m_nInputChannels || !m_nOutputChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In CLutExtElement\n";
    return false;
  }

  CIccCLUT *pCLut = icCLutFromXml(pNode, m_nInputChannels, m_nOutputChannels, icConvertFloat, parseStr);
  if (pCLut) {
    SetCLUT(pCLut);
    if (m_pCLUT)
      return true;
  }

  return false;
}

bool CIccMpeXmlBAcs::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char line[256];
  char buf[256], fix[256];

  sprintf(line, "<BAcsElement InputChannels=\"%d\" OutputChannels=\"%d\" Signature=\"%s\"", NumInputChannels(), NumOutputChannels(),
                icFixXml(fix, icGetSigStr(buf, m_signature)));
  xml += blanks + line;

  if (m_nReserved) {
    sprintf(line, " Reserved=\"%u\"", m_nReserved);
    xml += line;
  }

  if (m_pData && m_nDataSize) {
    icUInt8Number *ptr = m_pData;

    xml += ">\n";
  
    icXmlDumpHexData(xml, blanks+"  ", m_pData, m_nDataSize);

    xml += blanks + "</BAcsElement>\n";
  }
  else {
    xml += "/>\n";
  }

  return true;
}


bool CIccMpeXmlBAcs::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  m_nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  m_nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));

  if (!m_nInputChannels || !m_nOutputChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In BAcsElement\n";
    return false;
  }

  m_signature = icXmlStrToSig(icXmlAttrValue(pNode, "Signature"));

  if (pNode->children && pNode->children->type == XML_TEXT_NODE && pNode->children->content) {
    icUInt32Number nSize = icXmlGetHexDataSize((const char*)pNode->children->content);

    if (nSize) {
      if (!AllocData(nSize))
        return false;
      icXmlGetHexData(m_pData, (const char *)pNode->children->content, nSize);
    }
  }
  return true;
}


bool CIccMpeXmlEAcs::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char line[256];
  char buf[256], fix[256];

  sprintf(line, "<EAcsElement InputChannels=\"%d\" OutputChannels=\"%d\" Signature=\"%s\"", NumInputChannels(), NumOutputChannels(),
    icFixXml(fix, icGetSigStr(buf, m_signature)));
  xml += blanks + line;

  if (m_nReserved) {
    sprintf(line, " Reserved=\"%u\"", m_nReserved);
    xml += line;
  }

  if (m_pData && m_nDataSize) {
    icUInt8Number *ptr = m_pData;

    xml += ">\n";
    icXmlDumpHexData(xml, blanks+"  ", m_pData, m_nDataSize);
    xml += blanks + "</EAcsElement>\n";
  }
  else {
    xml += "/>\n";
  }

  return true;
}


bool CIccMpeXmlEAcs::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  m_nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  m_nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));

  if (!m_nInputChannels || !m_nOutputChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In EAcsElement\n";
    return false;
  }

  m_signature = icXmlStrToSig(icXmlAttrValue(pNode, "Signature"));

  if (pNode->children && pNode->children->type == XML_TEXT_NODE && pNode->children->content) {
    icUInt32Number nSize = icXmlGetHexDataSize((const char*)pNode->children->content);

    if (nSize) {
      if (!AllocData(nSize))
        return false;
      icXmlGetHexData(m_pData, (const char *)pNode->children->content, nSize);
    }
  }
  return true;
}

static bool icXmlDumpColorAppearanceParams(std::string &xml, std::string blanks, CIccCamConverter *pCam)
{
  char line[256];
  icFloatNumber xyz[3];

  xml += blanks + "<ColorAppearanceParams>\n";
  
  pCam->GetParameter_WhitePoint(&xyz[0]);
  sprintf(line, "  <XYZNumber X=\"%.8f\" Y=\"%.8f\" Z=\"%.8f\"/>", xyz[0], xyz[1], xyz[2]);

  xml += blanks + " <WhitePoint>\n";
  xml += blanks + line;
  xml += blanks + " </WhitePoint>\n";
  
  sprintf(line, " <Luminance>%f</Luminance>\n", pCam->GetParameter_La());
  xml += blanks + line;

  sprintf(line, " <BackgroundLuminance>%.8f</BackgroundLuminance>\n", pCam->GetParameter_Yb());
  xml += blanks + line;

  sprintf(line, " <ImpactSurround>%f</ImpactSurround>\n", pCam->GetParameter_C());
  xml += blanks + line;

  sprintf(line, " <ChromaticInductionFactor>%f</ChromaticInductionFactor>\n", pCam->GetParameter_Nc());
  xml += blanks + line;

  sprintf(line, " <AdaptationFactor>%f</AdaptationFactor>\n", pCam->GetParameter_F());
  xml += blanks + line;

  xml += "</ColorAppearanceParams>\n";

  return true;
}

static bool icXmlParseColorAppearanceParams(xmlNode *pNode, std::string &parseStr, CIccCamConverter *pCam)
{
   xmlNode *pChild = icXmlFindNode(pNode, "WhitePoint");
   if (!pChild) {
     parseStr += "Unable to find CAM Whitepoint\n";
     return false;
   }

   xmlNode *xyzNode = icXmlFindNode(pChild->children, "XYZNumber");

   if (!xyzNode) {
     parseStr += "Unable to find valid CAM WhitePoint XYZ\n";
     return false;
   }

   xmlAttr *x = icXmlFindAttr(xyzNode, "X");
   xmlAttr *y = icXmlFindAttr(xyzNode, "Y");
   xmlAttr *z = icXmlFindAttr(xyzNode, "Z");

   icFloatNumber xyz[3];
   if (x && y && z) {
     xyz[0] = (icFloatNumber)atof(icXmlAttrValue(x));
     xyz[1] = (icFloatNumber)atof(icXmlAttrValue(y));
     xyz[2] = (icFloatNumber)atof(icXmlAttrValue(z));
   }
   else {
     parseStr += "Invalid CAM WhitePoint XYZNumber\n";
     return false;
   }
   pCam->SetParameter_WhitePoint(&xyz[0]);

   pChild = icXmlFindNode(pNode, "Luminance");
   if (!pChild || !pChild->children || !pChild->children->content) {
     parseStr += "Invalid CAM Luminance\n";
     return false;
   }
   pCam->SetParameter_La((icFloatNumber)atof((const char*)pChild->children->content));

   pChild = icXmlFindNode(pNode, "BackgroundLuminance");
   if (!pChild || !pChild->children || !pChild->children->content) {
     parseStr += "Invalid CAM Luminance\n";
     return false;
   }
   pCam->SetParameter_Yb((icFloatNumber)atof((const char*)pChild->children->content));

   pChild = icXmlFindNode(pNode, "ImpactSurround");
   if (!pChild || !pChild->children || !pChild->children->content) {
     parseStr += "Invalid CAM ImpactSurround\n";
     return false;
   }
   pCam->SetParameter_C((icFloatNumber)atof((const char*)pChild->children->content));

   pChild = icXmlFindNode(pNode, "ChromaticInductionFactor");
   if (!pChild || !pChild->children || !pChild->children->content) {
     parseStr += "Invalid CAM ChromaticInductionFactor\n";
     return false;
   }
   pCam->SetParameter_Nc((icFloatNumber)atof((const char*)pChild->children->content));

   pChild = icXmlFindNode(pNode, "AdaptationFactor");
   if (!pChild || !pChild->children || !pChild->children->content) {
     parseStr += "Invalid CAM AdaptationFactor\n";
     return false;
   }
   pCam->SetParameter_F((icFloatNumber)atof((const char*)pChild->children->content));

   return true;
}

bool CIccMpeXmlJabToXYZ::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char line[256];

  sprintf(line, "<JabToXYZElement InputChannels=\"%d\" OutputChannels=\"%d\"" , NumInputChannels(), NumOutputChannels());
  xml += blanks + line;

  if (m_nReserved) {
    sprintf(line, " Reserved=\"%u\"", m_nReserved);
    xml += line;
  }
  xml += ">\n";

  if (m_pCAM) {
    icXmlDumpColorAppearanceParams(xml, blanks+"  ", m_pCAM);
    xml += blanks + "</JabToXYZElement>\n";
  }

  return true;
}


bool CIccMpeXmlJabToXYZ::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  m_nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  m_nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));

  if (m_nInputChannels!=3 || m_nOutputChannels!=3) {
    parseStr += "Invalid InputChannels or OutputChannels In JabToXYZElement\n";
    return false;
  }
  xmlNode *pChild = icXmlFindNode(pNode->children, "ColorAppearanceParams");

  if (pChild) {
    CIccCamConverter *pCAM = new CIccCamConverter();

    if (!icXmlParseColorAppearanceParams(pChild->children, parseStr, pCAM)) {
      delete pCAM;
      return false;
    }

    SetCAM(pCAM);
  }
  else {
    parseStr += "Unable to find ColorAppearanceParams\n";
    return false;
  }

  return true;
}

bool CIccMpeXmlXYZToJab::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char line[256];

  sprintf(line, "<XYZToJabElement InputChannels=\"%d\" OutputChannels=\"%d\"" , NumInputChannels(), NumOutputChannels());
    xml += blanks + line;

  if (m_nReserved) {
    sprintf(line, " Reserved=\"%u\"", m_nReserved);
    xml += line;
  }
  xml += ">\n";

  if (m_pCAM) {
    icXmlDumpColorAppearanceParams(xml, blanks+"  ", m_pCAM);
    xml += blanks + "</XYZToJabElement>\n";
  }

  return true;
}


bool CIccMpeXmlXYZToJab::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  m_nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  m_nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));

  if (m_nInputChannels!=3 || m_nOutputChannels!=3) {
    parseStr += "Invalid InputChannels or OutputChannels In XYZToJabElement\n";
    return false;
  }
  xmlNode *pChild = icXmlFindNode(pNode->children, "ColorAppearanceParams");

  if (pChild) {
    CIccCamConverter *pCAM = new CIccCamConverter();

    if (!icXmlParseColorAppearanceParams(pChild->children, parseStr, pCAM)) {
      delete pCAM;
      return false;
    }

    SetCAM(pCAM);
  }
  else {
    parseStr += "Unable to find ColorAppearanceParams\n";
    return false;
  }

  return true;
}


bool CIccMpeXmlCalculator::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char line[256];
  std::string blanks2 = blanks + "  ";

  sprintf(line, "<CalculatorElement InputChannels=\"%d\" OutputChannels=\"%d\"", NumInputChannels(), NumOutputChannels());
  xml += blanks + line;

  if (m_nReserved) {
    sprintf(line, " reserved=\"%u\"", m_nReserved);
    xml += line;
  }
  xml += ">\n";

  int i;

  if (m_SubElem && m_nSubElem) {
    xml += blanks2 + "<SubElements>\n";
    for (i=0; i<m_nSubElem; i++) {
      if (m_SubElem[i]) {
        IIccExtensionMpe *pExt = m_SubElem[i]->GetExtension();
        if (pExt && !strcmp(pExt->GetExtClassName(), "CIccMpeXml")) {
          CIccMpeXml *pMpe = (CIccMpeXml*)pExt;
          pMpe->ToXml(xml, blanks2+"  ");
        }
        else {
          return false;
        }
      }
      else {
        return false;
      }
    }
    xml += blanks2 + "</SubElements>\n";
  }

  if (m_calcFunc) {
    std::string desc;

    xml += blanks2 + "<MainFunction>\n";

    m_calcFunc->Describe(desc, (int)blanks2.size()+2);
    xml += desc;

    xml+= blanks2 + "</MainFunction>\n";
  }

  xml += blanks + "</CalculatorElement>\n";
  return true;
}

bool CIccMpeXmlCalculator::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  xmlNode *pChild, *pNext;
  int n;
  
  SetSize(atoi(icXmlAttrValue(pNode, "InputChannels")),
          atoi(icXmlAttrValue(pNode, "OutputChannels")));

  pChild = icXmlFindNode(pNode->children, "SubElements");
  if (pChild) {
    for (n=0, pNext=pChild->children; pNext; pNext = pNext->next) {
      if (pNext->type == XML_ELEMENT_NODE) {
        CIccMultiProcessElement *pMpe = CIccTagXmlMultiProcessElement::CreateElement((const icChar*)pNext->name);

        if (!pMpe) {
          parseStr += std::string("Unknown Sub-Element Type (") + (const icChar*)pNext->name + ")\n";
          return false;
        }

        xmlAttr *attr;
        IIccExtensionMpe *pExt = pMpe->GetExtension();

        if (pExt) {
          if (!strcmp(pExt->GetExtClassName(), "CIccMpeXml")) {
            CIccMpeXml* pXmlMpe = (CIccMpeXml*)pExt;

            if (pXmlMpe->ParseXml(pNext, parseStr)) {
              if ((attr=icXmlFindAttr(pNode, "Reserved"))) {
                sscanf(icXmlAttrValue(attr), "%u", &pMpe->m_nReserved);
              }

              if (!SetSubElem(n, pMpe)) {
                parseStr += "Unable to embed SubElement in Calculator Element";
              }
            }
            else {
              parseStr += std::string("Unable to parse element of type ") + pMpe->GetClassName() + "\n";
              delete pMpe;
              return false;
            }
          }
          else {
            parseStr += std::string("Element ") + pMpe->GetClassName() + "isn't of type CIccMpeXml\n";
            delete pMpe;
            return false;
          }
        }
        else {
          parseStr += std::string("Element ") + pMpe->GetClassName() + "isn't of type CIccMpeXml\n";
          delete pMpe;
          return false;
        }
        n++;
      }
    }
  }

  pChild = icXmlFindNode(pNode->children, "MainFunction");
  if (pChild && pNode->children && pChild->children->content) {
    char *content = (char*)pChild->children->content;
    icFuncParseStatus stat = SetCalcFunc(content, parseStr);
    if (stat!=icFuncParseNoError) {
      char buf[65];
      int len = icIntMin(64, (int)strlen(content));
      strncpy(buf, content, len);
      buf[len]=0;

      switch(stat) {
        case icFuncParseSyntaxError:
          parseStr += "Syntax Error occurred while parsing Main Calculator Function from \"";
          break;
        case icFuncParseInvalidOperation:
          parseStr += "Invalid Operation found while parsing Main Calculator Function from \"";
          break;
        case icFuncParseStackUnderflow:
          parseStr += "Stack underflow detected while parsing Main Calculator Function from \"";
          break;
        case icFuncParseInvalidChannel:
          parseStr += "Invalid Channel detected while parsing Main Calculator Function from \"";
          break;
        default:
          parseStr += "Unable to parse Main Calculator Function from \"";
      }
      parseStr += buf;
      parseStr += "\"\r\n";
      return false;
    }
  }

  return true;
}


bool CIccMpeXmlEmissionCLUT::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char buf[256];
  std::string reserved;

  xml += blanks + "<EmissionCLutElement";

  if (m_nReserved) {
    sprintf(buf, " Reserved=\"%u\"", m_nReserved);
    xml +=  buf;
  }

  sprintf(buf, " InputChannels=\"%d\" OutputChannels=\"%d\" Flags=\"%d\" StorageType=\"%d\">\n", NumInputChannels(), NumOutputChannels(), m_flags, m_nStorageType);
  xml += buf;

  sprintf(buf, "  <Wavelengths start=\"%.8f\" end=\"%.8f\" steps=\"%d\"/>\n", icF16toF(m_Range.start), icF16toF(m_Range.end), m_Range.steps);
  xml += blanks + buf;

  int i;

  if (m_pWhite) {
    xml += blanks + "  <WhiteData>\n";

    xml += blanks + "   ";
    for (i=0; i<(int)m_Range.steps; i++) {
      sprintf(buf, " %.8f", m_pWhite[i]);
      xml += buf;
    }
    xml += "\n";

    xml += blanks + "  </WhiteData>\n";
  }
  
  if (!icCLUTDataToXml(xml, m_pCLUT, icConvertFloat, blanks, true))
    return false;

  xml += blanks + "</EmissionCLutElement>\n";

  return true;
}

bool CIccMpeXmlEmissionCLUT::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  m_nStorageType = (icUInt16Number)atoi(icXmlAttrValue(pNode, "StorageType", "0"));

  m_nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  m_nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));
  m_flags = atoi(icXmlAttrValue(pNode, "Flags", 0));

  if (!m_nInputChannels || !m_nOutputChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In CLutElement\n";
    return false;
  }

  xmlNode *pData;

  pData = icXmlFindNode(pNode->children, "Wavelengths");
  if (pData) {
    icFloatNumber dStart = (icFloatNumber)atof(icXmlAttrValue(pData, "start"));
    icFloatNumber dEnd = (icFloatNumber)atof(icXmlAttrValue(pData, "end"));
    icUInt16Number nSteps = atoi(icXmlAttrValue(pData, "steps"));

    if (dStart >= dEnd ||!nSteps) {
      parseStr += "Invalid Spectral Range\n";
      return false;
    }
    m_Range.start = icFtoF16(dStart);
    m_Range.end = icFtoF16(dEnd);
    m_Range.steps = nSteps;
  }
  else {
    parseStr += "Missing Spectral Range\n";
    return false;
  }

  if (m_pWhite)
    free(m_pWhite);

  m_pWhite = (icFloatNumber *)malloc(m_Range.steps*sizeof(icFloatNumber));
  if (!m_pWhite) {
    parseStr += "White buffer memory error\n";
    return false;
  }
  
  pData = icXmlFindNode(pNode->children, "WhiteData");
  if (pData) {

    if (!CIccFloatArray::ParseArray(m_pWhite, m_Range.steps, pData->children))
      return false;
  }
  else {
    parseStr += "Missing White Data";
  }

  if (m_pCLUT) {
    delete m_pCLUT;
    m_pCLUT = NULL;
  }

  if (m_pApplyCLUT) {
    delete m_pApplyCLUT;
    m_pApplyCLUT = NULL;
  }

  CIccCLUT *pCLut = icCLutFromXml(pNode, m_nInputChannels, m_Range.steps, icConvertFloat, parseStr);
  if (pCLut) {
    m_pCLUT = pCLut;
    return true;
  }

  return false;
}

bool CIccMpeXmlReflectanceCLUT::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char buf[256];
  std::string reserved;

  xml += blanks + "<ReflectanceCLutElem";

  if (m_nReserved) {
    sprintf(buf, " Reserved=\"%u\"", m_nReserved);
    xml +=  buf;
  }

  sprintf(buf, " InputChannels=\"%d\" OutputChannels=\"%d\" Flags=\"%d\">\n", NumInputChannels(), NumOutputChannels(), m_flags);
  xml += buf;

  sprintf(buf, "  <Wavelengths start=\"%.8f\" end=\"%.8f\" steps=\"%d\"/>\n", icF16toF(m_Range.start), icF16toF(m_Range.end), m_Range.steps);
  xml += buf;

  int i;

  if (m_pWhite) {
    xml += blanks + "  <WhiteData>\n";

    xml += blanks + "   ";
    for (i=0; i<(int)m_Range.steps; i++) {
      sprintf(buf, " %.8f", m_pWhite[i]);
      xml += buf;
    }
    xml += "\n";

    xml += blanks + "  </WhiteData>\n";
  }

  if (!icCLUTDataToXml(xml, m_pCLUT, icConvertFloat, blanks, true))
    return false;

  xml += blanks + "</ReflectanceCLutElem>\n";

  return true;
}

bool CIccMpeXmlReflectanceCLUT::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  m_nStorageType = (icUInt16Number)atoi(icXmlAttrValue(pNode, "StorageType", "0"));

  m_nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  m_nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));
  m_flags = atoi(icXmlAttrValue(pNode, "Flags", 0));

  if (!m_nInputChannels || !m_nOutputChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In CLutElement\n";
    return false;
  }

  xmlNode *pData;

  pData = icXmlFindNode(pNode->children, "Wavelengths");
  if (pData) {
    icFloatNumber dStart = (icFloatNumber)atof(icXmlAttrValue(pData, "start"));
    icFloatNumber dEnd = (icFloatNumber)atof(icXmlAttrValue(pData, "end"));
    icUInt16Number nSteps = atoi(icXmlAttrValue(pData, "steps"));

    if (dStart >= dEnd ||!nSteps) {
      parseStr += "Invalid Spectral Range\n";
      return false;
    }
    m_Range.start = icFtoF16(dStart);
    m_Range.end = icFtoF16(dEnd);
    m_Range.steps = nSteps;
  }
  else {
    parseStr += "Missing Spectral Range\n";
    return false;
  }

  if (m_pWhite)
    free(m_pWhite);

  m_pWhite = (icFloatNumber *)malloc(m_Range.steps*sizeof(icFloatNumber));
  if (!m_pWhite) {
    parseStr += "White buffer memory error\n";
    return false;
  }

  pData = icXmlFindNode(pNode->children, "WhiteData");
  if (pData) {

    if (!CIccFloatArray::ParseArray(m_pWhite, m_Range.steps, pData->children))
      return false;
  }
  else {
    parseStr += "Missing WhiteData";
  }

  if (m_pCLUT) {
    delete m_pCLUT;
    m_pCLUT = NULL;
  }

  if (m_pApplyCLUT) {
    delete m_pApplyCLUT;
    m_pApplyCLUT = NULL;
  }

  CIccCLUT *pCLut = icCLutFromXml(pNode, m_nInputChannels, m_Range.steps, icConvertFloat, parseStr);
  if (pCLut) {
    m_pCLUT = pCLut;
    return true;
  }

  return false;
}

bool CIccMpeXmlEmissionObserver::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  icUInt16Number nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  icUInt16Number nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));
  m_flags = atoi(icXmlAttrValue(pNode, "Flags"));

  if (!nInputChannels || !nOutputChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In EmissionObserverElement\n";
    return false;
  }

  xmlNode *pData;

  pData = icXmlFindNode(pNode->children, "Wavelengths");
  if (pData) {
    icFloatNumber dStart = (icFloatNumber)atof(icXmlAttrValue(pData, "start"));
    icFloatNumber dEnd = (icFloatNumber)atof(icXmlAttrValue(pData, "end"));
    icUInt16Number nSteps = atoi(icXmlAttrValue(pData, "steps"));

    if (dStart >= dEnd || nSteps != nInputChannels) {
      parseStr += "Invalid Spectral Range\n";
      return false;
    }
    m_Range.start = icFtoF16(dStart);
    m_Range.end = icFtoF16(dEnd);
    m_Range.steps = nSteps;
  }

  SetSize(nInputChannels, nOutputChannels, m_Range);
  if (!m_pWhite) {
    parseStr += "Unable to SetSize\n";
    return false;
  }

  pData = icXmlFindNode(pNode->children, "WhiteData");
  if (pData) {

    if (!CIccFloatArray::ParseArray(m_pWhite, m_Range.steps, pData->children))
      return false;
  }
  else {
    parseStr += "Missing White Data";
  }

  return true;
}

bool CIccMpeXmlEmissionObserver::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char buf[128];
  sprintf(buf, "<EmissionObserverElement InputChannels=\"%d\" OutputChannels=\"%d\" Flags=\"%d\"", NumInputChannels(), NumOutputChannels(), m_flags);
  xml += blanks + buf;

  if (m_nReserved) {
    sprintf(buf, " Reserved=\"%u\"", m_nReserved);
    xml += buf;
  }
  xml += ">\n";

  sprintf(buf, "  <Wavelengths start=\"%.8f\" end=\"%.8f\" steps=\"%d\"/>\n", icF16toF(m_Range.start), icF16toF(m_Range.end), m_Range.steps);
  xml += buf;

  int i;

  if (m_pWhite) {
    xml += blanks + "  <WhiteData>\n";

    xml += blanks + "   ";
    for (i=0; i<(int)m_Range.steps; i++) {
      sprintf(buf, " %.8f", m_pWhite[i]);
      xml += buf;
    }
    xml += "\n";

    xml += blanks + "  </WhiteData>\n";
  }

  xml += blanks + "</EmissionObserverElement>\n";

  return true;
}

bool CIccMpeXmlReflectanceObserver::ParseXml(xmlNode *pNode, std::string &parseStr)
{
  icUInt16Number nInputChannels = atoi(icXmlAttrValue(pNode, "InputChannels"));
  icUInt16Number nOutputChannels = atoi(icXmlAttrValue(pNode, "OutputChannels"));
  m_flags = atoi(icXmlAttrValue(pNode, "Flags"));

  if (!nInputChannels || !nOutputChannels) {
    parseStr += "Invalid InputChannels or OutputChannels In ReflectanceObserverElement\n";
    return false;
  }

  xmlNode *pData;

  pData = icXmlFindNode(pNode->children, "Wavelengths");
  if (pData) {
    icFloatNumber dStart = (icFloatNumber)atof(icXmlAttrValue(pData, "start"));
    icFloatNumber dEnd = (icFloatNumber)atof(icXmlAttrValue(pData, "end"));
    icUInt16Number nSteps = atoi(icXmlAttrValue(pData, "steps"));

    if (dStart >= dEnd || nSteps != nInputChannels) {
      parseStr += "Invalid Spectral Range\n";
      return false;
    }
    m_Range.start = icFtoF16(dStart);
    m_Range.end = icFtoF16(dEnd);
    m_Range.steps = nSteps;
  }

  SetSize(nInputChannels, nOutputChannels, m_Range);
  if (!m_pWhite) {
    parseStr += "Unable to SetSize\n";
    return false;
  }

  pData = icXmlFindNode(pNode->children, "WhiteData");
  if (pData) {

    if (!CIccFloatArray::ParseArray(m_pWhite, m_Range.steps, pData->children))
      return false;
  }
  else {
    parseStr += "Missing White Data";
  }

  return true;
}

bool CIccMpeXmlReflectanceObserver::ToXml(std::string &xml, std::string blanks/* = ""*/)
{
  char buf[128];
  sprintf(buf, "<ReflectanceObserverElement InputChannels=\"%d\" OutputChannels=\"%d\" Flags=\"%d\"", NumInputChannels(), NumOutputChannels(), m_flags);
  xml += blanks + buf;

  if (m_nReserved) {
    sprintf(buf, " Reserved=\"%u\"", m_nReserved);
    xml += buf;
  }
  xml += ">\n";

  sprintf(buf, "  <Wavelengths start=\"%.8f\" end=\"%.8f\" steps=\"%d\"/>\n", icF16toF(m_Range.start), icF16toF(m_Range.end), m_Range.steps);
  xml += buf;

  int i;

  if (m_pWhite) {
    xml += blanks + "  <WhiteData>\n";

    xml += blanks + "   ";
    for (i=0; i<(int)m_Range.steps; i++) {
      sprintf(buf, " %.8f", m_pWhite[i]);
      xml += buf;
    }
    xml += "\n";

    xml += blanks + "  </WhiteData>\n";
  }

  xml += blanks + "</ReflectanceObserverElement>\n";

  return true;
}

#ifdef USEREFICCMAXNAMESPACE
}
#endif
