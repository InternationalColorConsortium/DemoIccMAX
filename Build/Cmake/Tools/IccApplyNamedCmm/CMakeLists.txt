# 
# IccApplyNamedCmm CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
# 
#
# Last Updated: 01-AUGUST-2025 at 0500Z by David Hoyt
#
# Changes: 	Remove hardcoded build args and debugging output from my prior commit
#						
#						
# TODO: Refactor Debug, Release, Asan 
# 			Collapse 3-tier CMakeLists.txt, Housekeeping
#				Refactor Base Configs & logging to .mk's 
#
#
#
#
#
#
#

# cmake_minimum_required(VERSION 3.5)
project(iccApplyNamedCmm)
set(TARGET_NAME iccApplyNamedCmm)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(nlohmann_json REQUIRED)

set(SOURCES
  ${CMAKE_CURRENT_SOURCE_DIR}/iccApplyNamedCmm.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/../IccCommon/IccJsonUtil.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/../IccCommon/IccCmmConfig.cpp
)

add_executable(iccApplyNamedCmm ${SOURCES})

# Only add these if you have actual directories or options to specify
# target_include_directories(iccApplyNamedCmm PRIVATE <include_dir>)
# target_link_directories(iccApplyNamedCmm PRIVATE <lib_dir>)
# target_compile_options(iccApplyNamedCmm PRIVATE <options>)
# target_link_options(iccApplyNamedCmm PRIVATE <options>)

target_link_libraries(iccApplyNamedCmm PRIVATE
  IccProfLib2
  IccXML2
  nlohmann_json::nlohmann_json
)
