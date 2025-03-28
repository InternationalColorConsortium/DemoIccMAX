#################################################################################
# Cmake Project Configuration| iccMAX Project
# Copyright (C) 2024-2025 The International Color Consortium. 
#                                        All rights reserved.
# 
#
#  Last Updated: Mon Mar 24 16:40:19 EDT 2025 by David Hoyt
#  date -d @1742848819
#  Mon Mar 24 16:40:19 EDT 2025
#
#  Changes: Minimized for Production, Logging is Verbose, Default
#           Added to CMakelists.txt: IccPngDump
#           Adjusted Cross Platform Build Args
#						
#  TODO:    Refactor Debug, Release, Asan, subproject pathing issues
#           Collapse 3-tier CMakeLists.txt, Housekeeping
#           Refactor Base Configs & logging to .mk's 
#
#
#################################################################################

# ----------------------------------------------------------------------
# Noise Level / Warning Suppression
# ----------------------------------------------------------------------

# Note: prefer `target_compile_options()` for scoped suppression
# Uncomment this only for global suppression (not recommended):
# add_compile_options(/w)

# Recommended: suppress known-safe MSVC warnings globally
if(MSVC)
  add_compile_options(/wd5045)         # Suppress Spectre mitigation warnings
  add_link_options("/IGNORE:4044")     # Ignore unrecognized MSVC linker flags
  add_link_options("/IGNORE:4300")     # Suppress ASAN + /INCREMENTAL warnings
endif()

# ----------------------------------------------------------------------
# Global CMake Project Setup
# ----------------------------------------------------------------------

cmake_minimum_required(VERSION 3.21 FATAL_ERROR)  # Modern minimum for policy safety

# Adopt modern behavior for scoped scripts and alias linking
# cmake_policy(SET CMP0112 NEW)  # Respect parent scope in script mode
# cmake_policy(SET CMP0156 NEW)  # Allow ALIAS targets for link dependencies

# Emit warnings on deprecated or legacy CMake features
set(CMAKE_WARN_DEPRECATED TRUE)

# Optional: clean up obsolete warnings (only enable if really needed)
# set(CMAKE_POLICY_WARNING_CMP0012 TRUE)

# Suppress redundant regeneration messages (less CLI noise)
set(CMAKE_SUPPRESS_REGENERATION ON)

# ----------------------------------------------------------------------
# Timestamped Configuration Header
# ----------------------------------------------------------------------

string(TIMESTAMP CURRENT_DATETIME "%Y-%m-%d %H:%M:%S")
message(STATUS "")
message(STATUS "##########################################################################")
message(STATUS "## Starting to Configure the DemoIccMAX Project at ${CURRENT_DATETIME}")
message(STATUS "##########################################################################")
message(STATUS "")

# ----------------------------------------------------------------------
# Verbose Makefile Output (for Make/Ninja generators)
# ----------------------------------------------------------------------

set(CMAKE_VERBOSE_MAKEFILE ON)

# ----------------------------------------------------------------------
# Define Default Configurations (for MSVC/Xcode generators)
# ----------------------------------------------------------------------

if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
  set(CMAKE_CONFIGURATION_TYPES "Debug;Release;RelWithDebInfo" CACHE STRING "Available configurations" FORCE)
  set_property(GLOBAL PROPERTY DEBUG_CONFIGURATIONS Debug)
  set_property(GLOBAL PROPERTY RELEASE_CONFIGURATIONS Release)
endif()

# ----------------------------------------------------------------------
# Project Identity and Versioning
# ----------------------------------------------------------------------

project(RefIccMAX LANGUAGES CXX)
set(PROJECT_UP_NAME "REFICCMAX")  # All-uppercase variant for internal macros
set(PROJECT_DOWN_NAME "reficcmax")  # All-lowercase variant for packaging

# Version Components
set(${PROJECT_UP_NAME}_MAJOR_VERSION 2)
set(${PROJECT_UP_NAME}_MINOR_VERSION 1)
set(${PROJECT_UP_NAME}_MICRO_VERSION 25)
set(${PROJECT_UP_NAME}_VERSION
  "${${PROJECT_UP_NAME}_MAJOR_VERSION}.${${PROJECT_UP_NAME}_MINOR_VERSION}.${${PROJECT_UP_NAME}_MICRO_VERSION}"
)

# Optional derived version (major.minor only)
set(${PROJECT_NAME}_VERSION_MAJORMINOR
  "${${PROJECT_NAME}_MAJOR_VERSION}.${${PROJECT_NAME}_MINOR_VERSION}"
)

# Set C++ standard globally
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Descriptive metadata (for packaging, install, CI)
set(PACKAGE_NAME "${PROJECT_DOWN_NAME}")
set(PACKAGE_DESCRIPTION
  "The IccMAX project provides an open source set of libraries and tools for iccMAX-based profiles."
)

# ----------------------------------------------------------------------
# Build Configuration Summary
# ----------------------------------------------------------------------
message(STATUS "")
message(STATUS "=== Project Configuration Summary ===")
message(STATUS "  Project Name       : ${PROJECT_NAME}")
message(STATUS "  Internal Name (UP) : ${PROJECT_UP_NAME}")
message(STATUS "  Version (Full)     : ${${PROJECT_UP_NAME}_VERSION}")
message(STATUS "  Version (Short)    : ${${PROJECT_NAME}_VERSION_MAJORMINOR}")
message(STATUS "  C++ Standard       : C++${CMAKE_CXX_STANDARD}")
message(STATUS "  Description        : ${PACKAGE_DESCRIPTION}")
message(STATUS "=========================================")
message(STATUS "")


# ----------------------------------------------------------------------
# Define project root (relative to CMake source directory)
# This may be overridden in superbuilds or CI environments
set(PROJECT_ROOT_DIR "${CMAKE_SOURCE_DIR}/../..")

# ----------------------------------------------------------------------
# Host System Diagnostics
# Print key info for reproducibility and debugging
message(STATUS "")
message(STATUS "===  Build Environment Diagnostics ===")
message(STATUS "  Source Directory       : ${CMAKE_SOURCE_DIR}")
message(STATUS "  Project Root Directory : ${PROJECT_ROOT_DIR}")
message(STATUS "   System Name           : ${CMAKE_SYSTEM_NAME}")
message(STATUS "  System Version        : ${CMAKE_SYSTEM_VERSION}")
message(STATUS "  Processor Architecture : ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "  Build Host             : $ENV{COMPUTERNAME} ($ENV{USERNAME})")
message(STATUS "=========================================")
message(STATUS "")

# ----------------------------------------------------------------------
# Sanitize broken MSVC linker flags (e.g., misused /LF:)
# This ensures clean linker invocation on Windows hosts
foreach(flag_var IN ITEMS
    CMAKE_EXE_LINKER_FLAGS
    CMAKE_SHARED_LINKER_FLAGS
    CMAKE_MODULE_LINKER_FLAGS)
  string(REPLACE "/LF:" "/LIBPATH:" ${flag_var} "${${flag_var}}")
endforeach()

# ----------------------------------------------------------------------
# AddressSanitizer / Fuzzing Configuration
# ----------------------------------------------------------------------

option(ENABLE_ASAN "Enable AddressSanitizer (requires compatible compiler)" OFF)
option(ENABLE_FUZZING "Enable Fuzzing Sanitizer (requires clang/libfuzzer)" OFF)

if(ENABLE_ASAN OR CMAKE_CXX_FLAGS MATCHES "-fsanitize=address")
  message(STATUS "[SANITIZER] ASAN detected - disabling /INCREMENTAL for MSVC.")
  if(MSVC)
    add_link_options(/INCREMENTAL:NO)
  endif()
endif()

if(ENABLE_FUZZING)
  message(STATUS "[SANITIZER] Fuzzing enabled - applying fuzzer flags.")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=fuzzer")
endif()

# ----------------------------------------------------------------------
# Spectre Variant 1 Mitigation (Optional Hardening)
# ----------------------------------------------------------------------

option(ENABLE_SPECTRE_MITIGATION "Enable /Qspectre on MSVC for Spectre V1 mitigation" OFF)

if(MSVC AND ENABLE_SPECTRE_MITIGATION)
  message(STATUS "[HARDENING] Spectre mitigation enabled: /Qspectre")
  add_compile_options(/Qspectre)
endif()

# ----------------------------------------------------------------------
# Host Environment Diagnostics
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Environment Diagnostics ###")

# Detect path separator
set(PATH_SEPARATOR $<IF:$<BOOL:${WIN32}>,";",":">)

# Pretty-print the PATH variable (numbered entries)
string(REPLACE "${PATH_SEPARATOR}" ";" PATH_LIST "$ENV{PATH}")
list(LENGTH PATH_LIST PATH_LENGTH)

message(STATUS "PATH Entries:")
foreach(INDEX RANGE 0 [expr ${PATH_LENGTH} - 1])
  list(GET PATH_LIST ${INDEX} PATH_ENTRY)
  message(STATUS "  [${INDEX}] ${PATH_ENTRY}")
endforeach()

# Core CMake Environment Variables
message(STATUS "CMAKE_PREFIX_PATH        : ${CMAKE_PREFIX_PATH}")
message(STATUS "CMAKE_INSTALL_PREFIX     : ${CMAKE_INSTALL_PREFIX}")
message(STATUS "CMAKE_MODULE_PATH        : ${CMAKE_MODULE_PATH}")

# ----------------------------------------------------------------------
# Compiler and Toolchain Diagnostics
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Compiler & Toolchain Info ###")
message(STATUS " C++ Compiler           : ${CMAKE_CXX_COMPILER}")
message(STATUS "C++ Compiler ID         : ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "C++ Compiler Version    : ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS " C Compiler             : ${CMAKE_C_COMPILER}")
message(STATUS "C Compiler Version      : ${CMAKE_C_COMPILER_VERSION}")
message(STATUS "Linker                  : ${CMAKE_LINKER}")

# ----------------------------------------------------------------------
# Platform-Specific Diagnostics
# ----------------------------------------------------------------------

if(APPLE)
  message(STATUS "")
  message(STATUS "### macOS Specific Details ###")
  message(STATUS " macOS SDK Path         : ${CMAKE_OSX_SYSROOT}")
  message(STATUS "Deployment Target       : ${CMAKE_OSX_DEPLOYMENT_TARGET}")
endif()

if(WIN32)
  message(STATUS "")
  message(STATUS "### Windows Specific Details ###")
  message(STATUS "Windows SDK Version     : ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}")

  if(DEFINED ENV{MSBUILD_PATH})
    message(STATUS "MSBuild Path            : $ENV{MSBUILD_PATH}")
  else()
    message(WARNING " MSBuild Path is not defined in environment variables.")
  endif()

  message(STATUS "Linker Flags            : ${CMAKE_EXE_LINKER_FLAGS}")
endif()

if(UNIX AND NOT APPLE)
  message(STATUS "")
  message(STATUS "### Linux/Unix Specific Details ###")
  execute_process(
    COMMAND uname -a
    OUTPUT_VARIABLE LINUX_SYSTEM_INFO
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  message(STATUS " System Info            : ${LINUX_SYSTEM_INFO}")
  message(STATUS " C++ Compiler           : ${CMAKE_CXX_COMPILER}")
  message(STATUS "Linker Flags            : ${CMAKE_EXE_LINKER_FLAGS}")
endif()

# ----------------------------------------------------------------------
# Cross-Platform Debugging Summary
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Cross-Platform Debugging ###")
message(STATUS "Build Type              : ${CMAKE_BUILD_TYPE}")
message(STATUS "Install Prefix          : ${CMAKE_INSTALL_PREFIX}")
message(STATUS "Build Generator         : ${CMAKE_GENERATOR}")
message(STATUS " Build Tool             : ${CMAKE_MAKE_PROGRAM}")

# ----------------------------------------------------------------------
# Build Configuration Summary
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Build Configuration ###")
message(STATUS "Build Type              : ${CMAKE_BUILD_TYPE}")
message(STATUS "C++ Standard            : C++${CMAKE_CXX_STANDARD}")
message(STATUS "C++ Flags               : ${CMAKE_CXX_FLAGS}")
message(STATUS "C Flags                 : ${CMAKE_C_FLAGS}")
message(STATUS "Active Config Flags     : ${CMAKE_CXX_FLAGS_${CMAKE_BUILD_TYPE}}")

# ----------------------------------------------------------------------
# Feature Flag Configuration
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Feature Flags ###")
message(STATUS "Enable Tools            : ${ENABLE_TOOLS}")
message(STATUS "Enable Tests            : ${ENABLE_TESTS}")
message(STATUS "Enable Shared Libraries : ${ENABLE_SHARED_LIBS}")
message(STATUS "Enable Static Libraries : ${ENABLE_STATIC_LIBS}")

# ----------------------------------------------------------------------
# Third-Party Dependencies
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Dependency Summary ###")

# --- LibXml2 ---
find_package(LibXml2 REQUIRED)
message(STATUS "LibXml2                : ${LIBXML2_LIBRARIES} (version: ${LIBXML2_VERSION})")

# --- nlohmann_json ---
find_package(nlohmann_json REQUIRED)
message(STATUS "nlohmann_json          : ${nlohmann_json_DIR} (version: ${nlohmann_json_VERSION})")

# --- TIFF ---
find_package(TIFF REQUIRED)
message(STATUS " TIFF                  : ${TIFF_LIBRARIES} (version: ${TIFF_VERSION})")
message(STATUS "TIFF Include Directory : ${TIFF_INCLUDE_DIR}")

# --- PNG ---
message(STATUS "Checking for PNG...")
find_package(PNG REQUIRED)

if(PNG_FOUND)
  message(STATUS " PNG Library           : ${PNG_LIBRARIES}")
  message(STATUS "PNG Include Directory  : ${PNG_INCLUDE_DIRS}")
  message(STATUS "PNG Version            : ${PNG_VERSION}")
else()
  message(FATAL_ERROR " PNG not found. Please install libpng-dev or install via vcpkg.")
endif()

# ----------------------------------------------------------------------
# Include Directories
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Include Paths ###")
message(STATUS "IccProfLib             : ${PROJECT_ROOT_DIR}/IccProfLib")
message(STATUS "IccXML                 : ${PROJECT_ROOT_DIR}/IccXML")

# ----------------------------------------------------------------------
# Link Directories
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Link Paths ###")
message(STATUS "IccProfLib             : ${CMAKE_BINARY_DIR}/IccProfLib")
message(STATUS "IccXML                 : ${CMAKE_BINARY_DIR}/IccXML")
message(STATUS "Fallback               : /usr/local/lib")

# ----------------------------------------------------------------------
# Debug Library Paths
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Debug Library Paths ###")
message(STATUS " IccProfLib Debug Path : ${PROJECT_ROOT_DIR}/Build/IccProfLib")
message(STATUS " IccXML Debug Path     : ${PROJECT_ROOT_DIR}/Build/IccXML")

# ----------------------------------------------------------------------
# CI/CD Environment Detection
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### CI/CD Integration ###")

if(DEFINED ENV{CI})
  message(STATUS " CI/CD Detected")
  message(STATUS "Build Number           : $ENV{BUILD_NUMBER}")
  message(STATUS "Branch Name            : $ENV{BRANCH_NAME}")
  message(STATUS "Commit Hash            : $ENV{GIT_COMMIT}")
  message(STATUS "Pipeline URL           : $ENV{CI_PIPELINE_URL}")
else()
  message(STATUS " CI/CD Integration      : Not Detected")
endif()

# ----------------------------------------------------------------------
# System Install Paths via GNUInstallDirs
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS " Initializing Install Paths with GNUInstallDirs...")
include(GNUInstallDirs)
message(STATUS "GNU Install Include Dir: ${CMAKE_INSTALL_INCLUDEDIR}")
message(STATUS "GNU Install Library Dir: ${CMAKE_INSTALL_LIBDIR}")
message(STATUS "GNU Install CMake Dir  : ${CMAKE_INSTALL_DATAROOTDIR}/cmake")

# ----------------------------------------------------------------------
# Build Feature Toggles
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Build Options ###")

option(ENABLE_TESTS           "Build tests (requires static libs)" ON)
option(ENABLE_TOOLS           "Build tools (command-line + GUI)"   ON)
option(ENABLE_SHARED_LIBS     "Build dynamic link libraries"       ON)
option(ENABLE_STATIC_LIBS     "Build static libraries"             ON)
option(ENABLE_ICCXML          "Build IccXML library support"       ON)

message(STATUS "ENABLE_TESTS            = ${ENABLE_TESTS}")
message(STATUS " ENABLE_TOOLS            = ${ENABLE_TOOLS}")
message(STATUS "ENABLE_SHARED_LIBS      = ${ENABLE_SHARED_LIBS}")
message(STATUS "ENABLE_STATIC_LIBS      = ${ENABLE_STATIC_LIBS}")
message(STATUS "ENABLE_ICCXML           = ${ENABLE_ICCXML}")

# ----------------------------------------------------------------------
# Build Context Detection: Top-Level vs Subproject
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Build Context Check ###")

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
  # Top-level project: full install/build mode
  option(ENABLE_INSTALL_RIM "Enable install target for RefIccMAX." ON)
  message(STATUS "RefIccMAX is being built as a top-level project.")
  message(STATUS "ENABLE_INSTALL_RIM      = ${ENABLE_INSTALL_RIM}")
else()
  # Subproject: disable install to avoid polluting parent build
  set(ENABLE_INSTALL_RIM OFF CACHE BOOL "Install disabled in subproject mode" FORCE)
  set(ENABLE_STATIC_LIBS ON  CACHE BOOL "Force static linking in subproject" FORCE)
  set(ENABLE_SHARED_LIBS OFF CACHE BOOL "Disable shared libs in subproject" FORCE)
  message(STATUS "RefIccMAX included as subproject - installation is disabled.")
  message(STATUS "ENABLE_INSTALL_RIM      = ${ENABLE_INSTALL_RIM}")
  message(STATUS "ENABLE_STATIC_LIBS      = ${ENABLE_STATIC_LIBS}")
  message(STATUS "ENABLE_SHARED_LIBS      = ${ENABLE_SHARED_LIBS}")
endif()

# ----------------------------------------------------------------------
# Default Build Type Enforcement
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Enforcing Default Build Type ###")
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
  message(STATUS "No build type specified. Defaulting to: ${CMAKE_BUILD_TYPE}")
else()
  message(STATUS " Build type explicitly set to: ${CMAKE_BUILD_TYPE}")
endif()

# ----------------------------------------------------------------------
# Compiler Flag Setup (Baseline)
# ----------------------------------------------------------------------

message(STATUS "")
message(STATUS "### Initializing Compiler Flags ###")
# Allow per-config extensions
set(CMAKE_CXX_FLAGS_DEBUG   "${CMAKE_CXX_FLAGS_DEBUG}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")


# Platform-Specific Flags
if(MSVC)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MDd /Zi /Ob0 /Od /RTC1")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MD /O2 /Ob2 /DNDEBUG")
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
    message(STATUS "Configuring MSVC runtime and flags")
elseif(UNIX)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -O0 -Wall -Wextra -DDEBUG")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -DNDEBUG")
    message(STATUS "Configuring GCC/Clang runtime and flags")
endif()

# Architecture determination
if(APPLE)
  message(STATUS "Detected platform: macOS")
  execute_process(
    COMMAND uname -m
    COMMAND tr -d '\n'
    OUTPUT_VARIABLE OSX_ARCHITECTURE
  )
  if("${OSX_ARCHITECTURE}" STREQUAL "arm64")
    message(STATUS "Configuring build for ARM64 architecture.")
    set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "macOS architecture")
    add_compile_definitions(ARM64)
  elseif("${OSX_ARCHITECTURE}" STREQUAL "x86_64")
    message(STATUS "Configuring build for X86_64 architecture.")
    set(CMAKE_OSX_ARCHITECTURES "x86_64" CACHE STRING "macOS architecture")
  else()
    message(FATAL_ERROR "Unsupported macOS architecture: ${OSX_ARCHITECTURE}")
  endif()
  message(STATUS "Final macOS Architecture: ${CMAKE_OSX_ARCHITECTURES}")
elseif(UNIX AND NOT APPLE)
  message(STATUS "Detected platform: Linux")
  add_compile_options(-std=c++17 -Wall -Wextra -Wpedantic)
  message(STATUS "Linux build: Compiler flags set to C++17 with standard warnings.")
elseif(WIN32)
  message(STATUS "Detected platform: Windows")
  add_compile_options(/std:c++17 /D_WINDOWS /EHsc)
  message(STATUS "Windows build: Compiler flags set to C++17 with MSVC-specific flags.")
else()
  message(FATAL_ERROR "Unsupported platform!")
endif()

message(STATUS "Debug Configuration")
# Debug configuration
if(CMAKE_BUILD_TYPE MATCHES "[Dd][Ee][Bb][Uu][Gg]")
  message("-- Info: Debug build \"${CMAKE_BUILD_TYPE}\"")
  set(DEBUG 1)
  add_definitions(-D_DEBUG)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
endif()

message(STATUS "Sanitizer Configuration")
# Sanitizer support (Optional, for Linux/Unix-like systems)
if(UNIX AND NOT APPLE AND CMAKE_BUILD_TYPE MATCHES "[Dd][Ee][Bb][Uu][Gg]")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=address,undefined -fno-omit-frame-pointer")
  message(STATUS "Sanitizers enabled for Debug build.")
endif()

# Prevent old-style path-based linking
unset(IccProfLib2_LIBRARIES CACHE)
unset(IccProfLib2_LIBRARY CACHE)
unset(IccProfLib2_LIB CACHE)
unset(IccProfLib2 CACHE)

#
# Target installation folders
#

SET (TARGET_INCLUDE_FOLDER
    ${PROJECT_NAME}
    CACHE STRING
    "Optional folder below system include folder to install include files."
    )

IF(NOT CMAKE_MODULES_INSTALL_DIR)
  SET (CMAKE_MODULES_INSTALL_DIR
    "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_DOWN_NAME}"
    CACHE STRING
    "The folder where to install cmake files."
    )
ENDIF(NOT CMAKE_MODULES_INSTALL_DIR)


SET (TARGET_PKGCONFIG_FOLDER
    "pkgconfig"
    CACHE STRING
    "The folder below system library folder where to install pkgconfig files."
    )

SET (TARGET_DOCUMENTATION_FOLDER
    "share/doc/${PACKAGE_NAME}-api"
    CACHE STRING
    "The folder below system prefix where to install api documentation files."
    )

# additional cmake modules for loading libraries
SET (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/Modules/")


SET( TOP_SOURCE_DIR ../.. )
INCLUDE_DIRECTORIES ( ${TOP_SOURCE_DIR}/IccProfLib/ )

# external dependencies
FIND_PROGRAM(CMAKE_AR_TMP NAMES ar)

#
# Core library
#
message(STATUS "Adding subdirectory for IccProfLib.")
add_subdirectory(IccProfLib)

# Set default link target for IccProfLib
# Use CACHE INTERNAL so that it's available in Tools/* subdirectories
set(TARGET_LIB_ICCPROFLIB IccProfLib2 CACHE INTERNAL "Link target for IccProfLib2")

#
# Optional external dependency: LibXML2
#
if(ENABLE_ICCXML)
  if(USE_SYSTEM_LIBXML2)
    find_package(LibXML2 REQUIRED)
  else()
    find_package(LibXML2)
  endif()

  if(LIBXML2_FOUND)
    include_directories(${LIBXML2_INCLUDE_DIR})
    link_directories(${LIBXML2_LIBRARY_DIRS})
    set(HAVE_LIBXML2 1)
  else()
    set(HAVE_LIBXML2 TRUE)
    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/IccXML/libxml2)
    link_directories(${CMAKE_CURRENT_BINARY_DIR}/IccXML/libxml2)
    add_subdirectory(IccXML/libxml2)
    set(LIBXML2_LIBRARIES xml2-static)
  endif()
endif()

#
# XML library
#
message(STATUS "Adding subdirectory for IccXML.")
add_subdirectory(IccXML)

# Set default link target for IccXML
set(TARGET_LIB_ICCXML IccXML2 CACHE INTERNAL "Link target for IccXML2")

# Ensure IccXML headers are available globally
include_directories(${TOP_SOURCE_DIR}/IccXML/IccLibXML/)

# Diagnostic: Output current linker flags
message(STATUS "CMAKE_EXE_LINKER_FLAGS = ${CMAKE_EXE_LINKER_FLAGS}")
message(STATUS "CMAKE_SHARED_LINKER_FLAGS = ${CMAKE_SHARED_LINKER_FLAGS}")
message(STATUS "CMAKE_MODULE_LINKER_FLAGS = ${CMAKE_MODULE_LINKER_FLAGS}")

# Ensure nlohmann_json is found
find_package(nlohmann_json REQUIRED)
message(STATUS "nlohmann_json library found: ${nlohmann_json_DIR}")

IF(ENABLE_TOOLS)
  # Verify nlohmann_json is configured properly
  IF(nlohmann_json_DIR)
    MESSAGE(STATUS "Found nlohmann JSON library at: ${nlohmann_json_DIR}")

    # Use nlohmann_json include directory
    include_directories(${nlohmann_json_DIR})

 message(STATUS "Adding IccApplyNamedCmm from: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyNamedCmm")

# Add subdirectory for IccApplyNamedCmm
IF(EXISTS "${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyNamedCmm")
  add_subdirectory(
    ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyNamedCmm
    ${CMAKE_BINARY_DIR}/Tools/IccApplyNamedCmm
  )
  message(STATUS "Added IccApplyNamedCmm")
ELSE()
  message(FATAL_ERROR "Directory does not exist: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyNamedCmm")
ENDIF()

    # Add IccApplyProfiles
    MESSAGE(STATUS "Adding IccApplyProfiles from: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles")
    IF(EXISTS "${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles")
      add_subdirectory(
        ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles
        ${CMAKE_BINARY_DIR}/Tools/IccApplyProfiles
      )
      MESSAGE(STATUS "Added IccApplyProfiles")
    ELSE()
      message(FATAL_ERROR "Directory does not exist: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles")
    ENDIF()
  ELSE()
    MESSAGE(WARNING "nlohmann JSON library not found. Skipping Tools/IccApplyNamedCmm and Tools/IccApplyProfiles.")
    RETURN() # Exit script for tools if dependency is not found
  ENDIF()

 # Function to add and log subdirectories
function(add_tool_subdirectory TOOL_SUBDIRECTORY)
    message(STATUS "Adding Subdirectory: ${TOOL_SUBDIRECTORY}...")
    add_subdirectory(${TOOL_SUBDIRECTORY})
    message(STATUS "Successfully added Subdirectory: ${TOOL_SUBDIRECTORY}")
endfunction()

  # Add remaining tools
  message(STATUS "Adding Subdirectory IccDumpProfile.")
  ADD_SUBDIRECTORY(Tools/IccDumpProfile)
  message(STATUS "Adding Subdirectory IccDumpRoundTrip.")
  ADD_SUBDIRECTORY(Tools/IccRoundTrip)
  message(STATUS "Adding Subdirectory IccFromCube.")
  ADD_SUBDIRECTORY(Tools/IccFromCube)
  message(STATUS "Adding Subdirectory IccV5DspObsToV4Dsp.")
  ADD_SUBDIRECTORY(Tools/IccV5DspObsToV4Dsp)
  message(STATUS "Adding Subdirectory IccApplyToLink.")
  ADD_SUBDIRECTORY(Tools/IccApplyToLink)
  # Add PNG Tools

# Check for PNG library
find_package(PNG REQUIRED)

if (PNG_FOUND)
    include_directories(${PNG_INCLUDE_DIRS})
    message(STATUS "PNG library found: ${PNG_LIBRARIES}")

    message(STATUS "Adding Subdirectory IccPngDump.")
    ADD_SUBDIRECTORY(Tools/IccPngDump)
else()
    message(FATAL_ERROR "PNG library not found. Please install libpng-dev.")
endif()

    message(STATUS "Adding Subdirectory DemoIccMAXCmm.")
    ADD_SUBDIRECTORY(Tools/DemoIccMAXCmm)


  # Check for TIFF library
  find_package(TIFF REQUIRED)
  if (TIFF_FOUND)
    include_directories(${TIFF_INCLUDE_DIR})
    message(STATUS "TIFF library found: ${TIFF_LIBRARIES}")

    # Add TIFF-dependent tools
#    ADD_SUBDIRECTORY(Tools/IccApplyProfiles)
    message(STATUS "Adding subdirectory IccSpecSepToTiff.")
    ADD_SUBDIRECTORY(Tools/IccSpecSepToTiff)
    message(STATUS "Adding Subdirectory IccTiffDump.")
    ADD_SUBDIRECTORY(Tools/IccTiffDump)
  else()
    message(FATAL_ERROR "TIFF library not found. Please install libtiff-dev.")
  endif()

  # Add XML-related tools
  message(STATUS "Adding Subdirectory IccFromXml.")
  ADD_SUBDIRECTORY(Tools/IccFromXml)
  message(STATUS "Adding Subdirectory IccToXml.")
  ADD_SUBDIRECTORY(Tools/IccToXml)

  # Configure wxWidgets
  find_package(wxWidgets COMPONENTS core base REQUIRED)
  if (wxWidgets_FOUND)
    include(${wxWidgets_USE_FILE})
      ADD_SUBDIRECTORY(Tools/wxProfileDump)
    message(STATUS "wxWidgets found and configured")
  else()
    message(FATAL_ERROR "wxWidgets not found. Please install it manually or via vcpkg.")
  endif()

ENDIF(ENABLE_TOOLS)


# Optionally add a description for the option
option(ENABLE_FUZZING "Enable fuzzing sanitizer" OFF)

if(ENABLE_FUZZING)
    message(STATUS "Fuzzing enabled")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=fuzzer")
endif()

IF( ENABLE_TESTS )
  ADD_SUBDIRECTORY( Testing )
ENDIF( ENABLE_TESTS )

CONFIGURE_FILE(
    "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}Uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Uninstall.cmake"
    IMMEDIATE @ONLY)

ADD_CUSTOM_TARGET( uninstall
  "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Uninstall.cmake")

IF( CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "64" )
  SET( ARCH 64 )
ELSE()
  SET( ARCH 32 )
ENDIF()
IF( NOT CMAKE_SYSTEM_NAME MATCHES Darwin )
  SET( GNUTAR_OPTS "--owner user:1000 --group group:500" )
ENDIF()
MESSAGE( "Configured ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}" )

ADD_CUSTOM_TARGET( dist-bin
    COMMAND test -d bin-temp && rm -rv bin-temp || echo "start fresh"
    COMMAND mkdir bin-temp && cd bin-temp && cmake -DENABLE_STATIC_LIBS=ON -DENABLE_SHARED_LIBS=OFF ${CMAKE_SOURCE_DIR} && make -j8 && make dist-bin2
    COMMAND ls -l bin-temp/${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing
    COMMAND echo "Dependencies for iccTiffDump:"
    COMMAND test ${CMAKE_SYSTEM_NAME} = Linux && ldd bin-temp/${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/iccTiffDump || echo ""
    COMMAND test ${CMAKE_SYSTEM_NAME} = Darwin && otool -L bin-temp/${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/iccTiffDump || echo ""
    COMMAND rm -r bin-temp
    COMMAND tar tzvf ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}.tar.gz
    COMMAND echo "We are in:"
    COMMAND pwd
    COMMAND ls -l ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}.tar.gz
    COMMENT Make a ${PROJECT_NAME} binary package
    VERBATIM
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    )

ADD_CUSTOM_TARGET( dist-bin2
    DEPENDS check
    COMMAND mkdir -p ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/IccApplyNamedCmm ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccApplyProfiles ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccApplyToLink ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccDumpProfile ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccDumpProfileGui ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/ || echo ""
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccFromXML ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccFromCube ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccToXml ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccRoundTrip ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccSpecSepToTiff ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccTiffDump ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccPngDump ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccV5DspObsToV4Dsp ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/CreateAllProfiles.sh ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/RunTests.sh ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND echo tar cf - ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/ --owner user:1000 --group group:500 | gzip -9 > ../${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}.tar.gz
    COMMAND tar cf - ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/ ${GNUTAR_OPTS} | gzip -9 > ../${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}.tar.gz
                COMMENT Helper for making a ${PROJECT_NAME} binary package
                VERBATIM
                WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
                )

#
# Misc.
#

#cmake settings for use by find_package
CONFIGURE_FILE (
                "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}Config.cmake.in"
                "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
                @ONLY
        )

IF(ENABLE_INSTALL_RIM)
  INSTALL ( FILES
                "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
                DESTINATION ${CMAKE_MODULES_INSTALL_DIR} COMPONENT dev
        )
ENDIF(ENABLE_INSTALL_RIM)
