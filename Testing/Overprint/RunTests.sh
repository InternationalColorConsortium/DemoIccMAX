#!/bin/sh
#################################################################################
# Overprint/RunTests.sh | iccMAX Project
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

echo "====================== Entering Overprint/RunTests.sh =========================="

# Properly handle newline-separated paths as a list
find ../Build/Tools -type f -perm -111 -exec dirname {} \; | sort -u | while read -r d; do
  abs_path=$(cd "$d" && pwd)
  PATH="$abs_path:$PATH"
done

export PATH

echo "Reminer - 10 September 2024 - Createprofile.sh is being refactored.... "
echo "The CreateProfiles.sh Script will create 17ChanPart1.icc... but.. "
echo "The file 17ChanPart1.icc won't be created via script until the Overflow is Fixed"
echo "Issue: CIccCLUT::Interp2d(float*, float const*) const IccTagLut.cpp:2454"
iccApplyNamedCmm 17ChanData.txt 3 0 17ChanPart1.icc 1

echo "====================== Exiting Overprint/RunTests.sh =========================="