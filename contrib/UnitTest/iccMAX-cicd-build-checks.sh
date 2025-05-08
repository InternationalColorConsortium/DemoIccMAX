#!/usr/bin/env bash
#################################################################################
# iccMAX-cicd-build-checks.sh | iccMAX Project
# Copyright (C) 2024-2025 The International Color Consortium.
#                                        All rights reserved.
#
#
#  Last Updated: 09-APRIL-2025 1900 EDT by David Hoyt
#
#
#
#
#
#
# RUN from Testing/
#
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
# Properly handle newline-separated paths as a list
find ../Build/Tools -type f -perm -111 -exec dirname {} \; | sort -u | while read -r d; do
  abs_path=$(cd "$d" && pwd)
  PATH="$abs_path:$PATH"
done

export PATH
# === Entrypoint ===
log "==========================================================================="
log "? Entry Point | iccMAX Runner Stub"
log "==========================================================================="

# === [Check 1] Run Profile Creation Script ===
log "[Check 1] CreateAllProfiles.sh"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh | bash || fail "CreateAllProfiles.sh failed"
log "[Check 1] DONE"

# === [Check 2] Profile Calculation Tests ===
log "[Check 2] check_profiles.zsh"
cd ../Build || fail "Missing ../Build directory"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/CalcTest/check_profiles.zsh | bash || fail "check_profiles.zsh failed"
log "[Check 2] DONE"

# === [Check 3] Profile Output Verification ===
#log "[Check 3] calc_test.zsh"
#curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/CalcTest/calc_test.zsh | bash || fail "calc_test.zsh failed"
#cd ../Testing || fail "Missing ../Testing directory"
#log "[Check 3] DONE"

# === [Check 4] UBSan Trigger Profile ===
log "[Check 4] icPlatformSignature-ubsan-poc.icc"
wget -q https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc || fail "UBSan profile download failed"
../Build/Tools/IccDumpProfile/iccDumpProfile icPlatformSignature-ubsan-poc.icc || fail "iccDumpProfile failed"
log "[Check 4] DONE"

# === [Check 5] Allocator Mismatch PoC (Disabled) ===
log "[Check 5] Skipped: iccApplyNamedCmm allocator mismatch PoC"
# curl ... | bash
log "[Check 5] SKIPPED"

# === [Check 6] Matrix Elem Type PoC ===
log "[Check 6] MatrixElemType"
wget -q https://github.com/InternationalColorConsortium/DemoIccMAX/raw/refs/heads/master/contrib/UnitTest/icSigMatrixElemType-Read-poc.icc || fail "Matrix PoC download failed"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/icSigMatrixElemType-Read-poc.sh | bash || fail "MatrixElemType test failed"
log "[Check 6] DONE"

# === [Check 7] ProfileSequenceId Type Confusion ===
log "[Check 7] ProfileSequenceId PoC"
wget -q https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/master/contrib/UnitTest/TestCIccTagXmlProfileSequenceId.cpp || fail "ProfileSequenceId PoC download failed"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/TestCIccTagXmlProfileSequenceId.sh | bash || fail "ProfileSequenceId PoC test failed"
log "[Check 7] DONE"

# === [Check 8] Lab_float Type Confusion (Skipped) ===
log "[Check 8] Skipped: Lab_float-D50_2deg.icc"
# ../Build/Tools/IccRoundTrip/iccRoundTrip PCC/Lab_float-D50_2deg.icc
log "[Check 8] SKIPPED"

# === [Check 9] CVE-2023-46602 ===
log "[Check 9] CVE-2023-46602 Regression Check"
cd .. || fail "Could not go up to root"
Build/Tools/IccToXml/iccToXml contrib/UnitTest/cve-2023-46602.icc contrib/UnitTest/cve-2023-46602.xml || fail "CVE-2023-46602 test failed"
log "[Check 9] DONE"

# === [Check 10] Heap Overflow / ParseText ===
log "[Check 10] Heap Overflow PoC (testParseText)"
cd Testing || fail "Missing Testing directory"
curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/TestParseText.sh | bash || fail "testParseText failed"
log "[Check 10] DONE"

log "==========================================================================="
log "All Checks Completed Successfully | iccMAX Runner Stub"
log "==========================================================================="
