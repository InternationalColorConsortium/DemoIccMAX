/** @file
    File:       IccPcc.cpp

    Contains:   Implementation of the IIccProfileConnectionConditions interface class.

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

////////////////////////////////////////////////////////////////////// 
// HISTORY:
//
// -Initial implementation by Max Derhak 5-15-2003
//
//////////////////////////////////////////////////////////////////////

#ifdef WIN32
  #pragma warning( disable: 4786) //disable warning in <list.h>
#endif
#include "IccPcc.h"
#include "IccProfile.h"
#include "IccTag.h"
#include "IccCmm.h"

bool IIccProfileConnectionConditions::isEquivalentPcc(IIccProfileConnectionConditions &IPCC)
{
  icIlluminant illum = getPccIlluminant();
  icStandardObserver obs = getPccObserver();

  if (illum!=IPCC.getPccIlluminant() || obs!= IPCC.getPccObserver())
    return false;

  if ((illum==icIlluminantDaylight || illum==icIlluminantBlackBody) && getPccCCT()!=IPCC.getPccCCT())
    return false;

  if (illum==icIlluminantUnknown)
    return false;
    
  if (obs==icStdObsCustom) { 
    if (!hasIlluminantSPD() && !IPCC.hasIlluminantSPD()) {
      icFloatNumber XYZ1[3], XYZ2[3];
      getNormIlluminantXYZ(&XYZ1[0]);
      IPCC.getNormIlluminantXYZ(&XYZ2[0]);

      if (XYZ1[0]!=XYZ2[0] ||
          XYZ1[1]!=XYZ2[1] ||
          XYZ1[2]!=XYZ2[2])
        return false;
    }
    else {
      return false;
    }
  }

  return true;
}

icIlluminant IIccProfileConnectionConditions::getPccIlluminant()
{
  const CIccTagSpectralViewingConditions *pCond = getPccViewingConditions();
  if (!pCond)
    return icIlluminantD50;

  return pCond->m_stdIlluminant;
}

icFloatNumber IIccProfileConnectionConditions::getPccCCT()
{
  const CIccTagSpectralViewingConditions *pCond = getPccViewingConditions();
  if (!pCond)
    return 0.0f;

  return pCond->m_colorTemperature;
}

icStandardObserver IIccProfileConnectionConditions::getPccObserver()
{
 const  CIccTagSpectralViewingConditions *pCond = getPccViewingConditions();
  if (!pCond)
    return icStdObs1931TwoDegrees;

  return pCond->m_stdObserver;
}

bool IIccProfileConnectionConditions::isStandardPcc()
{
  if (getPccIlluminant()==icIlluminantD50 && getPccObserver()==icStdObs1931TwoDegrees)
    return true;

  return false;
}

bool IIccProfileConnectionConditions::hasIlluminantSPD()
{
  const  CIccTagSpectralViewingConditions *pCond = getPccViewingConditions();
  if (!pCond)
    return false;

  if (!pCond->m_illuminantRange.steps || !pCond->m_illuminant)
    return false;

  return true;
}

icFloatNumber IIccProfileConnectionConditions::getObserverIlluminantScaleFactor()
{
  const CIccTagSpectralViewingConditions *pView = getPccViewingConditions();
  if (!pView)
    return 1.0;

  int i, n = pView->m_illuminantRange.steps;
  CIccMatrixMath *mapRange=CIccMatrixMath::rangeMap(pView->m_observerRange, pView->m_illuminantRange);
  icFloatNumber rv=0;

  if (mapRange) {
    icFloatNumber *Ycmf = new icFloatNumber[pView->m_illuminantRange.steps];
    icFloatNumber *ill = pView->m_illuminant;
    mapRange->VectorMult(Ycmf, &pView->m_observer[pView->m_observerRange.steps]);
    delete mapRange;

    for (i=0; i<n; i++) {
      rv += Ycmf[i]*ill[i];
    }
    delete [] Ycmf;
  }
  else {
    icFloatNumber *Ycmf = &pView->m_observer[pView->m_observerRange.steps];
    icFloatNumber *ill = pView->m_illuminant;

    for (i=0; i<n; i++) {
      rv += Ycmf[i]*ill[i];
    }
  }
  return rv;
}

icFloatNumber IIccProfileConnectionConditions::getObserverWhiteScaleFactor(icFloatNumber *pWhite, const icSpectralRange &whiteRange)
{
  const CIccTagSpectralViewingConditions *pView = getPccViewingConditions();
  if (!pView)
    return 1.0;

  int i, n = whiteRange.steps;
  CIccMatrixMath *mapRange=CIccMatrixMath::rangeMap(pView->m_observerRange, whiteRange);
  icFloatNumber rv=0;

  if (mapRange) {
    icFloatNumber *Ycmf = new icFloatNumber[whiteRange.steps];
    mapRange->VectorMult(Ycmf, &pView->m_observer[pView->m_observerRange.steps]);
    delete mapRange;

    for (i=0; i<n; i++) {
      rv += Ycmf[i]*pWhite[i];
    }
    delete [] Ycmf;
  }
  else {
    icFloatNumber *Ycmf = &pView->m_observer[pView->m_observerRange.steps];

    for (i=0; i<n; i++) {
      rv += Ycmf[i]*pWhite[i];
    }
  }
  return rv;
}

icFloatNumber *IIccProfileConnectionConditions::getEmissiveObserver(const icSpectralRange &range, const icFloatNumber *pWhite, icFloatNumber *obs)
{
  const CIccTagSpectralViewingConditions *pView = getPccViewingConditions();
  if (!pView || !pWhite)
    return NULL;

  int i, n = range.steps, size = 3*n;
  icFloatNumber *fptr, *tptr;

  if (!obs) 
    obs = (icFloatNumber*)malloc(size*sizeof(icFloatNumber));

  if (obs) {
    CIccMatrixMath *mapRange=CIccMatrixMath::rangeMap(pView->m_observerRange, range);

    //Copy observer while adjusting to range
    if (mapRange) {

      if (obs) {
        icFloatNumber *Ycmf = new icFloatNumber[range.steps];
        fptr = &pView->m_observer[0];
        tptr = obs;
        for (i=0; i<3; i++) {
          mapRange->VectorMult(tptr, fptr);
          fptr += pView->m_observerRange.steps;
          tptr += range.steps;
        }
      }
      delete mapRange;
    }
    else {
      memcpy(obs, pView->m_observer, size*sizeof(icFloatNumber));
    }

    //Calculate scale constant 
    icFloatNumber k=0.0f;
    fptr = &obs[range.steps]; //Using second color matching function
    for (i=0; i<(int)range.steps; i++) {
      k += fptr[i]*pWhite[i];
    }

    //Scale observer so application of observer against white results in 1.0.
    for (i=0; i<size; i++) {
      obs[i] = obs[i] / k;
    }

    CIccMatrixMath observer(3,range.steps);
    memcpy(observer.entry(0), obs, size*sizeof(icFloatNumber));

    icFloatNumber xyz[3];
    observer.VectorMult(xyz, pWhite);
  }

  return obs;
}

CIccMatrixMath *IIccProfileConnectionConditions::getReflectanceObserver(const icSpectralRange &rangeRef)
{
  CIccMatrixMath *pAdjust=NULL, *pMtx;
  const CIccTagSpectralViewingConditions *pView = getPccViewingConditions();

  pMtx = CIccMatrixMath::rangeMap(rangeRef, pView->m_illuminantRange);
  if (pMtx)
    pAdjust = pMtx;

  pMtx = pView->getObserverMatrix(pView->m_illuminantRange);

  if (pAdjust) {
    pMtx = pAdjust->Mult(pMtx);
    delete pAdjust;
  }
  pAdjust = pMtx;

  pAdjust->VectorScale(pView->m_illuminant);
  pAdjust->Scale(1.0f / pAdjust->RowSum(1));

  return pAdjust;
}

CIccCombinedConnectionConditions::CIccCombinedConnectionConditions(CIccProfile *pProfile, 
                                                                   IIccProfileConnectionConditions *pAppliedPCC, 
                                                                   bool bReflectance/*=false*/)
{
  const CIccTagSpectralViewingConditions *pView = pAppliedPCC ? pAppliedPCC->getPccViewingConditions() : NULL;

  if (bReflectance) {
    m_pPCC = pAppliedPCC;
    m_pViewingConditions = NULL;

    m_illuminantXYZ[0] = pView->m_illuminantXYZ.X;
    m_illuminantXYZ[1] = pView->m_illuminantXYZ.Y;
    m_illuminantXYZ[2] = pView->m_illuminantXYZ.Z;
    m_bValidMediaXYZ = pProfile->calcMediaWhiteXYZ(m_mediaXYZ, pAppliedPCC);
  }
  else if (pView) {
    m_pPCC = NULL;
    m_pViewingConditions = (CIccTagSpectralViewingConditions*)pView->NewCopy();
    m_pViewingConditions->m_colorTemperature = pView->m_colorTemperature;
    m_pViewingConditions->m_stdIlluminant = pView->m_stdIlluminant;
    m_pViewingConditions->m_illuminantRange = pView->m_illuminantRange;
    if (m_pViewingConditions->m_illuminant)
      free(m_pViewingConditions->m_illuminant);
    if (pView->m_illuminantRange.steps) {
      int n = (int)pView->m_illuminantRange.steps * sizeof(icFloatNumber);
      m_pViewingConditions->m_illuminant = (icFloatNumber*)malloc(n);
      memcpy(m_pViewingConditions->m_illuminant, pView->m_illuminant, n);
    }

    pProfile->calcNormIlluminantXYZ(m_illuminantXYZ, this);
    m_bValidMediaXYZ = pProfile->calcMediaWhiteXYZ(m_mediaXYZ, this);
    
  }
  else {
    m_pPCC = NULL;
    m_pViewingConditions = NULL;
    m_bValidMediaXYZ = false;
  }
}

CIccCombinedConnectionConditions::~CIccCombinedConnectionConditions()
{
  if (m_pViewingConditions)
    delete m_pViewingConditions;
}

const CIccTagSpectralViewingConditions *CIccCombinedConnectionConditions::getPccViewingConditions()
{
  if (m_pViewingConditions)
    return m_pViewingConditions;
  if (m_pPCC)
    return m_pPCC->getPccViewingConditions();
  return NULL;
}

CIccTagMultiProcessElement *CIccCombinedConnectionConditions::getCustomToStandardPcc()
{
  if (m_pPCC)
    return m_pPCC->getCustomToStandardPcc();
  return NULL;
}

CIccTagMultiProcessElement *CIccCombinedConnectionConditions::getStandardToCustomPcc()
{
  if (m_pPCC)
    return m_pPCC->getStandardToCustomPcc();
  return NULL;
}

void CIccCombinedConnectionConditions::getNormIlluminantXYZ(icFloatNumber *pXYZ)
{
  memcpy(pXYZ, m_illuminantXYZ, 3*sizeof(icFloatNumber));
}

bool CIccCombinedConnectionConditions::getMediaWhiteXYZ(icFloatNumber *pXYZ)
{
  if (m_pPCC || m_pViewingConditions) {
    memcpy(pXYZ, m_mediaXYZ, 3*sizeof(icFloatNumber));
    return m_bValidMediaXYZ;
  }
  return false;
}
