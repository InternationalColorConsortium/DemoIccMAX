SET( SRC_PATH ../../../.. )
SET( SOURCES  ${SRC_PATH}/Tools/CmdLine/IccCommon/IccCmmConfig.cpp
              ${SRC_PATH}/Tools/CmdLine/IccCommon/IccJsonUtil.cpp )
ADD_LIBRARY( ${PACKAGE_NAME}-tools-extra-static STATIC ${SOURCES} )

