
# libtiff Build Script

## Overview
This Zsh script automates the process of downloading, building, and installing **libtiff** version `4.6.0`. The script ensures the necessary directories are created, the tarball is downloaded, extracted, and the library is built and installed in the appropriate directories. Additionally, it copies the necessary files to an Xcode directory for use in macOS projects.

## Features
- Downloads `libtiff-4.6.0` tarball from the official repository.
- Builds and installs the library in a specified `libtiff/` directory.
- Copies required static library and header files to the `XCode/libtiff` directory for integration in Xcode projects.
- Handles error checking for each step of the process (download, extraction, configuration, building, and installation).

## Requirements
- Zsh
- Xcode command-line tools (for building)
- `curl` for downloading files
- Unix build tools (`make`, `configure`)

## Usage
1. **Download the script**: Copy the script to your local machine.
2. **Set up your environment**: Ensure you have the necessary tools installed (`Xcode`, `make`, etc.).
3. **Make the script executable**:
   ```bash
   chmod +x build_libtiff.sh
   ```
4. **Run the script**:
   ```bash
   ./build_libtiff.sh
   ```

The script will download and extract the `libtiff-4.6.0` tarball, configure and build it, and install it in the specified directory. Required files will be copied to the `XCode/libtiff/` directory for easy integration into macOS projects.

### Example Directory Structure
- The built library will be installed in:  
  ```
  libtiff/
  ```
- Files copied for Xcode integration will be in:
  ```
  XCode/libtiff/
  ```

## Error Handling
The script checks for errors in each step (downloading, extracting, building, etc.) and will exit with a message if any operation fails.
