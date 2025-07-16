# `iccMAX Version 2.2.6`

[PR129](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/129) addressed Bug Classes and other Housekeeping.

### Added Homebrew Formula

**brew install iccmax**

Coming Soon: vcpkg install iccmax

### Triples Tested

| **Operating System**         | **Kernel Version**                               | **Architecture**     | **Environment**                       |
|-----------------------------|--------------------------------------------------|----------------------|---------------------------------------|
| Linux (Ubuntu 24.04 LTS)     | Linux Kernel 6.8.0-31-generic (glibc)   | x86_64           | Homebrew Test-Bot Container (Ubuntu) |
| macOS 15 Sequoia             | Darwin Kernel Version 24.0.0            | ARM64            | macOS 15-arm64 Runner              |
| macOS 15 Sequoia             | Darwin Kernel Version 24.0.0            | x86_64           | macOS 15-x86_64 Runner             |
| macOS 14 Sonoma              | Darwin Kernel Version 23.0.0            | ARM64            | macOS 14-arm64 Runner              |
| macOS 14 Sonoma              | Darwin Kernel Version 23.0.0            | x86_64           | macOS 14-x86_64 Runner             |
| macOS 13 Ventura             | Darwin Kernel Version 22.0.0            | ARM64            | macOS 13-arm64 Runner              |
| macOS 13 Ventura             | Darwin Kernel Version 22.0.0            | x86_64           | macOS 13-x86_64 Runner             |
| iOS (iPhone 16 Pro Max) | Darwin Kernel Version 24.4.0 (iOS 18.4)          | arm64e               | iOS_ARM64E_A18_PRO                    |
| iOS (iPad Pro M4)     | Darwin Kernel Version 24.4.0 (iPadOS 18.4)       | arm64                | iOS_ARM64_M4_IPAD_PRO                 |
| WSL2 (Linux)                | 5.15.167.4-microsoft-standard-WSL2               | x86_64               | GNU/Linux                             |
| Microsoft Windows 11 Pro    | Version 10.0.26100 Build 26100                   | x86_64               | Visual Studio 17.13.6                 |
| Microsoft Windows 11 ARM    | Version 10.0.26100 Build 26100                   | ARM64            | windows-11-arm GitHub Runner      |
| Raspberry Pi OS (Debian)    | Linux 6.1.21-v8+ #1642 SMP PREEMPT               | aarch64 (ARMv8)      | GCC 10.2.1 (Debian 10.2.1-6)          |

### PR Refactor Summary

**Scan Build**

`Ubuntu clang version 18.1.3 (1ubuntu1)`
	
| **Bug Type**     | **Sub-Type**                      | **START** | **CURRENT** |
|------------------|-----------------------------------|--------------------|----------------------|
| **All Bugs**     |                                   | 67                 | 47                    |
| **Logic Error**  | Assigned value is garbage         | 1                  | -                    |
|                  | Dereference of null pointer       | 1                  | -                    |
|                  | Garbage return value              | 1                  | -                    |
|                  | Result of op is garbage/undefined | 4                  | -                    |
|                  | Uninitialized argument value      | 3                  | -                    |
| **Memory Error** | Double delete                     | 1                  | -                    |
|                  | Memory leak                       | 1                  | -                    |
|                  | Use of zero allocated             | 1                  | -                    |
|                  | Use-after-free                    | 2                  | -                    |
| **Unused Code**  | Dead assignment                   | 24                 | 21                   |
|                  | Dead increment                    | 4                  | 4                    |
|                  | Dead initialization               | 22                 | 20                   |
|                  | Dead nested assignment            | 2                  | 2                    |

**Code Audit**

| **Bug Type**     | **Sub-Type**                      | **START** | **CURRENT** |
|------------------|-----------------------------------|--------------------|----------------------|
| **All Bugs**     |                                   | 874                 | 848                 |
| **Other**        | Code Review, CodeQL Bugs          | 860                 | 840                 |
| **Heap or Stack**  | Over, Under, Other              | 14                  | 8                   |


---

## AFL Build

```
[*] Verifying tool instrumentation...
[PASS] iccToXml/iccToXml_test is instrumented
[PASS] iccFromXml/iccFromXml_test is instrumented
[PASS] iccDumpProfile/iccDumpProfile_test is instrumented
[PASS] iccRoundTrip/iccRoundTrip_afl is instrumented
[PASS] iccApplyNamedCmm/iccApplyNamedCmm_afl is instrumented
[PASS] iccApplyProfiles/iccApplyProfiles_afl is instrumented
[PASS] iccTiffDump/iccTiffDump_afl is instrumented
[PASS] iccPngDump/iccPngDump_afl is instrumented
```

---

## icc XML HTTP Service

RESTful service for bidirectional conversion between ICC XML and .icc using iccMAX.

---

### 📌 icc XHR Features

- **POST endpoints** for ICC XML → `.icc` and `.icc` → XML
- Built on the **iccMAX reference implementation**
- Enables structured roundtrip validation
- Exposes **HTTP interfaces** for fuzzing, CI, and test automation
- Supports integration with tools like **AFL**, **Burp Suite**, and custom harnesses
- Logs stderr, exit codes, and raw inputs for postmortem and traceability
- Foundation for expanding **iccMAX tooling as network services**

## 🧪 Fuzzing-Ready

This service is ready for fuzzing with:

- **Burp Suite**
- **AFLNet**
- **REST API fuzzers**
- Your custom toolchains


### Sample Output


```
F:\pr129\PatchIccMAX\Build\iis>run_service.bat

[*] Starting ICC XML HTTP Service on: http://localhost:8182/icctoxml

[+] Service listening at: http://localhost:8182/icctoxml
[+] Received POST request
[+] Extracted UTF-8 body, size: 134591
[+] Received POST request
[+] Extracted UTF-8 body, size: 43245
[+] Received POST request
[+] Extracted UTF-8 body, size: 8544
...
XML successfully created
XML successfully created
Unable to read 'temp_input.icc'
Unable to read 'temp_input.icc'
...
XML successfully created
XML successfully created
```

---

## 🔒 Security Notes

- Input size is not validated — use in isolated test environments.
- XML parser is libxml2 — known to tolerate many malformed patterns.

---

