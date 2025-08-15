#
# IccApplyNamedCmm CMakeLists.txt | DemoIccMAX Project
# Copyright (©) 2024 The International Color Consortium. All rights reserved.
#
#
# Last Updated: 09-APRIL-2025 at 1300 EDT by David Hoyt
#
# Changes:      Added JSON Dependency
#               Adjusted Cross Platform Build Args
#
#
#
#
#

# Check if the target is already defined before adding it
if(NOT TARGET iccApplyNamedCmm)
  set(SRC_PATH ../../../..)

  set(SOURCES
    ${SRC_PATH}/Tools/CmdLine/IccApplyNamedCmm/iccApplyNamedCmm.cpp
    ${SRC_PATH}/Tools/CmdLine/IccCommon/IccCmmConfig.cpp
    ${SRC_PATH}/Tools/CmdLine/IccCommon/IccJsonUtil.cpp
  )

  set(TARGET_NAME iccApplyNamedCmm)

  include_directories(${SRC_PATH}/Tools/CmdLine/IccApplyProfiles/)

  add_executable(${TARGET_NAME} ${SOURCES})
  target_link_libraries(${TARGET_NAME} ${TARGET_LIB_ICCPROFLIB})

  if(ENABLE_INSTALL_RIM)
    install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
  endif()
endif()
