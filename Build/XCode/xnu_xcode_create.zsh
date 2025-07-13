#!/bin/zsh
############################################################################################
# Copyright (c) 2024-2025. International Color Consortium. All rights reserved.
# 
#
# Last Updated: 25-APRIL-2025 at 2000 EDT by David Hoyt
#
# Intent:
#   This script is to be run from Project_Root/Build/Xcode
#   Note there are not yet any sanity checks
#   Invokes cmake config with Xcode Generator and Builds the iccMAX Project
#
# TODO
#     Sanity Checks, Logging
#
# Usage:
#   Run this script in a terminal with:
#     /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/xnu_xcode_reset.zsh)"
#
############################################################################################

# Display startup banner
echo "====================================="
echo "  Copyright (c) 2025. International Color Consortium. All rights reserved."
echo "  Run from \$PROJECT_ROOT/Build/Xcode"
echo "  Xcode Project Create & Build"
echo "====================================="

# Define log file
LOGFILE="xcode_create.log"
echo "Logging output to $LOGFILE"
exec > >(tee -a "$LOGFILE") 2>&1

# Detect architecture
ARCH=$(uname -m)
echo "Detected architecture: $ARCH"

# Confirm directory
echo "Running script from: $(pwd)"

# Recreate CMake Project with Xcode
echo "Generating new Xcode project..."
cmake -G "Xcode" \
  -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
  -DCMAKE_BUILD_TYPE=Release \
  -DENABLE_TOOLS=ON \
  -DENABLE_SHARED_LIBS=ON \
  -DENABLE_STATIC_LIBS=ON \
  -DENABLE_TESTS=ON \
  -DENABLE_INSTALL_RIM=ON \
  -DENABLE_ICCXML=ON \
  -Wno-dev \
  ../Cmake/

# Verify configuration
echo "Verifying configuration..."
xcodebuild -showBuildSettings | grep -i build

# Build the project
echo "Building project in Release mode..."
xcodebuild -project RefIccMAX.xcodeproj -scheme ALL_BUILD -configuration Release GCC_WARN_INHIBIT_ALL_WARNINGS=YES | grep -E "error:|BUILD SUCCEEDED"

echo "Project Build"
find . -type f \( -perm -111 -o -name "*.a" -o -name "*.so" -o -name "*.dylib" \) -mmin -1440 ! -path "*/.git/*" ! -path "*/CMakeFiles/*" ! -name "*.sh" -print `` 

# Display exit banner
echo "====================================="
echo "  Xcode Project Create & Build Complete  "
echo "====================================="
