# [contrib/](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib)

Last Updated: 26-FEB-2026 0814 EST by David Hoyt | [@h02332](https://x.com/h02332)

The [contrib/](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib) directory provides examples, tools, and scripts for building, testing, and running ICC profile-related functionality across different platforms. It also includes helper scripts and automated workflows designed to streamline the development process for the Community.

# Latest Merge [PR111](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/111)


- **Added Projects**:
  - `IccFromCube`
  - `IccV5DspObsToV4Dsp`
  - `IccApplyToLink`
- **Updated CMake Build Configurations**:
  - Adjusted cross-platform arguments.
  - Refactored logic for improved compatibility.

### Stats

```
[2024-12-03 12:05:48 ~/tmp/gnu/DemoIccMAX]% git diff --stat master...pr-111
 Build/Cmake/CMakeLists.txt                                | 167 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
 Build/Cmake/RefIccMAXConfig.cmake.in                      |   1 -
 Build/Cmake/Tools/IccApplyToLink/CMakeLists.txt           |  38 +++++++++++++++++++++
 Build/Cmake/Tools/IccFromCube/CMakeLists.txt              |  30 +++++++++++++++++
 Build/Cmake/Tools/IccV5DspObsToV4Dsp/CMakeLists.txt       |  30 +++++++++++++++++
 Build/MSVC/BuildDefs.props                                |   7 ++--
 Tools/CmdLine/IccApplyNamedCmm/CMakeLists.txt             |  34 +++++++++----------
 Tools/CmdLine/IccApplyProfiles/CMakeLists.txt             |  38 +++++++++++----------
 Tools/CmdLine/IccApplyToLink/CMakeLists.txt               |  37 +++++++++++----------
 Tools/CmdLine/IccFromCube/CMakeLists.txt                  |  37 +++++++++++----------
 contrib/BugReportSamples/scan-build_14-sept-24_summary.md |  62 -----------------------------------
 contrib/Build/cmake/Readme.md                             | 345 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------------------
 contrib/Build/cmake/build_clang_master_branch.sh          |   2 +-
 contrib/Build/cmake/build_master_branch.sh                |   2 +-
 contrib/Build/vcpkg/unset_default_triplet.ps1             | 334 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 contrib/Readme.md                                         | 135 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 16 files changed, 602 insertions(+), 697 deletions(-)
```

### Triples Summary

| **Operating System**       | **Kernel Version**                                | **Architecture**     | **Environment**                       |
|----------------------------|--------------------------------------------------|-----------------------|---------------------------------------|
| macOS                      | Darwin Kernel Version 24.1.0                     | ARM64                | RELEASE_ARM64_T8103                   |
| macOS                      | Darwin Kernel Version 24.1.0                     | x86_64               | RELEASE_X86_64                        |
| WSL2 (Linux)               | 5.15.153.1-microsoft-standard-WSL2               | x86_64               | GNU/Linux                             |
| Microsoft Windows 11 Pro   | 10.0.26100                                       | x86_64               | Visual Studio 17.12.1                 |

### PR Preflight Checks
1. Build on Linux, macOS & Windows.
2. Create ICC Profiles.

### Dependencies
- `libwxgtk3.2-dev`: Required for GUI support.
- `nlohmann-json3-dev`: Enables JSON parsing for configuration files.
- `libtiff`: Supports TIFF image manipulation for image processing tools.
- `wxWidgets`: Cross-platform GUI framework for the basic profile viewer.

---

## Build Instructions

PR & Project: Build on Unix & Windows on **arm64** and **x86_64** using **Clang**, **MSVC** and **GNU** C++ with the instructions provided below.

### Test [PR111](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/111) on *ubuntu-latest*

```
export CXX=clang++
cd /tmp
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/111/head:pr-111
git checkout pr-111
cd Build
sudo apt-get install -y libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DENABLE_TOOLS=ON  -Wno-dev Cmake/
make clean
make -j$(nproc)
```

### **Clang** Build 

Copy and Paste into your Terminal:

```
# Set Clang++
export CXX=clang++
# change to /tmp dir
cd /tmp
# Build Project
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/xnu_build_master_branch.zsh)"
# change to ../Testing/ dir
cd ../Testing/
# Build ICC Profiles
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
```

### Expected Output

**Clang Build Tools**

```
[2024-11-27 18:09:24] $ cd Build
$ make
...
[100%] Built target iccToXml
...
+ ../../Build/Tools/IccFromXml/iccFromXml RefIncW.xml RefIncW.icc
Profile parsed and saved correctly
...
Expecting 204 .icc color profiles...
-n ICC file count.. :
     204
...
 Clang Build Project and CreateAllProfiles Done!
```

### Windows **MSVC** Build

Copy and Paste into Powershell:

   ```powershell
   iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/VS2022C/build.ps1").Content
   ```
### Expected Output   

Windows using **MSBuild Build** & **vcpkg** Tools

```
[100%] Built target iccToXml
...
+ ../../Build/Tools/IccFromXml/iccFromXml RefIncW.xml RefIncW.icc
Profile parsed and saved correctly
...
Expecting 204 .icc color profiles...
-n ICC file count.. :
     204
```

### **GNU C++** Build

Manually complete the Clone, Patch & Build process shown below on Ubuntu:

```
## **GNU C++** Build Instructions

### Clone the DemoIccMAX repository and PR111
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/111/head:pr-111
git checkout pr-111

# Apply the GCC Patch from the PatchIccMAX repository
# TODO: Analyze Scoping Issue, Fix Template, Re: GNU C++ Strict Checks vs Clang

# Save the diff as a patch file
cat <<EOF > gnu_cpp_pr111.patch
diff --git a/Tools/CmdLine/IccCommon/IccJsonUtil.cpp b/Tools/CmdLine/IccCommon/IccJsonUtil.cpp
index 78a78cf..fcf0c6a 100644
--- a/Tools/CmdLine/IccCommon/IccJsonUtil.cpp
+++ b/Tools/CmdLine/IccCommon/IccJsonUtil.cpp
@@ -94,7 +94,6 @@ template <typename T>
 }

 // Explicit template instantiations
-template bool jsonToValue<int>(const json&, int&);
 template std::string arrayToJson<icUInt8Number>(icUInt8Number*, int);
 template std::string arrayToJson<icUInt16Number>(icUInt16Number*, int);
 template std::string arrayToJson<icUInt32Number>(icUInt32Number*, int);
EOF

# Apply the patch
git apply gnu_cpp_pr111.patch

# Verify the patch was applied successfully
git status

# Navigate to the Build directory
cd Build

# Install Deps
sudo apt-get install -y wx-common curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential libtiff-tools libtiff-opengl

# Configure the build with CMake
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DENABLE_TOOLS=ON  -Wno-dev Cmake/

# Build the project
make -j$(nproc)

# change to ../Testing/ dir
cd ../Testing/

# Build ICC Profiles
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
```

### Expected Output | Linux DESKTOP 5.15.153.1-microsoft-standard-WSL2

```
[2024-11-27 18:29:09 ~/tmp/DemoIccMAX/Build]% uname -a
Linux DESKTOP 5.15.153.1-microsoft-standard-WSL2 #1 SMP Fri Mar 29 23:14:13 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
[2024-11-27 18:29:19 ~/tmp/tt/DemoIccMAX/Build]% make -j$(nproc)
[ 45%] Built target IccProfLib2-static
...
[100%] Built target iccDumpProfile

[2024-11-27 18:29:25 ~/tmp/DemoIccMAX/Build]% Tools/IccToXml/iccToXml
IccToXml built with IccProfLib Version 2.2.5, IccLibXML Version 2.2.5

[2024-11-27 18:31:15 ~/tmp/tt/DemoIccMAX/Build]% Tools/IccFromXml/iccFromXml
IccFromXml built with IccProfLib Version 2.2.5, IccLibXML Version 2.2.5

...
```

## Reproduction Hosts

```
Darwin Kernel Version 24.1.0: Thu Oct 10 21:05:14 PDT 2024; root:xnu-11215.41.3~2/RELEASE_ARM64_T8103 arm64
Darwin Kernel Version 24.1.0: Thu Oct 10 21:02:27 PDT 2024; root:xnu-11215.41.3~2/RELEASE_X86_64 x86_64
5.15.153.1-microsoft-standard-WSL2 #1 SMP Fri Mar 29 23:14:13 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
Microsoft Windows 11 Pro 10.0.26100 26100 & VisualStudio/17.12.1
```

## Q3/Q4 Bug Report

**Last Updated: 3 December 2024**

| **Category**                               | **Sep 12, 2024** | **Dec 3, 2024** | **Change** | **Comments**                                                                                              | **Priority** |
|--------------------------------------------|------------------|-----------------|------------|-----------------------------------------------------------------------------------------------------------|--------------|
| **All Bugs**                               | 111              | 62              | -49        | Significant reduction in bug count due to active efforts in cleanup and resolution.                       | -            |
| **API**                                    | 5                | 5               | No change  | API misuse remains consistent; attention needed for arguments passed as null.                             | **1**        |
| **Logic Errors**                           |                  |                 |            |                                                                                                           |              |
| Assigned value is garbage or undefined     | 1                | 1               | No change  | The assigned value garbage issue remains consistent across the last two reports.                          | **2**        |
| Called C++ object pointer is null          | 2                | -               | Resolved   | Handling of null pointers improved in the latest report.                                                  | **2**        |
| Dereference of null pointer                | 14               | 1               | -13        | A drastic reduction in null pointer dereference errors, attributed to improved code quality.              | **1**        |
| Garbage return value                       | -                | 1               | +1         | Issue reintroduced, highlighting potential regressions in code maintenance.                               | **4**        |
| Result of operation is garbage or undefined| -                | 4               | +4         | Issues persist and require further attention.                                                             | **4**        |
| Uninitialized argument value               | 3                | 3               | No change  | Uninitialized arguments remain the same as in the last report.                                            | **3**        |
| **Memory Errors**                          |                  |                 |            |                                                                                                           |              |
| Bad deallocator                            | 4                | 4               | No change  | Efforts in memory management stabilize but remain a concern.                                              | **2**        |
| Double free                                | 2                | 2               | No change  | Double free issues remain consistent across all reports.                                                  | **1**        |
| Memory leak                                | 13               | 1               | -12        | Improved handling of memory leaks with some residual issues.                                              | **1**        |
| Use-after-free                             | 9                | 3               | -6         | Reduction in use-after-free instances but requires continued effort.                                      | **1**        |
| Use of zero allocated                      | 1                | 1               | No change  | Issue persists in the latest report.                                                                      | **2**        |
| **Unix API (Memory)**                      |                  |                 |            |                                                                                                           |              |
| Allocator sizeof operand mismatch          | 1                | 1               | No change  | No change, suggesting this edge case issue is still unresolved.                                           | **2**        |
| **Unused Code**                            |                  |                 |            |                                                                                                           |              |
| Dead assignment                            | 30               | 20              | -10        | Dead assignments reduced by a significant margin in the latest efforts.                                   | **4**        |
| Dead increment                             | 4                | 3               | -1         | Slight improvement in addressing dead increments.                                                         | **5**        |
| Dead initialization                        | 21               | 22              | +1         | New cases of dead initialization introduced and require attention.                                        | **4**        |
| Dead nested assignment                     | 1                | 2               | +1         | New dead nested assignment identified in recent code additions.                                           | **5**        |

---

## Summary (Dec 3, 2024):

| **Category**                    | **Bug Type**                                  | **Quantity** | **Priority** |
|---------------------------------|-----------------------------------------------|--------------|--------------|
| **All Bugs**                    | Total Bug Count                               | 62           | -            |
| **API Issues**                  | Argument with 'nonnull' attribute passed null | 5            | **1**        |
| **Logic Errors**                | Assigned value is garbage or undefined        | 1            | **2**        |
|                                 | Dereference of null pointer                   | 1            | **1**        |
|                                 | Garbage return value                          | 1            | **4**        |
|                                 | Result of operation is garbage or undefined   | 4            | **4**        |
|                                 | Uninitialized argument value                  | 3            | **3**        |
| **Memory Errors**               | Bad deallocator                               | 4            | **2**        |
|                                 | Double free                                   | 2            | **1**        |
|                                 | Memory leak                                   | 1            | **1**        |
|                                 | Use of zero allocated                         | 1            | **2**        |
|                                 | Use-after-free                                | 3            | **1**        |
| **Unix API**                    | Allocator sizeof operand mismatch             | 1            | **2**        |
| **Unused Code**                 | Dead assignment                               | 20           | **4**        |
|                                 | Dead increment                                | 3            | **5**        |
|                                 | Dead initialization                           | 22           | **4**        |
|                                 | Dead nested assignment                        | 2            | **5**        |

---

### Insight:
1. **Fixes**:
   - **null pointer dereferences** & **memory leaks**.
   - TODO: **use-after-free** errors & uninitialized values.

2. **Refactor**:
   - Decreased occurrences of dead assignments but new dead initializations introduced.
   - Ongoing efforts at memory handling and code optimization.

3. **Progress**:
   - Total bugs reduced by **49**, indicating improvements in code quality and maintainability.

### TODO
- Refactor Bugs from Scan-build
- General housekeeping.
- Refactor CMakeLists.txt:
  - A logical block opening on line 212 (IF) closes on line 330 (ENDIF) with mismatched arguments.
