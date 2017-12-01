/** @file
    File:       IccStructBasic.h

    Contains:   Header for implementation of basic IccStruct handlers

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
// -Initial implementation by Max Derhak 7-27-2011
//
//////////////////////////////////////////////////////////////////////

#if !defined(_ICCSTRUCTBASIC_H)
#define _ICCSTRUCTBASIC_H

#include <list>
#include <string>
#include "IccDefs.h"
#include "IccTagComposite.h"
#ifdef USEREFICCMAXNAMESPACE
namespace refIccMAX {
#endif

/**
****************************************************************************
* Class: CIccStructUnknown
* 
* Purpose: The Unknown struct handler
*****************************************************************************
*/
class ICCPROFLIB_API CIccStructUnknown : public IIccStruct
{
public:
  CIccStructUnknown(CIccTagStruct *pTagStruct=NULL);
  virtual ~CIccStructUnknown();
  virtual IIccStruct* NewCopy(CIccTagStruct *pNewTagStruct) const;

  virtual bool Describe(std::string &sDescription) const;

  virtual const icChar *GetClassName() const { return "CIccStructUnknown"; }
  virtual std::string GetElemName(icSignature sigElem) const;

  CIccTag *GetElem(icSignature sigElem) const;

protected:
  CIccTagStruct *m_pTag;
  
};

/**
****************************************************************************
* Class: CIccStructNamedColor
* 
* Purpose: The Named Color struct handler
*****************************************************************************
*/
class ICCPROFLIB_API CIccStructNamedColor : public CIccStructUnknown
{
public:
  CIccStructNamedColor(CIccTagStruct *pTagStruct=NULL);
  virtual ~CIccStructNamedColor();
  virtual IIccStruct* NewCopy(CIccTagStruct *pNewTagStruct) const;

  virtual bool Describe(std::string &sDescription) const;

  virtual const icChar *GetClassName() const { return "CIccStructNamedColor"; }
  virtual std::string GetElemName(icSignature sigElem) const;

  std::string getName() const;

  bool GetTint(icFloatNumber *dstColor,
               icFloatNumber tint,
               CIccTagNumArray *pZero,
               icSignature sigElem,
               icUInt32Number nSamples) const;

  CIccTagNumArray *GetNumArray(icSignature sigElem) const;

protected:

};


/**
****************************************************************************
* Class: CIccStructBRDF
* 
* Purpose: The BRDF struct handler
*****************************************************************************
*/
class ICCPROFLIB_API CIccStructBRDF : public CIccStructUnknown
{
public:
  CIccStructBRDF(CIccTagStruct *pTagStruct=NULL);
  virtual ~CIccStructBRDF();
  virtual IIccStruct* NewCopy(CIccTagStruct *pNewTagStruct) const;

  virtual bool Describe(std::string &sDescription) const;

  virtual const icChar *GetClassName() const { return "CIccStructBRDF"; }
  virtual std::string GetElemName(icSignature sigElem) const;

  virtual icSigBRDFType GetBRDFType() const;

  virtual icSigBRDFFunction GetBRDFFunction() const;

protected:

};


/**
****************************************************************************
* Class: CIccStructColorEncodingParams
* 
* Purpose: The Named Color struct handler
*****************************************************************************
*/
class ICCPROFLIB_API CIccStructColorEncodingParams : public CIccStructUnknown
{
public:
  CIccStructColorEncodingParams(CIccTagStruct *pTagStruct=NULL);
  virtual ~CIccStructColorEncodingParams();
  virtual IIccStruct* NewCopy(CIccTagStruct *pNewTagStruct) const;

  virtual bool Describe(std::string &sDescription) const;

  virtual const icChar *GetClassName() const { return "CIccStructColorEncodingParams"; }
  virtual std::string GetElemName(icSignature sigElem) const;

  std::string getName() const;

protected:

};


#ifdef USEREFICCMAXNAMESPACE
} //namespace refIccMAX
#endif

#endif // !defined(_ICCSTRUCTBASIC_H)
