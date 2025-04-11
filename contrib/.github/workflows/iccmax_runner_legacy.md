# 🧪 iccMAX Runner | Legacy Check Workflow

Last Updated: `Thu Apr 10 16:34:09 EDT 2025 by David Hoyt`

This GitHub Actions workflow runs a cross-platform build matrix to verify compatibility across legacy Ubuntu and macOS environments using both GCC and Clang.

## 🔁 Trigger

```yaml
on:
  workflow_dispatch:
```

## 🧰 Job Matrix: `build`

| OS            | Compiler |
|---------------|----------|
| ubuntu-22.04  | gcc      |
| ubuntu-22.04  | clang    |
| ubuntu-20.04  | gcc      |
| ubuntu-20.04  | clang    |
| macos-latest  | clang    |
| macos-13      | clang    |

## 🪛 Steps Summary

1. **🧾 Checkout PR Source**
   - Uses different PR branches:
     - `pr120` for macOS
     - `pr122` for Linux

2. **⚙️ Configure Git Identity**
   - Sets up Git user for automation context.

3. **📦 Install Dependencies**
   - **Linux**:
     - Installs build-essential packages, dev libraries, and tools.
   - **macOS**:
     - Uses Homebrew to install equivalent libraries.

4. **🧱 Build wxWidgets (Linux Only)**
   - Clones and builds `wxWidgets` from source.

5. **💡 Set Compiler Environment**
   - Exports `CC` and `CXX` based on the matrix compiler.

6. **🛠️ CMake Configuration**
   - macOS-specific tweaks (like handling `Mono.framework`).
   - Configures CMake for both static/shared builds.

7. **🔨 Build Project**
   - Executes `make` using max concurrency.

8. **✅ Verify Build Output**
   - Confirms presence of `CMakeCache.txt`.

9. **🧳 Upload Build Artifacts**
   - Artifacts named by OS and compiler.

10. **📄 Upload CMake Logs**
    - Uploads `CMakeCache.txt` for review.

11. **🖥️ Host System Info**
    - Dumps system details (`uname`, `os-release`, `clang/gcc --version`, etc.).

---

## 📁 Artifacts Naming Convention

- **Build Output**: `iccmax-<os>-<compiler>-release`
- **CMake Logs**: `cmake-log-<os>-<compiler>`

---

## ✅ Usage

Trigger the workflow manually from the GitHub Actions UI using the `Run workflow` button in the **Actions** tab.
