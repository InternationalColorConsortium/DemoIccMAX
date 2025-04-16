# iccTiffDump

## Overview

`iccTiffDump` is a command-line utility for extracting metadata and ICC profile details from TIFF images. It reports image characteristics such as dimensions, bit depth, photometric interpretation, and embedded ICC color profiles when present.

This tool is ideal for developers and color scientists who need to audit TIFF image color characteristics or verify ICC profile embedding.

---

## Features

- Extracts and displays key TIFF image metadata
- Identifies photometric interpretation and compression method
- Displays embedded ICC profile data including color space, PCS, and profile description
- Provides support for text and multilingual profile descriptions
- Outputs image resolution, sample format, and bytes per line

---

## Output Details

### TIFF Metadata
- Image dimensions and physical size (in inches)
- Planar configuration and photometric interpretation
- Bit depth, samples per pixel, and compression type
- Resolution in pixels per inch
- Extra samples (e.g., alpha channel)
- Byte stride per line of pixels

### ICC Profile Information (if embedded)
- Color space and PCS (Profile Connection Space)
- Spectral PCS and spectral range (if present)
- Profile description (localized and plain text variants)

---

## Build Instructions

### Clean prior build artifacts
```sh
cd Build/
rm -rf CMakeCache.txt CMakeFiles/ Makefile IccProfLib/ IccXML/ Testing/ Tools/
```

### Configure with debug flags and AddressSanitizer
```sh
cd Build/
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local       -DCMAKE_BUILD_TYPE=Debug       -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall"       -Wno-dev -DENABLE_TOOLS=YES Cmake/
```

### Compile with 32 threads
```sh
make -j32
```

---

## Usage Examples

### Analyze a single TIFF image
```sh
Tools/IccTiffDump/iccTiffDump sample.tiff
```

### Export ICC profile from TIFF (if present)
```sh
Tools/IccTiffDump/iccTiffDump sample.tiff exported.icc
```

---

## Notes

- **TIFF image requirements**: The image should be well-formed and readable by `CTiffImg`.
- **Exported profiles**: Only available if ICC profile is embedded in the input file.

---

## Changelog

- Initial implementation by Max Derhak (2003)
- CLI modernization and metadata extension by David Hoyt (2025)
