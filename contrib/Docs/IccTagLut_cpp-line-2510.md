# Repro `IccTagLut.cpp:L:2510`

**Last Updated:** `Mon Apr 21 09:54:08 EDT 2025 by David Hoyt`

## `CIccCLUT::Interp2d`


lldb -- ../../../iccApplyNamedCmm/iccApplyNamedcmm_test -debugcalc rgbExercise8bit.txt 0 1 calcExercizeOps.icc 1

(lldb) target create "../../../iccApplyNamedCmm/iccApplyNamedcmm_test"
Current executable set to '/home/xss/pr121/repro1/PatchIccMAX/cov/iccApplyNamedCmm/iccApplyNamedcmm_test' (x86_64).
(lldb) settings set -- target.run-args  "-debugcalc" "rgbExercise8bit.txt" "0" "1" "calcExercizeOps.icc" "1"
(lldb) r
Process 6000 launched: '/home/xss/pr121/repro1/PatchIccMAX/cov/iccApplyNamedCmm/iccApplyNamedcmm_test' (x86_64)
Process 6000 stopped
* thread #1, name = 'iccApplyNamedcm', stop reason = signal SIGSEGV: address not mapped to object (fault address: 0x55595595a1c0)
    frame #0: 0x000055555576c4c3 iccApplyNamedcmm_test`CIccCLUT::Interp2d(this=0x000055555595bf80, destPixel=0x000055555595e9e0, srcPixel=0x000055555595f00c) const at IccTagLut.cpp:2510:10
   2507   dF3 =  t*  u;
   2508
   2509   for (i=0; i<m_nOutput; i++, p++) {
-> 2510     pv = p[n000]*dF0 + p[n001]*dF1 + p[n010]*dF2 + p[n011]*dF3;
   2511
   2512     destPixel[i] = pv;
   2513   }
(lldb)
