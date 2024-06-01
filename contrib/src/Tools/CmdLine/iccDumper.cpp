/*!
 *  @file iccDumper.cpp
 *  @brief ICC Profile Dumper
 *  @author David Hoyt
 *  @date 01 JUN 2024
 *  @version 1.0.5
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 *  @section CHANGES
 *  - 01/06/2024, h02332: Initial commit
 *
 *  @section ROADMAP
 *  - FIX: Tools/CmdLine/IccDumpProfile/iccDumpProfile.cpp:398:41 Implicit conversion loses integer precision: 'long' to 'int'
 *  - FIX: Tools/CmdLine/IccDumpProfile/iccDumpProfile.cpp:403:66 Implicit conversion loses integer precision: 'long' to 'int'
 *
 *   ./iccDumpProfile [-v verbosity] profile.icc [tagId to dump/ALL]
 */
#pragma mark - Headers

/*!
* @brief Core and external libraries necessary for the fuzzer functionality.
*
* @details This section includes the necessary headers
*/
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


/// @name DumpTag
/// @{
/*!
 ******************************************************************************
 * @brief   Dumps detailed information about a specified ICC tag.
 *
 * @details This function finds a tag in the given ICC profile and logs its
 *          contents, type, description, raw content, and length of the
 *          description. If the tag is not found, it logs an appropriate
 *          message.
 *
 * @param[in] pIcc        Pointer to the ICC profile object.
 * @param[in] sig         The signature of the tag to be dumped.
 * @param[in] nVerboseness The level of verbosity for logging the tag's
 *                         description.
 ******************************************************************************
 */
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

        // Assuming Describe method fills the contents string with a description of the tag
        pTag->Describe(contents, nVerboseness);
        printf("Tag Description: \n%s\n", contents.c_str());

        // Logging the raw content of the tag
        printf("Raw Tag Content:\n");
        fwrite(contents.c_str(), contents.length(), 1, stdout);

        // Log the length of the tag description
        printf("\nTag description length: %zu bytes\n", contents.length());
    }
    else {
        printf("Tag (%s) not found in profile\n", icGetSig(buf, sig));
    }
}
/// @}


/// @name main
/// @{
/*!
 ******************************************************************************
 * @brief   Main function to dump ICC profile information.
 *
 * @details This function processes command-line arguments to read and dump
 *          detailed information about ICC profiles, including optional tag
 *          details. Supports memory leak checking on specific platforms.
 *
 * @param[in] argc  Number of command-line arguments.
 * @param[in] argv  Array of command-line argument strings.
 *
 * @return 0 on success, -1 on failure.
 ******************************************************************************
 */
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
    printf("Usage: iccDumper {-v} {int} profile {tagId to dump/\"ALL\"}\n");
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
    char buf[256];

    printf("Profile:            '%s'\n", argv[nArg]);
    if(Fmt.IsProfileIDCalculated(&pHdr->profileID))
      printf("Profile ID:         %s\n", Fmt.GetProfileID(&pHdr->profileID));
    else
        printf("Profile ID:         Profile ID not calculated.\n");

    printf("Size:               %d (0x%x) bytes\n", pHdr->size, pHdr->size);

    printf("\nHeader\n");
    printf("------\n");
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
    if (pHdr->version >= 5 && pHdr->deviceSubClass) {
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
    } else {
        printf("Spectral PCS Range: Not Defined\n");
    }

    if (pHdr->biSpectralRange.start || pHdr->biSpectralRange.end || pHdr->biSpectralRange.steps) {
        printf("BiSpectral Range:     start=%.1fnm, end=%.1fnm, steps=%d\n",
               icF16toF(pHdr->biSpectralRange.start),
               icF16toF(pHdr->biSpectralRange.end),
               pHdr->biSpectralRange.steps);
    } else {
        printf("BiSpectral Range:   Not Defined\n");
    }

    if (pHdr->mcs) {
        printf("MCS Color Space:    %s\n", Fmt.GetColorSpaceSigName((icColorSpaceSignature)pHdr->mcs));
    } else {
        printf("MCS Color Space:    Not Defined\n");
    }

    printf("\nProfile Tags\n");
    printf("------------\n");

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
            snprintf(str, sizeof(str), "Tag %s (offset %d, size %d) ends beyond EOF.\n",
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
            snprintf(str, sizeof(str), "Tag %s (offset %d, size %d) overlaps with following tag data starting at offset %d.\n",
                     Fmt.GetTagSigName(i->TagInfo.sig), i->TagInfo.offset, i->TagInfo.size, closest);

            sReport += str;
            nStatus = icMaxStatus(nStatus, icValidateWarning);
        }

        // Check for gaps between tag data (accounting for 4-byte alignment)
        if (closest > (int)i->TagInfo.offset + rndup) {
          sReport += icMsgValidateWarning;
            snprintf(str, sizeof(str), "Tag %s (size %d) is followed by %d unnecessary additional bytes (from offset %d).\n",
                     Fmt.GetTagSigName(i->TagInfo.sig), i->TagInfo.size, closest-(i->TagInfo.offset+rndup), (i->TagInfo.offset+rndup));
          sReport += str;
          nStatus = icMaxStatus(nStatus, icValidateWarning);
        }
      }

      // Clause 7.2.1, bullet (b): "the first set of tagged element data shall immediately follow the tag table"
      // 1st tag offset should be = Header (128) + Tag Count (4) + Tag Table (n*12)
      if ((n > 0) && (smallest_offset > 128 + 4 + (n * 12))) {
        sReport += icMsgValidateNonCompliant;
          snprintf(str, sizeof(str), "First tag data is at offset %d rather than immediately after tag table (offset %d).\n",
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
/// @}
