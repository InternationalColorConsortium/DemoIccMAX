#!/bin/sh
## Copyright (c) 2024 The International Color Consortium. All rights reserved.
## Unit Test of CreateAllProfiles.sh
##
## Written by David Hoyt for ICC color.org & DemoIccMAX Project
## Date: 27-Sept-24
##

echo "International Color Consortium | DemoIccMAX Project | Copyright 2024. For more information on The International Color Consortium, please see http://color.org/."
echo "Running remote script of Testing/CreateAllProfiles.sh Script now running.."

if [ "$1" = "clean" ]
then
	echo CLEANING!
elif [ "$#" -ge 1 ]
then
	echo "Unknown command line options"
	exit 1
elif ! command -v ../Build/Tools/IccFromXml/iccFromXml   # print which executable is being used
then
	exit 1
fi

echo "cd Calc.."
cd Calc
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	../../Build/Tools/IccFromXml/iccFromXml CameraModel.xml CameraModel.icc
	../../Build/Tools/IccFromXml/iccFromXml ElevenChanKubelkaMunk.xml ElevenChanKubelkaMunk.icc
	../../Build/Tools/IccFromXml/iccFromXml RGBWProjector.xml RGBWProjector.icc
	../../Build/Tools/IccFromXml/iccFromXml argbCalc.xml argbCalc.icc
	../../Build/Tools/IccFromXml/iccFromXml srgbCalcTest.xml srgbCalcTest.icc
	../../Build/Tools/IccFromXml/iccFromXml srgbCalc++Test.xml srgbCalc++Test.icc
	# calcImport.xml is not a standalone XML file
	# calcVars.xml is not a standalone XML file
	set -
fi

echo "cd CalcTest.."
cd ../CalcTest
if [ "$1" != "clean" ]
then
	set -x
	# cannot delete *.icc as many are non-XML test files
	../../Build/Tools/IccFromXml/iccFromXml calcCheckInit.xml   calcCheckInit.icc
	../../Build/Tools/IccFromXml/iccFromXml calcExercizeOps.xml calcExercizeOps.icc
	set -
fi

echo "cd CMYK-3DLUTs.."
cd ../CMYK-3DLUTs
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	../../Build/Tools/IccFromXml/iccFromXml CMYK-3DLUTs.xml  CMYK-3DLUTs.icc
	../../Build/Tools/IccFromXml/iccFromXml CMYK-3DLUTs2.xml CMYK-3DLUTs2.icc
	set -
fi

echo "cd Display.."
cd ../Display
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	../../Build/Tools/IccFromXml/iccFromXml GrayGSDF.xml GrayGSDF.icc
	../../Build/Tools/IccFromXml/iccFromXml LCDDisplay.xml LCDDisplay.icc
	../../Build/Tools/IccFromXml/iccFromXml LaserProjector.xml LaserProjector.icc
	../../Build/Tools/IccFromXml/iccFromXml Rec2020rgbColorimetric.xml Rec2020rgbColorimetric.icc
	../../Build/Tools/IccFromXml/iccFromXml Rec2020rgbSpectral.xml Rec2020rgbSpectral.icc
	../../Build/Tools/IccFromXml/iccFromXml Rec2100HlgFull.xml Rec2100HlgFull.icc
	../../Build/Tools/IccFromXml/iccFromXml Rec2100HlgNarrow.xml Rec2100HlgNarrow.icc
	../../Build/Tools/IccFromXml/iccFromXml RgbGSDF.xml RgbGSDF.icc
	../../Build/Tools/IccFromXml/iccFromXml sRGB_D65_MAT-300lx.xml sRGB_D65_MAT-300lx.icc
	../../Build/Tools/IccFromXml/iccFromXml sRGB_D65_MAT-500lx.xml sRGB_D65_MAT-500lx.icc
	../../Build/Tools/IccFromXml/iccFromXml sRGB_D65_MAT.xml       sRGB_D65_MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml sRGB_D65_colorimetric.xml sRGB_D65_colorimetric.icc
	../../Build/Tools/IccFromXml/iccFromXml Rec2100HlgFullCC.xml Rec2100HlgFullCC.icc
	../../Build/Tools/IccFromXml/iccFromXml Rec2100HlgFullNC.xml Rec2100HlgFullNC.icc
	set -
fi

echo "cd Encoding.."
cd ../Encoding
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	../../Build/Tools/IccFromXml/iccFromXml ISO22028-Encoded-sRGB.xml ISO22028-Encoded-sRGB.icc
	../../Build/Tools/IccFromXml/iccFromXml ISO22028-Encoded-bg-sRGB.xml ISO22028-Encoded-bg-sRGB.icc
	../../Build/Tools/IccFromXml/iccFromXml sRgbEncoding.xml sRgbEncoding.icc
	../../Build/Tools/IccFromXml/iccFromXml sRgbEncodingOverrides.xml sRgbEncodingOverrides.icc
	set -
fi

echo "cd ICS.."
cd ../ICS
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	../../Build/Tools/IccFromXml/iccFromXml Lab_float-D65_2deg-Part1.xml    Lab_float-D65_2deg-Part1.icc
	../../Build/Tools/IccFromXml/iccFromXml Lab_float-IllumA_2deg-Part2.xml Lab_float-IllumA_2deg-Part2.icc
	../../Build/Tools/IccFromXml/iccFromXml Lab_int-D65_2deg-Part1.xml      Lab_int-D65_2deg-Part1.icc
	../../Build/Tools/IccFromXml/iccFromXml Lab_int-IllumA_2deg-Part2.xml   Lab_int-IllumA_2deg-Part2.icc
	../../Build/Tools/IccFromXml/iccFromXml Rec2100HlgFull-Part1.xml Rec2100HlgFull-Part1.icc
	../../Build/Tools/IccFromXml/iccFromXml Rec2100HlgFull-Part2.xml Rec2100HlgFull-Part2.icc
	../../Build/Tools/IccFromXml/iccFromXml Rec2100HlgFull-Part3.xml Rec2100HlgFull-Part3.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_2deg-Part1.xml Spec400_10_700-D50_2deg-Part1.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D93_2deg-Part2.xml Spec400_10_700-D93_2deg-Part2.icc
	../../Build/Tools/IccFromXml/iccFromXml XYZ_float-D65_2deg-Part1.xml    XYZ_float-D65_2deg-Part1.icc
	../../Build/Tools/IccFromXml/iccFromXml XYZ_float-IllumA_2deg-Part2.xml XYZ_float-IllumA_2deg-Part2.icc
	../../Build/Tools/IccFromXml/iccFromXml XYZ_int-D65_2deg-Part1.xml      XYZ_int-D65_2deg-Part1.icc
	../../Build/Tools/IccFromXml/iccFromXml XYZ_int-IllumA_2deg-Part2.xml   XYZ_int-IllumA_2deg-Part2.icc
	set -
fi

echo "cd Named.."
cd ../Named
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	../../Build/Tools/IccFromXml/iccFromXml FluorescentNamedColor.xml FluorescentNamedColor.icc
	../../Build/Tools/IccFromXml/iccFromXml NamedColor.xml NamedColor.icc
	../../Build/Tools/IccFromXml/iccFromXml SparseMatrixNamedColor.xml SparseMatrixNamedColor.icc
	set -
fi

echo "cd Overprint.."
cd ../Overprint
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	../../Build/Tools/IccFromXml/iccFromXml 17ChanPart1.xml 17ChanPart1.icc
	set -
fi

echo "cd mcs.."
cd ../mcs
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	../../Build/Tools/IccFromXml/iccFromXml 17ChanWithSpots-MVIS.xml 17ChanWithSpots-MVIS.icc
	../../Build/Tools/IccFromXml/iccFromXml 18ChanWithSpots-MVIS.xml 18ChanWithSpots-MVIS.icc
	../../Build/Tools/IccFromXml/iccFromXml 6ChanSelect-MID.xml 6ChanSelect-MID.icc
	set -
fi

echo "cd Flexo-CMYKOGP.."
cd Flexo-CMYKOGP
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	../../../Build/Tools/IccFromXml/iccFromXml 4ChanSelect-MID.xml 4ChanSelect-MID.icc
	../../../Build/Tools/IccFromXml/iccFromXml 7ChanSelect-MID.xml 7ChanSelect-MID.icc
	../../../Build/Tools/IccFromXml/iccFromXml CGYK-SelectMID.xml  CGYK-SelectMID.icc
	../../../Build/Tools/IccFromXml/iccFromXml CMPK-SelectMID.xml  CMPK-SelectMID.icc
	../../../Build/Tools/IccFromXml/iccFromXml CMYK-SelectMID.xml  CMYK-SelectMID.icc
	../../../Build/Tools/IccFromXml/iccFromXml CMYKOGP-MVIS-Smooth.xml CMYKOGP-MVIS-Smooth.icc
	../../../Build/Tools/IccFromXml/iccFromXml OMYK-SelectMID.xml  OMYK-SelectMID.icc
	set -
fi
cd ..

echo "cd PCC.."
cd ../PCC
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	../../Build/Tools/IccFromXml/iccFromXml Lab_float-D50_2deg.xml Lab_float-D50_2deg.icc
	../../Build/Tools/IccFromXml/iccFromXml Lab_float-D93_2deg-MAT.xml Lab_float-D93_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Lab_int-D50_2deg.xml Lab_int-D50_2deg.icc
	../../Build/Tools/IccFromXml/iccFromXml Lab_int-D65_2deg-MAT.xml Lab_int-D65_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Lab_int-IllumA_2deg-MAT.xml Lab_int-IllumA_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec380_10_730-D50_2deg.xml Spec380_10_730-D50_2deg.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec380_10_730-D65_2deg-MAT.xml Spec380_10_730-D65_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec380_1_780-D50_2deg.xml Spec380_1_780-D50_2deg.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec380_5_780-D50_2deg.xml Spec380_5_780-D50_2deg.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-B_2deg-Abs.xml Spec400_10_700-B_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-B_2deg-CAM.xml Spec400_10_700-B_2deg-CAM.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-B_2deg-CAT02.xml Spec400_10_700-B_2deg-CAT02.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-B_2deg-MAT.xml Spec400_10_700-B_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_10deg-Abs.xml Spec400_10_700-D50_10deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_10deg-MAT.xml Spec400_10_700-D50_10deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_20yo2deg-MAT.xml Spec400_10_700-D50_20yo2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_2deg-Abs.xml Spec400_10_700-D50_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_2deg.xml Spec400_10_700-D50_2deg.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_40yo2deg-MAT.xml Spec400_10_700-D50_40yo2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_60yo2deg-MAT.xml Spec400_10_700-D50_60yo2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D50_80yo2deg-MAT.xml Spec400_10_700-D50_80yo2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_10deg-Abs.xml Spec400_10_700-D65_10deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_10deg-MAT.xml Spec400_10_700-D65_10deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_20yo2deg-MAT.xml Spec400_10_700-D65_20yo2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_2deg-Abs.xml Spec400_10_700-D65_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_2deg-MAT.xml Spec400_10_700-D65_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_40yo2deg-MAT.xml Spec400_10_700-D65_40yo2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_60yo2deg-MAT.xml Spec400_10_700-D65_60yo2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D65_80yo2deg-MAT.xml Spec400_10_700-D65_80yo2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D93_10deg-Abs.xml Spec400_10_700-D93_10deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D93_10deg-MAT.xml Spec400_10_700-D93_10deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D93_2deg-Abs.xml Spec400_10_700-D93_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-D93_2deg-MAT.xml Spec400_10_700-D93_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DB_2deg-Abs.xml Spec400_10_700-DB_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DB_2deg-CAT02.xml Spec400_10_700-DB_2deg-CAT02.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DB_2deg-MAT.xml Spec400_10_700-DB_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DG_2deg-Abs.xml Spec400_10_700-DG_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DG_2deg-CAT02.xml Spec400_10_700-DG_2deg-CAT02.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DG_2deg-MAT.xml Spec400_10_700-DG_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DR_2deg-Abs.xml Spec400_10_700-DR_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DR_2deg-CAT02.xml Spec400_10_700-DR_2deg-CAT02.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-DR_2deg-MAT.xml Spec400_10_700-DR_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-F11_2deg-CAT.xml Spec400_10_700-F11_2deg-CAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-F11_2deg-MAT.xml Spec400_10_700-F11_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-G_2deg-Abs.xml Spec400_10_700-G_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-G_2deg-CAT02.xml Spec400_10_700-G_2deg-CAT02.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-G_2deg-MAT.xml Spec400_10_700-G_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-IllumA_10deg-Abs.xml Spec400_10_700-IllumA_10deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-IllumA_10deg-MAT.xml Spec400_10_700-IllumA_10deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-IllumA_2deg-Abs.xml Spec400_10_700-IllumA_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-IllumA_2deg-CAT.xml Spec400_10_700-IllumA_2deg-CAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-IllumA_2deg-MAT.xml Spec400_10_700-IllumA_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-N_2deg-Abs.xml Spec400_10_700-N_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-N_2deg-CAT02.xml Spec400_10_700-N_2deg-CAT02.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-N_2deg-MAT.xml Spec400_10_700-N_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-R1_2deg-Abs.xml Spec400_10_700-R1_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-R1_2deg-CAT02.xml Spec400_10_700-R1_2deg-CAT02.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-R1_2deg-MAT.xml Spec400_10_700-R1_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-R2_2deg-Abs.xml Spec400_10_700-R2_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-R2_2deg-CAT02.xml Spec400_10_700-R2_2deg-CAT02.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-R2_2deg-MAT.xml Spec400_10_700-R2_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-Y_2deg-Abs.xml Spec400_10_700-Y_2deg-Abs.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-Y_2deg-CAT02.xml Spec400_10_700-Y_2deg-CAT02.icc
	../../Build/Tools/IccFromXml/iccFromXml Spec400_10_700-Y_2deg-MAT.xml Spec400_10_700-Y_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml XYZ_float-D50_2deg.xml XYZ_float-D50_2deg.icc
	../../Build/Tools/IccFromXml/iccFromXml XYZ_float-D65_2deg-MAT.xml XYZ_float-D65_2deg-MAT.icc
	../../Build/Tools/IccFromXml/iccFromXml XYZ_int-D50_2deg.xml XYZ_int-D50_2deg.icc
	../../Build/Tools/IccFromXml/iccFromXml XYZ_int-D65_2deg-MAT-Lvl2.xml XYZ_int-D65_2deg-MAT-Lvl2.icc
	../../Build/Tools/IccFromXml/iccFromXml XYZ_int-D65_2deg-MAT.xml XYZ_int-D65_2deg-MAT.icc
	set -
fi

echo "cd SpecRef.."
cd ../SpecRef
find . -iname "*\.icc" -delete
if [ "$1" != "clean" ]
then
	set -x
	../../Build/Tools/IccFromXml/iccFromXml argbRef.xml argbRef.icc
	../../Build/Tools/IccFromXml/iccFromXml SixChanCameraRef.xml SixChanCameraRef.icc
	../../Build/Tools/IccFromXml/iccFromXml SixChanInputRef.xml  SixChanInputRef.icc
	../../Build/Tools/IccFromXml/iccFromXml srgbRef.xml srgbRef.icc
	../../Build/Tools/IccFromXml/iccFromXml RefDecC.xml RefDecC.icc
	../../Build/Tools/IccFromXml/iccFromXml RefDecH.xml RefDecH.icc
	../../Build/Tools/IccFromXml/iccFromXml RefIncW.xml RefIncW.icc
	# RefEstimationImport.xml is not a standalone XML file
	set -
fi
cd ..

# Count number of ICCs that exist to confirm
echo "Expecting 204 .icc color profiles..."

if [ "$1" != "clean" ]
then
	echo -n "ICC file count.. : "
	find . -iname "*.icc" | wc -l
else
	echo -n "ICC files after a clean: "
	find . -iname "*.icc" | wc -l
fi

echo "CreateAllProfiles Done!"
