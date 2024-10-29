
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

### Dependencies Installation
The script automatically installs the following dependencies using Homebrew:
- `curl`
- `git`
- `cmake`
- `clang`
- `wxmac`
- `libxml2`
- `libtiff`

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

### 4. Reverting a Commit
It reverts a specific bad commit (`6ac1cc6`) in the repository.

### 5. Installing Dependencies
The necessary packages for building the project are installed using Homebrew.

### 6. Building the Project
The build process involves the following steps:
- **CMake Configuration**: Configures the project build with debugging options and sanitizers enabled.
- **Make Build**: Runs the `make` command using all available CPU cores.

### 7. Listing Built Files
After a successful build, the script lists all executable files, libraries (`.a`, `.so`, `.dylib`), and any files created within the last 24 hours.

### 8. Testing and Profile Creation
The script moves into the `Testing` directory and runs a provided script to create ICC profiles for testing purposes using a remote script fetched from the project's repository.

### 9. Elapsed Time Calculation
The script calculates and prints the total time taken for the entire build process.

## How to Use

### Step 1: Clone and Run
Clone the repository that contains this script or download it directly.

```bash
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
```

### Step 2: Execute the Script
Make the script executable and run it:

```bash
chmod +x build.sh
./build.sh
```

### Step 3: Follow the Logs
The script logs all its actions to a file with a name format similar to `build_log_YYYY-MM-DD_HH-MM-SS.log`, which is created in the current directory. You can follow along with the real-time logs or refer to the log file after the script completes.

### Step 4: Verify the Build
After the script completes successfully, verify the built files by checking the list printed at the end of the script.

## Error Handling
The script terminates if any command fails, displaying an error message. It checks for errors during:
- Git configuration
- Repository cloning
- Commit reversion
- CMake configuration
- Build process
- Profile creation

Ensure all prerequisites are installed and properly configured before running the script to avoid interruptions.

## Expected Output

```
24.0.0 Darwin Kernel Version 24.0.0: Tue Sep 24 23:36:30 PDT 2024; root:xnu-11215.1.12~1/RELEASE_X86_64 x86_64
...
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/development/contrib/Build/cmake/xnu_build_master_branch.zsh)"
============================================================
 International Color Consortium | DemoIccMAX Project | Copyright 2024. For more information on The International Color Consortium, please see http://color.org/.
 Time: Tue Oct  8 13:22:26 EDT 2024
============================================================
============================================================
 XNU Build Script now running..
 Time: Tue Oct  8 13:22:26 EDT 2024
============================================================
Logfile: build_log_2024-10-08_13-22-26.log
============================================================
 Step 1: Configuring Git user for this session
 Time: Tue Oct  8 13:22:26 EDT 2024
============================================================
Git user configuration done.
============================================================
 Step 2: Cloning DemoIccMAX on master branch
 Time: Tue Oct  8 13:22:26 EDT 2024
============================================================
Cloning into 'DemoIccMAX'...
Repository cloned and switched to DemoIccMAX directory.
============================================================
 Step 3: Reverting a bad commit
 Time: Tue Oct  8 13:22:28 EDT 2024
============================================================
Step 3a: Reverting 6ac1cc6
Auto-merging ChangeLog
Auto-merging IccProfLib/icProfileHeader.h
[master 4549ad4] Revert "Integrate 5.1 changes into Master Branch (#69)"
 Date: Tue Oct 8 13:22:29 2024 -0400
 28 files changed, 554 insertions(+), 3626 deletions(-)
 delete mode 100644 Tools/CmdLine/IccCommon/IccCmmConfig.cpp
 delete mode 100644 Tools/CmdLine/IccCommon/IccCmmConfig.h
 delete mode 100644 Tools/CmdLine/IccCommon/IccJsonUtil.cpp
 delete mode 100644 Tools/CmdLine/IccCommon/IccJsonUtil.h
master branch checked out.
============================================================
 Step 4: Installing Dependencies, you will be prompted for the sudo password to continue...
 Time: Tue Oct  8 13:22:29 EDT 2024
============================================================
Warning: libtiff 4.7.0 is already installed and up-to-date.
To reinstall 4.7.0, run:
  brew reinstall libtiff
Warning: libxml2 2.13.4_1 is already installed and up-to-date.
To reinstall 2.13.4_1, run:
  brew reinstall libxml2
Warning: wxwidgets 3.2.6 is already installed and up-to-date.
To reinstall 3.2.6, run:
  brew reinstall wxwidgets
============================================================
 Step 5: Starting Build....
 Time: Tue Oct  8 13:22:32 EDT 2024
============================================================
============================================================
 Step 5a: configuring cmake
 Time: Tue Oct  8 13:22:32 EDT 2024
============================================================
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
-- Configuring build for X86_64 architecture.
-- Info build "Debug"
-- Found LibXml2: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.0.sdk/usr/lib/libxml2.tbd (found version "2.9.4")
-- Found TIFF: /usr/local/lib/libtiff.dylib (found version "4.7.0")
-- Found wxWidgets: -L/usr/local/lib;;;-framework IOKit;-framework Carbon;-framework Cocoa;-framework QuartzCore;-framework AudioToolbox;-framework System;-framework OpenGL;-lwx_osx_cocoau_core-3.2;-lwx_baseu-3.2 (found version "3.2.6")
Configured RefIccMAX-Darwin64-2.1.17
-- Configuring done (2.8s)
-- Generating done (0.2s)
-- Build files have been written to: /tmp/DemoIccMAX/Build
============================================================
 Step 6: running make
 Time: Tue Oct  8 13:22:35 EDT 2024
============================================================
============================================================
 Built Files:
 Time: Tue Oct  8 13:23:01 EDT 2024
============================================================
./Tools/IccTiffDump/iccTiffDump
./Tools/IccFromXml/iccFromXml
./Tools/IccRoundTrip/iccRoundTrip
./Tools/wxProfileDump/iccDumpProfileGui
./Tools/IccSpecSepToTiff/iccSpecSepToTiff
./Tools/IccToXml/iccToXml
./Tools/IccApplyNamedCmm/iccApplyNamedCmm
./Tools/IccDumpProfile/iccDumpProfile
./Tools/IccApplyProfiles/iccApplyProfiles
./IccXML/libIccXML2-static.a
./IccXML/libIccXML2.2.1.17.dylib
./IccProfLib/libIccProfLib2.2.1.17.dylib
./IccProfLib/libIccProfLib2-static.a
============================================================
 cd Testing/
 Time: Tue Oct  8 13:23:01 EDT 2024
============================================================
============================================================
 Creating Profiles
 Time: Tue Oct  8 13:23:01 EDT 2024
============================================================
Creating Profiles...
cd to CalcTest
cd to HDR
cd to Overprint
cd mcs
cd Testing
==================================================
[2024-10-08 13:23:27] Starting XML to ICC correlation analysis
==================================================
==================================================
[2024-10-08 13:23:27] Identifying non-creations (XML files without corresponding ICC files)
==================================================
Non-creation: ./CMYK-3DLUTs/CMYK-3DLUTs.xml
Non-creation: ./CMYK-3DLUTs/CMYK-3DLUTs2.xml
Non-creation: ./Calc/calcImport.xml
Non-creation: ./Calc/calcVars.xml
Non-creation: ./Overprint/17ChanPart1.xml
Non-creation: ./SpecRef/RefEstimationImport.xml
Non-creation: ./mcs/17ChanWithSpots-MVIS.xml
Non-creation: ./mcs/18ChanWithSpots-MVIS.xml
==================================================
[2024-10-08 13:23:28] Summary Report
==================================================
Total XML files: 144
Total ICC files: 214
Total successful creations (matched XML and ICC): 136
Total non-creation (XML without ICC): 8
==================================================
[2024-10-08 13:23:28] Analysis completed
==================================================
Cross-Check for CreateAllProfiles Done!
============================================================
 XNU Build Project and CreateAllProfiles Done!
 Time: Tue Oct  8 13:23:28 EDT 2024
============================================================
Elapsed Time: 00:01:02
```
