#
# IccTiffDump CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024-2025 The International Color Consortium. All rights reserved.
#
#
# Last Updated: 27-JULY-2025 at 2100Z by David Hoyt
#
# Changes:      Adjust Build Args for WASM
#
#
#
#
#
#

set(SRC_PATH ../../../..)

set(SOURCES
    ${SRC_PATH}/Tools/CmdLine/IccTiffDump/iccTiffDump.cpp
    ${SRC_PATH}/Tools/CmdLine/IccApplyProfiles/TiffImg.cpp
)

set(TARGET_NAME iccTiffDump)

# Always include local headers
include_directories(${SRC_PATH}/Tools/CmdLine/IccApplyProfiles)

# Conditionally include TIFF headers
if(TIFF_INCLUDE_DIR)
  message(STATUS "Using TIFF_INCLUDE_DIR: ${TIFF_INCLUDE_DIR}")
  include_directories(${TIFF_INCLUDE_DIR})
endif()

add_executable(${TARGET_NAME} ${SOURCES})

# Link required libraries
target_link_libraries(${TARGET_NAME}
    ${TARGET_LIB_ICCPROFLIB}
    ${TIFF_LIBRARY}
    ${JPEG_LIBRARY}
    ${ZLIB_LIBRARY}
)

if(ENABLE_INSTALL_RIM)
  install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
