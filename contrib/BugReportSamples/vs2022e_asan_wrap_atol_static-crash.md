# VS2022E | ASAN Crash on Windows

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












