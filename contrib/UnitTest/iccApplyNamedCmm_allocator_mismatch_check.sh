#!/bin/sh
#################################################################################
# iccApplyNamedCmm_checks.sh | iccMAX Project
# Copyright (C) 2024-2025 The International Color Consortium. 
#                                        All rights reserved.
# 
#
#  Last Updated: Mon Mar 24 16:40:19 EDT 2025 by David Hoyt
#  date -d @1742848819
#  Mon Mar 24 16:40:19 EDT 2025
#
#
#
#
# RUN from Testing/
#
# STUB for Post-Build CI-CD Checks
#
#
#################################################################################

echo "==========================================================================="
echo "Test CalcElement Operations return of zero's indicates that something bad happened"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Calc/srgbCalcTest.txt 2 0 Calc/srgbCalcTest.icc 3 sRGB_v4_ICC_preference.icc 3

echo "==========================================================================="
echo "Test NamedColor"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 sRGB_v4_ICC_preference.icc 1

echo "==========================================================================="
echo "Test NamedColor with D93 2degree"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D93 10degree"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_10deg-MAT.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D65 2degree"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D65 10degree"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D65_10deg-MAT.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D50 2degree"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D50 10degree"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D50_10deg-MAT.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with Illuminant A 2degree"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-IllumA_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with Illuminant A 10degree"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-IllumA_10deg-MAT.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test Grayscale GSDF Display link profile with ambient luminance of 20cd/m^2"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Display/GrayTest.txt 3 0 -ENV:ambL 20 Display/GrayGSDF.icc 0

echo "==========================================================================="
echo "Test RGB GSDF Display link profile with ambient luminant of 30cd/m^2"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Display/RgbTest.txt 3 0 -ENV:ambL 30 Display/RgbGSDF.icc 0

echo "==========================================================================="
echo "Test Fluorescent Color under D93"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/FluorescentNamedColorTest.txt 2 0 Named/FluorescentNamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc SpecRef/SixChanCameraRef.icc 1

echo "========================================="
echo "Test Fluorescent Color under D65"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/FluorescentNamedColorTest.txt 2 0 Named/FluorescentNamedColor.icc 3 -pcc PCC/Spec400_10_700-D65_2deg-Abs.icc SpecRef/SixChanCameraRef.icc 1

echo "==========================================================================="
echo "Test Fluorescent under D50"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/FluorescentNamedColorTest.txt 2 0 Named/FluorescentNamedColor.icc 3 -pcc PCC/Spec400_10_700-D50_10deg.icc SpecRef/SixChanCameraRef.icc 1

echo "==========================================================================="
echo "Test Fluorescent under Illuminant A"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm Named/FluorescentNamedColorTest.txt 2 0 Named/FluorescentNamedColor.icc 3 -pcc PCC/Spec400_10_700-IllumA_2deg-Abs.icc SpecRef/SixChanCameraRef.icc 1

echo "==========================================================================="
echo "Test Six Channel Reflectance Camera"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm SpecRef/sixChanTest.txt 2 0 SpecRef/SixChanCameraRef.icc 3 PCC/Spec400_10_700-D50_2deg-Abs.icc 3

echo "==========================================================================="
echo "Test Six Channel Reflectance Camera to Lab"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm SpecRef/sixChanTest.txt 3 0 SpecRef/SixChanCameraRef.icc 3 PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test Six Channel Reflectance Camera reflectance under D93 to Lab"
../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm SpecRef/sixChanTest.txt 3 0 SpecRef/SixChanCameraRef.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3
