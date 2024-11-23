
# DemoIccMAX Race Condition Test Script

## Overview
This Zsh script is designed to run multiple concurrent instances of the `iccFromXml` command to test for potential race conditions when generating ICC profiles from XML files. It operates on two separate test files: `CMYK-3DLUTs.xml` and `CMYK-3DLUTs2.xml`, launching multiple instances of the command for each file and waiting for all processes to complete.

## Features
- Runs multiple concurrent processes to simulate potential race conditions.
- Processes two test XML files sequentially, `CMYK-3DLUTs.xml` and `CMYK-3DLUTs2.xml`.
- Utilizes background processing in Zsh and waits for all instances to complete.

## Requirements
- Zsh
- The `iccFromXml` application (must be located in `Tools/IccFromXml/`).

## Usage
1. **Navigate to the Build directory**: 
   Ensure you are in the correct directory where the script can access the necessary files and commands.
   ```bash
   cd DemoIccMAX-master/Build
   ```
2. **Make the script executable**:
   ```bash
   chmod +x race_condition_test.sh
   ```
3. **Run the script**:
   ```bash
   ./race_condition_test.sh
   ```

The script will execute `iccFromXml` on `CMYK-3DLUTs.xml` and `CMYK-3DLUTs2.xml` with 10 concurrent runs for each file. It then waits for all processes to complete before moving on to the next test file.

## Example Command
The script runs the following command in parallel:
```
Tools/IccFromXml/iccFromXml ../Testing/CMYK-3DLUTs/CMYK-3DLUTs.xml ../Testing/CMYK-3DLUTs/CMYK-3DLUTs.icc
```

### Customization
- You can adjust the number of concurrent runs by modifying the `num_runs` variable at the beginning of the script.

