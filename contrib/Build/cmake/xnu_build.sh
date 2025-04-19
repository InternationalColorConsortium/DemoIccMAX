#!/bin/sh
###############################################################
#
## Copyright (©) 2024-2025 David H Hoyt LLC. All rights reserved.
##                 https://srd.cx
##
## Last Updated: 17-APRIL-2025 0800 EDT by David Hoyt (©)
#
## Intent: Build Debug Release RelWithDebInfo MinSizeRel 
#
## 
#
# Comments: This is to be run from Build/
#
#
#
#
#
#
###############################################################

set -e

SOURCE_DIR="$(pwd)/Cmake"
BUILD_ROOT="$(pwd)"
CONFIGS="Debug Release RelWithDebInfo MinSizeRel"

for CFG in $CONFIGS; do
  OUT_DIR="$BUILD_ROOT/build_$CFG"
  mkdir -p "$OUT_DIR"
  cd "$OUT_DIR"
  rm -rf CMakeCache.txt CMakeFiles

  case "$CFG" in
    Debug)
      CFLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall"
      ;;
    Release)
      CFLAGS="-O3 -fno-omit-frame-pointer -Wall"
      ;;
    RelWithDebInfo)
      CFLAGS="-O2 -g -fno-omit-frame-pointer -Wall"
      ;;
    MinSizeRel)
      CFLAGS="-Os -fno-omit-frame-pointer -Wall"
      ;;
  esac

  cmake "$SOURCE_DIR" \
    -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
    -DCMAKE_BUILD_TYPE="$CFG" \
    -DENABLE_TOOLS=ON \
    -DENABLE_SHARED_LIBS=ON \
    -DENABLE_STATIC_LIBS=ON \
    -DENABLE_TESTS=ON \
    -DENABLE_INSTALL_RIM=ON \
    -DENABLE_ICCXML=ON \
    -DCMAKE_CXX_FLAGS="$CFLAGS" \
    -DCMAKE_C_FLAGS="$CFLAGS" \
    -Wno-dev

  echo "\n>>>>> Building $CFG configuration <<<<<"
  make -j"$(sysctl -n hw.logicalcpu)"

  cd "$BUILD_ROOT"
done
