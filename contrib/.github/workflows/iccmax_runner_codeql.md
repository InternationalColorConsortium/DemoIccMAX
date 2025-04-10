# 🛡️ iccMAX CodeQL Workflow

GitHub Actions CI pipeline for CodeQL analysis of `PatchIccMAX` on the `pr123` branch. Includes file validation and header verification steps to ensure analysis scope is accurate.

---

## 🔁 Trigger
```yaml
on:
  workflow_dispatch:
```

---

## 🔐 Permissions
```yaml
permissions:
  contents: write
  security-events: write
```

---

## 🧰 Job: analyze (`ubuntu-latest`)

### Workflow Summary

- **Branch:** `pr123`
- **Analyzer:** `github/codeql-action@v3`
- **Language:** `cpp`
- **Query suite:** `security-and-quality`

---

## 🔧 Steps

1. **Checkout Source**
   - Uses: `actions/checkout@v4`
   - Branch: `pr123`

2. **Initialize CodeQL**
   ```yaml
   uses: github/codeql-action/init@v3
   with:
     languages: cpp
     queries: security-and-quality
     source-root: .
   ```

3. **Debug File Paths**
   - Finds `.cpp` and `.h` files excluding:
     - `Build/`
     - `CMakeFiles/`
   - Stores output in `all_files_list.txt`

4. **Build with CMake**
   - CMake flags include:
     - `-DCMAKE_BUILD_TYPE=Debug`
     - `-fsanitize=address,undefined`
   - Dependencies installed via `apt`
   - Uses `clang` toolchain

5. **Verify Extracted Files**
   - Compares `all_files_list.txt` and `scanned_files_list.txt`
   - Outputs difference to `missing_files.txt`

6. **Header Verification**
   - Explicit check for known required headers:
     - `IccToXml/stdafx.h`
     - `IccLibXML/MainPage.h`
     - `IccWrapper.h`, etc.

7. **Run CodeQL Analysis**
   - Final step executes the actual scan:
     ```yaml
     uses: github/codeql-action/analyze@v3
     ```

---

## 🧪 Notes

- Includes proactive debugging and diff validation before invoking CodeQL scan.
- Explicit header presence check improves scan accuracy.
