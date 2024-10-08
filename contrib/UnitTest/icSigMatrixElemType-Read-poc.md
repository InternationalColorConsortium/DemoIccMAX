# Type Confusion in `CIccMpeCalculator::Read`

### LLDB Debugging Session and Analysis

## PoC

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/icSigMatrixElemType-Read-poc.sh)"
```

### Manual Debugging with lldb

#### 1. Breakpoint Setup
- A breakpoint set at line 4562 in `IccMpeCalc.cpp`, which is where the type confusion occurs:
```bash
(lldb) breakpoint set --file IccMpeCalc.cpp --line 4562
```

- Upon running the program (`iccToXml`), the process stops at the specified breakpoint, confirming that the program reached the problematic code segment.

#### 2. Inspecting `this` Pointer
```bash
(lldb) p *this
(CIccMpeCalculator) {
  CIccMultiProcessElement = (m_nReserved = 0, m_nInputChannels = 11, m_nOutputChannels = 36)
  m_nTempChannels = 0
  m_bNeedTempReset = true
  m_nSubElem = 2
  m_SubElem = 0x0000602000000250
  m_calcFunc = nullptr
  m_pCmmEnvVarLookup = nullptr
}
```
- The `this` pointer is confirmed to be of type `CIccMpeCalculator`.

#### 3. Inspecting `pElem`
```bash
(lldb) p *pElem
(CIccMultiProcessElement)  (m_nReserved = 0, m_nInputChannels = 11, m_nOutputChannels = 36)
```
- `pElem` is treated as a `CIccMultiProcessElement`, but we see below it is a `CIccMpeXmlMatrix`.

#### 4. Checking the Virtual Table Pointer (`vptr`)
```bash
(lldb) p *(void**)this
(void *) 0x0000000100d42130
```
- The `vptr` indicates that `this` is indeed pointing to a `CIccMpeCalculator`.

#### 5. Inspecting the Element Signature (`elemSig`)
```bash
(lldb) p elemSig
(icElemTypeSignature) icSigMatrixElemType
```
- The element signature is `icSigMatrixElemType`, indicating that `pElem` is actually a `CIccMpeXmlMatrix`.

### Observations

1. **Type of `this`:** The `this` pointer is correctly identified as a `CIccMpeCalculator`.
2. **Type of `pElem`:** The `pElem` pointer is treated as a `CIccMultiProcessElement`, but based on the `elemSig`, it is actually a `CIccMpeXmlMatrix`.
3. **Type Confusion Confirmation:** Since `pElem` is a `CIccMpeXmlMatrix` (as indicated by `elemSig` being `icSigMatrixElemType`), but it's being cast to a `CIccMpeCalculator` within the `SetSubElem` call, this represents a classic case of type confusion.

### Detailed Issues and CWE Mapping

**Type Confusion**

***Description***: The `pElem` pointer is treated as a `CIccMultiProcessElement` when it is actually a `CIccMpeXmlMatrix`. This incorrect casting can lead to unexpected behavior or security vulnerabilities when the system operates on the incorrectly typed object.

**CWE ID: CWE-843** - Access of Resource Using Incompatible Type ('**Type Confusion**').

**MITRE ATT&CK ID: T1569** - System Binary Proxy Execution (applicable in broader contexts).
