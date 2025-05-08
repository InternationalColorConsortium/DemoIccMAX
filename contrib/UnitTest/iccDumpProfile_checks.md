
# iccDumpProfile Check for `.icc` Color Profiles

**Intent:** iccCICD-STUB

***tl;dr***

```
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/iccDumpProfile_checks.zsh)"
```

## Overview

This script automates the process of analyzing ICC (International Color Consortium) profiles by utilizing the `iccDumpProfile` tool to generate detailed reports. The results are consolidated into a summary report, capturing key information from the profile header and flagging any runtime errors.

The script:
- Processes `.icc` files in the current and subdirectories.
- Generates individual reports for each profile in a timestamped directory.
- Extracts and logs key-value pairs from the header section into a summary file.
- Flags any runtime errors (e.g., UndefinedBehaviorSanitizer errors) found during the report generation.

### Output

- **Report Directory**: The individual reports for each `.icc` profile will be saved in the `icc_reports/` directory.
- **Summary Report**: A consolidated summary of the header information for all profiles will be saved in `icc_profile_summary_<timestamp>.txt`.

### Example Output
```
 more icc_reports/Spec400_10_700-D65_60yo2deg-MAT_report_20241007_201026.txt
Built with IccProfLib version 2.2.3

Profile:            './PCC/Spec400_10_700-D65_60yo2deg-MAT.icc'
Profile ID:         3344f9a3e99aab03de6ad8fa37c43b13
Size:               2264 (0x8d8) bytes

Header
------
Attributes:         Reflective | Glossy
Cmm:                Unknown NULL
Creation Date:      10/7/2024 (M/D/Y)  18:30:23
Creator:            NULL
Device Manufacturer:NULL
Data Color Space:   0x001FChannelData
Flags:              EmbeddedProfileTrue | UseAnywhere
PCS Color Space:    NoData
Platform:           Unknown
Rendering Intent:   Absolute Colorimetric
Profile Class:      ColorSpaceClass
Profile SubClass:   'sref' = 73726566
Version:            5.00
SubClass Version:   1.00
Illuminant:         X=0.9504, Y=1.0000, Z=1.0888
Spectral PCS:       0x001FChannelReflectanceData
Spectral PCS Range: start=400.0nm, end=700.0nm, steps=31
BiSpectral Range:   Not Defined
MCS Color Space:    Not Defined

Profile Tags
------------
                         Tag    ID      Offset      Size             Pad
                        ----  ------    ------      ----             ---
       profileDescriptionTag  'desc'       240       254               2
                    DToB3Tag  'D2B3'       496        16               0
                    BToD3Tag  'B2D3'       512        16               0
      customToStandardPccTag  'c2sp'       528        84               0
      standardToCustomPccTag  's2cp'       612        84               0
spectralViewingConditionsTag  'svcn'       696      1356               0
          mediaWhitePointTag  'wtpt'      2052        20               0
       spectralWhitePointTag  'swpt'      2072        70               2
                copyrightTag  'cprt'      2144       118               2




EXIT 0
```
### Notes

Ensure that the `iccDumpProfile` tool is correctly built and accessible. Modify the script to point to the correct location if necessary.
