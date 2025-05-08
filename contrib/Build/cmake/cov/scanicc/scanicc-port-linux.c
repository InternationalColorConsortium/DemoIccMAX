//---------------------------------------------------------------------------------
//
//  Little Color Management System
//  Copyright (c) 1998-2015 Marti Maria Saguer
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software
// is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//---------------------------------------------------------------------------------
//

//
// Copyright(c) 2025 David H Hoyt LLC - Port to Linux Mods - Apache 2 License
//
//
// REQUIRE: Build LCMS2 from Source, THEN
// COMPILE: gcc scanicc-port-linux.c /lcms2/Little-CMS/src/*.o -I/lcms2/Little-CMS/include 
//          -fsanitize=address -fno-omit-frame-pointer -g3 -O1 
//          -Wall -Wextra -pedantic     -o xscan     -lz -lm     
//          -Wno-unused-parameter -Wno-type-limits  -Wno-misleading-indentation
// 
// Last Modified: 12-MAY-2025 1830 EDT David Hoyt
// INTENT: PORT Marti Maria Saguer Code to Linux and Commit on research branches
//
//
//

#ifdef _WIN32
#include <io.h>
#endif

// Deal with Microsoft's attempt at deprecating C standard runtime functions
#ifdef _MSC_VER
#    if (_MSC_VER >= 1400)
#      ifndef _CRT_SECURE_NO_DEPRECATE
#        define _CRT_SECURE_NO_DEPRECATE
#      endif
#      ifndef _CRT_SECURE_NO_WARNINGS
#        define _CRT_SECURE_NO_WARNINGS
#      endif
#    endif
#endif


#include "lcms2.h"

#include <stdint.h>     // for intptr_t
#include <dirent.h>     // for opendir, readdir
#include <sys/stat.h>   // for stat
#include <unistd.h>     // for access


#include <string.h>
#include <stdarg.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
// #include <io.h>

#include <unistd.h>  // for getopt
#define xgetopt getopt
#define xoptarg optarg
#define xoptind optind
#define xopterr opterr
#define SW '-'

// ----------------------------------------------------------------------------------

#define UNUSED_PARAMETER(x) ((void)x)
#define cmsmin(a, b) (((a) < (b)) ? (a) : (b))


static int Verbose = 0;
static cmsBool PossibleExploit = FALSE;
static cmsBool ErrorState = FALSE;
static cmsBool AlreadyReported = FALSE;
static cmsBool Bypass = FALSE;

static cmsHPROFILE hsRGB;
static cmsHPROFILE hCMYK;

// Text that describes the phase
static const char* TryingPhase;
static char  ProfileName[cmsMAX_PATH];

// ----------------------------------------------------------------------------------

// Print diagnostic and die
static
void FatalError(const char *frm, ...)
{
       va_list args;

       va_start(args, frm);
       fprintf(stderr, "\n** Fatal error - ");
       vfprintf(stderr, frm, args);
       va_end(args);

       exit(1);
}


// Show a message on the profile
static
void Message(const char *frm, ...)
{
       va_list args;

       va_start(args, frm);
       fprintf(stderr, "\n\t");
       vfprintf(stderr, frm, args);
       va_end(args);
}



// The toggles stuff
static
void HandleSwitches(int argc, char *argv[])
{
       int s;

       while ((s = xgetopt(argc, argv, "V:v:")) != EOF) {

              switch (s) {


                     // Verbosity level
              case 'V':
              case 'v':
                     Verbose = atoi(xoptarg);
                     if (Verbose < 0 || Verbose > 3) {
                            FatalError("Unknown verbosity level '%d'", Verbose);
                     }
                     break;


              default:
                     FatalError("Unknown option - run without args to see valid ones.\n");
              }
       }
}

// The manual
static
int Help()
{

       fprintf(stderr, "\nscanicc: Checks for corrupted ICC profiles.\n");

       fprintf(stderr, "\n");
       fprintf(stderr, "usage: scanicc [flags] <profile>\n\n");
       fprintf(stderr, "flags:\n\n");
       fprintf(stderr, "%cv<level> - Verbosity level\n", SW);

       fprintf(stderr,
              "\n"
              "This program is intended to be a demo of the little cms\n"
              "engine. Both lcms and this program are freeware. You can\n"
              "obtain both in source code at http://www.littlecms.com\n"
              "For suggestions, comments, bug reports etc. send mail to\n"
              "info@littlecms.com\n\n");


       return 0;
}


// Create a fake CMYK profile, without any other requeriment that being coarse CMYK.
// DONT USE THIS PROFILE FOR ANYTHING, IT IS USELESS BUT FOR TESTING PURPOSES.
typedef struct {

       cmsHTRANSFORM hLab2sRGB;
       cmsHTRANSFORM sRGB2Lab;
       cmsHTRANSFORM hIlimit;

} FakeCMYKParams;

static
cmsFloat64Number Clip(cmsFloat64Number v)
{
       if (v < 0) return 0;
       if (v > 1) return 1;

       return v;
}

static
cmsInt32Number ForwardSampler(register const cmsUInt16Number In[], cmsUInt16Number Out[], void* Cargo)
{
       FakeCMYKParams* p = (FakeCMYKParams*)Cargo;
       cmsFloat64Number rgb[3], cmyk[4];
       cmsFloat64Number c, m, y, k;

       cmsDoTransform(p->hLab2sRGB, In, rgb, 1);

       c = 1 - rgb[0];
       m = 1 - rgb[1];
       y = 1 - rgb[2];

       k = (c < m ? cmsmin(c, y) : cmsmin(m, y));

       // NONSENSE WARNING!: I'm doing this just because this is a test
       // profile that may have ink limit up to 400%. There is no UCR here
       // so the profile is basically useless for anything but testing.

       cmyk[0] = c;
       cmyk[1] = m;
       cmyk[2] = y;
       cmyk[3] = k;

       cmsDoTransform(p->hIlimit, cmyk, Out, 1);

       return 1;
}


static
cmsInt32Number ReverseSampler(register const cmsUInt16Number In[], register cmsUInt16Number Out[], register void* Cargo)
{
       FakeCMYKParams* p = (FakeCMYKParams*)Cargo;
       cmsFloat64Number c, m, y, k, rgb[3];

       c = In[0] / 65535.0;
       m = In[1] / 65535.0;
       y = In[2] / 65535.0;
       k = In[3] / 65535.0;

       if (k == 0) {

              rgb[0] = Clip(1 - c);
              rgb[1] = Clip(1 - m);
              rgb[2] = Clip(1 - y);
       }
       else
              if (k == 1) {

                     rgb[0] = rgb[1] = rgb[2] = 0;
              }
              else {

                     rgb[0] = Clip((1 - c) * (1 - k));
                     rgb[1] = Clip((1 - m) * (1 - k));
                     rgb[2] = Clip((1 - y) * (1 - k));
              }

              cmsDoTransform(p->sRGB2Lab, rgb, Out, 1);
              return 1;
}

// Some magic
cmsStage*  _cmsStageAllocIdentityCurves(cmsContext ContextID, int nChannels);


// A fake CMYK just to creater transforms
static
cmsHPROFILE CreateFakeCMYK(cmsFloat64Number InkLimit)
{
       cmsHPROFILE hICC;
       cmsPipeline* AToB0, *BToA0;
       cmsStage* CLUT;
       FakeCMYKParams p;
       cmsHPROFILE hLab, hsRGB, hLimit;
       cmsUInt32Number cmykfrm;

       hsRGB = cmsCreate_sRGBProfile();

       hLab = cmsCreateLab4Profile(NULL);
       hLimit = cmsCreateInkLimitingDeviceLink(cmsSigCmykData, InkLimit);

       cmykfrm = FLOAT_SH(1) | BYTES_SH(0) | CHANNELS_SH(4);
       p.hLab2sRGB = cmsCreateTransform(hLab, TYPE_Lab_16, hsRGB, TYPE_RGB_DBL, INTENT_PERCEPTUAL, cmsFLAGS_NOOPTIMIZE | cmsFLAGS_NOCACHE);
       p.sRGB2Lab = cmsCreateTransform(hsRGB, TYPE_RGB_DBL, hLab, TYPE_Lab_16, INTENT_PERCEPTUAL, cmsFLAGS_NOOPTIMIZE | cmsFLAGS_NOCACHE);
       p.hIlimit = cmsCreateTransform(hLimit, cmykfrm, NULL, TYPE_CMYK_16, INTENT_PERCEPTUAL, cmsFLAGS_NOOPTIMIZE | cmsFLAGS_NOCACHE);

       cmsCloseProfile(hLab); cmsCloseProfile(hsRGB); cmsCloseProfile(hLimit);


       hICC = cmsCreateProfilePlaceholder(0);
       if (!hICC) return NULL;

       cmsSetProfileVersion(hICC, 4.3);

       cmsSetDeviceClass(hICC, cmsSigOutputClass);
       cmsSetColorSpace(hICC, cmsSigCmykData);
       cmsSetPCS(hICC, cmsSigLabData);

       BToA0 = cmsPipelineAlloc(0, 3, 4);
       if (BToA0 == NULL) return 0;
       CLUT = cmsStageAllocCLut16bit(0, 17, 3, 4, NULL);
       if (CLUT == NULL) return 0;
       if (!cmsStageSampleCLut16bit(CLUT, ForwardSampler, &p, 0)) return 0;

       cmsPipelineInsertStage(BToA0, cmsAT_BEGIN, _cmsStageAllocIdentityCurves(0, 3));
       cmsPipelineInsertStage(BToA0, cmsAT_END, CLUT);
       cmsPipelineInsertStage(BToA0, cmsAT_END, _cmsStageAllocIdentityCurves(0, 4));

       if (!cmsWriteTag(hICC, cmsSigBToA0Tag, (void*)BToA0)) return 0;
       cmsPipelineFree(BToA0);

       AToB0 = cmsPipelineAlloc(0, 4, 3);
       if (AToB0 == NULL) return 0;
       CLUT = cmsStageAllocCLut16bit(0, 17, 4, 3, NULL);
       if (CLUT == NULL) return 0;
       if (!cmsStageSampleCLut16bit(CLUT, ReverseSampler, &p, 0)) return 0;

       cmsPipelineInsertStage(AToB0, cmsAT_BEGIN, _cmsStageAllocIdentityCurves(0, 4));
       cmsPipelineInsertStage(AToB0, cmsAT_END, CLUT);
       cmsPipelineInsertStage(AToB0, cmsAT_END, _cmsStageAllocIdentityCurves(0, 3));

       if (!cmsWriteTag(hICC, cmsSigAToB0Tag, (void*)AToB0)) return 0;
       cmsPipelineFree(AToB0);

       cmsDeleteTransform(p.hLab2sRGB);
       cmsDeleteTransform(p.sRGB2Lab);
       cmsDeleteTransform(p.hIlimit);

       cmsLinkTag(hICC, cmsSigAToB1Tag, cmsSigAToB0Tag);
       cmsLinkTag(hICC, cmsSigAToB2Tag, cmsSigAToB0Tag);
       cmsLinkTag(hICC, cmsSigBToA1Tag, cmsSigBToA0Tag);
       cmsLinkTag(hICC, cmsSigBToA2Tag, cmsSigBToA0Tag);

       return hICC;
}

// We use error reporting to catch exploits
static
void MyErrorLogHandler(cmsContext ContextID, cmsUInt32Number ErrorCode, const char *Text)
{
       if (Verbose > 1)
              Message("%s", Text);

       ErrorState = TRUE;

       if (ErrorCode == cmsERROR_CORRUPTION_DETECTED)
       {
              if (!AlreadyReported && Verbose > 0)
                     Message("possible exploit in %s", TryingPhase);

              PossibleExploit = TRUE;
       }
       else
       {
              if (!AlreadyReported && Verbose > 0)
                     Message("error in %s", TryingPhase);
       }

       AlreadyReported = TRUE;
       UNUSED_PARAMETER(ContextID);
}


// Check a transformation by converting it ato a device link (this forces to evaluate the transform)
static
void CheckTransform(cmsHTRANSFORM xform)
{
       cmsHPROFILE hICC;

       hICC = cmsTransform2DeviceLink(xform, 2.1, 0);
       if (hICC != NULL) cmsCloseProfile(hICC);
       hICC = cmsTransform2DeviceLink(xform, 4.1, 0);
       cmsCloseProfile(hICC);
}

// For one intent (0..2)
static
void checkOneIntentRGB(cmsHPROFILE hProfile, cmsUInt32Number intent)
{
       cmsHTRANSFORM xform;
       static const char* ForwardTextPhase[] = { "input perceptual RGB (AtoB0)", "input rel.col RGB (AtoB1)", "input saturation RGB (AtoB2)" };
       static const char* ReverseTextPhase[] = { "output perceptual RGB (BtoA0)", "output rel.col RGB (BtoA1)", "output saturation RGB (BtoA2)" };

       if (intent >= INTENT_PERCEPTUAL && intent <= INTENT_SATURATION) {

              // Forward
              TryingPhase = ForwardTextPhase[intent];
              xform = cmsCreateTransform(hProfile, TYPE_RGB_16, hsRGB, TYPE_RGB_16, intent, cmsFLAGS_KEEP_SEQUENCE);
              if (xform != NULL) {
                     CheckTransform(xform);
                     cmsDeleteTransform(xform);
              }

              // Reverse
              TryingPhase = ReverseTextPhase[intent];
              xform = cmsCreateTransform(hsRGB, TYPE_RGB_16, hProfile, TYPE_RGB_16, intent, cmsFLAGS_KEEP_SEQUENCE);
              if (xform != NULL) {
                     CheckTransform(xform);
                     cmsDeleteTransform(xform);
              }
       }

}


static
void checkOneIntentCMYK(cmsHPROFILE hProfile, cmsUInt32Number intent)
{
       cmsHTRANSFORM xform;
       static const char* ForwardTextPhase[] = { "input perceptual CMYK (AtoB0)", "input rel.col CMYK (AtoB1)", "input saturation CMYK (AtoB2)" };
       static const char* ReverseTextPhase[] = { "output perceptual CMYK (BtoA0)", "output rel.col CMYK (BtoA1)", "output saturation CMYK (BtoA2)" };


       if (intent >= INTENT_PERCEPTUAL && intent <= INTENT_SATURATION) {

              // Forward
              TryingPhase = ForwardTextPhase[intent];
              xform = cmsCreateTransform(hProfile, TYPE_CMYK_16, hCMYK, TYPE_CMYK_16, intent, cmsFLAGS_KEEP_SEQUENCE);
              if (xform != NULL) {
                     CheckTransform(xform);
                     cmsDeleteTransform(xform);
              }

              // Reverse
              TryingPhase = ReverseTextPhase[intent];
              xform = cmsCreateTransform(hCMYK, TYPE_CMYK_16, hProfile, TYPE_CMYK_16, intent, cmsFLAGS_KEEP_SEQUENCE);
              if (xform != NULL) {
                     CheckTransform(xform);
                     cmsDeleteTransform(xform);
              }
       }
}

static
char* sig2char(int sig)
{
       static char str[5];

       str[0] = (char)((cmsUInt32Number)(sig & 0xff000000) >> 24);
       str[1] = (char)((cmsUInt32Number)(sig & 0x00ff0000) >> 16);
       str[2] = (char)((cmsUInt32Number)(sig & 0x0000ff00) >> 8);
       str[3] = (char)((cmsUInt32Number)(sig & 0x000000ff));
       str[4] = 0;

       return str;
}


// Test all intents
static
void checkAllIntents(cmsHPROFILE hProfile)
{
       cmsColorSpaceSignature cs = cmsGetColorSpace(hProfile);
       cmsProfileClassSignature  dc = cmsGetDeviceClass(hProfile);


       if (!(dc == cmsSigInputClass ||
              dc == cmsSigDisplayClass ||
              dc == cmsSigOutputClass ||
              dc == cmsSigColorSpaceClass)) {

              Bypass = TRUE;
              Message("*** Bypassing this profile because unsupported device class '%s'", sig2char(dc));
       }
       else
              if (cs == cmsSigRgbData) {

                     checkOneIntentRGB(hProfile, INTENT_PERCEPTUAL);
                     checkOneIntentRGB(hProfile, INTENT_RELATIVE_COLORIMETRIC);
                     checkOneIntentRGB(hProfile, INTENT_SATURATION);
              }
              else
                     if (cs == cmsSigCmykData) {

                            checkOneIntentCMYK(hProfile, INTENT_PERCEPTUAL);
                            checkOneIntentCMYK(hProfile, INTENT_RELATIVE_COLORIMETRIC);
                            checkOneIntentCMYK(hProfile, INTENT_SATURATION);
                     }
                     else {
                            Bypass = TRUE;
                            Message("*** Bypassing this profile because unsupported Color Space '%s'", sig2char(cs));
                     }

                     if (PossibleExploit)
                     {
                            Message("*** WARNING: Profile may contain exploits!");
                     }
                     else
                            if (ErrorState)
                            {
                                   Message("*** WARNING : Profile has errors");
                            }

}

// Auxiliar for reading information on profile
static
void checkInfo(cmsHPROFILE h, cmsInfoType Info)
{
       char* text;
       int len;

       TryingPhase = "Profile information";
       len = cmsGetProfileInfoASCII(h, Info, "en", "US", NULL, 0);
       if (len > 0) {

              if (len > 10 * 1024) {

                     PossibleExploit = TRUE;

              }
              else {
                     text = (char*)malloc(len * sizeof(char));
                     if (text != NULL) {

                            cmsGetProfileInfoASCII(h, Info, "en", "US", text, len);
                            free(text);
                     }
              }
       }
}



// checks the colorant table
static
void checkColorantTable(cmsHPROFILE hInput, cmsTagSignature Sig, const char* Title)
{
       cmsNAMEDCOLORLIST* list;
       int i, n;

       if (cmsIsTag(hInput, Sig)) {

              TryingPhase = Title;

              list = (cmsNAMEDCOLORLIST*)cmsReadTag(hInput, Sig);
              if (list != NULL) {

                     n = cmsNamedColorCount(list);

                     if (n > 15) {
                            PossibleExploit = TRUE;
                     }
                     else {
                            for (i = 0; i < n; i++) {

                                   char Name[cmsMAX_PATH];

                                   cmsNamedColorInfo(list, i, Name, NULL, NULL, NULL, NULL);
                            }
                     }
              }
       }

}

static
void checkProfileInformation(cmsHPROFILE hInput)
{
       checkInfo(hInput, cmsInfoDescription);
       checkInfo(hInput, cmsInfoManufacturer);
       checkInfo(hInput, cmsInfoModel);
       checkInfo(hInput, cmsInfoCopyright);

       checkColorantTable(hInput, cmsSigColorantTableTag, "Input colorant table");
       checkColorantTable(hInput, cmsSigColorantTableOutTag, "Input colorant out table");

}

static
void checkDir(const char* dir)
{
    DIR* d;
    struct dirent* entry;
    cmsHPROFILE hProfile;
    char fullpath[PATH_MAX];

    d = opendir(dir);
    if (!d) {
        Message("Cannot open directory: %s", dir);
        return;
    }

    while ((entry = readdir(d)) != NULL) {
        if (entry->d_type == DT_DIR) {
            if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0) {
                char subdir[PATH_MAX];
                snprintf(subdir, sizeof(subdir), "%s/%s", dir, entry->d_name);
                checkDir(subdir);
            }
        } else {
            if (strstr(entry->d_name, ".icc") || strstr(entry->d_name, ".ICM")) {
                PossibleExploit = FALSE;
                ErrorState = FALSE;
                AlreadyReported = FALSE;
                Bypass = FALSE;

                snprintf(fullpath, sizeof(fullpath), "%s/%s", dir, entry->d_name);
                strncpy(ProfileName, fullpath, sizeof(ProfileName) - 1);

                TryingPhase = "parsing profile";
                fprintf(stderr, "\n%s:", ProfileName);

                hProfile = cmsOpenProfileFromFile(ProfileName, "r");

                if (hProfile != NULL) {
                    checkProfileInformation(hProfile);
                    checkAllIntents(hProfile);
                    cmsCloseProfile(hProfile);
                } else {
                    Message("This file is not recognized as a valid ICC profile");
                }

                if (!ErrorState && !Bypass)
                    fprintf(stderr, " Ok\n");
                else
                    fprintf(stderr, "\n");

            }
        }
    }

    closedir(d);
}


// The main sink
int main(int argc, char *argv[])
{
       int nargs;

       fprintf(stderr, "LittleCMS ICC profile scanner [LittleCMS %2.2f]\n", LCMS_VERSION / 1000.0);

       cmsSetLogErrorHandler(MyErrorLogHandler);

       HandleSwitches(argc, argv);

       nargs = (argc - xoptind);
       if (nargs < 1)
              return Help();

       hsRGB = cmsCreate_sRGBProfile();
       hCMYK = CreateFakeCMYK(350);

//       checkDir(argv[xoptind]);
struct stat path_stat;
stat(argv[xoptind], &path_stat);

if (S_ISDIR(path_stat.st_mode)) {
    checkDir(argv[xoptind]);
} else {
    PossibleExploit = FALSE;
    ErrorState = FALSE;
    AlreadyReported = FALSE;
    Bypass = FALSE;

    strncpy(ProfileName, argv[xoptind], sizeof(ProfileName) - 1);
    TryingPhase = "parsing profile";
    fprintf(stderr, "\n%s:", ProfileName);

    cmsHPROFILE hProfile = cmsOpenProfileFromFile(ProfileName, "r");

    if (hProfile != NULL) {
        checkProfileInformation(hProfile);
        checkAllIntents(hProfile);
        cmsCloseProfile(hProfile);
    } else {
        Message("This file is not recognized as a valid ICC profile");
    }

    if (!ErrorState && !Bypass)
        fprintf(stderr, " Ok\n\n");
}

       cmsCloseProfile(hsRGB);
       cmsCloseProfile(hCMYK);

       // All is ok
       return 0;
}


