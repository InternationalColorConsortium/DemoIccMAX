# [contrib/](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib)

Last Updated: 01-MAR-2025 0930 EST by David Hoyt | [@h02332](https://x.com/h02332)

The [contrib/](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib) directory provides examples, tools, and scripts for building, testing, and running ICC profile-related functionality across different platforms. It also includes helper scripts and automated workflows designed to streamline the development process for the Community.

## Latest Merge: [PR116](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/116)

### git diff --stat pr115..pr116

```
 IccProfLib/IccTagBasic.cpp                           |  2 +-
 IccXML/IccLibXML/IccTagXml.cpp                       |  2 +-
```

## IccMAX Build Status

| **Build & Platform** | **Windows** | **macOS** | **Linux** |
|----------------------|-------------|-----------|-----------|
| Asan                | ✅          | ✅        | ✅        |
| Scan                | ✅          | ✅        | ✅        |
| Debug               | ✅          | ✅        | ✅        |
| Release             | ✅          | ✅        | ✅        |
 

### Runner Output

- [IccMAX Minimum PR Check](https://github.com/xsscx/PatchIccMAX/actions/runs/13604924810)
- [pr116-win-x86_64-master-static-release binaries](https://github.com/xsscx/PatchIccMAX/actions/runs/13599757332)
- [pr116-win-x86_64-master-static-debug binaries](https://github.com/xsscx/PatchIccMAX/actions/runs/13604509914)
- [pr116-xnu-arm64-master-debug-asan](https://github.com/xsscx/DemoIccMAX/actions/runs/13587344921) macos-latest-debug-x64-asan
- [pr116-xnu-arm64-master-debug-scan report + binaries](https://github.com/xsscx/PatchIccMAX/actions/runs/13605369882)
- [pr116-ubuntu-x86_64-master-release binaries](https://github.com/xsscx/PatchIccMAX/actions/runs/13605335253)
- [pr116-ubuntu-x86_64-master-debug-scan report + binaries](https://github.com/xsscx/DemoIccMAX/actions/runs/13587391416) ubuntu-latest-debug-x64-asan

---

**User:** runner@fv-az787-889  
**Working Directory:** /home/runner/work/DemoIccMAX/DemoIccMAX/DemoIccMAX/Build  
**Command Line:** make -j4  
**Clang Version:** Ubuntu clang version 17.0.6 (9ubuntu1)  
**Date:** Fri Feb 28 11:40:27 2025  

#### Bug Summary

##### **All Bugs:** 62

###### **Logic Errors**
- Assigned value is garbage or undefined: **1**
- Dereference of null pointer: **1**
- Garbage return value: **1**
- Result of operation is garbage or undefined: **4**
- Uninitialized argument value: **3**

###### **Memory Errors**
- Memory leak: **1**
- Use of zero allocated: **1**
- Use-after-free: **3**

###### **Unused Code**
- Dead assignment: **20**
- Dead increment: **3**
- Dead initialization: **22**
- Dead nested assignment: **2**

#### NET Change

##### PR 115 Reproduction

```
export CXX=clang++
cd /tmp
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/115/head:pr-115
git checkout pr-115
cd Build
sudo apt-get install -y libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/
make clean
make -j$(nproc)
cd ../Testing/
ASAN_OPTIONS=alloc_dealloc_mismatch=1:fast_unwind_on_malloc=0:detect_leaks=1 /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)" &> memory-allocation-review.txt
grep -oE '[^ ]+IccTagBasic.cpp:10976' memory-allocation-review.txt | sort | uniq | wc -l
```

###### PR115 alloc-dealloc-mismatch count

```
1
```

##### PR 116 Reproduction

```
export CXX=clang++
cd /tmp
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/116/head:pr-116
git checkout pr-116
cd Build
sudo apt-get install -y libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/
make clean
make -j$(nproc)
cd ../Testing/
ASAN_OPTIONS=alloc_dealloc_mismatch=1:fast_unwind_on_malloc=0:detect_leaks=1 /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)" &> memory-allocation-review.txt
grep -oE '[^ ]+IccTagBasic.cpp' memory-allocation-review.txt | sort | uniq | wc -l
```

###### PR116 alloc-dealloc-mismatch count

```
0
```

#### Next Patch

```
set -
cd CMYK-3DLUTs..
+ ../../Build/Tools/IccFromXml/iccFromXml CMYK-3DLUTs.xml CMYK-3DLUTs.icc
=================================================================
==5005==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x52b00001b04f at pc 0x7fba725a0f3c bp 0x7fff2967b950 sp 0x7fff2967b948
READ of size 1 at 0x52b00001b04f thread T0
    #0 0x7fba725a0f3b in CIccXmlArrayType<unsigned short, (icTagTypeSignature)1969828150>::ParseText(unsigned short*, unsigned int, char const*) /home/xss/tmp/pr116/DemoIccMAX/IccXML/IccLibXML/IccUtilXml.cpp:995:10
    #1 0x7fba725a336a in CIccXmlArrayType<unsigned short, (icTagTypeSignature)1969828150>::ParseTextArrayNum(char const*, unsigned int, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char>>&) /home/xss/tmp/pr116/DemoIccMAX/IccXML/IccLibXML/IccUtilXml.cpp:813:12
    #2 0x7fba723fdf60 in CIccSinglSampledeCurveXml::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char>>&) /home/xss/tmp/pr116/DemoIccMAX/IccXML/IccLibXML/IccMpeXml.cpp:750:19
    #3 0x7fba72409f25 in ParseXmlCurve(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char>>) /home/xss/tmp/pr116/DemoIccMAX/IccXML/IccLibXML/IccMpeXml.cpp:1106:17
    #4 0x7fba7240942b in CIccMpeXmlCurveSet::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char>>&) /home/xss/tmp/pr116/DemoIccMAX/IccXML/IccLibXML/IccMpeXml.cpp:1164:37
    #5 0x7fba72438d9d in CIccMpeXmlCalculator::ParseImport(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char>>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char>>&) /home/xss/tmp/pr116/DemoIccMAX/IccXML/IccLibXML/IccMpeXml.cpp:2582:26
    #6 0x7fba7244cb8f in CIccMpeXmlCalculator::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char>>&) /home/xss/tmp/pr116/DemoIccMAX/IccXML/IccLibXML/IccMpeXml.cpp:3099:8
    #7 0x7fba7252afa5 in CIccTagXmlMultiProcessElement::ParseElement(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char>>&) /home/xss/tmp/pr116/DemoIccMAX/IccXML/IccLibXML/IccTagXml.cpp:4059:20
    #8 0x7fba7252cfe3 in CIccTagXmlMultiProcessElement::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char>>&) /home/xss/tmp/pr116/DemoIccMAX/IccXML/IccLibXML/IccTagXml.cpp:4119:12
    #9 0x7fba724adfc2 in CIccProfileXml::ParseTag(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char>>&) /home/xss/tmp/pr116/DemoIccMAX/IccXML/IccLibXML/IccProfileXml.cpp:711:20
    #10 0x7fba724b2337 in CIccProfileXml::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char>>&) /home/xss/tmp/pr116/DemoIccMAX/IccXML/IccLibXML/IccProfileXml.cpp:820:12
    #11 0x7fba724b2929 in CIccProfileXml::LoadXml(char const*, char const*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char>>*) /home/xss/tmp/pr116/DemoIccMAX/IccXML/IccLibXML/IccProfileXml.cpp:877:13
    #12 0x55f10520ef01 in main /home/xss/tmp/pr116/DemoIccMAX/IccXML/CmdLine/IccFromXml/IccFromXml.cpp:68:18
    #13 0x7fba70d181c9  (/lib/x86_64-linux-gnu/libc.so.6+0x2a1c9) (BuildId: 42c84c92e6f98126b3e2230ebfdead22c235b667)
    #14 0x7fba70d1828a in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x2a28a) (BuildId: 42c84c92e6f98126b3e2230ebfdead22c235b667)
    #15 0x55f105132574 in _start (/home/xss/tmp/pr116/DemoIccMAX/Build/Tools/IccFromXml/iccFromXml+0x2f574) (BuildId: a07488d6f658f6ca4a9784670833c384960b36c8)
...
```

---

### Triples Summary

| **Operating System**       | **Kernel Version**                                | **Architecture**     | **Environment**                       |
|----------------------------|--------------------------------------------------|-----------------------|---------------------------------------|
| macOS                      | Darwin Kernel Version 24.1.0                     | ARM64                | RELEASE_ARM64_T8103                   |
| macOS                      | Darwin Kernel Version 24.1.0                     | x86_64               | RELEASE_X86_64                        |
| WSL2 (Linux)               | 5.15.153.1-microsoft-standard-WSL2               | x86_64               | GNU/Linux                             |
| Microsoft Windows 11 Pro   | 10.0.26100                                       | x86_64               | Visual Studio 17.12.1                 |

---

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

### Test [PR116](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/116) on *ubuntu-latest*

```
export CXX=clang++
cd /tmp
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git fetch origin pull/116/head:pr-116
git checkout pr-116
cd Build
sudo apt-get install -y libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/
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
cd Build
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
git fetch origin pull/116/head:pr-116
git checkout pr-116

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
