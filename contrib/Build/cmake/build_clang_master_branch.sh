#!/bin/bash
##
## Copyright (c) 2024 The International Color Consortium. All rights reserved.
##
## Written by David Hoyt for ICC color.org & DemoIccMAX Project
## Date: 24-Nov-2024
## Build Script using Clang for master branch

# Define log file
LOGFILE="build_log_$(date +%Y-%m-%d_%H-%M-%S).log"
START_TIME=$(date +%s)

# Set compiler to Clang explicitly for B testing
COMPILER="clang++"
CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall"

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
    echo "Elapsed Time: $(date -ud "@$ELAPSED_TIME" +'%H:%M:%S')"
}

# Start Script
print_banner "International Color Consortium | DemoIccMAX Project | Clang Build"
print_banner "For more information on The International Color Consortium, please see color.org."
print_banner "Build Script now running with compiler: $COMPILER"
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

# Step 3: Installing Dependencies, with conflict resolution
print_banner "Step 4: Installing Dependencies, you will be prompted for the sudo password to continue..."

# Attempt to remove conflicting packages
echo "Removing potentially conflicting packages..."
sudo apt-get remove -y libopencl-clang-* python3-clang-* || { echo "Error: Failed to remove conflicting packages."; exit 1; }

# Update and fix any broken packages
echo "Updating package list and fixing broken packages..."
sudo apt-get update || { echo "Error: Failed to update packages."; exit 1; }
sudo apt-get --fix-broken install || { echo "Error: Failed to fix broken packages."; exit 1; }

# Install the necessary dependencies
echo "Installing necessary dependencies..."
sudo apt-get install -y libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential || { echo "Error: Failed to install dependencies. Exiting."; exit 1; } || { echo "Error: Failed to install dependencies. Exiting."; exit 1; }

echo "Dependencies installed successfully."

# Step 4: Build with Clang
print_banner "Step 4: Starting Build using $COMPILER...."
cd Build/ || { echo "Error: Build directory not found. Exiting."; exit 1; }

print_banner "Step 5: configuring cmake with $COMPILER"
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug \
-DCMAKE_CXX_COMPILER=$COMPILER -DCMAKE_CXX_FLAGS="$CXX_FLAGS" \
-Wno-dev Cmake/ || { echo "Error: cmake configuration failed. Exiting."; exit 1; }

print_banner "Step 6: running make (low-noise)"
make -j$(nproc) >/dev/null 2>&1 || { echo "Error: Build failed. Exiting."; exit 1; }

print_banner "Built Files:"
find . -type f \( \( -perm -111 \) -o -name "*.a" -o -name "*.so" -o -name "*.dylib" \) -mmin -1440 ! -path "*/.git/*" ! -path "*/CMakeFiles/*" ! -name "*.sh" -exec ls -lh {} \;

print_banner "cd Testing/"
cd ../Testing || { echo "Error: Testing directory not found. Exiting."; exit 1; }

print_banner "Creating Profiles"
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)" || { echo "Error: Profile creation failed. Exiting."; exit 1; }

print_banner "Build Project and CreateAllProfiles Done!"
print_elapsed_time
