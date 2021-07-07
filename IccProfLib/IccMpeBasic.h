/** @file
File:       IccMpeBasic.h

Contains:   Header for implementation of Basic CIccTagMPE elements
            and supporting classes

Version:    V1

Copyright:  (c) see ICC Software License
*/

/*
* The ICC Software License, Version 0.2
*
*
* Copyright (c) 2005 The International Color Consortium. All rights 
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
// -Jan 30, 2005 
//  Initial CIccMpe prototype development
//
// -Nov 6, 2006
//  Prototype Merged into release
//
//////////////////////////////////////////////////////////////////////

#ifndef _ICCELEMBASIC_H
#define _ICCELEMBASIC_H

#include "IccTagMPE.h"


//CIccFloatTag support
#ifdef USEREFICCMAXNAMESPACE
namespace refIccMAX {
#endif

/**
****************************************************************************
* Class: CIccCurveSegment
* 
* Purpose: 
*****************************************************************************
*/
class CIccCurveSegment
{
public:
  virtual ~CIccCurveSegment() {}

  static CIccCurveSegment* Create(icCurveSegSignature sig, icFloatNumber start, icFloatNumber end);
  virtual CIccCurveSegment* NewCopy() const = 0;

  virtual icCurveSegSignature GetType() const = 0;
  virtual const icChar *GetClassName() const = 0;

  virtual void Describe(std::string &sDescription, int verboseness)=0;

  virtual bool Read(icUInt32Number size, CIccIO *pIO)=0;
  virtual bool Write(CIccIO *pIO)=0;

  virtual bool Begin(CIccCurveSegment *pPrevSeg) = 0;
  virtual icFloatNumber Apply(icFloatNumber v) const =0;

  virtual icValidateStatus Validate(std::string sigPath, std::string &sReport, const CIccTagMultiProcessElement* pMPE=NULL) const = 0;

  icFloatNumber StartPoint() { return m_startPoint; }
  icFloatNumber EndPoint() { return m_endPoint;}

protected:
  icFloatNumber m_startPoint;
  icFloatNumber m_endPoint;
  icUInt32Number m_nReserved;
};


/**
****************************************************************************
* Class: CIccTagFormulaCurveSegment
* 
* Purpose: The parametric curve segment
*****************************************************************************
*/
class CIccFormulaCurveSegment : public CIccCurveSegment
{
public:
  CIccFormulaCurveSegment(icFloatNumber start, icFloatNumber end);
  CIccFormulaCurveSegment(const CIccFormulaCurveSegment &seg);
  CIccFormulaCurveSegment &operator=(const CIccFormulaCurveSegment &seg);
  virtual CIccCurveSegment *NewCopy() const { return new CIccFormulaCurveSegment(*this);}
  virtual ~CIccFormulaCurveSegment();

  virtual icCurveSegSignature GetType() const { return icSigFormulaCurveSeg; }
  virtual const icChar *GetClassName() const { return "CIccFormulaCurveSegment"; }

  virtual void Describe(std::string &sDescription, int verboseness);

  void SetFunction(icUInt16Number functionType, icUInt8Number num_parameters, icFloatNumber *parameters);

  virtual bool Read(icUInt32Number size, CIccIO *pIO);
  virtual bool Write(CIccIO *pIO);

  virtual bool Begin(CIccCurveSegment *pPrevSeg);
  virtual icFloatNumber Apply(icFloatNumber v) const;
  virtual icValidateStatus Validate(std::string sigPath, std::string &sReport, const CIccTagMultiProcessElement* pMPE=NULL) const;

protected:
  icUInt16Number m_nReserved2;
  icUInt8Number m_nParameters;
  icUInt16Number m_nFunctionType;
  icUInt16Number m_nShortcutType;
  icFloatNumber *m_params;
};


/**
****************************************************************************
* Class: CIccSampledCurveSegment
* 
* Purpose: The sampled curve segment
*****************************************************************************
*/
class CIccSampledCurveSegment : public CIccCurveSegment
{
public:
  CIccSampledCurveSegment(icFloatNumber start, icFloatNumber end);
  CIccSampledCurveSegment(const CIccSampledCurveSegment &ITPC);
  CIccSampledCurveSegment &operator=(const CIccSampledCurveSegment &ParamCurveTag);
  virtual CIccCurveSegment *NewCopy() const { return new CIccSampledCurveSegment(*this);}
  virtual ~CIccSampledCurveSegment();

  virtual icCurveSegSignature GetType() const { return icSigSampledCurveSeg; }
  virtual const icChar *GetClassName() const { return "CIccSampledCurveSegment"; }

  virtual bool SetSize(icUInt32Number nSize, bool bZeroAlloc=true); //nSize must be >= 2
  virtual icUInt32Number GetSize() { return m_nCount; }

  virtual icFloatNumber *GetSamples() { return m_pSamples; }

  virtual void Describe(std::string &sDescription, int verboseness);

  virtual bool Read(icUInt32Number size, CIccIO *pIO);
  virtual bool Write(CIccIO *pIO);

  virtual bool Begin(CIccCurveSegment *pPrevSeg);
  virtual icFloatNumber Apply(icFloatNumber v) const;
  virtual icValidateStatus Validate(std::string sigPath, std::string &sReport, const CIccTagMultiProcessElement* pMPE=NULL) const ;

protected:
  icUInt32Number m_nCount;   //number of samples used for interpolation
  icFloatNumber *m_pSamples; //interpolation values - Note m_pSamples[0] is initialized from previous segment in Begin()

  icFloatNumber m_range;
  icFloatNumber m_last;
};



/**
****************************************************************************
* Class: CIccCurveSetCurve
* 
* Purpose: Base class for Curve Set Curves
*****************************************************************************
*/
class CIccCurveSetCurve
{
public:
  virtual ~CIccCurveSetCurve() {}
  
  static CIccCurveSetCurve *Create(icCurveElemSignature sig);
  virtual CIccCurveSetCurve *NewCopy() const = 0;

  virtual icCurveElemSignature GetType() const = 0;
  virtual const icChar *GetClassName() const = 0;

  virtual void Describe(std::string &sDescription, int verboseness) = 0;

  virtual bool Read(icUInt32Number size, CIccIO *pIO) = 0;
  virtual bool Write(CIccIO *pIO) = 0;

  virtual bool Begin() = 0;
  virtual icFloatNumber Apply(icFloatNumber v) const = 0; 
  virtual icValidateStatus Validate(std::string sigPath, std::string &sReport, const CIccTagMultiProcessElement* pMPE=NULL) const = 0;

protected:
};

typedef CIccCurveSetCurve* icCurveSetCurvePtr;

typedef std::list<CIccCurveSegment*> CIccCurveSegmentList;

/**
****************************************************************************
* Class: CIccSegmentedCurve
* 
* Purpose: The Curve Set Segmented Curve Type
*****************************************************************************
*/
class CIccSegmentedCurve : public CIccCurveSetCurve
{
public:
  CIccSegmentedCurve();
  CIccSegmentedCurve(const CIccSegmentedCurve &ITPC);
  CIccSegmentedCurve &operator=(const CIccSegmentedCurve &ParamCurveTag);
  virtual CIccCurveSetCurve *NewCopy() const { return new CIccSegmentedCurve(*this);}
  virtual ~CIccSegmentedCurve();

  virtual icCurveElemSignature GetType() const { return icSigSegmentedCurve; }
  virtual const icChar *GetClassName() const { return "CIccSegmentedCurve"; }

  virtual void Describe(std::string &sDescription, int verboseness);

  virtual bool Read(icUInt32Number size, CIccIO *pIO);
  virtual bool Write(CIccIO *pIO);

  void Reset();
  bool Insert(CIccCurveSegment *pCurveSegment);

  virtual bool Begin();
  virtual icFloatNumber Apply(icFloatNumber v) const;
  virtual icValidateStatus Validate(std::string sigPath, std::string &sReport, const CIccTagMultiProcessElement* pMPE=NULL) const;

protected:
  CIccCurveSegmentList *m_list;
  icUInt32Number m_nReserved1;
  icUInt32Number m_nReserved2;
};


/**
****************************************************************************
* Class: CIccSingleSampledCurve
*
* Purpose: The single sampled curve class
*****************************************************************************
*/
class CIccSingleSampledCurve : public CIccCurveSetCurve
{
public:
  CIccSingleSampledCurve(icFloatNumber first=0.0, icFloatNumber last=1.0);
  CIccSingleSampledCurve(const CIccSingleSampledCurve &ITPC);
  CIccSingleSampledCurve &operator=(const CIccSingleSampledCurve &SampledCurve);
  virtual CIccCurveSetCurve *NewCopy() const { return new CIccSingleSampledCurve(*this); }
  virtual ~CIccSingleSampledCurve();

  virtual icCurveElemSignature GetType() const { return icSigSingleSampledCurve; }
  virtual const icChar *GetClassName() const { return "CIccSingleSampledCurve"; }

  void SetRange(icFloatNumber first = 0.0f, icFloatNumber last = 1.0f);

  virtual bool SetSize(icUInt32Number nSize, bool bZeroAlloc = true); //nSize must be >= 2
  virtual icUInt32Number GetSize() { return m_nCount; }

  bool SetExtensionType(icUInt16Number nExtensionType);
  icUInt16Number GetExtensionType() { return m_extensionType; }

  bool SetStorageType(icUInt16Number nStorateType);
  icUInt16Number GetStorageType() { return m_storageType; }

  virtual icFloatNumber *GetSamples() { return m_pSamples; }

  virtual void Describe(std::string &sDescription, int verboseness);

  virtual bool Read(icUInt32Number size, CIccIO *pIO);
  virtual bool Write(CIccIO *pIO);

  virtual bool Begin();
  virtual icFloatNumber Apply(icFloatNumber v) const;
  virtual icValidateStatus Validate(std::string sigPath, std::string &sReport, const CIccTagMultiProcessElement* pMPE = NULL) const;

protected:
  icUInt32Number m_nReserved;

  icUInt32Number m_nCount;   //number of samples used for interpolation
  icFloatNumber *m_pSamples; //interpolation values

  icUInt16Number m_storageType;
  icUInt16Number m_extensionType;

  icFloatNumber m_firstEntry;
  icFloatNumber m_lastEntry;

  icFloatNumber m_range;
  icFloatNumber m_last;

  icFloatNumber m_loSlope;
  icFloatNumber m_loIntercept;
  icFloatNumber m_hiSlope;
  icFloatNumber m_hiIntercept;
};


/**
****************************************************************************
* Class: CIccMpeCurveSet
* 
* Purpose: The curve set process element
*****************************************************************************
*/
class CIccMpeCurveSet : public CIccMultiProcessElement
{
public:
  CIccMpeCurveSet(int nSize=0);
  CIccMpeCurveSet(const CIccMpeCurveSet &curveSet);
  CIccMpeCurveSet &operator=(const CIccMpeCurveSet &curveSet);
  virtual CIccMultiProcessElement *NewCopy() const { return new CIccMpeCurveSet(*this);}
  virtual ~CIccMpeCurveSet();

  bool SetSize(int nNewSize);

  bool SetCurve(int nIndex, icCurveSetCurvePtr newCurve);

  virtual icElemTypeSignature GetType() const { return icSigCurveSetElemType; }
  virtual const icChar *GetClassName() const { return "CIccMpeCurveSet"; }

  virtual void Describe(std::string &sDescription, int verboseness);

  virtual bool Read(icUInt32Number size, CIccIO *pIO);
  virtual bool Write(CIccIO *pIO);

  virtual bool Begin(icElemInterp nInterp, CIccTagMultiProcessElement *pMPE);
  virtual void Apply(CIccApplyMpe *pApply, icFloatNumber *dstPixel, const icFloatNumber *srcPixel) const;

  virtual icValidateStatus Validate(std::string sigPath, std::string &sReport, const CIccTagMultiProcessElement* pMPE=NULL) const;

protected:
  icCurveSetCurvePtr *m_curve;

  icPositionNumber *m_position;
};


/**
****************************************************************************
* Class: CIccMpeTintArray
* 
* Purpose: The curve set process element
*****************************************************************************
*/
class CIccMpeTintArray : public CIccMultiProcessElement
{
public:
  CIccMpeTintArray(int nVectorSize=1);
  CIccMpeTintArray(const CIccMpeTintArray &tintArray);
  CIccMpeTintArray &operator=(const CIccMpeTintArray &tintArray);
  virtual CIccMultiProcessElement *NewCopy() const { return new CIccMpeTintArray(*this);}
  virtual ~CIccMpeTintArray();

  void SetVectorSize(int nVectorSize);

  //SetArray assumes ownership of pTag
  void SetArray(CIccTagNumArray *pTag);

  CIccTagNumArray *GetArray() { return m_Array; }

  virtual icElemTypeSignature GetType() const { return icSigTintArrayElemType; }
  virtual const icChar *GetClassName() const { return "CIccMpeTintArray"; }

  virtual void Describe(std::string &sDescription, int verboseness =0);

  virtual bool Read(icUInt32Number size, CIccIO *pIO);
  virtual bool Write(CIccIO *pIO);

  virtual bool Begin(icElemInterp nInterp, CIccTagMultiProcessElement *pMPE);
  virtual void Apply(CIccApplyMpe *pApply, icFloatNumber *dstPixel, const icFloatNumber *srcPixel) const;

  virtual icValidateStatus Validate(std::string sigPath, std::string &sReport, const CIccTagMultiProcessElement* pMPE=NULL) const;

protected:
  CIccTagNumArray *m_Array;
};



typedef enum {
  ic3x3Matrix,
  ic3x4Matrix,
  ic4x3Matrix,
  ic4x4Matrix,
  icOtherMatrix
} icMatrixElemType;

/**
****************************************************************************
* Class: CIccMpeMatrix
* 
* Purpose: The Matrix element with constant offset
*****************************************************************************
*/
class CIccMpeMatrix : public CIccMultiProcessElement
{
public:
  CIccMpeMatrix();
  CIccMpeMatrix(const CIccMpeMatrix &ITPC);
  CIccMpeMatrix &operator=(const CIccMpeMatrix &ParamCurveTag);
  virtual CIccMultiProcessElement *NewCopy() const { return new CIccMpeMatrix(*this);}
  virtual ~CIccMpeMatrix();

  virtual icElemTypeSignature GetType() const { return icSigMatrixElemType; }
  virtual const icChar *GetClassName() const { return "CIccMpeMatrix"; }

  virtual void Describe(std::string &sDescription, int verboseness);

  virtual bool Read(icUInt32Number size, CIccIO *pIO);
  virtual bool Write(CIccIO *pIO);

  bool SetSize(icUInt16Number nInputChannels, icUInt16Number nOutputChannels, bool bUseConstants = true);

  icFloatNumber *GetMatrix() const {return m_pMatrix;}
  icFloatNumber *GetConstants() const {return m_pConstants;}
  bool GetApplyConstants() const {return m_bApplyConstants;}

  virtual bool Begin(icElemInterp nInterp, CIccTagMultiProcessElement *pMPE);
  virtual void Apply(CIccApplyMpe *pApply, icFloatNumber *dstPixel, const icFloatNumber *srcPixel) const;

  virtual icValidateStatus Validate(std::string sigPath, std::string &sReport, const CIccTagMultiProcessElement* pMPE=NULL) const;

protected:
  icFloatNumber *m_pMatrix;
  icFloatNumber *m_pConstants;
  icUInt32Number m_size;
  icMatrixElemType m_type;
  bool m_bApplyConstants;
};


typedef enum {
  ic1dInterp,
  ic2dInterp,
  ic3dInterpTetra,
  ic3dInterp,
  ic4dInterp,
  ic5dInterp,
  ic6dInterp,
  icNdInterp,
} icCLUTElemType;


/**
****************************************************************************
* Class: CIccMpeCLUT
* 
* Purpose: The float Color LookUp Table tag
*****************************************************************************
*/
class CIccMpeCLUT : public CIccMultiProcessElement
{
public:
  CIccMpeCLUT();
  CIccMpeCLUT(const CIccMpeCLUT &clut);
  CIccMpeCLUT &operator=(const CIccMpeCLUT &clut);
  virtual CIccMultiProcessElement *NewCopy() const { return new CIccMpeCLUT(*this);}
  virtual ~CIccMpeCLUT();

  virtual icElemTypeSignature GetType() const { return icSigCLutElemType; }
  virtual const icChar *GetClassName() const { return "CIccMpeCLUT"; }

  virtual void Describe(std::string &sDescription, int verboseness);

  virtual bool Read(icUInt32Number size, CIccIO *pIO);
  virtual bool Write(CIccIO *pIO);

  virtual bool Begin(icElemInterp nInterp, CIccTagMultiProcessElement *pMPE);
  virtual void Apply(CIccApplyMpe *pApply, icFloatNumber *dstPixel, const icFloatNumber *srcPixel) const;

  virtual icValidateStatus Validate(std::string sigPath, std::string &sReport, const CIccTagMultiProcessElement* pMPE=NULL) const;

  CIccCLUT *GetCLUT() { return m_pCLUT; }
  void SetCLUT(CIccCLUT *pCLUT);

protected:
  CIccCLUT *m_pCLUT;
  icCLUTElemType m_interpType;
};

/****************************************************************************
* Class: CIccMpeExtCLUT
* 
* Purpose: The extended Color LookUp Table tag
*****************************************************************************
*/
class CIccMpeExtCLUT : public CIccMpeCLUT
{
public:
  CIccMpeExtCLUT();
  CIccMpeExtCLUT(const CIccMpeExtCLUT &clut);
  CIccMpeExtCLUT &operator=(const CIccMpeExtCLUT &clut);
  virtual CIccMultiProcessElement *NewCopy() const { return new CIccMpeExtCLUT(*this);}
  virtual ~CIccMpeExtCLUT() {}

  virtual icElemTypeSignature GetType() const { return icSigExtCLutElemType; }
  virtual const icChar *GetClassName() const { return "CIccMpeExtCLUT"; }

  virtual void Describe(std::string &sDescription, int verboseness);

  virtual bool Read(icUInt32Number size, CIccIO *pIO);
  virtual bool Write(CIccIO *pIO);

  virtual icValidateStatus Validate(std::string sigPath, std::string &sReport, const CIccTagMultiProcessElement* pMPE=NULL) const;

  bool SetStorageType(icUInt16Number nStorateType);
  icUInt16Number GetStorageType() { return m_storageType; }

protected:
  icUInt16Number m_storageType;
  icUInt16Number m_nReserved2;
};

class CIccCamConverter;

/**
****************************************************************************
* Class: CIccMpeCAM
* 
* Purpose: The float Color LookUp Table tag
*****************************************************************************
*/
class CIccMpeCAM : public CIccMultiProcessElement
{
public:
  virtual ~CIccMpeCAM();

  virtual icElemTypeSignature GetType() const = 0;
  virtual const icChar *GetClassName() const = 0;

  virtual const icChar *GetXformName() const = 0;

  virtual void Describe(std::string &sDescription, int verboseness);

  virtual bool Read(icUInt32Number size, CIccIO *pIO);
  virtual bool Write(CIccIO *pIO);

  virtual bool Begin(icElemInterp nInterp, CIccTagMultiProcessElement *pMPE);
  virtual void Apply(CIccApplyMpe *pApply, icFloatNumber *dstPixel, const icFloatNumber *srcPixel) const =0;

  virtual icValidateStatus Validate(std::string sigPath, std::string &sReport, const CIccTagMultiProcessElement* pMPE=NULL) const;

  CIccCamConverter *GetCAM() { return m_pCAM; }
  void SetCAM(CIccCamConverter *pCAM);

protected:
  CIccMpeCAM();

  CIccCamConverter *m_pCAM;
};


/**
****************************************************************************
* Class: CIccMpeXYZToJab
* 
* Purpose: Converts XYZ to Jab using color appearance model
*****************************************************************************
*/
class CIccMpeXYZToJab : public CIccMpeCAM
{
public:
  CIccMpeXYZToJab();
  CIccMpeXYZToJab(const CIccMpeXYZToJab &cam);
  CIccMpeXYZToJab &operator=(const CIccMpeXYZToJab &cam);
  virtual CIccMultiProcessElement *NewCopy() const { return new CIccMpeXYZToJab(*this);}
  virtual ~CIccMpeXYZToJab();

  virtual icElemTypeSignature GetType() const {return icSigXYZToJabElemType; }
  virtual const icChar *GetClassName() const {return "CIccMpeXYZToJab"; }

  virtual const icChar *GetXformName() const {return "XYZToJab"; }

  virtual void Apply(CIccApplyMpe *pApply, icFloatNumber *dstPixel, const icFloatNumber *srcPixel) const;
};

/**
****************************************************************************
* Class: CIccMpeJabToXYZ
* 
* Purpose: Converts Jab to XYZ using color appearance model
*****************************************************************************
*/
class CIccMpeJabToXYZ : public CIccMpeCAM
{
public:
  CIccMpeJabToXYZ();
  CIccMpeJabToXYZ(const CIccMpeJabToXYZ &cam);
  CIccMpeJabToXYZ &operator=(const CIccMpeJabToXYZ &cam);
  virtual CIccMultiProcessElement *NewCopy() const { return new CIccMpeJabToXYZ(*this);}
  virtual ~CIccMpeJabToXYZ();

  virtual icElemTypeSignature GetType() const {return icSigJabToXYZElemType; }
  virtual const icChar *GetClassName() const {return "CIccMpeJabToXYZ"; }

  virtual const icChar *GetXformName() const {return "JabToXyz"; }

  virtual void Apply(CIccApplyMpe *pApply, icFloatNumber *dstPixel, const icFloatNumber *srcPixel) const;
};

//CIccMPElements support
#ifdef USEREFICCMAXNAMESPACE
}
#endif



#endif //_ICCELEMBASIC_H
