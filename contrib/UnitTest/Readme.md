# DemoIccMAX Project - Unit Tests and Build Scripts

This directory contains various scripts, test files, and documentation related to the DemoIccMAX project. The scripts and tests provide examples for profile creation, cross-checking, build verification, and sanitization (Asan/UBSan) for detecting memory-related issues. The purpose of these scripts is to automate testing, ensure code correctness, and track prior vulnerabilities in the DemoIccMAX project.

## Directory Structure

### Profile Creation and Testing Scripts

- [CreateAllProfiles.sh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/development/contrib/UnitTest/CreateAllProfiles.sh)  
  Automates the process of creating ICC profiles within the DemoIccMAX environment. The script is designed to validate profile creation by running tests and generating logs for analysis.

**Run:**

   ```
   cd Testing/
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
   ```

### CVE and Vulnerability Tests

- [cve-2023-46602.icc](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/cve-2023-46602.icc), [cve-2023-46602.zsh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/cve-2023-46602.zsh), [cve-2023-46602-icFixXml-function-IccTagXml_cpp-line_337-baseline-variant-000.xml](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/cve-2023-46602-icFixXml-function-IccTagXml_cpp-line_337-baseline-variant-000.xml)  
  These files provide tests for the CVE-2023-46602 vulnerability. The scripts and ICC profile files are designed to test edge cases that may trigger memory or security issues within the project.

- [TestCIccTagXmlProfileSequenceId.cpp](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/TestCIccTagXmlProfileSequenceId.cpp)  
  A unit test targeting specific vulnerabilities, particularly around handling of the ICC profile sequence ID tag in XML.

- [TestParseText.cpp](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/TestParseText.cpp)  
  Another test file aimed at parsing issues and vulnerabilities, such as the one identified in CVE-2023-44062.

### Memory Sanitization (Asan/UBSan) Scripts

- [iccApplyNamedCmm_allocator_mismatch_check.sh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/iccApplyNamedCmm_allocator_mismatch_check.sh)  
  Runs a series of tests with Asan enabled to catch allocator mismatch errors within the `iccApplyNamedCmm` tool.

### Reports and Documentation

- [ubsan_samples_consolidated_report.md](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/ubsan_samples_consolidated_report.md)  
  A report consolidating the results of Undefined Behavior Sanitizer (UBSan) tests. It captures and highlights issues found during the UBSan checks in various components of the DemoIccMAX project.

### ICC Profiles for Testing

- [icPlatformSignature-ubsan-poc.icc](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc)  
  A test ICC profile used to check for UBSan (Undefined Behavior Sanitizer) issues with the platform signature element.

- [icSigMatrixElemType-Read-poc.icc](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/icSigMatrixElemType-Read-poc.icc)  
  Another test ICC profile, designed to identify UBSan issues when reading matrix element types.

**PoC:**
   ```
   cd Testing/
   /bin/sh -c 'curl -fsSL -o iccProfile.icc https://github.com/InternationalColorConsortium/DemoIccMAX/raw/master/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc && ../Build/Tools/IccDumpProfile/iccDumpProfile 100 iccProfile.icc ALL'
   ```
 
