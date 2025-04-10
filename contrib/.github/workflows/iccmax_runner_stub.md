# 🧪 icc Runner Stub Workflow

Linux-only GitHub Actions workflow for building and testing `PatchIccMAX` PR122 branch with enhanced debug configuration and device/system reporting.

---

## 🔁 Trigger
```yaml
on:
  workflow_dispatch:
```

---

## 🧰 Job: build-linux (`ubuntu-latest`)

### Workflow Summary

- **Branch:** `pr122`
- **Compiler:** `gcc` explicitly set
- **Sanitizers:** `-fsanitize=address,undefined`
- **Build Type:** `Debug`
- **Tests:** Runs `iccMAX-cicd-build-checks.sh` post-build

---

## 🔧 Steps

1. **Checkout Repository**
   - Uses: `actions/checkout@v4`

2. **Configure Git Identity**
   - Anonymous GitHub Actions identity

3. **Install Dependencies**
   - Packages: `clang-17`, `wxWidgets`, `libxml2`, `nlohmann-json`, etc.

4. **Clone PatchIccMAX**
   - Branch: `pr122`

5. **CMake Configure**
   - Flags:
     - `ENABLE_TOOLS=ON`
     - `ENABLE_STATIC_LIBS=ON`
     - `ENABLE_SHARED_LIBS=ON`
     - `ENABLE_TESTS=ON`
     - `ENABLE_INSTALL_RIM=ON`
     - `ENABLE_ICCXML=ON`
   - Sanitizers enabled with debug flags

6. **Build and Run CI Script**
   - `make -j$(nproc)`
   - Executes CI shell script from `contrib/UnitTest`

7. **Gather System Info**
   - `uname`, `gcc -v`, `lscpu`, `free -m`, `df -h`

8. **Validate Build**
   - Check for presence of `CMakeCache.txt`

9. **Upload Artifacts**
   - `master-build-linux`
   - `build-logs` (note: misaligned path, points to `DemoIccMAX` instead of `PatchIccMAX`)
   
---

## ⚠️ Notes

- **Explicit compiler override:** `CC=gcc`, `CXX=g++`
- **Logging script call present**
- **Known bug:** log path for `CMakeCache.txt` references `DemoIccMAX`, should likely be `PatchIccMAX`

