#!/bin/bash
#################################################################################
# iccDEV WASMBuild Script | iccDEV Project
# Copyright (C) 2025 The International Color Consortium.
#                                        All rights reserved.
#
#  
#  Last Updated: 02-AUGUST-2025 1300Z by David Hoyt
#
#
#  INTENT: Get, Build and Install emsdk
#
#  Testing: Verified Working on Ubuntu24, XNU TODO
#  Issues:  The WASM Build exposed LIB Linking issues TODO via PR on master
#           Missing Graphics Link directives need to be pusg to master branch
#
#  WASM EMSDK BUILD STUB for CI-CD
#
#
#################################################################################
set -e

# Prep for emsdk
cd ~
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
git pull
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
