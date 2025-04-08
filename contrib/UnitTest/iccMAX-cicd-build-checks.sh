#!/bin/sh
#################################################################################
# iccMAX-cicd-build-checks.sh | iccMAX Project
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

#!/bin/bash
set -euo pipefail

echo "==========================================================================="
echo "✅ Runner Stub Entry Point"
echo "==========================================================================="

# === [Check 1] Run Profile Creation Script from ICC Main ===
echo "[Check 1] Generate Test Profiles via CreateAllProfiles.sh"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh | bash

# === [Check 2] Validate Profile Results (xsscx fork) ===
echo "[Check 2] Profile Calculation Test Suite (check_profiles.zsh)"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/CalcTest/check_profiles.zsh | bash

echo "[Check 3] Profile Output Verification (calc_test.zsh)"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/CalcTest/calc_test.zsh | bash

# === [Check 4] Heap + UBSan Trigger Profile ===
echo "[Check 4] Run icPlatformSignature-ubsan-poc with iccDumpProfile"
wget -q https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc
../Build/Tools/IccDumpProfile/iccDumpProfile icPlatformSignature-ubsan-poc.icc

# === [Check 5] Allocator Mismatch Check ===
echo "[Check 5] iccApplyNamedCmm Allocator Mismatch Check"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/iccApplyNamedCmm_allocator_mismatch_check.sh | bash

# === [Check 6] Matrix Elem Type PoC ===
wget https://github.com/xsscx/PatchIccMAX/raw/refs/heads/pr119/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/icSigMatrixElemType-Read-poc.sh | bash

# === [Check 7] ProfileSequenceId Test (Type Confusion/Overflow) ===
echo "[Check 7] TestCIccTagXmlProfileSequenceId PoC"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/TestCIccTagXmlProfileSequenceId.sh | bash

# === [Check 8] Type Confusion with Real Profile ===
echo "[Check 8] Type Confusion on Lab_float-D50_2deg.icc"
../Build/Tools/IccRoundTrip/iccRoundTrip PCC/Lab_float-D50_2deg.icc

# === [Check 9] CVE Regression (CVE-2023-46602) ===
echo "[Check 9] Validate CVE-2023-46602 is Handled Safely"
cd ..
Build/Tools/IccToXml/iccToXml contrib/UnitTest/cve-2023-46602.icc contrib/UnitTest/cve-2023-46602.xml

# === [Check 10] Trigger and Validate Heap Overflow / ParseText ===
echo "[Check 10] Run testParse() Against Crafted Input"
cd Testing/
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/TestParseText.sh | bash

echo "==========================================================================="
echo "✅ Runner Stub Complete"
echo "==========================================================================="
