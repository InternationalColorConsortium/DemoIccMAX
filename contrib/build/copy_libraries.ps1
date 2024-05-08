# Directories
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_ROOT = Resolve-Path "$SCRIPT_DIR\..\..\.."
$BUILD_DIR = Join-Path $PROJECT_ROOT "Build"
$ICC_PROF_LIB_DIR = Join-Path $BUILD_DIR "IccProfLib"
$ICC_XML_DIR = Join-Path $BUILD_DIR "IccXML"
$XCODE_LIB_DIR = Join-Path $BUILD_DIR "XCode\lib"

# Ensure the XCode\lib directory exists
if (-not (Test-Path $XCODE_LIB_DIR)) {
    New-Item -Path $XCODE_LIB_DIR -ItemType Directory
}

# Required files
$DesiredContents = @(
    "DesiredContentsAfterBuild.txt"
    "libIccProfLib.a"
    "libIccXML.a"
)

# Create the DesiredContentsAfterBuild.txt
$Content = @"
The desired files in this folder after a successful build are as follows:

DesiredContentsAfterBuild.txt - this file
libIccProfLib.a - IccProfLib library
libIccXML.a - IccXML library
"@
Set-Content -Path (Join-Path $XCODE_LIB_DIR "DesiredContentsAfterBuild.txt") -Value $Content

# Copy files to the XCode\lib directory
Copy-Item -Path (Join-Path $ICC_PROF_LIB_DIR "libIccProfLib2-static.a") -Destination (Join-Path $XCODE_LIB_DIR "libIccProfLib.a") -Force
Copy-Item -Path (Join-Path $ICC_XML_DIR "libIccXML2-static.a") -Destination (Join-Path $XCODE_LIB_DIR "libIccXML.a") -Force

# Verify the files
foreach ($file in $DesiredContents) {
    if (Test-Path (Join-Path $XCODE_LIB_DIR $file)) {
        Write-Output "Copied $file to $XCODE_LIB_DIR."
    } else {
        Write-Output "Missing file: $file"
    }
}
