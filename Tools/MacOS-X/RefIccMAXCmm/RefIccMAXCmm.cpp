/** @file
    File:       RefIccMAXCmm.cpp

    Contains:   RefIccMAX CMM Component for ColorSync 2.x

    Version:    V1

    Copyright:  © see ICC Software License
*/

/*
 * The ICC Software License, Version 0.2
 *
 *
 * Copyright (c) 2003-2015 The International Color Consortium. All rights 
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


#include <ApplicationServices/ApplicationServices.h>
#include <math.h>
#include <pthread.h>
#include "IccProfile.h"
#include "IccCmm.h"


CIccProfile* getIccProfLibProfileFromColorsyncProfile(CMProfileRef pref);

typedef void (*MatchOneProc) (UInt16* chan);


// Component storage
typedef struct
{
    OSType              srcSpace;
    OSType              srcClass;
    OSType              dstSpace;
    OSType              dstClass;
    MatchOneProc        proc;
	CIccCmm*			cmm;
} CMMStorageRec, *CMMStoragePtr;


// Match stuff
typedef struct
{
    UInt32              height;
    UInt32              width;
    
    UInt8*              srcBuf[4];
    UInt32              srcChanBits;
    UInt32              srcRowBytes;
    UInt32              srcColBytes;
    Boolean             srcSwap;
    
    UInt8*              dstBuf[4];
    UInt32              dstChanBits;
    UInt32              dstRowBytes;
    UInt32              dstColBytes;
    Boolean             dstSwap;
    
} CMMMatchRec;



#pragma mark -


#define DoubToUInt16(x)     (((x)<=0.0)?(0):(((x)>=1.0)?(65535):((x)*65535.0 + 0.5)))
#define UInt16ToDoub(x)     ((double)(x)/65535.0)
#define DoubToFract(x)      (((x)<=0.0)?(0):(((x)>=2.0)?(65535):((x)*32768.0 + 0.5)))
#define FractToDoub(x)      ((double)(x)/32768.0)
#define UInt16ToFract(x)    ((x)>>1)
#define FractToUInt16(x)    ((x)<<1)


#if DO_DEBUGCOLOR
static void
DebugColor4( UInt16* color)
{
    char            s[] = " 0xXXXX, 0xXXXX, 0xXXXX, 0xXXXX\n";
    char*           c = &(s[3]);
    int             i;
    int             v;
    
    for (i=0; i<4; i++)
    {
        v = (((*color)>>12) & 0x000F);  *c++ = (v<10) ? (v+'0') : (v+'A'-10);
        v = (((*color)>>8) & 0x000F);   *c++ = (v<10) ? (v+'0') : (v+'A'-10);
        v = (((*color)>>4) & 0x000F);   *c++ = (v<10) ? (v+'0') : (v+'A'-10);
        v = (((*color)) & 0x000F);      *c++ = (v<10) ? (v+'0') : (v+'A'-10);
        c += 4;
        color++;
    }
    
    fprintf(stderr, s);
}
#endif


//--------------------------------------------------------------------- DoMatch             
//  Simple conversion of a bunch or colors.
//---------------------------------------------------------------------

static void
DoMatch (CMMStoragePtr storage, CMMMatchRec* pMatchInfo)
{
    UInt32              r,c;
    float              chanIn[16];
	float              chanOut[16];
    UInt8**             sBuf;
    UInt8**             dBuf;
    
    sBuf = pMatchInfo->srcBuf;
    dBuf = pMatchInfo->dstBuf;
    int numIn = storage->cmm->GetSourceSamples();
	int numOut = storage->cmm->GetDestSamples();
	
    for (r=0; r < pMatchInfo->height; r++)
    {
        for (c=0; c < pMatchInfo->width; c++)
        {
            // read color in from source buffer
			
			if (pMatchInfo->srcSwap)
            {
				if (pMatchInfo->srcChanBits==16)
				{
					for (int i=0; i<numIn; i++)
					{
						UInt16 temp;
						if (sBuf[i]) temp = *(UInt16*)(sBuf[i] + (r * pMatchInfo->srcRowBytes) + (c * pMatchInfo->srcColBytes));
						chanIn[i] = (float)Endian16_Swap(temp)*0.000015259;
					}
						
				}
				else
				{
					for (int i=0; i<numIn; i++)
					{
						if (sBuf[i]) chanIn[i]  = (*(UInt8*)(sBuf[0] + (r * pMatchInfo->srcRowBytes) + (c * pMatchInfo->srcColBytes)))*0.00392157;
					}
				}
			}
			else {
				if (pMatchInfo->srcChanBits==16)
				{
					for (int i=0; i<numIn; i++)
						if (sBuf[i]) chanIn[i] = (*(UInt16*)(sBuf[i] + (r * pMatchInfo->srcRowBytes) + (c * pMatchInfo->srcColBytes)))*0.000015259;;
				}
				else
				{
					for (int i=0; i<numIn; i++)
					{
						if (sBuf[i]) chanIn[i] = (*(UInt8*)(sBuf[0] + (r * pMatchInfo->srcRowBytes) + (c * pMatchInfo->srcColBytes)))*0.00392157;;
					}
				}
			}

            // Match the color
			storage->cmm->Apply(chanOut, chanIn);

			//chanOut[0] = 0.5*chanOut[0]+0.5;
            
            if (pMatchInfo->dstSwap)
            {
				if (pMatchInfo->dstChanBits==16)
				{
					for (int i=0; i<numOut; i++)
					{
						UInt16 temp = (UInt16)(chanOut[i]*65535.0+0.5);
						temp = Endian16_Swap(temp);
						if (dBuf[i]) *(UInt16*)(dBuf[i] + (r * pMatchInfo->dstRowBytes) + (c * pMatchInfo->dstColBytes)) = temp;
					}
				}
				else
				{
					for (int i=0; i<numOut; i++)
					{
						if (dBuf[i]) *(UInt16*)(dBuf[i] + (r * pMatchInfo->dstRowBytes) + (c * pMatchInfo->dstColBytes)) = (UInt8)(chanOut[i]*255.0+0.5);
					}
				}
            }
			else {
				if (pMatchInfo->dstChanBits==16)
				{
					for (int i=0; i<numOut; i++)
					{
						if (dBuf[i]) *(UInt16*)(dBuf[i] + (r * pMatchInfo->dstRowBytes) + (c * pMatchInfo->dstColBytes)) = (UInt16)(chanOut[i]*65535.0+0.5);
					}
				}
				else
				{
					for (int i=0; i<numOut; i++)
					{
						if (dBuf[i]) *(UInt16*)(dBuf[i] + (r * pMatchInfo->dstRowBytes) + (c * pMatchInfo->dstColBytes)) = (UInt8)(chanOut[i]*255.0+0.5);
					}
				}
			}
        }
    }
}


//---------------------------------------------------------------------                 
//  Simple conversions of one color with 16 bits-per-channel.
//---------------------------------------------------------------------

static void
MatchOne_XYZ_LAB (UInt16* chan)
{
#if 0
    CMXYZColor white;
    white.X = 31594;
    white.Y = 32768;
    white.Z = 27030;
    CMConvertXYZToLab( (CMColor*)chan, &white, (CMColor*)chan,1);
#else
    double              X, Y, Z;
    double              L, a, b;
    double              fx, fy, fz;

    X = FractToDoub(chan[0]);
    Y = FractToDoub(chan[1]);
    Z = FractToDoub(chan[2]);
    
    // Assume XYZ white is D50
    X /= 0.9642;
    Z /= 0.8249;

    if (X > 0.008856)
        fx = pow(X, 0.3333);
    else
        fx = 7.787 * X + 16.0 / 116.0;
    
    if (Y > 0.008856)
        fy = pow(Y, 0.3333);
    else
        fy = 7.787 * Y + 16.0 / 116.0;
    
    if (Z > 0.008856)
        fz = pow(Z, 0.3333);
    else
        fz = 7.787 * Z + 16.0 / 116.0;

    L = 116.0 * fy - 16;
    a = 500.0 * (fx - fy);
    b = 200.0 * (fy - fz);
    
    L = L / 100.0;
    a = (a + 128.0) / 256.0;
    b = (b + 128.0) / 256.0;
    
    chan[0] = DoubToUInt16(L);
    chan[1] = DoubToUInt16(a);
    chan[2] = DoubToUInt16(b);
#endif
}

static void
MatchOne_LAB_XYZ (UInt16* chan)
{
#if 0
    CMXYZColor white;
    white.X = 31594;
    white.Y = 32768;
    white.Z = 27030;
    CMConvertLabToXYZ( (CMColor*)chan, &white, (CMColor*)chan,1);
#else
    double              X, Y, Z;
    double              L, a, b;
    double              fx, fy, fz;

    L = UInt16ToDoub(chan[0]) * 100.0;
    a = UInt16ToDoub(chan[1]) * 256.0 - 128.0;
    b = UInt16ToDoub(chan[2]) * 256.0 - 128.0;
    
    fy = (L + 16.0) / 116.0;
    fx = a / 500.0 + fy;
    fz = fy - b / 200.0;
    
    if (fx > 0.20696) 
        X = pow(fx, 3);
    else
        X = (fx - 16.0 / 116.0) / 7.787;
    
    if (fy > 0.20696) 
        Y = pow(fy, 3);
    else
        Y = (fy - 16.0 / 116.0) / 7.787;
    
    if (fz > 0.20696) 
        Z = pow(fz, 3);
    else
        Z = (fz - 16.0 / 116.0) / 7.787;
    
    X *= 0.9642;
    Z *= 0.8249;

    chan[0] = DoubToFract(X);
    chan[1] = DoubToFract(Y);
    chan[2] = DoubToFract(Z);
#endif
}

static void
MatchOne_RGB_CMYK (UInt16* chan)
{
    chan[0] = 0xFFFF - chan[0];
    chan[1] = 0xFFFF - chan[1];
    chan[2] = 0xFFFF - chan[2];
    chan[3] = (chan[0] < chan[1]) ?
                ( (chan[0] < chan[2]) ? (chan[0]) : (chan[2]) ) :
                ( (chan[1] < chan[2]) ? (chan[1]) : (chan[2]) );
    chan[0] -= chan[3];
    chan[1] -= chan[3];
    chan[2] -= chan[3];
}

static void
MatchOne_CMYK_RGB (UInt16* chan)
{
    chan[0] = 0xFFFF - chan[0];
    chan[1] = 0xFFFF - chan[1];
    chan[2] = 0xFFFF - chan[2];
    chan[0] = (chan[0] > chan[3]) ? (chan[0] - chan[3]) : 0;
    chan[1] = (chan[1] > chan[3]) ? (chan[1] - chan[3]) : 0;
    chan[2] = (chan[2] > chan[3]) ? (chan[2] - chan[3]) : 0;
    chan[3] = 0;
}

static void
MatchOne_RGB_XYZ (UInt16* chan)
{
    double r,g,b;
    double X,Y,Z;
    
    r = UInt16ToDoub(chan[0]);
    g = UInt16ToDoub(chan[1]);
    b = UInt16ToDoub(chan[2]);
    
    // map through 2.2 gamma
    // r = pow( r, 2.2)
    // g = pow( g, 2.2)
    // b = pow( b, 2.2)
    
    // sRGB phosphors matrix
    X = (0.418 * r) + (0.363 * g) + (0.183 * b);
    Y = (0.213 * r) + (0.715 * g) + (0.072 * b);
    Z = (0.015 * r) + (0.090 * g) + (0.720 * b);
    
    chan[0] = DoubToFract(X);
    chan[1] = DoubToFract(Y);
    chan[2] = DoubToFract(Z);
}

static void
MatchOne_XYZ_RGB (UInt16* chan)
{
    double r,g,b;
    double X,Y,Z;
    
    X = FractToDoub(chan[0]);
    Y = FractToDoub(chan[1]);
    Z = FractToDoub(chan[2]);
    
    // sRGB phosphors inverse matrix
    r = ( 3.202 * X) + (-1.543 * Y) + (-0.660 * Z);
    g = (-0.959 * X) + ( 1.879 * Y) + ( 0.056 * Z);
    b = ( 0.053 * X) + (-0.203 * Y) + ( 1.396 * Z);
    
    // map through inverse of 2.2 gamma
    // r = pow( r, 1.0 / 2.2)
    // g = pow( g, 1.0 / 2.2)
    // b = pow( b, 1.0 / 2.2)
    
    chan[0] = DoubToUInt16(r);
    chan[1] = DoubToUInt16(g);
    chan[2] = DoubToUInt16(b);
}

static void
MatchOne_XYZ_Gray (UInt16* chan)
{
    chan[0] = FractToUInt16(chan[1]); // gray = Y
}

static void
MatchOne_Gray_XYZ (UInt16* chan)
{
    double X,Y,Z;
    
    Y = UInt16ToDoub(chan[0]);
    X = Y * 0.96417;
    Z = Y * 0.82489;
    
    chan[0] = DoubToFract(X);
    chan[1] = DoubToFract(Y);
    chan[2] = DoubToFract(Z);
}

static void
MatchOne_LAB_Gray (UInt16* chan)
{
#pragma unused (chan)
    // nothing to do gray = L
}

static void
MatchOne_Gray_LAB (UInt16* chan)
{
    chan[1] = chan[2] = 0;
}

static void
MatchOne_RGB_LAB (UInt16* chan)
{
    MatchOne_RGB_XYZ(chan);
    MatchOne_XYZ_LAB(chan);
}

static void
MatchOne_LAB_RGB (UInt16* chan)
{
    MatchOne_LAB_XYZ(chan);
    MatchOne_XYZ_RGB(chan);
}

static void
MatchOne_CMYK_LAB (UInt16* chan)
{
    MatchOne_CMYK_RGB(chan);
    MatchOne_RGB_LAB(chan);
}

static void
MatchOne_LAB_CMYK (UInt16* chan)
{
    MatchOne_LAB_RGB(chan);
    MatchOne_RGB_CMYK(chan);
}

static void
MatchOne_CMYK_XYZ (UInt16* chan)
{
    MatchOne_CMYK_RGB(chan);
    MatchOne_RGB_XYZ(chan);
}

static void
MatchOne_XYZ_CMYK (UInt16* chan)
{
    MatchOne_XYZ_RGB(chan);
    MatchOne_RGB_CMYK(chan);
}

static void
MatchOne_RGB_Gray (UInt16* chan)
{
    UInt16 alpha;
    alpha = chan[3]; // preserve alpha
    MatchOne_RGB_XYZ(chan);
    MatchOne_XYZ_Gray(chan);
    chan[1] = alpha; // preserve alpha
}

static void
MatchOne_Gray_RGB (UInt16* chan)
{
    chan[3] = chan[1]; // preserve alpha
    chan[1] = chan[2] = chan[0];
}

static void
MatchOne_CMYK_Gray (UInt16* chan)
{
    MatchOne_CMYK_XYZ(chan);
    MatchOne_XYZ_Gray(chan);
}

static void
MatchOne_Gray_CMYK (UInt16* chan)
{
    chan[3] = chan[0]; // K = gray
    chan[0] = chan[1] = chan[2] = 0; // CMY = 0
}


#pragma mark -


static CMError
DoInit (CMMStoragePtr storage, CMProfileRef srcProf, CMProfileRef dstProf, UInt32 srcTransform, UInt32 dstTransform)
{
    CMError                 err = noErr;
    CMAppleProfileHeader    srcHdr;
    CMAppleProfileHeader    dstHdr;
	OSType srcSpace;
	OSType dstSpace;
    
    err = CMGetProfileHeader(srcProf, &srcHdr);
    require_noerr(err, bail);
    
    err = CMGetProfileHeader(dstProf, &dstHdr);
    require_noerr(err, bail);
    
    storage->srcSpace = (kDeviceToPCS) ? srcHdr.cm2.dataColorSpace : srcHdr.cm2.profileConnectionSpace;
    storage->srcClass = srcHdr.cm2.profileClass;
    
    storage->dstSpace = (kPCSToDevice) ? dstHdr.cm2.dataColorSpace : dstHdr.cm2.profileConnectionSpace;
    storage->dstClass = dstHdr.cm2.profileClass;
    
    srcSpace = storage->srcSpace;
    dstSpace = storage->dstSpace;
    
    if (srcSpace == dstSpace)                                   storage->proc = NULL;
    else if (srcSpace==cmRGBData  && dstSpace==cmCMYKData)      storage->proc = &MatchOne_RGB_CMYK;
    else if (srcSpace==cmRGBData  && dstSpace==cmXYZData)       storage->proc = &MatchOne_RGB_XYZ;
    else if (srcSpace==cmRGBData  && dstSpace==cmLabData)       storage->proc = &MatchOne_RGB_LAB;
    else if (srcSpace==cmRGBData  && dstSpace==cmGrayData)      storage->proc = &MatchOne_RGB_Gray;
    else if (srcSpace==cmCMYKData && dstSpace==cmRGBData)       storage->proc = &MatchOne_CMYK_RGB;
    else if (srcSpace==cmCMYKData && dstSpace==cmLabData)       storage->proc = &MatchOne_CMYK_LAB;
    else if (srcSpace==cmCMYKData && dstSpace==cmXYZData)       storage->proc = &MatchOne_CMYK_XYZ;
    else if (srcSpace==cmCMYKData && dstSpace==cmGrayData)      storage->proc = &MatchOne_CMYK_Gray;
    else if (srcSpace==cmXYZData  && dstSpace==cmRGBData)       storage->proc = &MatchOne_XYZ_RGB;
    else if (srcSpace==cmXYZData  && dstSpace==cmLabData)       storage->proc = &MatchOne_XYZ_LAB;
    else if (srcSpace==cmXYZData  && dstSpace==cmCMYKData)      storage->proc = &MatchOne_XYZ_CMYK;
    else if (srcSpace==cmXYZData  && dstSpace==cmGrayData)      storage->proc = &MatchOne_XYZ_Gray;
    else if (srcSpace==cmLabData  && dstSpace==cmRGBData)       storage->proc = &MatchOne_LAB_RGB;
    else if (srcSpace==cmLabData  && dstSpace==cmXYZData)       storage->proc = &MatchOne_LAB_XYZ;
    else if (srcSpace==cmLabData  && dstSpace==cmCMYKData)      storage->proc = &MatchOne_LAB_CMYK;
    else if (srcSpace==cmLabData  && dstSpace==cmGrayData)      storage->proc = &MatchOne_LAB_Gray;
    else if (srcSpace==cmGrayData && dstSpace==cmRGBData)       storage->proc = &MatchOne_Gray_RGB;
    else if (srcSpace==cmGrayData && dstSpace==cmCMYKData)      storage->proc = &MatchOne_Gray_CMYK;
    else if (srcSpace==cmGrayData && dstSpace==cmXYZData)       storage->proc = &MatchOne_Gray_XYZ;
    else if (srcSpace==cmGrayData && dstSpace==cmLabData)       storage->proc = &MatchOne_Gray_LAB;
    else
        err = cmInvalidProfile;
	 
    require_noerr(err, bail);
    
bail:
    
    return err;
}


static CMError
DoInitSampleICC (CMMStoragePtr storage, NCMConcatProfileSet* profileSet)
{
    CMError                 err = noErr;
    CMAppleProfileHeader    srcHdr;
    CMAppleProfileHeader    dstHdr;
	OSType srcSpace;
	OSType dstSpace;
    
    err = CMGetProfileHeader(profileSet->profileSpecs[0].profile, &srcHdr);
    require_noerr(err, bail);
    
    err = CMGetProfileHeader(profileSet->profileSpecs[profileSet->profileCount-1].profile, &dstHdr);
    require_noerr(err, bail);
    
    storage->srcSpace = (kDeviceToPCS) ? srcHdr.cm2.dataColorSpace : srcHdr.cm2.profileConnectionSpace;
    storage->srcClass = srcHdr.cm2.profileClass;
    
    storage->dstSpace = (kPCSToDevice) ? dstHdr.cm2.dataColorSpace : dstHdr.cm2.profileConnectionSpace;
    storage->dstClass = dstHdr.cm2.profileClass;
    
    srcSpace = storage->srcSpace;
    dstSpace = storage->dstSpace;
	
	for (int i=0; i<profileSet->profileCount; i++)
	{
		CIccProfile* prof = getIccProfLibProfileFromColorsyncProfile(profileSet->profileSpecs[i].profile);
		storage->cmm->AddXform(prof,(icRenderingIntent)profileSet->profileSpecs[i].renderingIntent);
	}
	
	if (storage->cmm->Begin() != icCmmStatOk) 
	{
		err = cmInvalidProfile;
		require_noerr(err, bail);
	}
	
    
bail:
    
    return err;
}

#pragma mark ------------------------------------------------------------------
#pragma mark pre-Leopard entry points
#pragma mark ------------------------------------------------------------------

CMError
CMMOpen (uintptr_t* cmmRefcon, void* hInstance) 
{ 
    #pragma unused (hInstance)
    *cmmRefcon = (uintptr_t)calloc(1,sizeof(CMMStorageRec));
    //{
    //  CFBundleRef ref = NULL;
    //  ref = CFBundleGetBundleWithIdentifier(CFSTR("com.apple.ColorSync.DemoCMM"));
    //}
	
	CMMStorageRec* storage = (CMMStorageRec*)*cmmRefcon;
	
	storage->cmm = new CIccCmm;
	
    if (*cmmRefcon)
        return noErr;
    else
        return memFullErr;
}


CMError
CMMClose (uintptr_t* cmmRefcon ) 
{
    if (*cmmRefcon)
	{
		CMMStorageRec* storage = (CMMStorageRec*)*cmmRefcon;
		delete storage->cmm;
		free((void*)*cmmRefcon);
	}
       
    return noErr;
}


CMError  
NCMMInit (uintptr_t* cmmRefcon, CMProfileRef srcProf, CMProfileRef dstProf)
{
    return DoInit((CMMStoragePtr)*cmmRefcon, srcProf, dstProf, kDeviceToPCS, kPCSToDevice);
}


CMError  
CMMConcatInit (uintptr_t* cmmRefcon, CMConcatProfileSet* profileSet)
{
    CMProfileRef srcProf = profileSet->profileSet[0];
    CMProfileRef dstProf = profileSet->profileSet[profileSet->count-1];
    
    return DoInit((CMMStoragePtr)*cmmRefcon, srcProf, dstProf, kDeviceToPCS, kPCSToDevice);
}


CMError  
NCMMConcatInit (uintptr_t* cmmRefcon, NCMConcatProfileSet* profileSet, CMConcatCallBackUPP proc, void* refCon)
{
    CMProfileRef srcProf = profileSet->profileSpecs[0].profile;
    CMProfileRef dstProf = profileSet->profileSpecs[profileSet->profileCount-1].profile;
    
    UInt32 srcTransform = profileSet->profileSpecs[0].transformTag;
    UInt32 dstTransform = profileSet->profileSpecs[profileSet->profileCount-1].transformTag;
    
    return DoInitSampleICC((CMMStoragePtr)*cmmRefcon, profileSet);
}


CMError  
CMMMatchColors (uintptr_t* cmmRefcon, CMColor *colorBuf, UInt32 count)
{
    CMMMatchRec         matchInfo;
    
    matchInfo.height        = count;
    matchInfo.width         = 1;
    
    matchInfo.srcBuf[0]     = ((UInt8*)colorBuf) + 0;
    matchInfo.srcBuf[1]     = ((UInt8*)colorBuf) + 2;
    matchInfo.srcBuf[2]     = ((UInt8*)colorBuf) + 4;
    matchInfo.srcBuf[3]     = ((UInt8*)colorBuf) + 6;
    matchInfo.srcChanBits   = 16;
    matchInfo.srcRowBytes   = sizeof(CMColor);
    matchInfo.srcColBytes   = sizeof(CMColor);
    matchInfo.srcSwap       = false;
    
    matchInfo.dstBuf[0]     = ((UInt8*)colorBuf) + 0;
    matchInfo.dstBuf[1]     = ((UInt8*)colorBuf) + 2;
    matchInfo.dstBuf[2]     = ((UInt8*)colorBuf) + 4;
    matchInfo.dstBuf[3]     = ((UInt8*)colorBuf) + 6;
    matchInfo.dstChanBits   = 16;
    matchInfo.dstRowBytes   = sizeof(CMColor);
    matchInfo.dstColBytes   = sizeof(CMColor);
    matchInfo.dstSwap       = false;
    
    DoMatch((CMMStoragePtr)*cmmRefcon, &matchInfo);
    
    return noErr;
}


CMError  
CMMMatchBitmap (uintptr_t* cmmRefcon, CMBitmap * srcMap, CMBitmapCallBackUPP progressProc, void * refCon, CMBitmap* dstMap)
{
    #pragma unused (progressProc, refCon)
    CMMMatchRec         matchInfo;
    OSType              srcSpace = 0;
    OSType              dstSpace = 0;
    
    // Check params
    if (srcMap==NULL || srcMap->image==NULL || 
        dstMap==NULL || dstMap->image==NULL)
        return paramErr;
    
    matchInfo.height        = srcMap->height;
    matchInfo.width         = srcMap->width;
    matchInfo.srcRowBytes   = srcMap->rowBytes;
    matchInfo.dstRowBytes   = dstMap->rowBytes;
    
    switch (srcMap->space)
    {
        case cmGray8Space:
        srcSpace                = cmGrayData;
        matchInfo.srcBuf[0]     = (UInt8*)srcMap->image + 0;
        matchInfo.srcBuf[1]     = NULL;
        matchInfo.srcBuf[2]     = NULL;
        matchInfo.srcBuf[3]     = NULL;
        matchInfo.srcChanBits   = 8;
        matchInfo.srcColBytes   = 1;
        break;
        
        case cmGray16Space:
        case cmGray16LSpace:
        srcSpace                = cmGrayData;
        matchInfo.srcBuf[0]     = (UInt8*)srcMap->image + 0;
        matchInfo.srcBuf[1]     = NULL;
        matchInfo.srcBuf[2]     = NULL;
        matchInfo.srcBuf[3]     = NULL;
        matchInfo.srcChanBits   = 16;
        matchInfo.srcColBytes   = 2;
        break;
    
        case cmRGB24Space:
        srcSpace                = cmRGBData;
        matchInfo.srcBuf[0]     = (UInt8*)srcMap->image + 0;
        matchInfo.srcBuf[1]     = (UInt8*)srcMap->image + 1;
        matchInfo.srcBuf[2]     = (UInt8*)srcMap->image + 2;
        matchInfo.srcBuf[3]     = NULL;
        matchInfo.srcChanBits   = 8;
        matchInfo.srcColBytes   = 3;
        break;
        
        case cmRGB32Space:
		case cmRGBA32Space:
        srcSpace                = cmRGBData;
        matchInfo.srcBuf[0]     = (UInt8*)srcMap->image + 1;
        matchInfo.srcBuf[1]     = (UInt8*)srcMap->image + 2;
        matchInfo.srcBuf[2]     = (UInt8*)srcMap->image + 3;
        matchInfo.srcBuf[3]     = NULL;
        matchInfo.srcChanBits   = 8;
        matchInfo.srcColBytes   = 4;
        break;
        
        case cmRGB48Space:
        case cmRGB48LSpace:
        srcSpace                = cmRGBData;
        matchInfo.srcBuf[0]     = (UInt8*)srcMap->image + 0;
        matchInfo.srcBuf[1]     = (UInt8*)srcMap->image + 2;
        matchInfo.srcBuf[2]     = (UInt8*)srcMap->image + 4;
        matchInfo.srcBuf[3]     = NULL;
        matchInfo.srcChanBits   = 16;
        matchInfo.srcColBytes   = 6;
        break;
        
        case cmCMYK32Space:
        srcSpace                = cmCMYKData;
        matchInfo.srcBuf[0]     = (UInt8*)srcMap->image + 0;
        matchInfo.srcBuf[1]     = (UInt8*)srcMap->image + 1;
        matchInfo.srcBuf[2]     = (UInt8*)srcMap->image + 2;
        matchInfo.srcBuf[3]     = (UInt8*)srcMap->image + 3;
        matchInfo.srcChanBits   = 8;
        matchInfo.srcColBytes   = 4;
        break;
        
        case cmCMYK64Space:
        case cmCMYK64LSpace:
        srcSpace                = cmCMYKData;
        matchInfo.srcBuf[0]     = (UInt8*)srcMap->image + 0;
        matchInfo.srcBuf[1]     = (UInt8*)srcMap->image + 2;
        matchInfo.srcBuf[2]     = (UInt8*)srcMap->image + 4;
        matchInfo.srcBuf[3]     = (UInt8*)srcMap->image + 6;
        matchInfo.srcChanBits   = 16;
        matchInfo.srcColBytes   = 8;
        break;
        
        case cmLAB24Space:
        srcSpace                = cmLabData;
        matchInfo.srcBuf[0]     = (UInt8*)srcMap->image + 0;
        matchInfo.srcBuf[1]     = (UInt8*)srcMap->image + 1;
        matchInfo.srcBuf[2]     = (UInt8*)srcMap->image + 2;
        matchInfo.srcBuf[3]     = NULL;
        matchInfo.srcChanBits   = 8;
        matchInfo.srcColBytes   = 3;
        break;
        
        case cmLAB48Space:
        case cmLAB48LSpace:
        srcSpace                = cmLabData;
        matchInfo.srcBuf[0]     = (UInt8*)srcMap->image + 0;
        matchInfo.srcBuf[1]     = (UInt8*)srcMap->image + 2;
        matchInfo.srcBuf[2]     = (UInt8*)srcMap->image + 4;
        matchInfo.srcBuf[3]     = NULL;
        matchInfo.srcChanBits   = 16;
        matchInfo.srcColBytes   = 6;
        break;
        
        case cmXYZ24Space:
        srcSpace                = cmXYZData;
        matchInfo.srcBuf[0]     = (UInt8*)srcMap->image + 0;
        matchInfo.srcBuf[1]     = (UInt8*)srcMap->image + 1;
        matchInfo.srcBuf[2]     = (UInt8*)srcMap->image + 2;
        matchInfo.srcBuf[3]     = NULL;
        matchInfo.srcChanBits   = 8;
        matchInfo.srcColBytes   = 3;
        break;
        
        case cmXYZ48Space:
        case cmXYZ48LSpace:
        srcSpace                = cmXYZData;
        matchInfo.srcBuf[0]     = (UInt8*)srcMap->image + 0;
        matchInfo.srcBuf[1]     = (UInt8*)srcMap->image + 2;
        matchInfo.srcBuf[2]     = (UInt8*)srcMap->image + 4;
        matchInfo.srcBuf[3]     = NULL;
        matchInfo.srcChanBits   = 16;
        matchInfo.srcColBytes   = 6;
        break;
        
        default:
        return cmInvalidSrcMap;
        break;
    }
    
    
    switch (dstMap->space)
    {
        case cmGray8Space:
        dstSpace                = cmGrayData;
        matchInfo.dstBuf[0]     = (UInt8*)srcMap->image + 0;
        matchInfo.dstBuf[1]     = NULL;
        matchInfo.dstBuf[2]     = NULL;
        matchInfo.dstBuf[3]     = NULL;
        matchInfo.dstChanBits   = 8;
        matchInfo.dstColBytes   = 1;
        break;
        
        case cmGray16Space:
        case cmGray16LSpace:
        dstSpace                = cmGrayData;
        matchInfo.dstBuf[0]     = (UInt8*)srcMap->image + 0;
        matchInfo.dstBuf[1]     = NULL;
        matchInfo.dstBuf[2]     = NULL;
        matchInfo.dstBuf[3]     = NULL;
        matchInfo.dstChanBits   = 16;
        matchInfo.dstColBytes   = 2;
        break;
    
        case cmRGB24Space:
        dstSpace                = cmRGBData;
        matchInfo.dstBuf[0]     = (UInt8*)dstMap->image + 0;
        matchInfo.dstBuf[1]     = (UInt8*)dstMap->image + 1;
        matchInfo.dstBuf[2]     = (UInt8*)dstMap->image + 2;
        matchInfo.dstBuf[3]     = NULL;
        matchInfo.dstChanBits   = 8;
        matchInfo.dstColBytes   = 3;
        break;
        
        case cmRGB32Space:
 		case cmRGBA32Space:
        dstSpace                = cmRGBData;
        matchInfo.dstBuf[0]     = (UInt8*)dstMap->image + 1;
        matchInfo.dstBuf[1]     = (UInt8*)dstMap->image + 2;
        matchInfo.dstBuf[2]     = (UInt8*)dstMap->image + 3;
        matchInfo.dstBuf[3]     = NULL;
        matchInfo.dstChanBits   = 8;
        matchInfo.dstColBytes   = 4;
        break;
        
        case cmRGB48Space:
        case cmRGB48LSpace:
        dstSpace                = cmRGBData;
        matchInfo.dstBuf[0]     = (UInt8*)dstMap->image + 0;
        matchInfo.dstBuf[1]     = (UInt8*)dstMap->image + 2;
        matchInfo.dstBuf[2]     = (UInt8*)dstMap->image + 4;
        matchInfo.dstBuf[3]     = NULL;
        matchInfo.dstChanBits   = 16;
        matchInfo.dstColBytes   = 6;
        break;
        
        case cmCMYK32Space:
        dstSpace                = cmCMYKData;
        matchInfo.dstBuf[0]     = (UInt8*)dstMap->image + 0;
        matchInfo.dstBuf[1]     = (UInt8*)dstMap->image + 1;
        matchInfo.dstBuf[2]     = (UInt8*)dstMap->image + 2;
        matchInfo.dstBuf[3]     = (UInt8*)dstMap->image + 3;
        matchInfo.dstChanBits   = 8;
        matchInfo.dstColBytes   = 4;
        break;
        
        case cmCMYK64Space:
        case cmCMYK64LSpace:
        dstSpace                = cmCMYKData;
        matchInfo.dstBuf[0]     = (UInt8*)dstMap->image + 0;
        matchInfo.dstBuf[1]     = (UInt8*)dstMap->image + 2;
        matchInfo.dstBuf[2]     = (UInt8*)dstMap->image + 4;
        matchInfo.dstBuf[3]     = (UInt8*)dstMap->image + 6;
        matchInfo.dstChanBits   = 16;
        matchInfo.dstColBytes   = 8;
        break;
        
        case cmLAB24Space:
        dstSpace                = cmLabData;
        matchInfo.dstBuf[0]     = (UInt8*)dstMap->image + 0;
        matchInfo.dstBuf[1]     = (UInt8*)dstMap->image + 1;
        matchInfo.dstBuf[2]     = (UInt8*)dstMap->image + 2;
        matchInfo.dstBuf[3]     = NULL;
        matchInfo.dstChanBits   = 8;
        matchInfo.dstColBytes   = 3;
        break;
        
        case cmLAB48Space:
        case cmLAB48LSpace:
        dstSpace                = cmLabData;
        matchInfo.dstBuf[0]     = (UInt8*)dstMap->image + 0;
        matchInfo.dstBuf[1]     = (UInt8*)dstMap->image + 2;
        matchInfo.dstBuf[2]     = (UInt8*)dstMap->image + 4;
        matchInfo.dstBuf[3]     = NULL;
        matchInfo.dstChanBits   = 16;
        matchInfo.dstColBytes   = 6;
        break;
        
        case cmXYZ24Space:
        dstSpace                = cmXYZData;
        matchInfo.dstBuf[0]     = (UInt8*)dstMap->image + 0;
        matchInfo.dstBuf[1]     = (UInt8*)dstMap->image + 1;
        matchInfo.dstBuf[2]     = (UInt8*)dstMap->image + 2;
        matchInfo.dstBuf[3]     = NULL;
        matchInfo.dstChanBits   = 8;
        matchInfo.dstColBytes   = 3;
        break;
        
        case cmXYZ48Space:
        case cmXYZ48LSpace:
        dstSpace                = cmXYZData;
        matchInfo.dstBuf[0]     = (UInt8*)dstMap->image + 0;
        matchInfo.dstBuf[1]     = (UInt8*)dstMap->image + 2;
        matchInfo.dstBuf[2]     = (UInt8*)dstMap->image + 4;
        matchInfo.dstBuf[3]     = NULL;
        matchInfo.dstChanBits   = 16;
        matchInfo.dstColBytes   = 6;
        break;
        
        default:
        return cmInvalidSrcMap;
        break;
    }
    
    #if TARGET_RT_LITTLE_ENDIAN
        matchInfo.srcSwap = ((srcMap->space & cmLittleEndianPacking) == 0);
        matchInfo.dstSwap = ((dstMap->space & cmLittleEndianPacking) == 0);
    #else
        matchInfo.srcSwap = ((srcMap->space & cmLittleEndianPacking) == cmLittleEndianPacking);
        matchInfo.dstSwap = ((dstMap->space & cmLittleEndianPacking) == cmLittleEndianPacking);
    #endif
    
    DoMatch((CMMStoragePtr)*cmmRefcon, &matchInfo);
    return noErr;
}


CMError  
CMMCheckColors (uintptr_t* cmmRefcon, CMColor *colorBuf, UInt32 count, UInt8* gamutResult)
{
    #pragma unused (cmmRefcon, colorBuf)
    // This is just sample code. Return that everything is in gamut.
    UInt32 byteCount = (count + 7) / 8;
    memset(gamutResult, 0xFF, byteCount);   
    return noErr;
}


CMError  
CMMCheckBitmap (uintptr_t* cmmRefcon,  const CMBitmap * srcMap, CMBitmapCallBackUPP progressProc, void * refCon, CMBitmap* chkMap)
{
    #pragma unused (cmmRefcon, srcMap, progressProc, refCon, chkMap)
    // This is just sample code.
    return unimpErr;
}

#pragma mark ------------------------------------------------------------------
#pragma mark Leopard entry points
#pragma mark ------------------------------------------------------------------

#define kCMMSTORAGE CFSTR("com.acme.DemoCMM") // use your company domain

static CFAllocatorRef CMMBytesDeallocator();

static uintptr_t
GetCMMStorage (CMWorldRef cw)
{
    uintptr_t cmmStorage = (uintptr_t) NULL;
    
    if (cw)
    {
        CFDataRef data = (CFDataRef) CWColorWorldGetProperty (cw, kCMMSTORAGE);
    
        if (data)
        {
            cmmStorage = (uintptr_t) CFDataGetBytePtr (data);
        }
    }
    
    return cmmStorage;
}


CMError
CMM_ConcatColorWorld (CMWorldRef cw, NCMConcatProfileSet* profileSet, CMConcatCallBackUPP proc, void* refCon)
{
    CMError err = paramErr;

    if (cw)
    {
        uintptr_t cmmStorage = (uintptr_t) NULL;
    
        if ((err = CMMOpen (&cmmStorage, NULL)) == noErr)
        {
            CFDataRef prop = CFDataCreateWithBytesNoCopy (NULL, (const UInt8*) cmmStorage, sizeof (cmmStorage), CMMBytesDeallocator());
    
            if (prop)
            {
                CWColorWorldSetProperty (cw, kCMMSTORAGE, prop);
                
                CFRelease (prop);

                return NCMMConcatInit (&cmmStorage, profileSet, proc, refCon);
            }
            else
            {
                CMMClose(&cmmStorage);
                
                err = memFullErr;
            }
        }
    }
    
    return err;
}


CMError
CMM_MatchColors (CMWorldRef cw, CMColor* myColors, UInt32 count)
{
    CMError err = paramErr;

    uintptr_t cmmStorage = GetCMMStorage (cw);

    if (cmmStorage)
    {
        err = CMMMatchColors (&cmmStorage, myColors, count);
    }
    
    return err;
}


CMError
CMM_CheckColors (CMWorldRef cw, CMColor* myColors, UInt32 count, UInt8* result) 
{
    CMError err = paramErr;

    uintptr_t cmmStorage = GetCMMStorage (cw);

    if (cmmStorage)
    {
        err = CMMCheckColors (&cmmStorage, myColors, count, result);
    }
    
    return err;
}


CMError
CMM_MatchBitmap (CMWorldRef cw, CMBitmap* srcMap, CMBitmapCallBackUPP progressProc, void* refCon, CMBitmap* dstMap)
{
    CMError err = paramErr;

    uintptr_t cmmStorage = GetCMMStorage (cw);

    if (cmmStorage)
    {
        err = CMMMatchBitmap (&cmmStorage, srcMap, progressProc, refCon, dstMap);
    }
    
    return err;
}


CMError CMM_CheckBitmap (CMWorldRef cw, const CMBitmap* srcMap, CMBitmapCallBackUPP progressProc, void* refCon, CMBitmap* chkMap)
{
    CMError err = paramErr;

    uintptr_t cmmStorage = GetCMMStorage (cw);

    if (cmmStorage)
    {
        err = CMMCheckBitmap (&cmmStorage, srcMap, progressProc, refCon, chkMap);
    }
    
    return err;
}


// ============================================================================
//
// Bytes deallocator
//
//=============================================================================

static CFAllocatorRef cmmAllocator = NULL;

static void *
cmmallocate(CFIndex size, CFOptionFlags hint, void *info)
{
    return malloc(size);
}

static void * 
cmmreallocate(void *ptr, CFIndex size, CFOptionFlags hint, void *info)
{
    return realloc(ptr, size);
}

static void
cmmdeallocate(void *ptr, void *info)
{
    void* cmmStorage = ptr;

    if (cmmStorage)
    {
        CMMClose ((uintptr_t*) &cmmStorage);
    }
}

static const CFAllocatorContext context = {
    0,
    NULL,
    NULL,
    NULL,
    NULL,
    cmmallocate,
    cmmreallocate,
    cmmdeallocate,
    NULL
};

static void
create_allocator(void)
{
    cmmAllocator = CFAllocatorCreate(kCFAllocatorUseContext, (CFAllocatorContext *)&context);
}

static CFAllocatorRef CMMBytesDeallocator()
{
    static pthread_once_t once = PTHREAD_ONCE_INIT;

    if (cmmAllocator == NULL)
    {
        pthread_once(&once, &create_allocator);
    }

    return cmmAllocator;
}


// Get SampleICC objects

struct sMemBlock {
    unsigned char* mem;
    unsigned long size;
    unsigned long memSize;
};

/*
OSErr MyCMFlattenCallback (
						   SInt32 command, 
						   SInt32 *size, 
						   void *data, 
						   void *refCon)
{
	unsigned char	*newBlock;
	sMemBlock *memBlock = (sMemBlock*)refCon;
	
	if (command == cmWriteSpool)
    {
		if (memBlock->size + *size > memBlock->memSize)
        {
			newBlock = new unsigned char[MaxVal(memBlock->memSize*2,*size + memBlock->size)];
			
			memcpy(newBlock,memBlock->mem,sizeof(unsigned char)*memBlock->size);
			
			if (memBlock->memSize*2 > *size + memBlock->size)
				memBlock->memSize = memBlock->memSize*2;
			else
				memBlock->memSize = *size + memBlock->size;
            
			
			delete memBlock->mem;
			memBlock->mem = newBlock;
        }
		memcpy(&memBlock->mem[memBlock->size],data,*size);
		memBlock->size += *size;
    }
    
	return noErr;
	
}


void cProfileFlatten(CMProfileRef pref,sMemBlock& memoryChunk)
{
    CMFlattenUPP flattenUPP;
    Boolean	 preferredCMMnotfound;
	
    memoryChunk.mem = 0L;
	
    flattenUPP = NewCMFlattenUPP(MyCMFlattenCallback);
    
    memoryChunk.mem = new unsigned char[20000];
    memoryChunk.memSize = 20000;
    memoryChunk.size = 0;
    
    CMFlattenProfile (pref,0,flattenUPP,&memoryChunk,&preferredCMMnotfound);
	
    DisposeCMFlattenUPP(flattenUPP);
}
 */

CIccProfile* getIccProfLibProfileFromColorsyncProfile(CMProfileRef pref)
{

	
	CFDataRef data = CMProfileCopyICCData(NULL,pref);
	
	CIccProfile* prof = ReadIccProfile(CFDataGetBytePtr(data),CFDataGetLength(data));

	CFRelease(data);
	
	return prof;
}