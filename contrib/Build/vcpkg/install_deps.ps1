#
# Written by : David Hoyt for DemoIccMAX Project
#
# Use:   cd to project_root
# Run: install_vcpkg_deps.ps1
#

# Startup Banner
Write-Host "=========================================" -ForegroundColor Yellow
Write-Host "        VCPKG MULTI-TRIPLET INSTALLER     " -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Yellow
Write-Host "Starting the installation of vcpkg triplets..." -ForegroundColor Cyan
Write-Host ""

# Helper Function to Display Progress
function Install-Triplet {
    param (
        [string]$triplet,
        [bool]$skipDownload = $false
    )

    $command = "vcpkg install --triplet $triplet"
    if ($skipDownload) {
        $command += " --no-downloads"
    }

    Write-Host "Installing: $triplet" -ForegroundColor Green
    Invoke-Expression $command
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully installed: $triplet" -ForegroundColor Green
    } else {
        Write-Host "Error installing: $triplet" -ForegroundColor Red
        exit 1
    }
    Write-Host "----------------------------------------"
}

# Install each triplet with progress updates (optimized, avoiding redundant installs)
Install-Triplet "x64-windows" $true
Install-Triplet "x64-windows-release" $true
Install-Triplet "x64-windows-static-md-release" $true
Install-Triplet "x64-windows-static-md" $true
Install-Triplet "x64-windows-static-release" $true
Install-Triplet "x64-windows-asan-debug" $true
Install-Triplet "x64-windows-static" $true
Install-Triplet "x64-windows-asan" $true

# Completion Message
Write-Host ""
Write-Host "=========================================" -ForegroundColor Yellow
Write-Host "  ALL TRIPLETS INSTALLED SUCCESSFULLY!  " -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Yellow
