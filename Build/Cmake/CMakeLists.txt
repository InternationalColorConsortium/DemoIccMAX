CMAKE_MINIMUM_REQUIRED (VERSION 2.8.5)

PROJECT (RefIccMAX)
SET (PROJECT_UP_NAME "REFICCMAX" )
SET(CMAKE_CXX_STANDARD 17)
SET( ${PROJECT_UP_NAME}_MAJOR_VERSION 2)
SET( ${PROJECT_UP_NAME}_MINOR_VERSION 1)
SET( ${PROJECT_UP_NAME}_MICRO_VERSION 25)
SET( ${PROJECT_UP_NAME}_VERSION "${${PROJECT_UP_NAME}_MAJOR_VERSION}.${${PROJECT_UP_NAME}_MINOR_VERSION}.${${PROJECT_UP_NAME}_MICRO_VERSION}" )

SET (PROJECT_DOWN_NAME "reficcmax" )
SET (PACKAGE_NAME "${PROJECT_DOWN_NAME}" )
SET (PACKAGE_DESCRIPTION "The RefIccMAX project provides an open source set of
libraries and tools that allow for the interaction, manipulation, and
application of iccMAX based color management profiles based on the iccMAX
profile specification http://www.color.org/iccmax.xalter
in addition to legacy ICC profiles defined by earlier ICC profile
specifications ")

SET( ${PROJECT_NAME}_VERSION_MAJORMINOR "${${PROJECT_NAME}_MAJOR_VERSION}.${${PROJECT_NAME}_MINOR_VERSION}" )

# Define the true project root directory
set(PROJECT_ROOT_DIR ${CMAKE_SOURCE_DIR}/../..)

# Debugging information
message(STATUS "CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR}")
# message(STATUS "PROJECT_ROOT_DIR: ${PROJECT_ROOT_DIR}")
message(STATUS "PROJECT_ROOT_DIR is resolved as: ${PROJECT_ROOT_DIR}")


include(GNUInstallDirs)

option(ENABLE_TESTS "Build tests (requires static libs)" ON)
option(ENABLE_TOOLS "Build tools" ON)
option(ENABLE_SHARED_LIBS "Build dynamic link libs" ON)
option(ENABLE_STATIC_LIBS "Build static libs" ON)
option(ENABLE_ICCXML "Build IccXML library" ON)

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

# Enforce build type to be Debug if not specified to ensure symbols are included
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
endif()

# Compiler flags for Debug and Release build types
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -fsanitize=address -fno-omit-frame-pointer -Wall -O0")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")

# Architecture determination
if(APPLE)
  execute_process(
    COMMAND uname -m
    COMMAND tr -d '\n'
    OUTPUT_VARIABLE OSX_ARCHITECTURE
  )
  if("${OSX_ARCHITECTURE}" STREQUAL "arm64")
    add_definitions(-DARM64)
    message(STATUS "Configuring build for ARM64 architecture.")
  elseif("${OSX_ARCHITECTURE}" STREQUAL "x86_64")
    message(STATUS "Configuring build for X86_64 architecture.")
  else()
    message(FATAL_ERROR "Unsupported architecture: ${OSX_ARCHITECTURE}")
  endif()
endif()

IF( CMAKE_BUILD_TYPE MATCHES "[Dd][Ee][Bb][Uu][Gg]" )
  MESSAGE( "-- Info build \"${CMAKE_BUILD_TYPE}\"" )
  SET( DEBUG 1 )
  add_definitions( -D_DEBUG )
ENDIF()

#
# Target installation folders
#

SET (TARGET_INCLUDE_FOLDER
		${PROJECT_NAME}
		CACHE STRING
		"Optional folder below system include folder to install include files."
    )

IF(NOT CMAKE_MODULES_INSTALL_DIR)
  SET (CMAKE_MODULES_INSTALL_DIR
		"${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_DOWN_NAME}"
		CACHE STRING
		"The folder where to install cmake files."
    )
ENDIF(NOT CMAKE_MODULES_INSTALL_DIR)


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

# additional cmake modules for loading libraries
SET (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/Modules/")


SET( TOP_SOURCE_DIR ../.. )
INCLUDE_DIRECTORIES ( ${TOP_SOURCE_DIR}/IccProfLib/ )

# external dependencies
FIND_PROGRAM(CMAKE_AR_TMP NAMES ar)

#
# Core library
#
ADD_SUBDIRECTORY( IccProfLib )
SET( TARGET_LIB_ICCPROFLIB ${TARGET_LIB} )

## external dependency
IF(ENABLE_ICCXML)
  IF(USE_SYSTEM_LIBXML2)
    FIND_PACKAGE(LibXML2 REQUIRED)
  ELSE()
    FIND_PACKAGE(LibXML2)
  ENDIF()
  IF(LIBXML2_FOUND)
    INCLUDE_DIRECTORIES( ${LIBXML2_INCLUDE_DIR} )
    LINK_DIRECTORIES( ${LIBXML2_LIBRARY_DIRS} )
    SET( HAVE_LIBXML2 1 )
  ELSE( LIBXML2_FOUND )
    IF(CMAKE_VERSION VERSION_GREATER 2.8.0)
      SET( HAVE_LIBXML2 TRUE  )
      INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/IccXML/libxml2 )
      LINK_DIRECTORIES( ${CMAKE_CURRENT_BINARY_DIR}/IccXML/libxml2 )
      ADD_SUBDIRECTORY( IccXML/libxml2 )
      SET( LIBXML2_LIBRARIES xml2-static )
    ENDIF()
  ENDIF(LIBXML2_FOUND)

#
# XML library
#
ADD_SUBDIRECTORY(IccXML)
SET(TARGET_LIB_ICCXML ${TARGET_LIB})
INCLUDE_DIRECTORIES(${TOP_SOURCE_DIR}/IccXML/IccLibXML/)

# Locate required libraries
find_package(nlohmann_json REQUIRED)
find_package(TIFF REQUIRED)

# Debugging information for located packages
message(STATUS "TIFF include directory: ${TIFF_INCLUDE_DIR}")
message(STATUS "TIFF libraries: ${TIFF_LIBRARIES}")
# message(STATUS "nlohmann_json library found: ${nlohmann_json_DIR}")

IF(ENABLE_TOOLS)
  # Check if nlohmann JSON was successfully found
  IF(nlohmann_json_DIR)
    MESSAGE(STATUS "Found nlohmann JSON library at: ${nlohmann_json_DIR}")

    # Use the nlohmann_json include directory
    include_directories(${nlohmann_json_DIR})

message(STATUS "Adding IccApplyNamedCmm from: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyNamedCmm")

# Add subdirectory for IccApplyNamedCmm
IF(EXISTS "${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyNamedCmm")
  message(STATUS "Added IccApplyNamedCmm")
  add_subdirectory(
    ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyNamedCmm
    ${CMAKE_BINARY_DIR}/Tools/CmdLine/IccApplyNamedCmm_Build
  )
ELSE()
  message(FATAL_ERROR "Directory does not exist: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyNamedCmm")
ENDIF()

message(STATUS "Adding IccApplyProfiles from: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles")

# IccApplyProfiles
if(EXISTS "${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles")
  message(STATUS "Added IccApplyProfiles from: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles")
  add_subdirectory(
    ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles
    ${CMAKE_BINARY_DIR}/Tools/CmdLine/IccApplyProfiles_Build
  )
else()
  message(FATAL_ERROR "Directory does not exist: ${PROJECT_ROOT_DIR}/Tools/CmdLine/IccApplyProfiles")
endif()


  ELSE()
    MESSAGE(WARNING "nlohmann JSON library not found. Skipping Tools/IccApplyNamedCmm and Tools/IccApplyProfiles.")
    RETURN() # Exit the script for tools if dependency is not found
  ENDIF()


  # Add additional include paths
  INCLUDE_DIRECTORIES(
    ${CMAKE_SOURCE_DIR}/IccProfLib
    ${CMAKE_SOURCE_DIR}/IccXML
    ${CMAKE_SOURCE_DIR}/Tools/CmdLine/IccCommon
  )


  # Ensure linker paths are set
  LINK_DIRECTORIES(
    ${CMAKE_BINARY_DIR}/IccProfLib
    ${CMAKE_BINARY_DIR}/IccXML
    /usr/local/lib
  )
ENDIF()


  ADD_SUBDIRECTORY( Tools/IccApplyNamedCmm )
  ADD_SUBDIRECTORY( Tools/IccDumpProfile )
  ADD_SUBDIRECTORY( Tools/IccRoundTrip )

  # needs libtiff
  FIND_PACKAGE( TIFF )
  FIND_PATH(TIFF_INCLDIR tiff.h)
  IF( TIFF_FOUND )
    INCLUDE_DIRECTORIES( ${TIFF_INCLUDE_DIR} )
    ADD_SUBDIRECTORY( Tools/IccApplyProfiles )
    ADD_SUBDIRECTORY( Tools/IccSpecSepToTiff )
    ADD_SUBDIRECTORY( Tools/IccTiffDump )
  ENDIF( TIFF_FOUND )

  ADD_SUBDIRECTORY( Tools/IccFromXml )
  ADD_SUBDIRECTORY( Tools/IccToXml )

  # needs wxWidgets
  FIND_PACKAGE(wxWidgets COMPONENTS core base)
  IF( WXWIDGETS_FOUND )
    INCLUDE(${wxWidgets_USE_FILE})
    ADD_SUBDIRECTORY( Tools/wxProfileDump )
  ENDIF( WXWIDGETS_FOUND )

ENDIF(ENABLE_TOOLS)

IF( ENABLE_TESTS )
  ADD_SUBDIRECTORY( Testing )
ENDIF( ENABLE_TESTS )

CONFIGURE_FILE(
    "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}Uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Uninstall.cmake"
    IMMEDIATE @ONLY)

ADD_CUSTOM_TARGET( uninstall
	"${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Uninstall.cmake")

IF( CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "64" )
  SET( ARCH 64 )
ELSE()
  SET( ARCH 32 )
ENDIF()
IF( NOT CMAKE_SYSTEM_NAME MATCHES Darwin )
  SET( GNUTAR_OPTS "--owner user:1000 --group group:500" )
ENDIF()
MESSAGE( "Configured ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}" )

ADD_CUSTOM_TARGET( dist-bin
    COMMAND test -d bin-temp && rm -rv bin-temp || echo "start fresh"
    COMMAND mkdir bin-temp && cd bin-temp && cmake -DENABLE_STATIC_LIBS=ON -DENABLE_SHARED_LIBS=OFF ${CMAKE_SOURCE_DIR} && make -j8 && make dist-bin2
    COMMAND ls -l bin-temp/${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing
    COMMAND echo "Dependencies for iccTiffDump:"
    COMMAND test ${CMAKE_SYSTEM_NAME} = Linux && ldd bin-temp/${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/iccTiffDump || echo ""
    COMMAND test ${CMAKE_SYSTEM_NAME} = Darwin && otool -L bin-temp/${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/iccTiffDump || echo ""
    COMMAND rm -r bin-temp
    COMMAND tar tzvf ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}.tar.gz
    COMMAND echo "We are in:"
    COMMAND pwd
    COMMAND ls -l ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}.tar.gz
		COMMENT Make a ${PROJECT_NAME} binary package
		VERBATIM
		WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
		)

ADD_CUSTOM_TARGET( dist-bin2
    DEPENDS check
    COMMAND mkdir -p ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/IccApplyNamedCmm ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccApplyProfiles ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccDumpProfile ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccDumpProfileGui ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/ || echo ""
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccFromXML ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccToXml ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccRoundTrip ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccSpecSepToTiff ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/iccTiffDump ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/CreateAllProfiles.sh ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND cp -av ${CMAKE_SOURCE_DIR}/../../Testing/RunTests.sh ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/Testing/
    COMMAND echo tar cf - ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/ --owner user:1000 --group group:500 | gzip -9 > ../${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}.tar.gz
    COMMAND tar cf - ${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}/ ${GNUTAR_OPTS} | gzip -9 > ../${PROJECT_NAME}-${CMAKE_SYSTEM_NAME}${ARCH}-${${PROJECT_UP_NAME}_VERSION}.tar.gz
		COMMENT Helper for making a ${PROJECT_NAME} binary package
		VERBATIM
		WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
		)

#
# Misc.
#

#cmake settings for use by find_package
CONFIGURE_FILE (
		"${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}Config.cmake.in"
		"${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
		@ONLY
	)

IF(ENABLE_INSTALL_RIM)
  INSTALL ( FILES
		"${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
		DESTINATION ${CMAKE_MODULES_INSTALL_DIR} COMPONENT dev
	)
ENDIF(ENABLE_INSTALL_RIM)
