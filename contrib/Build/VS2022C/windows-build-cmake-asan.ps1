# ========================== Windows Cmake Asan Build Script ==========================
#
# PowerShell Script for VCPKG Setup, Windows & IccMAX Cmake Asan Build
# Copyright (c) David H Hoyt LLC. All rights reserved.
# 
# Author: David Hoyt
#
# Date: 20-MAR-2025 1104 EDT by David Hoyt
#
#
#
#
#
# iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/VS2022C/windows-build-cmake-asan.ps1").Content
#
#
#
#
#
# ============================================================

# Entry Banner with Timestamp
Write-Host "**********************************************************************" -ForegroundColor Cyan
Write-Host "** IccMAX Build Script with Asan | David H Hoyt LLC 2025" -ForegroundColor Cyan
Write-Host "** Copyright (c) 2025 David H Hoyt LLC  | https://hoyt.net" -ForegroundColor Cyan
Write-Host "**********************************************************************" -ForegroundColor Cyan
Write-Host "[INFO] Script Execution Started: $(Get-Date)" -ForegroundColor Green

# Define log file directory
$LogDir = "C:\test"
if (!(Test-Path -Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

# Define log file
$LogFile = "$LogDir\setup_log_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Function Write-Log {
    param ([string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Timestamp : $Message" | Out-File -Append -FilePath $LogFile
    Write-Host "[LOG] $Message"
}

Write-Log "Script execution initiated."

# Function to Check Command Execution
Function Execute-Command {
    param (
        [string]$Command,
        [string]$ErrorMessage
    )
    try {
        Write-Log "Executing: $Command"
        Invoke-Expression -Command $Command
    } catch {
        Write-Log "ERROR: $ErrorMessage"
        Write-Host "[ERROR] $ErrorMessage" -ForegroundColor Red
    }
}

# Load Visual Studio Environment
Execute-Command "&{Import-Module 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll'; Enter-VsDevShell d5c5a928}" "Failed to load Visual Studio Environment."

# Create and Navigate to Test Directory
Execute-Command "mkdir C:\test\ -Force" "Failed to create test directory."
Execute-Command "cd C:\test\" "Failed to navigate to test directory."

# Clone and Setup VCPKG
Execute-Command "git clone https://github.com/microsoft/vcpkg.git" "Failed to clone VCPKG."
Execute-Command "cd vcpkg" "Failed to navigate to VCPKG directory."
Execute-Command "./bootstrap-vcpkg.bat -disableMetrics" "Failed to bootstrap VCPKG."
Execute-Command "./vcpkg.exe integrate install" "Failed to integrate VCPKG."

# Install Dependencies
$Packages = @("nlohmann-json:x64-windows", "nlohmann-json:x64-windows-static", "libxml2:x64-windows", "tiff:x64-windows", "wxwidgets:x64-windows", "libxml2:x64-windows-static", "tiff:x64-windows-static", "wxwidgets:x64-windows-static")
foreach ($Package in $Packages) {
    Execute-Command "./vcpkg.exe install $Package" "Failed to install package: $Package"
}

# Clone and Build DemoIccMAX
Execute-Command "cd C:\test\" "Failed to navigate to test directory."
Execute-Command "git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git" "Failed to clone DemoIccMAX."
Execute-Command "cd .\DemoIccMAX\Build\Cmake\" "Failed to navigate to build directory."

# CMake Configuration
Execute-Command "cmake -S . -B . -G 'Visual Studio 17 2022' -A x64 -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=C:/test/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_C_FLAGS='/MD /I C:/test/vcpkg/installed/x64-windows/include' -DCMAKE_CXX_FLAGS='/MD /I C:/test/vcpkg/installed/x64-windows/include' -DCMAKE_SHARED_LINKER_FLAGS='/LIBPATH:C:/test/vcpkg/installed/x64-windows/lib' -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON" "CMake configuration failed."

# Build Project
Execute-Command "cmake --build . --config Debug -- /m /maxcpucount:32" "Build failed."

# Copy Libraries for Testing
Execute-Command "copy IccProfLib\Debug\IccProfLib2-static.lib IccProfLib\Debug\IccProfLib2.lib" "Failed to copy IccProfLib."
Execute-Command "copy IccXML\Debug\IccXML2-static.lib IccXML\Debug\IccXML2.lib" "Failed to copy IccXML."
Execute-Command "copy C:\test\vcpkg\installed\x64-windows\bin\*.dll ..\..\Testing\" "Failed to copy DLLs."
Execute-Command "copy 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.43.34808\bin\Hostx64\x64\clang_rt.asan_dynamic-x86_64.dll' ..\..\Testing\" "Failed to copy sanitizer DLL."

# Final Build Step
Execute-Command "cmake --build . --config Debug -- /m /maxcpucount:32" "Final build failed."

# Execute Built Executables
Get-ChildItem -Path "." -Recurse -Filter *.exe | ForEach-Object {
    Write-Log "Running: $($_.FullName)"
    Write-Host "[EXEC] Running: $($_.FullName)"
    & $_.FullName
}

# Exit Banner
Write-Host "[INFO] Script Execution Completed: $(Get-Date)" -ForegroundColor Green
Write-Log "Script execution completed successfully."
