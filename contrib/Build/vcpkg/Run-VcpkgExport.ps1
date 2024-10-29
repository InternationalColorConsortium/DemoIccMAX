# =================================================================================
# Script: Run-VcpkgExport.ps1
# Purpose: Export SDKs and Static Configurations using vcpkg for specified triplets
# Author: David Hoyt
# Origin: International Color Consortium Copyright 2024
# Date: 2024-10-27
# =================================================================================

# Function to ensure directory exists
function Ensure-DirectoryExists {
    param (
        [string]$DirectoryPath
    )

    if (-Not (Test-Path -Path $DirectoryPath)) {
        New-Item -ItemType Directory -Force -Path $DirectoryPath
        Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Directory created: $DirectoryPath" -ForegroundColor Green
    } else {
        Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Directory already exists: $DirectoryPath" -ForegroundColor Yellow
    }
}

# Function to execute vcpkg export command and log actions using Start-Process
function Run-VcpkgExport {
    param (
        [string]$vcpkgPath,
        [string]$ExportType,
        [string]$Packages,
        [string]$OutputDir,
        [string]$Triplet,
        [string]$AdditionalArgs
    )

    $args = "export $Packages --output=$OutputDir --triplet=$Triplet $AdditionalArgs"
    Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Running vcpkg export for $ExportType..." -ForegroundColor Cyan
    Write-Host "Executing: $vcpkgPath $args" -ForegroundColor Gray

    try {
        # Start the vcpkg process with arguments
        Start-Process -FilePath $vcpkgPath -ArgumentList $args -NoNewWindow -Wait -PassThru | Out-Null
        Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $ExportType export completed successfully." -ForegroundColor Green
    } catch {
        # Log error message
        Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Error occurred during $ExportType export: $_" -ForegroundColor Red
    }
}

# Variables
$vcpkgExe = "F:\test\vcpkg\vcpkg.exe"
$exportDirSDK = "F:\exported\sdk"
$exportDirNuget = "F:\exported\nuget"
$packages = "zlib libpng"

# Ensure directories exist
Ensure-DirectoryExists -DirectoryPath $exportDirSDK
Ensure-DirectoryExists -DirectoryPath $exportDirNuget

# Run SDK exports
Run-VcpkgExport -vcpkgPath $vcpkgExe -ExportType "SDK" -Packages $packages -OutputDir $exportDirSDK -Triplet "x64-windows" -AdditionalArgs "--raw"
Run-VcpkgExport -vcpkgPath $vcpkgExe -ExportType "SDK (Static)" -Packages $packages -OutputDir $exportDirSDK -Triplet "x64-windows-static" -AdditionalArgs "--raw"
Run-VcpkgExport -vcpkgPath $vcpkgExe -ExportType "NuGet" -Packages $packages -OutputDir $exportDirNuget -Triplet "x64-windows" -AdditionalArgs "--nuget"

# End of Script
Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Script completed." -ForegroundColor Cyan
