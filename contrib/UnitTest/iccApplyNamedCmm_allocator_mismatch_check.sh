#!/bin/sh
##
##
## Unit Test of IccProfLib/IccMpeCalc.cpp:4563:37: runtime error: downcast of address .. which does not point to an object of type 'CIccMpeCalculator'
## Debug Asan Checks for Allocator-Mismatch-Error seen in iccApplyNamedCmm
##
## David Hoyt for DemoIccMAX Project
## Date: 25-FEB-25 2045 by David Hoyt
##
## To be run from Testing/ 
##    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/iccApplyNamedCmm_allocator_mismatch_check.sh)"
##
## Assumes "../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm" is somewhere on $PATH
##
##

if ! command -v ../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm   # print which executable is being used
then
	exit 1
fi

echo "==========================================================================="
echo "Test CalcElement Operations return of zero's indicates that something bad happened"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Calc/srgbCalcTest.txt 2 0 Calc/srgbCalcTest.icc 3 sRGB_v4_ICC_preference.icc 3

echo "==========================================================================="
echo "Test NamedColor"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 sRGB_v4_ICC_preference.icc 1

echo "==========================================================================="
echo "Test NamedColor with D93 2degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D93 10degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_10deg-MAT.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D65 2degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D65 10degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D65_10deg-MAT.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D50 2degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with D50 10degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-D50_10deg-MAT.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with Illuminant A 2degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-IllumA_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test NamedColor with Illuminant A 10degree"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/NamedColorTest.txt 2 0 Named/NamedColor.icc 3 -pcc PCC/Spec400_10_700-IllumA_10deg-MAT.icc PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test Grayscale GSDF Display link profile with ambient luminance of 20cd/m^2"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Display/GrayTest.txt 3 0 -ENV:ambL 20 Display/GrayGSDF.icc 0

echo "==========================================================================="
echo "Test RGB GSDF Display link profile with ambient luminant of 30cd/m^2"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Display/RgbTest.txt 3 0 -ENV:ambL 30 Display/RgbGSDF.icc 0

echo "==========================================================================="
echo "Test Fluorescent Color under D93"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/FluorescentNamedColorTest.txt 2 0 Named/FluorescentNamedColor.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc SpecRef/SixChanCameraRef.icc 1

echo "========================================="
echo "Test Fluorescent Color under D65"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/FluorescentNamedColorTest.txt 2 0 Named/FluorescentNamedColor.icc 3 -pcc PCC/Spec400_10_700-D65_2deg-Abs.icc SpecRef/SixChanCameraRef.icc 1

echo "==========================================================================="
echo "Test Fluorescent under D50"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/FluorescentNamedColorTest.txt 2 0 Named/FluorescentNamedColor.icc 3 -pcc PCC/Spec400_10_700-D50_10deg.icc SpecRef/SixChanCameraRef.icc 1

echo "==========================================================================="
echo "Test Fluorescent under Illuminant A"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm Named/FluorescentNamedColorTest.txt 2 0 Named/FluorescentNamedColor.icc 3 -pcc PCC/Spec400_10_700-IllumA_2deg-Abs.icc SpecRef/SixChanCameraRef.icc 1

echo "==========================================================================="
echo "Test Six Channel Reflectance Camera"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm SpecRef/sixChanTest.txt 2 0 SpecRef/SixChanCameraRef.icc 3 PCC/Spec400_10_700-D50_2deg-Abs.icc 3

echo "==========================================================================="
echo "Test Six Channel Reflectance Camera to Lab"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm SpecRef/sixChanTest.txt 3 0 SpecRef/SixChanCameraRef.icc 3 PCC/Lab_float-D50_2deg.icc 3

echo "==========================================================================="
echo "Test Six Channel Reflectance Camera reflectance under D93 to Lab"
../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm SpecRef/sixChanTest.txt 3 0 SpecRef/SixChanCameraRef.icc 3 -pcc PCC/Spec400_10_700-D93_2deg-Abs.icc PCC/Lab_float-D50_2deg.icc 3
