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

ADD_CUSTOM_TARGET( dist
		COMMAND cd ${TOP_SOURCE_DIR}/ && git archive --prefix=${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}/ --format=tar HEAD > ${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar 
                COMMAND echo "git:       git clone git://guthub.com/openicc-cms/${PACKAGE_NAME}.git" > ${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2.hashsum
                COMMAND echo "git sha1:  " | tr -d "\\n" >> ${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2.hashsum
                COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/ && git rev-parse HEAD >> ${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2.hashsum 
                COMMAND rm -rf ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION} && tar xf ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar 
                COMMAND tar cf - ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION} | bzip2 > ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2
                COMMAND echo  "package:   http://sourceforge.net/projects/openicc/files/OpenICC/${PACKAGE_NAME}%20${${PROJECT_NAME}_VERSION_MAJORMINOR}/${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2" >> ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2.hashsum
                COMMAND echo  "size:      " | tr -d "\\n" >> ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2.hashsum
                COMMAND du -b ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2 | sed s/[[:space:]][[:print:]]*// >> ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2.hashsum 
                COMMAND echo  "md5sum:    " | tr -d "\\n" >> ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2.hashsum
                COMMAND cd ${CMAKE_CURRENT_BINARY_DIR}/ && md5sum ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2 >> ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2.hashsum
                COMMAND echo  "sha1sum:   " | tr -d "\\n" >> ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2.hashsum
                COMMAND sha1sum ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2 >> ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2.hashsum
                COMMAND echo  "sha256sum: " | tr -d "\\n" >> ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2.hashsum
                COMMAND sha256sum ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2 >> ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2.hashsum
		COMMENT Make a ${PACKAGE_NAME} source package by using git
		VERBATIM
		WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
		)
EXECUTE_PROCESS(COMMAND rpmbuild --showrc
                COMMAND awk '/^build arch/ {print $$4}'
                OUTPUT_VARIABLE RPMARCH
                ERROR_VARIABLE RPMBUILD_ERROR
               )
ADD_CUSTOM_TARGET( rpm
		COMMAND test -d ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}/ && rm -rf ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}/
		COMMAND tar xjf ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2
                COMMAND mkdir -p rpmdir/BUILD rpmdir/SPECS rpmdir/SOURCES rpmdir/SRPMS rpmdir/RPMS/${RPMARCH}
                COMMAND cp -f ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2 rpmdir/SOURCES
                COMMAND rpmbuild --clean -ba extras/${PACKAGE_NAME}.spec --define "_topdir ${CMAKE_CURRENT_BINARY_DIR}/rpmdir"
                DEPENDS dist
		COMMENT Make a ${PACKAGE_NAME} RPM package
		VERBATIM
		)

ADD_CUSTOM_TARGET( debsrc
		COMMAND test -d ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}/ && rm -rf ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}/
		COMMAND tar xjf ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2
                COMMAND mv ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}.tar.bz2 ${PACKAGE_NAME}_${${PROJECT_NAME}_VERSION}.orig.tar.bz2
                COMMAND cp -R ${CMAKE_SOURCE_DIR}/extras/debian ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}/
                COMMAND dpkg-source -b ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}/
                DEPENDS dist
		COMMENT Make a ${PACKAGE_NAME}# DEB source package
		VERBATIM
		)
ADD_CUSTOM_TARGET( debian
		COMMAND cd ${PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}/ && debuild
                DEPENDS debsrc
		COMMENT Make a ${PACKAGE_NAME} DEB package
		VERBATIM
		)

