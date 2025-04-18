
# Build Master Branch

## Overview
This Remote Script will build the master branch. 

## Usage
To use this script, open a Terminal and execute the following command:
 
`sh`
 
```
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/build_master_branch.sh)"
```

## Expected Output

```
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -Wno-dev Cmake/

-- ##########################################################################
-- ## Starting to Configure the DemoIccMAX Project at 2024-11-24 14:26:36
-- ##########################################################################
-- The C compiler identification is GNU 13.2.0
-- The CXX compiler identification is GNU 13.2.0
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /usr/bin/cc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- ### System Information ###
-- CMAKE_SOURCE_DIR: DemoIccMAX/Build/Cmake
-- PROJECT_ROOT_DIR is resolved as: DemoIccMAX/Build/Cmake/../..
-- System Name: Linux
-- System Version: 5.15.153.1-microsoft-standard-WSL2
-- System Processor: x86_64
--
-- ### Compiler Information ###
-- C++ Compiler: /usr/bin/c++
-- C++ Compiler Version: 13.2.0
-- C Compiler: /usr/bin/cc
-- C Compiler Version: 13.2.0
-- Linker: /usr/bin/ld
--
-- ### Build Configuration ###
-- Build Type: Debug
-- C++ Standard: 17
-- C++ Flags: -g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall
-- C Flags:
--
-- Enable Tools:
-- Enable Tests:
-- Enable Shared Libraries:
-- Enable Static Libraries:
--
-- ### Dependencies ###
-- Found LibXml2: /usr/lib/x86_64-linux-gnu/libxml2.so (found version "2.9.14")
-- Found nlohmann_json: /usr/share/cmake/nlohmann_json/nlohmann_jsonConfig.cmake (found version "3.11.3")
-- Found TIFF: /usr/lib/x86_64-linux-gnu/libtiff.so (found version "4.5.1")
-- LibXml2: /usr/lib/x86_64-linux-gnu/libxml2.so (found version )
-- nlohmann_json: /usr/share/cmake/nlohmann_json (found version 3.11.3)
-- TIFF: /usr/lib/x86_64-linux-gnu/libtiff.so (found version )
-- TIFF Include Directory: /usr/include/x86_64-linux-gnu
--
-- ### Include Directories ###
-- IccProfLib: DemoIccMAX/Build/Cmake/../../IccProfLib
-- IccXML: DemoIccMAX/Build/Cmake/../../IccXML
--
-- ### Link Directories ###
-- IccProfLib: DemoIccMAX/Build/IccProfLib
-- IccXML: DemoIccMAX/Build/IccXML
-- /usr/local/lib
--
-- Library Path for IccProfLib: DemoIccMAX/Build/Cmake/../../Build/IccProfLib
-- Library Path for IccXML: DemoIccMAX/Build/Cmake/../../Build/IccXML
--
-- Configuring build for Linux.
-- Info: Debug build "Debug"
-- Sanitizers enabled for Debug build.
-- nlohmann_json library found: /usr/share/cmake/nlohmann_json
-- Found nlohmann JSON library at: /usr/share/cmake/nlohmann_json
-- Adding IccApplyNamedCmm from: DemoIccMAX/Build/Cmake/../../Tools/CmdLine/IccApplyNamedCmm
-- Non-macOS platform detected. Skipping macOS-specific configurations.
-- Include Directories:
-- IccProfLib: DemoIccMAX/Build/Cmake/../../../IccProfLib
-- IccXML: DemoIccMAX/Build/Cmake/../../../IccXML
-- Link Directories:
-- IccProfLib: DemoIccMAX/Build/Cmake/../../../Build/IccProfLib
-- IccXML: DemoIccMAX/Build/Cmake/../../../Build/IccXML
-- Added IccApplyNamedCmm
-- Adding IccApplyProfiles from: DemoIccMAX/Build/Cmake/../../Tools/CmdLine/IccApplyProfiles
-- nlohmann_json library found: /usr/share/cmake/nlohmann_json
-- TIFF library found: /usr/lib/x86_64-linux-gnu/libtiff.so
-- Build Configuration Complete for iccApplyProfiles
-- Added IccApplyProfiles
-- TIFF library found: /usr/lib/x86_64-linux-gnu/libtiff.so
-- Found wxWidgets: -L/usr/lib/x86_64-linux-gnu;-pthread;;;-lwx_gtk3u_core-3.2;-lwx_baseu-3.2 (found version "3.2.4")
-- wxWidgets found and configured
Configured RefIccMAX-Linux64-2.1.25
-- Configuring done (44.0s)
-- Generating done (0.2s)
-- Build files have been written to: DemoIccMAX/Build

make -j$(nproc) >/dev/null 2>&1 || { echo "Error: Build failed. Exiting."; exit 1; }

find . -type f \( \( -perm -111 \) -o -name "*.a" -o -name "*.so" -o -name "*.dylib" \) -mmin -1440 ! -path "*/.git/*" ! -path "*/CMakeFiles/*" ! -name "*.sh" -exec ls -lh {} \;

./IccXML/libIccXML2-static.a
./IccXML/libIccXML2.so.2.1.25
./IccProfLib/libIccProfLib2-static.a
./IccProfLib/libIccProfLib2.so.2.1.25
./Tools/wxProfileDump/iccDumpProfileGui
./Tools/IccTiffDump/iccTiffDump
./Tools/IccToXml/iccToXml
./Tools/IccRoundTrip/iccRoundTrip
./Tools/IccSpecSepToTiff/iccSpecSepToTiff
./Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm
./Tools/CmdLine/IccApplyProfiles_Build/iccApplyProfiles
./Tools/IccDumpProfile/iccDumpProfile
./Tools/IccFromXml/iccFromXml

[2024-11-24 14:27:56 ~/DemoIccMAX/Build]% 
```
