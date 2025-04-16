# iccMAX Instrumentation

This cov/ directory is part of the iccMAX CICD Pipeline.

##### Last Updated: 31-MAR-2024 0845 EDT by David Hoyt

## Static Libraries with Coverage Instrumentation

`IccProfLib` and `IccXML` static libraries with Tools `icctoXml` `iccFromXml` and `iccDumpprofile`  [are available](https://github.com/xsscx/PatchIccMAX/releases/tag/Instrumentation) and verified to contain `__llvm_prf_data` instrumentation symbols.

### Clone Repo Reproduction

```
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX
export CC=clang
export CXX=clang++
```

### Static Build Reproduction

## Prerequisites

- Clang/LLVM 14 with `llvm-profdata`, `llvm-cov`, `llvm-objdump`, `llvm-nm`
- `genhtml` (for LCOV HTML conversion)
- `libxml2` development headers installed

### Reproduction host

```
uname -a
Linux W5 5.15.167.4-microsoft-standard-WSL2 #1 SMP Tue Nov 5 00:21:55 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux
```

### **tl;dr:** `cd cov && bash build.sh`

#### Expected Output

```
xss@W5:~/pr121/PatchIccMAX$ cd cov && bash build.sh
===================================================================
>>> [PR121] Starting Static Coverage Build (Sun Mar 30 11:07:05 EDT 2025)
===================================================================
[+] Building libIccProfLib2.a (instrumented static)
make[1]: Entering directory '/home/xss/pr121/PatchIccMAX/cov/iccproflib'
[OK] Built 35 object files into libIccProfLib2.a
make[1]: Leaving directory '/home/xss/pr121/PatchIccMAX/cov/iccproflib'
[+] Building libIccXML2.a (instrumented static)
make[1]: Entering directory '/home/xss/pr121/PatchIccMAX/cov/iccxml'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/xss/pr121/PatchIccMAX/cov/iccxml'
[~] Verifying instrumentation in libIccProfLib2.a
   [INSTRUMENTED] IccApplyBPC.o
   [INSTRUMENTED] IccArrayBasic.o
   [INSTRUMENTED] IccArrayFactory.o
   [INSTRUMENTED] IccCAM.o
   [INSTRUMENTED] IccCmm.o
   [INSTRUMENTED] IccConvertUTF.o
   [INSTRUMENTED] IccEncoding.o
   [INSTRUMENTED] IccEnvVar.o
   [INSTRUMENTED] IccEval.o
   [INSTRUMENTED] IccIO.o
   [INSTRUMENTED] IccMD5.o
   [INSTRUMENTED] IccMatrixMath.o
   [INSTRUMENTED] IccMpeACS.o
   [INSTRUMENTED] IccMpeBasic.o
   [INSTRUMENTED] IccMpeCalc.o
   [INSTRUMENTED] IccMpeFactory.o
   [INSTRUMENTED] IccMpeSpectral.o
   [INSTRUMENTED] IccPcc.o
   [INSTRUMENTED] IccPrmg.o
   [INSTRUMENTED] IccProfile.o
   [INSTRUMENTED] IccSolve.o
   [INSTRUMENTED] IccSparseMatrix.o
   [INSTRUMENTED] IccStructBasic.o
   [INSTRUMENTED] IccStructFactory.o
   [INSTRUMENTED] IccTagBasic.o
   [INSTRUMENTED] IccTagComposite.o
   [INSTRUMENTED] IccTagDict.o
   [INSTRUMENTED] IccTagEmbedIcc.o
   [INSTRUMENTED] IccTagFactory.o
   [INSTRUMENTED] IccTagLut.o
   [INSTRUMENTED] IccTagMPE.o
   [INSTRUMENTED] IccTagProfSeqId.o
   [INSTRUMENTED] IccUtil.o
   [INSTRUMENTED] IccWrapper.o
   [INSTRUMENTED] IccXformFactory.o
[~] Verifying instrumentation in libIccXML2.a
   [INSTRUMENTED] IccIoXml.o
   [INSTRUMENTED] IccMpeXml.o
   [INSTRUMENTED] IccMpeXmlFactory.o
   [INSTRUMENTED] IccProfileXml.o
   [INSTRUMENTED] IccTagXml.o
   [INSTRUMENTED] IccTagXmlFactory.o
   [INSTRUMENTED] IccUtilXml.o
[~] Verifying instrumentation of built tools
[...] Checking iccToXml_test
[PASS] iccToXml_test is instrumented
[...] Checking iccFromXml_test
[PASS] iccFromXml_test is instrumented
[...] Checking iccDumpProfile_test
[PASS] iccDumpProfile_test is instrumented
===================================================================
>>> [PR121] Static Coverage Build Finished (Sun Mar 30 11:07:05 EDT 2025)
===================================================================
>>> Elapsed Time: 0 seconds
```

---

### Reproduction by Lib and Tool

## 1. Build Instrumented Static Libraries
### Static Libraries with Coverage Instrumentation

`IccProfLib` and `IccXML` static libraries [are available](https://github.com/xsscx/PatchIccMAX/releases/tag/Instrumentation) and verified to contain `__llvm_prf_data` instrumentation symbols.

### libIccProfLib2.a (Static, Instrumented)

```
cd cov/iccproflib
make -f Makefile.proflib
ar -x libIccProfLib2.a && for f in *.o; do llvm-objdump -h "$f" | grep -q __llvm_prf_data && echo "  ? [INSTRUMENTED] $f"; done; rm -f *.o
```

Output:
```
  [INSTRUMENTED] IccApplyBPC.o
  [INSTRUMENTED] IccArrayBasic.o
  ...
  [INSTRUMENTED] IccXformFactory.o
```

---

### libIccXML2.a (Static, Instrumented)

```
cd cov/iccxml
make -f Makefile.iccxml check-prof
```

Output:
```
[CHECK] Extracting and checking instrumentation in libIccXML2.a
  [INSTRUMENTED] IccIoXml.o
  ...
  [INSTRUMENTED] IccUtilXml.o
Instrumentation detected.
```

---

These verified `.a` files are now ready for linking into profiled tools (e.g., `iccToXml`, `iccFromXml`) to generate runtime coverage.


---

## 2. Build `iccToXml_test` with Profiling

```bash
cd cov/iccToXml
make -f Makefile.iccToXml clean all
# Links against the instrumented .a files above
```

---

## 3. Run Profiled Executions (Per Input)

```bash
# === Pass 1: iccToXml ===
mkdir -p output_xml
BIN=./iccToXml_test
find . -type f -name "*.icc" -print0 | while IFS= read -r -d '' f; do
  base="$(basename "$f" .icc)"
  out="output_xml/${base}.xml"
  echo "[+] $f -> $out"
  LLVM_PROFILE_FILE="iccToXml_${base}.profraw" "$BIN" "$f" "$out"
done


```

---

## 4. Merge Profiles into Unified `.profdata`

```bash
llvm-profdata merge -sparse *.profraw -o iccToXml.profdata
```

---

## 5. Generate Coverage Reports

### Text:
```bash
llvm-cov show ./iccToXml_test -instr-profile=iccToXml.profdata > iccToXml-coverage.txt
```

### Summary:
```bash
llvm-cov report ./iccToXml_test -instr-profile=iccToXml.profdata
```

### LCOV for HTML:
```bash
llvm-cov export ./iccToXml_test -instr-profile=iccToXml.profdata -format=lcov > coverage.lcov
genhtml -o htmlcov coverage.lcov
```

Open with:
```bash
xdg-open htmlcov/index.html
# or open htmlcov/index.html (macOS)
```

---

## Example Output

| Module                         | Line Coverage | Function Coverage |
|--------------------------------|----------------|--------------------|
| `IccProfLib/`                  | 6.6%           | 9.3%               |
| `IccXML/CmdLine/IccToXml/`     | 56.8%        | 100.0%           |
| `IccXML/IccLibXML/`            | 10.9%          | 16.6%              |

Total (all modules):  
**Lines**: 7.5% (3415 / 45609)  
**Functions**: 10.6% (363 / 3413)

---

## Insight

- Use `for f in profraw/*.profraw; do
  echo "[*] $f"
  llvm-profdata show -counts "$f" 2>/dev/null || echo "?? Skipped: $f"
done
` to analyze per-input hit data
- Identify low-coverage `.icc` inputs to prune or re-fuzz
- Use high-impact ones (`test1.icc`, `test2.icc`) as seeds for fuzzing

---

## Clean Up

```bash
rm -rf *.o *.profraw *.profdata output_xml/ htmlcov/ iccToXml-coverage.txt coverage.lcov
`````
