SET( SRC_PATH ../../../.. )
SET( SOURCES
        ${SRC_PATH}/Tools/CmdLine/IccCommon/IccCmmConfig.h
        ${SRC_PATH}/Tools/CmdLine/IccCommon/IccCmmConfig.cpp
        ${SRC_PATH}/Tools/CmdLine/IccCommon/IccJsonUtil.h
        ${SRC_PATH}/Tools/CmdLine/IccCommon/IccJsonUtil.cpp )

SET( TARGET_NAME IccCommon )
INCLUDE_DIRECTORIES ( ${SRC_PATH}/Tools/CmdLine/IccCommon/ )

ADD_EXECUTABLE( ${TARGET_NAME} ${SOURCES} )
TARGET_LINK_LIBRARIES( ${TARGET_NAME} ${TARGET_LIB_ICCPROFLIB} )

IF(ENABLE_INSTALL_RIM)
    INSTALL (TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
ENDIF(ENABLE_INSTALL_RIM)