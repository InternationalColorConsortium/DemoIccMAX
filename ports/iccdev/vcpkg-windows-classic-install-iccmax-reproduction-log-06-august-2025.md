# W11 OOB vcpkg install iccdev

## vcpkg classic reproduction

**Thursday, August 7, 2025 7:03:26 AM**

### tl;dr

```
$env:VCPKG_CONCURRENCY = "4"
cd \
mkdir test
cd test
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git checkout vcpkg
Remove-Item vcpkg.json
cd ..
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg integrate install
cd ..
.\vcpkg\vcpkg.exe --classic install iccdev iccdev:x64-windows --overlay-ports=DemoIccMAX\ports --clean-after-build
Get-ChildItem -Recurse -File -Include *.exe,*.dll,*.lib,*.a -Path C:\test\vcpkg | Where-Object { $_.FullName -match 'iccdev' -and $_.FullName -notmatch '\\CMakeFiles\\' -and $_.Name -notmatch '^CMake(C|CXX)CompilerId\.exe$' } | ForEach-Object { $_.FullName }
Get-History
```

### Prerequisites

- Visual Studio 2022 with C++ workload
- Git
- PowerShell or Command Prompt

```
**********************************************************************
** Visual Studio 2022 Developer Command Prompt v17.14.11
** Copyright (c) 2025 Microsoft Corporation
**********************************************************************
[vcvarsall.bat] Environment initialized for: 'x64'

C:\Program Files\Microsoft Visual Studio\2022\Community>          cd \

C:\>          mkdir test

C:\>          cd test

C:\test>          git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
Cloning into 'DemoIccMAX'...
remote: Enumerating objects: 5392, done.
remote: Counting objects: 100% (245/245), done.
remote: Compressing objects: 100% (116/116), done.
remote: Total 5392 (delta 158), reused 139 (delta 127), pack-reused 5147 (from 3)
Receiving objects: 100% (5392/5392), 61.63 MiB | 12.50 MiB/s, done.
Resolving deltas: 100% (3449/3449), done.

C:\test>          cd DemoIccMAX

C:\test\DemoIccMAX>          git checkout vcpkg
branch 'vcpkg' set up to track 'origin/vcpkg'.
Switched to a new branch 'vcpkg'

C:\test\DemoIccMAX>          del vcpkg.json

C:\test\DemoIccMAX>          cd ..

C:\test>          git clone https://github.com/microsoft/vcpkg.git
Cloning into 'vcpkg'...
remote: Enumerating objects: 282272, done.
remote: Counting objects: 100% (556/556), done.
remote: Compressing objects: 100% (340/340), done.
remote: Total 282272 (delta 411), reused 216 (delta 216), pack-reused 281716 (from 5)
Receiving objects: 100% (282272/282272), 87.89 MiB | 12.45 MiB/s, done.
Resolving deltas: 100% (188255/188255), done.
Updating files: 100% (12676/12676), done.

C:\test>          cd vcpkg

C:\test\vcpkg>          .\bootstrap-vcpkg.bat
Downloading https://github.com/microsoft/vcpkg-tool/releases/download/2025-07-21/vcpkg.exe -> C:\test\vcpkg\vcpkg.exe... done.
Validating signature... done.

vcpkg package management program version 2025-07-21-d4b65a2b83ae6c3526acd1c6f3b51aff2a884533

See LICENSE.txt for license information.
Telemetry
---------
vcpkg collects usage data in order to help us improve your experience.
The data collected by Microsoft is anonymous.
You can opt-out of telemetry by re-running the bootstrap-vcpkg script with -disableMetrics,
passing --disable-metrics to vcpkg on the command line,
or by setting the VCPKG_DISABLE_METRICS environment variable.

Read more about vcpkg telemetry at docs/about/privacy.md

C:\test\vcpkg>          .\vcpkg integrate install
Applied user-wide integration for this vcpkg root.
CMake projects should use: "-DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake"

All MSBuild C++ projects can now #include any installed libraries. Linking will be handled automatically. Installing new libraries will make them instantly available.

C:\test\vcpkg>          cd ..

C:\test>          c:\test\vcpkg\vcpkg.exe --classic  install iccdev iccdev:x64-windows --overlay-ports=DemoIccMAX\ports  --clean-after-build
Computing installation plan...
A suitable version of cmake was not found (required v3.30.1).
Downloading https://github.com/Kitware/CMake/releases/download/v3.30.1/cmake-3.30.1-windows-i386.zip -> cmake-3.30.1-windows-i386.zip
Successfully downloaded cmake-3.30.1-windows-i386.zip
Extracting cmake...
A suitable version of 7zip was not found (required v24.9.0).
Downloading https://github.com/ip7z/7zip/releases/download/24.09/7z2409.exe -> 7z2409.7z.exe
Successfully downloaded 7z2409.7z.exe
Extracting 7zip...
A suitable version of 7zr was not found (required v24.9.0).
Downloading https://github.com/ip7z/7zip/releases/download/24.09/7zr.exe -> 44d8504a-7zr.exe
Successfully downloaded 44d8504a-7zr.exe
The following packages will be built and installed:
  * egl-registry:x64-windows@2024-01-25
  * expat:x64-windows@2.7.1
    iccdev:x64-windows@2.2.50 -- C:\test\DemoIccMAX\ports\iccdev
  * libiconv:x64-windows@1.18#1
  * libjpeg-turbo:x64-windows@3.1.1
  * liblzma:x64-windows@5.8.1
  * libpng:x64-windows@1.6.50
  * libwebp[core,libwebpmux,nearlossless,simd,unicode]:x64-windows@1.6.0
  * libxml2[core,iconv,zlib]:x64-windows@2.13.8#1
  * nanosvg:x64-windows@2023-12-29
  * nlohmann-json:x64-windows@3.12.0
  * opengl:x64-windows@2022-12-04#3
  * opengl-registry:x64-windows@2024-02-10#1
  * pcre2[core,jit,platform-default-features]:x64-windows@10.45
  * tiff[core,jpeg,lzma,zip]:x64-windows@4.7.0
  * vcpkg-cmake:x64-windows@2024-04-23
  * vcpkg-cmake-config:x64-windows@2024-05-23
  * wxwidgets[core,debug-support,sound]:x64-windows@3.3.1
  * zlib:x64-windows@1.3.1
Additional packages (*) will be modified to complete this operation.
Detecting compiler hash for triplet x64-windows...
A suitable version of powershell-core was not found (required v7.2.24).
Downloading https://github.com/PowerShell/PowerShell/releases/download/v7.2.24/PowerShell-7.2.24-win-x64.zip -> PowerShell-7.2.24-win-x64.zip
Successfully downloaded PowerShell-7.2.24-win-x64.zip
Extracting powershell-core...
Compiler found: C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/Hostx64/x64/cl.exe
Restored 19 package(s) from C:\Users\User\AppData\Local\vcpkg\archives in 3.3 s. Use --debug to see more details.
Installing 1/19 egl-registry:x64-windows@2024-01-25...
Elapsed time to handle egl-registry:x64-windows: 16.9 ms
egl-registry:x64-windows package ABI: b22e27bb518f12fac93c868d0e0f73033541226b67110b8b0ecfea6cfe8f2546
Installing 2/19 vcpkg-cmake:x64-windows@2024-04-23...
Elapsed time to handle vcpkg-cmake:x64-windows: 7.35 ms
vcpkg-cmake:x64-windows package ABI: 0d207a6a8569a3a9de6c28f2b10b3fc9cd22d6565f3c73f04f080ae91a9d8b03
Installing 3/19 vcpkg-cmake-config:x64-windows@2024-05-23...
Elapsed time to handle vcpkg-cmake-config:x64-windows: 10.2 ms
vcpkg-cmake-config:x64-windows package ABI: 5f32804c7915d7da1cac54b275b93bfa5a14e4895e3f5fe21dc0d05aa769153f
Installing 4/19 expat:x64-windows@2.7.1...
Elapsed time to handle expat:x64-windows: 19.2 ms
expat:x64-windows package ABI: 4bf7a6a46f8644d16a50e6968df4e858c1096fee3dff868d096b65eac083c1f1
Installing 5/19 libiconv:x64-windows@1.18#1...
Elapsed time to handle libiconv:x64-windows: 14.8 ms
libiconv:x64-windows package ABI: ad1f326dd2d661bb18c0a283c46730c8ce058eb65f6e9dcb1f2762d9f782d8c1
Installing 6/19 libjpeg-turbo:x64-windows@3.1.1...
Elapsed time to handle libjpeg-turbo:x64-windows: 26.8 ms
libjpeg-turbo:x64-windows package ABI: 389db3dcd78f478fa020d384791136c1a8533a3ef20f1ced45e6c2093053f759
Installing 7/19 zlib:x64-windows@1.3.1...
Elapsed time to handle zlib:x64-windows: 14.2 ms
zlib:x64-windows package ABI: cbf231c7b08d9a8ca69ccc36900c59745d352c9b9d0077108e2ee69c504290ab
Installing 8/19 libpng:x64-windows@1.6.50...
Elapsed time to handle libpng:x64-windows: 35.9 ms
libpng:x64-windows package ABI: 46e4331b8f67e54a87602756303975dbc48694c22e1dfcd00c48a1c68f4d3f3d
Installing 9/19 libxml2[core,iconv,zlib]:x64-windows@2.13.8#1...
Elapsed time to handle libxml2:x64-windows: 84.3 ms
libxml2:x64-windows package ABI: 7289042ee3d12a0bc6ad488b6f9b36a837c478bc23f309ff2b1ce9947e101282
Installing 10/19 nlohmann-json:x64-windows@3.12.0...
Elapsed time to handle nlohmann-json:x64-windows: 65.4 ms
nlohmann-json:x64-windows package ABI: 6de5ac8945f4765e6bf8f135f7c6cfd93352c96d68cd90e0c5d419f841a30b4c
Installing 11/19 liblzma:x64-windows@5.8.1...
Elapsed time to handle liblzma:x64-windows: 89.7 ms
liblzma:x64-windows package ABI: 482581fd889de6e5e66229f7d2b879b0001af25c39b246219ec3006a6f3e16ff
Installing 12/19 tiff[core,jpeg,lzma,zip]:x64-windows@4.7.0...
Elapsed time to handle tiff:x64-windows: 48 ms
tiff:x64-windows package ABI: 26230f0647ddb21009f4143c601c53ceeda7bdf48e5fb11cc260d0336092f20f
Installing 13/19 libwebp[core,libwebpmux,nearlossless,simd,unicode]:x64-windows@1.6.0...
Elapsed time to handle libwebp:x64-windows: 85.4 ms
libwebp:x64-windows package ABI: 20d62139f81238975eb71e09459041d865f6d439be10bfaf39b7d34674ac6b70
Installing 14/19 nanosvg:x64-windows@2023-12-29...
Elapsed time to handle nanosvg:x64-windows: 28.1 ms
nanosvg:x64-windows package ABI: 1efef547d62fe49ffe0e707203f684d13a843c99b06a1b9720294670e26928c6
Installing 15/19 opengl-registry:x64-windows@2024-02-10#1...
Elapsed time to handle opengl-registry:x64-windows: 39.4 ms
opengl-registry:x64-windows package ABI: f5b7f131c0ca6b43e5346ad569c6a5224a7aea37dc29d34fc64cdddef4ea4044
Installing 16/19 opengl:x64-windows@2022-12-04#3...
Elapsed time to handle opengl:x64-windows: 34.8 ms
opengl:x64-windows package ABI: f89f0ba4a2d6398afe5ad32273867a5cb71e3d4e75bc6cb2c0ea093fe50fcff4
Installing 17/19 pcre2[core,jit,platform-default-features]:x64-windows@10.45...
Elapsed time to handle pcre2:x64-windows: 135 ms
pcre2:x64-windows package ABI: 73412e6e30ba80e1a785ee8488a8f1b40be2014c4a054f99566b5334fc2cde4f
Installing 18/19 wxwidgets[core,debug-support,sound]:x64-windows@3.3.1...
Elapsed time to handle wxwidgets:x64-windows: 518 ms
wxwidgets:x64-windows package ABI: b7f9d9c1cf4a63e26aba9b9d509df1a2adf0090c8db6bc3c78756b41b98056ae
Installing 19/19 iccdev:x64-windows@2.2.50...
Elapsed time to handle iccdev:x64-windows: 52 ms
iccdev:x64-windows package ABI: fa86fafb82bd4d072ab72aa215cb20ced15fdb0c43aeec758a74e48c747b8468
Total install time: 1.3 s
Installed contents are licensed to you by owners. Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
Some packages did not declare an SPDX license. Check the `copyright` file for each package for more information about their licensing.
Packages installed in this vcpkg installation declare the following licenses:
BSD-3-Clause
LGPL-2.0-or-later WITH WxWindows-exception-3.1
MIT
Zlib
libpng-2.0
libtiff
All requested installations completed successfully in: 1.3 s

PS C:\test> Get-ChildItem -Recurse -File -Include *.exe,*.dll,*.lib,*.a -Path C:\test\vcpkg | Where-Object { $_.FullName -match 'iccdev' -and $_.FullName -notmatch '\\CMakeFiles\\' -and $_.Name -notmatch '^CMake(C|CXX)CompilerId\.exe$' } | ForEach-Object { $_.FullName }
C:\test\vcpkg\installed\x64-windows\tools\iccdev\iccApplyToLink.exe
C:\test\vcpkg\installed\x64-windows\tools\iccdev\iccDumpProfile.exe
C:\test\vcpkg\installed\x64-windows\tools\iccdev\iccFromCube.exe
C:\test\vcpkg\installed\x64-windows\tools\iccdev\iccFromXml.exe
C:\test\vcpkg\installed\x64-windows\tools\iccdev\iccRoundTrip.exe
C:\test\vcpkg\installed\x64-windows\tools\iccdev\iccToXml.exe
C:\test\vcpkg\installed\x64-windows\tools\iccdev\iccV5DspObsToV4Dsp.exe
C:\test\vcpkg\installed\x64-windows\tools\iccdev\iconv-2.dll
C:\test\vcpkg\installed\x64-windows\tools\iccdev\libxml2.dll
C:\test\vcpkg\installed\x64-windows\tools\iccdev\zlib1.dll
PS C:\test> Get-ChildItem -Path "C:\test\vcpkg\installed\x64-windows\tools\iccdev" -Filter *.exe | ForEach-Object { Write-Host "== Testing $($_.Name) =="; & $_.FullName --help 2>&1 | Select-Object -First 20; ""; }
== Testing iccApplyToLink.exe ==
iccApplyToLink built with IccProfLib version 2.2.61

Usage: iccApplyToLink dst_link_file link_type lut_size option title range_min range_max first_transform interp {{-ENV:sig value} profile_file_path rendering_intent {-PCC connection_conditions_path}}

  dst_link_file is path of file to create

  For link_type:
    0 - Device Link
    1 - .cube text file

  Where lut_size represents the number of grid entries for each lut dimension.

  For option when link_type is 0:
    option represents the digits of precision for lut for .cube files
  For option when link_type is 1:
    0 - version 4 profile with 16-bit table
    1 - version 5 profile

  title is the title/description for the dest_link_file


== Testing iccDumpProfile.exe ==
Built with IccProfLib version 2.2.61


== Testing iccFromCube.exe ==
Usage: iccFromCube cube_file output_icc_file
Built with IccProfLib version 2.2.61

== Testing iccFromXml.exe ==
IccFromXml built with IccProfLib Version 2.2.61, IccLibXML Version 2.2.61

Usage: IccFromXml xml_file saved_profile_file {-noid -v{=[relax_ng_schema_file - optional]}}

== Testing iccRoundTrip.exe ==
Unable to perform round trip on '--help'

== Testing iccToXml.exe ==
IccToXml built with IccProfLib Version 2.2.61, IccLibXML Version 2.2.61

Usage: IccToXml src_icc_profile dest_xml_file

== Testing iccV5DspObsToV4Dsp.exe ==
Usage: iccV5DspObsToV4Dsp v5DspIccPath v5ObsPcc v4DspIccPath
Built with IccProfLib version 2.2.61
```

## vcpkg package install info

```
PS C:\tmp> Get-ChildItem -Path .\vcpkg\installed\x64-windows\ -Recurse |
>> Where-Object { $_.FullName -match 'iccdev' } |
>> Select-Object FullName, Length, LastWriteTime

FullName                                                               Length  LastWriteTime
--------                                                               ------  -------------
C:\tmp\vcpkg\installed\x64-windows\share\iccdev                                8/7/2025 11:09:49 AM
C:\tmp\vcpkg\installed\x64-windows\share\iccdev\copyright              1986    8/4/2025 10:09:15 AM
C:\tmp\vcpkg\installed\x64-windows\share\iccdev\RefIccMAXConfig.cmake  1776    8/7/2025 11:09:48 AM
C:\tmp\vcpkg\installed\x64-windows\share\iccdev\vcpkg.spdx.json        9247    8/7/2025 11:09:48 AM
C:\tmp\vcpkg\installed\x64-windows\share\iccdev\vcpkg_abi_info.txt     2125    8/7/2025 11:09:14 AM
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev                                8/7/2025 11:09:49 AM
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccApplyToLink.exe     702464  8/7/2025 11:09:38 AM
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccDumpProfile.exe     584704  8/7/2025 11:09:37 AM
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccFromCube.exe        589824  8/7/2025 11:09:37 AM
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccFromXml.exe         990720  8/7/2025 11:09:38 AM
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccRoundTrip.exe       681984  8/7/2025 11:09:37 AM
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccToXml.exe           975872  8/7/2025 11:09:38 AM
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccV5DspObsToV4Dsp.exe 586240  8/7/2025 11:09:38 AM
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iconv-2.dll            1089024 8/6/2025 5:42:00 PM
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\libxml2.dll            1267712 8/6/2025 5:43:08 PM
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\zlib1.dll              90112   8/6/2025 5:42:41 PM


PS C:\tmp> Write-Host '=== Installed Files:'
=== Installed Files:
PS C:\tmp> Get-ChildItem .\vcpkg\installed\x64-windows\ -Recurse | Where-Object FullName -match 'iccdev' | ForEach-Object FullName
C:\tmp\vcpkg\installed\x64-windows\share\iccdev
C:\tmp\vcpkg\installed\x64-windows\share\iccdev\copyright
C:\tmp\vcpkg\installed\x64-windows\share\iccdev\RefIccMAXConfig.cmake
C:\tmp\vcpkg\installed\x64-windows\share\iccdev\vcpkg.spdx.json
C:\tmp\vcpkg\installed\x64-windows\share\iccdev\vcpkg_abi_info.txt
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccApplyToLink.exe
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccDumpProfile.exe
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccFromCube.exe
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccFromXml.exe
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccRoundTrip.exe
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccToXml.exe
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iccV5DspObsToV4Dsp.exe
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\iconv-2.dll
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\libxml2.dll
C:\tmp\vcpkg\installed\x64-windows\tools\iccdev\zlib1.dll
PS C:\tmp> Write-Host "`n=== Package Status:"

=== Package Status:
PS C:\tmp> Select-String -Path .\vcpkg\installed\vcpkg\status -Pattern '^Package: iccdev' -Context 0,10

> vcpkg\installed\vcpkg\status:266:Package: iccdev
  vcpkg\installed\vcpkg\status:267:Version: 2.2.50
  vcpkg\installed\vcpkg\status:268:Depends: libiconv, libjpeg-turbo, libpng, libxml2, nlohmann-json, tiff, vcpkg-cmake, vcpkg-cmake-config, wxwidgets
  vcpkg\installed\vcpkg\status:269:Architecture: x64-windows
  vcpkg\installed\vcpkg\status:270:Multi-Arch: same
  vcpkg\installed\vcpkg\status:271:Abi: 34bacb72df4cff70361c1b3503bf5070a858051afcf81ce5f390a13c40aef89b
  vcpkg\installed\vcpkg\status:272:Description: Developer tools for ICC color profiles
  vcpkg\installed\vcpkg\status:273:Status: install ok installed
  vcpkg\installed\vcpkg\status:274:

```

