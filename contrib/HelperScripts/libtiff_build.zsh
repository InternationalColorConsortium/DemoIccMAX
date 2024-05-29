#!/bin/zsh

# Define variables
LIBTIFF_VERSION="4.6.0"
LIBTIFF_TARBALL="tiff-$LIBTIFF_VERSION.tar.gz"
LIBTIFF_URL="https://download.osgeo.org/libtiff/$LIBTIFF_TARBALL"
BUILD_DIR="$(pwd)"  # Ensure this is run from the appropriate directory
LIBTIFF_DIR="$BUILD_DIR/tiff-$LIBTIFF_VERSION"  # Adjusted to the actual directory name after extraction
INSTALL_DIR="$BUILD_DIR/libtiff"
XCODE_LIBTIFF_DIR="$BUILD_DIR/XCode/libtiff"

# Create necessary directories
echo "Creating directories..."
mkdir -p "$INSTALL_DIR" "$XCODE_LIBTIFF_DIR"

# Download the tarball if it doesn't exist
if [[ ! -f "$BUILD_DIR/$LIBTIFF_TARBALL" ]]; then
    echo "Downloading $LIBTIFF_TARBALL..."
    if ! curl -L "$LIBTIFF_URL" -o "$BUILD_DIR/$LIBTIFF_TARBALL"; then
        echo "Failed to download $LIBTIFF_TARBALL."
        exit 1
    fi
fi

# Extract the tarball
if [[ ! -d "$LIBTIFF_DIR" ]]; then
    echo "Extracting $LIBTIFF_TARBALL..."
    if ! tar -xzf "$BUILD_DIR/$LIBTIFF_TARBALL" -C "$BUILD_DIR" || [[ ! -d "$LIBTIFF_DIR" ]]; then
        echo "Extraction failed, directory $LIBTIFF_DIR not found."
        exit 1
    fi
fi

# Change to the libtiff directory
cd "$LIBTIFF_DIR" || exit 1

# Configure and build libtiff
echo "Configuring and building libtiff-$LIBTIFF_VERSION..."
if ! ./configure --prefix="$INSTALL_DIR" || ! make -j$(sysctl -n hw.ncpu) || ! make install; then
    echo "Failed to configure, build, or install libtiff-$LIBTIFF_VERSION."
    exit 1
fi

# Copy required files to the XCode directory
echo "Copying required files to $XCODE_LIBTIFF_DIR..."
cp "$INSTALL_DIR/lib/libtiff.a" "$INSTALL_DIR/include/"*.h "$XCODE_LIBTIFF_DIR/"

# Final success check
if [[ -f "$INSTALL_DIR/lib/libtiff.a" ]]; then
    echo "libtiff-$LIBTIFF_VERSION has been successfully built and installed in $INSTALL_DIR."
else
    echo "Failed to build and install libtiff-$LIBTIFF_VERSION."
    exit 1
fi

