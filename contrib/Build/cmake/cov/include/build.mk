#
## 
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt 
## Date: 28-MAR-2025 2000 EDT
#
# Branch: PR124
# Intent: Cross-platform build.mk for AFL fuzzing projects on macOS & Ubuntu
# Production: TRUE
# Runner: TRUE
#
#
# Updates: Cross-platform build.mk for AFL fuzzing projects on macOS & Ubuntu
#          
#
# 
# 
#  
# Cross-platform build.mk for AFL fuzzing projects on macOS & Ubuntu ripped from the SRD SDK

# Base path to this project (where the Makefile lives)
export PROJECT_PATH ?= $(dir $(realpath $(firstword ${MAKEFILE_LIST})))

# Platform detection
UNAME_S := $(shell uname -s)
IS_MAC := $(findstring Darwin,${UNAME_S})
IS_LINUX := $(findstring Linux,${UNAME_S})

# Default toolchain + SDKs for macOS
ifeq (${IS_MAC},Darwin)
export ARCH ?= arm64e
export SDK ?= iphoneos
export TOOLCHAIN ?= iOS14.0
export MACOS_TOOLCHAIN ?= MacOSX11.0

export SDK_PATH := $(shell xcrun --show-sdk-path --sdk ${SDK})
export MACOS_SDK_PATH := $(shell xcrun --show-sdk-path --sdk macosx)
export SDKROOT := ${SDK_PATH}

# Clang with toolchain
export CC := $(shell xcrun -f --toolchain ${TOOLCHAIN} clang)
export CXX := $(shell xcrun -f --toolchain ${TOOLCHAIN} clang++)
export HOSTCC := $(shell xcrun -f --toolchain ${MACOS_TOOLCHAIN} clang)

# Paths for grafted headers
export SDK_GRAFT_DIR ?= $(abspath ${PROJECT_PATH}/sdk-graft)
export SDK_GRAFT_DOWNLOADS ?= $(SDK_GRAFT_DIR)/downloads
export LOCAL_INCLUDE_DIR ?= $(SDK_GRAFT_DIR)/include

# CFlags for macOS targets
export CFLAGS := -isysroot ${SDK_PATH} -arch ${ARCH} \
	-I${SDK_PATH}/usr/include -I${LOCAL_INCLUDE_DIR} -F${LOCAL_INCLUDE_DIR} \
	-DTARGET_OS_IPHONE=1 -DTARGET_OS_BRIDGE=0

export HOST_CFLAGS := -isysroot ${MACOS_SDK_PATH} -I${MACOS_SDK_PATH}/usr/include
export LDFLAGS := -isysroot ${SDK_PATH} -arch ${ARCH}
export HOST_LDFLAGS := -isysroot ${MACOS_SDK_PATH}
export CPPFLAGS := -DUSE_GETCWD -I${LOCAL_INCLUDE_DIR} -F${LOCAL_INCLUDE_DIR}
endif

# Linux (Ubuntu) compatibility
ifeq (${IS_LINUX},Linux)
export CC := clang
export CXX := clang++
export HOSTCC := gcc

export CFLAGS := -Wall -Wextra -g
export LDFLAGS :=
export CPPFLAGS :=
endif

# AFL-aware wrapping
export AFL_CXX := afl-clang-fast++
export AFL_CC := afl-clang-fast

# Optional fallback to normal toolchain if AFL=0
ifeq ($(AFL),1)
	export CC := ${AFL_CC}
	export CXX := ${AFL_CXX}
endif

# Optional utilities
check-sdks:
ifeq (${IS_MAC},Darwin)
	@echo "[+] Checking macOS SDK at ${MACOS_SDK_PATH}"
	@test -d "${MACOS_SDK_PATH}" || (echo "? Missing macOS SDK" && exit 1)
	@echo "[+] Checking iOS SDK at ${SDK_PATH}"
	@test -d "${SDK_PATH}" || (echo "? Missing iOS SDK" && exit 1)
endif

# Header grafting (macOS only)
.PHONY: sdk-graft
sdk-graft: check-sdks gather-xnu-headers
	mkdir -p ${LOCAL_INCLUDE_DIR}
	@echo "[+] Creating SDK header graft..."

sdk-graft-clean:
	rm -rf ${SDK_GRAFT_DIR}

# Header extraction targets
export XNU_VERSION := xnu-6153.81.5

${SDK_GRAFT_DOWNLOADS}/${XNU_VERSION}:
	cd ${SDK_GRAFT_DOWNLOADS} && \
	mkdir -p ${XNU_VERSION} && \
	tar -xf ${XNU_VERSION}.tar.gz -C ${XNU_VERSION} --strip-components 1

${SDK_GRAFT_DOWNLOADS}/${XNU_VERSION}.tar.gz:
	mkdir -p ${SDK_GRAFT_DOWNLOADS}
	curl -sSL -o $@ https://github.com/apple-oss-distributions/xnu/archive/${XNU_VERSION}.tar.gz

gather-xnu-headers: ${SDK_GRAFT_DOWNLOADS}/${XNU_VERSION}

# Pattern graft rules (macOS)
${LOCAL_INCLUDE_DIR}/%: ${MACOS_SDK_PATH}/usr/include/%
	mkdir -p $(dir $@)
	cp $< $@

${LOCAL_INCLUDE_DIR}/IOKit/%.h: ${MACOS_SDK_PATH}/System/Library/Frameworks/IOKit.framework/Versions/Current/Headers/%.h
	mkdir -p ${LOCAL_INCLUDE_DIR}/IOKit/
	cp $< $@
