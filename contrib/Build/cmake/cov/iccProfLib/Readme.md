# IccProfLib Makefile for Profiling

iccMAX Profiling Makefile for IccProfLib to include profiling and instrumentation loads.

In the files there are/will be instrumentation modifications. 
Example:

```
//////////////////////////////////////////////////////////////////////
// CIccApplyBPC utility functions
//////////////////////////////////////////////////////////////////////

// converts lab to pcs
__attribute__((noinline)) void __force_llvm_profile_test();  // declaration

void CIccApplyBPC::lab2pcs(icFloatNumber* pixel, const CIccProfile* pProfile) const
{
    __force_llvm_profile_test();  // call inserted

    switch (pProfile->m_Header.pcs)
    {
        case icSigLabData:
            icLabToPcs(pixel);
            break;
        case icSigXYZData:
            icLabtoXYZ(pixel);
            icXyzToPcs(pixel);
            break;
        default:
            break;
    }
}
...
__attribute__((noinline)) void __force_llvm_profile_test() {
  static int counter = 0;
  ++counter;
```

## IccProfLib Build Reproduction

```
cd Build/iccproflib
make -f Makefile.proflib
```


## Manual Compile

```
cd Build
clang++ -O0 -g -fprofile-instr-generate -fcoverage-mapping   ../IccXML/CmdLine/IccProfLib/IccProfLib.cpp   -o IccProfLib_test   -Wl,--whole-archive ~/pr121/PatchIccMAX/Build/iccxml/libIccXML2.a ~/pr121/PatchIccMAX/Build/iccproflib/libIccProfLib2.a -Wl,--no-whole-archive   -I../IccXML/IccLibXML   -I../IccProfLib   -I../IccXML/CmdLine/IccProfLib   -I/usr/include/libxml2   -lxml2
```



## Validate

### Command

```
ar -x libIccProfLib2.a && for f in *.o; do llvm-objdump -h "$f" | grep -q __llvm_prf_data && echo "  → [INSTRUMENTED] $f"; done; rm -f *.o
```

### Expected Output

```
  → [INSTRUMENTED] IccApplyBPC.o
  → [INSTRUMENTED] IccArrayBasic.o
  → [INSTRUMENTED] IccArrayFactory.o
  → [INSTRUMENTED] IccCAM.o
  → [INSTRUMENTED] IccCmm.o
  → [INSTRUMENTED] IccConvertUTF.o
  → [INSTRUMENTED] IccEncoding.o
  → [INSTRUMENTED] IccEnvVar.o
  → [INSTRUMENTED] IccEval.o
  → [INSTRUMENTED] IccIO.o
  → [INSTRUMENTED] IccMD5.o
  → [INSTRUMENTED] IccMatrixMath.o
  → [INSTRUMENTED] IccMpeACS.o
  → [INSTRUMENTED] IccMpeBasic.o
  → [INSTRUMENTED] IccMpeCalc.o
  → [INSTRUMENTED] IccMpeFactory.o
  → [INSTRUMENTED] IccMpeSpectral.o
  → [INSTRUMENTED] IccPcc.o
  → [INSTRUMENTED] IccPrmg.o
  → [INSTRUMENTED] IccProfile.o
  → [INSTRUMENTED] IccSolve.o
  → [INSTRUMENTED] IccSparseMatrix.o
  → [INSTRUMENTED] IccStructBasic.o
  → [INSTRUMENTED] IccStructFactory.o
  → [INSTRUMENTED] IccTagBasic.o
  → [INSTRUMENTED] IccTagComposite.o
  → [INSTRUMENTED] IccTagDict.o
  → [INSTRUMENTED] IccTagEmbedIcc.o
  → [INSTRUMENTED] IccTagFactory.o
  → [INSTRUMENTED] IccTagLut.o
  → [INSTRUMENTED] IccTagMPE.o
  → [INSTRUMENTED] IccTagProfSeqId.o
  → [INSTRUMENTED] IccUtil.o
  → [INSTRUMENTED] IccWrapper.o
  → [INSTRUMENTED] IccXformFactory.o
```
