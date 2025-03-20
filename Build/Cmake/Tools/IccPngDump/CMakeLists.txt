#
# IccToXml in Project_Root/Build/Cmake/Tools/IccPngDump/CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024-2025 David H Hoyt LLC. All rights reserved.
#
# Last Updated: 06-MAR-2025 1937 EDT by David Hoyt
#
# Changes: Modified Cmake Configuration at top and project level
#          Added explicit linker paths
#          Improved debug output for cross-platform support
#
#
# TODO: Configure proper verbose flags for cmake config
#
#
#

cmake_minimum_required(VERSION 3.10)

# Set the project name
project(iccPngDump)

# Define the source path
set(SRC_PATH ../../../..)
set(SOURCES
    ${SRC_PATH}/Tools/CmdLine/IccPngDump/iccPngDump.cpp
)

# Resolve project root directory
get_filename_component(PROJECT_ROOT_DIR "${CMAKE_SOURCE_DIR}/../.." ABSOLUTE)
message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")

# Set the target name
set(TARGET_NAME iccPngDump)
message(STATUS "Added executable target: ${TARGET_NAME}")

# Include directories
include_directories(
    ${SRC_PATH}/Tools/CmdLine/IccPngDump/
    ${SRC_PATH}/Libraries/IccProfLib/
    /usr/include
    /usr/local/include
)

message(STATUS "Include directories added for ${TARGET_NAME}")

# Find required libraries
find_package(PNG REQUIRED)

# Add executable
add_executable(${TARGET_NAME} ${SOURCES})

# Link libraries
target_link_libraries(${TARGET_NAME} ${TARGET_LIB_ICCPROFLIB} ${PNG_LIBRARY})

message(STATUS "Libraries linked for ${TARGET_NAME}")

# Set output directories
# set_target_properties(${TARGET_NAME} PROPERTIES
#    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${PROJECT_ROOT_DIR}/Testing/Release"
#    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${PROJECT_ROOT_DIR}/Testing/Debug"
# )
message(STATUS "Output directories set for ${TARGET_NAME}")

# Optional installation rule
if(ENABLE_INSTALL_RIM)
    install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
endif(ENABLE_INSTALL_RIM)

message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")
message(STATUS "CMAKE_SOURCE_DIR resolved as: ${CMAKE_SOURCE_DIR}")
message(STATUS "SRC_PATH resolved as: ${SRC_PATH}")
message(STATUS "Resolved source file path: ${SOURCES}")
message(STATUS "Added executable target: ${TARGET_NAME}")
message(STATUS "")