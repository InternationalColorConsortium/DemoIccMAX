# Set the project name
project(iccJpegDump)

# Platform-based build gate (skip for Ubuntu < 24.04)
if(UNIX AND EXISTS "/etc/lsb-release")
    execute_process(
        COMMAND lsb_release -rs
        OUTPUT_VARIABLE LSB_VERSION
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    message(STATUS "Detected Ubuntu version: ${LSB_VERSION}")
    string(REGEX MATCHALL "[0-9]+" LSB_VERSION_PARTS "${LSB_VERSION}")

    if (NOT LSB_VERSION_PARTS)
        message(WARNING "iccJpegDump is skipped: couldn't detect Ubuntu version")
        return()
    endif()

    list(GET LSB_VERSION_PARTS 0 UBUNTU_MAJOR)
    list(GET LSB_VERSION_PARTS 1 UBUNTU_MINOR)

    if(NOT UBUNTU_MAJOR OR NOT UBUNTU_MINOR)
        message(WARNING "iccJpegDump is skipped: Ubuntu version parse failed")
        return()
    endif()

    math(EXPR LSB_VERSION_COMBINED "${UBUNTU_MAJOR} * 100 + ${UBUNTU_MINOR}")
    if(LSB_VERSION_COMBINED LESS 2404)
        message(WARNING "iccJpegDump is skipped: requires Ubuntu 24.04 or later")
        return()
    endif()
endif()

# Define the source path
set(SRC_PATH ../../../..)
set(SOURCES
    ${SRC_PATH}/Tools/CmdLine/IccJpegDump/iccJpegDump.cpp
)

# Resolve project root directory
get_filename_component(PROJECT_ROOT_DIR "${CMAKE_SOURCE_DIR}/../.." ABSOLUTE)
message(STATUS "PROJECT_ROOT_DIR resolved as: ${PROJECT_ROOT_DIR}")

# Set the target name
set(TARGET_NAME iccJpegDump)
message(STATUS "Added executable target: ${TARGET_NAME}")

# Include directories
include_directories(
    ${SRC_PATH}/Tools/CmdLine/IccJpegDump/
    ${SRC_PATH}/Libraries/IccProfLib/
)

# Platform-specific configuration
if(WIN32)
    find_path(JPEG_INCLUDE_DIR jpeglib.h PATH_SUFFIXES include)
    find_library(JPEG_LIBRARY NAMES jpeg turbojpeg PATH_SUFFIXES lib)

    if(JPEG_INCLUDE_DIR)
        include_directories(${JPEG_INCLUDE_DIR})
        message(STATUS "JPEG include directory: ${JPEG_INCLUDE_DIR}")
    else()
        message(FATAL_ERROR "JPEG include directory not found on Windows")
    endif()

    set(PLATFORM_LIBS ws2_32)

elseif(EMSCRIPTEN)
    message(STATUS "DEBUG: Input JPEG_INCLUDE_DIR = ${JPEG_INCLUDE_DIR}")
    message(STATUS "DEBUG: Input JPEG_LIBRARY = ${JPEG_LIBRARY}")

    find_path(JPEG_INCLUDE_DIR jpeglib.h PATHS ${JPEG_INCLUDE_DIR} NO_DEFAULT_PATH)
    find_library(JPEG_LIBRARY NAMES jpeg PATHS ${JPEG_LIBRARY} NO_DEFAULT_PATH)

    message(STATUS "DEBUG: Resolved JPEG_INCLUDE_DIR = ${JPEG_INCLUDE_DIR}")
    message(STATUS "DEBUG: Resolved JPEG_LIBRARY = ${JPEG_LIBRARY}")

    if(NOT JPEG_INCLUDE_DIR OR NOT JPEG_LIBRARY)
        message(FATAL_ERROR "JPEG_INCLUDE_DIR or JPEG_LIBRARY not set or not found for Emscripten")
    endif()

    include_directories(${JPEG_INCLUDE_DIR})
    set(PLATFORM_LIBS "")

else()
    find_package(JPEG REQUIRED)
    include_directories(${JPEG_INCLUDE_DIR})
    set(JPEG_LIBRARY ${JPEG_LIBRARIES})
endif()

# Add executable
add_executable(${TARGET_NAME} ${SOURCES})

# Link libraries
target_link_libraries(${TARGET_NAME}
    ${TARGET_LIB_ICCPROFLIB}
    ${JPEG_LIBRARY}
    ${PLATFORM_LIBS}
)

message(STATUS "Linked with JPEG library: ${JPEG_LIBRARY}")
message(STATUS "Linked with platform-specific libraries: ${PLATFORM_LIBS}")

# Optional installation rule
if(ENABLE_INSTALL_RIM)
    install(TARGETS ${TARGET_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
