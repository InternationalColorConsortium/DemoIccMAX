# [contrib/](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib)

Last Updated: 02-DEC-2024 by David Hoyt | [@h02332](https://x.com/h02332)

**Data** is ***Code***

The [contrib/](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib) directory provides examples, tools, and scripts for building, testing, and running ICC profile-related functionality across different platforms. It also includes helper scripts and automated workflows designed to streamline the development process for the Community.

## Build Instructions

The Project code currently compiles on Unix & Windows out of the box using **Clang**, **MSVC** and **GNU** C++ with the instructions provided below.

### **Clang** Build 

Copy and Paste into your Terminal:

```
# Set Clang++
export CXX=clang++
# change to /tmp dir
cd /tmp
# Build Project
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/build_master_branch.zsh)"
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
#### Clone the DemoIccMAX repository
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX

# Clone the PatchIccMAX repository to a directory outside the DemoIccMAX repo
git clone https://github.com/xsscx/PatchIccMAX.git ../PatchIccMAX
cd ../PatchIccMAX
git checkout development
cd -

# Apply the GCC Patch from the PatchIccMAX repository
# TODO: Analyze Scoping Issue, Fix Template, Re: GNU C++ Strict Checks vs Clang
git apply ../PatchIccMAX/contrib/patches/pr109-ubuntu-5.15.153.1-microsoft-standard-WSL2-patch.txt

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
Darwin Kernel Version 24.1.0: Thu Oct 10 21:02:27 PDT 2024; root:xnu-11215.41.3~2/RELEASE_X86_64 x86_64
24.1.0 Darwin Kernel Version 24.1.0: Thu Oct 10 21:05:14 PDT 2024; root:xnu-11215.41.3~2/RELEASE_ARM64_T8103 arm64
5.15.153.1-microsoft-standard-WSL2 #1 SMP Fri Mar 29 23:14:13 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
Microsoft Windows 11 Pro 10.0.26100 26100 & VisualStudio/17.12.1
```

## Automatic Install of DemoIccMAXCmm.dll and Registry Key

To streamline the setup of `DemoIccMAXCmm.dll` and ensure the necessary registry keys are applied, the following PowerShell script automates the entire process. This setup step is required for proper ICC profile color management.

Copy and paste the following commands into your **PowerShell** window:

```powershell
mkdir "C:\Program Files\RefIccMAX"
cd "C:\Program Files\RefIccMAX"
iwr -Uri "https://xss.cx/2024/10/26/signed/DemoIccMAXCmm.dll" -OutFile ".\DemoIccMAXCmm.dll"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/HelperScripts/Install-RefIccMAX.reg" -OutFile "$env:TEMP\Install-RefIccMAX.reg"; Start-Process reg.exe -ArgumentList "import $env:TEMP\Install-RefIccMAX.reg" -Wait; Remove-Item "$env:TEMP\Install-RefIccMAX.reg" -Force
```

## Subdirectories and Files in contrib/

### [Workflows](contrib/.github/workflows)
This directory contains GitHub Actions workflow files used for continuous integration (CI) and code scanning.

- **codeql.yml**: A GitHub Actions workflow for CodeQL code scanning, which helps identify vulnerabilities and errors in the code.
- **macos-self-hosted-example.yml**: An example workflow for building the project using a self-hosted macOS runner.
- **windows-vs2022-vcpkg-example.yml**: An example workflow for building the project on Windows using Visual Studio 2022 and vcpkg.

### [CalcTest](contrib/CalcTest)
The `CalcTest` directory includes shell scripts for performing various calculations and profile checks.

- **calc_test.zsh**: A script for running a set of calculation tests.
- **check_profiles.zsh**: A script for verifying ICC profile compatibility and integrity.
- **test_icc_apply_named_cmm.zsh**: A script for testing the application of named Color Management Modules (CMM) to ICC profiles.

### [Doxygen](contrib/Doxygen)
The `Doxygen` directory contains configuration files for generating project documentation using Doxygen.

- **Doxyfile**: The main configuration file for Doxygen, specifying how the documentation should be generated.
- **README.md**: A readme file providing an overview of how to use Doxygen for generating documentation.

### [HelperScripts](contrib/HelperScripts)
The `HelperScripts` directory contains various helper scripts for building dependencies and running tests.

- **libtiff_build.zsh**: A script for building the libtiff library, which is a dependency for the project.
- **libxml2_build.zsh**: A script for building the libxml2 library, another dependency for the project.
- **test_xmlarray_type.zsh**: A script for testing XML array types.
- **vs2022_build.ps1**: A PowerShell script for building the project using Visual Studio 2022.

### [UnitTest](contrib/UnitTest)
The `UnitTest` directory includes unit test files and related scripts.

- **cve-2023-46602-icFixXml-function-IccTagXml_cpp-line_337-baseline-variant-000.xml**: An XML file related to testing a specific CVE (Common Vulnerabilities and Exposures) issue.
- **cve-2023-46602.icc**: An ICC profile file related to the same CVE issue.
- **cve-2023-46602.zsh**: A shell script for testing the specific CVE issue.
- **TestCIccTagXmlProfileSequenceId.cpp**: A C++ test file for the `CIccTagXmlProfileSequenceId` class.
- **TestParseText.cpp**: A C++ test file for testing text parsing functionality.
