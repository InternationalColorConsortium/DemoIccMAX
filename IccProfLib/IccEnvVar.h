/** @file
    File:       IccEnvVar.h

    Contains:   Header for implementation of the IIccCmmEnvVarLookup interface class.

    Version:    V1

    Copyright:  (c) see ICC Software License
*/

/*
 * The ICC Software License, Version 0.2
 *
 *
 * Copyright (c) 2003-2016 The International Color Consortium. All rights 
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
// -Initial implementation by Max Derhak 3-1-2016
//
//////////////////////////////////////////////////////////////////////

#if !defined(_ICCENVVAR_H)
#define _ICCENVVAR_H

#include "IccDefs.h"
#include "IccCmm.h"
#include <map>

#ifdef USEREFICCMAXNAMESPACE
namespace refIccMAX {
#endif


typedef std::map<icSignature, icFloatNumber> icCmmEnvSigMap;

class ICCPROFLIB_API CIccCmmVarLookup : public IIccCmmEnvVarLookup
{
public:
  CIccCmmVarLookup(icCmmEnvSigMap &map);
  virtual ~CIccCmmVarLookup();

  virtual bool GetEnvVar(icSigCmmEnvVar sig, icFloatNumber &val);
  virtual bool IndexedEnvVar(icUInt32Number nIndex, icSigCmmEnvVar &sig, icFloatNumber &val);
protected:
  icCmmEnvSigMap *m_map;
};

class ICCPROFLIB_API CIccCmmEnvVarHint : public CIccCreateCmmEnvVarXformHint
{
public:
  CIccCmmEnvVarHint(icCmmEnvSigMap &map);
  virtual ~CIccCmmEnvVarHint();

  virtual IIccCmmEnvVarLookup *GetNewCmmEnvVarLookup() const { return new CIccCmmVarLookup(*m_map);}

protected:
  icCmmEnvSigMap *m_map;
};

class ICCPROFLIB_API CIccCmmPccEnvVarHint : public CIccCreateCmmPccEnvVarXformHint
{
public:
  CIccCmmPccEnvVarHint(icCmmEnvSigMap& map);
  virtual ~CIccCmmPccEnvVarHint();

  virtual IIccCmmEnvVarLookup* GetNewCmmEnvVarLookup() const { return new CIccCmmVarLookup(*m_map); }

protected:
  icCmmEnvSigMap* m_map;
};


#ifdef USEREFICCMAXNAMESPACE
} //namespace refIccMAX
#endif

#endif // !defined(_ICCPCC_H)
