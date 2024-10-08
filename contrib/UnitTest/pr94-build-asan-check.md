# Unit Test for PR94 Build Check with Asan Checks

This script automates the process of building and testing the DemoIccMAX project, specifically focusing on the PR94 pull request. It includes AddressSanitizer (Asan) checks and performs various tasks such as Git configuration, repository cloning, building the project, and running tests with `CreateAllProfiles.sh`.

## Prerequisites

Ensure the following tools are installed before running the script:

- **Git**: For version control and managing the repository.
- **CMake**: For configuring the project build.
- **Make**: For building the project.
- **Curl**: To fetch external test scripts.
- **AddressSanitizer (Asan)**: To detect memory issues like buffer overflows and undefined behavior.

## Script Overview

The script performs the following tasks:

1. **Git Configuration**: Sets up Git user details for this session.
2. **Repository Cloning**: Clones the DemoIccMAX repository and checks out the PR94 pull request.
3. **Commit Revert**: Reverts a specific commit (`6ac1cc6`) if needed.
4. **CMake Configuration**: Configures the build environment using CMake with AddressSanitizer enabled.
5. **Build Process**: Compiles the project using `make` with multiple processor support.
6. **Running Tests**: Runs the `CreateAllProfiles.sh` script to verify that profile creation works as expected.
7. **Log Management**: All outputs are logged to a file for review, and a summary of the test logs is displayed at the end.
8. **Elapsed Time**: The script tracks and displays the total time taken for execution.

## How to Use

### Step 1: Run from Host

Ensure you are in the appropriate working directory before running the script.

```
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/build_development_branch.sh)"
```
