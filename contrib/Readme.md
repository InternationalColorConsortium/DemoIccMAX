# [contrib/](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib)

Last Updated: 30-Oct-2024 by David Hoyt | [@h02332](https://x.com/h02332)

**Data** is ***Code***

The [contrib/](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib) directory provides examples, tools, and scripts for building, testing, and running ICC profile-related functionality across different platforms. It also includes helper scripts and automated workflows designed to streamline the development process for the Community.

# Automated Builds

The Project can be built automatically. Copy the command below and Paste into your Terminal to start the Build.

## Build via CMake

   ```bash
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/build_master_branch.sh)"
   ```

### Xcode Build

   ```bash
   cd Build/Xcode
   /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/Build/XCode/xnu_build_macos15_x86_64.zsh)"
   ```

## MSBuild on Windows using VS2022

   ```powershell
   iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/VS2022C/build.ps1").Content
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
