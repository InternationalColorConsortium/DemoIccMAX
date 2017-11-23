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
	${SRC_PATH}/IccProfLib/IccTagFactory.cpp
	${SRC_PATH}/IccProfLib/IccTagLut.cpp
	${SRC_PATH}/IccProfLib/IccTagMPE.cpp
	${SRC_PATH}/IccProfLib/IccTagProfSeqId.cpp
	${SRC_PATH}/IccProfLib/IccUtil.cpp
	${SRC_PATH}/IccProfLib/IccXformFactory.cpp
	${SRC_PATH}/IccProfLib/md5.cpp
   )

SET( SOURCES ${CFILES} )

IF(APPLE)
   INCLUDE_DIRECTORIES ( /Developer/Headers/FlatCarbon )
   FIND_LIBRARY( CARBON_LIBRARY Carbon )
   FIND_LIBRARY( IOKIT_LIBRARY IOKit )
   MARK_AS_ADVANCED( CARBON_LIBRARY )
   MARK_AS_ADVANCED( IOKIT_LIBRARY )
   SET(EXTRA_LIBS_CS ${CARBON_LIBRARY} ${IOKIT_LIBRARY})
ENDIF (APPLE)

SET( TARGET_NAME IccProfLib)

IF(ENABLE_SHARED_LIBS)
  ADD_LIBRARY( ${TARGET_NAME} SHARED ${SOURCES} )
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
