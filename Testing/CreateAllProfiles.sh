#!/bin/sh
##
## Assumes "iccFromXml" is on $PATH
## Use "sudo make install" to install to default location of "/usr/local/bin"
##

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
iccFromXml ISO22028EncodedsRGB.xml ISO22028EncodedsRGB.icc
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
iccFromXml Lab-D50_2deg.xml Lab-D50_2deg.icc
iccFromXml Lab-D93_2deg.xml Lab-D93_2deg.icc
iccFromXml Spec400_10_700-B-Abs_2deg.xml Spec400_10_700-B-Abs_2deg.icc
iccFromXml Spec400_10_700-B-CAT02_2deg.xml Spec400_10_700-B-CAT02_2deg.icc
iccFromXml Spec400_10_700-B-MAT_2deg.xml Spec400_10_700-B-MAT_2deg.icc
iccFromXml Spec400_10_700-D50-Abs_2deg.xml Spec400_10_700-D50-Abs_2deg.icc
iccFromXml Spec400_10_700-D50_10deg.xml Spec400_10_700-D50_10deg.icc
iccFromXml Spec400_10_700-D50_2deg.xml Spec400_10_700-D50_2deg.icc
iccFromXml Spec400_10_700-D65-Abs_2deg.xml Spec400_10_700-D65-Abs_2deg.icc
iccFromXml Spec400_10_700-D65-MAT_10deg.xml Spec400_10_700-D65-MAT_10deg.icc
iccFromXml Spec400_10_700-D65-MAT_2deg.xml Spec400_10_700-D65-MAT_2deg.icc
iccFromXml Spec400_10_700-D93-Abs_2deg.xml Spec400_10_700-D93-Abs_2deg.icc
iccFromXml Spec400_10_700-D93-MAT_10deg.xml Spec400_10_700-D93-MAT_10deg.icc
iccFromXml Spec400_10_700-D93-MAT_2deg.xml Spec400_10_700-D93-MAT_2deg.icc
iccFromXml Spec400_10_700-DB-Abs_2deg.xml Spec400_10_700-DB-Abs_2deg.icc
iccFromXml Spec400_10_700-DB-CAT02_2deg.xml Spec400_10_700-DB-CAT02_2deg.icc
iccFromXml Spec400_10_700-DB-MAT_2deg.xml Spec400_10_700-DB-MAT_2deg.icc
iccFromXml Spec400_10_700-DG-Abs_2deg.xml Spec400_10_700-DG-Abs_2deg.icc
iccFromXml Spec400_10_700-DG-CAT02_2deg.xml Spec400_10_700-DG-CAT02_2deg.icc
iccFromXml Spec400_10_700-DG-MAT_2deg.xml Spec400_10_700-DG-MAT_2deg.icc
iccFromXml Spec400_10_700-DR-Abs_2deg.xml Spec400_10_700-DR-Abs_2deg.icc
iccFromXml Spec400_10_700-DR-CAT02_2deg.xml Spec400_10_700-DR-CAT02_2deg.icc
iccFromXml Spec400_10_700-DR-MAT_2deg.xml Spec400_10_700-DR-MAT_2deg.icc
iccFromXml Spec400_10_700-G-Abs_2deg.xml Spec400_10_700-G-Abs_2deg.icc
iccFromXml Spec400_10_700-G-CAT02_2deg.xml Spec400_10_700-G-CAT02_2deg.icc
iccFromXml Spec400_10_700-G-MAT_2deg.xml Spec400_10_700-G-MAT_2deg.icc
iccFromXml Spec400_10_700-IllumA-Abs_2deg.xml Spec400_10_700-IllumA-Abs_2deg.icc
iccFromXml Spec400_10_700-IllumA-MAT_10deg.xml Spec400_10_700-IllumA-MAT_10deg.icc
iccFromXml Spec400_10_700-IllumA-MAT_2deg.xml Spec400_10_700-IllumA-MAT_2deg.icc
iccFromXml Spec400_10_700-N-Abs_2deg.xml Spec400_10_700-N-Abs_2deg.icc
iccFromXml Spec400_10_700-N-CAT02_2deg.xml Spec400_10_700-N-CAT02_2deg.icc
iccFromXml Spec400_10_700-N-MAT_2deg.xml Spec400_10_700-N-MAT_2deg.icc
iccFromXml Spec400_10_700-R1-Abs_2deg.xml Spec400_10_700-R1-Abs_2deg.icc
iccFromXml Spec400_10_700-R1-CAT02_2deg.xml Spec400_10_700-R1-CAT02_2deg.icc
iccFromXml Spec400_10_700-R1-MAT_2deg.xml Spec400_10_700-R1-MAT_2deg.icc
iccFromXml Spec400_10_700-R2-Abs_2deg.xml Spec400_10_700-R2-Abs_2deg.icc
iccFromXml Spec400_10_700-R2-CAT02_2deg.xml Spec400_10_700-R2-CAT02_2deg.icc
iccFromXml Spec400_10_700-R2-MAT_2deg.xml Spec400_10_700-R2-MAT_2deg.icc
iccFromXml Spec400_10_700-Y-Abs_2deg.xml Spec400_10_700-Y-Abs_2deg.icc
iccFromXml Spec400_10_700-Y-CAT02_2deg.xml Spec400_10_700-Y-CAT02_2deg.icc
iccFromXml Spec400_10_700-Y-MAT_2deg.xml Spec400_10_700-Y-MAT_2deg.icc

cd ../SpecRef
iccFromXml argbRef.xml argbRef.icc
iccFromXml SixChanCameraRef.xml SixChanCameraRef.icc
iccFromXml SixChanInputRef.xml SixChanInputRef.icc
iccFromXml srgbRef.xml srgbRef.icc
iccFromXml RefDecC.xml RefDecC.icc
iccFromXml RefDecH.xml RefDecH.icc
iccFromXml RefIncW.xml RefIncW.icc

cd ..
