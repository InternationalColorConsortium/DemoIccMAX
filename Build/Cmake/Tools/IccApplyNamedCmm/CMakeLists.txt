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
option(ENABLE_ICCAPPLYNAMEDCMM "Build iccApplyNamedCmm tool" ON)

if(ENABLE_ICCAPPLYNAMEDCMM)
  set(NLOHMANN_JSON_INCLUDE_DIR "${CMAKE_BINARY_DIR}/_deps/nlohmann_json-src/include")

  if(EXISTS "${NLOHMANN_JSON_INCLUDE_DIR}/nlohmann/json.hpp")
    include_directories(${NLOHMANN_JSON_INCLUDE_DIR})

    if(NOT TARGET iccApplyNamedCmm)
      set(SRC_PATH ../../../..)

      set(SOURCES
        ${SRC_PATH}/Tools/CmdLine/IccApplyNamedCmm/iccApplyNamedCmm.cpp
        ${SRC_PATH}/Tools/CmdLine/IccCommon/IccCmmConfig.cpp
        ${SRC_PATH}/Tools/CmdLine/IccCommon/IccJsonUtil.cpp
      )

      set(TARGET_NAME iccApplyNamedCmm)

      include_directories(${SRC_PATH}/Tools/CmdLine/IccCommon)

      add_executable(${TARGET_NAME} ${SOURCES})
      target_link_libraries(${TARGET_NAME} ${TARGET_LIB_ICCPROFLIB})

      if(TIFF_LIBRARY)
        message(STATUS "Linking TIFF_LIBRARY: ${TIFF_LIBRARY}")
        target_link_libraries(${TARGET_NAME} ${TIFF_LIBRARY})
      endif()

      if(ENABLE_INSTALL_RIM)
        install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
      endif()
    else()
      message(WARNING "Target ${TARGET_NAME} already exists. Skipping duplicate addition.")
    endif()
  else()
    message(WARNING "Skipping iccApplyNamedCmm: json.hpp not found in ${NLOHMANN_JSON_INCLUDE_DIR}/nlohmann/")
  endif()
endif()
