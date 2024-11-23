
# ICC Profile to TXT Script

## Overview
This Zsh script automates the process of analyzing ICC color profiles in the current working directory and all subdirectories. It searches for files with known ICC profile extensions (`.icc`, `.icm`, `.iccp`, `.icf`), performs a hex dump using the `xxd` command, and saves the results in a designated output directory. All operations are logged to both the console and a consolidated report file.

## Features
- Recursively scans the current working directory and all subdirectories for ICC profiles.
- Supports the following ICC profile extensions: `.icc`, `.icm`, `.iccp`, and `.icf`.
- Generates a hex dump of each ICC profile using the `xxd` command.
- Saves hex dump output to a directory named `icc-xxd/` with the format `icc-filename-xxd-timestamp.txt`.
- Logs all operations to the console and a consolidated report file (`consolidated_icc_report.txt`).

## Requirements
- Zsh
- `xxd` utility (available by default on most Unix-based systems)

## Usage
1. **Download the script**: Copy the script to your local machine.
2. **Make the script executable**:
   ```bash
   chmod +x process_icc.sh
   ```
3. **Run the script**:
   ```bash
   /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/HelperScripts/icc2txt.zsh)"
   ```

The script will process all ICC profiles in the current directory and its subdirectories. The hex dump of each profile will be saved in the `icc-xxd/` directory, and logs will be stored in `consolidated_icc_report.txt`.

### Example Output
The hex dump output files are saved in the following format:
```
icc-xxd/icc-profile-name-xxd-timestamp.txt
```
The consolidated report will log each file processed and its corresponding hex dump output file.
