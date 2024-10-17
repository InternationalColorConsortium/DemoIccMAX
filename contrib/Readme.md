# DemoIccMAX Project - Unit Tests and Build Scripts

This directory contains various scripts, test files, and documentation related to the DemoIccMAX project. The scripts and tests focus on profile creation, cross-checking, build verification, and sanitization (Asan/UBSan) for detecting memory-related issues. The purpose of these scripts is to automate testing, ensure code correctness, and track any vulnerabilities in the DemoIccMAX project.


## Directory Structure

### Profile Creation and Testing Scripts

- [CreateAllProfiles.sh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/development/contrib/UnitTest/CreateAllProfiles.sh)  
  Automates the process of creating ICC profiles within the DemoIccMAX environment. The script is designed to validate profile creation by running tests and generating logs for analysis.

**Run:**

   ```
   cd Testing/
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles.sh)"
   ```

- [CreateAllProfiles_cross_check.sh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/CreateAllProfiles_cross_check.sh)  
  A more comprehensive profile creation script that performs cross-checks on the generated profiles. It ensures consistency and correctness across profiles by comparing them to a reference set.

**Run:**

   ```
   cd Testing/
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles_cross_check.sh)"
   ```

- [CreateAllProfiles_cross_check.md](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/CreateAllProfiles_cross_check.md)  
  Documentation detailing the cross-check process for the generated profiles, including expected results and error handling steps.

### Build and Branch Management Scripts

- [build_development_branch.sh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/build_development_branch.sh)  
  This script is responsible for building the development branch of the DemoIccMAX project. It configures the build environment using CMake and Make, then runs various tests to verify the build’s correctness. It also includes AddressSanitizer (Asan) checks.

**Run:**

   ```
   cd /tmp
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/build_development_branch.sh)"
   ```

- [build_development_branch.md](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/build_development_branch.md)  
  Documentation for the `build_development_branch.sh` script, including instructions on how to use the script, required dependencies, and troubleshooting tips for build failures.

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

- [pcs_asan_test_CreateAllProfiles.sh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/pcs_asan_test_CreateAllProfiles.sh)  
  Performs AddressSanitizer (Asan) checks specifically during the profile creation process, ensuring that no memory leaks or invalid accesses occur.

- [pcs_refactor_create_profiles.sh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/pcs_refactor_create_profiles.sh), [pcs_refactor_build_createprofiles_check.sh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/pcs_refactor_build_createprofiles_check.sh)  
  These scripts focus on refactoring the profile creation process with added Asan checks to ensure code quality during refactoring.

### Reports and Documentation

- [pr94-build-asan-check.md](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/pr94-build-asan-check.md), [pr94-build-asan-check.sh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/pr94-build-asan-check.sh)  
  Focuses on the PR94 build check, ensuring that PR94 is built correctly with AddressSanitizer (Asan) enabled. The script configures, builds, and tests the PR94 pull request.

- [pcs_revert_build_asan_report.md](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/pcs_revert_build_asan_report.md), [pcs_revert_build_asan_report.sh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/pcs_revert_build_asan_report.sh)  
  This script handles reverting specific commits and running Asan checks after the revert to ensure that the codebase remains stable.

- [ubsan_samples_consolidated_report.md](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/ubsan_samples_consolidated_report.md)  
  A report consolidating the results of Undefined Behavior Sanitizer (UBSan) tests. It captures and highlights issues found during the UBSan checks in various components of the DemoIccMAX project.

### ICC Profiles for Testing

- [icPlatformSignature-ubsan-poc.icc](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc)  
  A test ICC profile used to check for UBSan (Undefined Behavior Sanitizer) issues with the platform signature element.

- [icSigMatrixElemType-Read-poc.icc](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/icSigMatrixElemType-Read-poc.icc)  
  Another test ICC profile, designed to identify UBSan issues when reading matrix element types.

### Reports and Documentation

- [pr94-build-asan-check.md](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/pr94-build-asan-check.md), [pr94-build-asan-check.sh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/pr94-build-asan-check.sh)  
  Focuses on the PR94 build check, ensuring that PR94 is built correctly with AddressSanitizer (Asan) enabled. The script configures, builds, and tests the PR94 pull request.

- [pcs_revert_build_asan_report.md](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/pcs_revert_build_asan_report.md), [pcs_revert_build_asan_report.sh](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/pcs_revert_build_asan_report.sh)  
  This script handles reverting specific commits and running Asan checks after the revert to ensure that the codebase remains stable.

- [ubsan_samples_consolidated_report.md](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/ubsan_samples_consolidated_report.md)  
  A report consolidating the results of Undefined Behavior Sanitizer (UBSan) tests. It captures and highlights issues found during the UBSan checks in various components of the DemoIccMAX project.

### ICC Profiles for Testing

- [icPlatformSignature-ubsan-poc.icc](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc)  
  A test ICC profile used to check for UBSan (Undefined Behavior Sanitizer) issues with the platform signature element.

**Run:**
   ```
   cd Testing/
   /bin/sh -c 'curl -fsSL -o iccProfile.icc https://github.com/InternationalColorConsortium/DemoIccMAX/raw/master/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc && ../Build/Tools/IccDumpProfile/iccDumpProfile 100 iccProfile.icc ALL'
   ```

- [icSigMatrixElemType-Read-poc.icc](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/master/contrib/UnitTest/icSigMatrixElemType-Read-poc.icc)  
  Another test ICC profile, designed to identify UBSan issues when reading matrix element types.

## How to Use

1. **Build.log**

```
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/build_master_branch.sh)" > build.log 2>&1 & script_pid=$!; while [ ! -f build.log ]; do sleep 1; done; tail --pid=$script_pid -f build.log; wait $script_pid
```

2. **Run icPlatformSignature Check**  
   To run the icPlatformSignature Check, switch your directory to contrib/UnitTest/ then paste the following commnd into your terminal:
```
/bin/sh -c 'curl -fsSL -o iccProfile.icc https://github.com/InternationalColorConsortium/DemoIccMAX/raw/master/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc && ../Build/Tools/IccDumpProfile/iccDumpProfile 100 iccProfile.icc ALL'
```
 
