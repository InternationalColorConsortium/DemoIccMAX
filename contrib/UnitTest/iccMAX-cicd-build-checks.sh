#!/usr/bin/env bash
#################################################################################
# iccMAX-cicd-build-checks.sh | iccMAX Project
# Copyright (C) 2024-2025 The International Color Consortium.
#                                        All rights reserved.
#
#
#  Last Updated: 21-APRIL-2025 1600 EDT by David Hoyt
#
# Intent: STUB for Minimum CICD Checks
#
#
#
#
# RUN from Testing/
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/iccMAX-cicd-build-checks.sh)"
#
# STUB for Post-Build CI-CD Checks
#
#################################################################################

#!/usr/bin/env bash
set -euo pipefail

# === Config ===
LOG_TAG="RunnerStub"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(realpath "$SCRIPT_DIR/..")"
TOOLS_DIRS=("$ROOT_DIR/Build/Tools"/*)

log()  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$LOG_TAG] $*"; }
fail() { log "❌ ERROR: $*" >&2; exit 1; }

# === Export PATH for iccMAX Tools ===
for d in "${TOOLS_DIRS[@]}"; do
  [[ -d "$d" ]] && export PATH="$(realpath "$d"):$PATH"
done

# === Start Banner ===
log "==========================================================================="
log "✅ Entry Point | iccMAX Runner Stub"
log "==========================================================================="

# === [Check 1] Run Profile Creation Script ===
log "[Check 1] CreateAllProfiles.sh"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh | bash || fail "CreateAllProfiles.sh failed"
log "[Check 1] ✅ DONE"

# === [Check 2] Profile Calculation Tests ===
log "[Check 2] check_profiles.zsh"
cd "$ROOT_DIR/Build" || fail "Missing Build directory"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/CalcTest/check_profiles.zsh | bash || fail "check_profiles.zsh failed"
log "[Check 2] ✅ DONE"

# === [Check 3] Profile Output Verification (Bypass) ===
log "[Check 3] calc_test.zsh"
cd "$ROOT_DIR/Build" || fail "Missing Testing directory"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/pr128/contrib/CalcTest/calc_test.sh)"
log "[Check 3] ✅ DONE"

# === [Check 4] UBSan Trigger Profile ===
log "[Check 4] icPlatformSignature-ubsan-poc.icc"
wget -q https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc || fail "UBSan profile download failed"
iccDumpProfile icPlatformSignature-ubsan-poc.icc || fail "iccDumpProfile failed"
log "[Check 4] ✅ DONE"

# === [Check 5] Allocator Mismatch PoC (Skipped) ===
log "[Check 5] Skipped: iccApplyNamedCmm allocator mismatch PoC"
log "[Check 5] ✅ SKIPPED"

# === [Check 6] Matrix Elem Type PoC ===
log "[Check 6] MatrixElemType"
wget -q https://github.com/InternationalColorConsortium/DemoIccMAX/raw/refs/heads/master/contrib/UnitTest/icSigMatrixElemType-Read-poc.icc || fail "Matrix PoC download failed"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/icSigMatrixElemType-Read-poc.sh | bash || fail "MatrixElemType test failed"
log "[Check 6] ✅ DONE"

# === [Check 7] ProfileSequenceId Type Confusion ===
log "[Check 7] ProfileSequenceId PoC"
wget -q https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/master/contrib/UnitTest/TestCIccTagXmlProfileSequenceId.cpp || fail "ProfileSequenceId PoC download failed"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/TestCIccTagXmlProfileSequenceId.sh | bash || fail "ProfileSequenceId PoC test failed"
./TestCIccTagXmlProfileSequenceId
log "[Check 7] ✅ DONE"

# === [Check 8] CVE-2023-46602 ===
log "[Check 8] CVE-2023-46602 Regression Check"
cd "$ROOT_DIR" || fail "Could not go up to root"
iccToXml contrib/UnitTest/cve-2023-46602.icc contrib/UnitTest/cve-2023-46602.xml || fail "CVE-2023-46602 test failed"
log "[Check 8] ✅ DONE"

# === [Check 9] Heap Overflow / ParseText ===
log "[Check 9] Heap Overflow PoC (testParseText)"
cd "$ROOT_DIR/Testing" || fail "Missing Testing directory"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/TestParseText.sh | bash || fail "testParseText failed"
log "[Check 9] ✅ DONE"

# === [Check 10] namedccm check ===
#log "[Check 10] NamedCmm check"
# cd "$ROOT_DIR/Build" || fail "Could not go up to build"
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/pr128/contrib/CalcTest/test_icc_apply_named_cmm.sh)"
# log "[Check 10] ✅"

# === [Check 10] calcCheckInit and calcExercizeOps check ===
log "[Check 10] calcCheckInit and calcExercizeOps check"
cd "$ROOT_DIR/Build" || fail "Could not go up to build"
./Tools/IccFromXml/iccFromXml ../Testing/CalcTest/calcCheckInit.xml ../Testing/CalcTest/calcCheckInit.icc
./Tools/IccFromXml/iccFromXml ../Testing/CalcTest/calcExercizeOps.xml ../Testing/CalcTest/calcExercizeOps.icc
log "[Check 10] ✅ DONE"

# === [Check 11] calcCheckInit-debugcalc Check ===
log "[Check 11] calcCheckInit-debugcalc Check"
cd "$ROOT_DIR/Build" || fail "Could not go up to build"
./Tools/IccApplyNamedCmm/iccApplyNamedCmm -debugcalc ../Testing/CalcTest/rgbExercise8bit.txt 0 1 ../Testing/CalcTest/calcCheckInit.icc 1
log "[Check 11] ✅ DONE"

# === [Check 10] namedccm check ===
# log "[Check 10] NamedCmm check"
# cd "$ROOT_DIR/Build" || fail "Could not go up to build"
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/pr128/contrib/CalcTest/test_icc_apply_named_cmm.sh)"
# log "[Check 10] ✅"

# === Done ===
log "==========================================================================="
log "✅ All Checks Completed Successfully | iccMAX Runner Stub"
log "==========================================================================="
