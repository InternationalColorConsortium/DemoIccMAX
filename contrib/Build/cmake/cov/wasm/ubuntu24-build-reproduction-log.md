# WASM Build Reproduction

**Last Updated:** 31-JULY-2025 2321Z by David Hoyt


```
icc@icc:~/pr151/repro4/DemoIccMAX/Build/wasm$ date
Thu Jul 31 11:49:11 PM UTC 2025
icc@icc:~/pr151/repro4/DemoIccMAX/Build/wasm$ uname -a
Linux icc 6.8.0-64-generic #67-Ubuntu SMP PREEMPT_DYNAMIC Sun Jun 15 20:23:31 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
icc@icc:~/pr151/repro4/DemoIccMAX/Build/wasm$ cmake --preset wasm-release -B . -S ../Cmake/
Preset CMake variables:

  CMAKE_BUILD_TYPE="Release"
  CMAKE_CXX_FLAGS="-I/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/include -I/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libjpeg/out/include -I/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libpng/out/include -I/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/zlib -I/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/nlohmann/json/include"
  CMAKE_EXE_LINKER_FLAGS="-s INITIAL_MEMORY=128MB -s ALLOW_MEMORY_GROWTH=1 -s FORCE_FILESYSTEM=1 -s MODULARIZE=1 -s EXPORT_NAME=createModule -s EXPORTED_RUNTIME_METHODS=['FS','callMain']"
  CMAKE_TOOLCHAIN_FILE="/home/icc/emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake"
  ENABLE_STATIC_LIBS="ON"
  ENABLE_TOOLS="ON"
  JPEG_INCLUDE_DIR="/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libjpeg/out/include"
  JPEG_LIBRARY="/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libjpeg/out/lib/libjpeg.a"
  LIBXML2_INCLUDE_DIR="/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libxml2/out/include/libxml2"
  LIBXML2_LIBRARY="/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libxml2/out/lib/libxml2.a"
  PNG_INCLUDE_DIR="/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libpng/out/include"
  PNG_LIBRARY="/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libpng/out/lib/libpng16.a"
  TIFF_INCLUDE_DIR="/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/include"
  TIFF_LIBRARY="/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/lib/libtiff.a"
  ZLIB_INCLUDE_DIR="/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/zlib"
  ZLIB_LIBRARY="/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/zlib/out/lib/libz.a"

--
-- ############################################################
-- ## Demonstration Implementation for iccMAX color profiles ##
-- ############################################################
-- ## Configuration and Build started at 2025-07-31 23:49:19 ##
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
-- Source Directory       : /home/icc/pr151/repro4/DemoIccMAX/Build/Cmake
-- Project Root Directory : /home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../..
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
-- System Info            : Linux icc 6.8.0-64-generic #67-Ubuntu SMP PREEMPT_DYNAMIC Sun Jun 15 20:23:31 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
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
-- C++ Flags               : -I/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/include -I/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libjpeg/out/include -I/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libpng/out/include -I/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/zlib -I/home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/nlohmann/json/include
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

-- Using the multi-header code from /home/icc/pr151/repro4/DemoIccMAX/Build/wasm/_deps/nlohmann_json-src/include/
-- nlohmann_json          :  (version: )
--
-- ### Include Paths ###
-- IccProfLib             : /home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../../IccProfLib
-- IccXML                 : /home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../../IccXML
--
-- ### Link Paths ###
-- IccProfLib             : /home/icc/pr151/repro4/DemoIccMAX/Build/wasm/IccProfLib
-- IccXML                 : /home/icc/pr151/repro4/DemoIccMAX/Build/wasm/IccXML
-- Fallback               : /usr/local/lib
--
-- ### Debug Library Paths ###
-- IccProfLib Debug Path : /home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../../Build/IccProfLib
-- IccXML Debug Path     : /home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../../Build/IccXML
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
-- Using TIFF_INCLUDE_DIR: /home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/include
-- Linking TIFF_LIBRARY: /home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/lib/libtiff.a
-- Successfully added Subdirectory: Tools/IccTiffDump
-- Adding Subdirectory IccSpecSepToTiff.
-- Adding Subdirectory: Tools/IccSpecSepToTiff...
-- Successfully added Subdirectory: Tools/IccSpecSepToTiff
-- Adding Subdirectory IccApplyProfiles.
-- Adding Subdirectory: Tools/IccApplyProfiles...
-- Linking TIFF_LIBRARY: /home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/lib/libtiff.a
-- Successfully added Subdirectory: Tools/IccApplyProfiles
-- Adding Subdirectory IccApplyToLink.
-- Adding Subdirectory: Tools/IccApplyToLink...
-- Successfully added Subdirectory: Tools/IccApplyToLink
-- Adding Subdirectory IccApplyNamedCmm.
-- Adding Subdirectory: Tools/IccApplyNamedCmm...
-- Linking TIFF_LIBRARY: /home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libtiff/out/lib/libtiff.a
-- Successfully added Subdirectory: Tools/IccApplyNamedCmm
-- Adding Subdirectory IccJpegDump.
-- Adding Subdirectory: Tools/IccJpegDump...
-- Detected Ubuntu version: 24.04
-- PROJECT_ROOT_DIR resolved as: /home/icc/pr151/repro4/DemoIccMAX
-- Added executable target: iccJpegDump
-- Linked with JPEG library: /home/icc/pr151/repro4/DemoIccMAX/Build/Cmake/../third_party/libjpeg/out/lib/libjpeg.a
-- Linked with platform-specific libraries:
-- Successfully added Subdirectory: Tools/IccJpegDump
-- Adding Subdirectory IccPngDump.
-- Adding Subdirectory: Tools/IccPngDump...
-- PROJECT_ROOT_DIR resolved as: /home/icc/pr151/repro4/DemoIccMAX
-- Added executable target: iccPngDump
-- Include directories added for iccPngDump
-- Libraries linked for iccPngDump
-- Successfully added Subdirectory: Tools/IccPngDump
Configured RefIccMAX-Emscripten64-2.2.61
-- Configuring done (0.9s)
-- Generating done (0.0s)
-- Build files have been written to: /home/icc/pr151/repro4/DemoIccMAX/Build/wasm
icc@icc:~/pr151/repro4/DemoIccMAX/Build/wasm$ cmake --build --preset wasm-release
ninja: no work to do.
icc@icc:~/pr151/repro4/DemoIccMAX/Build/wasm$ find Tools/ -type f \( -name '*.js' -o -name '*.wasm' \)
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
icc@icc:~/pr151/repro4/DemoIccMAX/Build/wasm$
```
