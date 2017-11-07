/** @file
    File:       IccTagFactory.cpp

    Contains:   Implementation of the CIccTag class and creation factories

    Version:    V1

    Copyright:  � see ICC Software License
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
// -Oct 30, 2005
// Added CICCTag Creation using factory support
//
//////////////////////////////////////////////////////////////////////

#include "IccTag.h"
#include "IccTagFactory.h"
#include "IccUtil.h"
#include "IccProfile.h"

#ifdef USEREFICCMAXNAMESPACE
namespace refIccMAX {
#endif

CIccTag* CIccSpecTagFactory::CreateTag(icTagTypeSignature tagSig)
{
  switch(tagSig) {
    case icSigSignatureType:
      return new CIccTagSignature;

    case icSigTextType:
      return new CIccTagText;

    case icSigXYZArrayType:
      return new CIccTagXYZ;

    case icSigUInt8ArrayType:
      return new CIccTagUInt8;

    case icSigUInt16ArrayType:
      return new CIccTagUInt16;

    case icSigUInt32ArrayType:
      return new CIccTagUInt32;

    case icSigUInt64ArrayType:
      return new CIccTagUInt64;

    case icSigS15Fixed16ArrayType:
      return new CIccTagS15Fixed16;

    case icSigU16Fixed16ArrayType:
      return new CIccTagU16Fixed16;

    case icSigFloat16ArrayType:
      return new CIccTagFloat16;

    case icSigFloat32ArrayType:
      return new CIccTagFloat32;

    case icSigFloat64ArrayType:
      return new CIccTagFloat64;

    case icSigGamutBoundaryDescType:
      return new CIccTagGamutBoundaryDesc;

    case icSigCurveType:
      return new CIccTagCurve;

    case icSigSegmentedCurveType:
      return new CIccTagSegmentedCurve;

    case icSigMeasurementType:
      return new CIccTagMeasurement;

    case icSigMultiLocalizedUnicodeType:
      return new CIccTagMultiLocalizedUnicode;

    case icSigMultiProcessElementType:
      return new CIccTagMultiProcessElement();

    case icSigParametricCurveType:
      return new CIccTagParametricCurve;

    case icSigLutAtoBType:
      return new CIccTagLutAtoB;

    case icSigLutBtoAType:
      return new CIccTagLutBtoA;

    case icSigLut16Type:
      return new CIccTagLut16;

    case icSigLut8Type:
      return new CIccTagLut8;

    case icSigTextDescriptionType:
      return new CIccTagTextDescription;

    case icSigNamedColor2Type:
      return new CIccTagNamedColor2;

    case icSigChromaticityType:
      return new CIccTagChromaticity;

    case icSigDataType:
      return new CIccTagData;

    case icSigDateTimeType:
      return new CIccTagDateTime;

#ifndef ICC_UNSUPPORTED_TAG_DICT
    case icSigDictType:
      return new CIccTagDict;
#endif

    case icSigColorantOrderType:
      return new CIccTagColorantOrder;

    case icSigColorantTableType:
      return new CIccTagColorantTable;

    case icSigSparseMatrixArrayType:
      return new CIccTagSparseMatrixArray;

    case icSigViewingConditionsType:
      return new CIccTagViewingConditions;

    case icSigSpectralDataInfoTag:
      return new CIccTagSpectralDataInfo;

    case icSigSpectralViewingConditionsTag:
      return new CIccTagSpectralViewingConditions;

    case icSigProfileSequenceDescType:
      return new CIccTagProfileSeqDesc;

    case icSigResponseCurveSet16Type:
      return new CIccTagResponseCurveSet16;

    case icSigProfileSequceIdType:
      return new CIccTagProfileSequenceId;

    case icSigUtf8TextType:
      return new CIccTagUtf8Text;

    case icSigZipUtf8TextType:
      return new CIccTagUtf8Text;

    case icSigZipXmlType:
      return new CIccTagZipXml;

    case icSigUtf16TextType:
      return new CIccTagUtf16Text;

    case icSigTagArrayType:
      return new CIccTagArray;

    case icSigTagStructType:
      return new CIccTagStruct;

    case icSigScreeningType:
    case icSigUcrBgType:
    case icSigCrdInfoType:

    default:
      return new CIccTagUnknown;
  }
}

const icChar* CIccSpecTagFactory::GetTagSigName(icTagSignature tagSig)
{
  switch (tagSig) {
  case icSigAToB0Tag:
    return "AToB0Tag";

  case icSigAToB1Tag:
    return "AToB1Tag";

  case icSigAToB2Tag:
    return "AToB2Tag";

  case icSigAToB3Tag:
    return "AToB3Tag";

  case icSigAToM0Tag:
    return "AToM0Tag";

  case icSigBlueColorantTag:
    return "blueColorantTag";

  case icSigBlueTRCTag:
    return "blueTRCTag";

  case icSigBrdfColorimetricParameter0Tag:
    return "brdfColorimetricParameter0Tag";

  case icSigBrdfColorimetricParameter1Tag:
    return "brdfColorimetricParameter1Tag";

  case icSigBrdfColorimetricParameter2Tag:
    return "brdfColorimetricParameter2Tag";

  case icSigBrdfColorimetricParameter3Tag:
    return "brdfColorimetricParameter3Tag";

  case icSigBrdfSpectralParameter0Tag:
    return "brdfSpectralParameter0Tag";

  case icSigBrdfSpectralParameter1Tag:
    return "brdfSpectralParameter1Tag";

  case icSigBrdfSpectralParameter2Tag:
    return "brdfSpectralParameter2Tag";

  case icSigBrdfSpectralParameter3Tag:
    return "brdfSpectralParameter3Tag";

  case icSigBRDFAToB0Tag:
    return "brdfAToB0Tag";

  case icSigBRDFAToB1Tag:
    return "brdfAToB1Tag";

  case icSigBRDFAToB2Tag:
    return "brdfAToB2Tag";

  case icSigBRDFAToB3Tag:
    return "brdfAToB3Tag";

  case icSigBRDFDToB0Tag:
    return "brdfDToB0Tag";

  case icSigBRDFDToB1Tag:
    return "brdfDToB1Tag";

  case icSigBRDFDToB2Tag:
    return "brdfDToB2Tag";

  case icSigBRDFDToB3Tag:
    return "brdfDToB3Tag";

  case icSigBRDFMToB0Tag:
    return "brdfMToB0Tag";

  case icSigBRDFMToB1Tag:
    return "brdfMToB1Tag";

  case icSigBRDFMToB2Tag:
    return "brdfMToB2Tag";

  case icSigBRDFMToB3Tag:
    return "brdfMToB3Tag";

  case icSigBRDFMToS0Tag:
    return "brdfMToS0Tag";

  case icSigBRDFMToS1Tag:
    return "brdfMToS1Tag";

  case icSigBRDFMToS2Tag:
    return "brdfMToS2Tag";

  case icSigBRDFMToS3Tag:
    return "brdfMToS3Tag";

  case icSigBToA0Tag:
    return "BToA0Tag";

  case icSigBToA1Tag:
    return "BToA1Tag";

  case icSigBToA2Tag:
    return "BToA2Tag";

  case icSigBToA3Tag:
    return "BToA3Tag";

  case icSigBToD0Tag:
    return "BToD0Tag";

  case icSigBToD1Tag:
    return "BToD1Tag";

  case icSigBToD2Tag:
    return "BToD2Tag";

  case icSigBToD3Tag:
    return "BToD3Tag";

  case icSigCalibrationDateTimeTag:
    return "calibrationDateTimeTag";

  case icSigCharTargetTag:
    return "charTargetTag";

  case icSigChromaticityTag:
    return "chromaticityTag";

  case icSigCopyrightTag:
    return "copyrightTag";

  case icSigCrdInfoTag:
    return "crdInfoTag";

  case icSigDataTag:
    return "dataTag";

  case icSigDateTimeTag:
    return "dateTimeTag";

  case icSigDeviceMfgDescTag:
    return "deviceMfgDescTag";

  case icSigDeviceModelDescTag:
    return "deviceModelDescTag";

  case icSigMetaDataTag:
    return "metaDataTag";

  case icSigDToB0Tag:
    return "DToB0Tag";

  case icSigDToB1Tag:
    return "DToB1Tag";

  case icSigDToB2Tag:
    return "DToB2Tag";

  case icSigDToB3Tag:
    return "DToB3Tag";

  case icSigGamutTag:
    return "gamutTag";

  case icSigGamutBoundaryDescription0Tag:
    return "gamutBoundaryDescription0Tag";

  case icSigGamutBoundaryDescription1Tag:
    return "gamutBoundaryDescription0Tag";

  case icSigGamutBoundaryDescription2Tag:
    return "gamutBoundaryDescription0Tag";

  case icSigGamutBoundaryDescription3Tag:
    return "gamutBoundaryDescription0Tag";

  case icSigGrayTRCTag:
    return "grayTRCTag";

  case icSigGreenColorantTag:
    return "greenColorantTag";

  case icSigGreenTRCTag:
    return "greenTRCTag";

  case icSigLuminanceTag:
    return "luminanceTag";

  case icSigMeasurementTag:
    return "measurementTag";

  case icSigMediaBlackPointTag:
    return "mediaBlackPointTag";

  case icSigMediaWhitePointTag:
    return "mediaWhitePointTag";

  case icSigMToA0Tag:
    return "MToA0Tag";

  case icSigMToB0Tag:
    return "MToB0Tag";

  case icSigMToB1Tag:
    return "MToB1Tag";

  case icSigMToB2Tag:
    return "MToB2Tag";

  case icSigMToB3Tag:
    return "MToB3Tag";

  case icSigMToS0Tag:
    return "MToS0Tag";

  case icSigMToS1Tag:
    return "MToS1Tag";

  case icSigMToS2Tag:
    return "MToS2Tag";

  case icSigMToS3Tag:
    return "MToS3Tag";

  case icSigNamedColor2Tag:
    return "namedColor2Tag";

  case icSigPreview0Tag:
    return "preview0Tag";

  case icSigPreview1Tag:
    return "preview1Tag";

  case icSigPreview2Tag:
    return "preview2Tag";

  case icSigPrintConditionTag:
    return "printConditionTag";

  case icSigProfileDescriptionTag:
    return "profileDescriptionTag";

  case icSigProfileSequenceDescTag:
    return "profileSequenceDescTag";

  case icSigProfileSequceIdTag:
    return "profileSequenceIdentifierTag";

  case icSigPs2CRD0Tag:
    return "ps2CRD0Tag";

  case icSigPs2CRD1Tag:
    return "ps2CRD1Tag";

  case icSigPs2CRD2Tag:
    return "ps2CRD2Tag";

  case icSigPs2CRD3Tag:
    return "ps2CRD3Tag";

  case icSigPs2CSATag:
    return "ps2CSATag";

  case icSigPs2RenderingIntentTag:
    return "ps2RenderingIntentTag";

  case icSigRedColorantTag:
    return "redColorantTag";

  case icSigRedTRCTag:
    return "redTRCTag";

  case icSigScreeningDescTag:
    return "screeningDescTag";

  case icSigScreeningTag:
    return "screeningTag";

  case icSigTechnologyTag:
    return "technologyTag";

  case icSigUcrBgTag:
    return "ucrBgTag";

  case icSigViewingCondDescTag:
    return "viewingCondDescTag";

  case icSigViewingConditionsTag:
    return "viewingConditionsTag";

  case icSigSpectralViewingConditionsTag:
    return "spectralViewingConditionsTag";

  case icSigColorantOrderTag:
    return "colorantOrderTag";

  case icSigColorantTableTag:
    return "colorantTableTag";

  case icSigChromaticAdaptationTag:
    return "chromaticAdaptationTag";

  case icSigColorantTableOutTag:
    return "colorantTableOutTag";

  case icSigOutputResponseTag:
    return "outputResponseTag";

  case icSigPerceptualRenderingIntentGamutTag:
    return "perceptualRenderingIntentGamutTag";

  case icSigSaturationRenderingIntentGamutTag:
    return "saturationRenderingIntentGamutTag";

  case icSigCxFTag:
    return "CxfTag";

  case icSigSpectralDataInfoTag:
    return "spectralDataInfoTag";

  case icSigSpectralMediaWhitePointTag:
    return "spectralMediaWhitePointTag";

  case icSigCustomToStandardPcsTag:
    return "customToStandardPcsTag";

  case icSigStandardToCustomPcsTag:
    return "standardToCustomPcsTag";

  case icSigColorEncodingParamsTag:
    return "icSigColorEncodingParamsTag";

  case icSigColorSpaceNameTag:
    return "icSigColorSpaceNameTag";

  case icSigReferenceNameTag:
    return "icSigReferenceNameTag";

  case icSigMaterialTypeArrayTag:
    return "icSigMaterialTypeArrayTag";

  case icSigMaterialDefaultValuesTag:
    return "icSigMaterialDefaultValuesTag";

  default:
    return NULL;
  }
  return NULL;
}

const icChar* CIccSpecTagFactory::GetTagTypeSigName(icTagTypeSignature tagSig)
{
  switch (tagSig) {
  case icSigChromaticityType:
    return "chromaticityType";

  case icSigColorantOrderType:
    return "colorantOrderType";

  case icSigColorantTableType:
    return "colorantTableType";

  case icSigCrdInfoType:
    return "crdInfoType";

  case icSigCurveType:
    return "curveType";

  case icSigSegmentedCurveType:
    return "segmentedCurveType";

  case icSigDataType:
    return "dataType";

  case icSigDateTimeType:
    return "dateTimeType";

  case icSigDeviceSettingsType:
    return "deviceSettingsType";

  case icSigDictType:
    return "dictType";

  case icSigGamutBoundaryDescType:
    return "gamutBoundaryDescType";

  case icSigLut16Type:
    return "lut16Type";

  case icSigLut8Type:
    return "lut8Type";

  case icSigLutAtoBType:
    return "lutAtoBType";

  case icSigLutBtoAType:
    return "lutBtoAType";

  case icSigMeasurementType:
    return "measurementType";

  case icSigMultiLocalizedUnicodeType:
    return "multiLocalizedUnicodeType";

  case icSigMultiProcessElementType:
    return "multiProcessElementType";

  case icSigNamedColor2Type:
    return "namedColor2Type";

  case icSigParametricCurveType:
    return "parametricCurveType";

  case icSigResponseCurveSet16Type:
    return "responseCurveSet16Type";

  case icSigProfileSequenceDescType:
    return "profileSequenceDescType";

  case icSigS15Fixed16ArrayType:
    return "s15Fixed16 ArrayType";

  case icSigScreeningType:
    return "screeningType";

  case icSigSignatureType:
    return "signatureType";

  case icSigSpectralDataInfoType:
    return "spectralDataInfoType";

  case icSigSpectralViewingConditionsType:
    return "spectralViewingConditionsType";

  case icSigTextType:
    return "textType";

  case icSigTextDescriptionType:
    return "textDescriptionType";

  case icSigU16Fixed16ArrayType:
    return "u16Fixed16 Type";

  case icSigUcrBgType:
    return "ucrBgType";

  case icSigSparseMatrixArrayType:
    return "sparseMatrixArrayType";

  case icSigUInt16ArrayType:
    return "uInt16 Type";

  case icSigUInt32ArrayType:
    return "uInt32 Type";

  case icSigUInt64ArrayType:
    return "uInt64 Type";

  case icSigUInt8ArrayType:
    return "uInt8 Type";

  case icSigFloat16ArrayType:
    return "float16 Type";

  case icSigFloat32ArrayType:
    return "float32 Type";

  case icSigFloat64ArrayType:
    return "float64 Type";

  case icSigUtf8TextType:
    return "UTF8 Text Type";

  case icSigZipUtf8TextType:
    return "ZIP Compressed UTF8 Text Type";

  case icSigZipXmlType:
    return "ZIP Compressed UTF8 XML Type";

  case icSigUtf16TextType:
    return "UTF16 Text Type";

  case icSigTagArrayType:
    return "tagArrayType";

  case icSigTagStructType:
    return "tagStructType";

  case icSigViewingConditionsType:
    return "viewingConditionsType";

  case icSigXYZArrayType:
    return "XYZ Type";

  case icSigProfileSequceIdType:
    return "profileSequenceIdentifierType";

  default:
    return NULL;
  }

  return NULL;
}

std::auto_ptr<CIccTagCreator> CIccTagCreator::theTagCreator;

CIccTagCreator::~CIccTagCreator()
{
  IIccTagFactory *pFactory = DoPopFactory(true);

  while (pFactory) {
    delete pFactory;
    pFactory = DoPopFactory(true);
  }
}

CIccTagCreator* CIccTagCreator::GetInstance()
{
  if (!theTagCreator.get()) {
    theTagCreator = CIccTagCreatorPtr(new CIccTagCreator);

    theTagCreator->DoPushFactory(new CIccSpecTagFactory);
  }

  return theTagCreator.get();
}

CIccTag* CIccTagCreator::DoCreateTag(icTagTypeSignature tagTypeSig)
{
  CIccTagFactoryList::iterator i;
  CIccTag *rv = NULL;

  for (i=factoryStack.begin(); i!=factoryStack.end(); i++) {
    rv = (*i)->CreateTag(tagTypeSig);
    if (rv)
      break;
  }
  return rv;
}

const icChar* CIccTagCreator::DoGetTagSigName(icTagSignature tagSig)
{
  CIccTagFactoryList::iterator i;
  const icChar* rv;

  for (i=factoryStack.begin(); i!=factoryStack.end(); i++) {
    rv = (*i)->GetTagSigName(tagSig);
    if (rv)
      return rv;
  }

  return NULL;
}

const icChar* CIccTagCreator::DoGetTagTypeSigName(icTagTypeSignature tagTypeSig)
{
  CIccTagFactoryList::iterator i;
  const icChar* rv;

  for (i=factoryStack.begin(); i!=factoryStack.end(); i++) {
    rv = (*i)->GetTagTypeSigName(tagTypeSig);
    if (rv)
      return rv;
  }

  return NULL;
}

void CIccTagCreator::DoPushFactory(IIccTagFactory *pFactory)
{
  factoryStack.push_front(pFactory);
}

IIccTagFactory* CIccTagCreator::DoPopFactory(bool bAll /*=false*/)
{
//  int nNum = (bAll ? 0 : 1);

  if (factoryStack.size()>0) {
    CIccTagFactoryList::iterator i=factoryStack.begin();
    IIccTagFactory* rv = (*i);
    factoryStack.pop_front();
    return rv;
  }
  return NULL;
}

#ifdef USEREFICCMAXNAMESPACE
} //namespace refIccMAX
#endif
