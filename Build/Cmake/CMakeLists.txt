CMAKE_MINIMUM_REQUIRED (VERSION 2.8.5)

PROJECT (RefIccMAX)

SET( ${PROJECT_NAME}_MAJOR_VERSION 2)
SET( ${PROJECT_NAME}_MINOR_VERSION 1)
SET( ${PROJECT_NAME}_MICRO_VERSION 7)
SET( ${PROJECT_NAME}_VERSION ${${PROJECT_NAME}_MAJOR_VERSION}.${${PROJECT_NAME}_MINOR_VERSION}.${${PROJECT_NAME}_MICRO_VERSION} )

SET (PROJECT_UP_NAME "REFICCMAX" )
SET (PROJECT_DOWN_NAME "reficcmax" )
SET (PACKAGE_NAME "${PROJECT_DOWN_NAME}" )
SET (PACKAGE_DESCRIPTION "The RefIccMAX project provides an open source set of
libraries and tools that allow for the interaction, manipulation, and
application of iccMAX based color management profiles based on the iccMAX
profile specification http://www.color.org/iccmax.xalter
in addition to legacy ICC profiles defined by earlier ICC profile
specifications ")

SET( ${PROJECT_NAME}_VERSION_MAJORMINOR "${${PROJECT_NAME}_MAJOR_VERSION}.${${PROJECT_NAME}_MINOR_VERSION}" )

include(GNUInstallDirs)

option(ENABLE_TESTS "Build tests (requires static libs)" ON)
option(ENABLE_TOOLS "Build tools" ON)
option(ENABLE_SHARED_LIBS "Build dynamic link libs" ON)
option(ENABLE_STATIC_LIBS "Build static libs" ON)

IF(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
  OPTION(ENABLE_INSTALL_RIM "Install files" ON)
ELSE()
  MESSAGE( "-- RefIccMAX: compile as subproject - skip install (ENABLE_INSTALL_RIM=OFF)" )
  # disable install and build of shared libs for fallback subproject
  IF(NOT ENABLE_INSTALL_RIM)
    SET(ENABLE_INSTALL_RIM OFF)
  ENDIF(NOT ENABLE_INSTALL_RIM)
  SET(ENABLE_STATIC_LIBS ON)
  SET(ENABLE_SHARED_LIBS OFF)
ENDIF()

IF( ENABLE_TESTS )
  SET(ENABLE_STATIC_LIBS ON)
ENDIF()


IF( CMAKE_BUILD_TYPE MATCHES "[Dd][Ee][Bb][Uu][Gg]" )
  MESSAGE( "-- Info build \"${CMAKE_BUILD_TYPE}\"" )
  SET( DEBUG 1 )
ENDIF()

FIND_PROGRAM(CMAKE_AR_TMP NAMES ar)

SET( TOP_SOURCE_DIR ../.. )
INCLUDE_DIRECTORIES ( ${TOP_SOURCE_DIR}/IccProfLib/ )

# now add all directories
ADD_SUBDIRECTORY( IccProfLib )
ADD_SUBDIRECTORY( Tools/IccDumpProfile )

CONFIGURE_FILE(
    "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}Uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Uninstall.cmake"
    IMMEDIATE @ONLY)

ADD_CUSTOM_TARGET( uninstall
	"${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Uninstall.cmake")

#
# Target installation folders
#

SET (TARGET_INCLUDE_FOLDER
		${PROJECT_DOWN_NAME}
		CACHE STRING
		"Optional folder below system include folder to install include files."
    )

SET (TARGET_CMAKE_FOLDER
		"cmake/${PACKAGE_NAME}"
		CACHE STRING
		"The folder below system prefix where to install cmake files."
    )

SET (TARGET_PKGCONFIG_FOLDER
		"pkgconfig"
		CACHE STRING
		"The folder below system library folder where to install pkgconfig files."
    )

SET (TARGET_DOCUMENTATION_FOLDER
		"share/doc/${PACKAGE_NAME}-api"
		CACHE STRING
		"The folder below system prefix where to install api documentation files."
    )


#
# Misc.
#

#cmake settings for use by find_package
CONFIGURE_FILE (
		"${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}Config.cmake.in"
		"${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.cmake"
		@ONLY
	)

INSTALL ( FILES
		"${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.cmake"
		DESTINATION ${CMAKE_INSTALL_LIBDIR}/${TARGET_CMAKE_FOLDER} COMPONENT dev
	)


