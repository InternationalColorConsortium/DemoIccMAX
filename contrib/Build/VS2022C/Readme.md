
# Visual Studio 2022 Community

## Overview

This directory contains build scripts and documentation for building the DemoIccMAX Project in windows using Visual Studio 2022 Community.

## Key Features

- **No Experience Required**: Compiles out of the box using powershell.

### Prerequisites

- PowerShell 7.x or higher
- Windows 10/11 development environment
- Visual Studio 2022 Community
	- Git for Windows

### Setup

To build and test the project, use the provided PowerShell scripts:
- `build_leaf_projects_release.ps1`: Builds all leaf projects in release mode.
- `build_revert_master_branch.ps1`: Reverts changes to the master branch if needed.

### Example Commands

- **Build the master branch of the project**:

	- Powershell

   ```
   cd C:\temp
   iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/VS2022C/build_revert_master_branch.ps1").Content
   ```

- **Diagnostic build of master branch**:

	- Powershell
	
   ```
   cd $$PROJECT_ROOT$$/
   iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/VS2022C/build_diagnostics.ps1").Content
   ```


- **Create ICC profiles after build**:

	- Powershell

   ```
   cd Testing/
   $tempFile = "$env:TEMP\CreateAllProfiles.bat"; iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.bat" -OutFile $tempFile; & $tempFile; Remove-Item $tempFile
   ```

## Contributing

1. Fork the repository.
2. Create a new feature branch (`git checkout -b feature/my-feature`).
3. Commit your changes (`git commit -am 'Add my feature'`).
4. Push to the branch (`git push origin feature/my-feature`).
5. Create a pull request.

