#################################################################################
# iccPngDump Cmake Project Configuration| iccMAX Project
# Copyright (©) 2024-2025 The International Color Consortium. 
#                                        All rights reserved.
# 
#
# Last Updated: 01-AUG-2025 1800Z by David Hoyt
#
# Changes: 	WASM-specific for Testing
#           Fixup for PNG .a file location
#           Added CMakePresets.json for wasm-release
#						
#
#
#
#
#
#
#
#################################################################################

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
message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")

# Set the target name
set(TARGET_NAME iccPngDump)
message(STATUS "Added executable target: ${TARGET_NAME}")

# Include source directories
include_directories(
    ${SRC_PATH}/Tools/CmdLine/IccPngDump/
    ${SRC_PATH}/Libraries/IccProfLib/
)

# Explicitly handle native-only include paths
if(NOT EMSCRIPTEN)
  include_directories(
    /usr/include
    /usr/local/include
  )
endif()

message(STATUS "Include directories added for ${TARGET_NAME}")

# WASM-specific static linkage
if(EMSCRIPTEN)
  # Fix: use Cmake/third_party path, consistent with build steps
  set(THIRD_PARTY_DIR "${CMAKE_SOURCE_DIR}/Cmake/third_party")

  set(PNG_LIBRARY "${THIRD_PARTY_DIR}/libpng/out/lib/libpng16.a" CACHE FILEPATH "Manual override for libpng16.a")
  set(PNG_INCLUDE_DIR "${THIRD_PARTY_DIR}/libpng/out/include" CACHE PATH "Manual override for libpng include path")

  set(ZLIB_LIBRARY "${THIRD_PARTY_DIR}/zlib/out/lib/libz.a" CACHE FILEPATH "Manual override for zlib.a")
  set(ZLIB_INCLUDE_DIR "${THIRD_PARTY_DIR}/zlib" CACHE PATH "Manual override for zlib include path")

  include_directories(${PNG_INCLUDE_DIR})
  include_directories(${ZLIB_INCLUDE_DIR})

  # Sanity check
  if(NOT EXISTS "${PNG_LIBRARY}")
    message(FATAL_ERROR "Missing PNG static library: ${PNG_LIBRARY}")
  endif()
  if(NOT EXISTS "${ZLIB_LIBRARY}")
    message(FATAL_ERROR "Missing ZLIB static library: ${ZLIB_LIBRARY}")
  endif()
endif()

# Add the executable
add_executable(${TARGET_NAME} ${SOURCES})

# Link libraries
target_link_libraries(${TARGET_NAME}
  ${TARGET_LIB_ICCPROFLIB}
  ${PNG_LIBRARY}
  ${ZLIB_LIBRARY}
)

message(STATUS "Libraries linked for ${TARGET_NAME}")

# Optional installation
if(ENABLE_INSTALL_RIM)
  install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
