# iccV5DspObsToV4Dsp

## Overview

`iccV5DspObsToV4Dsp` is a command-line utility that converts a version 5 ICC display profile (with spectral emission data) and its corresponding Profile Connection Conditions (PCC) profile into a version 4 display profile. The output profile is suitable for workflows requiring traditional v4 XYZ-based colorant representation.

This tool is useful for migrating ICCv5 display profiles to ICCv4 format for compatibility with legacy color management systems.

---

## Features

- Converts spectral-based AToB1 tag to v4-style RGB TRCs and XYZ colorants
- Applies custom-to-standard PCC transformation
- Outputs version 4.3 ICC profile
- Preserves key metadata (e.g., profile description, copyright)
- Computes TRCs using sampled curves from the spectral profile
- Calculates Red, Green, Blue colorants from emission matrices

---

## Requirements

- Input ICC display profile must:
  - Be version 5
  - Include an AToB1 tag of type `multiProcessElementType`
  - Contain curve and emission matrix MPEs

- Input PCC profile must:
  - Be version 5
  - Include valid `SpectralViewingConditions` and `CustomToStandardPcc` tags

---

## Usage

```sh
Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp input_v5_display.icc input_pcc.icc output_v4_display.icc
```

---

## Output Details

- TRCs are sampled over 2048 points
- RGB to XYZ transformation is computed from emission matrix × PCC transform
- Output profile class: `Display`
- Output version: `4.3`

---

## Build Instructions

### Clean old build files
```sh
cd Build/
rm -rf CMakeCache.txt CMakeFiles/ Makefile IccProfLib/ IccXML/ Testing/ Tools/
```

### Configure for debug with sanitizers
```sh
cd Build/
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local       -DCMAKE_BUILD_TYPE=Debug       -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall"       -Wno-dev -DENABLE_TOOLS=YES Cmake/
```

### Compile the project
```sh
make -j32
```

---

## Changelog

- Initial implementation by Max Derhak (Oct 2023)
- XYZ/Curve conversion and integration by David Hoyt (2025)
