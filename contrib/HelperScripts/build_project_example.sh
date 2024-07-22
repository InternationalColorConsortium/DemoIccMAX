#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Clone the repository
cd /tmp
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX

# Revert to a specific commit
git revert -n b90ac3933da99179df26351c39d8d9d706ac1cc6

# Configure the main build
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
      -Wno-dev Build/Cmake

# Compile the main build
make -j$(nproc) 2>&1 | grep 'error:' || true

# Build IccApplyToLink Tool
mkdir -p Tools/CmdLine/IccApplyToLink/Build
cd Tools/CmdLine/IccApplyToLink/Build

cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
      -Wno-dev ../

make -j$(nproc) 2>&1 | grep 'error:' || true
cd ../../../../

# Build IccFromCube Tool
mkdir -p Tools/CmdLine/IccFromCube/Build
cd Tools/CmdLine/IccFromCube/Build

cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
      -Wno-dev ../

make -j$(nproc) 2>&1 | grep 'error:' || true
cd ../../../../
