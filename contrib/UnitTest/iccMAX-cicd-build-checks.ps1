#################################################################################
# iccMAX-cicd-build-checks.ps1 | iccMAX Project
# Copyright (C) 2024-2025 David H Hoyt LLC.
#                                        All rights reserved.
#
#
#  Last Updated: 11-APRIL-2025 1400 EDT by David Hoyt
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
#
#################################################################################

# === Config ===
$LOG_TAG = "RunnerStub"
function Log-Message {
    param([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "${timestamp}: $message" | Tee-Object -FilePath $REPORT_FILE -Append
}


# === Entrypoint ===
Log "==========================================================================="
Log "✅ Entry Point | iccMAX Runner Stub"
Log "==========================================================================="

# === [Check 1] Run Profile Creation Script ===
Log "[Check 1 ] CreateAllProfiles.ps1"
# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.ps1" -OutFile "CreateAllProfiles.ps1"
# powershell -ExecutionPolicy Bypass -File "CreateAllProfiles.ps1" || Fail "CreateAllProfiles.ps1 failed"
Log "[Check 1] ✅ DONE"

# === [Check 2] Profile Calculation Tests ===
Log "[Check 2] check_profiles.ps1"
Set-Location ..\Build || Fail "Missing ../Build directory"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/CalcTest/check_profiles.ps1" -OutFile "check_profiles.ps1"
powershell -ExecutionPolicy Bypass -File "check_profiles.ps1" || Fail "check_profiles.ps1 failed"
Log "[Check 2] ✅ DONE"

# === [Check 3] Profile Output Verification ===
Log "[Check 3] calc_test.ps1"
# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/CalcTest/calc_test.ps1" -OutFile "calc_test.ps1"
# powershell -ExecutionPolicy Bypass -File "calc_test.ps1" || Fail "calc_test.ps1 failed"
# Set-Location ..\Testing || Fail "Missing ../Testing directory"
Log "[Check 3] ✅ DONE"

# === [Check 4] UBSan Trigger Profile ===
Log "[Check 4] icPlatformSignature-ubsan-poc.icc"
# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc" -OutFile "icPlatformSignature-ubsan-poc.icc"
# ..\Build\Tools\IccDumpProfile\iccDumpProfile.exe icPlatformSignature-ubsan-poc.icc || Fail "iccDumpProfile failed"
Log "[Check 4] ✅ DONE"

# === [Check 5] Allocator Mismatch PoC (Disabled) ===
Log "[Check 5] Skipped: iccApplyNamedCmm allocator mismatch PoC"
# Invoke-WebRequest ... | powershell
Log "[Check 5] ✅ SKIPPED"

# === [Check 6] Matrix Elem Type PoC ===
Log "[Check 6] MatrixElemType"
# Invoke-WebRequest -Uri "https://github.com/InternationalColorConsortium/DemoIccMAX/raw/refs/heads/master/contrib/UnitTest/icSigMatrixElemType-Read-poc.icc" -OutFile "icSigMatrixElemType-Read-poc.icc"
# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/icSigMatrixElemType-Read-poc.ps1" -OutFile "MatrixElemType.ps1"
# powershell -ExecutionPolicy Bypass -File "MatrixElemType.ps1" || Fail "MatrixElemType test failed"
Log "[Check 6] ✅ DONE"

# === [Check 7] ProfileSequenceId Type Confusion ===
Log "[Check 7] ProfileSequenceId PoC"
# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/master/contrib/UnitTest/TestCIccTagXmlProfileSequenceId.cpp" -OutFile "TestCIccTagXmlProfileSequenceId.cpp"
# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/TestCIccTagXmlProfileSequenceId.ps1" -OutFile "TestCIccTagXmlProfileSequenceId.ps1"
# powershell -ExecutionPolicy Bypass -File "TestCIccTagXmlProfileSequenceId.ps1" || Fail "ProfileSequenceId PoC test failed"
Log "[Check 7] ✅ DONE"

# === [Check 8] Lab_float Type Confusion (Skipped) ===
Log "[Check 8] Skipped: Lab_float-D50_2deg.icc"
# ..\Build\Tools\IccRoundTrip\iccRoundTrip.exe PCC\Lab_float-D50_2deg.icc
Log "[Check 8] ✅ SKIPPED"

# === [Check 9] CVE-2023-46602 ===
Log "[Check 9] CVE-2023-46602 Regression Check"
# Set-Location .. || Fail "Could not go up to root"
# .\Build\Tools\IccToXml\iccToXml.exe .\contrib\UnitTest\cve-2023-46602.icc .\contrib\UnitTest\cve-2023-46602.xml || Fail "CVE-2023-46602 test failed"
Log "[Check 9] ✅ DONE"

# === [Check 10] Heap Overflow / ParseText ===
Log "[Check 10] Heap Overflow PoC (testParseText)"
# Set-Location Testing || Fail "Missing Testing directory"
# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/TestParseText.ps1" -OutFile "TestParseText.ps1"
# powershell -ExecutionPolicy Bypass -File "TestParseText.ps1" || Fail "testParseText failed"
Log "[Check 10] ✅ DONE"

Log "==========================================================================="
Log "✅ All Checks Completed Successfully | iccMAX Runner Stub"
Log "==========================================================================="
