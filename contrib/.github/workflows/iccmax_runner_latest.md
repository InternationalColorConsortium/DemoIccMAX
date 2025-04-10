# ✅ Latest iccMAX Workflow

Last Updated: `Thu Apr 10 16:34:09 EDT 2025 by David Hoyt`

Multi-platform GitHub Actions CI pipeline for building and validating the `PatchIccMAX`/`DemoIccMAX` toolchain on Linux, macOS, and Windows.

---

## 🔁 Trigger
```yaml
on:
  workflow_dispatch:
```

---

## 🧰 Jobs

### Linux (`ubuntu-latest`)

**Matrix:** `compiler: [gcc, clang]`  
**Branch:** `pr122`

- Install build tools and libraries via `apt`
- Set `CC` and `CXX` based on matrix
- `cmake` build and `make`
- Validate `CMakeCache.txt`
- Upload artifact:
  - `iccmax-linux-gcc`
  - `iccmax-linux-clang`

---

### macOS (`macos-latest`)

- Install dependencies via Homebrew
- Set compiler: `clang`
- Remove `Mono.framework/png.h` if present
- Export `CFLAGS`, `LDFLAGS`
- Run build with `cmake` and `make`
- Call CI test script:  
  `iccMAX-cicd-build-checks.sh` via `curl | bash`
- Validate `CMakeCache.txt`
- Upload artifact:
  - `iccmax-macos-clang`

---

### Windows (`windows-latest`)

- Use `MSBuild` and `Visual Studio 17 2022`
- Restore `vcpkg` packages for:
  - `libpng`, `nlohmann-json`, `libxml2`, `wxwidgets`, `tiff`
- Clone `PatchIccMAX` and checkout `pr122`
- Configure CMake build using vcpkg toolchain
- Full release build with `/m /maxcpucount:32`
- Validate `CMakeCache.txt`
- Upload artifacts:
  - `Windows Build-Artifacts`
  - `Windows Build-Logs`

---

## 📦 Artifacts Summary

| Platform | Artifact Name(s)                  |
|----------|-----------------------------------|
| Linux    | `iccmax-linux-gcc`, `iccmax-linux-clang` |
| macOS    | `iccmax-macos-clang`              |
| Windows  | `Windows Build-Artifacts`, `Windows Build-Logs` |

---

## ✅ Build Coverage

- Shared and static libraries (`ENABLE_STATIC_LIBS`, `ENABLE_SHARED_LIBS`)
- CI test hooks via shell script (macOS)
- vcpkg toolchain validation on Windows
