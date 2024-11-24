cmake_minimum_required(VERSION 3.5)
project(iccApplyNamedCmm)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(APPLE)
  set(CMAKE_OSX_ARCHITECTURES "x86_64")
endif()

# Set the path for nlohmann-json
set(CMAKE_PREFIX_PATH "/usr/local/Cellar/nlohmann-json/3.11.3")

# Find nlohmann-json
find_package(nlohmann_json REQUIRED)

# Sources
set(SOURCES
  ${CMAKE_CURRENT_SOURCE_DIR}/iccApplyNamedCmm.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/../IccCommon/IccJsonUtil.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/../IccCommon/IccCmmConfig.cpp
)

# Define the executable
add_executable(iccApplyNamedCmm ${SOURCES})

# Include directories
target_include_directories(iccApplyNamedCmm PRIVATE
  ${CMAKE_SOURCE_DIR}/../../../IccProfLib
  ${CMAKE_SOURCE_DIR}/../../../IccXML
  /usr/local/Cellar/nlohmann-json/3.11.3/include
)

# Link directories
target_link_directories(iccApplyNamedCmm PRIVATE
  ${CMAKE_SOURCE_DIR}/../../../Build/IccProfLib
  ${CMAKE_SOURCE_DIR}/../../../Build/IccXML
)

# Link libraries
target_link_libraries(iccApplyNamedCmm PRIVATE
  IccProfLib2
  IccXML2
  nlohmann_json::nlohmann_json
)

# Compiler options
target_compile_options(iccApplyNamedCmm PRIVATE
  -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.1.sdk
  -arch x86_64
)

# Linker options
target_link_options(iccApplyNamedCmm PRIVATE
  -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.1.sdk
  -arch x86_64
  -L${CMAKE_SOURCE_DIR}/../../../Build/IccProfLib
  -L${CMAKE_SOURCE_DIR}/../../../Build/IccXML
)

# Debugging output
message(STATUS "Include Directories:")
message(STATUS "IccProfLib: ${CMAKE_SOURCE_DIR}/../../../IccProfLib")
message(STATUS "IccXML: ${CMAKE_SOURCE_DIR}/../../../IccXML")
message(STATUS "macOS SDK Path: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX15.1.sdk")
message(STATUS "Link Directories:")
message(STATUS "IccProfLib: ${CMAKE_SOURCE_DIR}/../../../Build/IccProfLib")
message(STATUS "IccXML: ${CMAKE_SOURCE_DIR}/../../../Build/IccXML")
