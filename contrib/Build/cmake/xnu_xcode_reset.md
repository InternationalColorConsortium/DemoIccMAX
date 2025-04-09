# Xcode Project Reset & Rebuild

Last Updated: Sunday 16-FEB-2025 1645 EST | David Hoyt

## Overview
This script resets and rebuilds the Xcode project for RefIccMAX from scratch. It should be run from the **Project_Root/Build/** directory. You can then manually delete the legacy Xcode Project files.

## Requirements
- macOS with **Xcode** installed
- **CMake** installed
- Internet connection (for fetching updates if needed)

## Usage
To execute this script, run the following command in a terminal:

```sh
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/xnu_xcode_reset.zsh)"
```

## What This Script Does
1. **Displays a startup banner** to confirm execution.
2. **Logs all output** to `xcode_reset.log` for debugging.
3. **Detects the system architecture** (`x86_64` or `arm64`).
4. **Confirms execution from `Project_Root/Build/`**.
5. **Deletes and recreates the `Xcode` directory**.
6. **Generates a new Xcode project** using CMake.
7. **Verifies configuration** via `xcodebuild -showBuildSettings`.
8. **Builds the project** while filtering for errors or successful build messages.

## TODO (Future Enhancements)
- **Sanity Checks** to ensure correct environment setup.
- **Enhanced Logging** for better debugging and status tracking.

## Expected Output

```
xcodebuild -project RefIccMAX.xcodeproj -scheme ALL_BUILD -configuration Release GCC_WARN_INHIBIT_ALL_WARNINGS=YES | grep -E "error:|BUILD SUCCEEDED"
...
{ platform:macOS, arch:x86_64, id:E40C08D0-90C3-58BB-AF08-34C7410FDDEE, name:My Mac }
{ platform:macOS, name:Any Mac }
** BUILD SUCCEEDED ** [30.00 sec]
```

## Troubleshooting
If you encounter issues:
- Ensure that **CMake** and **Xcode** are installed and accessible.
- Verify the correct execution directory: `Project_Root/Build/`.
- Check **xcode_reset.log** for detailed error messages.
- Run manually in steps:
  ```sh
  rm -rf Xcode && mkdir Xcode && cd Xcode
  cmake -G "Xcode" -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -Wno-dev ../Cmake/
  xcodebuild -project RefIccMAX.xcodeproj -scheme ALL_BUILD -configuration Release
  ```
- Try updating Xcode and CMake:
  ```sh
  sudo xcode-select --install
  brew upgrade cmake
  ```

```text
Copyright (c) 2025. International Color Consortium. All rights reserved.
```
