
# DemoIccMAX XNU Build Script for macOS

**tl;dr**

Copy and Paste the folowing Command into your Terminal to Build the DemoIccMAX Project:

   ```
   cd /tmp
   /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/development/contrib/Build/cmake/xnu_build_master_branch.zsh)"
   ```

## Overview
This script automates the build process for the DemoIccMAX project, which is part of the International Color Consortium's (ICC) open-source initiatives. It sets up the development environment, installs dependencies, reverts a specific commit, and builds the project using `cmake` and `make`. It also runs additional profile creation tests using a provided script.

## Prerequisites
Before running the script, ensure the following requirements are met:

- **Operating System**: macOS with Homebrew installed.
- **Required Tools**:
  - `git`
  - `brew`
  - `curl`
  - `cmake`
  - `clang`
  - `wxmac`
  - `libxml2`
  - `libtiff`
  - 'nlohmann-json'

### Dependencies Installation
The script automatically installs the following dependencies using Homebrew:
- `curl`
- `git`
- `cmake`
- `clang`
- `wxmac`
- `libxml2`
- `libtiff`
- 'nlohmann-json'

Ensure Homebrew is installed and functional on your system for smooth execution of this step.

## Script Breakdown
The script performs the following actions:

### 1. Logging Setup
A log file is created to record all stdout and stderr output. The log file name is timestamped for clarity and traceability.

### 2. Git Configuration
The script configures `git` with a predefined user and email (used for GitHub Actions automation):
- User: GitHub Actions
- Email: `github-actions@github.com`

### 3. Cloning the Repository
The script clones the `DemoIccMAX` repository from the master branch into the current working directory.

### 4. Installing Dependencies
The necessary packages for building the project are installed using Homebrew.

### 5. Building the Project
The build process involves the following steps:
- **CMake Configuration**: Configures the project build with debugging options and sanitizers enabled.
- **Make Build**: Runs the `make` command using all available CPU cores.

### 6. Listing Built Files
After a successful build, the script lists all executable files, libraries (`.a`, `.so`, `.dylib`), and any files created within the last 24 hours.

### 7. Testing and Profile Creation
The script moves into the `Testing` directory and runs a provided script to create ICC profiles for testing purposes using a remote script fetched from the project's repository.

### 8. Elapsed Time Calculation
The script calculates and prints the total time taken for the entire build process.

## Expected Output

```
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/scripts/contrib/Build/cmake/xnu_build_master_branch.zsh)"
============================================================
 International Color Consortium | DemoIccMAX Project
 Copyright © 2024 
 For more information on The International Color Consortium, please see http://color.org/.
 Time: Sun Nov 24 07:32:42 EST 2024
============================================================
============================================================
 XNU Build Script now running..
 Time: Sun Nov 24 07:32:42 EST 2024
============================================================
Logfile: build_log_2024-11-24_07-32-41.log
============================================================
 Step 1: Configuring Git user for this session
 Time: Sun Nov 24 07:32:42 EST 2024
============================================================
Git user configuration done.
============================================================
 Step 2: Cloning DemoIccMAX on master branch
 Time: Sun Nov 24 07:32:42 EST 2024
============================================================
Cloning into 'DemoIccMAX'...
Repository cloned and switched to DemoIccMAX directory.
============================================================
 Step 3 Installing Dependencies, you will be prompted for the sudo password to continue...
 Time: Sun Nov 24 07:32:43 EST 2024
============================================================
Warning: nlohmann-json 3.11.3 is already installed and up-to-date.
To reinstall 3.11.3, run:
  brew reinstall nlohmann-json
Warning: libxml2 2.13.5 is already installed and up-to-date.
To reinstall 2.13.5, run:
  brew reinstall libxml2
Warning: wxwidgets 3.2.6 is already installed and up-to-date.
To reinstall 3.2.6, run:
  brew reinstall wxwidgets
Warning: libtiff 4.7.0 is already installed and up-to-date.
To reinstall 4.7.0, run:
  brew reinstall libtiff
============================================================
 Step 4: Starting Build....
 Time: Sun Nov 24 07:32:46 EST 2024
============================================================
============================================================
 Configuring cmake for Debug
 Time: Sun Nov 24 07:32:46 EST 2024
============================================================
-- ##########################################################################
-- ## Starting to Configure the DemoIccMAX Project at 2024-11-24 07:32:46
-- ##########################################################################
-- The C compiler identification is AppleClang 16.0.0.16000026
-- The CXX compiler identification is AppleClang 16.0.0.16000026
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- ### System Information ###
-- CMAKE_SOURCE_DIR: DemoIccMAX/Build/Cmake
-- PROJECT_ROOT_DIR is resolved as: DemoIccMAX/Build/Cmake/../..
-- System Name: Darwin
-- System Version: 24.1.0
-- System Processor: x86_64
--
-- ### Compiler Information ###
-- C++ Compiler: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++
-- C++ Compiler Version: 16.0.0.16000026
-- C Compiler: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc
-- C Compiler Version: 16.0.0.16000026
-- Linker: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld
--
-- macOS SDK Path: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.1.sdk
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
-- Found LibXml2: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.1.sdk/usr/lib/libxml2.tbd (found version "2.9.13")
-- Found nlohmann_json: /usr/local/share/cmake/nlohmann_json/nlohmann_jsonConfig.cmake (found version "3.11.3")
-- Found TIFF: /usr/local/lib/libtiff.dylib (found version "4.7.0")
-- LibXml2: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.1.sdk/usr/lib/libxml2.tbd (found version )
-- nlohmann_json: /usr/local/share/cmake/nlohmann_json (found version 3.11.3)
-- TIFF: /usr/local/lib/libtiff.dylib (found version )
-- TIFF Include Directory: /usr/local/include
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
-- Configuring build for X86_64 architecture.
-- Info build "Debug"
-- TIFF include directory: /usr/local/include
-- TIFF libraries: /usr/local/lib/libtiff.dylib
-- Found nlohmann JSON library at: /usr/local/share/cmake/nlohmann_json
-- Adding IccApplyNamedCmm from: DemoIccMAX/Build/Cmake/../../Tools/CmdLine/IccApplyNamedCmm
-- Added IccApplyNamedCmm
-- Include Directories:
-- IccProfLib: DemoIccMAX/Build/Cmake/../../../IccProfLib
-- IccXML: DemoIccMAX/Build/Cmake/../../../IccXML
-- macOS SDK Path: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.1.sdk
-- Link Directories:
-- IccProfLib: DemoIccMAX/Build/Cmake/../../../Build/IccProfLib
-- IccXML: DemoIccMAX/Build/Cmake/../../../Build/IccXML
-- Adding IccApplyProfiles from: DemoIccMAX/Build/Cmake/../../Tools/CmdLine/IccApplyProfiles
-- Added IccApplyProfiles from: DemoIccMAX/Build/Cmake/../../Tools/CmdLine/IccApplyProfiles
-- TIFF include directory: /usr/local/include
-- TIFF libraries: /usr/local/lib/libtiff.dylib
-- nlohmann_json library found: /usr/local/share/cmake/nlohmann_json
-- Build Configuration:
-- C++ Standard: 17
-- macOS Architecture: x86_64
-- Custom Libraries:
-- IccProfLib: DemoIccMAX/Build/Cmake/../../../Build/IccProfLib
-- IccXML: DemoIccMAX/Build/Cmake/../../../Build/IccXML
-- Found wxWidgets: -L/usr/local/lib;;;-framework IOKit;-framework Carbon;-framework Cocoa;-framework QuartzCore;-framework AudioToolbox;-framework System;-framework OpenGL;-lwx_osx_cocoau_core-3.2;-lwx_baseu-3.2 (found version "3.2.6")
Configured RefIccMAX-Darwin64-2.1.25
--
-- ##########################################################################
-- ## Finished Configuring the DemoIccMAX Project at 2024-11-24 07:32:46
-- ##########################################################################
-- Configuring done (2.5s)
-- Generating done (0.2s)
-- Build files have been written to: DemoIccMAX/Build
============================================================
 Step 5: running make
 Time: Sun Nov 24 07:32:49 EST 2024
============================================================
============================================================
 Built Files:
 Time: Sun Nov 24 07:33:15 EST 2024
============================================================
-rwxr-xr-x  1 xss  staff   4.7M Nov 24 07:33 ./Tools/CmdLine/IccApplyNamedCmm_Build/iccApplyNamedCmm
-rwxr-xr-x  1 xss  staff   4.7M Nov 24 07:33 ./Tools/CmdLine/IccApplyProfiles_Build/iccApplyProfiles
-rwxr-xr-x  1 xss  staff   155K Nov 24 07:33 ./Tools/IccTiffDump/iccTiffDump
-rwxr-xr-x  1 xss  staff    85K Nov 24 07:33 ./Tools/IccFromXml/iccFromXml
-rwxr-xr-x  1 xss  staff    53K Nov 24 07:33 ./Tools/IccRoundTrip/iccRoundTrip
-rwxr-xr-x  1 xss  staff   1.2M Nov 24 07:33 ./Tools/wxProfileDump/iccDumpProfileGui
-rwxr-xr-x  1 xss  staff   164K Nov 24 07:33 ./Tools/IccSpecSepToTiff/iccSpecSepToTiff
-rwxr-xr-x  1 xss  staff    55K Nov 24 07:33 ./Tools/IccToXml/iccToXml
-rwxr-xr-x  1 xss  staff   141K Nov 24 07:33 ./Tools/IccDumpProfile/iccDumpProfile
-rwxr-xr-x  1 xss  staff   4.2M Nov 24 07:33 ./IccXML/libIccXML2.2.1.25.dylib
-rw-r--r--  1 xss  staff    11M Nov 24 07:33 ./IccXML/libIccXML2-static.a
-rw-r--r--  1 xss  staff    28M Nov 24 07:33 ./IccProfLib/libIccProfLib2-static.a
-rwxr-xr-x  1 xss  staff    13M Nov 24 07:33 ./IccProfLib/libIccProfLib2.2.1.25.dylib
============================================================
 cd Testing/
 Time: Sun Nov 24 07:33:16 EST 2024
============================================================
============================================================
 Creating Profiles
 Time: Sun Nov 24 07:33:16 EST 2024
============================================================
International Color Consortium | DemoIccMAX Project | Copyright 2024. For more information on The International Color Consortium, please see http://color.org/.
Running remote script of Testing/CreateAllProfiles.sh Script now running..
../Build/Tools/IccFromXml/iccFromXml
cd Calc..
+ ../../Build/Tools/IccFromXml/iccFromXml CameraModel.xml CameraModel.icc
Profile parsed and saved correctly
...
Expecting 204 .icc color profiles...
-n ICC file count.. :
     204
CreateAllProfiles Done!
============================================================
 XNU Build Project and CreateAllProfiles Done!
 Time: Sun Nov 24 07:33:37 EST 2024
============================================================
Elapsed Time: 00:00:56
```
