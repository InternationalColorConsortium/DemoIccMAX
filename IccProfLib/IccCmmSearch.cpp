/** @file
    File:       IccCmm.cpp

    Contains:   Implementation of the CIccCmm class.

    Version:    V1

    Copyright:  � see ICC Software License
*/

/*
 * The ICC Software License, Version 0.2
 *
 *
 * Copyright (c) 2003-2025 The International Color Consortium. All rights
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
 // -Initial implementation by Max Derhak 5-21-2025
 //
 //////////////////////////////////////////////////////////////////////

#include "IccCmmSearch.h"


CIccApplyCmmSearch::CIccApplyCmmSearch(CIccCmm* pBaseCmm) : CIccApplyCmm(pBaseCmm)
{
  CIccCmmSearch* pCmm = (CIccCmmSearch*)pBaseCmm;

  if (pCmm->m_dst_to_mid.size() && pCmm->m_pcc.size()) {
    m_nApply = pCmm->m_pcc.size();
    
  }
  else if (pCmm->m_src_to_mid.size()) {
    m_nApply = 1;
  }
  m_mid_data.resize(m_nApply);
  m_nSamples = pCmm->m_dst_to_mid[0]->GetDestSamples();
  icUInt16Number nSrcSamples = pCmm->m_dst_to_mid[0]->GetSourceSamples();
  for (size_t i = 0; i < m_nApply; i++) {
    m_mid_data[i].resize(m_nSamples);
  }
  m_pixel.resize(m_nSamples);
  m_startPixel.resize(nSrcSamples);
}

CIccApplyCmmSearch::~CIccApplyCmmSearch()
{
}

static icFloatNumber sq(icFloatNumber x) { return x * x; }

icFloatNumber CIccApplyCmmSearch::costFunc(CIccSearchVec& point)
{
  CIccCmmSearch* pCmm = (CIccCmmSearch*)m_pCmm;
  icFloatNumber sum = 0.0;
  for (size_t i = 0; i < m_nApply; i++) {
    pCmm->m_dst_to_mid[i]->Apply(&m_pixel[0], &point.vec()[0]);
    icFloatNumber difSum = 0;
    for (icUInt16Number j = 0; j < m_nSamples; j++) {
      difSum += sq(m_pixel[j] - m_mid_data[i][j]);
    }
    sum += sqrt(difSum) * pCmm->m_weight[i];
  }
  return sum;
}

icStatusCMM CIccApplyCmmSearch::Apply(icFloatNumber* DstPixel, const icFloatNumber* SrcPixel)
{
  CIccCmmSearch* pCmm = (CIccCmmSearch*)m_pCmm;

  for (size_t i = 0; i < m_nApply; i++) {
    pCmm->m_src_to_mid[i]->Apply(&m_mid_data[i][0], SrcPixel);
  }

  pCmm->m_mid_to_dst->Apply(&m_startPixel[0], &m_mid_data[0][0]);

  icFloatVector result = findMin(m_startPixel);

  memcpy(DstPixel, &result[0], result.size() * sizeof(icFloatNumber));

  return icCmmStatOk;
}

icStatusCMM CIccApplyCmmSearch::Apply(icFloatNumber* DstPixel, const icFloatNumber* SrcPixel, icUInt32Number nPixels)
{
  CIccCmmSearch* pCmm = (CIccCmmSearch*)m_pCmm;
  icUInt32Number nSrcSamples = pCmm->GetSourceSamples();
  icUInt32Number nDstSamples = pCmm->GetDestSamples();

  for (icUInt32Number i = 0; i < nPixels; i++) {
    Apply(DstPixel, SrcPixel);
    DstPixel += nDstSamples;
    SrcPixel += nSrcSamples;
  }

  return icCmmStatOk;
}


CIccCmmSearch::CIccCmmSearch()
{
}

CIccCmmSearch::~CIccCmmSearch()
{
  if (m_pSrcProfile)
    delete m_pSrcProfile;

  if (m_pMidProfile)
    delete m_pMidProfile;

  if (m_pDstProfile)
    delete m_pDstProfile;
}

//virtual CIccPCS *GetPCS() { return new CIccPCS(); }

///Must make to or three calls to some form of AddXform() before calling Begin()
icStatusCMM CIccCmmSearch::AddXform(CIccProfile* pProfile,
  icRenderingIntent nIntent,
  icXformInterp nInterp,
  IIccProfileConnectionConditions* pPc,
  icXformLutType nLutType,
  bool bUseD2BxB2DxTags,
  CIccCreateXformHintManager* pHintManager)
{
  if (pProfile->m_Header.deviceClass == icSigNamedColorClass)
    return icCmmStatInvalidLut;

  switch (m_nAttached) {
  case 0:
    m_pSrcProfile = pProfile;
    m_nSrcIntent = nIntent;
    m_nSrcInterp = nInterp;
    m_nSrcLutType = nLutType;
    m_bSrcUseD2BxB2DxTags = bUseD2BxB2DxTags;
    break;
  case 1:
    m_pDstProfile = pProfile;
    m_nDstIntent = nIntent;
    m_nDstInterp = nInterp;
    m_nDstLutType = nLutType;
    m_bDstUseD2BxB2DxTags = bUseD2BxB2DxTags;
    break;
  case 2:
    m_pMidProfile = m_pDstProfile;
    m_nMidIntent = m_nDstIntent;
    m_nMidInterp = m_nDstInterp;
    m_nMidLutType = m_nDstLutType;
    m_bMidUseD2BxB2DxTags = m_bDstUseD2BxB2DxTags;

    m_pDstProfile = pProfile;
    m_nDstIntent = nIntent;
    m_nDstInterp = nInterp;
    m_nDstLutType = nLutType;
    m_bDstUseD2BxB2DxTags = bUseD2BxB2DxTags;
    break;
  default:
    delete pProfile;
    return icCmmStatInvalidProfile;
  }

  m_nAttached++;

  return icCmmStatOk;
}

void CIccCmmSearch::SetDstInitProfile(CIccProfile* pProfile,
  icRenderingIntent nIntent,
  icXformInterp nInterp,
  IIccProfileConnectionConditions* pPcc,
  icXformLutType nLutType,
  bool bUseD2BxB2DxTags)
{
  m_pDstInitProfile = pProfile;
  m_nDstInitIntent = nIntent;
  m_nDstInitInterp = nInterp;
  m_pDstInitPcc = pPcc;
  m_nDstInitLutType = nLutType;
  m_bDstInitUseD2BxB2DxTags = bUseD2BxB2DxTags;
}


icStatusCMM CIccCmmSearch::AttachPCC(IIccProfileConnectionConditions* pPCC, icFloatNumber dWeight)
{
  m_pcc.push_back(pPCC);
  m_weight.push_back(dWeight);

  return icCmmStatOk;
}

#define checkCmmStatus(rv) if (rv != icCmmStatOk) return rv

icStatusCMM CIccCmmSearch::Begin(bool bAllocNewApply, bool bUsePcsConversion)
{
  icStatusCMM rv;

  if (m_nAttached < 2)
    return icCmmStatBadXform;

  if (m_nAttached == 2) {
    //mid_to_dst
    CIccCmmPtr cmm = CIccCmmPtr(new CIccCmm); 
    rv = cmm->AddXform(*m_pSrcProfile, m_nSrcIntent, m_nSrcInterp, m_pSrcPcc, m_nSrcLutType, m_bSrcUseD2BxB2DxTags);
    checkCmmStatus(rv);

    if (m_pDstInitProfile) {
      rv = cmm->AddXform(m_pDstInitProfile, m_nDstInitIntent, m_nDstInitInterp, m_pDstInitPcc, m_nDstInitLutType, m_bDstInitUseD2BxB2DxTags);
      m_pDstInitProfile = nullptr;
      checkCmmStatus(rv);
    }
    else {
      rv = cmm->AddXform(*m_pDstProfile, m_nDstIntent, m_nDstInterp, m_pDstPcc, m_nDstLutType, m_bDstUseD2BxB2DxTags);
      checkCmmStatus(rv);
    }

    rv = cmm->Begin();
    checkCmmStatus(rv);

    m_mid_to_dst = cmm;

    //src_to_mid
    cmm = CIccCmmPtr(new CIccCmm);
    rv = cmm->AddXform(*m_pSrcProfile, m_nSrcIntent, m_nSrcInterp, m_pcc.size() ? m_pcc[0] : m_pSrcPcc, m_nSrcLutType, m_bSrcUseD2BxB2DxTags);
    checkCmmStatus(rv);

    rv = cmm->AddXform(*m_pDstProfile, m_nDstIntent, m_nSrcInterp, m_pcc.size() ? m_pcc[0] : m_pDstPcc, m_nSrcLutType, m_bDstUseD2BxB2DxTags);
    checkCmmStatus(rv);

    delete m_pDstProfile;
    m_pDstProfile = nullptr;

    rv = cmm->Begin();
    checkCmmStatus(rv);
    m_src_to_mid.push_back(cmm);
   
    m_nSrcSpace = cmm->GetSourceSpace();
    m_nDestSpace = cmm->GetDestSpace();
    m_nLastIntent = cmm->GetLastIntent();
    m_nLastSpace = cmm->GetLastSpace();

    if (!m_weight.size())
      m_weight.push_back(1.0);
  }
  else {
    if (m_weight.size() < m_pcc.size())
      return icCmmStatBadXform;

    //mid_to_dst
    CIccCmmPtr cmm = CIccCmmPtr(new CIccCmm);
    rv = cmm->AddXform(*m_pMidProfile, m_nMidIntent, m_nMidInterp, m_pMidPcc, m_nMidLutType, m_bMidUseD2BxB2DxTags);
    checkCmmStatus(rv);

    if (m_pDstInitProfile) {
      rv = cmm->AddXform(m_pDstInitProfile, m_nDstInitIntent, m_nDstInitInterp, m_pDstInitPcc, m_nDstInitLutType, m_bDstInitUseD2BxB2DxTags);
      m_pDstInitProfile = nullptr;
      checkCmmStatus(rv);
    }
    else {
      rv = cmm->AddXform(*m_pDstProfile, m_nDstIntent, m_nDstInterp, m_pDstPcc, m_nDstLutType, m_bDstUseD2BxB2DxTags);
      checkCmmStatus(rv);
    }

    rv = cmm->Begin();
    checkCmmStatus(rv);

    m_mid_to_dst = cmm;

    if (m_pcc.size()) {
      m_nSrcSpace = icSigUnknownData;

      for (auto pcc : m_pcc) {
        //dst_to_mid
        cmm = CIccCmmPtr(new CIccCmm);
        rv = cmm->AddXform(*m_pDstProfile, m_nDstIntent, m_nDstInterp, pcc, m_nDstLutType, m_bDstUseD2BxB2DxTags);
        checkCmmStatus(rv);

        rv = cmm->AddXform(*m_pMidProfile, m_nMidIntent, m_nMidInterp, pcc, m_nMidLutType, m_bMidUseD2BxB2DxTags);
        checkCmmStatus(rv);

        rv = cmm->Begin();
        checkCmmStatus(rv);
        m_dst_to_mid.push_back(cmm);

        //src_to_mid
        cmm = CIccCmmPtr(new CIccCmm);
        rv = cmm->AddXform(*m_pSrcProfile, m_nSrcIntent, m_nSrcInterp, pcc, m_nSrcLutType, m_bSrcUseD2BxB2DxTags);
        checkCmmStatus(rv);

        rv = cmm->AddXform(*m_pMidProfile, m_nMidIntent, m_nMidInterp, pcc, m_nMidLutType, m_bMidUseD2BxB2DxTags);
        checkCmmStatus(rv);

        rv = cmm->Begin();
        checkCmmStatus(rv);
        m_src_to_mid.push_back(cmm);

        if (m_nSrcSpace == icSigUnknownData)
          m_nSrcSpace = cmm->GetSourceSpace();
      }
    }
    else {  //We must have PCC entries if we have a middle profile
      return icCmmStatBadConnection;
    }

    m_nDestSpace = m_mid_to_dst->GetDestSpace();
    m_nLastIntent = m_mid_to_dst->GetLastIntent();
    m_nLastSpace = m_mid_to_dst->GetLastSpace();
  }

  m_pApply = new CIccApplyCmmSearch(this);

  m_bValid = true;

  return rv;
}

//Call to Detach and remove all pending IO objects attached to the profiles used by the CMM. Should be called only after Begin()
icStatusCMM CIccCmmSearch::RemoveAllIO()
{
  for (auto p : m_src_to_mid)
    p->RemoveAllIO();

  for (auto p : m_dst_to_mid)
    p->RemoveAllIO();

  m_mid_to_dst->RemoveAllIO();

  return icCmmStatOk;
}

