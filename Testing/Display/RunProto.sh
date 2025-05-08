#!/bin/sh
#################################################################################
# Display/RunTests.sh | iccMAX Project
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
# Intent: iccMAX CICD
#
#
#
#
#################################################################################

echo "====================== Entering Display/RunTests.sh =========================="

# Properly handle newline-separated paths as a list
find ../Build/Tools -type f -perm -111 -exec dirname {} \; | sort -u | while read -r d; do
  abs_path=$(cd "$d" && pwd)
  PATH="$abs_path:$PATH"
done

export PATH

echo "==========================================================================="
echo "Colorimetric Rec2020 profile test"
iccApplyNamedCmm rgbTestSamples.txt 3 0 ProtoRec2020rgbColorimetric.icc 1 ..\PCC\XYZ_int-D50_2deg.icc 1

echo "==========================================================================="
echo "Spectral Rec2020 profile test with standard 2-degree observer"
iccApplyNamedCmm rgbTestSamples.txt 3 0 ProtoRec2020rgbSpectral.icc 1 ..\PCC\XYZ_int-D50_2deg.icc 1

echo "==========================================================================="
echo "Spectral Rec2020 profile test with 20 year old 2-degree observer"
iccApplyNamedCmm rgbTestSamples.txt 3 0 ProtoRec2020rgbSpectral.icc 1 -PCC ..\PCC\Spec400_10_700-D65_20yo2deg-MAT.icc ..\PCC\XYZ_int-D50_2deg.icc 1

echo "==========================================================================="
echo "Spectral Rec2020 profile test with 40 year old 2-degree observer"
iccApplyNamedCmm rgbTestSamples.txt 3 0 ProtoRec2020rgbSpectral.icc 1 -PCC ..\PCC\Spec400_10_700-D65_40yo2deg-MAT.icc ..\PCC\XYZ_int-D50_2deg.icc 1

echo "==========================================================================="
echo "Spectral Rec2020 profile test with 60 year old 2-degree observer"
iccApplyNamedCmm rgbTestSamples.txt 3 0 ProtoRec2020rgbSpectral.icc 1 -PCC ..\PCC\Spec400_10_700-D65_60yo2deg-MAT.icc ..\PCC\XYZ_int-D50_2deg.icc 1

echo "==========================================================================="
echo "Spectral Rec2020 profile test with 80 year old 2-degree observer"
iccApplyNamedCmm rgbTestSamples.txt 3 0 ProtoRec2020rgbSpectral.icc 1 -PCC ..\PCC\Spec400_10_700-D65_80yo2deg-MAT.icc ..\PCC\XYZ_int-D50_2deg.icc 1

echo "====================== Exiting Display/RunTests.sh =========================="