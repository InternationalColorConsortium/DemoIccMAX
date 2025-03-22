#!/bin/zsh
## Copyright (c) 2024-2025. International Color Consortium. All rights reserved.
## Copyright (c) 2024. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt 
## Date: 15-MAR-2025 1434 EDT
#
# Branch: XNU
# Intent: PROTOTYPE
# Production: FALSE
# Runner: TRUE
#
#
# Updates: Added platform conditional
#          Fixed globbing
#
# Run: /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/xnu/contrib/Build/cmake/xnu_build_master_branch.zsh)"
# 
#  
## Build Script using Clang for master branch

export CXX=clang++
export CC=clang

# Default ASAN options
export ASAN_OPTIONS="alloc_dealloc_mismatch=1:detect_leaks=1:detect_stack_use_after_return=1:strict_string_checks=1:detect_invalid_pointer_pairs=2:halt_on_error=0:verbosity=1"

# Detect if running on macOS (Darwin) and ARM64
if [[ "$(uname -s)" == "Darwin" && "$(uname -m)" == "arm64" ]]; then
    export ASAN_OPTIONS=${ASAN_OPTIONS//detect_leaks=1/detect_leaks=0}
fi

# Log the ASAN_OPTIONS value
echo "ASAN_OPTIONS is set to: $ASAN_OPTIONS" >> asan_options.log

# Define log file
LOGFILE="build_log_$(date +%Y-%m-%d_%H-%M-%S).log"
START_TIME=$(date +%s)

# Function to print section banners
print_banner() {
    echo "============================================================"
    echo " $1"
    echo " Time: $(date)"
    echo "============================================================"
}

# Function to log both stdout and stderr, and also show in real-time
run_and_log() {
    "$@" 2>&1 | tee -a $LOGFILE
}

# Function to track elapsed time
print_elapsed_time() {
    END_TIME=$(date +%s)
    ELAPSED_TIME=$((END_TIME - START_TIME))
    echo "Elapsed Time: $(date -u -r "$ELAPSED_TIME" +'%H:%M:%S')"
}

# Start Script
print_banner "International Color Consortium | DemoIccMAX Project"
print_banner "Copyright © 2024"
print_banner "For more information on The International Color Consortium, please see http://color.org/"
print_banner "XNU Build Script now running.."
run_and_log echo "Logfile: $LOGFILE"

# Step 1: Configuring Git user
print_banner "Step 1: Configuring Git user for this session"
run_and_log git config --global user.email "github-actions@github.com" || { echo "Error: Git config failed. Exiting."; exit 1; }
run_and_log git config --global user.name "GitHub Actions" || { echo "Error: Git config failed. Exiting."; exit 1; }
run_and_log echo "Git user configuration done."

# Step 2: Cloning master branch
print_banner "Step 2: Cloning DemoIccMAX on master branch"
run_and_log git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git || { echo "Error: Git clone failed. Exiting."; exit 1; }
cd DemoIccMAX/ || { echo "Error: Failed to change directory to DemoIccMAX. Exiting."; exit 1; }
run_and_log echo "Repository cloned and switched to DemoIccMAX directory."

# Step 3: Installing Dependencies
print_banner "Step 3: Installing Dependencies"
echo "You may be prompted for the sudo password to continue..."
run_and_log brew install libpng nlohmann-json libxml2 wxwidgets libtiff || { echo "Error: Failed to install dependencies via Homebrew. Exiting."; exit 1; }

# Step 4: Build
print_banner "Step 4: Starting Build...."
cd Build/ || { echo "Error: Build directory not found. Exiting."; exit 1; }

print_banner "Configuring cmake for Debug"
run_and_log cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" -DCMAKE_BUILD_TYPE=Debug \
-DCMAKE_CXX_COMPILER="$COMPILER" -DCMAKE_CXX_FLAGS="$CXX_FLAGS" \
-DENABLE_TOOLS=ON -DENABLE_SHARED_LIBS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_TESTS=ON -DENABLE_INSTALL_RIM=ON -DENABLE_ICCXML=ON \
-Wno-dev Cmake/ || { echo "❌ Error: CMake configuration failed. Exiting."; exit 1; }

print_banner "Step 5: Running make"
run_and_log make -j$(sysctl -n hw.ncpu) || { echo "Error: Build failed. Exiting."; exit 1; }

print_banner "Built Files:"
find . -type f \( -perm -111 -o -name "*.a" -o -name "*.so" -o -name "*.dylib" \) -mmin -1440 \
    ! -path "*/.git/*" ! -path "*/CMakeFiles/*" ! -name "*.sh" -exec ls -lh {} \;

# Step 6: Testing
print_banner "Step 6: Testing"
cd ../Testing || { echo "Error: Testing directory not found. Exiting."; exit 1; }

print_banner "Creating Profiles"
run_and_log /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)" || { echo "Error: Profile creation failed. Exiting."; exit 1; }

print_banner "XNU Build Project and CreateAllProfiles Done!"
print_elapsed_time
