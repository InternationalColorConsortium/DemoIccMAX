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
    "${CMAKE_SOURCE_DIR}/../../"
    "${CMAKE_SOURCE_DIR}/../../IccLibXML"
)

# Library directories
link_directories(
    "${CMAKE_SOURCE_DIR}/../../../Build/IccProfLib"
    "${CMAKE_SOURCE_DIR}/../../../Build/IccXML"
)

# Source files
set(SOURCE_FILES
    iccToXml.cpp
)

# Add executable target
add_executable(iccToXml ${SOURCE_FILES})

# Link the necessary libraries
target_link_libraries(iccToXml
    IccProfLib2
    IccXML2
)

# Verbose compiler output
set(CMAKE_VERBOSE_MAKEFILE ON)

# Add linker flags
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -v -Wl,-v")

