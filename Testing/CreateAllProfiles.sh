#!/bin/sh
##
## Assumes "iccFromXml" is on $PATH
##

# purge any ICCs from previous runs
find . -iname "*.icc" -delete

# print which executable is being used
if ! command -v iccFromXml 
then
    exit
fi

# echo the conversions so we know what fails
set -x

cd Calc
iccFromXml CameraModel.xml CameraModel.icc
iccFromXml ElevenChanKubelkaMunk.xml ElevenChanKubelkaMunk.icc
iccFromXml RGBWProjector.xml RGBWProjector.icc
iccFromXml argbCalc.xml argbCalc.icc
iccFromXml srgbCalcTest.xml srgbCalcTest.icc
iccFromXml srgbCalc++Test.xml srgbCalc++Test.icc
# calcImport.xml is not a standalone XML file
# calcVars.xml is not a standalone XML file

cd ../CalcTest
iccFromXml calcCheckInit.xml   calcCheckInit.icc
iccFromXml calcExercizeOps.xml calcExercizeOps.icc

cd ../CMYK-3DLUTs
iccFromXml CMYK-3DLUTs.xml  CMYK-3DLUTs.icc
iccFromXml CMYK-3DLUTs2.xml CMYK-3DLUTs2.icc

cd ../Display
iccFromXml GrayGSDF.xml GrayGSDF.icc
iccFromXml LCDDisplay.xml LCDDisplay.icc
iccFromXml LaserProjector.xml LaserProjector.icc
iccFromXml Rec2020rgbColorimetric.xml Rec2020rgbColorimetric.icc
iccFromXml Rec2020rgbSpectral.xml Rec2020rgbSpectral.icc
iccFromXml Rec2100HlgFull.xml Rec2100HlgFull.icc
iccFromXml Rec2100HlgNarrow.xml Rec2100HlgNarrow.icc
iccFromXml RgbGSDF.xml RgbGSDF.icc
iccFromXml sRGB_D65_MAT-300lx.xml sRGB_D65_MAT.icc
iccFromXml sRGB_D65_MAT-500lx.xml sRGB_D65_MAT.icc
iccFromXml sRGB_D65_MAT.xml sRGB_D65_MAT.icc
iccFromXml sRGB_D65_colorimetric.xml sRGB_D65_colorimetric.icc

cd ../Encoding
iccFromXml ISO22028-Encoded-sRGB.xml ISO22028-Encoded-sRGB.icc
iccFromXml ISO22028-Encoded-bg-sRGB.xml ISO22028-Encoded-bg-sRGB.icc
iccFromXml sRgbEncoding.xml sRgbEncoding.icc
iccFromXml sRgbEncodingOverrides.xml sRgbEncodingOverrides.icc

cd ../ICS
iccFromXml Lab_float-D65_2deg-Part1.xml    Lab_float-D65_2deg-Part1.icc
iccFromXml Lab_float-IllumA_2deg-Part2.xml Lab_float-IllumA_2deg-Part2.icc
iccFromXml Lab_int-D65_2deg-Part1.xml      Lab_int-D65_2deg-Part1.icc
iccFromXml Lab_int-IllumA_2deg-Part2.xml   Lab_int-IllumA_2deg-Part2.icc
iccFromXml Rec2100HlgFull-Part1.xml Rec2100HlgFull-Part1.icc
iccFromXml Rec2100HlgFull-Part2.xml Rec2100HlgFull-Part2.icc
iccFromXml Rec2100HlgFull-Part3.xml Rec2100HlgFull-Part3.icc
iccFromXml Spec400_10_700-D50_2deg-Part1.xml Spec400_10_700-D50_2deg-Part1.icc
iccFromXml Spec400_10_700-D93_2deg-Part2.xml Spec400_10_700-D93_2deg-Part2.icc
iccFromXml XYZ_float-D65_2deg-Part1.xml    XYZ_float-D65_2deg-Part1.icc
iccFromXml XYZ_float-IllumA_2deg-Part2.xml XYZ_float-IllumA_2deg-Part2.icc
iccFromXml XYZ_int-D65_2deg-Part1.xml      XYZ_int-D65_2deg-Part1.icc
iccFromXml XYZ_int-IllumA_2deg-Part2.xml   XYZ_int-IllumA_2deg-Part2.icc

cd ../Named
iccFromXml FluorescentNamedColor.xml FluorescentNamedColor.icc
iccFromXml NamedColor.xml NamedColor.icc
iccFromXml SparseMatrixNamedColor.xml SparseMatrixNamedColor.icc

cd ../Overprint
iccFromXml 17ChanPart1.xml 17ChanPart1.icc

cd ../mcs
iccFromXml 17ChanWithSpots-MVIS.xml 17ChanWithSpots-MVIS.icc
iccFromXml 18ChanWithSpots-MVIS.xml 18ChanWithSpots-MVIS.icc
iccFromXml 6ChanSelect-MID.xml 6ChanSelect-MID.icc

cd Flexo-CMYKOGP
iccFromXml 4ChanSelect-MID.xml 4ChanSelect-MID.icc
iccFromXml 7ChanSelect-MID.xml 7ChanSelect-MID.icc
iccFromXml CGYK-SelectMID.xml  CGYK-SelectMID.icc
iccFromXml CMPK-SelectMID.xml  CMPK-SelectMID.icc
iccFromXml CMYK-SelectMID.xml  CMYK-SelectMID.icc
iccFromXml CMYKOGP-MVIS-Smooth.xml CMYKOGP-MVIS-Smooth.icc
iccFromXml OMYK-SelectMID.xml  OMYK-SelectMID.icc
cd ..

cd ../PCC
iccFromXml Lab_float-D50_2deg.xml Lab_float-D50_2deg.icc
iccFromXml Lab_float-D93_2deg-MAT.xml Lab_float-D93_2deg-MAT.icc
iccFromXml Lab_int-D50_2deg.xml Lab_int-D50_2deg.icc
iccFromXml Lab_int-D65_2deg-MAT.xml Lab_int-D65_2deg-MAT.icc
iccFromXml Lab_int-IllumA_2deg-MAT.xml Lab_int-IllumA_2deg-MAT.icc
iccFromXml Spec380_10_730-D50_2deg.xml Spec380_10_730-D50_2deg.icc
iccFromXml Spec380_10_730-D65_2deg-MAT.xml Spec380_10_730-D65_2deg-MAT.icc
iccFromXml Spec380_1_780-D50_2deg.xml Spec380_1_780-D50_2deg.icc
iccFromXml Spec380_5_780-D50_2deg.xml Spec380_5_780-D50_2deg.icc
iccFromXml Spec400_10_700-B_2deg-Abs.xml Spec400_10_700-B_2deg-Abs.icc
iccFromXml Spec400_10_700-B_2deg-CAM.xml Spec400_10_700-B_2deg-CAM.icc
iccFromXml Spec400_10_700-B_2deg-CAT02.xml Spec400_10_700-B_2deg-CAT02.icc
iccFromXml Spec400_10_700-B_2deg-MAT.xml Spec400_10_700-B_2deg-MAT.icc
iccFromXml Spec400_10_700-D50_10deg-Abs.xml Spec400_10_700-D50_10deg-Abs.icc
iccFromXml Spec400_10_700-D50_10deg-MAT.xml Spec400_10_700-D50_10deg-MAT.icc
iccFromXml Spec400_10_700-D50_20yo2deg-MAT.xml Spec400_10_700-D50_20yo2deg-MAT.icc
iccFromXml Spec400_10_700-D50_2deg-Abs.xml Spec400_10_700-D50_2deg-Abs.icc
iccFromXml Spec400_10_700-D50_2deg.xml Spec400_10_700-D50_2deg.icc
iccFromXml Spec400_10_700-D50_40yo2deg-MAT.xml Spec400_10_700-D50_40yo2deg-MAT.icc
iccFromXml Spec400_10_700-D50_60yo2deg-MAT.xml Spec400_10_700-D50_60yo2deg-MAT.icc
iccFromXml Spec400_10_700-D50_80yo2deg-MAT.xml Spec400_10_700-D50_80yo2deg-MAT.icc
iccFromXml Spec400_10_700-D65_10deg-Abs.xml Spec400_10_700-D65_10deg-Abs.icc
iccFromXml Spec400_10_700-D65_10deg-MAT.xml Spec400_10_700-D65_10deg-MAT.icc
iccFromXml Spec400_10_700-D65_20yo2deg-MAT.xml Spec400_10_700-D65_20yo2deg-MAT.icc
iccFromXml Spec400_10_700-D65_2deg-Abs.xml Spec400_10_700-D65_2deg-Abs.icc
iccFromXml Spec400_10_700-D65_2deg-MAT.xml Spec400_10_700-D65_2deg-MAT.icc
iccFromXml Spec400_10_700-D65_40yo2deg-MAT.xml Spec400_10_700-D65_40yo2deg-MAT.icc
iccFromXml Spec400_10_700-D65_60yo2deg-MAT.xml Spec400_10_700-D65_60yo2deg-MAT.icc
iccFromXml Spec400_10_700-D65_80yo2deg-MAT.xml Spec400_10_700-D65_80yo2deg-MAT.icc
iccFromXml Spec400_10_700-D93_10deg-Abs.xml Spec400_10_700-D93_10deg-Abs.icc
iccFromXml Spec400_10_700-D93_10deg-MAT.xml Spec400_10_700-D93_10deg-MAT.icc
iccFromXml Spec400_10_700-D93_2deg-Abs.xml Spec400_10_700-D93_2deg-Abs.icc
iccFromXml Spec400_10_700-D93_2deg-MAT.xml Spec400_10_700-D93_2deg-MAT.icc
iccFromXml Spec400_10_700-DB_2deg-Abs.xml Spec400_10_700-DB_2deg-Abs.icc
iccFromXml Spec400_10_700-DB_2deg-CAT02.xml Spec400_10_700-DB_2deg-CAT02.icc
iccFromXml Spec400_10_700-DB_2deg-MAT.xml Spec400_10_700-DB_2deg-MAT.icc
iccFromXml Spec400_10_700-DG_2deg-Abs.xml Spec400_10_700-DG_2deg-Abs.icc
iccFromXml Spec400_10_700-DG_2deg-CAT02.xml Spec400_10_700-DG_2deg-CAT02.icc
iccFromXml Spec400_10_700-DG_2deg-MAT.xml Spec400_10_700-DG_2deg-MAT.icc
iccFromXml Spec400_10_700-DR_2deg-Abs.xml Spec400_10_700-DR_2deg-Abs.icc
iccFromXml Spec400_10_700-DR_2deg-CAT02.xml Spec400_10_700-DR_2deg-CAT02.icc
iccFromXml Spec400_10_700-DR_2deg-MAT.xml Spec400_10_700-DR_2deg-MAT.icc
iccFromXml Spec400_10_700-F11_2deg-CAT.xml Spec400_10_700-F11_2deg-CAT.icc
iccFromXml Spec400_10_700-F11_2deg-MAT.xml Spec400_10_700-F11_2deg-MAT.icc
iccFromXml Spec400_10_700-G_2deg-Abs.xml Spec400_10_700-G_2deg-Abs.icc
iccFromXml Spec400_10_700-G_2deg-CAT02.xml Spec400_10_700-G_2deg-CAT02.icc
iccFromXml Spec400_10_700-G_2deg-MAT.xml Spec400_10_700-G_2deg-MAT.icc
iccFromXml Spec400_10_700-IllumA_10deg-Abs.xml Spec400_10_700-IllumA_10deg-Abs.icc
iccFromXml Spec400_10_700-IllumA_10deg-MAT.xml Spec400_10_700-IllumA_10deg-MAT.icc
iccFromXml Spec400_10_700-IllumA_2deg-Abs.xml Spec400_10_700-IllumA_2deg-Abs.icc
iccFromXml Spec400_10_700-IllumA_2deg-CAT.xml Spec400_10_700-IllumA_2deg-CAT.icc
iccFromXml Spec400_10_700-IllumA_2deg-MAT.xml Spec400_10_700-IllumA_2deg-MAT.icc
iccFromXml Spec400_10_700-N_2deg-Abs.xml Spec400_10_700-N_2deg-Abs.icc
iccFromXml Spec400_10_700-N_2deg-CAT02.xml Spec400_10_700-N_2deg-CAT02.icc
iccFromXml Spec400_10_700-N_2deg-MAT.xml Spec400_10_700-N_2deg-MAT.icc
iccFromXml Spec400_10_700-R1_2deg-Abs.xml Spec400_10_700-R1_2deg-Abs.icc
iccFromXml Spec400_10_700-R1_2deg-CAT02.xml Spec400_10_700-R1_2deg-CAT02.icc
iccFromXml Spec400_10_700-R1_2deg-MAT.xml Spec400_10_700-R1_2deg-MAT.icc
iccFromXml Spec400_10_700-R2_2deg-Abs.xml Spec400_10_700-R2_2deg-Abs.icc
iccFromXml Spec400_10_700-R2_2deg-CAT02.xml Spec400_10_700-R2_2deg-CAT02.icc
iccFromXml Spec400_10_700-R2_2deg-MAT.xml Spec400_10_700-R2_2deg-MAT.icc
iccFromXml Spec400_10_700-Y_2deg-Abs.xml Spec400_10_700-Y_2deg-Abs.icc
iccFromXml Spec400_10_700-Y_2deg-CAT02.xml Spec400_10_700-Y_2deg-CAT02.icc
iccFromXml Spec400_10_700-Y_2deg-MAT.xml Spec400_10_700-Y_2deg-MAT.icc
iccFromXml XYZ_float-D50_2deg.xml XYZ_float-D50_2deg.icc
iccFromXml XYZ_float-D65_2deg-MAT.xml XYZ_float-D65_2deg-MAT.icc
iccFromXml XYZ_int-D50_2deg.xml XYZ_int-D50_2deg.icc
iccFromXml XYZ_int-D65_2deg-MAT-Lvl2.xml XYZ_int-D65_2deg-MAT-Lvl2.icc
iccFromXml XYZ_int-D65_2deg-MAT.xml XYZ_int-D65_2deg-MAT.icc

cd ../SpecRef
iccFromXml argbRef.xml argbRef.icc
iccFromXml SixChanCameraRef.xml SixChanCameraRef.icc
iccFromXml SixChanInputRef.xml  SixChanInputRef.icc
iccFromXml srgbRef.xml srgbRef.icc
iccFromXml RefDecC.xml RefDecC.icc
iccFromXml RefDecH.xml RefDecH.icc
iccFromXml RefIncW.xml RefIncW.icc
# RefEstimationImport.xml is not a standalone XML file

set -
cd ..

# Count number of ICCs that got created - should be 129
find . -iname "*.icc" | wc -l
