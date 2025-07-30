set(SRC_PATH ../../../..)
set(SOURCES
    ${SRC_PATH}/Tools/CmdLine/IccSpecSepToTiff/iccSpecSepToTiff.cpp
    ${SRC_PATH}/Tools/CmdLine/IccApplyProfiles/TiffImg.cpp
)

set(TARGET_NAME iccSpecSepToTiff)
include_directories(${SRC_PATH}/Tools/CmdLine/IccApplyProfiles)

add_executable(${TARGET_NAME} ${SOURCES})
target_link_libraries(${TARGET_NAME}
    ${TARGET_LIB_ICCPROFLIB}
    ${TIFF_LIBRARY}
    ${JPEG_LIBRARY}
    ${ZLIB_LIBRARY}
)

if(ENABLE_INSTALL_RIM)
    install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
