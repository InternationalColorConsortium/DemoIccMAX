# test_icc_apply_named_cmm

Zsh script designed to test the ICC Profile Application tool (`iccApplyNamedCmm`). The script automates the process of applying ICC profiles to test files and logs the results. It includes a robust framework for capturing debug output, verifying results, and ensuring compatibility with ICC specifications.

## Features

- **Automated Testing**: The script runs tests on specified input files and ICC profiles.
- **Result Logging**: Logs all test outputs to a file with timestamps for easier debugging.
- **Error Handling**: Verifies expected output and highlights discrepancies.
- **Compliance Testing**: Ensures that the ICC profile transformations adhere to ICC.2 standards.

## Prerequisites

- **Operating System**: Linux/Unix with Zsh installed.
- **Dependencies**:
  - `iccApplyNamedCmm` tool from the [DemoIccMAX](https://github.com/InternationalColorConsortium/DemoIccMAX) repository.
  - ICC profiles and test files.

## Script Details

### File Paths
- **Tool Path**: `Tools/IccApplyNamedCmm/iccApplyNamedCmm`
- **Test File**: `../Testing/CalcTest/rgbExercise8bit.txt`
- **Profile File**: `../Testing/CalcTest/calcExercizeOps.icc`
- **Log File**: `../Testing/CalcTest/test_results.log`

### Parameters
- `FINAL_DATA_ENCODING="1"`
- `INTERPOLATION="0"`

### Key Functions
1. **Logging with Timestamps**: Logs messages to both the console and the log file.
2. **Test Execution**: Runs the `iccApplyNamedCmm` tool with the test file and ICC profile.
3. **Output Verification**: Confirms the presence of the expected output string in the log file.
