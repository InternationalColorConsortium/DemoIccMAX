# CreateAllProfiles Script
**Run:** Copy and Paste into your Terminal

```
cd Testing/
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
```

## Overview

`CreateAllProfiles.sh` is a shell script designed to generate multiple ICC profiles from XML files using the `iccFromXml` tool. It works by navigating through various directories, cleaning up existing `.icc` files (if needed), and regenerating new profiles based on XML inputs.

The script assumes that the **iccFromXml** tool is present at `Build/Tools/IccFromXml/iccFromXml` or somewhere within your system's `$PATH`.

## Features

- **Profile Generation**: Converts a wide range of XML files into ICC profiles using the `iccFromXml` tool.
- **Clean Mode**: The script can be run in a clean mode, where it will only delete `.icc` files without regenerating them.
- **Directory Traversal**: The script covers multiple directories such as `Calc`, `CalcTest`, `CMYK-3DLUTs`, `Display`, `Encoding`, and more to process corresponding XML files.

## Prerequisites

Ensure the following are met before running the script:

- The `iccFromXml` tool must be present in `Build/Tools/IccFromXml/` or available in your system's `$PATH`.
- **Bash Shell**: This script is intended to run in a Unix-like environment that supports `bash` or `sh`.
- **XML Files**: Make sure the XML files that the script references exist in their respective directories.
  
## Script Usage

```bash
sh CreateAllProfiles.sh [options]
