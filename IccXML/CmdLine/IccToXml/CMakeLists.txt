cmake_minimum_required(VERSION 3.10)

# Project setup
project(IccToXml)

# Set architecture and SDK path
if(NOT CMAKE_OSX_ARCHITECTURES)
    set(CMAKE_OSX_ARCHITECTURES "x86_64")
endif()

execute_process(COMMAND xcrun --show-sdk-path OUTPUT_VARIABLE SDK_PATH OUTPUT_STRIP_TRAILING_WHITESPACE)
set(CMAKE_OSX_SYSROOT "${SDK_PATH}")

# Include directories
include_directories(
    "${CMAKE_SOURCE_DIR}/../../../IccProfLib"
    "${CMAKE_SOURCE_DIR}/../.."
    "${CMAKE_SOURCE_DIR}/../../IccLibXML"
)

# Library directories
link_directories(
    "${CMAKE_SOURCE_DIR}/../../../Build/IccProfLib"
    "${CMAKE_SOURCE_DIR}/../../../Build/IccXML"
)

# Source files
set(SOURCE_FILES
    IccToXml.cpp
)

# Add executable target
add_executable(IccToXml ${SOURCE_FILES})

# Link the necessary libraries
target_link_libraries(IccToXml
    IccProfLib2.2
    IccXML2.2
)

# Set RPATH to locate the dynamic libraries
set_target_properties(IccToXml PROPERTIES
    INSTALL_RPATH "${CMAKE_SOURCE_DIR}/../../../Build/IccProfLib;${CMAKE_SOURCE_DIR}/../../../Build/IccXML"
    BUILD_WITH_INSTALL_RPATH TRUE
)

# Set the executable output directory for both Debug and Release configurations
set_target_properties(IccToXml PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_BINARY_DIR}/Debug"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/Release"
)

# Verbose compiler output
set(CMAKE_VERBOSE_MAKEFILE ON)

# Add linker flags
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -v -Wl,-v")
