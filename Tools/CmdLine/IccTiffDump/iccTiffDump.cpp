/*
    File:       iccTiffDump.cpp

    Contains:   Console app display info about Tiff file and its ICC profile

    Version:    V1

    Copyright:  (c) see below
*/

/*
 * The ICC Software License, Version 0.2
 *
 *
 * Copyright (c) 2003-2010 The International Color Consortium. All rights 
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
#include "IccCmm.h"
#include "IccUtil.h"
#include "IccDefs.h"
#include "IccApplyBPC.h"
#include "TiffImg.h"


typedef struct {
  unsigned long nId;
  char const * const szName;
} IdList;
#define UNKNOWNID 0xffffffff


IdList planar_types[] = {
  {0,  "Interleaved samples"},
  {PLANARCONFIG_CONTIG,  "Interleaved samples"},
  {PLANARCONFIG_SEPARATE,     "Samples in separate planes"},

  {UNKNOWNID, "Unknown"},
};

IdList photo_types[] = {
  {PHOTO_MINISWHITE, "Min Is White"},
  {PHOTO_MINISBLACK, "Min Is Black"},
  {PHOTO_CIELAB, "CIELab"},
  {PHOTO_ICCLAB, "IccLab"},

  {UNKNOWNID, "Unknown"},
};

IdList compression_types[] = {
  {COMPRESSION_NONE,   "None"},
  {COMPRESSION_LZW,    "LZW"},
  {COMPRESSION_JPEG,   "JPEG"},
  {COMPRESSION_DEFLATE, "Deflate"},
  {COMPRESSION_ADOBE_DEFLATE, "Deflate"},

  {UNKNOWNID, "Unknown"},
};

const char* GetId(unsigned long nId, IdList* pIdList)
{
  for (;pIdList->nId != nId && pIdList->nId != UNKNOWNID; pIdList++);

  return pIdList->szName;
}


void Usage() 
{
  printf("Usage: iccTiffDump tiff_file {exported_icc_file}\n\n");
}

//===================================================

int main(int argc, icChar* argv[])
{
  int minargs = 1; // minimum number of arguments
  if(argc<=minargs) {
    Usage();
    return -1;
  }

  CTiffImg SrcImg;

  if (!SrcImg.Open(argv[1])) {
    printf("\nFile [%s] cannot be opened.\n", argv[1]);
    return false;
  }

  printf("-------------------->Tiff Image Dump<---------------------------\n");
  printf("Filename:          %s\n", argv[1]);
  printf("Size:              (%d x %d) pixels, (%.2lf\" x %.2lf\")\n",
    SrcImg.GetWidth(), SrcImg.GetHeight(),
    SrcImg.GetWidthIn(), SrcImg.GetHeightIn());
  printf("Planar:            %s\n", GetId(SrcImg.GetPlanar(), planar_types));
  printf("BitsPerSample:     %d\n", SrcImg.GetBitsPerSample());
  printf("SamplesPerPixel:   %d\n", SrcImg.GetSamples());
  int nExtra = SrcImg.GetExtraSamples();
  if (nExtra)
    printf("ExtraSamples       %d\n", nExtra);
  printf("Photometric:       %s\n", GetId(SrcImg.GetPhoto(), photo_types));
  printf("BytesPerLine:      %d\n", SrcImg.GetBytesPerLine());

  printf("Resolution:        (%lf x %lf) pixels per/inch\n", SrcImg.GetXRes(), SrcImg.GetYRes());
  printf("Compression:       %s\n", GetId(SrcImg.GetCompress(), compression_types));

  unsigned char *pProfMem;
  unsigned int nLen;
  if (SrcImg.GetIccProfile(pProfMem, nLen)) {
    printf("Profile:           Embedded\n");

    CIccProfile *pProfile = OpenIccProfile(pProfMem, nLen);

    if (pProfile) {
      icHeader *pHdr = &pProfile->m_Header;
      CIccInfo Fmt;

      if (pHdr->colorSpace)
        printf(" Color Space:      %s\n", Fmt.GetColorSpaceSigName(pHdr->colorSpace));
      if (pHdr->pcs)
        printf(" Colorimetric PCS: %s\n", Fmt.GetColorSpaceSigName(pHdr->pcs));
      if (pHdr->spectralPCS) {
        printf(" Spectral PCS:     %s\n", Fmt.GetSpectralColorSigName(pHdr->spectralPCS));
        if (pHdr->spectralRange.start || pHdr->spectralRange.end || pHdr->spectralRange.steps) {
          printf(" Spectral Range:   start=%.1fnm, end=%.1fnm, steps=%d\n",
            icF16toF(pHdr->spectralRange.start),
            icF16toF(pHdr->spectralRange.end),
            pHdr->spectralRange.steps);
        }
        if (pHdr->biSpectralRange.start || pHdr->biSpectralRange.end || pHdr->biSpectralRange.steps) {
          printf(" BiSpectral Range: start=%.1fnm, end=%.1fnm, steps=%d\n",
            icF16toF(pHdr->biSpectralRange.start),
            icF16toF(pHdr->biSpectralRange.end),
            pHdr->biSpectralRange.steps);
        }
      }
      CIccTag *pDesc = pProfile->FindTag(icSigProfileDescriptionTag);
      if (pDesc->GetType()==icSigTextDescriptionType) {
        CIccTagTextDescription *pText = (CIccTagTextDescription*)pDesc;
        printf(" Description:      %s\n", pText->GetText());
      }
      else if (pDesc->GetType()==icSigMultiLocalizedUnicodeType) {
        CIccTagMultiLocalizedUnicode *pStrs = (CIccTagMultiLocalizedUnicode*)pDesc;
        if (pStrs->m_Strings) {
          CIccMultiLocalizedUnicode::iterator text = pStrs->m_Strings->begin();
          if (text != pStrs->m_Strings->end()) {
            char line[256];
            printf(" Description:      %s\n", text->GetAnsi(line, sizeof(line)-1));
          }
        }
      }
    }
  }
  else {
    printf("Profile:           Embedded\n");
  }

  SrcImg.Close();
  return 0;
}

