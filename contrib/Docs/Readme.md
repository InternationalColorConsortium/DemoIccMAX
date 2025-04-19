
# Bug Report Samples

This directory contains community provided documentation, sample bug reports and pull request examples.

## Reference Implementation

The `IccMAX` reference implementation is intended as a guideline and **should not be considered production-ready code**. If you plan to use this code in a production environment, best practice includes:
- Performing a thorough security review, including static and dynamic analysis tools.
- Applying security patches for known vulnerabilities (see the CVEs listed below).
- Conducting extensive product testing, including fuzzing and performance testing, to ensure stability and security.
  
## Bug Reporting

When you discover a bug or unexpected behavior, please [open an issue](https://github.com/InternationalColorConsortium/DemoIccMAX/issues) with the following details:
1. **Description**: A clear and concise explanation of the issue.
2. **Steps to Reproduce**: A step-by-step guide on how to reproduce the bug.
3. **Expected Behavior**: What you expected to happen.
4. **Actual Behavior**: What actually happened.
5. **Environment**: Information about your environment (OS, version of `DemoIccMAX`, etc.).
6. **Proof of Concept**: If possible, provide a minimal reproducible example or test case.
7. **Severity**: Indicate whether this is a **Bug** or **Bad** issue (see Severity below).
8. **Patch (Optional)**: We encourage contributors to submit a patch along with the report when possible.

### Severity

- **Bug**: If user-controllable input causes a crash or results in unexpected behavior that could be exploited for Denial of Service (DoS).
- **Bad**: If user-controllable input causes arbitrary code execution, privilege escalation, or data corruption.
- **Info Disclosure**: If user-controllable input leads to the unintended exposure of sensitive data (e.g., out-of-bounds reads leading to information leaks).

## How to Submit

- **GitHub Issues**: [Submit Issue](https://github.com/InternationalColorConsortium/DemoIccMAX/issues)

---
