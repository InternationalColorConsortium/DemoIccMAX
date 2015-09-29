/*
    File:       CmdDumpProfile.cpp

    Contains:   Console app to parse and display profile contents

    Version:    V1

    Copyright:  © see below
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


#include <stdio.h>
#include <cstring>
#include "IccProfile.h"
#include "IccTag.h"
#include "IccUtil.h"

void DumpTag(CIccProfile *pIcc, icTagSignature sig)
{
  CIccTag *pTag = pIcc->FindTag(sig);
  char buf[64];
  CIccInfo Fmt;

  std::string contents;

  if (pTag) {
    printf("\nContents of %s tag (%s)\n", Fmt.GetTagSigName(sig), icGetSig(buf, sig)); 
    printf("Type:   ");
    if (pTag->IsArrayType()) {
      printf("Array of ");
    }
    printf("%s\n", Fmt.GetTagTypeSigName(pTag->GetType()));
    pTag->Describe(contents);
    fwrite(contents.c_str(), contents.length(), 1, stdout);
  }
  else {
    printf("Tag (%s) not found in profile\n", icGetSig(buf, sig));
  }
}

int main(int argc, char* argv[])
{
  int nArg = 1;

  if (argc<=1) {
print_usage:
    printf("Usage: iccDumpProfile profile {tagId to dump/\"ALL\")\n");
    return -1;
  }

  CIccProfile *pIcc;
  std::string sReport;
  icValidateStatus nStatus;

  if (!strncmp(argv[1], "-V", 2) || !strncmp(argv[1], "-v", 2)) {
    if (argc<=2)
      goto print_usage;

    nArg = 2;

    pIcc = ValidateIccProfile(argv[nArg], sReport, nStatus);
  }
  else
    pIcc = OpenIccProfile(argv[nArg]);

  if (!pIcc) {
    printf("Unable to open '%s'\n", argv[nArg]);
  }
  else {
    icHeader *pHdr = &pIcc->m_Header;
    CIccInfo Fmt;
    char buf[64];

    printf("Profile:          '%s'\n", argv[nArg]);
    if(Fmt.IsProfileIDCalculated(&pHdr->profileID))
      printf("Profile ID:        %s\n", Fmt.GetProfileID(&pHdr->profileID));
    else
      printf("Profile ID:       Profile ID not calculated.\n");
    printf("Size:             %d(0x%x) bytes\n", pHdr->size, pHdr->size);

    printf("\nHeader\n");
    printf(  "------\n");
    printf("Attributes:       %s\n", Fmt.GetDeviceAttrName(pHdr->attributes));
    printf("Cmm:              %s\n", Fmt.GetCmmSigName((icCmmSignature)(pHdr->cmmId)));
    printf("Creation Date:    %d/%d/%d  %02u:%02u:%02u\n",
                              pHdr->date.month, pHdr->date.day, pHdr->date.year,
                              pHdr->date.hours, pHdr->date.minutes, pHdr->date.seconds);
    printf("Creator:          %s\n", icGetSig(buf, pHdr->creator));
    printf("Data Color Space: %s\n", Fmt.GetColorSpaceSigName(pHdr->colorSpace));
    printf("Flags             %s\n", Fmt.GetProfileFlagsName(pHdr->flags));
    printf("PCS Color Space:  %s\n", Fmt.GetColorSpaceSigName(pHdr->pcs));
    printf("Platform:         %s\n", Fmt.GetPlatformSigName(pHdr->platform));
    printf("Rendering Intent: %s\n", Fmt.GetRenderingIntentName((icRenderingIntent)(pHdr->renderingIntent)));
    printf("Type:             %s\n", Fmt.GetProfileClassSigName(pHdr->deviceClass));
    printf("Version:          %s\n", Fmt.GetVersionName(pHdr->version));
    printf("Illuminant:       X=%.4lf, Y=%.4lf, Z=%.4lf\n",
                            icFtoD(pHdr->illuminant.X),
                            icFtoD(pHdr->illuminant.Y),
                            icFtoD(pHdr->illuminant.Z));

    printf("\nProfile Tags\n");
    printf(  "------------\n");

    printf("%25s    ID    %8s\t%8s\n", "Tag", "Offset", "Size");
    printf("%25s  ------  %8s\t%8s\n", "----", "------", "----");

    int n;
    TagEntryList::iterator i;

    for (n=0, i=pIcc->m_Tags->begin(); i!=pIcc->m_Tags->end(); i++, n++) {
      printf("%25s  %s  %8d\t%8d\n", Fmt.GetTagSigName(i->TagInfo.sig),
                                   icGetSig(buf, i->TagInfo.sig, false), 
                                   i->TagInfo.offset, i->TagInfo.size);
    }

    if (argc>nArg+1) {
      if (!stricmp(argv[nArg+1], "ALL")) {
        for (n=0, i=pIcc->m_Tags->begin(); i!=pIcc->m_Tags->end(); i++, n++) {
          DumpTag(pIcc, i->TagInfo.sig);
        }
      }
      else {
        DumpTag(pIcc, (icTagSignature)icGetSigVal(argv[nArg+1]));
      }
    }
  }

  if (nArg>1) {
    printf("\nValidation Report\n");
    printf(  "-----------------\n");
    switch (nStatus) {
    case icValidateOK:
      printf("Profile is valid\n\n");
      break;
    case icValidateWarning:
      printf("Profile has warning(s)\n\n");
      break;
    case icValidateNonCompliant:
      printf("Profile violates ICC specification\n\n");
      break;
    case icValidateCriticalError:
      printf("Profile has Critical Error(s) that violate ICC specificaiton.\n\n");
      break;
    default:
      printf("Profile has unknown status.\n\n");
      break;
    }
    fwrite(sReport.c_str(), sReport.length(), 1, stdout);
  }

  delete pIcc;
  return 0;
}

