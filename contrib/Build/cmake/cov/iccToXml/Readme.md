# 🛠️ iccToXml Instrumentation Repro

This directory contains a standalone instrumentation + profiling harness for the `IccToXml` tool in the IccMAX project.

## 📄 Description

`iccToXml` converts ICC binary profiles to XML format. This harness builds the tool with Clang instrumentation to enable LLVM coverage analysis.

---

## ✅ Build

```bash
make -f Makefile.iccToXml
```

## ▶️ Run (generate `.profraw`)

```bash
make -f Makefile.iccToXml run
```

## 📊 Generate Coverage Report

```bash
make -f Makefile.iccToXml report
```

Resulting report will be saved in `coverage.txt`.

---

## 📁 Dependencies

- LLVM toolchain (`clang++`, `llvm-profdata`, `llvm-cov`)
- `libxml2-dev`
- Profiling `.a` libs from:
  - `../iccxml/libIccXML2.a`
  - `../iccproflib/libIccProfLib2.a`

---

## 🧪 Inputs

- Input ICC: `../../TestProfiles/Sample.icc`
- Output XML: `out.xml` (temporary)

---


### REPRO

```
 wget https://github.com/xsscx/PatchIccMAX/raw/refs/heads/pr121/contrib/UnitTest/icSigMatrixElemType-Read-poc.icc
 BIN=./iccToXml_test; \
find . -type f -name "*.icc" -print0 | while IFS= read -r -d '' f; do \
  base=$(basename "$f" .icc); \
  out="output_xml/${base}.xml"; \
  echo "[+] $f -> $out"; \
  LLVM_PROFILE_FILE="iccToXml.profraw" "$BIN" "$f" "$out"; \
done
[+] ./icSigMatrixElemType-Read-poc.icc -> output_xml/icSigMatrixElemType-Read-poc.xml
XML successfully created
```
