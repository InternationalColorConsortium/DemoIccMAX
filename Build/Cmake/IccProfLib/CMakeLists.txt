SET( TARGET_NAME IccProfLib2)

SET( SRC_PATH ../../.. )
SET( CFILES
	${SRC_PATH}/IccProfLib/IccApplyBPC.cpp
	${SRC_PATH}/IccProfLib/IccArrayBasic.cpp
	${SRC_PATH}/IccProfLib/IccArrayFactory.cpp
	${SRC_PATH}/IccProfLib/IccCAM.cpp
	${SRC_PATH}/IccProfLib/IccCmm.cpp
	${SRC_PATH}/IccProfLib/IccConvertUTF.cpp
	${SRC_PATH}/IccProfLib/IccEncoding.cpp
	${SRC_PATH}/IccProfLib/IccEnvVar.cpp
	${SRC_PATH}/IccProfLib/IccEval.cpp
	${SRC_PATH}/IccProfLib/IccIO.cpp
	${SRC_PATH}/IccProfLib/IccMatrixMath.cpp
	${SRC_PATH}/IccProfLib/IccMpeACS.cpp
	${SRC_PATH}/IccProfLib/IccMpeBasic.cpp
	${SRC_PATH}/IccProfLib/IccMpeCalc.cpp
	${SRC_PATH}/IccProfLib/IccMpeFactory.cpp
	${SRC_PATH}/IccProfLib/IccMpeSpectral.cpp
	${SRC_PATH}/IccProfLib/IccPrmg.cpp
	${SRC_PATH}/IccProfLib/IccPcc.cpp
	${SRC_PATH}/IccProfLib/IccProfile.cpp
	${SRC_PATH}/IccProfLib/IccSolve.cpp
	${SRC_PATH}/IccProfLib/IccSparseMatrix.cpp
	${SRC_PATH}/IccProfLib/IccStructBasic.cpp
	${SRC_PATH}/IccProfLib/IccStructFactory.cpp
	${SRC_PATH}/IccProfLib/IccTagBasic.cpp
	${SRC_PATH}/IccProfLib/IccTagComposite.cpp
	${SRC_PATH}/IccProfLib/IccTagDict.cpp
	${SRC_PATH}/IccProfLib/IccTagEmbedIcc.cpp
	${SRC_PATH}/IccProfLib/IccTagFactory.cpp
	${SRC_PATH}/IccProfLib/IccTagLut.cpp
	${SRC_PATH}/IccProfLib/IccTagMPE.cpp
	${SRC_PATH}/IccProfLib/IccTagProfSeqId.cpp
	${SRC_PATH}/IccProfLib/IccUtil.cpp
	${SRC_PATH}/IccProfLib/IccXformFactory.cpp
	${SRC_PATH}/IccProfLib/IccMD5.cpp
   )

IF(ENABLE_INSTALL_RIM)
  SET( HEADERS_PUBLIC
    ${SRC_PATH}/IccProfLib/IccApplyBPC.h
    ${SRC_PATH}/IccProfLib/IccArrayBasic.h
    ${SRC_PATH}/IccProfLib/IccArrayFactory.h
    ${SRC_PATH}/IccProfLib/IccCAM.h
    ${SRC_PATH}/IccProfLib/IccCmm.h
    ${SRC_PATH}/IccProfLib/IccConvertUTF.h
    ${SRC_PATH}/IccProfLib/IccDefs.h
    ${SRC_PATH}/IccProfLib/IccEncoding.h
    ${SRC_PATH}/IccProfLib/IccEnvVar.h
    ${SRC_PATH}/IccProfLib/IccEval.h
    ${SRC_PATH}/IccProfLib/IccIO.h
    ${SRC_PATH}/IccProfLib/IccMatrixMath.h
    ${SRC_PATH}/IccProfLib/IccMpeACS.h
    ${SRC_PATH}/IccProfLib/IccMpeBasic.h
    ${SRC_PATH}/IccProfLib/IccMpeCalc.h
    ${SRC_PATH}/IccProfLib/IccMpeFactory.h
    ${SRC_PATH}/IccProfLib/IccMpeSpectral.h
    ${SRC_PATH}/IccProfLib/IccPcc.h
    ${SRC_PATH}/IccProfLib/IccPrmg.h
    ${SRC_PATH}/IccProfLib/IccProfile.h
    ${SRC_PATH}/IccProfLib/IccProfLibConf.h
    ${SRC_PATH}/IccProfLib/IccProfLibVer.h
    ${SRC_PATH}/IccProfLib/IccSolve.h
    ${SRC_PATH}/IccProfLib/IccSparseMatrix.h
    ${SRC_PATH}/IccProfLib/IccStructBasic.h
    ${SRC_PATH}/IccProfLib/IccStructFactory.h
    ${SRC_PATH}/IccProfLib/IccTagBasic.h
    ${SRC_PATH}/IccProfLib/IccTagComposite.h
    ${SRC_PATH}/IccProfLib/IccTagDict.h
    ${SRC_PATH}/IccProfLib/IccTagEmbedIcc.h
    ${SRC_PATH}/IccProfLib/IccTagFactory.h
    ${SRC_PATH}/IccProfLib/IccTag.h
    ${SRC_PATH}/IccProfLib/IccTagLut.h
    ${SRC_PATH}/IccProfLib/IccTagMPE.h
    ${SRC_PATH}/IccProfLib/IccTagProfSeqId.h
    ${SRC_PATH}/IccProfLib/IccUtil.h
    ${SRC_PATH}/IccProfLib/IccWrapper.h
    ${SRC_PATH}/IccProfLib/IccXformFactory.h
    ${SRC_PATH}/IccProfLib/icProfileHeader.h
  )
  INSTALL( FILES
	     ${HEADERS_PUBLIC}
	     DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${TARGET_INCLUDE_FOLDER}/${TARGET_NAME} )
ENDIF(ENABLE_INSTALL_RIM)

SET( SOURCES ${CFILES} )

IF(APPLE)
   INCLUDE_DIRECTORIES ( /Developer/Headers/FlatCarbon )
   FIND_LIBRARY( CARBON_LIBRARY Carbon )
   FIND_LIBRARY( IOKIT_LIBRARY IOKit )
   MARK_AS_ADVANCED( CARBON_LIBRARY )
   MARK_AS_ADVANCED( IOKIT_LIBRARY )
   SET(EXTRA_LIBS_CS ${CARBON_LIBRARY} ${IOKIT_LIBRARY})
ENDIF (APPLE)

IF(ENABLE_SHARED_LIBS)
  ADD_LIBRARY( ${TARGET_NAME} SHARED ${SOURCES} )
  SET_TARGET_PROPERTIES( ${TARGET_NAME}
    PROPERTIES VERSION ${${PROJECT_UP_NAME}_VERSION}
             SOVERSION ${${PROJECT_UP_NAME}_MAJOR_VERSION}
                     )
  TARGET_LINK_LIBRARIES (
               ${TARGET_NAME}
               ${EXTRA_LIBS} ${EXTRA_LIBS_CS} )
  IF(ENABLE_INSTALL_RIM)
    INSTALL( TARGETS ${TARGET_NAME}
             RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
             LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
             ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} )
  ENDIF(ENABLE_INSTALL_RIM)
ENDIF(ENABLE_SHARED_LIBS)

IF(ENABLE_STATIC_LIBS)
   ADD_LIBRARY( ${TARGET_NAME}-static STATIC ${SOURCES} )
   TARGET_LINK_LIBRARIES (
                ${TARGET_NAME}-static
                ${EXTRA_LIBS} ${EXTRA_LIBS_CS} )

  IF(ENABLE_INSTALL_RIM)
   INSTALL( TARGETS ${TARGET_NAME}-static
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} )
  ENDIF(ENABLE_INSTALL_RIM)
ENDIF(ENABLE_STATIC_LIBS)

IF(ENABLE_SHARED_LIBS)
  SET( TARGET_LIB ${TARGET_NAME} )
ELSE(ENABLE_SHARED_LIBS)
  SET( TARGET_LIB ${TARGET_NAME}-static )
ENDIF(ENABLE_SHARED_LIBS)
SET( TARGET_LIB ${TARGET_LIB} PARENT_SCOPE )
