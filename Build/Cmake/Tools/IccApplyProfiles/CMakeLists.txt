#
# IccApplyProfiles CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
#
#
# Last Updated: 09-APRIL-2025 1300 EDT  by David Hoyt
#
# Changes:      Added TIFF Dependency
#               Adjusted Cross Platform Build Args
#
#
# Found the missing Tiff Include Dep from AFL and Graph - DHOYT
#
#

# Check if the target is already defined before adding it
IF(NOT TARGET iccApplyProfiles)
  # Define the source path relative to this file
  SET(SRC_PATH ../../../..)
  SET(SOURCES ${SRC_PATH}/Tools/CmdLine/IccApplyProfiles/iccApplyProfiles.cpp
              ${SRC_PATH}/Tools/CmdLine/IccApplyProfiles/TiffImg.cpp )
  SET(TARGET_NAME iccApplyProfiles)

  # Define the executable target
  ADD_EXECUTABLE(${TARGET_NAME} ${SOURCES})

  # Link the necessary libraries to the target
  TARGET_LINK_LIBRARIES(${TARGET_NAME} ${TARGET_LIB_ICCPROFLIB}) ${TIFF_LIBRARY} )

  # Optional: Install the executable if enabled
  IF(ENABLE_INSTALL_RIM)
    INSTALL(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
  ENDIF()
ELSE()
  # Log a warning if the target already exists
  MESSAGE(WARNING "Target ${TARGET_NAME} already exists. Skipping duplicate addition.")
ENDIF()
