# 🛠️ iccDumpProfile Instrumentation Repro

This directory provides a standalone profiling and LLVM coverage harness for the `iccDumpProfile` CLI tool.

## 📄 Description

`iccDumpProfile` reads and dumps the internal structure of an ICC profile. This harness compiles it with Clang instrumentation for coverage analysis.

---

## ✅ Build

```bash
make -f Makefile.iccDumpProfile
```

## ▶️ Run (generates .profraw)

```bash
make -f Makefile.iccDumpProfile run
```

## 📊 Generate Coverage Report

```bash
make -f Makefile.iccDumpProfile report
```

This produces `coverage_iccdumpprofile.txt`.

---

## 📁 Dependencies

- Clang/LLVM toolchain (clang++, llvm-profdata, llvm-cov)
- `libxml2-dev`
- Instrumented static libraries:
  - `../iccxml/libIccXML2.a`
  - `../iccproflib/libIccProfLib2.a`

---

## 🧪 Inputs

- Uses default execution (`--help` or similar).
- Adjust `make run` to specify an ICC file for full path coverage.

---
