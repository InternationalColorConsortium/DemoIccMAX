# Hoyt's Reproduction for Windows ASAN/UBSAN Interceptor Bug

Date: 20-Nov-2024

## Overview

The Sanitizer logs indicate runtime errors preventing sanitizer functionality due to function interception failures.

### Host Environment
```
Microsoft Visual Studio Enterprise 2022
Version 17.12.1
VisualStudio.17.Release/17.12.1+35514.174
Microsoft .NET Framework
Version 4.8.09032
```

### Build Process
To reproduce the issue, the following command was executed in the Developer PowerShell:
```
iex (iwr -Uri "https://raw.githubusercontent.com/xsscx/PatchIccMAX/development/contrib/Build/VS2022C/build_asan.ps1").Content
```

### Observations
1. **Interceptor Skipping:**
   - Several function addresses were skipped during re-interception:
     ```
     Address 0x7ffcda403d50 was already intercepted with result: 1. Skipping re-interception.
     ```

2. **Interceptor Failures:**
   - ASAN failed to intercept key functions in `ntdll.dll` and `vcruntime140.dll`, including `atoll`, `strtoll`, and other memory management functions.
     Example:
     ```
     ==28756==AddressSanitizer: failed to intercept 'atoll' in ntdll.dll
     ==28756==AddressSanitizer: failed to intercept 'strtoll' in ntdll.dll
     ```

3. **Configuration Details:**
   - Memory shadowing details indicated proper ASAN initialization but were unable to proceed due to interception failures.

4. **Function Override Failures:**
   - Both `_aligned_free_dbg` and `_msize_dbg` failed to override in `vcruntime140.dll` and `ucrtbase.dll`.

## Findings

### 1. General Observations
- **ASAN and UBSAN Runtime**: 
  - Failures were linked to the inability to override low-level functions such as `atol`.
  - Issues occurred in multiple executables during runtime.
- **Impact**: 
  - Prevents effective runtime sanitization for memory and undefined behavior checks.

### 2. Successful Executables
The following executables ran successfully, providing expected output:
- **iccApplyNamedCmm.exe**
- **iccApplyProfiles.exe**
- **iccFromXml.exe**
- **iccToXml.exe**

### 3. Failed Executables
The following executables encountered runtime failures due to ASAN/UBSAN-related issues:

| Executable              | Failure Location                              | Error Summary                                                                 | Stack Trace Example                                                                                       |
|-------------------------|-----------------------------------------------|------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| **iccDumpProfile.exe**  | `sanitizer_win_interception.cpp:149`         | Failed to replace local function with sanitizer version (`__asan_wrap_atol`) | `main E:\rpppp\PatchIccMAX\Tools\CmdLine\IccDumpProfile\iccDumpProfile.cpp:343`                     |
| **iccFromCube.exe**     | `sanitizer_win_interception.cpp:149`         | Failed to replace local function with sanitizer version (`__asan_wrap_atol`) | `std::basic_string::_Reallocate_for C:\...\xstring:2980`                                               |
| **iccRoundTrip.exe**    | `sanitizer_win_interception.cpp:149`         | Failed to replace local function with sanitizer version (`__asan_wrap_atol`) | `main E:\rpppp\PatchIccMAX\Tools\CmdLine\IccRoundTrip\iccRoundTrip.cpp:150`                         |
| **iccSpecSepToTiff.exe**| `sanitizer_win_interception.cpp:149`         | Failed to replace local function with sanitizer version (`__asan_wrap_atol`) | `std::_Allocate_manually_vector_aligned C:\...\xmemory:151`                                             |
| **iccTiffDump.exe**     | `sanitizer_win_interception.cpp:149`         | Failed to replace local function with sanitizer version (`__asan_wrap_atol`) | `CTiffImg::Open(char const *) E:\...\TiffImg.cpp:271`                                                  |
| **iccV5DspObsToV4Dsp.exe**| `sanitizer_win_interception.cpp:149`       | Failed to replace local function with sanitizer version (`__asan_wrap_atol`) | `std::_Allocate_manually_vector_aligned C:\...\xmemory:159`                                             |

## Summary Analysis
- **Sanitizer Interception**:
  - All failures point to `sanitizer_win_interception.cpp:149`, where AddressSanitizer attempts to override local functions (e.g., `atol`) but fails.
  - This issue is specific to the Windows platform and its sanitizer implementation.
- **Memory Allocation Failures**:
  - Some failures involve standard C++ STL functions like `std::basic_string` and `std::_Allocate_manually_vector_aligned`, indicating broader runtime compatibility issues.

---

### ASAN Log

```
Address 0x7ffcda403d50 was already intercepted with result: 1. Skipping re-interception.
Address 0x7ffcda403d50 was already intercepted with result: 1. Skipping re-interception.
Address 0x7ffcda3f1f60 was already intercepted with result: 1. Skipping re-interception.
Address 0x7ffcda3f2ca0 was already intercepted with result: 1. Skipping re-interception.
Address 0x7ffcd7e7dad0 was already intercepted with result: 1. Skipping re-interception.
Address 0x7ffcda444dc0 was already intercepted with result: 1. Skipping re-interception.
Address 0x7ffcd7df0d70 was already intercepted with result: 1. Skipping re-interception.
==28756==AddressSanitizer: failed to intercept 'atoll' in ntdll.dll
==28756==AddressSanitizer: failed to intercept 'strtoll' in ntdll.dll
==28756==AddressSanitizer: libc interceptors initialized
|| `[0x100140300000, 0x7fffffffffff]` || HighMem    ||
|| `[0x020168360000, 0x1001402fffff]` || HighShadow ||
|| `[0x000168360000, 0x02016835ffff]` || ShadowGap  ||
|| `[0x000140300000, 0x00016835ffff]` || LowShadow  ||
|| `[0x000000000000, 0x0001402fffff]` || LowMem     ||
MemToShadow(shadow): 0x000168360000 0x00016d36bfff 0x00416d36c000 0x02016835ffff
redzone=16
max_redzone=2048
quarantine_size_mb=256M
thread_local_quarantine_size_kb=1024K
malloc_context_size=30
SHADOW_SCALE: 3
SHADOW_GRANULARITY: 8
SHADOW_OFFSET: 0x000140300000
Failed to override function _aligned_free_dbg in vcruntime140.dll
Failed to override function _aligned_offset_recalloc_dbg in vcruntime140.dll
Failed to override function _aligned_realloc_dbg in vcruntime140.dll
Failed to override function _aligned_recalloc_dbg in vcruntime140.dll
Failed to override function _expand_dbg in vcruntime140.dll
Failed to override function _free_dbg in vcruntime140.dll
Failed to override function _msize_dbg in vcruntime140.dll
Failed to override function _realloc_dbg in vcruntime140.dll
Failed to override function _recalloc_dbg in vcruntime140.dll
Failed to override function _aligned_free in vcruntime140.dll
Failed to override function _aligned_msize in vcruntime140.dll
Failed to override function _aligned_offset_realloc in vcruntime140.dll
Failed to override function _aligned_offset_recalloc in vcruntime140.dll
Failed to override function _aligned_realloc in vcruntime140.dll
Failed to override function _aligned_recalloc in vcruntime140.dll
Failed to override function _expand in vcruntime140.dll
Failed to override function _expand_base in vcruntime140.dll
Failed to override function _free_base in vcruntime140.dll
Failed to override function _msize in vcruntime140.dll
Failed to override function _msize_base in vcruntime140.dll
Failed to override function realloc in vcruntime140.dll
Failed to override function _realloc_base in vcruntime140.dll
Failed to override function _realloc_crt in vcruntime140.dll
Failed to override function _recalloc in vcruntime140.dll
Failed to override function _recalloc_base in vcruntime140.dll
Failed to override function _recalloc_crt in vcruntime140.dll
Failed to override function free in vcruntime140.dll
Failed to override function _aligned_free_dbg in ucrtbase.dll
Failed to override function _aligned_offset_recalloc_dbg in ucrtbase.dll
Failed to override function _aligned_realloc_dbg in ucrtbase.dll
Failed to override function _aligned_recalloc_dbg in ucrtbase.dll
Failed to override function _expand_dbg in ucrtbase.dll
Failed to override function _free_dbg in ucrtbase.dll
Failed to override function _msize_dbg in ucrtbase.dll
Failed to override function _realloc_dbg in ucrtbase.dll
Failed to override function _recalloc_dbg in ucrtbase.dll
Failed to override function _expand_base in ucrtbase.dll
Failed to override function _msize_base in ucrtbase.dll
Failed to override function _realloc_crt in ucrtbase.dll
Failed to override function _recalloc_base in ucrtbase.dll
Failed to override function _recalloc_crt in ucrtbase.dll
Failed to override function _aligned_free_dbg in ntdll.dll
Failed to override function _aligned_offset_recalloc_dbg in ntdll.dll
Failed to override function _aligned_realloc_dbg in ntdll.dll
Failed to override function _aligned_recalloc_dbg in ntdll.dll
Failed to override function _expand_dbg in ntdll.dll
Failed to override function _free_dbg in ntdll.dll
Failed to override function _msize_dbg in ntdll.dll
Failed to override function _realloc_dbg in ntdll.dll
Failed to override function _recalloc_dbg in ntdll.dll
Failed to override function _aligned_free in ntdll.dll
Failed to override function _aligned_msize in ntdll.dll
Failed to override function _aligned_offset_realloc in ntdll.dll
Failed to override function _aligned_offset_recalloc in ntdll.dll
Failed to override function _aligned_realloc in ntdll.dll
Failed to override function _aligned_recalloc in ntdll.dll
Failed to override function _expand in ntdll.dll
Failed to override function _expand_base in ntdll.dll
Failed to override function _free_base in ntdll.dll
Failed to override function _msize in ntdll.dll
Failed to override function _msize_base in ntdll.dll
Failed to override function realloc in ntdll.dll
Failed to override function _realloc_base in ntdll.dll
Failed to override function _realloc_crt in ntdll.dll
Failed to override function _recalloc in ntdll.dll
Failed to override function _recalloc_base in ntdll.dll
Failed to override function _recalloc_crt in ntdll.dll
Failed to override function free in ntdll.dll
Address 0x7ffcd77a5570 was already intercepted with result: 1. Skipping re-interception.
==28756==SetCurrentThread: 0x0000023a0000 for thread 0x000000007c78
==28756==T0: stack [0x000000050000,0x000000150000) size 0x100000; local=0x00000014ef90
==28756==Using llvm-symbolizer at path: C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC\14.42.34433\bin\HostX64\x64/llvm-symbolizer.exe
==28756==AddressSanitizer Init done
==28756==ERROR: Failed to override local function at '0x0001401ccc40' with sanitizer function '__asan_wrap_atol_static'
AddressSanitizer: CHECK failed: sanitizer_win_interception.cpp:149 "(("Failed to replace local function with sanitizer version." && 0)) != (0)" (0x0, 0x0) (tid=31864)
    #0 0x7ffbe7327f7f in __asan::CheckUnwind D:\a\_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\asan\asan_rtl.cpp:70
    #1 0x7ffbe72df993 in __sanitizer::CheckFailed(char const *, int, char const *, unsigned __int64, unsigned __int64) D:\a\_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\sanitizer_common\sanitizer_termination.cpp:86
    #2 0x7ffbe72dee15 in __sanitizer_override_function D:\a\_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\sanitizer_common\sanitizer_win_interception.cpp:149
    #3 0x0001400047cc in main E:\rpppp\PatchIccMAX\Tools\CmdLine\IccDumpProfile\iccDumpProfile.cpp:349
    #4 0x00014000479e in main E:\rpppp\PatchIccMAX\Tools\CmdLine\IccDumpProfile\iccDumpProfile.cpp:348
    #5 0x000140004746 in main E:\rpppp\PatchIccMAX\Tools\CmdLine\IccDumpProfile\iccDumpProfile.cpp:343
    #6 0x7ffcda2fd852  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x18001d852)
    #7 0x7ffcda30380f  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x18002380f)
    #8 0x7ffcda38dcc1  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800adcc1)
    #9 0x7ffcda38bddf  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800abddf)
    #10 0x7ffcda3fefa2  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x18011efa2)
    #11 0x7ffcda3d235d  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800f235d)

```

---

### Workaround

---

#### [Posted to Developer Community](https://developercommunity.visualstudio.com/t/ASAN-atol_static-interception-failure/10729662?ref=native&refTime=1745406931783&refUserId=8be899af-a536-60cd-9557-8670734e56da)

**Subject:** Workarounds for AddressSanitizer Interception Issues

Hello All,

If you’re encountering AddressSanitizer (ASan) failures when intercepting functions like `atoi`, `atoll`, and `strtoll`, this issue has **known workarounds**.

#### Understanding the Problem

*   **Interception Failures:** ASan wraps standard library functions to monitor memory accesses, but certain functions (especially on Windows) may not be intercepted properly.
*   **“Skipping Re-interception” Messages:** These indicate that ASan has already intercepted the function or cannot properly override it due to runtime limitations in Windows (`ntdll.dll`).

#### Workarounds & Solutions

1.  Replace `atol`, `atoll`, and `strtoll` with custom wrappers using `_strtoi64()` on Windows to avoid interception issues.
    
    ```  
    Extern "C" long long my_atoll(const char* str) {
    return _strtoi64(str, nullptr, 10);
    }
      
    ```
2.  Use a Different Platform  
    ASan interception works more reliably on macOS, Linux, or WSL. If your project allows it, consider testing on these platforms.

---

My Original Report Below

---

## VS2022E | ASAN Crash on Windows

**Reporter:** David Hoyt @xsscx

**September 15, 2024**

***tl;dr*** VS2022E ASAN Failures

[MSFT Developer Community Report](https://developercommunity.visualstudio.com/t/ASAN-atol_static-interception-failure/10746460?q=asan&fTime=6m&sort=newest)

**Failed to override local function at '0x0001404564d0' with sanitizer function '__asan_wrap_atol_static'**

## Build Reproduction

```
# setup dirs
$baseDir = "C:\tmp\build"
$repoDir = "$baseDir\PatchIccMAX"
$vcpkgDir = "$baseDir\vcpkg"
$patchDir = "$baseDir\patch"

# Create base directory
New-Item -ItemType Directory -Path $baseDir -Force

# Clone and setup vcpkg
cd $baseDir
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg.exe integrate install
.\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows

# Clone DemoIccMAX repository

git clone https://github.com/xsscx/PatchIccMAX.git
cd PatchIccMAX
checkout development
git revert --no-edit b90ac3933da99179df26351c39d8d9d706ac1cc6

# Build the project
$msbuildPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
& $msbuildPath /m /maxcpucount .\Build\MSVC\BuildAll_v22.sln /p:Configuration=Debug /p:Platform=x64 /p:AdditionalIncludeDirectories="$vcpkgDir\installed\x64-windows\include" /p:AdditionalLibraryDirectories="$vcpkgDir\installed\x64-windows\lib" /p:CLToolAdditionalOptions="/fsanitize=address /Zi /Od /DDEBUG /W4" /p:LinkToolAdditionalOptions="/fsanitize=address /DEBUG /INCREMENTAL:NO"
```

## Crash Repro
```
Tools\CmdLine\IccApplyNamedCmm\x64\Debug\iccApplyNamedCmm.exe
==4620==ERROR: Failed to override local function at '0x0001404564d0' with sanitizer function '__asan_wrap_atol_static'
AddressSanitizer: CHECK failed: sanitizer_win_interception.cpp:143 "(("Failed to replace local function with sanitizer version." && 0)) != (0)" (0x0, 0x0) (tid=28324)
    #0 0x7fff5e20087f  (C:\gits-repo-sept14\PatchIccMAX\Testing\clang_rt.asan_dynamic-x86_64.dll+0x18005087f)
    #1 0x7fff5e1bf613  (C:\gits-repo-sept14\PatchIccMAX\Testing\clang_rt.asan_dynamic-x86_64.dll+0x18000f613)
    #2 0x7fff5e1bea95  (C:\gits-repo-sept14\PatchIccMAX\Testing\clang_rt.asan_dynamic-x86_64.dll+0x18000ea95)
    #3 0x14002ce3c in __sanitizer::override_function(char const *, unsigned __int64) D:\a\_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\sanitizer_common\sanitizer_win_thunk_interception.cpp:29
    #4 0x14002ce0e in __sanitizer::initialize_thunks(int (__cdecl *const *)(void), int (__cdecl *const *)(void)) D:\a\_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\sanitizer_common\sanitizer_win_thunk_interception.cpp:48
    #5 0x14002cdb6 in __sanitizer_thunk_init D:\a\_work\1\s\src\vctools\asan\llvm\compiler-rt\lib\sanitizer_common\sanitizer_win_thunk_interception.cpp:82
    #6 0x7ff80798bfe9  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x18007bfe9)
    #7 0x7ff807938b7e  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x180028b7e)
    #8 0x7ff807939808  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x180029808)
    #9 0x7ff8079eee5c  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800dee5c)
    #10 0x7ff8079daa19  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800caa19)
    #11 0x7ff8079843c2  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800743c2)
    #12 0x7ff8079842ed  (C:\WINDOWS\SYSTEM32\ntdll.dll+0x1800742ed)
```

## File Details

```
link /dump /dependents C:\gits-repo-sept14\PatchIccMAX\Tools\CmdLine\IccApplyNamedCmm\x64\Debug\iccApplyNamedCmm.exe
Microsoft (R) COFF/PE Dumper Version 14.41.34120.0
File Type: EXECUTABLE IMAGE
  Image has the following dependencies:
    clang_rt.asan_dynamic-x86_64.dll
    KERNEL32.dll
  Summary
        1000 .INTR
        1000 .WEAK
       2D000 .data
       27000 .pdata
       BD000 .rdata
        1000 .rsrc
      4CD000 .text
```

### VS 2022 Enterprise Config
```
 &"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -format json | ConvertFrom-Json
 ...
installationName         : VisualStudio/17.11.3+35303.130
installationPath         : C:\Program Files\Microsoft Visual Studio\2022\Enterprise
installationVersion      : 17.11.35303.130
productId                : Microsoft.VisualStudio.Product.Enterprise
productPath              : C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\devenv.exe
displayName              : Visual Studio Enterprise 2022
...
Microsoft (R) C/C++ Optimizing Compiler Version 19.41.34120 for x64
MSBuild version 17.11.2+c078802d4 for .NET Framework

[System.Environment]::OSVersion.Version

Major  Minor  Build  Revision
-----  -----  -----  --------
10     0      22631  0
```












