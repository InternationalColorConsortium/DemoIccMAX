
# xxd summary for `.icc` Color Profiles

**Author:** David Hoyt  
**Last Refactor Date:** 30-Sept-2024  
**Purpose:** Automates the analysis and testing of `.icc` color profiles using `xxd` dumps to extract critical metadata.

***tl;dr***

```
cd Testing/
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/xxd_icc_checks.zsh)" 
```

## Overview

This script automates the process of analyzing ICC (International Color Consortium) profiles by leveraging the `xxd` command to create hex dumps. The resulting hex dumps are parsed to extract key information about each ICC profile, such as:

- Magic Bytes (`acsp` validation)
- Profile Size
- Preferred CMM Type
- Profile Version
- Device Class
- Data Color Space
- Creation Date
- Profile Signature
- Primary Platform
- CMM Flags
- Device Manufacturer and Model
- Device Attributes
- Rendering Intent
- PCS Illuminant
- Profile Creator
- Reserved Bytes (should be zero)

The extracted data is consolidated into a report saved as `consolidated_icc_report.txt`.

## How to Use

```
cd Testing/
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/xxd_icc_checks.zsh)" 
```

### Prerequisites

- **macOS**: The script is designed to run on macOS.
- **xxd**: Ensure that the `xxd` command-line tool is available (it comes pre-installed on macOS).
- **ICC Profiles**: The profiles should be pre-dumped into hex format using `xxd`.

### Output

The report will include sections for each analyzed ICC profile, displaying its metadata and any potential inconsistencies. At the end of the process, you will find the consolidated report in `consolidated_icc_report.txt`.
