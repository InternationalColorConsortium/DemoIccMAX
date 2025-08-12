#
# IccV5DspObsToV4Dsp CMakeLists.txt | iccDEV Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
#
#
# Last Updated: 12-AUGUST-2025 1600Z by David Hoyt
#
# Changes: Modify iccMAX to iccDEV
#
#
#
#
# TODO: Refactor Debug, Release, Asan
#                       Collapse 3-tier CMakeLists.txt, Housekeeping
#                               Refactor Base Configs & logging to .mk's
#

# Check if the target is already defined before adding it
IF(NOT TARGET iccV5DspObsToV4Dsp)
  SET(SRC_PATH ../../../..)
  SET(SOURCES ${SRC_PATH}/Tools/CmdLine/IccV5DspObsToV4Dsp/IccV5DspObsToV4Dsp.cpp)
  SET(TARGET_NAME iccV5DspObsToV4Dsp)

  ADD_EXECUTABLE(${TARGET_NAME} ${SOURCES})
  TARGET_LINK_LIBRARIES(${TARGET_NAME} ${TARGET_LIB_ICCPROFLIB})

  IF(ENABLE_INSTALL_RIM)
    INSTALL(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
  ENDIF(ENABLE_INSTALL_RIM)
ENDIF()
