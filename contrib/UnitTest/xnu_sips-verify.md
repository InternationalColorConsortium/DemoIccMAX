
# xnu_sips-verify.zsh

***tl;dr***

```
cd Testing/
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/xnu_sips-verify.zsh)"
```

## Overview
This script recursively processes `.icc` files in the current directory and its subdirectories, verifying each file using the `sips --verify` command. It outputs the verification results into individual text files stored in a designated `sips-output` directory. The script also compiles a summary report highlighting header issues, tag issues, and general warnings or errors encountered during verification.

## Features
- **Automatic Output Directory**: All verification results are saved in a `sips-output` directory. The script automatically creates this directory if it doesn't exist.
- **Detailed Per-File Logging**: Each `.icc` file generates an individual verification log in the `sips-output` directory.
- **Issue Summarization**: The script captures and counts specific issues related to headers, tags, warnings, and errors. These are summarized in a final report saved as `sips_verification_report.txt` inside the `sips-output` directory.
  
## Usage

1. **Run the Script**:

```
cd Testing/
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/xnu_sips-verify.zsh)"
```

2. **Output**:
   - All verification outputs for each `.icc` file will be stored in `sips-output` directory.
   - A summary report will be generated at the end of the process as `sips-output/sips_verification_report.txt`.

## Example File Structure

```
Testing/
 ├── sips_verify.zsh
 ├── sips-output
 │    ├── file1-sips.txt
 │    ├── file2-sips.txt
 │    └── sips_verification_report.txt
 └── subdir
     └── anotherfile.icc
```

In this example:
- The `.icc` files are processed, and results are saved as `.txt` files in the `sips-output` directory.
- A final report, `sips_verification_report.txt`, summarizes any header issues, tag issues, warnings, or errors found.

## Summary Report Format

The final report, `sips_verification_report.txt`, contains:
- **Header Issues**: Counts and lists all header-related issues.
- **Tag Issues**: Counts and lists all tag-related issues.
- **General Warnings and Errors**: Lists any warnings and errors encountered during verification.

### Example Output
```
...
Verifying file: ./mcs/Flexo-CMYKOGP/CMPK-SelectMID.icc
Verifying file: ./mcs/6ChanSelect-MID.icc
Verifying file: ./luts/lg_to_srgb_m1.icc
Verifying file: ./luts/lg_to_srgb_m2.icc
Verifying file: ./luts/lg_to_srgb.icc
Generating final report: sips-output/sips_verification_report.txt
...
 tail -n 50 sips-output/sips_verification_report.txt
Summary of sips verification:

=== Header Issues ===
"   Header version not correct. ": 149
"   Header message digest (MD5) is missing. ": 16
"   Header white point is not D50. ": 261
"   Header connection space is not correct. ": 135
"   Header padding is not null. ": 273
"   Header data space is not correct. ": 137
"   Header profile class is not correct. ": 8
"   Header message digest (MD5) is not correct. ": 5

=== Tag Issues ===
"   Tag 'dmdd': Description tag has a bad Unicode string. ": 1
"   Tag 'A2B0': Required tag is not present. ": 235
"   Tag 'desc': Required tag is not present. ": 2
"   Tag 'rTRC': Required tag is not present. ": 21
"   Tag 'dscm': Tag type is not correct. ": 1
"   Tag 'A2B0': Number of input channels is not correct. ": 1
"   Tag 'kTRC': Required tag is not present. ": 1
"   Tag 'B2A1': Tag type is not correct. ": 111
"   Tag 'B2A0': Required tag is not present. ": 230
"   Tag 'A2B0': Tag reserved field is not zero. ": 1
"   Tag 'A2B0': Reserved field not zero. ": 1
"   Tag 'wtpt': Required tag is not present. ": 11
"   Tag 'gamt': Required tag is not present. ": 1
"   Tag 'A2B0': Tag type is not correct. ": 6
"   Tag 'chad': Tag type is not correct. ": 1
"   Tag 'gXYZ': Required tag is not present. ": 21
"   Tag 'cprt': Required tag is not present. ": 3
"   Tag 'desc': Tag reserved field is not zero. ": 1
"   Tag 'bXYZ': Required tag is not present. ": 21
"   Tag 'dmdd': Description tag has a bad ASCII string. ": 1
"   Tag 'A2B1': Tag type is not correct. ": 111
"   Tag 'bTRC': Required tag is not present. ": 21
"   Tag 'wtpt': Tag type is not correct. ": 1
"   Tag 'desc': Description tag has a bad Unicode string. ": 1
"   Tag 'desc': Tag type is not correct. ": 272
"   Tag 'chad': Tag reserved field is not zero. ": 1
"   Tag 'dmnd': Description tag has a bad ASCII string. ": 1
"   Tag 'dscm': Tag reserved field is not zero. ": 1
"   Tag 'gTRC': Required tag is not present. ": 21
"   Tag 'ncl2': Tag type is not correct. ": 3
"   Tag 'cprt': Tag type is not correct. ": 271
"   Tag 'pseq': Required tag is not present. ": 5
"   Tag 'B2A0': Curve type is not correct. ": 1
"   Tag 'A2B0': Number of output channels is not correct. ": 1
"   Tag 'rXYZ': Required tag is not present. ": 21

=== General Warnings and Errors ===
```
## Dependencies
- **sips**: The script requires the `sips` command, which is pre-installed on macOS. The script uses `sips --verify` to perform file verification.
  
