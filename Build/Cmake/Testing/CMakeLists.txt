# Test for iccApplyNamedCmm and iccFromXml

ADD_CUSTOM_TARGET(check
	"echo"
        DEPENDS test
        COMMENT "Test iccApplyNamedCmm and iccFromXml." VERBATIM )

ADD_CUSTOM_COMMAND( OUTPUT  test
                    DEPENDS iccApplyNamedCmm iccFromXml
                    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/RunTest.cmake )

