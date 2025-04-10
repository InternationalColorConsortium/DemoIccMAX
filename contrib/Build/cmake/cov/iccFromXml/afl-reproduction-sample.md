# iccFromXml AFL++ Repro Sample

Last Updated: `03-April-2025 0900 EDT` by David Hoyt

This Draft Replay for `Ubuntu-WSL2` will build, fuzz, and triage example bugs from `iccFromXml_afl`, based on AFL++ and AddressSanitizer instrumentation.

---

## Build Configuration

### Makefile: `Makefile.iccFromXml.afl2`
```makefile
CXX := afl-clang-fast++
CXXFLAGS := -O0 -g3 -fno-omit-frame-pointer -fno-inline -fno-eliminate-unused-debug-types -fsanitize=address
INCLUDES := -I../../IccXML/IccLibXML -I../../IccProfLib -I../../IccXML/CmdLine/IccFromXml -I/usr/include/libxml2
LDFLAGS := -Wl,--whole-archive ../iccxml/libIccXML2.a ../iccproflib/libIccProfLib2.a -Wl,--no-whole-archive -lxml2 -fsanitize=address

SRC := ../../IccXML/CmdLine/IccFromXml/IccFromXml.cpp
BIN := iccFromXml_afl

.PHONY: all clean

all: $(BIN)

$(BIN): $(SRC)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $^ -o $@ $(LDFLAGS)

clean:
	rm -f $(BIN)
```

---

## Build & Clean
```bash
make -f Makefile.iccFromXml.afl2 clean
make -f Makefile.iccFromXml.afl2
```

---

## Crash Reproduction Commands

### Reproduce Individual Crashes
```bash
ASAN_OPTIONS=abort_on_error=1:symbolize=1 ./iccFromXml_afl output_afl/fuzzer31/crashes/id:000000,sig:11,... out.icc
```

### Reproduce All
```bash
for crash in output_afl/**/crashes/id:*; do
  echo "[*] Running $crash"
  ASAN_OPTIONS=abort_on_error=1:symbolize=1 ./iccFromXml_afl "$crash" out.icc
done
```

### Extract Unique Crash Sites
```bash
for crash in output_afl/**/crashes/id:*; do
  echo -n "$crash ? "
  ASAN_OPTIONS=abort_on_error=1 ./iccFromXml_afl "$crash" out.icc 2>&1 | \
    grep '#0' | head -n1 | awk '{print $4}'
done | sort | uniq -c | sort -nr
```

---

## Crash Trace Analysis

### PIE Address Normalization
```bash
readelf -Wl ./iccFromXml_afl | grep LOAD
python3 -c 'print(hex(0x559f0988a19d - 0x559f09842000))'  # = 0x4819d
```

### Source Mapping

```bash
addr2line -C -f -e ./iccFromXml_afl 0x4819d
```
**Result:**
```
CIccMpeXmlCalculator::ToXml(std::string&, std::string const&)
/home/xss/pr121/repro1/PatchIccMAX/IccXML/IccLibXML/IccMpeXml.cpp:2283
```

---

## Code Area of Crash
```cpp
if (m_SubElem && m_nSubElem) {
  for (int i = 0; i < (int)m_nSubElem; i++) {
    if (m_SubElem[i]) {
      IIccExtensionMpe *pExt = m_SubElem[i]->GetExtension();
      if (pExt && !strcmp(pExt->GetExtClassName(), "CIccMpeXml")) {
        CIccMpeXml *pMpe = (CIccMpeXml*)pExt;
        pMpe->ToXml(xml, blanks2 + "  "); // line 2283
      } else {
        return false;
      }
    }
  }
}
```
---

## Expected Output

```
Summary stats
=============

       Fuzzers alive : 26
      Dead or remote : 7 (excluded from stats)
      Total run time : 9 days, 9 hours
         Total execs : 522 millions
    Cumulative speed : 16719 execs/sec
       Average speed : 643 execs/sec
       Pending items : 9382 faves, 37832 total
  Pending per fuzzer : 360 faves, 1455 total (on average)
    Coverage reached : 14.13%
       Crashes saved : 325
         Hangs saved : 929
Cycles without finds : 0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0/0
  Time without finds : 10 seconds

Fri Apr  4 05:39:12 EDT 2025

[+] Starting crash triage and minimization...
[*] Minimizing id:000000,sig:11,src:000283,time:7845,execs:22131,op:havoc,rep:1 → id_000000_sig_11_src_000283_time_7845_execs_22131_op_havoc_rep_1
afl-tmin++4.09c by Michal Zalewski

[+] Read 682 bytes from 'output_afl/default/crashes/id:000000,sig:11,src:000283,time:7845,execs:22131,op:havoc,rep:1'.
[*] Spinning up the fork server...
[+] All right - fork server is up.
[*] Target map size: 42115
[*] Performing dry run (mem limit = 0 MB, timeout = 1000 ms)...
[+] Program exits with a signal, minimizing in crash mode.
[*] Stage #0: One-time block normalization...
[+] Block normalization complete, 0 bytes replaced.
[*] --- Pass #1 ---
[*] Stage #1: Removing blocks of data...
    Block length = 64, remaining size = 682
    Block length = 32, remaining size = 682
    Block length = 16, remaining size = 650
    Block length = 8, remaining size = 650
    Block length = 4, remaining size = 642
    Block length = 2, remaining size = 630
    Block length = 1, remaining size = 530
[+] Block removal complete, 185 bytes deleted.
[*] Stage #2: Minimizing symbols (37 code points)...
[+] Symbol minimization finished, 8 symbols (31 bytes) replaced.
[*] Stage #3: Character minimization...
[+] Character minimization done, 0 bytes replaced.
[*] --- Pass #2 ---
[*] Stage #1: Removing blocks of data...
    Block length = 32, remaining size = 497
    Block length = 16, remaining size = 497
    Block length = 8, remaining size = 497
    Block length = 4, remaining size = 489
    Block length = 2, remaining size = 485
    Block length = 1, remaining size = 485
[+] Block removal complete, 13 bytes deleted.
[*] Stage #2: Minimizing symbols (30 code points)...
[+] Symbol minimization finished, 0 symbols (0 bytes) replaced.
[*] Stage #3: Character minimization...
[+] Character minimization done, 0 bytes replaced.
[*] --- Pass #3 ---
[*] Stage #1: Removing blocks of data...
    Block length = 32, remaining size = 484
    Block length = 16, remaining size = 484
    Block length = 8, remaining size = 484
    Block length = 4, remaining size = 484
    Block length = 2, remaining size = 484
    Block length = 1, remaining size = 484
[+] Block removal complete, 0 bytes deleted.

     File size reduced by : 29.03% (to 484 bytes)
    Characters simplified : 6.40%
     Number of execs done : 4111
          Fruitless execs : path=4011 crash=0 hang=0

[*] Writing output to 'minimized/id_000000_sig_11_src_000283_time_7845_execs_22131_op_havoc_rep_1'...
[+] We're done here. Have a nice day!

  → Size reduced: 682 → 484 bytes (-29.03%)
```

## Notes
- Cashes are reproducible on Ubuntu-WSL2.
- Segfaults caused by null or invalid pointer dereference at `CIccMpeXmlCalculator::ToXml()`.
- Targeted patching or asserts needed around pointer use.

---
