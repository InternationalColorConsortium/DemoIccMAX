#!/bin/sh -v
##
## Assumes "iccFromXml" is on $PATH
## Use "sudo make install" to install all CLI tools to default location of "/usr/local/bin"
##

# purge any ICCs from previous runs
find . -iname "*.icc" -delete

cd Calc
iccFromXml CameraModel.xml CameraModel.icc
iccFromXml ElevenChanKubelkaMunk.xml ElevenChanKubelkaMunk.icc
iccFromXml RGBWProjector.xml RGBWProjector.icc
iccFromXml argbCalc.xml argbCalc.icc
iccFromXml srgbCalcTest.xml srgbCalcTest.icc
iccFromXml srgbCalc++Test.xml srgbCalc++Test.icc

cd ../CMYK-3DLUTs
iccFromXml CMYK-3DLUTs.xml CMYK-3DLUTs.icc
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

cd ../Named
iccFromXml FluorescentNamedColor.xml FluorescentNamedColor.icc
iccFromXml NamedColor.xml NamedColor.icc
iccFromXml SparseMatrixNamedColor.xml SparseMatrixNamedColor.icc

cd ../mcs
iccFromXml 17ChanWithSpots-MVIS.xml 17ChanWithSpots-MVIS.icc
iccFromXml 18ChanWithSpots-MVIS.xml 18ChanWithSpots-MVIS.icc
iccFromXml 6ChanSelect-MID.xml 6ChanSelect-MID.icc

cd ../PCC
iccFromXml  Lab_float-D50_2deg.xml Lab_float-D50_2deg.icc
iccFromXml  Lab_float-D93_2deg-MAT.xml Lab_float-D93_2deg-MAT.icc
iccFromXml  Lab_int-D50_2deg.xml Lab_int-D50_2deg.icc
iccFromXml  Lab_int-D65_2deg-MAT.xml Lab_int-D65_2deg-MAT.icc
iccFromXml  Lab_int-IllumA_2deg-MAT.xml Lab_int-IllumA_2deg-MAT.icc
iccFromXml  Spec380_10_730-D50_2deg.xml Spec380_10_730-D50_2deg.icc
iccFromXml  Spec380_10_730-D65_2deg-MAT.xml Spec380_10_730-D65_2deg-MAT.icc
iccFromXml  Spec380_1_780-D50_2deg.xml Spec380_1_780-D50_2deg.icc
iccFromXml  Spec380_5_780-D50_2deg.xml Spec380_5_780-D50_2deg.icc
iccFromXml  Spec400_10_700-B_2deg-Abs.xml Spec400_10_700-B_2deg-Abs.icc
iccFromXml  Spec400_10_700-B_2deg-CAM.xml Spec400_10_700-B_2deg-CAM.icc
iccFromXml  Spec400_10_700-B_2deg-CAT02.xml Spec400_10_700-B_2deg-CAT02.icc
iccFromXml  Spec400_10_700-B_2deg-MAT.xml Spec400_10_700-B_2deg-MAT.icc
iccFromXml  Spec400_10_700-D50_10deg-Abs.xml Spec400_10_700-D50_10deg-Abs.icc
iccFromXml  Spec400_10_700-D50_10deg-MAT.xml Spec400_10_700-D50_10deg-MAT.icc
iccFromXml  Spec400_10_700-D50_20yo2deg-MAT.xml Spec400_10_700-D50_20yo2deg-MAT.icc
iccFromXml  Spec400_10_700-D50_2deg-Abs.xml Spec400_10_700-D50_2deg-Abs.icc
iccFromXml  Spec400_10_700-D50_2deg.xml Spec400_10_700-D50_2deg.icc
iccFromXml  Spec400_10_700-D50_40yo2deg-MAT.xml Spec400_10_700-D50_40yo2deg-MAT.icc
iccFromXml  Spec400_10_700-D50_60yo2deg-MAT.xml Spec400_10_700-D50_60yo2deg-MAT.icc
iccFromXml  Spec400_10_700-D50_80yo2deg-MAT.xml Spec400_10_700-D50_80yo2deg-MAT.icc
iccFromXml  Spec400_10_700-D65_10deg-Abs.xml Spec400_10_700-D65_10deg-Abs.icc
iccFromXml  Spec400_10_700-D65_10deg-MAT.xml Spec400_10_700-D65_10deg-MAT.icc
iccFromXml  Spec400_10_700-D65_20yo2deg-MAT.xml Spec400_10_700-D65_20yo2deg-MAT.icc
iccFromXml  Spec400_10_700-D65_2deg-Abs.xml Spec400_10_700-D65_2deg-Abs.icc
iccFromXml  Spec400_10_700-D65_2deg-MAT.xml Spec400_10_700-D65_2deg-MAT.icc
iccFromXml  Spec400_10_700-D65_40yo2deg-MAT.xml Spec400_10_700-D65_40yo2deg-MAT.icc
iccFromXml  Spec400_10_700-D65_60yo2deg-MAT.xml Spec400_10_700-D65_60yo2deg-MAT.icc
iccFromXml  Spec400_10_700-D65_80yo2deg-MAT.xml Spec400_10_700-D65_80yo2deg-MAT.icc
iccFromXml  Spec400_10_700-D93_10deg-Abs.xml Spec400_10_700-D93_10deg-Abs.icc
iccFromXml  Spec400_10_700-D93_10deg-MAT.xml Spec400_10_700-D93_10deg-MAT.icc
iccFromXml  Spec400_10_700-D93_2deg-Abs.xml Spec400_10_700-D93_2deg-Abs.icc
iccFromXml  Spec400_10_700-D93_2deg-MAT.xml Spec400_10_700-D93_2deg-MAT.icc
iccFromXml  Spec400_10_700-DB_2deg-Abs.xml Spec400_10_700-DB_2deg-Abs.icc
iccFromXml  Spec400_10_700-DB_2deg-CAT02.xml Spec400_10_700-DB_2deg-CAT02.icc
iccFromXml  Spec400_10_700-DB_2deg-MAT.xml Spec400_10_700-DB_2deg-MAT.icc
iccFromXml  Spec400_10_700-DG_2deg-Abs.xml Spec400_10_700-DG_2deg-Abs.icc
iccFromXml  Spec400_10_700-DG_2deg-CAT02.xml Spec400_10_700-DG_2deg-CAT02.icc
iccFromXml  Spec400_10_700-DG_2deg-MAT.xml Spec400_10_700-DG_2deg-MAT.icc
iccFromXml  Spec400_10_700-DR_2deg-Abs.xml Spec400_10_700-DR_2deg-Abs.icc
iccFromXml  Spec400_10_700-DR_2deg-CAT02.xml Spec400_10_700-DR_2deg-CAT02.icc
iccFromXml  Spec400_10_700-DR_2deg-MAT.xml Spec400_10_700-DR_2deg-MAT.icc
iccFromXml  Spec400_10_700-F11_2deg-CAT.xml Spec400_10_700-F11_2deg-CAT.icc
iccFromXml  Spec400_10_700-F11_2deg-MAT.xml Spec400_10_700-F11_2deg-MAT.icc
iccFromXml  Spec400_10_700-G_2deg-Abs.xml Spec400_10_700-G_2deg-Abs.icc
iccFromXml  Spec400_10_700-G_2deg-CAT02.xml Spec400_10_700-G_2deg-CAT02.icc
iccFromXml  Spec400_10_700-G_2deg-MAT.xml Spec400_10_700-G_2deg-MAT.icc
iccFromXml  Spec400_10_700-IllumA_10deg-Abs.xml Spec400_10_700-IllumA_10deg-Abs.icc
iccFromXml  Spec400_10_700-IllumA_10deg-MAT.xml Spec400_10_700-IllumA_10deg-MAT.icc
iccFromXml  Spec400_10_700-IllumA_2deg-Abs.xml Spec400_10_700-IllumA_2deg-Abs.icc
iccFromXml  Spec400_10_700-IllumA_2deg-CAT.xml Spec400_10_700-IllumA_2deg-CAT.icc
iccFromXml  Spec400_10_700-IllumA_2deg-MAT.xml Spec400_10_700-IllumA_2deg-MAT.icc
iccFromXml  Spec400_10_700-N_2deg-Abs.xml Spec400_10_700-N_2deg-Abs.icc
iccFromXml  Spec400_10_700-N_2deg-CAT02.xml Spec400_10_700-N_2deg-CAT02.icc
iccFromXml  Spec400_10_700-N_2deg-MAT.xml Spec400_10_700-N_2deg-MAT.icc
iccFromXml  Spec400_10_700-R1_2deg-Abs.xml Spec400_10_700-R1_2deg-Abs.icc
iccFromXml  Spec400_10_700-R1_2deg-CAT02.xml Spec400_10_700-R1_2deg-CAT02.icc
iccFromXml  Spec400_10_700-R1_2deg-MAT.xml Spec400_10_700-R1_2deg-MAT.icc
iccFromXml  Spec400_10_700-R2_2deg-Abs.xml Spec400_10_700-R2_2deg-Abs.icc
iccFromXml  Spec400_10_700-R2_2deg-CAT02.xml Spec400_10_700-R2_2deg-CAT02.icc
iccFromXml  Spec400_10_700-R2_2deg-MAT.xml Spec400_10_700-R2_2deg-MAT.icc
iccFromXml  Spec400_10_700-Y_2deg-Abs.xml Spec400_10_700-Y_2deg-Abs.icc
iccFromXml  Spec400_10_700-Y_2deg-CAT02.xml Spec400_10_700-Y_2deg-CAT02.icc
iccFromXml  Spec400_10_700-Y_2deg-MAT.xml Spec400_10_700-Y_2deg-MAT.icc
iccFromXml  XYZ_float-D50_2deg.xml XYZ_float-D50_2deg.icc
iccFromXml  XYZ_float-D65_2deg-MAT.xml XYZ_float-D65_2deg-MAT.icc
iccFromXml  XYZ_int-D50_2deg.xml XYZ_int-D50_2deg.icc
iccFromXml  XYZ_int-D65_2deg-MAT-Lvl2.xml XYZ_int-D65_2deg-MAT-Lvl2.icc
iccFromXml  XYZ_int-D65_2deg-MAT.xml XYZ_int-D65_2deg-MAT.icc

cd ../SpecRef
iccFromXml argbRef.xml argbRef.icc
iccFromXml SixChanCameraRef.xml SixChanCameraRef.icc
iccFromXml SixChanInputRef.xml SixChanInputRef.icc
iccFromXml srgbRef.xml srgbRef.icc
iccFromXml RefDecC.xml RefDecC.icc
iccFromXml RefDecH.xml RefDecH.icc
iccFromXml RefIncW.xml RefIncW.icc

cd ..
