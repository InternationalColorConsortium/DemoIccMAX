# ========================== IccMAX contrib/HelperScripts/iccdumpprofile.ps1 ==========================
#
# Description: IccDumpProfile Helper Script
#
# Copyright (c) 2025 The International Color Consortium. All rights reservedd.
# Copyright (c) 2024 David H Hoyt LLC . All rights reserved
#
# Author: David Hoyt
# Last Updated:  24-FEB-2025 1116 EST
#
#
# Intent: Dump with iccdumpprofile *.icc profile and capture outputs in $Project_Root/Testing/output/iccdumpprofile
#
#
# cd $Project_Root/Testing/
# Run via pwsh: iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/HelperScripts/iccdumpprofile.ps1").Content
#
#
#
# ============================================================

# Start of Script
Write-Host "============================= IccMAX contrib/HelperScripts/iccdumpprofile.ps1 =============================" -ForegroundColor Green
Write-Host "Copyright (c) 2025 The International Color Consortium. All rights reserved." -ForegroundColor Green
Write-Host "Copyright (c) 2024 David H Hoyt LLC . All rights reserved" -ForegroundColor Green
Write-Host "Last Updated: 24-FEB-2025 1045 EST David Hoyt | @h02332" -ForegroundColor Green

# Define the base directory and output directory
$baseDirectory = "C:\test\DemoIccMAX\Testing"  
$outputDirectory = "C:\test\DemoIccMAX\Testing\output\iccdumpprofile"  # Output directory

# Ensure the output directory exists
if (-Not (Test-Path -Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

# Define the path to iccDumpProfile.exe
$iccDumpProfileExe = "C:\test\DemoIccMAX\Testing\IccDumpProfile_d.exe"  

# Get all .icc files recursively, excluding the output directory
$iccFiles = Get-ChildItem -Path $baseDirectory -Filter *.icc -Recurse | Where-Object { $_.DirectoryName -notlike "$outputDirectory*" }

# Iterate through each .icc file
foreach ($iccFile in $iccFiles) {
    # Define the output file path in icc-dump, preserving subdirectory structure
    $relativePath = $iccFile.FullName.Replace($baseDirectory, "").TrimStart("\")  # Get relative path
    $outputFile = Join-Path -Path $outputDirectory -ChildPath ($relativePath -replace "\.icc$", ".txt")  # Change .icc to .txt

    # Ensure the subdirectories exist in the output directory
    $outputSubDir = Split-Path -Path $outputFile -Parent
    if (-Not (Test-Path $outputSubDir)) {
        New-Item -ItemType Directory -Path $outputSubDir -Force | Out-Null
    }

    # Run iccDumpProfile.exe on the current .icc file and properly redirect output
    $process = Start-Process -FilePath $iccDumpProfileExe -ArgumentList $iccFile.FullName -NoNewWindow -PassThru -Wait -RedirectStandardOutput $outputFile

    # Check if the command succeeded
    if ($process.ExitCode -eq 0) {
        Write-Output "Successfully dumped profile: $($iccFile.FullName) to $outputFile"
    } else {
        Write-Output "Failed to dump profile: $($iccFile.FullName)"
    }
}
