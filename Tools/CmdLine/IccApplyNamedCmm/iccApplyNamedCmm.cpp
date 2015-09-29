#include <fstream>

#include "IccCmm.h"
#include "IccUtil.h"
#include "IccDefs.h"
#include "IccApplyBPC.h"

//----------------------------------------------------
// Function Declarations
//----------------------------------------------------
#define IsSpacePCS(x) ((x)==icSigXYZData || (x)==icSigLabData)
bool ParseNumbers(icFloatNumber* pData, icChar* pString, icUInt32Number nSamples);
bool ParseName(icChar* pName, icChar* pString);

//----------------------------------------------------
// Function Definitions
//----------------------------------------------------

bool ParseNumbers(icFloatNumber* pData, icChar* pString, icUInt32Number nSamples)
{
  icUInt32Number nNumbersRead=0;

  icChar *ptr=pString;

  while (*ptr && nNumbersRead < nSamples) {
    while (*ptr==' ' || *ptr=='\t' || *ptr=='\n' || *ptr=='\r')
      ptr++;
    if (sscanf(ptr, ICFLOATFMT, &pData[nNumbersRead])==1)
      nNumbersRead++;
    else
      break;
    while (*ptr && *ptr!=' ' && *ptr!='\t' && *ptr!='n' && *ptr!='\r')
      ptr++;
  }


  if(nNumbersRead != nSamples) {
    return false;
  }

  return true;
}

bool ParseNextNumber(icFloatNumber &num, icChar **text)
{
  if (!text)
    return false;

  icChar *ptr = *text;
  while(*ptr==' ') ptr++;
  if ((*ptr>='0' && *ptr<='9') || *ptr=='.') {
    num=(icFloatNumber)atof(ptr); 

    while(*ptr && *ptr!=' ') ptr++;
    
    *text = ptr;

    return true;
  }
  return false;
}

//===================================================

bool ParseName(icChar* pName, icChar* pString)
{
  if(strncmp(pString, "{ \"", 3))
    return false;

  icChar *ptr = strstr(pString, "\" }");

  if(!ptr)
    return false;

  icUInt32Number nNameLen = ptr - (pString+3);

  if(!nNameLen)
    return false;

  strncpy(pName, pString+3, nNameLen);
  pName[nNameLen] = '\0';
  
  return true;
}

typedef std::list<CIccProfile*> IccProfilePtrList;

void Usage() 
{
  printf("Usage: iccApplyNamedCmm data_file_path final_data_encoding interpolation {profile_file_path Rendering_intent {-PCC connection_conditions_path}}\n\n");
	printf("  For final_data_encoding:\n");
	printf("    0 - icEncodeValue (converts to/from lab encoding when samples=3)\n");
	printf("    1 - icEncodePercent\n");
  printf("    2 - icEncodeUnitFloat (may clip to 0.0 to 1.0)\n");
	printf("    3 - icEncodeFloat\n");
	printf("    4 - icEncode8Bit\n");
	printf("    5 - icEncode16Bit\n");
  printf("    6 - icEncode16BitV2\n\n");

	printf("  For interpolation:\n");
	printf("    0 - Linear\n");
	printf("    1 - Tetrahedral\n\n");

	printf("  For Rendering_intent:\n");
	printf("    0 - Perceptual\n");
	printf("    1 - Relative Colorimetric\n");
	printf("    2 - Saturation\n");
	printf("    3 - Absolute Colorimetric\n");
	printf("    10 - Perceptual without MPE\n");
	printf("    11 - Relative Colorimetric without MPE\n");
	printf("    12 - Saturation without MPE\n");
	printf("    13 - Absolute Colorimetric without MPE \n");
	printf("    20 - Preview Perceptual\n");
	printf("    21 - Preview Relative Colorimetric\n");
	printf("    22 - Preview Saturation\n");
	printf("    23 - Preview Absolute Colorimetric\n");
	printf("    30 - Gamut\n");
  printf("    33 - Gamut Absolute\n");
	printf("    40 - Perceptual with BPC\n");
	printf("    41 - Relative Colorimetric with BPC\n");
	printf("    42 - Saturation with BPC\n");
  printf("    50 - MCS connection");
}

//===================================================

int main(int argc, icChar* argv[])
{
	int minargs = 4; // minimum number of arguments
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

  std::ifstream InputData(argv[1]);

  if(!InputData) {
    printf("\nFile [%s] cannot be opened.\n", argv[1]);
    return false;
  }

  icChar ColorSig[7], tempBuf[5000];
  InputData.getline(tempBuf, sizeof(tempBuf));

  int i;
  for (i = 0; (i<4 || tempBuf[i+1]!='\'') && i < 6; i++) {
    ColorSig[i] = tempBuf[i+1];
  }
  for (;i<7; i++)
    ColorSig[i] = '\0';


  icColorSpaceSignature SrcspaceSig = (icColorSpaceSignature)icGetSigVal(ColorSig);
  int nSamples = icGetSpaceSamples(SrcspaceSig);

  if(SrcspaceSig != icSigNamedData) {
    if(!nSamples) {
      printf("Source color space signature not recognized.\n");
      return -1;
    }
  }

  InputData.getline(tempBuf, sizeof(tempBuf));
  sscanf(tempBuf, "%s", tempBuf);

  icFloatColorEncoding srcEncoding, destEncoding;

  srcEncoding = CIccCmm::GetFloatColorEncoding(tempBuf);

  if(srcEncoding == icEncodeUnknown) {
    printf("Source color data encoding not recognized.\n");
    return false;
  }

  destEncoding = (icFloatColorEncoding)atoi(argv[2]);
	icXformInterp nInterp = (icXformInterp)atoi(argv[3]);

  int nIntent, nType;
  CIccNamedColorCmm namedCmm(SrcspaceSig, icSigUnknownData, !IsSpacePCS(SrcspaceSig));
  IccProfilePtrList pccList;

  int nCount;
  bool bUseMPE;
  for(i = 0, nCount=minargs; i<nNumProfiles; i++, nCount+=2) {
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

    //check for -PCC arg to allow for profile connection conditions to be defined
    if (stricmp(argv[nCount], "-PCC")) {
      if (i+1<nNumProfiles && !stricmp(argv[nCount+2], "-PCC")) {
        pPccProfile = OpenIccProfile(argv[nCount+3]);
        if (!pPccProfile) {
          printf("Unable to open Profile Connections Conditions from '%s'\n", argv[nCount+3]);
          return -1;
        }
        //Keep track of pPccProfile for until after cmm.Begin is called
        pccList.push_back(pPccProfile);
      }

      if (namedCmm.AddXform(argv[nCount], nIntent<0 ? icUnknownIntent : (icRenderingIntent)nIntent, nInterp, pPccProfile, (icXformLutType)nType, bUseMPE, &Hint)) {
        printf("Invalid Profile:  %s\n", argv[nCount]);
        return -1;
      }
    }
  }

  icStatusCMM stat;
  if((stat=namedCmm.Begin())) {
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

  SrcspaceSig = namedCmm.GetSourceSpace();
  int nSrcSamples = icGetSpaceSamples(SrcspaceSig);

  icColorSpaceSignature DestspaceSig = namedCmm.GetDestSpace();
  int nDestSamples = icGetSpaceSamples(DestspaceSig);
  
  std::string OutPutData;
  char SrcNameBuf[256], DestNameBuf[256];
  CIccPixelBuf SrcPixel(nSrcSamples+16), DestPixel(nDestSamples+16), Pixel(icIntMax(nSrcSamples, nDestSamples)+16);

  sprintf(tempBuf,"%s\t; ", icGetColorSig(tempBuf, DestspaceSig, false));
  OutPutData += tempBuf;
  OutPutData += "Data Format\n";

  if(DestspaceSig==icSigNamedData)
    destEncoding = icEncodeValue;
  sprintf(tempBuf, "%s\t; ", CIccCmm::GetFloatColorEncoding(destEncoding));
  OutPutData += tempBuf;
  OutPutData += "Encoding\n\n";

  OutPutData += ";Source Data Format: ";
  sprintf(tempBuf,"%s\n", icGetColorSig(tempBuf, SrcspaceSig, false));
  OutPutData += tempBuf;

  if(SrcspaceSig==icSigNamedData)
    srcEncoding = icEncodeValue;
  OutPutData += ";Source Data Encoding: ";
  sprintf(tempBuf, "%s\n", CIccCmm::GetFloatColorEncoding(srcEncoding));
  OutPutData += tempBuf;

  OutPutData += ";Source data is after semicolon\n";
  
  OutPutData += "\n;Profiles applied\n";
  for(i = 0, nCount=minargs; i<nNumProfiles; i++, nCount+=2) {
    OutPutData += "; ";
    if (stricmp(argv[nCount], "-PCC")) {
      if (i+1<nNumProfiles && !stricmp(argv[nCount+2], "-PCC")) {
        sprintf(tempBuf, "%s -PCC %s\n", argv[nCount], argv[nCount+3]);
        OutPutData += tempBuf;
        nCount += 2;
        nNumProfiles--;
      }
      else {
        sprintf(tempBuf, "%s\n", argv[nCount]);
        OutPutData += tempBuf;
      }
    }
  }
  OutPutData += "\n";
  
  fwrite(OutPutData.c_str(), 1, OutPutData.length(), stdout);

  while(!InputData.eof()) {

    if(SrcspaceSig==icSigNamedData) {
      InputData.getline(tempBuf, sizeof(tempBuf));
      if(!ParseName(SrcNameBuf, tempBuf))
        continue;

      icChar *numptr = strstr(tempBuf, "\" }");
      if (numptr)
        numptr+=3;

      icFloatNumber tint;
      if (!ParseNextNumber(tint, &numptr))
        tint = 1.0;

      OutPutData.erase();

      switch(namedCmm.GetInterface()) {
        case icApplyNamed2Pixel:
          {

            if(namedCmm.Apply(DestPixel, SrcNameBuf, tint)) {
              printf("Profile application failed.\n");
              return -1;
            }

            if(CIccCmm::FromInternalEncoding(DestspaceSig, destEncoding, DestPixel, DestPixel, destEncoding!=icEncodeFloat)) {
              printf("Invalid final data encoding\n");
              return -1;
            }

            for(i = 0; i<nDestSamples; i++) {
              sprintf(tempBuf, "%9.4lf ", DestPixel[i]);
              OutPutData += tempBuf;
            }
            OutPutData += "\t; ";
            
            break;
          }
        case icApplyNamed2Named:
          {
            if(namedCmm.Apply(DestNameBuf, SrcNameBuf, tint)) {
              printf("Profile application failed.\n");
              return -1;
            }
            
            sprintf(tempBuf, "{ \"%s\" }\t; ", DestNameBuf);
            OutPutData += tempBuf;

            break;
          }
        case icApplyPixel2Pixel:
        case icApplyPixel2Named:
        default:
          printf("Incorrect interface.\n");
          return -1;
      }      

      if (tint==1.0)
        sprintf(tempBuf, "{ \"%s\" }\n", SrcNameBuf);
      else
        sprintf(tempBuf, "{ \"%s\" } %.4f\n", SrcNameBuf, tint);

      OutPutData += tempBuf;
    }
    else {
      InputData.getline(tempBuf, sizeof(tempBuf));
      if(!ParseNumbers(Pixel, tempBuf, nSamples))
        continue;

      OutPutData.erase();
      if(CIccCmm::ToInternalEncoding(SrcspaceSig, srcEncoding, SrcPixel, Pixel)) {
        printf("Invalid source data encoding\n");
        return -1;
      }

      switch(namedCmm.GetInterface()) {
        case icApplyPixel2Pixel:
          {
            if(namedCmm.Apply(DestPixel, SrcPixel)) {
              printf("Profile application failed.\n");
              return -1;
            }
            if(CIccCmm::FromInternalEncoding(DestspaceSig, destEncoding, DestPixel, DestPixel)) {
              printf("Invalid final data encoding\n");
              return -1;
            }

            for(i = 0; i<nDestSamples; i++) {
              sprintf(tempBuf, "%9.4lf ", DestPixel[i]);
              OutPutData += tempBuf;
            }
            OutPutData += "\t; ";
            break;
          }
        case icApplyPixel2Named:
          {
            if(namedCmm.Apply(DestNameBuf, SrcPixel)) {
              printf("Profile application failed.\n");
              return -1;
            }
            sprintf(tempBuf, "{ \"%s\" }\t; ", DestNameBuf);
            OutPutData += tempBuf;
            break;
          }
        case icApplyNamed2Pixel:
        case icApplyNamed2Named:
        default:
          printf("Incorrect interface.\n");
          return -1;
      }      


      for(i = 0; i<nSamples; i++) {
        sprintf(tempBuf, "%9.4lf ", Pixel[i]);
        OutPutData += tempBuf;
      }

      OutPutData += "\n";
    }

    fwrite(OutPutData.c_str(), 1, OutPutData.length(), stdout);
  }


  return 0;
}
