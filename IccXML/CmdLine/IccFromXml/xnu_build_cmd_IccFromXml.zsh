#!/bin/zsh

echo "This Project is configured to manually build a command line tool, you must have already built and installed the dylibs...."

# Project and configurations
PROJECT="IccFromXml.xcodeproj"
CONFIGURATIONS=("Debug" "Release" "MinSizeRel" "RelWithDebInfo")
SCHEMES=("ALL_BUILD" "iccFromXml" "ZERO_CHECK")

# Destination
DESTINATION="platform=macOS,arch=x86_64"

# Mark the build directory as created by the build system
#BUILD_DIR="$(pwd)/IccXML/CmdLine/IccFromXml/build"
#xattr -w com.apple.xcode.CreatedByBuildSystem true "$BUILD_DIR"

# Function to build with a specific configuration and scheme
build_project() {
    local scheme=$1
    local config=$2

    echo "Building scheme '$scheme' with configuration '$config'..."
    xcodebuild -project "$PROJECT" -scheme "$scheme" -configuration "$config" -destination "$DESTINATION" clean build
}

# Iterate over configurations and schemes
for config in "${CONFIGURATIONS[@]}"; do
    for scheme in "${SCHEMES[@]}"; do
        build_project "$scheme" "$config"
    done
done

echo "All builds completed."
