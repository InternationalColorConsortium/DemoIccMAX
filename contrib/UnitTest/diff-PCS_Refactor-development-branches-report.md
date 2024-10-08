# PCS_Refactor and Development Branch Analysis Script

***tl;dr***

```
 /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/diff-PCS_Refactor-development-branches-report.sh)"
```

## Overview

This script automates the process of comparing the `PCS_Refactor` and `development` branches of two repositories, analyzing the differences in `.cpp` files for potential memory management issues. The analysis identifies mismatches between memory allocation (`malloc()`, `new`, etc.) and deallocation (`free()`, `delete`, etc.) calls, providing detailed and condensed reports.

## Features

- **Automatic Repository Cloning:** Clones the `PCS_Refactor` and `development` branches from two repositories for analysis.
- **Memory Management Issue Detection:** Compares `.cpp` files between the two repositories to detect mismatches in memory management (allocation vs deallocation).
- **Detailed and Condensed Reports:** Generates two reports:
  - `analysis_report.txt`: Detailed analysis of mismatches in each file.
  - `condensed_report.txt`: A concise summary of detected memory management issues.
- **Diff Output:** Logs the differences between corresponding `.cpp` files in `diff_output_cpp.txt`.
- **Logging:** Captures the script’s output into `script.log` for debugging or auditing purposes.

## Prerequisites

Ensure the following dependencies are installed on your system:

- **Git**: Used to clone repositories.
- **Bash**: The script is written for a bash-compatible shell.

## Usage

1. Copy and Paste into your Terminal:
   ```
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/diff-PCS_Refactor-development-branches-report.sh)"
   ```
