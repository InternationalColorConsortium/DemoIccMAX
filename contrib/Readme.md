# 🛠️ [PR119](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/119)

### Runner Status

[![PR119-Latest](https://github.com/xsscx/PatchIccMAX/actions/workflows/PR119-Latest.yaml/badge.svg)](https://github.com/xsscx/PatchIccMAX/actions/workflows/PR119-Latest.yaml)
[![PR119-Scan-Build](https://github.com/xsscx/PatchIccMAX/actions/workflows/pr119-ubuntu-clang-scan.yaml/badge.svg)](https://github.com/xsscx/PatchIccMAX/actions/workflows/pr119-ubuntu-clang-scan.yaml)
[![PR119-Unit-Test](https://github.com/xsscx/PatchIccMAX/actions/workflows/pr119-xnu-debug-asan.yaml/badge.svg)](https://github.com/xsscx/PatchIccMAX/actions/workflows/pr119-xnu-debug-asan.yaml)

**Last Updated:** 26-MAR-2025 at 0900 EDT by David Hoyt

### Triples Testing Summary

| **Operating System**       | **Kernel Version**                                | **Architecture**     | **Environment**                       |
|----------------------------|--------------------------------------------------|-----------------------|---------------------------------------|
| macOS                      | Darwin Kernel Version 24.1.0                     | ARM64                | RELEASE_ARM64_T8103                   |
| macOS                      | Darwin Kernel Version 24.1.0                     | x86_64               | RELEASE_X86_64                        |
| WSL2 (Linux)               | 5.15.153.1-microsoft-standard-WSL2               | x86_64               | GNU/Linux                             |
| Microsoft Windows 11 Pro   | 10.0.26100                                       | x86_64               | Visual Studio 17.12.1                 |

#### PR Preflight Checks
1. Build on Linux, macOS & Windows.
2. Create ICC Profiles.

### Dependencies
- `libpng-dev`: Required for Png Support.
- `libxml2`: Required for XML support.
- `libwxgtk3.2-dev`: Required for GUI support.
- `nlohmann-json3-dev`: Enables JSON parsing for configuration files.
- `libtiff`: Supports TIFF image manipulation for image processing tools.
- `wxWidgets`: Cross-platform GUI framework for the basic profile viewer.

### iccMAX Graph

#### Before
![iccMAX GraphViz](https://xss.cx/2025/03/22/img/iccMAX-graph.svg)

#### After
![iccMAX Target Graph](https://xss.cx/2025/03/24/img/iccMAX_Graph_Latest.png)

#### iccPngDump Tool
![iccPngDump Graph](https://xss.cx/2025/03/24/img/iccPngDump.png)

---

## Git Diff Summary: `master...pr-119`

### Reproduction

```
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/119/head:pr-119
git checkout pr-119
git diff --stat origin/master...
```

#### Expected Output

```
 Build/Cmake/CMakeLists.txt                                    | 667 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------
 Build/Cmake/IccProfLib/CMakeLists.txt                         | 100 +++++++++++++++++---------
 Build/Cmake/IccXML/CMakeLists.txt                             | 123 ++++++++++++++++++++++---------
 Build/Cmake/Tools/DemoIccMAXCmm/CMakeLists.txt                |  87 ++++++++++++++++++++++
 Build/Cmake/Tools/IccPngDump/CMakeLists.txt                   |  70 ++++++++++++++++++
 Build/Cmake/Tools/wxProfileDump/CMakeLists.txt                |  57 ++++++++++++---
 Build/Cmake/vcpkg-toolchain.cmake                             |  61 ++++++++++++++++
 Tools/CmdLine/IccApplyNamedCmm/CMakeLists.txt                 |   1 -
 Tools/CmdLine/IccApplyProfiles/CMakeLists.txt                 |   1 -
 Tools/CmdLine/IccPngDump/Readme.md                            | 139 +++++++++++++++++++++++++++++++++++
 Tools/CmdLine/IccPngDump/iccPngDump.cpp                       | 432 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 contrib/.github/workflows/PR119-Latest.yaml                   | 195 +++++++++++++++++++++++++++++++++++++++++++++++++
 contrib/BugReportSamples/pr119.md                             | 377 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 contrib/Build/VS2022C/build.ps1                               |   6 +-
 contrib/Build/cmake/build_master_branch.sh                    |   8 +--
 contrib/Build/cmake/build_master_branch.zsh                   |   4 +-
 contrib/Build/vcpkg/Readme.md                                 | 138 ++++++++++++++++++++++++-----------
 contrib/CalcTest/check_profiles.zsh                           |  21 +++++-
 contrib/DGML/Readme.md                                        |  64 +++++++++++++++++
 contrib/DGML/iccMAX_Graph.zip                                 | Bin 0 -> 8498644 bytes
 contrib/Readme.md                                             | 533 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------
 contrib/UnitTest/TestCIccTagXmlProfileSequenceId.sh           |   8 +--
 contrib/UnitTest/iccApplyNamedCmm_allocator_mismatch_check.sh |  76 ++++++++++----------
 contrib/UnitTest/iccMAX-cicd-build-checks.md                  |  14 ++++
 contrib/UnitTest/iccMAX-cicd-build-checks.sh                  |  73 +++++++++++++++++++
 contrib/UnitTest/zsh_ubuntu_checks..md                        |  17 +++++
 contrib/UnitTest/zsh_ubuntu_checks.zsh                        | 171 +++++++++++++++++++++++++++++++++++++++++++
 vcpkg.json                                                    |  14 ++++
 28 files changed, 2894 insertions(+), 563 deletions(-)
```

### Reproduction | GNU

```
export CXX=g++
cd /tmp
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/119/head:pr-119
git checkout pr-119
cd Build
sudo apt-get install -y libpng-dev libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" -DCMAKE_BUILD_TYPE=Debug -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON -Wno-dev -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/
make -j$(nproc)
cd ../Testing/
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
```

#### Expected Output

```
find IccProfLib/ IccXML/ Tools/ -type f -executable -exec file {} \; | grep 'ELF' | cut -d: -f1
IccProfLib/libIccProfLib2.so.2.1.25
IccXML/libIccXML2.so.2.1.25
Tools/IccRoundTrip/iccRoundTrip
Tools/IccDumpProfile/iccDumpProfile
Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp
Tools/IccApplyProfiles/iccApplyProfiles
Tools/IccApplyToLink/iccApplyToLink
Tools/IccSpecSepToTiff/iccSpecSepToTiff
Tools/wxProfileDump/iccDumpProfileGui
Tools/IccToXml/iccToXml
Tools/IccApplyNamedCmm/iccApplyNamedCmm
Tools/IccFromXml/iccFromXml
Tools/IccPngDump/iccPngDump
Tools/IccTiffDump/iccTiffDump
Tools/IccFromCube/iccFromCube
```

### Reproduction | Clang

```
export CXX=clang++
cd /tmp
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/119/head:pr-119
git checkout pr-119
cd Build
sudo apt-get install -y libpng-dev libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/
make -j$(nproc)
cd ../Testing/
```

#### Expected Output

```
find IccProfLib/ IccXML/ Tools/ -type f -executable -exec file {} \; | grep 'ELF' | cut -d: -f1
IccProfLib/libIccProfLib2.so.2.1.25
IccXML/libIccXML2.so.2.1.25
Tools/IccRoundTrip/iccRoundTrip
Tools/IccDumpProfile/iccDumpProfile
Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp
Tools/IccApplyProfiles/iccApplyProfiles
Tools/IccApplyToLink/iccApplyToLink
Tools/IccSpecSepToTiff/iccSpecSepToTiff
Tools/wxProfileDump/iccDumpProfileGui
Tools/IccToXml/iccToXml
Tools/IccApplyNamedCmm/iccApplyNamedCmm
Tools/IccFromXml/iccFromXml
Tools/IccPngDump/iccPngDump
Tools/IccTiffDump/iccTiffDump
Tools/IccFromCube/iccFromCube
```

### XNU Clang

```
[2025-03-24 15:50:07] $ cmake --build . --config RelWithDebInfo --

[ 31%] Built target IccProfLib2
[ 62%] Built target IccProfLib2-static
[ 70%] Built target IccXML2
[ 74%] Built target iccApplyNamedCmm
[ 78%] Built target iccApplyProfiles
[ 79%] Built target IccDumpProfile
[ 81%] Built target iccRoundTrip
[ 82%] Built target iccFromCube
[ 84%] Built target iccV5DspObsToV4Dsp
[ 86%] Built target iccApplyToLink
[ 88%] Built target iccPngDump
[ 90%] Built target iccSpecSepToTiff
[ 93%] Built target iccTiffDump
[ 95%] Built target iccFromXml
[ 97%] Built target IccToXml
[100%] Built target iccDumpProfileGui

[2025-03-24 15:51:54] $ find IccProfLib IccXML Tools -type f \( -name '*.dylib' -o -name '*.a' -o -perm +111 \) -exec file {} +

IccProfLib/libIccProfLib2.a:                           current ar archive
IccProfLib/libIccProfLib2.2.1.25.dylib:                Mach-O 64-bit dynamically linked shared library x86_64
IccXML/libIccXML2.2.1.25.dylib:                        Mach-O 64-bit dynamically linked shared library x86_64
Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp:           Mach-O 64-bit executable x86_64
Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm: Mach-O 64-bit executable x86_64
Tools/CmdLine/IccApplyProfiles_Build/iccApplyProfiles: Mach-O 64-bit executable x86_64
Tools/IccTiffDump/iccTiffDump:                         Mach-O 64-bit executable x86_64
Tools/IccFromXml/iccFromXml:                           Mach-O 64-bit executable x86_64
Tools/IccRoundTrip/iccRoundTrip:                       Mach-O 64-bit executable x86_64
Tools/wxProfileDump/iccDumpProfileGui:                 Mach-O 64-bit executable x86_64
Tools/IccSpecSepToTiff/iccSpecSepToTiff:               Mach-O 64-bit executable x86_64
Tools/IccPngDump/iccPngDump:                           Mach-O 64-bit executable x86_64
Tools/IccToXml/IccToXml:                               Mach-O 64-bit executable x86_64
Tools/IccFromCube/iccFromCube:                         Mach-O 64-bit executable x86_64
Tools/IccApplyToLink/iccApplyToLink:                   Mach-O 64-bit executable x86_64
Tools/IccDumpProfile/IccDumpProfile:                   Mach-O 64-bit executable x86_64
```

### Reproduction Windows

#### Prerequisites

- Windows 10/11
- Visual Studio 2022 (with C++ Desktop Development workload)
- PowerShell
- Administrator or Developer command prompt

---

#### Setup: Environment & Dependencies

```
mkdir C:\test\
cd C:\test\
```

### Clone vcpkg and bootstrap

```
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat -disableMetrics
.\vcpkg.exe integrate install
```

#### Install required libraries (both dynamic and static)

```
.\vcpkg.exe install `
  libpng `
  nlohmann-json:x64-windows `
  nlohmann-json:x64-windows-static `
  libxml2:x64-windows `
  libxml2:x64-windows-static `
  tiff:x64-windows `
  tiff:x64-windows-static `
  wxwidgets:x64-windows `
  wxwidgets:x64-windows-static
```

#### Clone and Checkout ICCMAX PR

```
cd C:\test\
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
```

#### Checkout pull request #119

```
git fetch origin pull/119/head:pr-119
git checkout pr-119
```

---

#### Configure & Build Example (Debug)

```
cd Build
mkdir win
cd win

cmake -S ..\Cmake -B . -G "Visual Studio 17 2022" -A x64 `
  -DCMAKE_BUILD_TYPE=Debug `
  -DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake `
  -DCMAKE_C_FLAGS="/MD /Od /Zi /I C:/test/vcpkg/installed/x64-windows/include" `
  -DCMAKE_CXX_FLAGS="/MD /Od /Zi /I C:/test/vcpkg/installed/x64-windows/include" `
  -DCMAKE_SHARED_LINKER_FLAGS="/LIBPATH:C:/test/vcpkg/installed/x64-windows/lib" `
  -DENABLE_TOOLS=ON `
  -DENABLE_SHARED_LIBS=ON `
  -DENABLE_STATIC_LIBS=ON `
  -DENABLE_TESTS=ON `
  -DENABLE_INSTALL_RIM=ON `
  -DENABLE_ICCXML=ON `
  -DENABLE_SPECTRE_MITIGATION=OFF `
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON `
  --graphviz=iccMAX-project.dot

cmake --build . --config Debug -- /m /maxcpucount:32
```

##### Expected Output

```
  IccProfLib2-static.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\IccProfLib\MinSizeRel\IccProfLib2-static.lib
  IccProfLib2.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\IccProfLib\MinSizeRel\IccProfLib2.dll
  Aliasing IccProfLib2-static.lib to IccProfLib2.lib for MSVC compatibility
  iccFromCube.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\IccFromCube\MinSizeRel\iccFromCube.exe
  iccApplyToLink.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\IccApplyToLink\MinSizeRel\iccApplyToLink.exe
  iccPngDump.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\IccPngDump\MinSizeRel\iccPngDump.exe
  IccXML2-static.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\IccXML\MinSizeRel\IccXML2-static.lib
  iccV5DspObsToV4Dsp.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\IccV5DspObsToV4Dsp\MinSizeRel\iccV5DspObsToV4Dsp.exe
  iccDumpProfile.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\IccDumpProfile\MinSizeRel\iccDumpProfile.exe
  iccTiffDump.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\IccTiffDump\MinSizeRel\iccTiffDump.exe
  iccSpecSepToTiff.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\IccSpecSepToTiff\MinSizeRel\iccSpecSepToTiff.exe
  iccRoundTrip.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\IccRoundTrip\MinSizeRel\iccRoundTrip.exe
  Aliasing IccXML2-static.lib to IccXML2.lib for MSVC compatibility
  IccXML2.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\IccXML\MinSizeRel\IccXML2.dll
  iccDumpProfileGui.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\wxProfileDump\MinSizeRel\iccDumpProfileGui.exe
  DemoIccMAXCmm.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\DemoIccMAXCmm\x64\MinSizeRel\DemoIccMAXCmm.dll
  iccFromXml.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\IccFromXml\MinSizeRel\iccFromXml.exe
  iccToXml.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\IccToXml\MinSizeRel\iccToXml.exe
  iccApplyNamedCmm.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\IccApplyNamedCmm\MinSizeRel\iccApplyNamedCmm.exe
  iccApplyProfiles.vcxproj -> F:\pr119\latest\repro\DemoIccMAX\Build\win\stats\DemoIccMAX\Build\m\Tools\IccApplyProfiles\MinSizeRel\iccApplyProfiles.exe
```


```
C:\test\pr119\PatchIccMAX\Build\Cmake\Tools\IccPngDump\Debug\iccPngDump.exe
[INFO] Starting iccPngDump...
Built with IccProfLib version 2.2.5
Built with LibPNG version 1.6.46
Usage: iccPngDump <input.png> [output.icc]
  Extracts the ICC profile from a PNG file.
```

## CMake Build System Updates (Cross-Platform)

PR119 modified the Cmake Build Configurations in the `Build/Cmake/` directory, moving towards a modern cross-platform build system.

#### Updates:

- **Top-Level CMake Configuration**
  - `CMakeLists.txt` enables unified configuration for tools, libraries, and flags.
  - Supports toggles for shared/static linking, ICCXML, and optional RIM inclusion.
  - No need to maintain `.vcxproj` files

- **Tool-Specific Subdirectories**
  - Each tool (e.g., `IccPngDump`, `IccDumpProfile`, `IccToXml`) is configured via `CMakeLists.txt` under `Build/Cmake/Tools/`.
  - Adds modularity, CI targeting, and selective builds.

- **Cross-Platform Toolchain Support**
  - Adds support for Clang, GCC, and MSVC via conditional platform logic.

---

## [Scan Build](https://github.com/xsscx/PatchIccMAX/actions/runs/14046632061)

```
Build - scan-build results
User:        root@Mac-1742852499290.local
Working Directory: /Users/runner/work/PatchIccMAX/PatchIccMAX/DemoIccMAX/Build
Command Line:      make -j3
Clang Version:     Homebrew clang version 17.0.6
Date:              Mon Mar 24 21:48:47 2025

Bug Summary
Bug Type                                      Quantity
------------------------------------------------------
All Bugs                                      65

Logic error
  Assigned value is garbage or undefined       1
  Dereference of null pointer                  1
  Garbage return value                         1
  Result of operation is garbage or undefined  4
  Uninitialized argument value                 3

Memory error
  Memory leak                                  1
  Use of zero allocated                        1
  Use-after-free                               3

Unused code
  Dead assignment                             22
  Dead increment                               4
  Dead initialization                         22
  Dead nested assignment                       2
```
