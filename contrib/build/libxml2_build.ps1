# Set environment variables
$LIBXML2_VERSION = "2.12.6"
$LIBXML2_TARBALL = "libxml2-$LIBXML2_VERSION.tar.xz"
$LIBXML2_URL = "https://download.gnome.org/sources/libxml2/2.12/$LIBXML2_TARBALL"
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_ROOT = Resolve-Path "$SCRIPT_DIR\..\..\.."
$BUILD_DIR = Join-Path $PROJECT_ROOT "Build"
$LIBXML2_DIR = Join-Path $BUILD_DIR "libxml2-$LIBXML2_VERSION"
$LIBXML2_BUILD_DIR = Join-Path $BUILD_DIR "libxml2-$LIBXML2_VERSION-build"
$INSTALL_DIR = Join-Path $BUILD_DIR "libxml"

# Ensure the Build directory exists
if (-not (Test-Path $BUILD_DIR)) {
    New-Item -Path $BUILD_DIR -ItemType Directory
}

# Download the tarball if it doesn't exist or is corrupted
$TARBALL_PATH = Join-Path $BUILD_DIR $LIBXML2_TARBALL
if (-not (Test-Path $TARBALL_PATH) -or ((Get-Item $TARBALL_PATH).Length -eq 0)) {
    Write-Output "Downloading $LIBXML2_TARBALL..."
    Invoke-WebRequest -Uri $LIBXML2_URL -OutFile $TARBALL_PATH
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error downloading $LIBXML2_TARBALL. Please check the URL or your internet connection."
        exit 1
    }
} else {
    Write-Output "$LIBXML2_TARBALL already downloaded."
}

# Extract the tarball if the directory doesn't exist
if (-not (Test-Path $LIBXML2_DIR)) {
    Write-Output "Extracting $LIBXML2_TARBALL..."
    Start-Process -FilePath "cmake.exe" -ArgumentList "-E", "tar", "xf", "$TARBALL_PATH", "-C", "$BUILD_DIR" -NoNewWindow -Wait
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error extracting $LIBXML2_TARBALL. The archive may be corrupted."
        exit 1
    }
} else {
    Write-Output "$LIBXML2_DIR already extracted."
}

# Configure and build the library
Write-Output "Configuring and building libxml2-$LIBXML2_VERSION..."
if (-not (Test-Path $LIBXML2_BUILD_DIR)) {
    New-Item -Path $LIBXML2_BUILD_DIR -ItemType Directory
}
Start-Process -FilePath "cmake.exe" -ArgumentList "-S", "$LIBXML2_DIR", "-B", "$LIBXML2_BUILD_DIR", "-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR", "-G", "NMake Makefiles" -NoNewWindow -Wait
if ($LASTEXITCODE -ne 0) {
    Write-Error "Configuration failed."
    exit 1
}
Start-Process -FilePath "cmake.exe" -ArgumentList "--build", "$LIBXML2_BUILD_DIR" -NoNewWindow -Wait
if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed."
    exit 1
}
Start-Process -FilePath "cmake.exe" -ArgumentList "--install", "$LIBXML2_BUILD_DIR" -NoNewWindow -Wait
if ($LASTEXITCODE -ne 0) {
    Write-Error "Installation failed."
    exit 1
}

# Report results
if (Test-Path "$INSTALL_DIR\lib\libxml2.a" -or Test-Path "$INSTALL_DIR\lib\libxml2.dll") {
    Write-Output "libxml2-$LIBXML2_VERSION built and installed successfully in $INSTALL_DIR."
} else {
    Write-Error "Failed to build and install libxml2-$LIBXML2_VERSION."
}
