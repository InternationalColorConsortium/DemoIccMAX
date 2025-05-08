/*
#
# Copyright(c) 1998 - 2025 Marti Maria Saguer - scan.c
# Copyright(c) 2003 - 2025 International Color Consortium - IccDumpProfile.cpp
# Copyright(c) 1994 - 2025 David H Hoyt LLC - IccSignatureUtils.h - UCI Profiler
#
#
# Compile: g++ -I../../../../IccProfLib/     -I../../../../IccXML/IccLibXML/     -I/usr/local/include     -L/usr/local/lib     -fsanitize=address     -fno-omit-frame-pointer     -g3 -O1     -Wall -Wextra -Wpedantic     -o licc licc.c     -llcms2 -lstdc++ -lz -lm     -Wno-unused-parameter     -Wno-type-limits     -Wno-overloaded-virtual
#
# Last Modified: 15-MAY-2025 1830 EDT David Hoyt
# Latest: Add iccDumpProfile Output Report Section, Test
#
#
# Intent: Demo implementation for IccSignatureUtils.h
# Little ICC Scanner [licc] demonstrates a measurement and analysis toolchain for ICC profiles
# Bug Class: Profile Bleed | https://srd.cx/cve-2022-26730
#
#
#
*/

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

#include <cassert>
#include <stdio.h>
#include <cstring>

#include <time.h>
#include "IccDefs.h"
#include "IccProfile.h"
#include "IccUtil.h"
#include "IccTagBasic.h"
#include "IccTagMPE.h"
#include "IccTagXml.h"
#include "IccProfLibVer.h"
#include "IccLibXMLVer.h"
#include "IccSignatureUtils.h"

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

       fprintf(stderr, "\nLittle ICC Scanner demonstrates a toolchain for measurement and analysis of ICC Profiles.\n");

       fprintf(stderr, "\n");
       fprintf(stderr, "usage: licc [flags] <profile>\n\n");
       fprintf(stderr, "flags:\n\n");
       fprintf(stderr, "%cv<level> - Verbosity level\n", SW);

       fprintf(stderr,
           "\n"
           "Little ICC Scanner demonstrates a toolchain for measurement and analysis of ICC Profiles.\n"
           "\n");


       return 0;
}


static
char* sig2char(int sig)
{
    static char str[5];

    str[0] = (char)((cmsUInt32Number)(sig & 0xff000000) >> 24);
    str[1] = (char)((cmsUInt32Number)(sig & 0x00ff0000) >> 16);
    str[2] = (char)((cmsUInt32Number)(sig & 0x0000ff00) >> 8);
    str[3] = (char)((cmsUInt32Number)(sig & 0x000000ff));
    str[4] = '\0';

//    ICC_LOG_DEBUG("sig2char(): sig=0x%08x → '%s'", (cmsUInt32Number)sig, str);
    return str;
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
cmsInt32Number ForwardSampler(const cmsUInt16Number In[], cmsUInt16Number Out[], void* Cargo)
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
cmsInt32Number ReverseSampler(const cmsUInt16Number In[], cmsUInt16Number Out[], void* Cargo)
{
    FakeCMYKParams* p = (FakeCMYKParams*)Cargo;
    cmsFloat64Number c, m, y, k;
    cmsFloat64Number rgb[3];

    c = In[0] / 65535.0;
    m = In[1] / 65535.0;
    y = In[2] / 65535.0;
    k = In[3] / 65535.0;

    if (k == 0.0) {
        rgb[0] = Clip(1.0 - c);
        rgb[1] = Clip(1.0 - m);
        rgb[2] = Clip(1.0 - y);
    }
    else if (k == 1.0) {
        rgb[0] = rgb[1] = rgb[2] = 0.0;
    }
    else {
        rgb[0] = Clip((1.0 - c) * (1.0 - k));
        rgb[1] = Clip((1.0 - m) * (1.0 - k));
        rgb[2] = Clip((1.0 - y) * (1.0 - k));
    }

    cmsDoTransform(p->sRGB2Lab, rgb, Out, 1);
    return 1;
}

// Replacement for internal LCMS identity curve allocator
static
cmsStage* StageAllocIdentityCurves(int nChannels)
{
    cmsToneCurve* curves[16];
    if (nChannels > 16) return NULL;

    for (int i = 0; i < nChannels; ++i)
        curves[i] = cmsBuildGamma(NULL, 1.0);

    cmsStage* stage = cmsStageAllocToneCurves(NULL, nChannels, curves);

    // Free each tone curve after stage creation
    for (int i = 0; i < nChannels; ++i)
        cmsFreeToneCurve(curves[i]);

    return stage;
}

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
       if (BToA0 == NULL)
           return NULL;

       CLUT = cmsStageAllocCLut16bit(0, 17, 3, 4, NULL);
       cmsStage* preLutBToA = StageAllocIdentityCurves(3);
       cmsStage* postLutBToA = StageAllocIdentityCurves(4);

       if (!CLUT || !preLutBToA || !postLutBToA) {
           if (CLUT) cmsStageFree(CLUT);
           if (preLutBToA) cmsStageFree(preLutBToA);
           if (postLutBToA) cmsStageFree(postLutBToA);
           cmsPipelineFree(BToA0); // 🧼 prevent leak
           return NULL;
       }

       if (!cmsStageSampleCLut16bit(CLUT, ForwardSampler, &p, 0)) {
           cmsStageFree(CLUT);
           cmsStageFree(preLutBToA);
           cmsStageFree(postLutBToA);
           cmsPipelineFree(BToA0); // 🧼 prevent leak
           return NULL;
       }

       cmsPipelineInsertStage(BToA0, cmsAT_BEGIN, preLutBToA);
       cmsPipelineInsertStage(BToA0, cmsAT_END, CLUT);
       cmsPipelineInsertStage(BToA0, cmsAT_END, postLutBToA);

       if (!cmsWriteTag(hICC, cmsSigBToA0Tag, (void*)BToA0)) {
           cmsPipelineFree(BToA0);
           return NULL;
       }
       cmsPipelineFree(BToA0);


       // AToB0
       AToB0 = cmsPipelineAlloc(0, 4, 3);
       if (!AToB0)
           return NULL;

       CLUT = cmsStageAllocCLut16bit(0, 17, 4, 3, NULL);
       cmsStage* preLutAToB = StageAllocIdentityCurves(4);
       cmsStage* postLutAToB = StageAllocIdentityCurves(3);

       if (!CLUT || !preLutAToB || !postLutAToB) {
           if (CLUT) cmsStageFree(CLUT);
           if (preLutAToB) cmsStageFree(preLutAToB);
           if (postLutAToB) cmsStageFree(postLutAToB);
           cmsPipelineFree(AToB0);
           return NULL;
       }

       if (!cmsStageSampleCLut16bit(CLUT, ReverseSampler, &p, 0)) {
           cmsStageFree(CLUT);
           cmsStageFree(preLutAToB);
           cmsStageFree(postLutAToB);
           cmsPipelineFree(AToB0);
           return NULL;
       }

       cmsPipelineInsertStage(AToB0, cmsAT_BEGIN, preLutAToB);
       cmsPipelineInsertStage(AToB0, cmsAT_END, CLUT);
       cmsPipelineInsertStage(AToB0, cmsAT_END, postLutAToB);

       if (!cmsWriteTag(hICC, cmsSigAToB0Tag, (void*)AToB0)) {
           cmsPipelineFree(AToB0);
           return NULL;
       }
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

static void PrintTimestamp(FILE* stream)
{
    time_t now = time(NULL);
    struct tm *t = localtime(&now);
    if (t) {
        fprintf(stream, "[%04d-%02d-%02d %02d:%02d:%02d] ",
                t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
                t->tm_hour, t->tm_min, t->tm_sec);
    }
}

static
void MyErrorLogHandler(cmsContext ContextID, cmsUInt32Number ErrorCode, const char* Text)
{
    ErrorState = TRUE;

    if (!AlreadyReported && Verbose > 0) {
        if (ErrorCode == cmsERROR_CORRUPTION_DETECTED) {
            ICC_LOG_WARNING("[HEURISTIC] Phase='%s' Detail='%s'", TryingPhase, Text);
            TRACE_CALLER();
            PossibleExploit = TRUE;
        }
        else {
            ICC_LOG_ERROR("[ERROR] Phase='%s' Detail='%s'", TryingPhase, Text);
        }
        AlreadyReported = TRUE;
    }

    if (Verbose > 1) {
        ICC_LOG_INFO("[INFO] Phase='%s' Msg='%s'", TryingPhase, Text);
    }

    UNUSED_PARAMETER(ContextID);
}


// Check a transformation by converting it to a device link (forces evaluation)
static
void CheckTransform(cmsHTRANSFORM xform)
{
    if (!xform) {
        ICC_LOG_ERROR("CheckTransform() called with null transform");
        TRACE_CALLER();
        ErrorState = TRUE;
        AlreadyReported = TRUE;
        return;
    }

    // Validate transform integrity before use
    cmsUInt32Number inFmt = cmsGetTransformInputFormat(xform);
    cmsUInt32Number outFmt = cmsGetTransformOutputFormat(xform);
    if ((inFmt == 0) || (outFmt == 0)) {
        ICC_LOG_ERROR("cmsTransform integrity check failed: input=0x%x, output=0x%x", inFmt, outFmt);
        TRACE_CALLER();
        ErrorState = TRUE;
        AlreadyReported = TRUE;
        cmsDeleteTransform(xform);
        return;
    }

    cmsHPROFILE hICC = cmsTransform2DeviceLink(xform, 2.1, 0);
    if (hICC) {
        cmsCloseProfile(hICC);
    } else {
        ICC_LOG_ERROR("Transform2DeviceLink(2.1) failed (Phase='%s')", TryingPhase);
        TRACE_CALLER();
        ErrorState = TRUE;
        AlreadyReported = TRUE;
    }

    hICC = cmsTransform2DeviceLink(xform, 4.1, 0);
    if (hICC) {
        cmsCloseProfile(hICC);
    } else {
        ICC_LOG_ERROR("Transform2DeviceLink(4.1) failed (Phase='%s')", TryingPhase);
        TRACE_CALLER();
        ErrorState = TRUE;
        AlreadyReported = TRUE;
    }
}


static
void checkOneIntentRGB(cmsHPROFILE hProfile, cmsUInt32Number intent)
{
    cmsHTRANSFORM xform = NULL;

    static const char* ForwardTextPhase[] = {
        "input perceptual RGB (AtoB0)",
        "input rel.col RGB (AtoB1)",
        "input saturation RGB (AtoB2)"
    };

    static const char* ReverseTextPhase[] = {
        "output perceptual RGB (BtoA0)",
        "output rel.col RGB (BtoA1)",
        "output saturation RGB (BtoA2)"
    };

    static const cmsTagSignature AToBTags[] = {
        cmsSigAToB0Tag, cmsSigAToB1Tag, cmsSigAToB2Tag
    };

    static const cmsTagSignature BToATags[] = {
        cmsSigBToA0Tag, cmsSigBToA1Tag, cmsSigBToA2Tag
    };

    if (intent < INTENT_PERCEPTUAL || intent > INTENT_SATURATION) {
        ICC_LOG_WARNING("Unsupported rendering intent: %u", intent);
        return;
    }

    // --------- FORWARD TRANSFORM (profile → sRGB) ---------
    TryingPhase = ForwardTextPhase[intent];

    CIccProfile iccParsed;
    CIccFileIO io;

    bool hasAToB = cmsIsTag(hProfile, AToBTags[intent]);
    bool iccParsedOK = io.Open(ProfileName, "rb") && iccParsed.Read(&io);
    bool hasAToB_ICC = iccParsedOK && (iccParsed.FindTag(AToBTags[intent]) != nullptr);
    io.Close();

    if (!hasAToB || !hasAToB_ICC) {
        ICC_LOG_INFO("Skipping forward transform: missing or unparseable tag %s", sig2char(AToBTags[intent]));
    } else {
        ICC_LOG_DEBUG("Creating forward RGB transform: intent=%u [%s]", intent, TryingPhase);

        cmsColorSpaceSignature cs = cmsGetColorSpace(hProfile);
        if (cs != cmsSigRgbData) {
            ICC_LOG_ERROR("Profile ColorSpace='%s' does not support RGB transform", sig2char(cs));
            return;
        }

        xform = cmsCreateTransform(hProfile, TYPE_RGB_16, hsRGB, TYPE_RGB_16, intent, cmsFLAGS_KEEP_SEQUENCE);

        if (xform) {
            cmsUInt32Number inFmt = cmsGetTransformInputFormat(xform);
            cmsUInt32Number outFmt = cmsGetTransformOutputFormat(xform);

            if (inFmt != 0 && outFmt != 0) {
                CheckTransform(xform);
            } else {
                ICC_LOG_ERROR("cmsCreateTransform() returned corrupted transform (forward intent=%u): inFmt=0x%x, outFmt=0x%x", intent, inFmt, outFmt);
                TRACE_CALLER();
            }

            cmsDeleteTransform(xform);
        } else {
            ICC_LOG_ERROR("Forward RGB transform creation failed (intent=%u, tag=%s)", intent, sig2char(AToBTags[intent]));
            TRACE_CALLER();
        }
    }

    // --------- REVERSE TRANSFORM (sRGB → profile) ---------
    TryingPhase = ReverseTextPhase[intent];

    bool hasBToA = cmsIsTag(hProfile, BToATags[intent]);
    bool hasBToA_ICC = iccParsedOK && (iccParsed.FindTag(BToATags[intent]) != nullptr);

    if (!hasBToA || !hasBToA_ICC) {
        ICC_LOG_INFO("Skipping reverse transform: missing or unparseable tag %s", sig2char(BToATags[intent]));
    } else {
        ICC_LOG_DEBUG("Creating reverse RGB transform: intent=%u [%s]", intent, TryingPhase);

        xform = cmsCreateTransform(hsRGB, TYPE_RGB_16, hProfile, TYPE_RGB_16, intent, cmsFLAGS_KEEP_SEQUENCE);

        if (!xform) {
            ICC_LOG_ERROR("Reverse RGB transform creation failed (intent=%u, tag=%s)", intent, sig2char(BToATags[intent]));
            TRACE_CALLER();
            return;
        }

        cmsUInt32Number inFmt = cmsGetTransformInputFormat(xform);
        cmsUInt32Number outFmt = cmsGetTransformOutputFormat(xform);

        if (!inFmt || !outFmt || (inFmt & 0xFFFF) == 0 || (outFmt & 0xFFFF) == 0) {
            ICC_LOG_ERROR("cmsCreateTransform() returned unusable reverse transform: inFmt=0x%x, outFmt=0x%x", inFmt, outFmt);
            TRACE_CALLER();
        } else {
            CheckTransform(xform);
        }

        cmsDeleteTransform(xform);
    }
}



static
void checkOneIntentCMYK(cmsHPROFILE hProfile, cmsUInt32Number intent)
{
    cmsHTRANSFORM xform;
    static const char* ForwardTextPhase[] = {
        "input perceptual CMYK (AtoB0)",
        "input rel.col CMYK (AtoB1)",
        "input saturation CMYK (AtoB2)"
    };
    static const char* ReverseTextPhase[] = {
        "output perceptual CMYK (BtoA0)",
        "output rel.col CMYK (BtoA1)",
        "output saturation CMYK (BtoA2)"
    };

    if (intent >= INTENT_PERCEPTUAL && intent <= INTENT_SATURATION) {

        // Forward
        TryingPhase = ForwardTextPhase[intent];
        ICC_LOG_DEBUG("Creating forward CMYK transform: intent=%u [%s]", intent, TryingPhase);
        xform = cmsCreateTransform(hProfile, TYPE_CMYK_16, hCMYK, TYPE_CMYK_16, intent, cmsFLAGS_KEEP_SEQUENCE);
        if (xform) {
            CheckTransform(xform);
            cmsDeleteTransform(xform);
        }
        else {
            ICC_LOG_WARNING("Forward CMYK transform creation failed (intent=%u)", intent);
            TRACE_CALLER();
        }

        // Reverse
        TryingPhase = ReverseTextPhase[intent];
        ICC_LOG_DEBUG("Creating reverse CMYK transform: intent=%u [%s]", intent, TryingPhase);
        xform = cmsCreateTransform(hCMYK, TYPE_CMYK_16, hProfile, TYPE_CMYK_16, intent, cmsFLAGS_KEEP_SEQUENCE);
        if (xform) {
            CheckTransform(xform);
            cmsDeleteTransform(xform);
        }
        else {
            ICC_LOG_WARNING("Reverse CMYK transform creation failed (intent=%u)", intent);
            TRACE_CALLER();
        }
    }
    else {
        ICC_LOG_WARNING("Unsupported rendering intent: %u", intent);
    }
}


static
void checkAllIntents(cmsHPROFILE hProfile)
{
    cmsColorSpaceSignature cs = cmsGetColorSpace(hProfile);
    cmsProfileClassSignature dc = cmsGetDeviceClass(hProfile);
    const char* cs_str = sig2char(cs);
    const char* dc_str = sig2char(dc);

    // Log basic profile metadata
    PrintTimestamp(stderr);
    ICC_LOG_INFO("DeviceClass='%s' ColorSpace='%s'", dc_str, cs_str);

    // Check if device class is supported
    if (!(dc == cmsSigInputClass ||
        dc == cmsSigDisplayClass ||
        dc == cmsSigOutputClass ||
        dc == cmsSigColorSpaceClass))
    {
        Bypass = TRUE;
        PrintTimestamp(stderr);
        ICC_LOG_WARNING("Skipping unsupported DeviceClass='%s'\n", dc_str);
        Message("*** Bypassing this profile because unsupported device class '%s'\n", dc_str);
        return;
    }

    // Route to appropriate intent tester
    if (cs == cmsSigRgbData) {
        ICC_LOG_DEBUG("Dispatching to RGB transform checks");
        checkOneIntentRGB(hProfile, INTENT_PERCEPTUAL);
        checkOneIntentRGB(hProfile, INTENT_RELATIVE_COLORIMETRIC);
        checkOneIntentRGB(hProfile, INTENT_SATURATION);
    }
    else if (cs == cmsSigCmykData) {
        ICC_LOG_DEBUG("Dispatching to CMYK transform checks");
        checkOneIntentCMYK(hProfile, INTENT_PERCEPTUAL);
        checkOneIntentCMYK(hProfile, INTENT_RELATIVE_COLORIMETRIC);
        checkOneIntentCMYK(hProfile, INTENT_SATURATION);
    }
    else {
        Bypass = TRUE;
        PrintTimestamp(stderr);
        ICC_LOG_WARNING("Skipping unsupported ColorSpace='%s'", cs_str);
        Message("*** Bypassing this profile because unsupported Color Space '%s'\n", cs_str);
        return;
    }

    // Report scan result
    if (PossibleExploit) {
        Message("*** WARNING: Profile may contain matching heuristics\n");
        ICC_LOG_WARNING("Heuristic match indicator flagged\n");
    }
    else if (ErrorState) {
        Message("*** WARNING: Profile has errors");
        ICC_LOG_WARNING("Profile failed validation with known errors\n");
    }
}



static
void checkInfo(cmsHPROFILE h, cmsInfoType Info)
{
    const char* label;
    char* text;
    int len;

    // Label for current info type
    switch (Info) {
    case cmsInfoDescription:   label = "Description"; break;
    case cmsInfoManufacturer:  label = "Manufacturer"; break;
    case cmsInfoModel:         label = "Model"; break;
    case cmsInfoCopyright:     label = "Copyright"; break;
    default:                   label = "Unknown"; break;
    }

    TryingPhase = label;
    len = cmsGetProfileInfoASCII(h, Info, "en", "US", NULL, 0);

    if (len <= 0)
        return;

    if (len > 10 * 1024) {
        PossibleExploit = TRUE;
        PrintTimestamp(stderr);
        fprintf(stderr, "[HEURISTIC] Phase='Info[%s]' Detail='Excessive text length (%d bytes)'\n", label, len);
        return;
    }

    text = (char*)malloc(len);
    if (!text) {
        PrintTimestamp(stderr);
        fprintf(stderr, "[ERROR]   Phase='Info[%s]' Detail='malloc failed for %d bytes'\n", label, len);
        ErrorState = TRUE;
        return;
    }

    if (cmsGetProfileInfoASCII(h, Info, "en", "US", text, len) > 0) {
        if (Verbose > 1) {
            PrintTimestamp(stderr);
            fprintf(stderr, "[INFO]    Phase='Info[%s]' Value='%s'\n", label, text);
        }
    }

    free(text);
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
void checkProfileInformation(cmsHPROFILE h)
{
    cmsCIEXYZ* wp = NULL;
    cmsUInt32Number version = cmsGetProfileVersion(h);
    cmsUInt32Number intent = cmsGetHeaderRenderingIntent(h);
    cmsUInt8Number id[16] = { 0 };
    cmsGetHeaderProfileID(h, id);

CIccInfo Fmt;
CIccProfile icc;
CIccFileIO file;
if (!file.Open(ProfileName, "rb") || !icc.Read(&file)) {
    ICC_LOG_ERROR("Failed to open ICC profile using ICCMAX stack: %s", ProfileName);
    return;
}
icHeader* pHdr = &icc.m_Header;
char buf[64];

if (Fmt.IsProfileIDCalculated(&pHdr->profileID)) {
    printf("Profile ID:         %s\n", Fmt.GetProfileID(&pHdr->profileID));
} else {
    printf("Profile ID:         Profile ID not calculated.\n");
}

printf("Size:               %u (0x%X) bytes\n",
       (unsigned)pHdr->size, (unsigned)pHdr->size);

printf("\nHeader\n");
printf("------\n");

printf("Attributes:         %s\n", Fmt.GetDeviceAttrName(pHdr->attributes));

// -------------------------------
// CMM Signature Check
// -------------------------------
if (pHdr->cmmId >= 0x20202020 && pHdr->cmmId <= 0x7A7A7A7A) {
    printf("Cmm:                %s\n", Fmt.GetCmmSigName((icCmmSignature)pHdr->cmmId));
} else {
    printf("Cmm:                InvalidCmm (0x%08X)\n", (unsigned)pHdr->cmmId);
}

// -------------------------------
// Date
// -------------------------------
printf("Creation Date:      %d/%d/%d (M/D/Y)  %02u:%02u:%02u\n",
       pHdr->date.month, pHdr->date.day, pHdr->date.year,
       pHdr->date.hours, pHdr->date.minutes, pHdr->date.seconds);

// -------------------------------
// Creator / Manufacturer Tags
// -------------------------------
// char buf[64] = {0};

printf("Creator:            %s\n", icGetSig(buf, pHdr->creator));
printf("Device Manufacturer:%s\n", icGetSig(buf, pHdr->manufacturer));

// ------------------------------
// ICC HEADER FUZZ DIAGNOSTICS
// ------------------------------

uint8_t sentinelBlock[32];
memset(sentinelBlock, 0xEE, sizeof(sentinelBlock)); // Fill with marker before parsing

// Trace: CMM Signature field
ICC_TRACE_INPUT_FIELD("cmmId", offsetof(icHeader, cmmId), &pHdr->cmmId, 4);

// Trace: Expected ICC Magic 'acsp' at offset 0x24 (36)
ICC_TRACE_INPUT_FIELD("magic", 0x24, ((uint8_t*)pHdr) + 0x24, 4);
uint8_t expectedMagic[4] = { 'a', 'c', 's', 'p' };
ICC_IIB_TAG_GUARD("Profile Magic", ((uint8_t*)pHdr) + 0x24, 4, expectedMagic);

// Dirty Write Detection: Copy 32 bytes after header to compare against sentinel
memcpy(sentinelBlock, ((uint8_t*)pHdr) + 0x50, sizeof(sentinelBlock));
for (size_t idx = 0; idx < sizeof(sentinelBlock); ++idx) {
  ICC_DIRTY_WRITE_CHECK("HeaderPad", sentinelBlock, idx, sizeof(sentinelBlock), 0xEE);
}

// Trace: Manufacturer field
ICC_TRACE_INPUT_FIELD("manufacturer", offsetof(icHeader, manufacturer), &pHdr->manufacturer, 4);

// Signature Evaluation: Color space decoding
uint32_t sigTest = pHdr->colorSpace;
DebugColorSpaceMeta(sigTest);          // Logs name, raw bytes, known status
ICC_SANITY_CHECK_SIGNATURE(sigTest, "colorSpaceSignature");

// -------------------------------
// PCS Color Space
// -------------------------------
switch (pHdr->pcs) {
  case icSigLabData:
  case icSigXYZData:
    printf("PCS Color Space:    %s\n", Fmt.GetColorSpaceSigName(pHdr->pcs));
    break;
  default:
    printf("PCS Color Space:    InvalidPCS (0x%08X)\n", (unsigned)pHdr->pcs);
    break;
}

// -------------------------------
// Data Color Space
// -------------------------------
printf("Data Color Space:   %s\n", Fmt.GetColorSpaceSigName(pHdr->colorSpace));

// -------------------------------
// Profile Flags
// -------------------------------
printf("Flags:              %s\n", Fmt.GetProfileFlagsName(pHdr->flags));

// Platform Signature (strict enum validation to prevent UBSan fault)
icUInt32Number platformValue;
memcpy(&platformValue, &pHdr->platform, sizeof(icUInt32Number));
printf("Raw Platform Value: 0x%08X\n", platformValue);


const char *platformName = nullptr;
icUInt32Number rawPlatform;
memcpy(&rawPlatform, &pHdr->platform, sizeof(icUInt32Number));
if (rawPlatform == 0x4150504C)      // 'APPL'
  platformName = "Macintosh";
else if (rawPlatform == 0x4D534654) // 'MSFT'
  platformName = "Microsoft";
else if (rawPlatform == 0x53554E20) // 'SUN '
  platformName = "Solaris";
else if (rawPlatform == 0x53474920) // 'SGI '
  platformName = "SGI";
else if (rawPlatform == 0x54474C20) // 'TGL '
  platformName = "Taligent";
else if (rawPlatform == 0x00000000) // icSigUnknownPlatform
  platformName = "Unknown";


if (platformName)
  printf("Platform:           %s\n", platformName);
else
  printf("Platform:           UnknownPlatformSig (0x%08X)\n", rawPlatform);

// Rendering Intent (range: 0–3)
if (pHdr->renderingIntent <= icAbsoluteColorimetric)
    printf("Rendering Intent:   %s\n", Fmt.GetRenderingIntentName((icRenderingIntent)pHdr->renderingIntent));
else
    printf("Rendering Intent:   InvalidIntent (%u)\n", (unsigned)pHdr->renderingIntent);

// Profile Class (basic signature range check)
printf("Profile Class:      %s\n", Fmt.GetProfileClassSigName(pHdr->deviceClass));

if (pHdr->deviceSubClass)
    printf("Profile SubClass:   %s\n", icGetSig(buf, pHdr->deviceSubClass));
else
    printf("Profile SubClass:   Not Defined\n");

printf("Version:            %s\n", Fmt.GetVersionName(pHdr->version));

if (pHdr->version >= icVersionNumberV5 && pHdr->deviceSubClass)
    printf("SubClass Version:   %s\n", Fmt.GetSubClassVersionName(pHdr->version));

printf("Illuminant:         X=%.4lf, Y=%.4lf, Z=%.4lf\n",
       icFtoD(pHdr->illuminant.X),
       icFtoD(pHdr->illuminant.Y),
       icFtoD(pHdr->illuminant.Z));

// Spectral PCS (let it pass, log if garbage)
printf("Spectral PCS:       %s\n", Fmt.GetSpectralColorSigName(pHdr->spectralPCS));

if (pHdr->spectralRange.start || pHdr->spectralRange.end || pHdr->spectralRange.steps)
    printf("Spectral PCS Range: start=%.1fnm, end=%.1fnm, steps=%d\n",
           icF16toF(pHdr->spectralRange.start),
           icF16toF(pHdr->spectralRange.end),
           pHdr->spectralRange.steps);
else
    printf("Spectral PCS Range: Not Defined\n");

if (pHdr->biSpectralRange.start || pHdr->biSpectralRange.end || pHdr->biSpectralRange.steps)
    printf("BiSpectral Range:     start=%.1fnm, end=%.1fnm, steps=%d\n",
           icF16toF(pHdr->biSpectralRange.start),
           icF16toF(pHdr->biSpectralRange.end),
           pHdr->biSpectralRange.steps);
else
    printf("BiSpectral Range:   Not Defined\n");

if (pHdr->mcs)
    printf("MCS Color Space:    %s\n", Fmt.GetColorSpaceSigName((icColorSpaceSignature)pHdr->mcs));
else
    printf("MCS Color Space:    Not Defined\n");


printf("\niccMAX Profile Tags\n");
printf("------------\n");

printf("%28s    ID    %8s\t%8s\t%8s\n", "Tag", "Offset", "Size", "Pad");
printf("%28s  ------  %8s\t%8s\t%8s\n", "----", "------", "----", "---");
printf("------------\n");

fprintf(stderr, "\nLittle CMS Outputs\n");
fprintf(stderr, "Version:            %d.%02d\n", (version >> 16) & 0xff, (version >> 8) & 0xff);

    fprintf(stderr, "Rendering Intent:   %s\n",
        intent == INTENT_PERCEPTUAL ? "Perceptual" :
        intent == INTENT_RELATIVE_COLORIMETRIC ? "Relative Colorimetric" :
        intent == INTENT_SATURATION ? "Saturation" :
        intent == INTENT_ABSOLUTE_COLORIMETRIC ? "Absolute Colorimetric" :
        "Unknown");

    // Optional white point info
    if (cmsIsTag(h, cmsSigMediaWhitePointTag)) {
        wp = (cmsCIEXYZ*)cmsReadTag(h, cmsSigMediaWhitePointTag);
        if (wp) {
            fprintf(stderr, "Media White Point:  X=%.4f Y=%.4f Z=%.4f\n", wp->X, wp->Y, wp->Z);
        }
    }

    fprintf(stderr, "\nProfile Tags\n");
    fprintf(stderr, "------------\n");
    fprintf(stderr, "%28s    ID    %8s\t%8s\t%8s\n", "Tag", "Offset", "Size", "Pad");
    fprintf(stderr, "%28s  ------  %8s\t%8s\t%8s\n", "----", "------", "----", "---");

    // Enumerate tags — LCMS doesn't expose offset/size/pad directly
    for (int i = 0; i < cmsGetTagCount(h); ++i) {
        cmsTagSignature sig = cmsGetTagSignature(h, i);
        const char* tagSigStr = sig2char(sig);
        fprintf(stderr, "%28s  %s  %8s\t%8s\t%8s\n", tagSigStr, tagSigStr, "-", "-", "-");
    }

    fprintf(stderr, "\n");

    // Dump known textual fields (with exploit checks)
    checkInfo(h, cmsInfoDescription);
    checkInfo(h, cmsInfoManufacturer);
    checkInfo(h, cmsInfoModel);
    checkInfo(h, cmsInfoCopyright);

    // Check optional colorant tables
    checkColorantTable(h, cmsSigColorantTableTag, "Input colorant table");
    checkColorantTable(h, cmsSigColorantTableOutTag, "Output colorant table");
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
                fprintf(stderr, "\n============================\n");
                fprintf(stderr, "Profile:           '%s'\n", ProfileName);


                hProfile = cmsOpenProfileFromFile(ProfileName, "r");

                if (hProfile != NULL) {
                    checkProfileInformation(hProfile);
                    checkAllIntents(hProfile);
                    cmsCloseProfile(hProfile);
                } else {
                    Message("This file is not recognized as a valid ICC profile");
                }

                if (!ErrorState && !Bypass)
                    fprintf(stderr, "Validation Result: Ok\n\n");
                else
                    fprintf(stderr, "\nValidation Result: Issues detected\n\n");

            }
        }
    }

    closedir(d);
}

static
cmsBool IsRoundTripable(CIccProfile* pIcc)
{
    ICC_LOG_INFO("IsRoundTripable(): Entry point reached.");
    icHeader* pHdr = &pIcc->m_Header;
    ICC_LOG_INFO("IsRoundTripable(): Checking profile with deviceClass=0x%08x", pHdr->deviceClass);

    if (pHdr->deviceClass == icSigLinkClass) {
        ICC_LOG_INFO("IsRoundTripable(): Profile is DeviceLink. Not roundtripable.");
        return FALSE;
    }

    cmsBool hasAToB0 = pIcc->FindTag(icSigAToB0Tag) != NULL;
    cmsBool hasBToA0 = pIcc->FindTag(icSigBToA0Tag) != NULL;
    cmsBool hasAToB1 = pIcc->FindTag(icSigAToB1Tag) != NULL;
    cmsBool hasBToA1 = pIcc->FindTag(icSigBToA1Tag) != NULL;
    cmsBool hasAToB2 = pIcc->FindTag(icSigAToB2Tag) != NULL;
    cmsBool hasBToA2 = pIcc->FindTag(icSigBToA2Tag) != NULL;

    cmsBool hasDToB0 = pIcc->FindTag(icSigDToB0Tag) != NULL;
    cmsBool hasBToD0 = pIcc->FindTag(icSigBToD0Tag) != NULL;
    cmsBool hasDToB1 = pIcc->FindTag(icSigDToB1Tag) != NULL;
    cmsBool hasBToD1 = pIcc->FindTag(icSigBToD1Tag) != NULL;
    cmsBool hasDToB2 = pIcc->FindTag(icSigDToB2Tag) != NULL;
    cmsBool hasBToD2 = pIcc->FindTag(icSigBToD2Tag) != NULL;

    cmsBool hasMatrix =
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
        return TRUE;
    }

    ICC_LOG_INFO("IsRoundTripable(): No qualifying tag pairs found.");
    return FALSE;
}


int main(int argc, char* argv[])
{
    int nargs;
    int exitCode = 0;
    struct stat path_stat;
    const char* inputPath;

    // ---- Version & attribution banner ----
    fprintf(stderr,
        "\n"
        "ICC Profile Scanner v.01 [LittleCMS %.2f, IccProfLib %s, IccLibXML %s]\n"
        "Copyright (c) 2022-2025 David H Hoyt LLC - IccSignatureUtilities.h\n"
        "Copyright (c) 1998-2015 Marti Maria Saguer - Little CMS2 Library\n"
        "Copyright (c) 2003-2025 International Color Consortium - iccMAX Library\n"
        "\n"
        "\n",
        LCMS_VERSION / 1000.0,
        ICCPROFLIBVER,
        ICCLIBXMLVER);

    // ---- Register error logger ----
    cmsSetLogErrorHandler(MyErrorLogHandler);
    ICC_LOG_INFO("Logger initialized. Starting argument parse.");

    // ---- Parse command line switches ----
    HandleSwitches(argc, argv);
    nargs = argc - xoptind;

    if (nargs < 1)
        return Help();

    inputPath = argv[xoptind];
    ICC_LOG_INFO("Input path: %s", inputPath);

    // ---- Create system profiles ----
    hsRGB = cmsCreate_sRGBProfile();
    hCMYK = CreateFakeCMYK(350);
    if (!hsRGB || !hCMYK) {
        ICC_LOG_ERROR("System profile creation failed.");
        FatalError("Failed to initialize base profiles (sRGB or CMYK).");
    }

    // ---- Stat the path and dispatch ----
    if (stat(inputPath, &path_stat) != 0) {
        perror("stat failed");
        ICC_LOG_ERROR("stat() failed for path: %s", inputPath);
        Message("Unable to access path: %s", inputPath);
        exitCode = 2;
        goto cleanup;
    }

    if (S_ISDIR(path_stat.st_mode)) {
        ICC_LOG_INFO("Input is a directory. Beginning recursive scan.");
        checkDir(inputPath);
    }
    else {
        PossibleExploit = FALSE;
        ErrorState = FALSE;
        AlreadyReported = FALSE;
        Bypass = FALSE;

        strncpy(ProfileName, inputPath, sizeof(ProfileName) - 1);
        ProfileName[sizeof(ProfileName) - 1] = '\0';  // Ensure null-termination
        TryingPhase = "parsing profile";

        fprintf(stderr, "\n============================\n");
        fprintf(stderr, "Profile:           '%s'\n", ProfileName);

        cmsHPROFILE hProfile = cmsOpenProfileFromFile(ProfileName, "r");
        if (!hProfile) {
            ICC_LOG_WARNING("cmsOpenProfileFromFile() failed. Profile not valid ICC: %s", ProfileName);
            Message("This file is not recognized as a valid ICC profile");
            exitCode = 3;
            goto cleanup;
        }

       CIccProfile iccMax;
       CIccFileIO fileIO;
       if (fileIO.Open(ProfileName, "rb") && iccMax.Read(&fileIO)) {
           if (IsRoundTripable(&iccMax)) {
               ICC_LOG_INFO("Round-trip check: PASS");
           } else {
               ICC_LOG_WARNING("Round-trip check: FAIL");
           }
           fileIO.Close();
       } else {
           ICC_LOG_WARNING("CIccProfile::Read() failed for %s", ProfileName);
       }

        ICC_LOG_INFO("Profile opened successfully.");
        checkProfileInformation(hProfile);
        checkAllIntents(hProfile);
        cmsCloseProfile(hProfile);

        if (!ErrorState && !Bypass) {
            fprintf(stderr, "Validation Result: Ok\n\n");
            ICC_LOG_INFO("Validation passed.");
        }
        else {
            fprintf(stderr, "Validation Result: Issues detected\n\n");
            ICC_LOG_WARNING("Validation issues present in profile.");
            exitCode = 4;
        }
    }

cleanup:
    cmsCloseProfile(hsRGB);
    cmsCloseProfile(hCMYK);
    ICC_LOG_INFO("Execution complete with exitCode=%d", exitCode);
    return exitCode;
}
