#!/bin/zsh

# Directories
SCRIPT_DIR="$(dirname "$0")"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/Build"
ICC_PROF_LIB_DIR="$BUILD_DIR/IccProfLib"
ICC_XML_DIR="$BUILD_DIR/IccXML"
XCODE_LIB_DIR="$BUILD_DIR/XCode/lib"

# Ensure the XCode/lib directory exists
mkdir -p "$XCODE_LIB_DIR"

# Required files
DESIRED_CONTENTS=(
    "DesiredContentsAfterBuild.txt"
    "libIccProfLib.a"
    "libIccXML.a"
)

# Create the DesiredContentsAfterBuild.txt
cat << EOF > "$XCODE_LIB_DIR/DesiredContentsAfterBuild.txt"
The desired files in this folder after a successful build are as follows:

DesiredContentsAfterBuild.txt - this file
libIccProfLib.a - IccProfLib library
libIccXML.a - IccXML library
EOF

# Copy files to the XCode/lib directory
cp "$ICC_PROF_LIB_DIR/libIccProfLib2-static.a" "$XCODE_LIB_DIR/libIccProfLib.a"
cp "$ICC_XML_DIR/libIccXML2-static.a" "$XCODE_LIB_DIR/libIccXML.a"

# Verify the files
for file in "${DESIRED_CONTENTS[@]}"; do
    if [[ -f "$XCODE_LIB_DIR/$file" ]]; then
        echo "Copied $file to $XCODE_LIB_DIR."
    else
        echo "Missing file: $file"
    fi
done
