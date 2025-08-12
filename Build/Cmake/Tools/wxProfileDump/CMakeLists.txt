#################################################################################
# Cmake Project Configuration| iccDEV Project
# Copyright (C) 2024-2025 The International Color Consortium. 
#                                        All rights reserved.
#  Last Updated: 12-AUGUST-2025 1600Z by David Hoyt
#
#
#
#  
#  Changes: Modify iccMAX to iccDEV
#           
#           
#
#  TODO: Refactor Debug, Release, Asan 
#        Collapse 3-tier CMakeLists.txt, Housekeeping
#        Refactor Base Configs & logging to .mk's
#
#
#
#################################################################################

message(STATUS "Configuring wxProfileDump")

# Resolve source root properly
get_filename_component(PROJECT_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../../../.." ABSOLUTE)
set(SRC_PATH "${PROJECT_ROOT}")
set(SOURCES ${SRC_PATH}/Tools/wxWidget/wxProfileDump/wxProfileDump.cpp)
set(TARGET_NAME iccDumpProfileGui)

# Log configuration
message(STATUS "SRC_PATH: ${SRC_PATH}")
message(STATUS "Sources: ${SOURCES}")

set(wxWidgets_CONFIGURATION mswu)

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
