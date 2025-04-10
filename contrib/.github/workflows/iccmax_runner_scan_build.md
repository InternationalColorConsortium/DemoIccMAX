# 🧪 iccMAX Scan Build Workflow

Last Updated: `Thu Apr 10 16:34:09 EDT 2025 by David Hoyt`

GitHub Actions CI pipeline for running Clang static analysis (`scan-build`) against the `IccMAX` project.

---

## 🔁 Trigger
```yaml
on:
  workflow_dispatch:
```

---

## 🧰 Job: build-linux

**Runner:** `ubuntu-latest`  
**Branch:** Pull request #122 (`pr-122`)

---

## 🔧 Steps

1. **Checkout Repository**
   ```yaml
   uses: actions/checkout@v4
   ```

2. **Install Dependencies**
   - Packages: `libxml2`, `nlohmann-json3-dev`, `build-essential`, `cmake`, `llvm`, `clang-17`, `libpng-dev`, `libwxgtk3.2-dev`, etc.

3. **Ensure scan-build**
   - Verifies `scan-build` is available in `/usr/lib/llvm-17/bin`.

4. **Clone Source**
   - Clones `DemoIccMAX` and checks out PR #122 as `pr-122`.

5. **CMake Configure with scan-build**
   ```sh
   scan-build cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Release -DENABLE_TOOLS=ON -Wno-dev Cmake/
   ```

6. **Run scan-build**
   ```sh
   scan-build --status-bugs --keep-going -o scan-build-reports make -j$(nproc)
   ```

7. **Upload scan-build Reports**
   - Artifact: `scan-build-reports`

8. **Evaluate scan-build Results**
   - Fails if no `.html` reports found.

9. **Build Success Check**
   - Verifies presence of `CMakeCache.txt`.

10. **Upload Build Artifacts**
    - Artifact: `master-build-linux`

11. **Upload Build Logs**
    - Artifact: `build-logs`

---

## 🧪 Notes

- `continue-on-error: true` used for `scan-build` to allow warnings.
- Evaluation logic ensures reports exist before passing.
