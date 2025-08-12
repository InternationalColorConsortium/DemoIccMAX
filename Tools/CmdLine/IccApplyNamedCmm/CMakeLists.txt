# 
# IccApplyNamedCmm CMakeLists.txt | iccDEV Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
# 
#
# Last Updated: 12-AUGUST-2025 1600Z by David Hoyt
#
# Changes: 	Modify iccMAX to iccDEV
#						
#						
# TODO: Refactor Debug, Release, Asan 
# 			Collapse 3-tier CMakeLists.txt, Housekeeping
#				Refactor Base Configs & logging to .mk's 
#

# cmake_minimum_required(VERSION 3.5)
project(iccApplyNamedCmm)

# set(CMAKE_CXX_STANDARD 17)
# set(CMAKE_CXX_STANDARD_REQUIRED ON)


# Set the path for nlohmann-json
# set(CMAKE_PREFIX_PATH "/usr/local/Cellar/nlohmann-json/3.11.3")

# Find nlohmann-json
find_package(nlohmann_json REQUIRED)

# Sources
set(SOURCES
  ${CMAKE_CURRENT_SOURCE_DIR}/iccApplyNamedCmm.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/../IccCommon/IccJsonUtil.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/../IccCommon/IccCmmConfig.cpp
)

# Define the executable
add_executable(iccApplyNamedCmm ${SOURCES})

# Include directories
target_include_directories(iccApplyNamedCmm PRIVATE)

# Link directories
target_link_directories(iccApplyNamedCmm PRIVATE)

# Link libraries
target_link_libraries(iccApplyNamedCmm PRIVATE
  IccProfLib2
  IccXML2
  nlohmann_json::nlohmann_json
)

# Compiler options
target_compile_options(iccApplyNamedCmm PRIVATE)

# Linker options
target_link_options(iccApplyNamedCmm PRIVATE)
