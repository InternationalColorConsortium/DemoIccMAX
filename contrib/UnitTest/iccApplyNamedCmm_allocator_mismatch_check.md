# Unit Test for `CreateAllProfiles.sh` with Debug Asan Checks

This script is designed to run a series of unit tests for the `CreateAllProfiles.sh` script, focusing on the detection of an allocator mismatch error observed in the `iccApplyNamedCmm` tool. The script applies AddressSanitizer (Asan) checks and performs tests across various color profiles and environments, including `CalcElement`, `NamedColor`, `GSDF Display`, and `Fluorescent Color` tests. 

## Prerequisites

Ensure that the following requirements are met before running the script:

- **Git**: For managing repositories.
- **Curl**: To fetch test scripts from the repository.
- **DemoIccMAX tools**: Ensure that the binary `IccApplyNamedCmm` is built and available on the system's `$PATH`. This can be done by adding the `../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm` to your environment's `$PATH`.

To verify this, the script will check if the tool is accessible before proceeding.

## Script Overview

This script performs the following tests:

1. **CalcElement Operations**: Tests calculations based on an sRGB ICC profile.
2. **NamedColor Tests**: Runs multiple tests on NamedColor profiles with different illuminants such as D93, D65, D50, and Illuminant A, using different degrees of observer angles (2° and 10°).
3. **Grayscale and RGB GSDF Display Link Profile Tests**: Validates grayscale and RGB displays under different ambient luminance settings.
4. **Fluorescent Color Tests**: Evaluates the handling of fluorescent colors under different illuminants such as D93, D65, D50, and Illuminant A.
5. **Six-Channel Reflectance Camera Tests**: Tests a six-channel reflectance camera profile and its conversion to the Lab color space and other illuminants.

## Usage

### Step 1: Run from Host

Ensure you have the DemoIccMAX environment set up and the necessary tools built:

```
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/iccApplyNamedCmm_allocator_mismatch_check.sh)"
```
