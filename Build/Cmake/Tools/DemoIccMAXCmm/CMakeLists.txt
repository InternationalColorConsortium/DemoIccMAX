#################################################################################
# iccMAXCmm Cmake Project Configuration| iccMAX Project
# Copyright (©) 2024-2025 The International Color Consortium. 
#                                        All rights reserved.
# Last Updated: 14-MAR-2025 1007 EDT by David Hoyt
#
# Changes:  Modified Build/Cmake/CMakeLists.txt and others
# TODO :    Adjusted CMM build, wrapped build type in conditional
#           Debug to MinSizeRel and x64-Debug - IN PROCESS
#           Library path.part slightly hardcoded
#           Refactor for x64-MinSizeRel, x64-Debug, Unix/Win/macOS wrap
#           HARDCODED - Release or Debug, needs rel-debug wrapper
#           Refactor Debug, Release, Asan 
#           Collapse 3-tier CMakeLists.txt, Housekeeping
#           Refactor Base Configs & logging to .mk's
#
#
#
#
################################################################################

cmake_minimum_required(VERSION 3.16)
project(DemoIccMAXCmm)

# Detect OS and Set Source Paths (Only build on Windows, bypass macOS and Unix)
if (WIN32)
    message(STATUS "Configuring for Windows...")
    set(OS_SPECIFIC_SOURCES "${CMAKE_CURRENT_LIST_DIR}/../../../../Tools/Winnt/DemoIccMAXCmm")
else()
    message(STATUS "Skipping DemoIccMAXCmm build on non-Windows platforms.")
    add_custom_target(DemoIccMAXCmm)  # Create a dummy target to prevent dependency errors
    return()
endif()

# Compiler Settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_VERBOSE_MAKEFILE ON)

# Output Directory based on Configuration
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Tools/DemoIccMAXCmm/x64/$<CONFIG>")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Tools/DemoIccMAXCmm/x64/$<CONFIG>")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/Tools/DemoIccMAXCmm/x64/$<CONFIG>")

# Source Files
set(SOURCES
    "${OS_SPECIFIC_SOURCES}/DemoIccMAXCmm.cpp"
    "${OS_SPECIFIC_SOURCES}/DemoIccMAXCmm.rc"
    "${OS_SPECIFIC_SOURCES}/resource.h"
    "${OS_SPECIFIC_SOURCES}/DemoIccMAXCmm.h"
    "${OS_SPECIFIC_SOURCES}/stdafx.cpp"
    "${OS_SPECIFIC_SOURCES}/stdafx.h"
)

# Define Shared Library
add_library(${PROJECT_NAME} SHARED ${SOURCES})

# Ensure add_dependencies() is only called when the target exists
if (TARGET ${PROJECT_NAME})
    add_dependencies(${PROJECT_NAME} DemoIccMAXCmm)
endif()

# MSVC-Specific Settings
if (MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL$<$<CONFIG:Debug>:Debug>")
    set_source_files_properties("${OS_SPECIFIC_SOURCES}/stdafx.cpp" PROPERTIES COMPILE_FLAGS "/Ycstdafx.h /Fp${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/DemoIccMAXCmm.pch")
    foreach(SRC ${SOURCES})
        if(NOT SRC STREQUAL "${OS_SPECIFIC_SOURCES}/stdafx.cpp" AND SRC MATCHES "^.*\\.cpp$")
            set_source_files_properties("${SRC}" PROPERTIES COMPILE_FLAGS "/Yustdafx.h /Fp${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/DemoIccMAXCmm.pch")
        endif()
    endforeach()
    set_source_files_properties("${OS_SPECIFIC_SOURCES}/DemoIccMAXCmm.rc" PROPERTIES COMPILE_FLAGS "")
endif()

# Compiler Definitions
target_compile_definitions(${PROJECT_NAME} PRIVATE WIN32 _WINDOWS _USRDLL DemoIccMAXCmm_EXPORTS _MBCS)

# Include Directories
include_directories(${OS_SPECIFIC_SOURCES} ${TOP_SOURCE_DIR}/IccProfLib)

# Library Linking
target_link_libraries(${PROJECT_NAME} PRIVATE ${TARGET_LIB_ICCPROFLIB})
set(LINK_LIBS Mscms.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib)
target_link_options(${PROJECT_NAME} PRIVATE "/OUT:${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/DemoIccMAXCmm.dll" "/PDB:${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/DemoIccMAXCmm.pdb" "/DYNAMICBASE:NO" "/NODEFAULTLIB:LIBCMT")

target_link_libraries(${PROJECT_NAME} PRIVATE ${LINK_LIBS})
message(STATUS "Windows build configuration complete.")
