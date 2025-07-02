@ECHO First lets build some ICC profiles

..\iccFromXml.exe MultSpectralRGB.xml Profiles\MultSpectralRGB.icc
..\iccFromXml.exe LCDDisplay.xml Profiles\LCDDisplay.icc
..\iccFromXml.exe UCD_candidate_v4v5.xml Profiles\UCD_candidate_v4v5.icc

..\iccFromXml.exe Data\Lab_float-D50_2deg.xml Profiles\Lab_float-D50_2deg.icc
..\iccFromXml.exe Data\Lab_float-D93_2deg-MAT.xml Profiles\Lab_float-D93_2deg-MAT.icc
..\iccFromXml.exe Data\Lab_float-F11_2deg-MAT.xml Profiles\Lab_float-F11_2deg-MAT.icc
..\iccFromXml.exe Data\Lab_float-illumA_2deg-MAT.xml Profiles\Lab_float-illumA_2deg-MAT.icc

..\iccFromXml.exe Data\Spec400_10_700-D50_2deg.xml Profiles\Spec400_10_700-D50_2deg.icc
..\iccFromXml.exe Data\Spec400_10_700-illumA_2deg-Abs.xml Profiles\Spec400_10_700-illumA_2deg-Abs.icc
..\iccFromXml.exe Data\Spec380_10_730-D50_2deg.xml Profiles\Spec380_10_730-D50_2deg.icc

@ECHO ************************************************
@ECHO Make a multi-spectral image from a spectral one
@ECHO ************************************************

..\iccTiffDump.exe Data\smCows380_5_780.tif

..\iccApplyProfiles.exe Data\smCows380_5_780.tif Results\MS_smCows.tif 2 1 0 1 1 -embedded 3 Profiles\MultSpectralRGB.icc 10003

..\iccTiffDump.exe Results\MS_smCows.tif

@ECHO *****************************************************************
@ECHO Apply PCC's to the spectral images to get colorimetric renderings
@ECHO *****************************************************************

..\iccApplyProfiles.exe Data\smCows380_5_780.tif Results\cowsA_fromRef.tif 1 1 0 1 1 -embedded 3 -pcc Profiles\Spec400_10_700-illumA_2deg-Abs.icc ..\sRGB_v4_ICC_preference.icc 1
..\iccApplyProfiles.exe Results\MS_smCows.tif Results\cowsA_fromMS.tif 1 1 0 1 1 -embedded 10003 -pcc Profiles\Spec400_10_700-illumA_2deg-Abs.icc ..\sRGB_v4_ICC_preference.icc 1

@ECHO *****************************************************************
@ECHO Do some spectral color management from an extended print profiles
@ECHO *****************************************************************

..\iccApplyNamedCmm.exe Data\cmykGrays.txt 3 1 Profiles\UCD_candidate_v4v5.icc 10003 Profiles\Spec380_10_730-D50_2deg.icc 3 > Results\cmykGraysRef.txt

@type Results\cmykGraysRef.txt

..\iccApplySearch.exe Results\cmykGraysRef.txt 0 1 Profiles\Spec380_10_730-d50_2deg.icc 3 Profiles\Lab_float-D50_2deg.icc 3 Profiles\UCD_candidate_v4v5.icc 10003 -INIT 3 Profiles\Lab_float-D50_2deg.icc 1 Profiles\Lab_float-D93_2deg-MAT.icc 1 Profiles\Lab_float-F11_2deg-MAT.icc 1 Profiles\Lab_float-illumA_2deg-MAT.icc 1 > Results\cmykGraysEst.txt

@type Results\cmykGraysEst.txt
