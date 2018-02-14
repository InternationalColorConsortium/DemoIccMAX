@echo off
echo ===========================================================================
echo Test CalcElement Operations return of zero's indicates that something bad happened
iccApplyNamedCMM Calc\srgbCalcTest.txt 2 0 Calc\srgbCalcTest.icc 3 sRGB_v4_ICC_preference.icc 3

echo ===========================================================================
echo Test Extended CalcElement Operations return of zero's indicates that something bad happened
iccApplyNamedCMM Calc\srgbCalcTest.txt 2 0 Calc\srgbCalc++Test.icc 3 sRGB_v4_ICC_preference.icc 3

echo ===========================================================================
echo Test NamedColor
iccApplyNamedCMM Named\NamedColorTest.txt 2 0 Named\NamedColor.icc 3 sRGB_v4_ICC_preference.icc 1

echo ===========================================================================
echo Test NamedColor with D93 2degree
iccApplyNamedCMM Named\NamedColorTest.txt 2 0 Named\NamedColor.icc 3 -pcc PCC\Spec400_10_700-D93-Abs_2deg.icc PCC\Lab-D50_2deg.icc 3

echo ===========================================================================
echo Test NamedColor with D93 10degree
iccApplyNamedCMM Named\NamedColorTest.txt 2 0 Named\NamedColor.icc 3 -pcc PCC\Spec400_10_700-D93-Abs_10deg.icc PCC\Lab-D50_2deg.icc 3

echo ===========================================================================
echo Test NamedColor with D65 2degree
iccApplyNamedCMM Named\NamedColorTest.txt 2 0 Named\NamedColor.icc 3 -pcc PCC\Spec400_10_700-D65-Abs_2deg.icc PCC\Lab-D50_2deg.icc 3

echo ===========================================================================
echo Test NamedColor with D65 10degree
iccApplyNamedCMM Named\NamedColorTest.txt 2 0 Named\NamedColor.icc 3 -pcc PCC\Spec400_10_700-D65-Abs_10deg.icc PCC\Lab-D50_2deg.icc 3

echo ===========================================================================
echo Test NamedColor with D50 2degree
iccApplyNamedCMM Named\NamedColorTest.txt 2 0 Named\NamedColor.icc 3 -pcc PCC\Spec400_10_700-D50-Abs_2deg.icc PCC\Lab-D50_2deg.icc 3

echo ===========================================================================
echo Test NamedColor with D50 10degree
iccApplyNamedCMM Named\NamedColorTest.txt 2 0 Named\NamedColor.icc 3 -pcc PCC\Spec400_10_700-D50-Abs_10deg.icc PCC\Lab-D50_2deg.icc 3

echo ===========================================================================
echo Test NamedColor with Illuminant A 2degree
iccApplyNamedCMM Named\NamedColorTest.txt 2 0 Named\NamedColor.icc 3 -pcc PCC\Spec400_10_700-IllumA-Abs_2deg.icc PCC\Lab-D50_2deg.icc 3

echo ===========================================================================
echo Test NamedColor with Illuminant A 10degree
iccApplyNamedCMM Named\NamedColorTest.txt 2 0 Named\NamedColor.icc 3 -pcc PCC\Spec400_10_700-IllumA-Abs_10deg.icc PCC\Lab-D50_2deg.icc 3

echo ===========================================================================
echo Test Grayscale GSDF Display link profile with ambient luminance of 20cd/m^2
iccApplyNamedCMM Display\GrayTest.txt 3 0 -ENV:ambL 20 Display\GrayGSDF.icc 0

echo ===========================================================================
echo Test RGB GSDF Display link profile with ambient luminant of 30cd/m^2
iccApplyNamedCMM Display\RgbTest.txt 3 0 -ENV:ambL 30 Display\RgbGSDF.icc 0

echo ===========================================================================
echo Test Fluorescent Color under D93
iccApplyNamedCMM Named\FluorescentNamedColorTest.txt 2 0 Named\FluorescentNamedColor.icc 3 -pcc PCC\Spec400_10_700-D93-Abs_2deg.icc SpecRef\SixChanCameraRef.icc 1

echo =========================================
echo Test Fluorescent Color under D65
iccApplyNamedCMM Named\FluorescentNamedColorTest.txt 2 0 Named\FluorescentNamedColor.icc 3 -pcc PCC\Spec400_10_700-D65-Abs_2deg.icc SpecRef\SixChanCameraRef.icc 1

echo ===========================================================================
echo Test Fluorescent under D50
iccApplyNamedCMM Named\FluorescentNamedColorTest.txt 2 0 Named\FluorescentNamedColor.icc 3 -pcc PCC\Spec400_10_700-D50-Abs_10deg.icc SpecRef\SixChanCameraRef.icc 1

echo ===========================================================================
echo Test Fluorescent under Illuminant A
iccApplyNamedCMM Named\FluorescentNamedColorTest.txt 2 0 Named\FluorescentNamedColor.icc 3 -pcc PCC\Spec400_10_700-IllumA-Abs_2deg.icc SpecRef\SixChanCameraRef.icc 1

echo ===========================================================================
echo Test Six Channel Reflectance Camera
iccApplyNamedCMM SpecRef\sixChanTest.txt 2 0 SpecRef\SixChanCameraRef.icc 3 PCC\Spec400_10_700-D50-Abs_2deg.icc 3

echo ===========================================================================
echo Test Six Channel Reflectance Camera to Lab
iccApplyNamedCMM SpecRef\sixChanTest.txt 3 0 SpecRef\SixChanCameraRef.icc 3 PCC\Lab-D50_2deg.icc 3

echo ===========================================================================
echo Test Six Channel Reflectance Camera reflectance under D93 to Lab
iccApplyNamedCMM SpecRef\sixChanTest.txt 3 0 SpecRef\SixChanCameraRef.icc 3 -pcc PCC\Spec400_10_700-D93-Abs_2deg.icc PCC\Lab-D50_2deg.icc 3

echo ===========================================================================
echo Test 380_5_780 Reflectance under D50 to XYZ
iccApplyNamedCmm.exe ApplyDataFiles\cc_ref-380_5_780.txt 1 0 pcc\Spec380_5_780-D50_2deg.icc 3 pcc\XYZ-D50_2deg.icc 3

echo ===========================================================================
echo Test 380_10_730 Reflectance under D50 to XYZ
iccApplyNamedCmm.exe ApplyDataFiles\cc_ref-380_10_730.txt 1 0 pcc\Spec380_10_730-D50_2deg.icc 3 pcc\XYZ-D50_2deg.icc 3
