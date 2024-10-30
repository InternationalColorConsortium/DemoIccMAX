
# TestParseText Unit Test with AddressSanitizer (ASan)

## Overview

This repository contains a self-contained script that builds and runs a unit test for the `ParseText()` function. The script is designed to work on both **Linux** and **macOS** platforms, automatically generating the source code, Makefile, and compiling the test with **AddressSanitizer (ASan)** for detecting memory-related issues.

The `ParseText()` function parses numerical values from a string and stores them in a buffer. This unit test ensures that the function works as expected and integrates **ASan** to detect potential memory issues such as segmentation faults, buffer overflows, and more.

## Script: `TestParseText.sh`
***Remote***
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/TestParseText.sh)"
```

### Script Description

- **Self-contained**: The script includes the source code, Makefile generation, and build instructions all in one.
- **Cross-Platform**: It detects whether the system is running on **Linux** or **macOS** and applies the appropriate build flags.
- **AddressSanitizer (ASan)**: The script integrates ASan to detect memory-related errors during the test.
- **Automated**: The script generates everything needed (source code, Makefile), compiles the program, runs the test, and cleans up after execution.

The script will generate the source code, compile the program with ASan, run the test, and provide feedback on whether the program ran successfully or if memory-related issues were detected by ASan.

### Expected Output

The script will provide detailed feedback as it progresses through the following stages:

1. **Banner**: Displays a banner indicating the start of the build and test process.
2. **Cleanup**: Removes any previously generated files (`TestParseText.cpp`, `Makefile`, executable, logs).
3. **Source Code Generation**: Automatically generates the `TestParseText.cpp` file containing the unit test for the `ParseText()` function.
4. **Makefile Generation**: Generates a platform-specific Makefile for compiling the test.
5. **Build and Test Execution**: 
   - **Successful Build**: If the build succeeds, the test will run, and the script will check for ASan errors.
   - **ASan Errors**: If memory-related issues are detected, the script will print a message indicating an ASan error.
   - **No Errors**: If no errors are found, the program will run successfully.

### Sample Output

#### Successful Test (No ASan Errors):
```
==============================================
   Building and Running TestParseText Unit Test
   ParseText() Unit Test with AddressSanitizer
==============================================
Cleaning up...
Cleanup complete.
Generating TestParseText.cpp source code...
Source code generated.
Generating Makefile...
Makefile generated.
Building the project...
TestParseText build successful.
Running TestParseText...
Program ran successfully.
Build and test completed.
Cleaning up...
Cleanup complete.
Script finished.
```

#### Test with ASan-Detected Errors:
```
==============================================
   Building and Running TestParseText Unit Test
   ParseText() Unit Test with AddressSanitizer
==============================================
Cleaning up...
Cleanup complete.
Generating TestParseText.cpp source code...
Source code generated.
Generating Makefile...
Makefile generated.
Building the project...
TestParseText build successful.
Running TestParseText...
ASan error detected.
Build and test completed.
Cleaning up...
Cleanup complete.
Script finished.
```

### Cleanup

The script automatically cleans up the following files after execution:
- `TestParseText.cpp`
- `Makefile`
- `TestParseText` (the compiled executable)
- `run.log` (if generated)

## TestParseText.cpp: Unit Test Details

### Purpose

The unit test is designed to validate the behavior of the `ParseText()` function, which parses numerical values from a string and stores them in an array buffer. The test runs a sample input through the `ParseText()` function and ensures the function operates correctly.

### Code Explanation

- **CIccXmlArrayType Class**: 
  - A template class that defines the `ParseText()` function for parsing numerical values from a string.
  - The function reads the input string, extracts valid numbers, and stores them in the provided buffer.
  
- **Main Function**:
  - The main function runs the test with a long sample input string and checks if `ParseText()` can process the string and store the parsed values in the buffer.
  
- **AddressSanitizer (ASan)**:
  - The test integrates **ASan** to detect potential memory-related issues during the test. If any memory issues such as buffer overflows, use-after-free, or invalid accesses are detected, ASan will flag them.

---

### Conclusion

This `README.md` provides all the necessary information to understand and run the self-contained unit test for `ParseText()` using AddressSanitizer. The script automates the entire process, ensuring a simple and reliable way to run the test on both Linux and macOS platforms.
