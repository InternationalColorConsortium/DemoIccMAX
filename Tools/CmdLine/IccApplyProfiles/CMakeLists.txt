# 
# IccApplyProfiles CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
# 
#
# Last Updated: 03-DEC-2024 by David Hoyt
#
# Changes: 	Remove hardcoded build args and debugging output from my prior commit
#						
#						
# TODO: Refactor Debug, Release, Asan 
# 			Collapse 3-tier CMakeLists.txt, Housekeeping
#				Refactor Base Configs & logging to .mk's 
#

project(iccApplyProfiles)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Ensure architecture compatibility on macOS
# if(APPLE)
#  set(CMAKE_OSX_ARCHITECTURES "x86_64")
# endif()

# Locate required libraries
find_package(nlohmann_json REQUIRED)
find_package(TIFF REQUIRED)

# Debugging information for located packages
message(STATUS "TIFF include directory: ${TIFF_INCLUDE_DIR}")
message(STATUS "TIFF libraries: ${TIFF_LIBRARIES}")
message(STATUS "nlohmann_json library found: ${nlohmann_json_DIR}")

# Define source files for iccApplyProfiles
set(SOURCES
  ${CMAKE_CURRENT_SOURCE_DIR}/iccApplyProfiles.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/../IccCommon/IccJsonUtil.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/../IccCommon/IccCmmConfig.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/TiffImg.cpp
)

# Define the executable
add_executable(iccApplyProfiles ${SOURCES})

# Include directories
target_include_directories(iccApplyProfiles PRIVATE
  ${CMAKE_SOURCE_DIR}/../../../IccProfLib  # Custom ICC profile library
  ${CMAKE_SOURCE_DIR}/../../../IccXML     # Custom XML processing library
  ${TIFF_INCLUDE_DIR}                     # Include libtiff headers
)

# Link directories (if required)
target_link_directories(iccApplyProfiles PRIVATE
  ${CMAKE_SOURCE_DIR}/../../../Build/IccProfLib
  ${CMAKE_SOURCE_DIR}/../../../Build/IccXML
)

# Link libraries
target_link_libraries(iccApplyProfiles PRIVATE
  IccProfLib2                         # Custom ICC profile library
  IccXML2                             # Custom XML processing library
  nlohmann_json::nlohmann_json        # JSON processing library
  ${TIFF_LIBRARIES}                   # libtiff
)

# Compiler options
target_compile_options(iccApplyProfiles PRIVATE)

# Linker options
target_link_options(iccApplyProfiles PRIVATE)

