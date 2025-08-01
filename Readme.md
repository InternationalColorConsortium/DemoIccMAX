# iccDEV WASM Build
[![WASM](https://github.com/xsscx/PatchIccMAX/actions/workflows/wasm.yaml/badge.svg)](https://github.com/xsscx/PatchIccMAX/actions/workflows/wasm.yaml)

**Last Updated** 02-AUGUST-2025 at 1500Z by David Hoyt

**TL;DR**

The WebAssembly build (iccWASM) wraps the iccDEV Command Line Tools in JavaScript enabling color profile development using modern web browsers. 

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/wasm/wasm_remote_build.sh)"
```

**INTENT:** This Branch `wasm` will be used for Runner CICD & [Build Outputs for .js & .wasm files](https://github.com/InternationalColorConsortium/DemoIccMAX/releases).

## NPM Lib & Tool Bundle

```
Tools/IccDumpProfile/iccDumpProfile.wasm
Tools/IccDumpProfile/iccDumpProfile.js
Tools/IccFromCube/iccFromCube.js
Tools/IccFromCube/iccFromCube.wasm
Tools/IccApplyToLink/iccApplyToLink.wasm
Tools/IccApplyToLink/iccApplyToLink.js
Tools/IccApplyProfiles/iccApplyProfiles.js
Tools/IccApplyProfiles/iccApplyProfiles.wasm
Tools/IccJpegDump/iccJpegDump.wasm
Tools/IccJpegDump/iccJpegDump.js
Tools/IccApplyNamedCmm/iccApplyNamedCmm.wasm
Tools/IccApplyNamedCmm/iccApplyNamedCmm.js
Tools/IccFromXml/iccFromXml.js
Tools/IccFromXml/iccFromXml.wasm
Tools/IccSpecSepToTiff/iccSpecSepToTiff.wasm
Tools/IccSpecSepToTiff/iccSpecSepToTiff.js
Tools/IccRoundTrip/iccRoundTrip.wasm
Tools/IccRoundTrip/iccRoundTrip.js
Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp.js
Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp.wasm
Tools/IccToXml/iccToXml.wasm
Tools/IccToXml/iccToXml.js
Tools/IccPngDump/iccPngDump.js
Tools/IccPngDump/iccPngDump.wasm
Tools/IccTiffDump/iccTiffDump.wasm
Tools/IccTiffDump/iccTiffDump.js
IccProfLib/libIccProfLib2.a
IccXML/libIccXML2.a
```

## iccDEV WebAssembly (WASM) Build

### Step 1: Set Up Emscripten SDK

```
cd ~
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
git pull
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
```


### Step 2: Clone iccDEV Repository

```
cd ~
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
git checkout wasm
cd Build
```

### Step 3: Build Dependencies

Create and enter the `third_party` directory:

```
mkdir third_party && cd third_party
```

Build each dependency:

* **zlib**:

  ```
  git clone https://github.com/madler/zlib.git && cd zlib
  emconfigure ./configure --static --prefix=$(pwd)/out
  emmake make -j$(nproc) && emmake make install
  cd ..
  ```

* **libpng**:

  ```
  curl -LO https://download.sourceforge.net/libpng/libpng-1.6.43.tar.gz
  tar -xzf libpng-1.6.43.tar.gz && mv libpng-1.6.43 libpng && cd libpng
  CPPFLAGS="-I$(pwd)/../zlib" LDFLAGS="-L$(pwd)/../zlib/out/lib" emconfigure ./configure --disable-shared --enable-static --prefix=$(pwd)/out
  emmake make -j$(nproc) && emmake make install
  cd ..
  ```

* **libjpeg**:

  ```
  curl -LO https://ijg.org/files/jpegsrc.v9e.tar.gz
  tar -xzf jpegsrc.v9e.tar.gz && mv jpeg-9e libjpeg && cd libjpeg
  emconfigure ./configure --prefix=$(pwd)/out --disable-shared --enable-static
  emmake make -j$(nproc) && emmake make install
  cd ..
  ```

* **libtiff**:

```
git clone https://gitlab.com/libtiff/libtiff.git && cd libtiff
mkdir wasm && cd wasm
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../out \
-DZLIB_INCLUDE_DIR=$(realpath ../../zlib) -DZLIB_LIBRARY=$(realpath ../../zlib/out/lib/libz.a) \
-DJPEG_INCLUDE_DIR=$(realpath ../../libjpeg/out/include) -DJPEG_LIBRARY=$(realpath ../../libjpeg/out/lib/libjpeg.a)
emmake make -j$(nproc) && emmake make install
cd ../..
```

* **libxml2**:

  ```
  git clone https://gitlab.gnome.org/GNOME/libxml2.git && cd libxml2
  emconfigure ./autogen.sh --without-python --disable-shared --enable-static --prefix=$(pwd)/out
  emmake make -j$(nproc) && emmake make install
  cd ..
  ```

* **JSON Headers**:

  ```
  mkdir -p nlohmann/json/include
  curl -L https://github.com/nlohmann/json/releases/latest/download/json.hpp -o nlohmann/json/include/json.hpp
  cd ..
  ```

### Step 4: Configure & Compile iccDEV

```
# Copy the deps to fixup the wasm smoke test
cp -r third_party Cmake

# Now configure for wasm and build
emcmake cmake Cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DENABLE_TOOLS=ON \
  -DENABLE_STATIC_LIBS=ON \
  -DLIBXML2_INCLUDE_DIR=$(pwd)/third_party/libxml2/out/include/libxml2 \
  -DLIBXML2_LIBRARY=$(pwd)/third_party/libxml2/out/lib/libxml2.a \
  -DTIFF_INCLUDE_DIR=$(pwd)/third_party/libtiff/out/include \
  -DTIFF_LIBRARY=$(pwd)/third_party/libtiff/out/lib/libtiff.a \
  -DJPEG_INCLUDE_DIR=$(pwd)/third_party/libjpeg/out/include \
  -DJPEG_LIBRARY=$(pwd)/third_party/libjpeg/out/lib/libjpeg.a \
  -DPNG_INCLUDE_DIR=$(pwd)/third_party/libpng/out/include \
  -DPNG_LIBRARY=$(pwd)/third_party/libpng/out/lib/libpng16.a \
  -DZLIB_INCLUDE_DIR=$(pwd)/third_party/zlib \
  -DZLIB_LIBRARY=$(pwd)/third_party/zlib/out/lib/libz.a \
  -DCMAKE_CXX_FLAGS="\
    -I$(pwd)/third_party/libtiff/out/include \
    -I$(pwd)/third_party/libjpeg/out/include \
    -I$(pwd)/third_party/libpng/out/include \
    -I$(pwd)/third_party/zlib \
    -I$(pwd)/third_party/nlohmann/json/include" \
  -DCMAKE_EXE_LINKER_FLAGS="\
    -s INITIAL_MEMORY=128MB \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s FORCE_FILESYSTEM=1 \
    -s MODULARIZE=1 \
    -s EXPORT_NAME=createModule \
    -s EXPORTED_RUNTIME_METHODS=['FS','callMain']" \
  -Wno-dev

emmake make -j$(nproc)
```

### Step 5: Validate WASM Build

Check WASM format:

```
find IccProfLib/ -name '*.a' -exec sh -c 'for obj in $(ar t "$1" | grep "\.o$"); do ar p "$1" "$obj" > "/tmp/$obj"; command -v wasm-objdump && wasm-objdump -x "/tmp/$obj" | head || echo "wasm-objdump not installed"; done' sh {} \;
```

Compile and test a sample CPP file:

```
em++ test_link.cpp ./IccProfLib/libIccProfLib2.a -o test_link.js \
-s WASM=1 -s EXIT_RUNTIME=1 -s ENVIRONMENT=node \
-I./libxml2/out/include/libxml2 -std=c++17
```

Run validation test:

```
node test_link.js
```

### Expected Output

```
WASM Static Link Test Begin
CalcFactors returned: 0
WASM Static Link Test Passed
```

### Reproduction Log for CmakePreset.json

```
Fri Aug  1 06:09:24 PM UTC 2025
Linux icc 6.8.0-71-generic #71-Ubuntu SMP PREEMPT_DYNAMIC Tue Jul 22 16:52:38 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux

icc@icc:~/pr151/repro6/DemoIccMAX/Build/Cmake$ cmake --preset wasm-release
Preset CMake variables:

  CMAKE_BUILD_TYPE="Release"
  CMAKE_CXX_FLAGS="-I/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/include -I/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libjpeg/out/include -I/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libpng/out/include -I/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/zlib -I/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/nlohmann/json/include"
  CMAKE_EXE_LINKER_FLAGS="-s INITIAL_MEMORY=128MB -s ALLOW_MEMORY_GROWTH=1 -s FORCE_FILESYSTEM=1 -s MODULARIZE=1 -s EXPORT_NAME=createModule -s EXPORTED_RUNTIME_METHODS=['FS','callMain']"
  CMAKE_TOOLCHAIN_FILE="/home/icc/emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake"
  ENABLE_STATIC_LIBS="ON"
  ENABLE_TOOLS="ON"
  JPEG_INCLUDE_DIR="/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libjpeg/out/include"
  JPEG_LIBRARY="/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libjpeg/out/lib/libjpeg.a"
  LIBXML2_INCLUDE_DIR="/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libxml2/out/include/libxml2"
  LIBXML2_LIBRARY="/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libxml2/out/lib/libxml2.a"
  PNG_INCLUDE_DIR="/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libpng/out/include"
  PNG_LIBRARY="/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libpng/out/lib/libpng16.a"
  TIFF_INCLUDE_DIR="/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/include"
  TIFF_LIBRARY="/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/lib/libtiff.a"
  ZLIB_INCLUDE_DIR="/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/zlib"
  ZLIB_LIBRARY="/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/zlib/out/lib/libz.a"

--
-- ############################################################
-- ## Demonstration Implementation for iccMAX color profiles ##
-- ############################################################
-- ## Configuration and Build started at 2025-08-01 18:08:19 ##
--
--
-- === Project Configuration Summary ===
--   Project Name       : RefIccMAX
--   Internal Name (UP) : REFICCMAX
--   Version (Full)     : 2.2.61
--   Version (Short)    : 2.2
--   C++ Standard       : C++17
--   Description        : Demonstration Implementation for iccMAX color profiles.
-- =========================================
--
--
-- ===  Build Environment Diagnostics ===
-- Source Directory       : /home/icc/pr151/repro6/DemoIccMAX/Build/Cmake
-- Project Root Directory : /home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../..
-- System Name            : Emscripten
-- System Version         : 1
-- Processor Architecture : x86
-- Build Host             : icc (icc)
-- MSBuild Path            :
-- =========================================
--
--
-- ### Environment Diagnostics ###
-- PATH Entries:
--   [0] /home/icc/emsdk:/home/icc/emsdk/upstream/emscripten:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
-- CMAKE_PREFIX_PATH        :
-- CMAKE_INSTALL_PREFIX     : /home/icc/emsdk/upstream/emscripten/cache/sysroot
-- CMAKE_MODULE_PATH        : /home/icc/emsdk/upstream/emscripten/cmake/Modules;/home/icc/emsdk/upstream/emscripten/cmake/Modules;/home/icc/emsdk/upstream/emscripten/cmake/Modules;/home/icc/emsdk/upstream/emscripten/cmake/Modules
--
-- ### Compiler & Toolchain Info ###
-- C++ Compiler            : /home/icc/emsdk/upstream/emscripten/em++
-- C++ Compiler ID         : Clang
-- C++ Compiler Version    : 21.0.0
-- C Compiler              : /home/icc/emsdk/upstream/emscripten/emcc
-- C Compiler Version      : 21.0.0
-- Linker                  : /usr/bin/ld
--
-- ### Linux/Unix Specific Details ###
-- System Info            : Linux icc 6.8.0-71-generic #71-Ubuntu SMP PREEMPT_DYNAMIC Tue Jul 22 16:52:38 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
-- C++ Compiler           : /home/icc/emsdk/upstream/emscripten/em++
-- Linker Flags            : -s INITIAL_MEMORY=128MB -s ALLOW_MEMORY_GROWTH=1 -s FORCE_FILESYSTEM=1 -s MODULARIZE=1 -s EXPORT_NAME=createModule -s EXPORTED_RUNTIME_METHODS=['FS','callMain']
--
-- ### Cross-Platform Debugging ###
-- Build Type              : Release
-- Install Prefix          : /home/icc/emsdk/upstream/emscripten/cache/sysroot
-- Build Generator         : Ninja
-- Build Tool              : /usr/bin/ninja
--
-- ### Build Configuration ###
-- Build Type              : Release
-- C++ Standard            : C++17
-- C++ Flags               : -I/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/include -I/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libjpeg/out/include -I/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libpng/out/include -I/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/zlib -I/home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/nlohmann/json/include
-- C Flags                 :
-- Active Config Flags     :
--
-- ### Dependency Summary ###
-- LibXml2                :  (version: )
CMake Warning (dev) at /usr/share/cmake-3.28/Modules/FetchContent.cmake:1331 (message):
  The DOWNLOAD_EXTRACT_TIMESTAMP option was not given and policy CMP0135 is
  not set.  The policy's OLD behavior will be used.  When using a URL
  download, the timestamps of extracted files should preferably be that of
  the time of extraction, otherwise code that depends on the extracted
  contents might not be rebuilt if the URL changes.  The OLD behavior
  preserves the timestamps from the archive instead, but this is usually not
  what you want.  Update your project to the NEW behavior or specify the
  DOWNLOAD_EXTRACT_TIMESTAMP option with a value of true to avoid this
  robustness issue.
Call Stack (most recent call first):
  CMakeLists.txt:320 (FetchContent_Declare)
This warning is for project developers.  Use -Wno-dev to suppress it.

-- Using the multi-header code from /home/icc/pr151/repro6/DemoIccMAX/Build/wasm/_deps/nlohmann_json-src/include/
-- nlohmann_json          :  (version: )
--
-- ### Include Paths ###
-- IccProfLib             : /home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../../IccProfLib
-- IccXML                 : /home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../../IccXML
--
-- ### Link Paths ###
-- IccProfLib             : /home/icc/pr151/repro6/DemoIccMAX/Build/wasm/IccProfLib
-- IccXML                 : /home/icc/pr151/repro6/DemoIccMAX/Build/wasm/IccXML
-- Fallback               : /usr/local/lib
--
-- ### Debug Library Paths ###
-- IccProfLib Debug Path : /home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../../Build/IccProfLib
-- IccXML Debug Path     : /home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../../Build/IccXML
--
-- ### CI/CD Integration ###
--  CI/CD Integration      : Not Detected
--
-- Initializing Install Paths with GNUInstallDirs...
-- GNU Install Include Dir: include
-- GNU Install Library Dir: lib
-- GNU Install CMake Dir  : share/cmake
--
-- ### Build Options ###
-- ENABLE_TESTS               = ON
-- ENABLE_TOOLS               = ON
-- ENABLE_SHARED_LIBS         = ON
-- ENABLE_STATIC_LIBS         = ON
-- ENABLE_ICCXML              = ON
-- ICC_TRACE_NAN_ENABLED      = OFF
-- ICC_CLUT_DEBUG             = OFF
-- ICC_ENABLE_ASSERTS         = OFF
-- ICC_LOG_SAFE               = OFF
-- ENABLE_SANITIZERS          = OFF
-- ENABLE_FUZZING             = OFF
-- ENABLE_SPECTRE_MITIGATION  = OFF
--
--
-- ### Build Context Check ###
-- RefIccMAX is being built as a top-level project.
-- ENABLE_INSTALL_RIM      = ON
--
-- ### Enforcing Default Build Type ###
-- Build type explicitly set to: Release
--
-- ### Initializing Compiler Flags ###
-- Configuring GCC/Clang runtime and flags
-- Detected platform: Linux
-- Linux build: Standard warning flags applied.
-- Adding subdirectory for IccProfLib.
CMake Warning (dev) at IccProfLib/CMakeLists.txt:121 (ADD_LIBRARY):
  ADD_LIBRARY called with SHARED option but the target platform does not
  support dynamic linking.  Building a STATIC library instead.  This may lead
  to problems.
This warning is for project developers.  Use -Wno-dev to suppress it.

-- ICCXML support enabled
-- Found LibXml2 via system or toolchain integration
-- Adding subdirectory for IccXML.
-- Starting CMake debug for target: IccXML2
-- CFILES = ../../../IccXML/IccLibXML/IccIoXml.cpp;../../../IccXML/IccLibXML/IccMpeXml.cpp;../../../IccXML/IccLibXML/IccMpeXmlFactory.cpp;../../../IccXML/IccLibXML/IccProfileXml.cpp;../../../IccXML/IccLibXML/IccTagXml.cpp;../../../IccXML/IccLibXML/IccTagXmlFactory.cpp;../../../IccXML/IccLibXML/IccUtilXml.cpp
-- ENABLE_SHARED_LIBS = ON
-- ENABLE_STATIC_LIBS = ON
-- ENABLE_INSTALL_RIM = ON
-- LIBXML2_LIBRARIES = LibXml2::LibXml2
-- PROJECT_UP_NAME = REFICCMAX
-- EXTRA_LIBS = LibXml2::LibXml2
-- Building SHARED library: IccXML2
CMake Warning (dev) at IccXML/CMakeLists.txt:78 (ADD_LIBRARY):
  ADD_LIBRARY called with SHARED option but the target platform does not
  support dynamic linking.  Building a STATIC library instead.  This may lead
  to problems.
This warning is for project developers.  Use -Wno-dev to suppress it.

-- Installing SHARED library
-- Building STATIC library: IccXML2-static
-- Installing STATIC library
-- Final TARGET_LIB = IccXML2
-- SHARED lib output name: SHARED_OUTPUT_NAME-NOTFOUND
-- SHARED lib output dir: SHARED_OUTPUT_DIR-NOTFOUND
-- SHARED archive dir: SHARED_ARCHIVE_DIR-NOTFOUND
-- CMAKE_EXE_LINKER_FLAGS = -s INITIAL_MEMORY=128MB -s ALLOW_MEMORY_GROWTH=1 -s FORCE_FILESYSTEM=1 -s MODULARIZE=1 -s EXPORT_NAME=createModule -s EXPORTED_RUNTIME_METHODS=['FS','callMain']
-- CMAKE_SHARED_LINKER_FLAGS =
-- CMAKE_MODULE_LINKER_FLAGS =
-- nlohmann_json library found:
-- nlohmann_json library found:
-- Found nlohmann JSON library or target at:
-- Adding Subdirectory IccFromXml.
-- Adding Subdirectory: Tools/IccFromXml...
-- Successfully added Subdirectory: Tools/IccFromXml
-- Adding Subdirectory IccToXml.
-- Adding Subdirectory: Tools/IccToXml...
-- Successfully added Subdirectory: Tools/IccToXml
-- Adding Subdirectory IccDumpProfile.
-- Adding Subdirectory: Tools/IccDumpProfile...
-- Successfully added Subdirectory: Tools/IccDumpProfile
-- Adding Subdirectory IccRoundTrip.
-- Adding Subdirectory: Tools/IccRoundTrip...
-- Successfully added Subdirectory: Tools/IccRoundTrip
-- Adding Subdirectory IccFromCube.
-- Adding Subdirectory: Tools/IccFromCube...
-- Successfully added Subdirectory: Tools/IccFromCube
-- Adding Subdirectory IccV5DspObsToV4Dsp.
-- Adding Subdirectory: Tools/IccV5DspObsToV4Dsp...
-- Successfully added Subdirectory: Tools/IccV5DspObsToV4Dsp
-- Adding Subdirectory IccTiffDump.
-- Adding Subdirectory: Tools/IccTiffDump...
-- Using TIFF_INCLUDE_DIR: /home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/include
-- Linking TIFF_LIBRARY: /home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/lib/libtiff.a
-- Successfully added Subdirectory: Tools/IccTiffDump
-- Adding Subdirectory IccSpecSepToTiff.
-- Adding Subdirectory: Tools/IccSpecSepToTiff...
-- Successfully added Subdirectory: Tools/IccSpecSepToTiff
-- Adding Subdirectory IccApplyProfiles.
-- Adding Subdirectory: Tools/IccApplyProfiles...
-- Linking TIFF_LIBRARY: /home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/lib/libtiff.a
-- Successfully added Subdirectory: Tools/IccApplyProfiles
-- Adding Subdirectory IccApplyToLink.
-- Adding Subdirectory: Tools/IccApplyToLink...
-- Successfully added Subdirectory: Tools/IccApplyToLink
-- Adding Subdirectory IccApplyNamedCmm.
-- Adding Subdirectory: Tools/IccApplyNamedCmm...
-- Linking TIFF_LIBRARY: /home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/lib/libtiff.a
-- Successfully added Subdirectory: Tools/IccApplyNamedCmm
-- Adding Subdirectory IccJpegDump.
-- Adding Subdirectory: Tools/IccJpegDump...
-- Detected Ubuntu version: 24.04
-- PROJECT_ROOT_DIR resolved as: /home/icc/pr151/repro6/DemoIccMAX
-- Added executable target: iccJpegDump
-- Linked with JPEG library: /home/icc/pr151/repro6/DemoIccMAX/Build/Cmake/../third_party/libjpeg/out/lib/libjpeg.a
-- Linked with platform-specific libraries:
-- Successfully added Subdirectory: Tools/IccJpegDump
-- Adding Subdirectory IccPngDump.
-- Adding Subdirectory: Tools/IccPngDump...
-- PROJECT_ROOT_DIR resolved as: /home/icc/pr151/repro6/DemoIccMAX
-- Added executable target: iccPngDump
-- Include directories added for iccPngDump
-- Libraries linked for iccPngDump
-- Successfully added Subdirectory: Tools/IccPngDump
Configured RefIccMAX-Emscripten64-2.2.61
-- Configuring done (0.8s)
-- Generating done (0.0s)
-- Build files have been written to: /home/icc/pr151/repro6/DemoIccMAX/Build/wasm
icc@icc:~/pr151/repro6/DemoIccMAX/Build/Cmake$ cmake --build --preset wasm-release
ninja: no work to do.
icc@icc:~/pr151/repro6/DemoIccMAX/Build/Cmake$
```
