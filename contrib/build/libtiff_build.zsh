#!/bin/zsh

# Variables
LIBTIFF_VERSION="4.6.0rc2"
LIBTIFF_TARBALL="tiff-$LIBTIFF_VERSION.tar.gz"
LIBTIFF_URL="https://download.osgeo.org/libtiff/$LIBTIFF_TARBALL"
SCRIPT_DIR="$(dirname "$0")"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/Build"
LIBTIFF_DIR="$BUILD_DIR/tiff-4.6.0"  # Adjusted to the correct directory name after extraction
LIBTIFF_BUILD_DIR="$BUILD_DIR/tiff-$LIBTIFF_VERSION-build"
INSTALL_DIR="$BUILD_DIR/libtiff"
XCODE_LIBTIFF_DIR="$BUILD_DIR/XCode/libtiff"
REQUIRED_FILES=(
    "libtiff.a"
    "tiff.h"
    "tiffconf.h"
    "tiffio.h"
    "tiffvers.h"
)

# Ensure the Build directories exist
mkdir -p "$BUILD_DIR"
mkdir -p "$XCODE_LIBTIFF_DIR"

# Download the tarball if it doesn't exist or is corrupted
if [[ ! -f "$BUILD_DIR/$LIBTIFF_TARBALL" || "$(file -b --mime-type "$BUILD_DIR/$LIBTIFF_TARBALL")" != "application/x-gzip" ]]; then
    echo "Downloading $LIBTIFF_TARBALL..."
    if ! wget -O "$BUILD_DIR/$LIBTIFF_TARBALL" "$LIBTIFF_URL"; then
        echo "Error downloading $LIBTIFF_TARBALL. Please check the URL or your internet connection."
        exit 1
    fi
else
    echo "$LIBTIFF_TARBALL already downloaded."
fi

# Extract the tarball if the directory doesn't exist
if [[ ! -d "$LIBTIFF_DIR" ]]; then
    echo "Extracting $LIBTIFF_TARBALL..."
    if ! tar xf "$BUILD_DIR/$LIBTIFF_TARBALL" -C "$BUILD_DIR"; then
        echo "Error extracting $LIBTIFF_TARBALL. The archive may be corrupted."
        exit 1
    fi
else
    echo "$LIBTIFF_DIR already extracted."
fi

# Configure and build the library
echo "Configuring and building libtiff-$LIBTIFF_VERSION..."
mkdir -p "$INSTALL_DIR"
cd "$LIBTIFF_DIR" || exit 1

./configure --prefix="$INSTALL_DIR"
make -j$(sysctl -n hw.ncpu)
sudo make install

# Copy the required files to the XCode/libtiff folder
for file in "${REQUIRED_FILES[@]}"; do
    src="$INSTALL_DIR/lib/$file"
    if [[ "$file" == "libtiff.a" ]]; then
        src="$INSTALL_DIR/lib/libtiff.a"
    else
        src="$INSTALL_DIR/include/$file"
    fi

    if [[ -f "$src" ]]; then
        cp "$src" "$XCODE_LIBTIFF_DIR/"
        echo "Copied $file to $XCODE_LIBTIFF_DIR."
    else
        echo "Missing file: $file"
    fi
done

# Report results
if [[ -f "$INSTALL_DIR/lib/libtiff.a" ]]; then
    echo "libtiff-$LIBTIFF_VERSION built and installed successfully in $INSTALL_DIR."
else
    echo "Failed to build and install libtiff-$LIBTIFF_VERSION."
fi
