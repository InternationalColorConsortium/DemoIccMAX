## Automated Build from Master Branch

## Building the Project

This repository contains scripts that automate the setup and build process on CMake. Follow the steps below to configure and build the project from the master branch.

### Build Master from Repository

**gnu**: Copy and Paste the Build from Remote Script into your Terminal:

```bash
cd /tmp
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/build_master_branch.sh)"
```

**clang**: Copy and Paste the Build from Remote Script into your Terminal:

```bash
cd /tmp
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/cmake/build_clang_master_branch.sh)"
```

The script performs the following steps:
1. **Git Configuration**: Configures Git for the current session.
2. **Cloning the Repository**: Clones the repository from the master branch.
3. **Reverting a Commit**: Reverts a known bad commit (ID: `6ac1cc6`).
4. **Installing Dependencies**: Prompts for the sudo password to install required dependencies.
5. **Building the Project**: Configures and builds the project using CMake and runs make.
6. **Lists the Build Files**: Lists the Project Binaries

## Expected Output

```
 /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/Build/cmake/build_master_branch.sh)"
============================================================
 International Color Consortium | DemoIccMAX Project | Copyright 2024. For more information on The International Color Consortium, please see http://color.org/.
 Time: Mon Oct  7 13:48:38 EDT 2024
============================================================
============================================================
 Build Script now running..
 Time: Mon Oct  7 13:48:38 EDT 2024
============================================================
Logfile: build_log_2024-10-07_13-48-38.log
============================================================
 Step 1: Configuring Git user for this session
 Time: Mon Oct  7 13:48:38 EDT 2024
============================================================
Git user configuration done.
============================================================
 Step 2: Cloning DemoIccMAX on master branch
 Time: Mon Oct  7 13:48:38 EDT 2024
============================================================
Cloning into 'DemoIccMAX'...
Repository cloned and switched to DemoIccMAX directory.
============================================================
 Step 3: Reverting a bad commit
 Time: Mon Oct  7 13:48:41 EDT 2024
============================================================
Step 3a: Reverting 6ac1cc6
Auto-merging ChangeLog
Auto-merging IccProfLib/icProfileHeader.h
[master 7be6fcf] Revert "Integrate 5.1 changes into Master Branch (#69)"
 Date: Mon Oct 7 13:48:41 2024 -0400
 28 files changed, 793 insertions(+), 3865 deletions(-)
 rewrite Tools/CmdLine/IccApplyNamedCmm/iccApplyNamedCmm.cpp (66%)
 delete mode 100644 Tools/CmdLine/IccCommon/IccCmmConfig.cpp
 delete mode 100644 Tools/CmdLine/IccCommon/IccCmmConfig.h
 delete mode 100644 Tools/CmdLine/IccCommon/IccJsonUtil.cpp
 delete mode 100644 Tools/CmdLine/IccCommon/IccJsonUtil.h
master branch checked out.
============================================================
 Step 4: Installing Dependencies, you will be prompted for the sudo password to continue...
 Time: Mon Oct  7 13:48:41 EDT 2024
============================================================
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
build-essential is already the newest version (12.9ubuntu3).
make is already the newest version (4.3-4.1build1).
clang is already the newest version (1:14.0-55~exp2).
clang-tools is already the newest version (1:14.0-55~exp2).
libwxgtk-media3.0-gtk3-dev is already the newest version (3.0.5.1+dfsg-4).
libwxgtk-webview3.0-gtk3-dev is already the newest version (3.0.5.1+dfsg-4).
libwxgtk3.0-gtk3-dev is already the newest version (3.0.5.1+dfsg-4).
cmake is already the newest version (3.22.1-1ubuntu1.22.04.2).
curl is already the newest version (7.81.0-1ubuntu1.18).
git is already the newest version (1:2.34.1-1ubuntu1.11).
libtiff5 is already the newest version (4.3.0-6ubuntu0.10).
libtiff5-dev is already the newest version (4.3.0-6ubuntu0.10).
libxml2 is already the newest version (2.9.13+dfsg-1ubuntu0.4).
libxml2-dev is already the newest version (2.9.13+dfsg-1ubuntu0.4).
0 upgraded, 0 newly installed, 0 to remove and 7 not upgraded.
============================================================
 Step 5: Starting Build....
 Time: Mon Oct  7 13:48:42 EDT 2024
============================================================
============================================================
 Step 5a: configuring cmake
 Time: Mon Oct  7 13:48:42 EDT 2024
============================================================
-- The C compiler identification is GNU 11.4.0
-- The CXX compiler identification is GNU 11.4.0
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
-- Info build "Debug"
-- Found LibXml2: /usr/lib/x86_64-linux-gnu/libxml2.so (found version "2.9.13")
-- Found TIFF: /usr/lib/x86_64-linux-gnu/libtiff.so (found version "4.3.0")
-- Found wxWidgets: -L/usr/lib/x86_64-linux-gnu;-pthread;;;-lwx_gtk3u_core-3.0;-lwx_baseu-3.0 (found version "3.0.5")
Configured RefIccMAX-Linux64-2.1.17
-- Configuring done
-- Generating done
-- Build files have been written to: /home/xss/tmm/DemoIccMAX/Build
============================================================
 Step 6: running make
 Time: Mon Oct  7 13:48:49 EDT 2024
============================================================
============================================================
 Built Files:
 Time: Mon Oct  7 13:49:13 EDT 2024
============================================================
./IccProfLib/libIccProfLib2-static.a
./IccProfLib/libIccProfLib2.so.2.1.17
./IccXML/libIccXML2-static.a
./IccXML/libIccXML2.so.2.1.17
./Tools/IccDumpProfile/iccDumpProfile
./Tools/wxProfileDump/iccDumpProfileGui
./Tools/IccToXml/iccToXml
./Tools/IccApplyProfiles/iccApplyProfiles
./Tools/IccTiffDump/iccTiffDump
./Tools/IccSpecSepToTiff/iccSpecSepToTiff
./Tools/IccApplyNamedCmm/iccApplyNamedCmm
./Tools/IccFromXml/iccFromXml
./Tools/IccRoundTrip/iccRoundTrip
============================================================
 cd Testing/
 Time: Mon Oct  7 13:49:13 EDT 2024
============================================================
============================================================
 Creating Profiles
 Time: Mon Oct  7 13:49:13 EDT 2024
============================================================
Creating Profiles...
cd to CalcTest
cd to HDR
cd to Overprint
cd mcs
cd Testing
==================================================
[2024-10-07 13:49:30] Starting XML to ICC correlation analysis
==================================================
==================================================
[2024-10-07 13:49:30] Identifying non-creations (XML files without corresponding ICC files)
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
[2024-10-07 13:49:31] Summary Report
==================================================
Total XML files: 144
Total ICC files: 214
Total successful creations (matched XML and ICC): 136
Total non-creation (XML without ICC): 8
==================================================
[2024-10-07 13:49:31] Analysis completed
==================================================
Cross-Check for CreateAllProfiles Done!
============================================================
 Build Project and CreateAllProfiles Done!
 Time: Mon Oct  7 13:49:31 EDT 2024
============================================================
Elapsed Time: 00:00:53
```
