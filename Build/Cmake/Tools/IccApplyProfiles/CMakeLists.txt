# Define the relative source path
set(SRC_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../..")

# Specify the source files
set(SOURCES
    ${SRC_PATH}/Tools/CmdLine/IccApplyProfiles/iccApplyProfiles.cpp
    ${SRC_PATH}/Tools/CmdLine/IccApplyProfiles/TiffImg.cpp
)

# Define the target name
set(TARGET_NAME iccApplyProfiles)

# Add target only if it doesn't already exist
if (NOT TARGET ${TARGET_NAME})
    # Include necessary directories
    include_directories(${SRC_PATH}/Tools/CmdLine/IccApplyProfiles/)

    # Define the executable target
    add_executable(${TARGET_NAME} ${SOURCES})

    # Link the required libraries
    target_link_libraries(${TARGET_NAME} ${TARGET_LIB_ICCPROFLIB} ${TIFF_LIBRARY})

    # Optionally install the target
    if (ENABLE_INSTALL_RIM)
        install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
    endif()
else()
    message(STATUS "Target ${TARGET_NAME} already exists, skipping redefinition.")
endif()
