/** @file
    File:       IccStructBasic.cpp

    Contains:   Implementation of the IIccStruct class and basic inherited classes

    Version:    V1

    Copyright:  � see ICC Software License
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

////////////////////////////////////////////////////////////////////// 
// HISTORY:
//
// -Initial implementation by Max Derhak 5-15-2003
//
//////////////////////////////////////////////////////////////////////

#ifdef WIN32
  #pragma warning( disable: 4786) //disable warning in <list.h>
  #include <windows.h>
#endif
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include "IccStructBasic.h"
#include "IccUtil.h"
#include "IccStructFactory.h"

#ifndef __min
#include <algorithm>
using std::min;
#define __min min
#endif

#ifdef USEREFICCMAXNAMESPACE
namespace refIccMAX {
#endif


CIccStructUnknown::CIccStructUnknown(CIccTagStruct *pTagStruct)
{
  m_pTag = pTagStruct;
}


CIccStructUnknown::~CIccStructUnknown()
{

}


IIccStruct* CIccStructUnknown::NewCopy(CIccTagStruct *pTagStruct) const
{
  CIccStructUnknown *rv = new CIccStructUnknown(pTagStruct);

  return rv;
}


bool CIccStructUnknown::Describe(std::string &sDescription) const
{
  char buf[256];
  CIccInfo info;
  int n;

  if (m_pTag) {
    TagEntryList *entries = m_pTag->GetElemList();
    TagEntryList::iterator i;

    for (n=0, i=entries->begin(); i!=entries->end(); n++, i++) {
      if (i->pTag) {
        if (n)
          sDescription += "\r\n";
        sprintf(buf, "Begin SubTag(%s)\r\n", GetElemName(i->TagInfo.sig).c_str());
        sDescription += buf;
        i->pTag->Describe(sDescription);
        sprintf(buf, "End SubTag(%s)\r\n", GetElemName(i->TagInfo.sig).c_str());
        sDescription += buf;
      }
    }
  }
  return true;
}


std::string CIccStructUnknown::GetElemName(icSignature sigElem) const
{
  CIccInfo info;
  std::string str;
  str = info.GetSigName(sigElem);

  return str;
}

CIccTag *CIccStructUnknown::GetElem(icSignature sigElem) const
{
  if (!m_pTag)
    return NULL;

  return m_pTag->FindElem(sigElem);
}



CIccStructNamedColor::CIccStructNamedColor(CIccTagStruct *pTagStruct)
{
  m_pTag = pTagStruct;
}


CIccStructNamedColor::~CIccStructNamedColor()
{

}


IIccStruct* CIccStructNamedColor::NewCopy(CIccTagStruct *pTagStruct) const
{
  CIccStructNamedColor *rv = new CIccStructNamedColor(pTagStruct);

  return rv;
}


bool CIccStructNamedColor::Describe(std::string &sDescription) const
{
  return CIccStructUnknown::Describe(sDescription);
}


std::string CIccStructNamedColor::GetElemName(icSignature sigElem) const
{
  CIccInfo info;

  switch (sigElem) {
    case icSigNameNamedColorMember:
      return "NameSubTag";
    case icSigDeviceNamedColorMember:
      return "DeviceSubTag";
    case icSigPcsNamedColorMember:
      return "PcsSubTag";
    case icSigSpectralNamedColorMember:
      return "SpectralSubTag";
    case icSigTintNamedColorMember:
      return "TintSubTag";
    default:
      break;
  }
  std::string str;
  str = "UnknownSubTag_";
  str += info.GetSigName(sigElem);

  return str;
}

std::string CIccStructNamedColor::getName() const
{
  CIccTag *pTag = m_pTag->FindElem(icSigNameNamedColorMember);

  if (pTag && pTag->GetType()==icSigUtf8TextType) {
    CIccTagUtf8Text *pText = (CIccTagUtf8Text*)pTag;

    return std::string((char*)pText->GetText());
  }

  return "";
}

CIccTagNumArray *CIccStructNamedColor::GetNumArray(icSignature sigElem) const
{
  CIccTag *pTag = GetElem(sigElem);
  if (pTag && pTag->IsNumArrayType())
    return (CIccTagNumArray*)pTag;

  return NULL;
}

bool CIccStructNamedColor::GetTint(icFloatNumber *dstColor,
                                  icFloatNumber tint,
                                  CIccTagNumArray *pZero,
                                  icSignature sigElem,
                                  icUInt32Number nSamples) const
{

  if (tint<0.0f)
    tint = 0.0f;
  else if (tint>1.0f)
    tint = 1.0f;

  CIccTagNumArray *pData;
  CIccTagNumArray *pTint;

  pData = GetNumArray(sigElem);
  pTint = GetNumArray(icSigTintNamedColorMember);

  if (!pData || !nSamples)
    return false;

  int nEntries = pData->GetNumValues()/nSamples;
  if (nEntries<1)
    return false;

  bool bNoZero;
  bool bNeedZero;
  icFloatNumber pos;

  if (pTint) {
    if (pTint->GetNumValues()!=nEntries)
      return false;

    if (!pTint->ValuePos(pos, tint, bNoZero))
      return false;

    bNeedZero = (pos<0.0f);

    if (bNoZero)
      pos = (pos + 1.0f)/nEntries;
    else
      pos = pos / (nEntries-1.0f);
  }
  else {
    bNoZero = true;
    bNeedZero = true;
    pos = tint;
  }

  icFloatNumber vals[256];
  icFloatNumber *zeroVals=NULL;

  if (bNoZero) {
    if (!pZero || pZero->GetNumValues()!=nSamples)
      return false;

    if (bNeedZero) {
      if (nSamples<256)
        zeroVals = vals;
      else if (bNeedZero)
        zeroVals = new icFloatNumber[nSamples];

      pZero->GetValues(zeroVals, 0, nSamples);
    }
    else {
      zeroVals = vals;
    }
  }

  bool rv = pData->Interpolate(dstColor, pos, nSamples, zeroVals);

  if (zeroVals && zeroVals!=vals)
    delete [] zeroVals;

  return rv;
}


CIccStructBRDF::CIccStructBRDF(CIccTagStruct *pTagStruct)
{
  m_pTag = pTagStruct;
}


CIccStructBRDF::~CIccStructBRDF()
{

}


IIccStruct* CIccStructBRDF::NewCopy(CIccTagStruct *pTagStruct) const
{
  CIccStructBRDF *rv = new CIccStructBRDF(pTagStruct);

  return rv;
}


bool CIccStructBRDF::Describe(std::string &sDescription) const
{
  return CIccStructUnknown::Describe(sDescription);
}


std::string CIccStructBRDF::GetElemName(icSignature sigElem) const
{
  CIccInfo info;

  switch (sigElem) {
    case icSigTypeBrdfMember:
      return "TypeSubTag";
    case icSigFunctionBrdfMember:
      return "FunctionSubTag";
    case icSigNumParamsBrdfMember:
      return "NumParamsSubTag";
    case icSigTransformBrdfMember:
      return "TransformSubTag";
    case icSigLightTransformBrdfMember:
      return "LightTransformSubTag";
    case icSigOutputTransformBrdfMember:
      return "OutputTransformSubTag";
    default:
      break;
  }
  std::string str;
  str = "UnknownSubTag_";
  str += info.GetSigName(sigElem);

  return str;
}

icSigBRDFType CIccStructBRDF::GetBRDFType() const
{
  CIccTag* pTag = GetElem(icSigTypeBrdfMember);

  if (pTag)
  {
    if (pTag->GetType() == icSigSignatureType)
    {
      CIccTagSignature* pTagSig = dynamic_cast<CIccTagSignature*>(pTag);
      if (pTagSig)
        return  (icSigBRDFType)pTagSig->GetValue();
    }
  }
  return (icSigBRDFType)icSigUnknownType;
}


icSigBRDFFunction CIccStructBRDF::GetBRDFFunction() const
{
  CIccTag* pTag = GetElem(icSigTypeBrdfMember);

  if (pTag)
  {
    if (pTag->GetType() == icSigSignatureType)
    {
      CIccTagSignature* pTagSig = dynamic_cast<CIccTagSignature*>(pTag);
      if (pTagSig)
        return  (icSigBRDFFunction)pTagSig->GetValue();
    }
  }
  return (icSigBRDFFunction)icSigUnknownType;
}


CIccStructColorEncodingParams::CIccStructColorEncodingParams(CIccTagStruct *pTagStruct)
{
  m_pTag = pTagStruct;
}


CIccStructColorEncodingParams::~CIccStructColorEncodingParams()
{

}


IIccStruct* CIccStructColorEncodingParams::NewCopy(CIccTagStruct *pTagStruct) const
{
  CIccStructColorEncodingParams *rv = new CIccStructColorEncodingParams(pTagStruct);

  return rv;
}


bool CIccStructColorEncodingParams::Describe(std::string &sDescription) const
{
  return CIccStructUnknown::Describe(sDescription);
}


std::string CIccStructColorEncodingParams::GetElemName(icSignature sigElem) const
{
  CIccInfo info;

  switch (sigElem) {
	case icBluePrimaryXYZCeptMember:
		return "BluePrimaryXYZSubTag";
	case icGreenPrimaryXYZCeptMember:
		return "GreenPrimaryXYZSubTag";
	case icRedPrimaryXYZCeptMember:
		return "icRedPrimaryXYZSubTag";
	case icTransferFunctionCeptMember:
		return "icTransferFunctionSubTag";
	case icLumaChromaMatrixCeptMember:
        return "icLumaChromaMatrixSubTag";
	case icWhitePointLuminanceCeptMember:
		return "icWhitePointLuminanceSubTag";
	case icWhitePointChromaticityCeptMember:
		return "WhitePointChromaticitySubTag";
	case icEncodingRangeCeptMember:
		return "EncodingRangeSubTag";
	case icBitDepthCeptMember:
		return "BitDepthCSubTag";
	case icImageStateCeptMember:
		return "ImageStateSubTag";
	case icImageBackgroundCeptMember:
		return "ImageBackgroundSubTag";
	case icViewingSurroundCeptMember:
		return "ViewingSurroundSubTag";
	case icAmbientIlluminanceCeptMember:
		return "AmbientIlluminancembientIlluminanceSubTag";
	case icAmbientWhitePointLuminanceCeptMember:
		return "AmbientWhitePointLuminanceSubTag";
	case icAmbientWhitePointChromaticityCeptMember:
		return "AmbientWhitePointChromaticitySubTag";
	case icViewingFlareCeptMember:
		return "ViewingFlareSubTag";
	case icValidRelativeLuminanceRangeCeptMember:
		return "ValidRelativeLuminanceRangeSubTag";
	case icMediumWhitePointLuminanceCeptMember:
		return "MediumWhitePointLuminanceSubTag";
	case icMediumWhitePointChromaticityCeptMember:
		return "MediumWhitePointChromaticitySubTag";
	case icMediumBlackPointLuminanceCeptMember:
		return "MediumBlackPointLuminanceSubTag";
	case icMediumBlackPointChromaticityCeptMember:
		return "MediumBlackPointChromaticitySubTag";
    default:
      break;
  }
  std::string str;
  str = "UnknownSubTag_";
  str += info.GetSigName(sigElem);

  return str;
}



#ifdef USEREFICCMAXNAMESPACE
} //namespace refIccMAX
#endif
