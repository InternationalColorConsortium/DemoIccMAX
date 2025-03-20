#!/bin/zsh
#
# Copyright (c) 2025. International Color Consortium. All rights reserved.
# Copyright (c) 2024. David H Hoyt LLC. All rights reserved.
#
# Last Updated: 06-MAR-2025 at 0729 EST by David Hoyt | h02332
#
# Intent:
#   This script is to be run from Project_Root/Build/
#   Note there are not yet any sanity checks included
#
#
# TODO
#     Sanity Checks
#     Logging
#
# Usage:
#   Run this script in a terminal with:
#     /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/xnu_xcode_reset.zsh)"
#

# Display startup banner
echo "====================================="
echo "  Copyright (c) 2025. International Color Consortium. All rights reserved."
echo "  Copyright (c) 2024. David H Hoyt LLC. All rights reserved.              "
echo "  Run from $PROJECT_ROOT/Build... "
echo "  Xcode Project Reset & Rebuild           "
echo "====================================="

# Define log file
LOGFILE="xcode_reset.log"
echo "Logging output to $LOGFILE"
exec > >(tee -a $LOGFILE) 2>&1

# Detect architecture
ARCH=$(uname -m)
echo "Detected architecture: $ARCH"

# Confirm directory 
echo "Running script from: $(pwd)"

# Remove and recreate Xcode directory
echo "Recreating Xcode directory..."
rm -rf Xcode
mkdir Xcode
cd Xcode || { echo "Error: Failed to enter Xcode directory"; exit 1; }

# Recreate CMake Project with Xcode
echo "Generating new Xcode project..."
cmake -G "Xcode" -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -Wno-dev cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DENABLE_TOOLS=ON -Wno-dev -DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON ../Cmake/

# Verify configuration
echo "Verifying configuration..."
xcodebuild -showBuildSettings | grep -i build

# Build the project
echo "Building project in Release mode..."
xcodebuild -project RefIccMAX.xcodeproj -scheme ALL_BUILD -configuration Release GCC_WARN_INHIBIT_ALL_WARNINGS=YES | grep -E "error:|BUILD SUCCEEDED"

# Display exit banner
echo "====================================="
echo "  Xcode Project Reset & Build Complete  "
echo "====================================="


