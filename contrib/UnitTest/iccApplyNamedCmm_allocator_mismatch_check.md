# Unit Test for `CreateAllProfiles.sh` with Debug Asan Checks

This script is designed to run a series of unit tests for the `CreateAllProfiles.sh` script, focusing on the detection of an allocator mismatch error observed in the `iccApplyNamedCmm` tool. The script applies AddressSanitizer (Asan) checks and performs tests across various color profiles and environments, including `CalcElement`, `NamedColor`, `GSDF Display`, and `Fluorescent Color` tests. 

## Prerequisites

Ensure that the following requirements are met before running the script:

- **Git**: For managing repositories.
- **Curl**: To fetch test scripts from the repository.
- **DemoIccMAX tools**: Ensure that the binary `IccApplyNamedCmm` is built and available on the system's `$PATH`. This can be done by adding the `../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm` to your environment's `$PATH`.

To verify this, the script will check if the tool is accessible before proceeding.

## Script Overview

This script performs the following tests:

1. **CalcElement Operations**: Tests calculations based on an sRGB ICC profile.
2. **NamedColor Tests**: Runs multiple tests on NamedColor profiles with different illuminants such as D93, D65, D50, and Illuminant A, using different degrees of observer angles (2° and 10°).
3. **Grayscale and RGB GSDF Display Link Profile Tests**: Validates grayscale and RGB displays under different ambient luminance settings.
4. **Fluorescent Color Tests**: Evaluates the handling of fluorescent colors under different illuminants such as D93, D65, D50, and Illuminant A.
5. **Six-Channel Reflectance Camera Tests**: Tests a six-channel reflectance camera profile and its conversion to the Lab color space and other illuminants.

## Usage

### Step 1: Run from Host

Ensure you have the DemoIccMAX environment set up and the necessary tools built:

```
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/iccApplyNamedCmm_allocator_mismatch_check.sh)"
```


### 25-FEB-2025 Output Sample

```
 ../Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm  Calc/srgbCalcTest.txt 2 0 Calc/srgbCalcTest.icc 3 sRGB_v4_ICC_preference.icc 3
/home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccMpeCalc.cpp:4563:37: runtime error: downcast of address 0x503000000400 which does not point to an object of type 'CIccMpeCalculator'
0x503000000400: note: object is of type 'CIccMpeCurveSet'
 00 00 00 00  30 6b 32 bd 79 7f 00 00  00 00 00 00 03 00 03 00  30 04 00 00 30 50 00 00  60 04 00 00
              ^~~~~~~~~~~~~~~~~~~~~~~
              vptr for 'CIccMpeCurveSet'
'RGB '  ; Data Format
icEncodeUnitFloat       ; Encoding

;Source Data Format: 'RGB '
;Source Data Encoding: icEncode8Bit
;Source data is after semicolon

;Profiles applied
; Calc/srgbCalcTest.icc
; sRGB_v4_ICC_preference.icc

    1.0000    0.9869    1.0000  ;  255.0000  255.0000  255.0000
    0.5244    0.4947    0.5025  ;  128.0000  128.0000  128.0000

=================================================================
==1437==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 56 byte(s) in 1 object(s) allocated from:
    #0 0x7f79beb14548 in operator new(unsigned long) ../../../../src/libsanitizer/asan/asan_new_delete.cpp:95
    #1 0x7f79bd089594 in CIccTagMultiProcessElement::GetNewApply() /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccTagMPE.cpp:1389
    #2 0x7f79bc9f794b in CIccXformMpe::GetNewApply(icStatusCMM&) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:7446
    #3 0x7f79bca3d6f3 in CIccNamedColorCmm::GetNewApplyCmm(icStatusCMM&) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:10640
    #4 0x7f79bca3cffc in CIccNamedColorCmm::Begin(bool, bool) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:10615
    #5 0x55d4bf22bda3 in main /home/xss/tmp/pr111/gnu/DemoIccMAX/Tools/CmdLine/IccApplyNamedCmm/iccApplyNamedCmm.cpp:396
    #6 0x7f79bae311c9  (/lib/x86_64-linux-gnu/libc.so.6+0x2a1c9) (BuildId: 42c84c92e6f98126b3e2230ebfdead22c235b667)
    #7 0x7f79bae3128a in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x2a28a) (BuildId: 42c84c92e6f98126b3e2230ebfdead22c235b667)
    #8 0x55d4bf2277c4 in _start (/home/xss/tmp/pr111/gnu/DemoIccMAX/Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm+0x2e17c4) (BuildId: 074b5cb5b035b1dadd98540b0ae63f039e6abf6e)
...

SUMMARY: AddressSanitizer: alloc-dealloc-mismatch ../../../../src/libsanitizer/asan/asan_new_delete.cpp:164 in operator delete(void*, unsigned long)
==1473==HINT: if you don't care about these errors you may set ASAN_OPTIONS=alloc_dealloc_mismatch=0
==1473==ABORTING
===========================================================================
Test Six Channel Reflectance Camera reflectance under D93 to Lab
=================================================================
==1474==ERROR: AddressSanitizer: alloc-dealloc-mismatch (operator new [] vs operator delete) on 0x519000001480
    #0 0x7f3ffa0895e8 in operator delete(void*, unsigned long) ../../../../src/libsanitizer/asan/asan_new_delete.cpp:164
    #1 0x7f3ff8036b2d in CIccMatrixMath::~CIccMatrixMath() /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccMatrixMath.cpp:142
    #2 0x7f3ff7fc348c in CIccPcsStepMatrix::~CIccPcsStepMatrix() /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.h:847
    #3 0x7f3ff7fc35df in CIccPcsStepMatrix::~CIccPcsStepMatrix() /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.h:847
    #4 0x7f3ff7e760b3 in CIccPcsXform::~CIccPcsXform() /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:1921
    #5 0x7f3ff7ea3b26 in CIccPcsXform::pushXYZNormalize(IIccProfileConnectionConditions*, icSpectralRange const&, icSpectralRange const&) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:3008
    #6 0x7f3ff7ea488e in CIccPcsXform::pushRef2Xyz(CIccProfile*, IIccProfileConnectionConditions*) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:3036
    #7 0x7f3ff7e85665 in CIccPcsXform::Connect(CIccXform*, CIccXform*) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:2134
    #8 0x7f3ff7f82e9a in CIccCmm::CheckPCSConnections(bool) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:8431
    #9 0x7f3ff7fb0b51 in CIccNamedColorCmm::Begin(bool, bool) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:10608
    #10 0x5634ff984da3 in main /home/xss/tmp/pr111/gnu/DemoIccMAX/Tools/CmdLine/IccApplyNamedCmm/iccApplyNamedCmm.cpp:396
    #11 0x7f3ff63a51c9  (/lib/x86_64-linux-gnu/libc.so.6+0x2a1c9) (BuildId: 42c84c92e6f98126b3e2230ebfdead22c235b667)
    #12 0x7f3ff63a528a in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x2a28a) (BuildId: 42c84c92e6f98126b3e2230ebfdead22c235b667)
    #13 0x5634ff9807c4 in _start (/home/xss/tmp/pr111/gnu/DemoIccMAX/Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm+0x2e17c4) (BuildId: 074b5cb5b035b1dadd98540b0ae63f039e6abf6e)

0x519000001480 is located 0 bytes inside of 972-byte region [0x519000001480,0x51900000184c)
allocated by thread T0 here:
    #0 0x7f3ffa0886c8 in operator new[](unsigned long) ../../../../src/libsanitizer/asan/asan_new_delete.cpp:98
    #1 0x7f3ff8035776 in CIccMatrixMath::CIccMatrixMath(unsigned short, unsigned short, bool) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccMatrixMath.cpp:101
    #2 0x7f3ff7fc2f56 in CIccPcsStepMatrix::CIccPcsStepMatrix(unsigned short, unsigned short, bool) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.h:842
    #3 0x7f3ff7e9e702 in CIccPcsXform::pushMatrix(unsigned short, unsigned short, float const*) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:2819
    #4 0x7f3ff7ea3157 in CIccPcsXform::pushXYZNormalize(IIccProfileConnectionConditions*, icSpectralRange const&, icSpectralRange const&) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:2979
    #5 0x7f3ff7ea488e in CIccPcsXform::pushRef2Xyz(CIccProfile*, IIccProfileConnectionConditions*) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:3036
    #6 0x7f3ff7e85665 in CIccPcsXform::Connect(CIccXform*, CIccXform*) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:2134
    #7 0x7f3ff7f82e9a in CIccCmm::CheckPCSConnections(bool) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:8431
    #8 0x7f3ff7fb0b51 in CIccNamedColorCmm::Begin(bool, bool) /home/xss/tmp/pr111/gnu/DemoIccMAX/IccProfLib/IccCmm.cpp:10608
    #9 0x5634ff984da3 in main /home/xss/tmp/pr111/gnu/DemoIccMAX/Tools/CmdLine/IccApplyNamedCmm/iccApplyNamedCmm.cpp:396
    #10 0x7f3ff63a51c9  (/lib/x86_64-linux-gnu/libc.so.6+0x2a1c9) (BuildId: 42c84c92e6f98126b3e2230ebfdead22c235b667)
    #11 0x7f3ff63a528a in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x2a28a) (BuildId: 42c84c92e6f98126b3e2230ebfdead22c235b667)
    #12 0x5634ff9807c4 in _start (/home/xss/tmp/pr111/gnu/DemoIccMAX/Build/Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm+0x2e17c4) (BuildId: 074b5cb5b035b1dadd98540b0ae63f039e6abf6e)

SUMMARY: AddressSanitizer: alloc-dealloc-mismatch ../../../../src/libsanitizer/asan/asan_new_delete.cpp:164 in operator delete(void*, unsigned long)
==1474==HINT: if you don't care about these errors you may set ASAN_OPTIONS=alloc_dealloc_mismatch=0
==1474==ABORTING
```
