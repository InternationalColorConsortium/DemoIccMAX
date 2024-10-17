# Unit Test for Profile Creation and Cross Check with Report

This script automates the profile creation process and performs a series of cross checks and tests for the DemoIccMAX project. The script is designed to generate profiles, run tests on various components (such as HDR, Overprint, and MCS), and produce a final report summarizing the test results.

## Prerequisites

Ensure the following are installed on your system before running the script:

- **Git**: For managing repositories and fetching scripts.
- **Curl**: To fetch remote scripts and data from the repository.
- **Bash**: To execute shell commands.
- **DemoIccMAX environment**: The necessary binaries and libraries for creating profiles and running tests.

## Script Overview

The script performs the following steps:

1. **Profile Creation**: Generates profiles using the `CreateAllProfiles.sh` script.
2. **Running Core Tests**: Executes the main testing script to validate the profile creation process.
3. **Component-Specific Testing**: Runs tests for various components, including `CalcTest`, `HDR`, `Overprint`, and `MCS`.
4. **Cross Checks and Updates**: Performs background and other updates for MCS, followed by a cross-check.
5. **Final Summary Report**: Generates a testing summary report, aggregating results from all the tests.
6. **Logging**: All steps are logged into `profile-checks.log` for detailed review.

## How to Run

### Step 1: Run from Host

Ensure you are in the appropriate directory for the DemoIccMAX project.

```
cd Testing/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/CreateAllProfiles_cross_check.sh)"
```
