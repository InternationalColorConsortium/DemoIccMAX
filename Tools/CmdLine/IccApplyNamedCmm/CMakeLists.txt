# 
# IccApplyNamedCmm CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
# 
#
# Last Updated: 02-DEC-2024 by David Hoyt
#
# Changes: 	Remove hardcoded build args and debugging output from my prior commit
#						
#						
# TODO: Refactor Debug, Release, Asan 
# 			Collapse 3-tier CMakeLists.txt, Housekeeping
#				Refactor Base Configs & logging to .mk's 
#

cmake_minimum_required(VERSION 3.5)
project(iccApplyNamedCmm)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


# Set the path for nlohmann-json
set(CMAKE_PREFIX_PATH "/usr/local/Cellar/nlohmann-json/3.11.3")

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
target_include_directories(iccApplyNamedCmm PRIVATE
  ${CMAKE_SOURCE_DIR}/../../../IccProfLib
  ${CMAKE_SOURCE_DIR}/../../../IccXML
  /usr/local/Cellar/nlohmann-json/3.11.3/include
)

# Link directories
target_link_directories(iccApplyNamedCmm PRIVATE
  ${CMAKE_SOURCE_DIR}/../../../Build/IccProfLib
  ${CMAKE_SOURCE_DIR}/../../../Build/IccXML
)

# Link libraries
target_link_libraries(iccApplyNamedCmm PRIVATE
  IccProfLib2
  IccXML2
  nlohmann_json::nlohmann_json
)

# Compiler options
target_compile_options(iccApplyNamedCmm PRIVATE)

# Linker options
target_link_options(iccApplyNamedCmm PRIVATE
  -L${CMAKE_SOURCE_DIR}/../../../Build/IccProfLib
  -L${CMAKE_SOURCE_DIR}/../../../Build/IccXML
)
