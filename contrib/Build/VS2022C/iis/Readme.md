# ICC XML HTTP Service - WIP

**Work in Progress**

RESTful service for bidirectional conversion between ICC XML and .icc using iccMAX.

---

## 📌 Features

- **POST endpoints** for ICC XML → `.icc` and `.icc` → XML
- Built on the **iccMAX reference implementation**
- Enables structured roundtrip validation
- Exposes **HTTP interfaces** for fuzzing, CI, and test automation
- Supports integration with tools like **AFL**, **Burp Suite**, and custom harnesses
- Logs stderr, exit codes, and raw inputs for postmortem and traceability
- Foundation for expanding **iccMAX tooling as network services**

---

## 🛠️ Build Overview

### Prerequisites

| Dependency        | Purpose                          | Recommended Source               |
|-------------------|----------------------------------|----------------------------------|
| `clang-cl` or `cl`| C++17 compiler (MSVC-compatible) | [Visual Studio](https://visualstudio.microsoft.com/) |
| `vcpkg`           | Dependency manager               | https://github.com/microsoft/vcpkg |
| `cpprestsdk`      | HTTP REST framework              | `vcpkg install cpprestsdk`       |
| `libxml2`         | XML parser                       | `vcpkg install libxml2`          |
| `IccProfLib`      | Color profile engine             | Local or integrated source tree  |
| `IccLibXML`       | ICC XML schema tools             | Local or integrated source tree  |

### Environment Setup

VS2022 Community

---

### Build Steps

1. Open a `x64 Native Tools Command Prompt for VS 2022`
2. Navigate to the project directory

Run the endpoint .exe files or double click in Explorer.
`iccFromXml_http_service.exe`

Expected output:
```
=============================================
[+] ICC Service Starting... NOT FOR COMMERCIAL USE (OR INTERNET FACING USE)... (c) David H Hoyt LLC 2020-2025
    Timestamp   : 2025-07-16T01:38:52Z
    Endpoint    : http://localhost:8182/iccfromxml
    Thread ID   : 27004
=============================================
[+] Service listening at: http://localhost:8182/
```

---

### Send a Request

**bash**
```
curl -X POST http://localhost:8182/iccfromxml --data-binary "@example.icc.xml" --output profile.icc
```

**pwsh**

```
 & "C:\Windows\System32\curl.exe" -X POST http://localhost:8082/icctoxml --data-binary "@input.xml" --output result.icc
```

---

## 📂 Log Output

- `logs/service_startup.log` — startup banners with timestamps
- `logs/log_req_<timestamp>.log` — per-request stderr + status
- `failed_xml/fail_input_<timestamp>.xml` — archived input on failure

---

## Fuzzing-Ready

This service is ready for fuzzing with:

- **Burp Suite**
- **AFLNet**
- **REST API fuzzers**
- Your custom toolchains

Use malformed XML, compression bombs, or invalid attributes to test your Code!

***iccMAX is _NOT_ Production Ready***

### Sample Output


```
F:\pr121a\PatchIccMAX\Build\iis>run_service.bat

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

## License

`Copyright (c) 2024-2025 David H Hoyt LLC` 

NOT FOR COMMERCIAL USE | DO NOT EXPOSE TO INTERNET | REMOTE CODE EXECUTION DEMONSTRATION (RCE)
