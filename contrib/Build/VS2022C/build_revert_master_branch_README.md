# DemoIccMAX Project - Build and Profile Creation for Windows + VS2022C

***tl;dr***

```
cd C:\temp
iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/VS2022C/build_revert_master_branch.ps1").Content
```

## Overview
This script automates the setup, build, and testing process for the **DemoIccMAX** project using **Visual Studio 2022 Community Edition** and **vcpkg** to manage dependencies. The instructions below outline the full process from setting up the development environment on a Windows VM to building and testing the project executables.

## Prerequisites
Before you begin, ensure the following are installed:
- Windows 10/11 (64-bit recommended)
- Visual Studio 2022 Community Edition (with C++ Development Workload)
- PowerShell (for script execution)
- Git (for version control)
- vcpkg (package manager for dependencies)

## Build and Test Workflow

### Step 1: Set up the Environment and Clone Repositories
1. Start by cloning the `vcpkg` repository and bootstrapping it. This package manager will install the necessary libraries:
    ```pwsh
    $optDir = "C:\test"
    cd $optDir
    git clone https://github.com/microsoft/vcpkg.git
    cd vcpkg
    .\bootstrap-vcpkg.bat
    ```

2. Integrate `vcpkg` into the system to manage the project’s dependencies:
    ```pwsh
    .\vcpkg.exe integrate install
    ```

3. Install the required dependencies:
    ```pwsh
    .\vcpkg.exe install libxml2:x64-windows tiff:x64-windows wxwidgets:x64-windows-static
    ```

4. Clone the **DemoIccMAX** repository:
    ```pwsh
    cd $optDir
    git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
    ```

### Step 2: Build the Project

1. Revert to the stable master branch for the build and make necessary patches to fix library links and project configs:
    ```pwsh
    cd C:\test\DemoIccMAX
    git revert --no-edit b90ac3933da99179df26351c39d8d9d706ac1cc6
    ```

2. Begin selective building of project files using MSBuild:
    ```pwsh
    msbuild /m /maxcpucount "C:\test\DemoIccMAX\IccXML\IccLibXML\IccLibXML_v22.vcxproj" /p:Configuration=Debug /p:Platform=x64
    ```

3. Continue building remaining `.vcxproj` files as required for different components of the DemoIccMAX project.

### Step 3: Running Executable Files
1. After building, you can run the generated executables to test the project:
    ```pwsh
    Get-ChildItem -Path "." -Recurse -Filter *.exe | ForEach-Object { Write-Host "Running: $($_.FullName)"; & $_.FullName }
    ```

### Step 4: Profile Creation and Testing
1. The script automates profile creation using a remote batch file:
    ```pwsh
    $tempFile = "$env:TEMP\CreateAllProfiles.bat"
    iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.bat" -OutFile $tempFile
    Start-Process $tempFile -Wait
    ```

2. After execution, all profiles will be created and verified.

### Conclusion
Once the build is complete, and all profiles are tested, the development environment for **DemoIccMAX** is fully set up and ready for use. The script process automates environment setup, dependency installation, and project compilation.

For any further details or troubleshooting, please consult the project’s documentation or reach out to the project maintainers.

---

**Author**: David Hoyt  
**Last Updated**: 30-Sept-2024
