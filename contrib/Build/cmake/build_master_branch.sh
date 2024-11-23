#!/bin/bash
##
## Copyright (c) 2024 The International Color Consortium. All rights reserved.
##
## Written by David Hoyt for ICC color.org & DemoIccMAX Project
## Date: 27-Sept-24
##

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
    echo "Elapsed Time: $(date -ud "@$ELAPSED_TIME" +'%H:%M:%S')"
}

# Start Script
print_banner "International Color Consortium | DemoIccMAX Project | Copyright 2024. For more information on The International Color Consortium, please see http://color.org/."
print_banner "Build Script now running.."
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

# Step 3: Revert
print_banner "Step 3: Reverting a bad commit"
run_and_log echo "Step 3a: Reverting 6ac1cc6"
run_and_log git revert --no-edit b90ac3933da99179df26351c39d8d9d706ac1cc6 || { echo "Error: Git revert failed. Exiting."; exit 1; }
run_and_log echo "master branch checked out."

# Step 4: Installing Dependencies
print_banner "Step 4: Installing Dependencies, you will be prompted for the sudo password to continue..."
sudo apt-get install curl git make cmake clang clang-tools \
libwxgtk-media3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev \
libwxgtk3.0-gtk3-dev libxml2 libxml2-dev libtiff5 libtiff5-dev build-essential || { echo "Error: Failed to install dependencies. Exiting."; exit 1; }

# Step 5: Build
print_banner "Step 5: Starting Build...."
cd Build/ || { echo "Error: Build directory not found. Exiting."; exit 1; }

print_banner "Step 5a: configuring cmake"
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug \
-DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
-Wno-dev Cmake/ || { echo "Error: cmake configuration failed. Exiting."; exit 1; }

print_banner "Step 6: running make"
make -j$(nproc) >/dev/null 2>&1 || { echo "Error: Build failed. Exiting."; exit 1; }

print_banner "Built Files:"
find . -type f \( \( -perm -111 \) -o -name "*.a" -o -name "*.so" -o -name "*.dylib" \) -mmin -1440 ! -path "*/.git/*" ! -path "*/CMakeFiles/*" ! -name "*.sh" -exec ls -lh {} \;

print_banner "cd Testing/"
cd ../Testing || { echo "Error: Testing directory not found. Exiting."; exit 1; }

print_banner "Creating Profiles"
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles_cross_check.sh)" || { echo "Error: Profile creation failed. Exiting."; exit 1; }

print_banner "Build Project and CreateAllProfiles Done!"
print_elapsed_time
