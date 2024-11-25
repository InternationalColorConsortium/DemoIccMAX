#!/bin/zsh
##
## Copyright (©) 2024 The International Color Consortium. All rights reserved.
##
## Written by David Hoyt for ICC color.org & DemoIccMAX Project
## Date: 24-Nov-2024
## 
## Zsh build script for macOS

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
run_and_log brew install nlohmann-json libxml2 wxwidgets libtiff || { echo "Error: Failed to install dependencies via Homebrew. Exiting."; exit 1; }

# Step 4: Build
print_banner "Step 4: Starting Build...."
cd Build/ || { echo "Error: Build directory not found. Exiting."; exit 1; }

print_banner "Configuring cmake for Debug"
run_and_log cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
    -Wno-dev Cmake/ || { echo "Error: cmake configuration failed. Exiting."; exit 1; }

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
