#################################################################################
# Cmake Project Configuration| iccMAX Project
# Copyright (C) 2024-2025 The International Color Consortium. 
#                                        All rights reserved.
#  Last Updated: Mon Mar 24 16:40:19 EDT 2025 EDT by David Hoyt
#  date -d @1742848819
#
#
#  
#  Changes: Modified Build/Cmake/CMakeLists.txt and others
#           Improved dependency linking and error handling
#           Adjusted cross-platform build args
#
#  TODO: Refactor Debug, Release, Asan 
#        Collapse 3-tier CMakeLists.txt, Housekeeping
#        Refactor Base Configs & logging to .mk's
#
#
#
#################################################################################

message(STATUS "Configuring wxProfileDump")


set(SRC_PATH ../../../..)
set(SOURCES ${SRC_PATH}/Tools/wxWidget/wxProfileDump/wxProfileDump.cpp)
set(TARGET_NAME iccDumpProfileGui)
message(STATUS "SRC_PATH: ${SRC_PATH}")
message(STATUS "Sources:")

set(wxWidgets_CONFIGURATION mswu)
message(STATUS "SRC_PATH: ${SRC_PATH}")
message(STATUS "Sources:")

add_executable(${TARGET_NAME} ${SOURCES})
set_target_properties(${TARGET_NAME} PROPERTIES WIN32_EXECUTABLE ON)
message(STATUS "  Linking libraries for target ${TARGET_NAME}:")
message(STATUS "  ICCProfLib Library: ${TARGET_LIB_ICCPROFLIB}")
message(STATUS "  wxWidgets Libraries: ${wxWidgets_LIBRARIES}")
target_link_libraries(${TARGET_NAME} PRIVATE ${TARGET_LIB_ICCPROFLIB} ${wxWidgets_LIBRARIES})

if(ENABLE_INSTALL_RIM)
    install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()

message(STATUS "wxProfileDump Configuration Complete")
