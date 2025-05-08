/*
    File:       iccRoundTrip.cpp

    Contains:   Console app to parse and display profile round-trip statistics

    Version:    V1

    Copyright:  (c) see below
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
// -Initial implementation by Max Derhak 10-1-2007
// - Modified for Debugging Q1/2025 by David Hoyt
//////////////////////////////////////////////////////////////////////
#include <cstdio>
#include <cstring>
#include <stdio.h>
#include <math.h>
#include "IccUtil.h"
#include "IccEval.h"
#include "IccPrmg.h"
#include "IccProfLibVer.h"
#include "IccProfLibVer.h"
#include "IccSignatureUtils.h"

// -----------------------------------------------------------------------------
// MEMORY LEAK CHECKING (Optional)
// Define MEMORY_LEAK_CHECK to enable debug-time allocation tracking.
//
// On Windows (MSVC): Uses CRT leak detection (_CrtSetDbgFlag)
// On Linux (glibc):  Hooks via mcheck()
// -----------------------------------------------------------------------------
#define MEMORY_LEAK_CHECK

#if defined(_WIN32) || defined(WIN32)
  #include <crtdbg.h>
  static void EnableMemoryLeakChecking()
  {
    int dbgFlags = _CrtSetDbgFlag(_CRTDBG_REPORT_FLAG);
    dbgFlags |= _CRTDBG_ALLOC_MEM_DF;
    dbgFlags |= _CRTDBG_LEAK_CHECK_DF;
    _CrtSetDbgFlag(dbgFlags);
  }
#elif defined(__GLIBC__)
  #include <mcheck.h>
  static void EnableMemoryLeakChecking()
  {
    mcheck(NULL);  // Enable glibc memory tracking
  }
#else
  static void EnableMemoryLeakChecking() {}  // Stub for non-supported platforms
#endif

static bool IsRoundTripable(CIccProfile *pIcc)
{
  printf("Up and Running.....\n");
  icHeader *pHdr = &pIcc->m_Header;
  ICC_LOG_INFO("IsRoundTripable(): Checking profile with deviceClass=0x%08x", pHdr->deviceClass);

  if (pHdr->deviceClass == icSigLinkClass) {
    ICC_LOG_INFO("IsRoundTripable(): Profile is DeviceLink. Not roundtripable.");
    return false;
  }

  bool hasAToB0 = pIcc->FindTag(icSigAToB0Tag) != nullptr;
  bool hasBToA0 = pIcc->FindTag(icSigBToA0Tag) != nullptr;
  bool hasAToB1 = pIcc->FindTag(icSigAToB1Tag) != nullptr;
  bool hasBToA1 = pIcc->FindTag(icSigBToA1Tag) != nullptr;
  bool hasAToB2 = pIcc->FindTag(icSigAToB2Tag) != nullptr;
  bool hasBToA2 = pIcc->FindTag(icSigBToA2Tag) != nullptr;

  bool hasDToB0 = pIcc->FindTag(icSigDToB0Tag) != nullptr;
  bool hasBToD0 = pIcc->FindTag(icSigBToD0Tag) != nullptr;
  bool hasDToB1 = pIcc->FindTag(icSigDToB1Tag) != nullptr;
  bool hasBToD1 = pIcc->FindTag(icSigBToD1Tag) != nullptr;
  bool hasDToB2 = pIcc->FindTag(icSigDToB2Tag) != nullptr;
  bool hasBToD2 = pIcc->FindTag(icSigBToD2Tag) != nullptr;

  bool hasMatrix =
    pIcc->FindTag(icSigRedMatrixColumnTag) &&
    pIcc->FindTag(icSigGreenMatrixColumnTag) &&
    pIcc->FindTag(icSigBlueMatrixColumnTag) &&
    pIcc->FindTag(icSigRedTRCTag) &&
    pIcc->FindTag(icSigGreenTRCTag) &&
    pIcc->FindTag(icSigBlueTRCTag);

  ICC_LOG_INFO("Tag pairs found: AToB0/BToA0=%d, AToB1/BToA1=%d, AToB2/BToA2=%d",
               hasAToB0 && hasBToA0, hasAToB1 && hasBToA1, hasAToB2 && hasBToA2);
  ICC_LOG_INFO("Tag pairs found: DToB0/BToD0=%d, DToB1/BToD1=%d, DToB2/BToD2=%d",
               hasDToB0 && hasBToD0, hasDToB1 && hasBToD1, hasDToB2 && hasBToD2);
  ICC_LOG_INFO("Matrix/TRC tags present: %d", hasMatrix);

  if ((hasAToB0 && hasBToA0) ||
      (hasAToB1 && hasBToA1) ||
      (hasAToB2 && hasBToA2) ||
      (hasDToB0 && hasBToD0) ||
      (hasDToB1 && hasBToD1) ||
      (hasDToB2 && hasBToD2) ||
      hasMatrix) {
    ICC_LOG_INFO("IsRoundTripable(): Profile meets round-trip conditions.");
    return true;
  }

  ICC_LOG_INFO("IsRoundTripable(): No qualifying tag pairs found.");
  return false;
}


class CIccMinMaxEval : public CIccEvalCompare
{
public:
  CIccMinMaxEval();

  void Compare(icFloatNumber *pixel, icFloatNumber *deviceLab, icFloatNumber *lab1, icFloatNumber *lab2);

  icFloatNumber GetMean1() { return sum1 / num1; }
  icFloatNumber GetMean2() { return sum2 / num2; }

  icFloatNumber minDE1, minDE2;
  icFloatNumber maxDE1, maxDE2;
  icUInt32Number num3, m_nTotal;

  icFloatNumber maxLab1[3], maxLab2[3];

protected:

  icFloatNumber sum1, sum2;
  icFloatNumber num1, num2;
};

CIccMinMaxEval::CIccMinMaxEval()
{
  minDE1 = minDE2 = 10000;
  maxDE1 = maxDE2 = -1;
  sum1 = sum2 = 0;
  num1 = num2 = 0.0;
  num3 = m_nTotal = 0;

  memset(&maxLab1[0], 0, sizeof(maxLab1));
  memset(&maxLab2[0], 0, sizeof(maxLab2));
}

void CIccMinMaxEval::Compare(icFloatNumber *pixel, icFloatNumber *deviceLab, icFloatNumber *lab1, icFloatNumber *lab2)
{
  icFloatNumber DE1 = icDeltaE(deviceLab, lab1);
  icFloatNumber DE2 = icDeltaE(lab1, lab2);

  if (DE1<minDE1) {
    minDE1 = DE1;
  }

  if (DE1>maxDE1) {
    maxDE1 = DE1;
    memcpy(&maxLab1[0], deviceLab, sizeof(maxLab1));
  }

  if (DE2<minDE2) {
    minDE2 = DE2;
  }

  if (DE2>maxDE2) {
    maxDE2 = DE2;
    memcpy(&maxLab2[0], deviceLab, sizeof(maxLab2));
  }

  if(DE2 <= 1.0)
    num3 += 1;

  sum1 += DE1;
  num1 += 1.0;

  sum2 += DE2;
  num2 += 1.0;

  m_nTotal += 1;
}



int main(int argc, char* argv[])
{
  if (argc <= 1) {
    printf("Usage: iccRoundTrip profile {rendering_intent=1 {use_mpe=0}}\n");
    printf("Built with IccProfLib version " ICCPROFLIBVER "\n");
    printf("  where rendering_intent is (0=perceptual, 1=relative, 2=saturation, 3=absolute)\n");
    return -1;
  }

  const char* profilePath = argv[1];
  icRenderingIntent nIntent = icRelativeColorimetric;
  int nUseMPE = 0;

  if (argc > 2) {
    nIntent = static_cast<icRenderingIntent>(atoi(argv[2]));
    if (argc > 3) {
      nUseMPE = atoi(argv[3]);
    }
  }

  CIccMinMaxEval eval;
  icStatusCMM stat = eval.EvaluateProfile(profilePath, 0, nIntent, icInterpLinear, (nUseMPE != 0));
  if (stat != icCmmStatOk) {
    fprintf(stderr, "❌ Unable to perform round trip on '%s'\n", profilePath);
    return -1;
  }

  CIccPRMG prmg;
  stat = prmg.EvaluateProfile(profilePath, nIntent, icInterpLinear, (nUseMPE != 0));
  if (stat != icCmmStatOk) {
    fprintf(stderr, "❌ Unable to perform PRMG analysis on '%s'\n", profilePath);
    return -1;
  }

  CIccInfo info;
  printf("Profile:          '%s'\n", profilePath);
  printf("Rendering Intent: %s\n", info.GetRenderingIntentName(nIntent));
  printf("Specified Gamut:  %s\n", prmg.m_bPrmgImplied ? "Perceptual Reference Medium Gamut" : "Not Specified");

  printf("\nRound Trip 1\n");
  printf(  "------------\n");
  printf("Min DeltaE:    %8.2" ICFLOATSFX "\n", eval.minDE1);
  printf("Mean DeltaE:   %8.2" ICFLOATSFX "\n", eval.GetMean1());
  printf("Max DeltaE:    %8.2" ICFLOATSFX "\n\n", eval.maxDE1);
  printf("Max L, a, b:   " ICFLOATFMT ", " ICFLOATFMT ", " ICFLOATFMT "\n", eval.maxLab1[0], eval.maxLab1[1], eval.maxLab1[2]);

  printf("\nRound Trip 2\n");
  printf(  "------------\n");
  printf("Min DeltaE:    %8.2" ICFLOATSFX "\n", eval.minDE2);
  printf("Mean DeltaE:   %8.2" ICFLOATSFX "\n", eval.GetMean2());
  printf("Max DeltaE:    %8.2" ICFLOATSFX "\n\n", eval.maxDE2);
  printf("Max L, a, b:   " ICFLOATFMT ", " ICFLOATFMT ", " ICFLOATFMT "\n", eval.maxLab2[0], eval.maxLab2[1], eval.maxLab2[2]);

  if (prmg.m_nTotal) {
    printf("\nPRMG Interoperability - Round Trip Results\n");
    printf(  "------------------------------------------------------\n");
    printf("DE <= 1.0 (%8u): %5.1f%%\n", prmg.m_nDE1, (float)prmg.m_nDE1 / prmg.m_nTotal * 100.0f); 
    printf("DE <= 2.0 (%8u): %5.1f%%\n", prmg.m_nDE2, (float)prmg.m_nDE2 / prmg.m_nTotal * 100.0f);
    printf("DE <= 3.0 (%8u): %5.1f%%\n", prmg.m_nDE3, (float)prmg.m_nDE3 / prmg.m_nTotal * 100.0f);
    printf("DE <= 5.0 (%8u): %5.1f%%\n", prmg.m_nDE5, (float)prmg.m_nDE5 / prmg.m_nTotal * 100.0f);
    printf("DE <=10.0 (%8u): %5.1f%%\n", prmg.m_nDE10, (float)prmg.m_nDE10 / prmg.m_nTotal * 100.0f);
    printf("Total     (%8u)\n", prmg.m_nTotal);
  }

  return 0;
}
