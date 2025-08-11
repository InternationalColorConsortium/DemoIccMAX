#################################################################################
# iccPngDump Cmake Project Configuration| iccMAX Project
# Copyright (©) 2024-2025 The International Color Consortium. 
#                                        All rights reserved.
# 
#
# Last Updated: 24-MAR-2025 1200 EDT by David Hoyt
#
# Changes: 	Modified output target to fix a few subproject pathing issues
#           Added to CMakelists.txt: IccPngDump
#           Adjusted Cross Platform Build Args
#						
# TODO: Refactor Debug, Release, Asan, subproject pathing issues
#       Collapse 3-tier CMakeLists.txt, Housekeeping
#       Refactor Base Configs & logging to .mk's 
#
#
#
#
#################################################################################

# Set the project name
project(iccPngDump)

# Define the source path
set(SRC_PATH ../../../..)
set(SOURCES
    ${SRC_PATH}/Tools/CmdLine/IccPngDump/iccPngDump.cpp
)

# Resolve project root directory
get_filename_component(PROJECT_ROOT_DIR "${CMAKE_SOURCE_DIR}/../.." ABSOLUTE)
# message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")

# Set the target name
set(TARGET_NAME iccPngDump)
# message(STATUS "Added executable target: ${TARGET_NAME}")

# Include directories
include_directories(
    ${SRC_PATH}/Tools/CmdLine/IccPngDump/
    ${SRC_PATH}/Libraries/IccProfLib/
    /usr/include
    /usr/local/include
)

# message(STATUS "Include directories added for ${TARGET_NAME}")

# Find required libraries
find_package(PNG REQUIRED)

# Add executable
add_executable(${TARGET_NAME} ${SOURCES})

# Link libraries
target_link_libraries(${TARGET_NAME} ${TARGET_LIB_ICCPROFLIB} ${PNG_LIBRARY})

# message(STATUS "Libraries linked for ${TARGET_NAME}")

# Set output directories
# set_target_properties(${TARGET_NAME} PROPERTIES
#    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${PROJECT_ROOT_DIR}/Testing/Release"
#    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${PROJECT_ROOT_DIR}/Testing/Debug"
# )
# message(STATUS "Output directories set for ${TARGET_NAME}")

# Optional installation rule
if(ENABLE_INSTALL_RIM)
    install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
endif(ENABLE_INSTALL_RIM)
