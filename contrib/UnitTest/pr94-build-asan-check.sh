#!/bin/sh
##
## Unit Test for PR94 Build Check
## Asan Checks for CreateAllProfiles.sh
##
## David Hoyt for DemoIccMAX Project
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
print_banner "Hoyt's PR94 Build Script now running.."
run_and_log echo "Logfile: $LOGFILE"

# Step 1: Configuring Git user
print_banner "Step 1: Configuring Git user for this session"
run_and_log git config --global user.email "github-actions@github.com" || { echo "Error: Git config failed. Exiting."; exit 1; }
run_and_log git config --global user.name "GitHub Actions" || { echo "Error: Git config failed. Exiting."; exit 1; }
run_and_log echo "Git user configuration done."

# Step 2: Cloning Hoyt's PR94
print_banner "Step 2: Cloning Hoyt's PR94"
run_and_log git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git || { echo "Error: Git clone failed. Exiting."; exit 1; }
cd DemoIccMAX/ || { echo "Error: Failed to change directory to PatchIccMAX. Exiting."; exit 1; }
run_and_log echo "Repository cloned and switched to DemoIccMAX directory."

# Step 3: Checking out Hoyt's PR94
print_banner "Step 3: Checking out Hoyt's PR94"
run_and_log git fetch origin pull/94/head:pr-94 || { echo "Error: Git Fetch failed. Exiting."; exit 1; }
run_and_log git checkout pr-94 || { echo "Error: Git checkout PR94 failed. Exiting."; exit 1; }
run_and_log echo "Step 3a: Reverting 6ac1cc6"
run_and_log git revert --no-edit b90ac3933da99179df26351c39d8d9d706ac1cc6 || { echo "Error: Git revert failed. Exiting."; exit 1; }
run_and_log echo "PR94 checked out."

# Step 4: Changing to Build directory
print_banner "Step 4: Changing to Build directory"
cd Build/ || { echo "Error: Directory change to Build/ failed. Exiting."; exit 1; }
run_and_log echo "Changed to Build directory."

# Step 5: Configuring the build with CMake
print_banner "Step 5: Configuring the build with CMake"
run_and_log cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
      -Wno-dev Cmake/ || { echo "Error: CMake configuration failed. Exiting."; exit 1; }
run_and_log echo "CMake configuration completed."

# Step 6: Building the code with make
print_banner "Step 6: Building the code with make"
run_and_log make -j$(nproc) || { echo "Error: Build failed. Exiting."; exit 1; }
run_and_log echo "Build completed successfully."

# Step 7: Running the tests
print_banner "Step 7: Running the tests.. (60 seconds or less)"
cd ../Testing || { echo "Error: Directory change to Testing failed. Exiting."; exit 1; }
run_and_log /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/CreateAllProfiles.sh)" > CreateAllProfiles.log 2>&1
run_and_log echo "Tests completed. Logs saved in CreateAllProfiles.log. Showing last 50 lines:"
run_and_log tail -n 50 CreateAllProfiles.log

# Final Message
print_banner "Hoyt's PR94 - All steps completed successfully."
run_and_log echo "Based on https://github.com/InternationalColorConsortium/DemoIccMAX/pull/94"

# Print total elapsed time
print_elapsed_time
