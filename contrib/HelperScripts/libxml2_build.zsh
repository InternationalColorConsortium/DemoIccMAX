#!/bin/zsh

# Variables
LIBXML2_VERSION="2.12.6"
LIBXML2_TARBALL="libxml2-$LIBXML2_VERSION.tar.xz"
LIBXML2_URL="https://download.gnome.org/sources/libxml2/2.12/$LIBXML2_TARBALL"
SCRIPT_DIR="$(dirname "$0")"
PROJECT_ROOT="/Users/xss/dmax/DemoIccMAX-master"  # Explicitly setting your project root directory
BUILD_DIR="$PROJECT_ROOT/Build"
LIBXML2_DIR="$BUILD_DIR/libxml2-$LIBXML2_VERSION"
LIBXML2_BUILD_DIR="$BUILD_DIR/libxml2-$LIBXML2_VERSION-build"
INSTALL_DIR="$BUILD_DIR/libxml"
XCODE_LIBXML_DIR="$BUILD_DIR/XCode/libxml"
REQUIRED_HEADERS=(
    "c14n.h"
    "catalog.h"
    "chvalid.h"
    "debugXML.h"
    "dict.h"
    "DOCBparser.h"
    "encoding.h"
    "entities.h"
    "globals.h"
    "hash.h"
    "HTMLparser.h"
    "HTMLtree.h"
    "list.h"
    "nanoftp.h"
    "nanohttp.h"
    "parser.h"
    "parserInternals.h"
    "pattern.h"
    "relaxng.h"
    "SAX.h"
    "SAX2.h"
    "schemasInternals.h"
    "threads.h"
    "tree.h"
    "uri.h"
    "valid.h"
    "xinclude.h"
    "xlink.h"
    "xmlautomata.h"
    "xmlerror.h"
    "xmlexports.h"
    "xmlIO.h"
    "xmlmemory.h"
    "xmlmodule.h"
    "xmlreader.h"
    "xmlregexp.h"
    "xmlsave.h"
    "xmlschemas.h"
    "xmlschemastypes.h"
    "xmlstring.h"
    "xmlunicode.h"
    "xmlversion.h"
    "xmlwin32version.h"
    "xmlwriter.h"
    "xpath.h"
    "xpathInternals.h"
    "xpointer.h"
)

# Ensure the Build directories exist
mkdir -p "$BUILD_DIR"
mkdir -p "$XCODE_LIBXML_DIR"

# Debug output
echo "Project Root: $PROJECT_ROOT"
echo "Build Directory: $BUILD_DIR"
echo "LibXML2 Source Directory: $LIBXML2_DIR"
echo "LibXML2 Build Directory: $LIBXML2_BUILD_DIR"
echo "Installation Directory: $INSTALL_DIR"

# Download the tarball if it doesn't exist or is corrupted
if [[ ! -f "$BUILD_DIR/$LIBXML2_TARBALL" || "$(file -b --mime-type "$BUILD_DIR/$LIBXML2_TARBALL")" != "application/x-xz" ]]; then
    echo "Downloading $LIBXML2_TARBALL..."
    curl -L "$LIBXML2_URL" -o "$BUILD_DIR/$LIBXML2_TARBALL"
fi

# Extract the tarball if the directory doesn't exist
if [[ ! -d "$LIBXML2_DIR" ]]; then
    echo "Extracting $LIBXML2_TARBALL..."
    tar xf "$BUILD_DIR/$LIBXML2_TARBALL" -C "$BUILD_DIR"
fi

# Configure and build the library
echo "Configuring and building libxml2-$LIBXML2_VERSION..."
mkdir -p "$INSTALL_DIR"
cmake -S "$LIBXML2_DIR" -B "$LIBXML2_BUILD_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
    -DCMAKE_BUILD_TYPE=Debug 
cmake --build "$LIBXML2_BUILD_DIR"
cmake --install "$LIBXML2_BUILD_DIR"

# Copy the required header files to the XCode/libxml folder
for header in "${REQUIRED_HEADERS[@]}"; do
    find "$INSTALL_DIR/include/libxml2/libxml" -name $(basename $header) -exec cp {} "$XCODE_LIBXML_DIR/" \;
done

# Report results
if [[ -f "$INSTALL_DIR/lib/libxml2.a" || -f "$INSTALL_DIR/lib/libxml2.dylib" ]]; then
    echo "libxml2-$LIBXML2_VERSION built and installed successfully in $INSTALL_DIR."
else
    echo "Failed to build and install libxml2-$LIBXML2_VERSION."
fi

