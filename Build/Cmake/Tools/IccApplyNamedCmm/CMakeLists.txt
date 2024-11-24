# 
# IccApplyNamedCmm CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
# 
#
# Last Updated: 2024-11-24 by David Hoyt
#
# Changes: 	Added JSON Dependency
#						Adjusted Cross Platform Build Args
#						
# TODO: Refactor Debug, Release, Asan 
# 			Collapse 3-tier CMakeLists.txt, Housekeeping
#				Refactor Base Configs & logging to .mk's 
#

# Check if the target is already defined before adding it
IF(NOT TARGET iccApplyNamedCmm)
  SET(SRC_PATH ../../../..)
  SET(SOURCES ${SRC_PATH}/Tools/CmdLine/IccApplyNamedCmm/iccApplyNamedCmm.cpp)
  SET(TARGET_NAME iccApplyNamedCmm)

  ADD_EXECUTABLE(${TARGET_NAME} ${SOURCES})
  TARGET_LINK_LIBRARIES(${TARGET_NAME} ${TARGET_LIB_ICCPROFLIB})

  IF(ENABLE_INSTALL_RIM)
    INSTALL(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
  ENDIF(ENABLE_INSTALL_RIM)
ENDIF()
