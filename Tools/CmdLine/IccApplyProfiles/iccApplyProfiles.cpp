/*
    File:       CmdApplyProfiles.cpp

    Contains:   Console app that applies profiles

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
#include "IccEnvVar.h"
#include "TiffImg.h"

static icFloatNumber UnitClip(icFloatNumber v)
{
  if (v<0.0)
    return 0.0;
  if (v>1.0)
    return 1.0;
  return v;
}


typedef std::list<CIccProfile*> IccProfilePtrList;

void Usage() 
{
  printf("Usage: iccApplyProfiles src_tiff_file dst_tiff_file dst_sample_encoding interpolation dst_compression dst_planar dst_embed_icc {profile_file_path Rendering_intent {-PCC connection_conditions_path}}\n\n");
  printf("  For dst_sample_encoding:\n");
  printf("    0 - Same as src\n");
  printf("    1 - icEncode8Bit\n");
  printf("    2 - icEncode16Bit\n");
  printf("    4 - icEncodeFloat\n\n");

  printf("  For interpolation:\n");
  printf("    0 - Linear\n");
  printf("    1 - Tetrahedral\n\n");

  printf("  For dst_compression:\n");
  printf("    0 - No compression\n");
  printf("    1 - LZW compression\n\n");

  printf("  For dst_planar:\n");
  printf("    0 - Contig\n");
  printf("    1 - Separation\n\n");

  printf("  For dst_embed_icc:\n");
  printf("    0 - Do not Embed\n");
  printf("    1 - Embed Last ICC\n\n");

  printf("  For Rendering_intent:\n");
  printf("    0 - Perceptual\n");
  printf("    1 - Relative Colorimetric\n");
  printf("    2 - Saturation\n");
  printf("    3 - Absolute Colorimetric\n");
  printf("    10 - Perceptual without Spectral/MPE\n");
  printf("    11 - Relative Colorimetric without Spectral/MPE\n");
  printf("    12 - Saturation without Spectral/MPE\n");
  printf("    13 - Absolute Colorimetric without Spectral/MPE \n");
  printf("    20 - Preview Perceptual\n");
  printf("    21 - Preview Relative Colorimetric\n");
  printf("    22 - Preview Saturation\n");
  printf("    23 - Preview Absolute Colorimetric\n");
  printf("    30 - Gamut\n");
  printf("    33 - Gamut Absolute\n");
  printf("    40 - Perceptual with BPC\n");
  printf("    41 - Relative Colorimetric with BPC\n");
  printf("    42 - Saturation with BPC\n");
}

//===================================================

int main(int argc, icChar* argv[])
{
  int minargs = 8; // minimum number of arguments
  if(argc<minargs) {
    Usage();
    return -1;
  }

  int nNumProfiles, temp;
  temp = argc - minargs;

  if(temp%2 != 0) {
    printf("\nMissing arguments!\n");
    Usage();
    return -1;
  }

  nNumProfiles = temp/2;


  unsigned long i, j, k, sn, sphoto, photo, space, bps, dbps;
  CTiffImg SrcImg, DstImg;
  CIccCmm cmm;
  unsigned char *sptr, *dptr;
  bool bSuccess = true;
  bool bConvert = false;
  char *last_path = NULL;

  if (!SrcImg.Open(argv[1])) {
    printf("\nFile [%s] cannot be opened.\n", argv[1]);
    return false;
  }
  sn = SrcImg.GetSamples();
  sphoto = SrcImg.GetPhoto();
  space = cmm.GetSourceSpace();
  bps = SrcImg.GetBitsPerSample();

  icFloatColorEncoding srcEncoding, destEncoding;

  switch(bps) {
    case 8:
      srcEncoding = icEncode8Bit;
      break;
    case 16:
      srcEncoding = icEncode16Bit;
      break;
    case 32:
      srcEncoding = icEncodeFloat;
      break;
    default:
      printf("Source bit depth / color data encoding not recognized.\n");
      return false;
  }


  destEncoding = (icFloatColorEncoding)atoi(argv[3]);
  switch(destEncoding) {
    case 0:
      destEncoding = srcEncoding;
      dbps = bps;
      break;
    case 1:
      destEncoding = icEncode8Bit;
      dbps = 8;
      break;
    case 2:
      destEncoding = icEncode16Bit;
      dbps = 16;
      break;
    case 4:
      destEncoding = icEncodeFloat;
      dbps = 32;
      break;
    default:
      printf("Source color data encoding not recognized.\n");
      return false;
  }
  icXformInterp nInterp = (icXformInterp)atoi(argv[4]);

  bool bCompress = atoi(argv[5])!=0;
  bool bSeparation = atoi(argv[6])!=0;
  bool bEmbed = atoi(argv[7])!=0;

  int nIntent, nType;
  //CIccNamedColorCmm theCmm(icSigUnknownData, icSigUnknownData, true);
  CIccCmm theCmm(icSigUnknownData, icSigUnknownData, true);
  IccProfilePtrList pccList;

  int nCount;
  bool bUseMPE;
  icStatusCMM stat;
  icCmmEnvSigMap sigMap;

  for(i = 0, nCount=minargs; i<nNumProfiles; i++, nCount+=2) {
    if (!strnicmp(argv[nCount], "-ENV:", 5)) {  //check for -ENV: to allow for Cmm Environment variables to be defined for next transform
      icSignature sig = icGetSigVal(argv[nCount]+5);
      icFloatNumber val = (icFloatNumber)atof(argv[nCount+1]);

      sigMap[sig]=val;
    }
    else if (stricmp(argv[nCount], "-PCC")) { //check for -PCC arg to allow for profile connection conditions to be defined
      bUseMPE = true;
      nIntent = atoi(argv[nCount+1]);
      nType = abs(nIntent) / 10;
      nIntent = nIntent % 10;
      CIccProfile *pPccProfile = NULL;

      CIccCreateXformHintManager Hint;

      switch(nType) {
      case 1:
        nType = 0;
        bUseMPE = false;
        break;
      case 4:
        nType = 0;
        Hint.AddHint(new CIccApplyBPCHint());
        break;
      }

      if (i+1<nNumProfiles && !stricmp(argv[nCount+2], "-PCC")) {
        pPccProfile = OpenIccProfile(argv[nCount+3]);
        if (!pPccProfile) {
          printf("Unable to open Profile Connections Conditions from '%s'\n", argv[nCount+3]);
          return -1;
        }
        //Keep track of pPccProfile for until after cmm.Begin is called
        pccList.push_back(pPccProfile);
      }

      if (!i && !stricmp(argv[nCount], "-embedded")) {
        unsigned int len=0;
        icUInt8Number *pProfile=NULL;

        if (!SrcImg.GetIccProfile(pProfile, len)) {
          printf("Image [%s] does not have an embedded profile\n", argv[nCount]);
          return -1;
        }

        CIccProfile *pImgProfile = OpenIccProfile(pProfile, len);

        if (!pImgProfile) {
          printf("Invalid Embedded profile in image [%s]\n", argv[nCount]);
          return -1;
        }

        if (sigMap.size()>0) {
          Hint.AddHint(new CIccCmmEnvVarHint(sigMap));
        }

        stat = theCmm.AddXform(pImgProfile, nIntent<0 ? icUnknownIntent : (icRenderingIntent)nIntent, nInterp, pPccProfile, (icXformLutType)nType, bUseMPE, &Hint);
        if (stat) {
          printf("Invalid Embedded profile in image [%s]\n", argv[nCount]);
          return -1;
        }
        sigMap.clear();
      }
      else {
        if (sigMap.size()>0) {
          Hint.AddHint(new CIccCmmEnvVarHint(sigMap));
        }

        last_path = &argv[nCount][0];
        stat = theCmm.AddXform(argv[nCount], nIntent<0 ? icUnknownIntent : (icRenderingIntent)nIntent, nInterp, pPccProfile, (icXformLutType)nType, bUseMPE, &Hint);
        if (stat) {
          printf("Invalid Profile(%d):  %s\n", stat, argv[nCount]);
          return -1;
        }
        sigMap.clear();
      }
    }
  }

  if((stat=theCmm.Begin())) {
    printf("Error %d - Unable to begin profile application - Possibly invalid or incompatible profiles\n", stat);
    return -1;
  }

  //Now we can release the pccProfile nodes.
  IccProfilePtrList::iterator pcc;

  for (pcc=pccList.begin(); pcc!=pccList.end(); pcc++) {
    CIccProfile *pPccProfile = *pcc;
    delete pPccProfile;
  }
  pccList.clear();

  icColorSpaceSignature SrcspaceSig = theCmm.GetSourceSpace();
  int nSrcSamples = icGetSpaceSamples(SrcspaceSig);

  if (nSrcSamples != sn) {
    printf("Number of samples in image[%s] doesn't match device samples in first profile\n", argv[1]);
    return -1;
  }

  icColorSpaceSignature DestspaceSig = theCmm.GetDestSpace();
  int nDestSamples = icGetSpaceSamples(DestspaceSig);

  switch (DestspaceSig) {
  case icSigRgbData:
    photo = PHOTO_MINISBLACK;
    break;

  case icSigCmyData:
  case icSigCmykData:
  case icSig4colorData:
  case icSig5colorData:
  case icSig6colorData:
  case icSig7colorData:
  case icSig8colorData:
    photo = PHOTO_MINISWHITE;
    break;

  case icSigXYZData:
    bConvert = true;
    //Fall through - No break here

  case icSigLabData:
    photo = PHOTO_CIELAB;
    break;

  default:
    photo = PHOTO_MINISBLACK;
    break;
  }

  unsigned long sbpp = (nSrcSamples * bps + 7) / 8;
  unsigned long dbpp = (nDestSamples * dbps  + 7)/ 8;

  if (!DstImg.Create(argv[2], SrcImg.GetWidth(), SrcImg.GetHeight(), dbps, photo, nDestSamples, SrcImg.GetXRes(), SrcImg.GetYRes(), bCompress, bSeparation)) {
    printf("Unable to create Tiff file - '%s'\n", argv[2]);
    return false;
  }

  if (bEmbed) {
    unsigned long length = 0;
    icUInt8Number *pDestProfile = NULL;

    CIccFileIO io;
    if (io.Open(last_path, "r")) {
      length = io.GetLength();
      pDestProfile = (icUInt8Number *)malloc(length);
      if (pDestProfile) {
        io.Read8(pDestProfile, length);
        DstImg.SetIccProfile(pDestProfile, length);
        free(pDestProfile);
      }
      io.Close();
    }
  }

  unsigned char *pSBuf = (unsigned char *)malloc(SrcImg.GetBytesPerLine());  

  if (!pSBuf) {
    printf("Out of Memory!\n");
    return false;
  }

  unsigned char *pDBuf = (unsigned char *)malloc(DstImg.GetBytesPerLine());

  if (!pDBuf) {
    printf("Out of Memory!\n");
    free(pSBuf);
    return false;
  }

  CIccPixelBuf SrcPixel(nSrcSamples+16), DestPixel(nDestSamples+16), Pixel(icIntMax(nSrcSamples, nDestSamples)+16);
  int lastPer = -1;
  int curper;

  for (i=0; i<SrcImg.GetHeight(); i++) {
    if (!SrcImg.ReadLine(pSBuf)) {
      bSuccess = false;
      break;
    }
    for (sptr=pSBuf, dptr=pDBuf, j=0; j<SrcImg.GetWidth(); j++, sptr+=sbpp, dptr+=dbpp) {

      switch(bps) {
        case 8:
          if (sphoto==PHOTO_CIELAB) {
            unsigned char *pSPixel = sptr;
            icFloatNumber *pPixel = SrcPixel;
            pPixel[0]=(icFloatNumber)pSPixel[0] / 255.0f;
            pPixel[1]=(icFloatNumber)(pSPixel[1]-128) / 255.0f;
            pPixel[2]=(icFloatNumber)(pSPixel[2]-128) / 255.0f;
          }
          else {
            unsigned char *pSPixel = sptr;
            icFloatNumber *pPixel = SrcPixel;
            for (k=0; k<nSrcSamples; k++) {
              pPixel[k] = (icFloatNumber)pSPixel[k] / 255.0f;
            }
          }
          break;

        case 16:
          if (sphoto==PHOTO_CIELAB) {
            unsigned short *pSPixel = (unsigned short*)sptr;
            icFloatNumber *pPixel = SrcPixel;
            pPixel[0]=(icFloatNumber)pSPixel[0] / 65535.0f;
            pPixel[1]=(icFloatNumber)(pSPixel[1]-0x8000) / 65535.0f;
            pPixel[2]=(icFloatNumber)(pSPixel[2]-0x8000) / 65535.0f;
          }
          else {
            unsigned short *pSPixel = (unsigned short*)sptr;
            icFloatNumber *pPixel = SrcPixel;
            for (k=0; k<nSrcSamples; k++) {
              pPixel[k] = (icFloatNumber)pSPixel[k] / 65535.0f;
            }
          }
          break;

        case 32:
          {
            if (sizeof(icFloatNumber)==sizeof(icFloat32Number)) {
              memcpy(SrcPixel.get(), sptr, sbpp);
            }
            else {
              icFloat32Number *pSPixel = (icFloat32Number*)sptr;
              icFloatNumber *pPixel = SrcPixel;
              for (k=0; k<nSrcSamples; k++) {
                pPixel[k] = (icFloatNumber)pSPixel[k];
              }
            }

            if (sphoto==PHOTO_CIELAB || sphoto==PHOTO_ICCLAB) {
              icLabToPcs(SrcPixel);
            }
          }
          break;

        default:
          printf("Invalid source bit depth\n");
          return -1;
      }

      if (SrcspaceSig==icSigXYZData) {
        icLabFromPcs(SrcPixel);
        icLabtoXYZ(SrcPixel);
        icXyzToPcs(SrcPixel);
      }

      theCmm.Apply(DestPixel, SrcPixel);

      if (DestspaceSig==icSigXYZData) {
        icXyzFromPcs(DestPixel);
        icXYZtoLab(DestPixel);
        icLabToPcs(DestPixel);
      }

      switch(dbps) {
        case 8:
          if (photo==PHOTO_CIELAB) {
            unsigned char *pDPixel = dptr;
            icFloatNumber *pPixel = DestPixel;
            pDPixel[0]=(icUInt8Number)(UnitClip(pPixel[0]) * 255.0f + 0.5f);
            pDPixel[1]=(icUInt8Number)(UnitClip(pPixel[1]) * 255.0f + 0.5f)+128;
            pDPixel[2]=(icUInt8Number)(UnitClip(pPixel[2]) * 255.0f + 0.5f)+128;
          }
          else {
            icUInt8Number *pDPixel = dptr;
            icFloatNumber *pPixel = DestPixel;
            for (k=0; k<nDestSamples; k++) {
              pDPixel[k] = (icUInt8Number)(UnitClip(pPixel[k]) * 255.0f + 0.5f);
            }
          }
          break;

        case 16:
          if (photo==PHOTO_CIELAB) {
            unsigned short *pDPixel = (unsigned short*)dptr;
            icFloatNumber *pPixel = DestPixel;
            pDPixel[0]=(icUInt16Number)(UnitClip(pPixel[0]) * 65535.0f + 0.5f);
            pDPixel[1]=(icUInt16Number)(UnitClip(pPixel[1]) * 65535.0f + 0.5f)+0x8000;
            pDPixel[2]=(icUInt16Number)(UnitClip(pPixel[2]) * 65535.0f + 0.5f)+0x8000;
          }
          else {
            icUInt16Number *pDPixel = (icUInt16Number*)dptr;
            icFloatNumber *pPixel = DestPixel;
            for (k=0; k<nDestSamples; k++) {
              pDPixel[k] = (icUInt16Number)(UnitClip(pPixel[k]) * 65535.0f+0.5f);
            }
          }
          break;

        case 32:
          {
            if (photo==PHOTO_CIELAB || photo==PHOTO_ICCLAB) {
              icLabFromPcs(SrcPixel);
            }

            if (sizeof(icFloatNumber)==sizeof(icFloat32Number)) {
              memcpy(dptr, DestPixel.get(), dbpp);
            }
            else {
              icFloat32Number *pDPixel = (icFloat32Number*)dptr;
              icFloatNumber *pPixel = DestPixel;
              for (k=0; k<nDestSamples; k++) {
                pDPixel[k] = (icFloat32Number)pPixel[k];
              }
            }
          }
          break;

        default:
          printf("Invalid source bit depth\n");
          return -1;
      }
    }
    if (!DstImg.WriteLine(pDBuf)) {
      bSuccess = false;
      break;
    }
    curper = (int)((float)(i+1)*100.0f/(float)SrcImg.GetHeight());
    if (curper !=lastPer) {
      printf("\r%d%%", curper);
      lastPer = curper;
    }
  }
  printf("\n");

  if (last_path && last_path[0] && theCmm.IsLastOutPut()) {
  }

  SrcImg.Close();

  free(pSBuf);
  free(pDBuf);

  DstImg.Close();

  return 0;
}

