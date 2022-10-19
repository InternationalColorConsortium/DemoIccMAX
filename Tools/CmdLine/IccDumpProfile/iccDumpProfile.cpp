/*
    File:       CmdDumpProfile.cpp

    Contains:   Console app to parse and display profile contents

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
// -Initial implementation by Max Derhak 5-15-2003
// -Validation improvements by Peter Wyatt 2021
//
//////////////////////////////////////////////////////////////////////


#include <stdio.h>
#include <cstring>
#include "IccProfile.h"
#include "IccTag.h"
#include "IccUtil.h"
#include "IccProfLibVer.h"

// #define MEMORY_LEAK_CHECK to enable C RTL memory leak checking (slow!)
#define MEMORY_LEAK_CHECK

#if defined(_WIN32) || defined(WIN32)
#include <crtdbg.h>
#elif __GLIBC__
#include <mcheck.h>
#endif


void DumpTag(CIccProfile *pIcc, icTagSignature sig, int nVerboseness)
{
  CIccTag *pTag = pIcc->FindTag(sig);
  char buf[64];
  CIccInfo Fmt;

  std::string contents;

  if (pTag) {
    printf("\nContents of %s tag (%s)\n", Fmt.GetTagSigName(sig), icGetSig(buf, sig));
    printf("Type: ");
    if (pTag->IsArrayType()) {
      printf("Array of ");
    }
    printf("%s (%s)\n", Fmt.GetTagTypeSigName(pTag->GetType()), icGetSig(buf, pTag->GetType()));
    pTag->Describe(contents, nVerboseness);
    fwrite(contents.c_str(), contents.length(), 1, stdout);
  }
  else {
    printf("Tag (%s) not found in profile\n", icGetSig(buf, sig));
  }
}

int main(int argc, char* argv[])
{
#if defined(MEMORY_LEAK_CHECK) && defined(_DEBUG)
#if defined(WIN32) || defined(_WIN32)
#if 0
  // Suppress windows dialogs for assertions and errors - send to stderr instead during batch CLI processing
  _CrtSetReportMode(_CRT_ERROR, _CRTDBG_MODE_FILE);
  _CrtSetReportFile(_CRT_ERROR, _CRTDBG_FILE_STDERR);
  _CrtSetReportMode(_CRT_ASSERT, _CRTDBG_MODE_FILE);
  _CrtSetReportFile(_CRT_ASSERT, _CRTDBG_FILE_STDERR);
#endif
  int tmp = _CrtSetDbgFlag(_CRTDBG_REPORT_FLAG);
  tmp = tmp | _CRTDBG_LEAK_CHECK_DF | _CRTDBG_ALLOC_MEM_DF; // | _CRTDBG_CHECK_ALWAYS_DF;
  _CrtSetDbgFlag(tmp);
  //_CrtSetBreakAlloc(1163);
#elif __GLIBC__
  mcheck(NULL);
#endif // WIN32
#endif // MEMORY_LEAK_CHECK && _DEBUG

  int nArg = 1;
  long int verbosity = 100; // default is maximum verbosity (old behaviour)

  if (argc <= 1) {
print_usage:
    printf("Usage: iccDumpProfile {-v} {int} profile {tagId to dump/\"ALL\"}\n");
    printf("Built with IccProfLib version " ICCPROFLIBVER "\n");
    printf("\nThe -v option causes profile validation to be performed."
           "\nThe optional integer parameter specifies verboseness of output (1-100, default=100).\n");
    printf("iccDumpProfile built with IccProfLib version " ICCPROFLIBVER "\n\n");

    return -1;
  }

  CIccProfile *pIcc;
  std::string sReport;
  icValidateStatus nStatus = icValidateOK;
  bool bDumpValidation = false;

  if (!strncmp(argv[1], "-V", 2) || !strncmp(argv[1], "-v", 2)) {
    nArg++;
    if (argc <= nArg)
      goto print_usage;

    // support case where ICC filename starts with an integer: e.g. "123.icc"
    char *endptr = nullptr;
    verbosity = strtol(argv[nArg], &endptr, 10);
    if ((verbosity != 0L) && (errno != ERANGE) && ((endptr == nullptr) || (*endptr == '\0'))) {
      // clamp verbosity to 1-100 inclusive
      if (verbosity < 0)
        verbosity = 1;
      else if (verbosity > 100)
        verbosity = 100;
      nArg++;
      if (argc <= nArg)
        goto print_usage;
    }
    else if (argv[nArg] == endptr) {
        verbosity = 100;
    }

    pIcc = ValidateIccProfile(argv[nArg], sReport, nStatus);
    bDumpValidation = true;
  }
  else {
    // support case where ICC filename starts with an integer: e.g. "123.icc"
    char* endptr = nullptr;
    verbosity = strtol(argv[nArg], &endptr, 10);
    if ((verbosity != 0L) && (errno != ERANGE) && ((endptr == nullptr) || (*endptr == '\0'))) {
      // clamp verbosity to 1-100 inclusive
      if (verbosity < 0)
        verbosity = 1;
      else if (verbosity > 100)
        verbosity = 100;
      nArg++;
      if (argc <= nArg)
        goto print_usage;
    }

    pIcc = OpenIccProfile(argv[nArg]);
  }

  CIccInfo Fmt;
  icHeader* pHdr = NULL;

  // Precondition: nArg is argument of ICC profile filename
  printf("Built with IccProfLib version " ICCPROFLIBVER "\n\n");
  if (!pIcc) {
    printf("Unable to parse '%s' as ICC profile!\n", argv[nArg]);
    nStatus = icValidateCriticalError;
  }
  else {
    pHdr = &pIcc->m_Header;
    char buf[64];

    printf("Profile:            '%s'\n", argv[nArg]);
    if(Fmt.IsProfileIDCalculated(&pHdr->profileID))
      printf("Profile ID:         %s\n", Fmt.GetProfileID(&pHdr->profileID));
    else
      printf("Profile ID:         Profile ID not calculated.\n");
    printf("Size:               %d (0x%x) bytes\n", pHdr->size, pHdr->size);

    printf("\nHeader\n");
    printf(  "------\n");
    printf("Attributes:         %s\n", Fmt.GetDeviceAttrName(pHdr->attributes));
    printf("Cmm:                %s\n", Fmt.GetCmmSigName((icCmmSignature)(pHdr->cmmId)));
    printf("Creation Date:      %d/%d/%d (M/D/Y)  %02u:%02u:%02u\n",
                               pHdr->date.month, pHdr->date.day, pHdr->date.year,
                               pHdr->date.hours, pHdr->date.minutes, pHdr->date.seconds);
    printf("Creator:            %s\n", icGetSig(buf, pHdr->creator));
    printf("Device Manufacturer:%s\n", icGetSig(buf, pHdr->manufacturer));
    printf("Data Color Space:   %s\n", Fmt.GetColorSpaceSigName(pHdr->colorSpace));
    printf("Flags:              %s\n", Fmt.GetProfileFlagsName(pHdr->flags));
    printf("PCS Color Space:    %s\n", Fmt.GetColorSpaceSigName(pHdr->pcs));
    printf("Platform:           %s\n", Fmt.GetPlatformSigName(pHdr->platform));
    printf("Rendering Intent:   %s\n", Fmt.GetRenderingIntentName((icRenderingIntent)(pHdr->renderingIntent)));
    printf("Profile Class:      %s\n", Fmt.GetProfileClassSigName(pHdr->deviceClass));
    if (pHdr->deviceSubClass)
      printf("Profile SubClass:   %s\n", icGetSig(buf, pHdr->deviceSubClass));
    else
      printf("Profile SubClass:   Not Defined\n");
    printf("Version:            %s\n", Fmt.GetVersionName(pHdr->version));
    if (pHdr->version >= icVersionNumberV5 && pHdr->deviceSubClass) {
      printf("SubClass Version:   %s\n", Fmt.GetSubClassVersionName(pHdr->version));
    }
    printf("Illuminant:         X=%.4lf, Y=%.4lf, Z=%.4lf\n",
                                icFtoD(pHdr->illuminant.X),
                                icFtoD(pHdr->illuminant.Y),
                                icFtoD(pHdr->illuminant.Z));
    printf("Spectral PCS:       %s\n", Fmt.GetSpectralColorSigName(pHdr->spectralPCS));
    if (pHdr->spectralRange.start || pHdr->spectralRange.end || pHdr->spectralRange.steps) {
      printf("Spectral PCS Range: start=%.1fnm, end=%.1fnm, steps=%d\n",
             icF16toF(pHdr->spectralRange.start),
             icF16toF(pHdr->spectralRange.end),
             pHdr->spectralRange.steps);
    }
    else {
      printf("Spectral PCS Range: Not Defined\n");
    }

    if (pHdr->biSpectralRange.start || pHdr->biSpectralRange.end || pHdr->biSpectralRange.steps) {
      printf("BiSpectral Range:     start=%.1fnm, end=%.1fnm, steps=%d\n",
        icF16toF(pHdr->biSpectralRange.start),
        icF16toF(pHdr->biSpectralRange.end),
        pHdr->biSpectralRange.steps);
    }
    else {
      printf("BiSpectral Range:   Not Defined\n");
    }

    if (pHdr->mcs) {
      printf("MCS Color Space:    %s\n", Fmt.GetColorSpaceSigName((icColorSpaceSignature)pHdr->mcs));
    }
    else {
      printf("MCS Color Space:    Not Defined\n");
    }

    printf("\nProfile Tags\n");
    printf(  "------------\n");

    printf("%28s    ID    %8s\t%8s\t%8s\n", "Tag",  "Offset", "Size", "Pad");
    printf("%28s  ------  %8s\t%8s\t%8s\n", "----", "------", "----", "---");

    int n, closest, pad;
    TagEntryList::iterator i, j;

    // n is number of Tags in Tag Table
    for (n=0, i=pIcc->m_Tags->begin(); i!=pIcc->m_Tags->end(); i++, n++) {
        // Find closest tag after this tag, by scanning all offsets of other tags
        closest = pHdr->size;
        for (j = pIcc->m_Tags->begin(); j != pIcc->m_Tags->end(); j++) {
            if ((i != j) && (j->TagInfo.offset >= i->TagInfo.offset + i->TagInfo.size) && ((int)j->TagInfo.offset <= closest)) {
                closest = j->TagInfo.offset;
            }
        }
        // Number of actual padding bytes between this tag and closest neighbour (or EOF)
        // Should be 0-3 if compliant. Negative number if tags overlap!
        pad = closest - i->TagInfo.offset - i->TagInfo.size;

        printf("%28s  %s  %8d\t%8d\t%8d\n", Fmt.GetTagSigName(i->TagInfo.sig),
            icGetSig(buf, i->TagInfo.sig, false), i->TagInfo.offset, i->TagInfo.size, pad);
    }

    printf("\n");

    // Report all duplicated tags in the tag index
    // Both ICC.1 and ICC.2 are silent on what should happen for this but report as a warning!!!
    int m;
    for (n=0, i = pIcc->m_Tags->begin(); i != pIcc->m_Tags->end(); i++, n++)
        for (m=0, j = pIcc->m_Tags->begin(); j != pIcc->m_Tags->end(); j++, m++)
            if ((i != j) && (i->TagInfo.sig == j->TagInfo.sig)) {
                printf("%28s is duplicated at positions %d and %d!\n", Fmt.GetTagSigName(i->TagInfo.sig), n,  m);
                nStatus = icMaxStatus(nStatus, icValidateWarning);
            }


    // Check additional details if doing detailed validation:
    // - First tag data offset is immediately after the Tag Table
    // - Tag data offsets are all 4-byte aligned
    // - Tag data should be tightly abutted with adjacent tags (or the end of the Tag Table)
    //   (note that tag data can be reused by multiple tags and tags do NOT have to be order)
    // - Last tag also has to be padded and thus file size is always a multiple of 4. See clause
    //   7.2.1, bullet (c) of ICC.1:2010 and ICC.2:2019 specs.
    // - Tag offset + Tag Size should never go beyond EOF
    // - Multiple tags can reuse data and this is NOT reported as it is perfectly valid and
    //   occurs in real-world ICC profiles
    // - Tags with overlapping tag data are considered highly suspect (but officially valid)
    // - 1-3 padding bytes after each tag's data need to be all zero *** NOT DONE - TODO ***
    if (bDumpValidation) {
      char str[256];
      int  rndup, smallest_offset = pHdr->size;

      // File size is required to be a multiple of 4 bytes according to clause 7.2.1 bullet (c):
      // "all tagged element data, including the last, shall be padded by no more than three
      //  following pad bytes to reach a 4 - byte boundary"
      if ((pHdr->version >= icVersionNumberV4_2) && (pHdr->size % 4 != 0)) {
          sReport += icMsgValidateNonCompliant;
          sReport += "File size is not a multiple of 4 bytes (last tag needs padding?).\n";
          nStatus = icMaxStatus(nStatus, icValidateNonCompliant);
      }

      for (i=pIcc->m_Tags->begin(); i!=pIcc->m_Tags->end(); i++) {
        rndup = 4 * ((i->TagInfo.size + 3) / 4); // Round up to a 4-byte aligned size as per ICC spec
        pad = rndup - i->TagInfo.size;           // Optimal smallest number of bytes of padding for this tag (0-3)

        // Is the Tag offset + Tag Size beyond EOF?
        if (i->TagInfo.offset + i->TagInfo.size > pHdr->size) {
            sReport += icMsgValidateNonCompliant;
            sprintf(str, "Tag %s (offset %d, size %d) ends beyond EOF.\n",
                    Fmt.GetTagSigName(i->TagInfo.sig), i->TagInfo.offset, i->TagInfo.size);
            sReport += str;
            nStatus = icMaxStatus(nStatus, icValidateNonCompliant);
        }

        // Is it the first tag data in the file?
        if ((int)i->TagInfo.offset < smallest_offset) {
            smallest_offset = (int)i->TagInfo.offset;
        }

        // Find closest tag after this tag, by scanning all other tag offsets
        closest = pHdr->size;
        for (j=pIcc->m_Tags->begin(); j!=pIcc->m_Tags->end(); j++) {
           if ((i!=j) && (j->TagInfo.offset > i->TagInfo.offset) && ((int)j->TagInfo.offset <= closest)) {
             closest = j->TagInfo.offset;
           }
        }

        // Check if closest tag after this tag is less than offset+size - in which case it overlaps! Ignore last tag.
        if ((closest < (int)i->TagInfo.offset + (int)i->TagInfo.size) && (closest < (int)pHdr->size)) {
            sReport += icMsgValidateWarning;
            sprintf(str, "Tag %s (offset %d, size %d) overlaps with following tag data starting at offset %d.\n",
                Fmt.GetTagSigName(i->TagInfo.sig), i->TagInfo.offset, i->TagInfo.size, closest);
            sReport += str;
            nStatus = icMaxStatus(nStatus, icValidateWarning);
        }

        // Check for gaps between tag data (accounting for 4-byte alignment)
        if (closest > (int)i->TagInfo.offset + rndup) {
          sReport += icMsgValidateWarning;
          sprintf(str, "Tag %s (size %d) is followed by %d unnecessary additional bytes (from offset %d).\n",
                Fmt.GetTagSigName(i->TagInfo.sig), i->TagInfo.size, closest-(i->TagInfo.offset+rndup), (i->TagInfo.offset+rndup));
          sReport += str;
          nStatus = icMaxStatus(nStatus, icValidateWarning);
        }
      }

      // Clause 7.2.1, bullet (b): "the first set of tagged element data shall immediately follow the tag table"
      // 1st tag offset should be = Header (128) + Tag Count (4) + Tag Table (n*12)
      if ((n > 0) && (smallest_offset > 128 + 4 + (n * 12))) {
        sReport += icMsgValidateNonCompliant;
        sprintf(str, "First tag data is at offset %d rather than immediately after tag table (offset %d).\n",
            smallest_offset, 128 + 4 + (n * 12));
        sReport += str;
        nStatus = icMaxStatus(nStatus, icValidateNonCompliant);
      }
    }

    if (argc>nArg+1) {
      if (!stricmp(argv[nArg+1], "ALL")) {
        for (i=pIcc->m_Tags->begin(); i!=pIcc->m_Tags->end(); i++) {
          DumpTag(pIcc, i->TagInfo.sig, verbosity);
        }
      }
      else {
        DumpTag(pIcc, (icTagSignature)icGetSigVal(argv[nArg+1]), verbosity);
      }
    }
  }

  int nValid = 0;

  if (bDumpValidation) {
    printf("\nValidation Report\n");
    printf(  "-----------------\n");
    switch (nStatus) {
    case icValidateOK:
      printf("Profile is valid");
      if (pHdr)
        printf(" for version %s", Fmt.GetVersionName(pHdr->version));
      break;
    case icValidateWarning:
      printf("Profile has warning(s)");
      if (pHdr)
        printf(" for version %s", Fmt.GetVersionName(pHdr->version));
      break;
    case icValidateNonCompliant:
      printf("Profile violates ICC specification");
      if (pHdr)
        printf(" for version %s", Fmt.GetVersionName(pHdr->version));
      break;
    case icValidateCriticalError:
      printf("Profile has Critical Error(s) that violate ICC specification");
      if (pHdr)
        printf(" for version %s", Fmt.GetVersionName(pHdr->version));
      nValid = -1;
      break;
    default:
      printf("Profile has unknown status!");
      nValid = -2;
      break;
    }
  }
  printf("\n\n");

  sReport += "\n";
  fwrite(sReport.c_str(), sReport.length(), 1, stdout);

  delete pIcc;

#if defined(_DEBUG) || defined(DEBUG)
  printf("EXIT %d\n", nValid);
#endif
  return nValid;
}

