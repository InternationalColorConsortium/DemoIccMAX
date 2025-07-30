# Option to enable/disable iccApplyProfiles tool
option(ENABLE_ICCAPPLYPROFILES "Build iccApplyProfiles tool" ON)

if(ENABLE_ICCAPPLYPROFILES)
  # Correct JSON include path
  set(NLOHMANN_JSON_INCLUDE_DIR "${CMAKE_BINARY_DIR}/_deps/nlohmann_json-src/include")

  if(EXISTS "${NLOHMANN_JSON_INCLUDE_DIR}/nlohmann/json.hpp")
    include_directories(${NLOHMANN_JSON_INCLUDE_DIR})

    if(NOT TARGET iccApplyProfiles)
      set(SRC_PATH ../../../..)
      set(SOURCES
        ${SRC_PATH}/Tools/CmdLine/IccApplyProfiles/iccApplyProfiles.cpp
        ${SRC_PATH}/Tools/CmdLine/IccApplyProfiles/TiffImg.cpp
        ${SRC_PATH}/Tools/CmdLine/IccCommon/IccJsonUtil.cpp
        ${SRC_PATH}/Tools/CmdLine/IccCommon/IccCmmConfig.cpp
      )
      set(TARGET_NAME iccApplyProfiles)

      # Add include path for IccJsonUtil.h and related headers
      include_directories(${SRC_PATH}/Tools/CmdLine/IccCommon)

      add_executable(${TARGET_NAME} ${SOURCES})
      target_link_libraries(${TARGET_NAME} ${TARGET_LIB_ICCPROFLIB})

      if(TIFF_LIBRARY)
        message(STATUS "Linking TIFF_LIBRARY: ${TIFF_LIBRARY}")
        target_link_libraries(${TARGET_NAME} ${TIFF_LIBRARY})
      endif()

      if(JPEG_LIBRARY)
        message(STATUS "Linking JPEG_LIBRARY: ${JPEG_LIBRARY}")
        target_link_libraries(${TARGET_NAME} ${JPEG_LIBRARY})
      endif()

      if(ZLIB_LIBRARY)
        message(STATUS "Linking ZLIB_LIBRARY: ${ZLIB_LIBRARY}")
        target_link_libraries(${TARGET_NAME} ${ZLIB_LIBRARY})
      endif()

      if(ENABLE_INSTALL_RIM)
        install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
      endif()
    else()
      message(WARNING "Target ${TARGET_NAME} already exists. Skipping duplicate addition.")
    endif()
  else()
    message(WARNING "Skipping iccApplyProfiles: json.hpp not found in ${NLOHMANN_JSON_INCLUDE_DIR}/nlohmann/")
  endif()
endif()
