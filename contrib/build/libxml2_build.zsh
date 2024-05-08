#!/bin/zsh

# Variables
LIBXML2_VERSION="2.12.6"
LIBXML2_TARBALL="libxml2-$LIBXML2_VERSION.tar.xz"
LIBXML2_URL="https://download.gnome.org/sources/libxml2/2.12/$LIBXML2_TARBALL"
SCRIPT_DIR="$(dirname "$0")"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/Build"
LIBXML2_DIR="$BUILD_DIR/libxml2-$LIBXML2_VERSION"
INSTALL_DIR="$BUILD_DIR/libxml"

# Ensure the Build directory exists
mkdir -p "$BUILD_DIR"

# Download the tarball if it doesn't exist or if the current file is corrupted
if [[ ! -f "$BUILD_DIR/$LIBXML2_TARBALL" || "$(file -b --mime-type "$BUILD_DIR/$LIBXML2_TARBALL")" != "application/x-xz" ]]; then
    echo "Downloading $LIBXML2_TARBALL..."
    if ! wget -O "$BUILD_DIR/$LIBXML2_TARBALL" "$LIBXML2_URL"; then
        echo "Error downloading $LIBXML2_TARBALL. Please check the URL or your internet connection."
        exit 1
    fi
else
    echo "$LIBXML2_TARBALL already downloaded."
fi

# Extract the tarball if the directory doesn't exist
if [[ ! -d "$LIBXML2_DIR" ]]; then
    echo "Extracting $LIBXML2_TARBALL..."
    if ! tar xf "$BUILD_DIR/$LIBXML2_TARBALL" -C "$BUILD_DIR"; then
        echo "Error extracting $LIBXML2_TARBALL. The archive may be corrupted."
        exit 1
    fi
else
    echo "$LIBXML2_DIR already extracted."
fi

# Configure and build the library
echo "Configuring and building libxml2-$LIBXML2_VERSION..."
mkdir -p "$INSTALL_DIR"
cd "$LIBXML2_DIR" || exit 1

./configure --prefix="$INSTALL_DIR"
make -j$(nproc)
make install

# Report results
if [[ -f "$INSTALL_DIR/lib/libxml2.a" || -f "$INSTALL_DIR/lib/libxml2.dylib" ]]; then
    echo "libxml2-$LIBXML2_VERSION built and installed successfully in $INSTALL_DIR."
else
    echo "Failed to build and install libxml2-$LIBXML2_VERSION."
fi
