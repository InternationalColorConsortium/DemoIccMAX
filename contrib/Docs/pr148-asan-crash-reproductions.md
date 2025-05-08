# `devicc` Asan Sample

Updated: 24-July-2025 by David Hoyt

## CICD Testing

Single PoC using Asan on Windows, WSL-2, macOS and Raspi builds.

### Raspi

`cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -Wno-dev -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" -DENABLE_TOOLS=ON -DENABLE_STATIC_LIBS=ON -DENABLE_SHARED_LIBS=ON -Wno-dev Cmake/ && make -j32`

```
iccApplyNamedCmm  rgbExercise8bit.txt 0 1 calcExercizeOps.icc 2
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:4563:37: runtime error: downcast of address 0x007f861008b0 which does not point to an object of type 'CIccMpeCalculator'
0x007f861008b0: note: object is of type 'CIccMpeTintArray'
 02 00 00 2f  70 6a ce 8c 7f 00 00 00  00 00 00 00 01 00 02 00  80 08 10 86 7f 00 00 00  00 00 00 00
              ^~~~~~~~~~~~~~~~~~~~~~~
              vptr for 'CIccMpeTintArray'
AddressSanitizer:DEADLYSIGNAL
=================================================================
==2564==ERROR: AddressSanitizer: SEGV on unknown address 0x002070c200df (pc 0x007f8c8f36b8 bp 0x007fc8c2b5b0 sp 0x007fc8c2b5b0 T0)
==2564==The signal is caused by a READ memory access.
    #0 0x7f8c8f36b8 in CIccCLUT::Interp2d(float*, float const*) const DemoIccMAX/IccProfLib/IccTagLut.cpp:2510
    #1 0x7f8c498ac8 in CIccMpeCLUT::Apply(CIccApplyMpe*, float*, float const*) const DemoIccMAX/IccProfLib/IccMpeBasic.cpp:5674
    #2 0x7f8c528214 in CIccApplyMpe::Apply(float*, float const*) DemoIccMAX/IccProfLib/IccTagMPE.h:213
    #3 0x7f8c5295bc in CIccSubCalcApply::Apply(float*, float const*) (DemoIccMAX/Build/IccProfLib/libIccProfLib2.so.2+0x109c5bc)
    #4 0x7f8c52ee18 in CIccOpDefSubElement::Exec(SIccCalcOp*, SIccOpState&) DemoIccMAX/IccProfLib/IccMpeCalc.cpp:374
    #5 0x7f8c4fa40c in CIccCalculatorFunc::ApplySequence(CIccApplyMpeCalculator*, unsigned int, SIccCalcOp*) const DemoIccMAX/IccProfLib/IccMpeCalc.cpp:3664
    #6 0x7f8c4fac40 in CIccCalculatorFunc::Apply(CIccApplyMpeCalculator*) const DemoIccMAX/IccProfLib/IccMpeCalc.cpp:3691
    #7 0x7f8c51f5fc in CIccMpeCalculator::Apply(CIccApplyMpe*, float*, float const*) const DemoIccMAX/IccProfLib/IccMpeCalc.cpp:4805
    #8 0x7f8c528214 in CIccApplyMpe::Apply(float*, float const*) DemoIccMAX/IccProfLib/IccTagMPE.h:213
    #9 0x7f8c9a69f8 in CIccTagMultiProcessElement::Apply(CIccApplyTagMpe*, float*, float const*) const DemoIccMAX/IccProfLib/IccTagMPE.cpp:1467
    #10 0x7f8c2cf364 in CIccXformMpe::Apply(CIccApplyXform*, float*, float const*) const DemoIccMAX/IccProfLib/IccCmm.cpp:7564
    #11 0x7f8c2fe89c in CIccApplyNamedColorCmm::Apply(float*, float const*) DemoIccMAX/IccProfLib/IccCmm.cpp:9797
    #12 0x7f8c2f1530 in CIccCmm::Apply(float*, float const*) DemoIccMAX/IccProfLib/IccCmm.cpp:8769
    #13 0x555935a1a0 in CIccNamedColorCmm::Apply(float*, float const*) (DemoIccMAX/Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm+0x34a1a0)
    #14 0x5559356b78 in main DemoIccMAX/Tools/CmdLine/IccApplyNamedCmm/iccApplyNamedCmm.cpp:535
    #15 0x7f8a78add4 in __libc_start_main ../csu/libc-start.c:308
    #16 0x5559350204  (DemoIccMAX/Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm+0x340204)

AddressSanitizer can not provide additional info.
SUMMARY: AddressSanitizer: SEGV DemoIccMAX/IccProfLib/IccTagLut.cpp:2510 in CIccCLUT::Interp2d(float*, float const*) const
==2564==ABORTING
```

### macOS x64

```
iccApplyNamedCmm  rgbExercise8bit.txt 0 1 calcExercizeOps.icc 2
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:4563:37: runtime error: downcast of address 0x6030000055f0 which does not point to an object of type 'CIccMpeCalculator'
0x6030000055f0: note: object is of type 'CIccMpeTintArray'
 00 00 00 00  f0 81 a8 03 01 00 00 00  00 00 00 00 01 00 02 00  20 56 00 00 30 60 00 00  00 00 00 00
              ^~~~~~~~~~~~~~~~~~~~~~~
              vptr for 'CIccMpeTintArray'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeCalc.cpp:4563:37
DemoIccMAX/IccProfLib/IccTagBasic.cpp:6608:41: runtime error: nan is outside the range of representable values of type 'unsigned int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccTagBasic.cpp:6608:41
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:1249:35: runtime error: nan is outside the range of representable values of type 'int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeCalc.cpp:1249:35
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:1247:35: runtime error: -inf is outside the range of representable values of type 'int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeCalc.cpp:1247:35
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:1195:35: runtime error: nan is outside the range of representable values of type 'int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeCalc.cpp:1195:35
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:3616:84: runtime error: nan is outside the range of representable values of type 'int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeCalc.cpp:3616:84
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:3616:57: runtime error: inf is outside the range of representable values of type 'int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeCalc.cpp:3616:57
DemoIccMAX/IccProfLib/IccMpeBasic.cpp:1809:43: runtime error: nan is outside the range of representable values of type 'unsigned int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeBasic.cpp:1809:43
DemoIccMAX/IccProfLib/IccTagLut.cpp:2480:39: runtime error: nan is outside the range of representable values of type 'unsigned int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccTagLut.cpp:2480:39
DemoIccMAX/IccProfLib/IccTagLut.cpp:2481:39: runtime error: nan is outside the range of representable values of type 'unsigned int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccTagLut.cpp:2481:39
AddressSanitizer:DEADLYSIGNAL
=================================================================
==27001==ERROR: AddressSanitizer: BUS on unknown address (pc 0x0001038fd0a5 bp 0x7ff7be35b050 sp 0x7ff7be35ad60 T0)
==27001==The signal is caused by a READ memory access.
==27001==Hint: this fault was caused by a dereference of a high value address (see register values below).  Disassemble the provided pc to learn which register was used.
    #0 0x0001038fd0a5 in CIccCLUT::Interp2d(float*, float const*) const IccTagLut.cpp:2510
    #1 0x000103594173 in CIccMpeCLUT::Apply(CIccApplyMpe*, float*, float const*) const IccMpeBasic.cpp:5674
    #2 0x000103617adc in CIccApplyMpe::Apply(float*, float const*) IccTagMPE.h:213
    #3 0x000103617825 in CIccSubCalcApply::Apply(float*, float const*) IccMpeCalc.h:432
    #4 0x000103616fc1 in CIccOpDefSubElement::Exec(SIccCalcOp*, SIccOpState&) IccMpeCalc.cpp:374
    #5 0x0001035ef6d8 in CIccCalculatorFunc::ApplySequence(CIccApplyMpeCalculator*, unsigned int, SIccCalcOp*) const IccMpeCalc.cpp:3664
    #6 0x0001035f0594 in CIccCalculatorFunc::Apply(CIccApplyMpeCalculator*) const IccMpeCalc.cpp:3691
    #7 0x000103607648 in CIccMpeCalculator::Apply(CIccApplyMpe*, float*, float const*) const IccMpeCalc.cpp:4805
    #8 0x000103617adc in CIccApplyMpe::Apply(float*, float const*) IccTagMPE.h:213
    #9 0x000103979a5b in CIccTagMultiProcessElement::Apply(CIccApplyTagMpe*, float*, float const*) const IccTagMPE.cpp:1467
    #10 0x0001034322bd in CIccXformMpe::Apply(CIccApplyXform*, float*, float const*) const IccCmm.cpp:7564
    #11 0x00010345fa03 in CIccApplyNamedColorCmm::Apply(float*, float const*) IccCmm.cpp:9797
    #12 0x0001034505e8 in CIccCmm::Apply(float*, float const*) IccCmm.cpp:8769
    #13 0x000101bae97a in CIccNamedColorCmm::Apply(float*, float const*) IccCmm.h:1832
    #14 0x000101ba9b46 in main iccApplyNamedCmm.cpp:535
    #15 0x7ff805e0a52f in start+0xbef (dyld:x86_64+0xfffffffffffe652f)

==27001==Register values:
rax = 0x0000613000000740  rbx = 0x00007ff7be35b4e0  rcx = 0x0000603400003800  rdx = 0x00000000000000ff
rdi = 0x0000000000000001  rsi = 0x0000603400003800  rbp = 0x00007ff7be35b050  rsp = 0x00007ff7be35ad60
 r8 = 0x0000000000000000   r9 = 0x0000000000000001  r10 = 0x00007fffffffff01  r11 = 0x00007fffffffff01
r12 = 0x00007ff7be35f5e8  r13 = 0x00007ff847d8e3a0  r14 = 0x0000000000000000  r15 = 0x00007ff7be35f590
AddressSanitizer can not provide additional info.
SUMMARY: AddressSanitizer: BUS IccTagLut.cpp:2510 in CIccCLUT::Interp2d(float*, float const*) const
==27001==ABORTING
zsh: abort      iccApplyNamedCmm rgbExercise8bit.txt 0 1
```

### WSL2 ubuntu

```
iccApplyNamedCmm -debugcalc rgbExercise8bit.txt 0 1 calcExercizeOps.icc 1
Segmentation fault
```

### Windows

```
cmake --preset vs2022-x64 -B . -S Build/Cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS_DEBUG="/Zi /Od /fsanitize=address /Oy- /MDd" -DCMAKE_C_FLAGS_DEBUG="/Zi /Od /fsanitize=address /Oy- /MDd"    -DCMAKE_TOOLCHAIN_FILE="C:/Program Files/Microsoft Visual Studio/2022/Enterprise/VC/vcpkg/scripts/buildsystems/vcpkg.cmake"
cmake --build . -- /m /maxcpucount
...
iccApplyNamedCmm -debugcalc rgbExercise8bit.txt 0 1 calcExercizeOps.icc 1
=================================================================
==9012==ERROR: AddressSanitizer: access-violation on unknown address 0x126e18f9e778 (pc 0x7ff613a3fa1c bp 0x000000000000 sp 0x00a8874fc950 T0)
==9012==The signal is caused by a READ memory access.
    #0 0x7ff613a3fa1b in CIccCLUT::Interp2d(float *, float const *) const E:\pr148\repro1\DemoIccMAX\IccProfLib\IccTagLut.cpp:2510
    #1 0x7ff613b17e6f in CIccMpeCLUT::Apply(class CIccApplyMpe *, float *, float const *) const E:\pr148\repro1\DemoIccMAX\IccProfLib\IccMpeBasic.cpp:5674
    #2 0x7ff61390a260 in CIccApplyMpe::Apply(float *, float const *) E:\pr148\repro1\DemoIccMAX\IccProfLib\IccTagMPE.h:213
    #3 0x7ff61390a353 in CIccSubCalcApply::Apply(float *, float const *) E:\pr148\repro1\DemoIccMAX\IccProfLib\IccMpeCalc.h:432
    #4 0x7ff61391ab5b in CIccOpDefSubElement::Exec(struct SIccCalcOp *, struct SIccOpState &) E:\pr148\repro1\DemoIccMAX\IccProfLib\IccMpeCalc.cpp:374
    #5 0x7ff6138e907d in CIccCalculatorFunc::ApplySequence(class CIccApplyMpeCalculator *, unsigned long, struct SIccCalcOp *) const E:\pr148\repro1\DemoIccMAX\IccProfLib\IccMpeCalc.cpp:3664
    #6 0x7ff6138e0968 in CIccCalculatorFunc::Apply(class CIccApplyMpeCalculator *) const E:\pr148\repro1\DemoIccMAX\IccProfLib\IccMpeCalc.cpp:3691
    #7 0x7ff6138f0c42 in CIccMpeCalculator::Apply(class CIccApplyMpe *, float *, float const *) const E:\pr148\repro1\DemoIccMAX\IccProfLib\IccMpeCalc.cpp:4798
    #8 0x7ff61390a260 in CIccApplyMpe::Apply(float *, float const *) E:\pr148\repro1\DemoIccMAX\IccProfLib\IccTagMPE.h:213
    #9 0x7ff613a6e7df in CIccTagMultiProcessElement::Apply(class CIccApplyTagMpe *, float *, float const *) const E:\pr148\repro1\DemoIccMAX\IccProfLib\IccTagMPE.cpp:1467
    #10 0x7ff61388b95e in CIccXformMpe::Apply(class CIccApplyXform *, float *, float const *) const E:\pr148\repro1\DemoIccMAX\IccProfLib\IccCmm.cpp:7564
    #11 0x7ff6138a1998 in CIccApplyNamedColorCmm::Apply(float *, float const *) E:\pr148\repro1\DemoIccMAX\IccProfLib\IccCmm.cpp:9797
    #12 0x7ff613896498 in CIccCmm::Apply(float *, float const *) E:\pr148\repro1\DemoIccMAX\IccProfLib\IccCmm.cpp:8769
    #13 0x7ff613702b16 in CIccNamedColorCmm::Apply(float *, float const *) E:\pr148\repro1\DemoIccMAX\IccProfLib\IccCmm.h:1832
    #14 0x7ff6136d4cb4 in main E:\pr148\repro1\DemoIccMAX\Tools\CmdLine\IccApplyNamedCmm\iccApplyNamedCmm.cpp:535
    #15 0x7ff613b596e8 in invoke_main D:\a\_work\1\s\src\vctools\crt\vcstartup\src\startup\exe_common.inl:78
    #16 0x7ff613b59631 in __scrt_common_main_seh D:\a\_work\1\s\src\vctools\crt\vcstartup\src\startup\exe_common.inl:288
    #17 0x7ff613b594ed in __scrt_common_main D:\a\_work\1\s\src\vctools\crt\vcstartup\src\startup\exe_common.inl:330
    #18 0x7ff613b5975d in mainCRTStartup D:\a\_work\1\s\src\vctools\crt\vcstartup\src\startup\exe_main.cpp:16
    #19 0x7ff8199de8d6  (C:\Windows\System32\KERNEL32.DLL+0x18002e8d6)
    #20 0x7ff81ae7c34b  (C:\Windows\SYSTEM32\ntdll.dll+0x18003c34b)

==9012==Register values:
rax = 126e18f9e778  rbx = 0  rcx = 0  rdx = 24dc31f3cef
rdi = 0  rsi = 0  rbp = 0  rsp = a8874fc950
r8  = 126a18fa0d0c  r9  = 126e18f9e778  r10 = 0  r11 = a8874fbe40
r12 = 0  r13 = 0  r14 = 0  r15 = 0
AddressSanitizer can not provide additional info.
SUMMARY: AddressSanitizer: access-violation E:\pr148\repro1\DemoIccMAX\IccProfLib\IccTagLut.cpp:2510 in CIccCLUT::Interp2d(float *, float const *) const
==9012==ABORTING
```

### macOS PoC - Variant

`iccApplyNamedCmm -debugcalc rgbExercise8bit.txt 0 3 calcExercizeOps.icc 2`

```
DemoIccMAX/Tools/CmdLine/IccCommon/IccCmmConfig.cpp:776:32: runtime error: load of value 3, which is not a valid value for type 'icXformInterp'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/Tools/CmdLine/IccCommon/IccCmmConfig.cpp:776:32
DemoIccMAX/Tools/CmdLine/IccApplyNamedCmm/iccApplyNamedCmm.cpp:382:37: runtime error: load of value 3, which is not a valid value for type 'icXformInterp'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/Tools/CmdLine/IccApplyNamedCmm/iccApplyNamedCmm.cpp:382:37
DemoIccMAX/IccProfLib/IccCmm.cpp:10354:48: runtime error: load of value 3, which is not a valid value for type 'icXformInterp'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccCmm.cpp:10354:48
DemoIccMAX/IccProfLib/IccCmm.cpp:10601:62: runtime error: load of value 3, which is not a valid value for type 'icXformInterp'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccCmm.cpp:10601:62
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:4563:37: runtime error: downcast of address 0x603000005650 which does not point to an object of type 'CIccMpeCalculator'
0x603000005650: note: object is of type 'CIccMpeTintArray'
 00 00 00 00  f0 31 54 0b 01 00 00 00  00 00 00 00 01 00 02 00  80 56 00 00 30 60 00 00  00 00 00 00
              ^~~~~~~~~~~~~~~~~~~~~~~
              vptr for 'CIccMpeTintArray'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeCalc.cpp:4563:37
DemoIccMAX/IccProfLib/IccCmm.cpp:1141:75: runtime error: load of value 3, which is not a valid value for type 'icXformInterp'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccCmm.cpp:1141:75
DemoIccMAX/IccProfLib/IccCmm.cpp:1282:15: runtime error: load of value 3, which is not a valid value for type 'icXformInterp'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccCmm.cpp:1282:15
DemoIccMAX/IccProfLib/IccTagBasic.cpp:6608:41: runtime error: nan is outside the range of representable values of type 'unsigned int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccTagBasic.cpp:6608:41
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:1249:35: runtime error: nan is outside the range of representable values of type 'int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeCalc.cpp:1249:35
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:1247:35: runtime error: -inf is outside the range of representable values of type 'int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeCalc.cpp:1247:35
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:1195:35: runtime error: nan is outside the range of representable values of type 'int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeCalc.cpp:1195:35
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:3616:84: runtime error: nan is outside the range of representable values of type 'int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeCalc.cpp:3616:84
DemoIccMAX/IccProfLib/IccMpeCalc.cpp:3616:57: runtime error: inf is outside the range of representable values of type 'int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeCalc.cpp:3616:57
DemoIccMAX/IccProfLib/IccMpeBasic.cpp:1809:43: runtime error: nan is outside the range of representable values of type 'unsigned int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccMpeBasic.cpp:1809:43
DemoIccMAX/IccProfLib/IccTagLut.cpp:2480:39: runtime error: nan is outside the range of representable values of type 'unsigned int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccTagLut.cpp:2480:39
DemoIccMAX/IccProfLib/IccTagLut.cpp:2481:39: runtime error: nan is outside the range of representable values of type 'unsigned int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior DemoIccMAX/IccProfLib/IccTagLut.cpp:2481:39
AddressSanitizer:DEADLYSIGNAL
=================================================================
==27087==ERROR: AddressSanitizer: BUS on unknown address (pc 0x00010b3b80a5 bp 0x7ff7b68a0030 sp 0x7ff7b689fd40 T0)
==27087==The signal is caused by a READ memory access.
==27087==Hint: this fault was caused by a dereference of a high value address (see register values below).  Disassemble the provided pc to learn which register was used.
    #0 0x00010b3b80a5 in CIccCLUT::Interp2d(float*, float const*) const IccTagLut.cpp:2510
    #1 0x00010b04f173 in CIccMpeCLUT::Apply(CIccApplyMpe*, float*, float const*) const IccMpeBasic.cpp:5674
    #2 0x00010b0d2adc in CIccApplyMpe::Apply(float*, float const*) IccTagMPE.h:213
    #3 0x00010b0d2825 in CIccSubCalcApply::Apply(float*, float const*) IccMpeCalc.h:432
    #4 0x00010b0d1fc1 in CIccOpDefSubElement::Exec(SIccCalcOp*, SIccOpState&) IccMpeCalc.cpp:374
    #5 0x00010b0aa6d8 in CIccCalculatorFunc::ApplySequence(CIccApplyMpeCalculator*, unsigned int, SIccCalcOp*) const IccMpeCalc.cpp:3664
    #6 0x00010b0ab594 in CIccCalculatorFunc::Apply(CIccApplyMpeCalculator*) const IccMpeCalc.cpp:3691
    #7 0x00010b0c21ea in CIccMpeCalculator::Apply(CIccApplyMpe*, float*, float const*) const IccMpeCalc.cpp:4798
    #8 0x00010b0d2adc in CIccApplyMpe::Apply(float*, float const*) IccTagMPE.h:213
    #9 0x00010b434a5b in CIccTagMultiProcessElement::Apply(CIccApplyTagMpe*, float*, float const*) const IccTagMPE.cpp:1467
    #10 0x00010aeed2bd in CIccXformMpe::Apply(CIccApplyXform*, float*, float const*) const IccCmm.cpp:7564
    #11 0x00010af1aa03 in CIccApplyNamedColorCmm::Apply(float*, float const*) IccCmm.cpp:9797
    #12 0x00010af0b5e8 in CIccCmm::Apply(float*, float const*) IccCmm.cpp:8769
    #13 0x00010966997a in CIccNamedColorCmm::Apply(float*, float const*) IccCmm.h:1832
    #14 0x000109664b46 in main iccApplyNamedCmm.cpp:535
    #15 0x7ff805e0a52f in start+0xbef (dyld:x86_64+0xfffffffffffe652f)

==27087==Register values:
rax = 0x0000613000000740  rbx = 0x00007ff7b68a04c0  rcx = 0x0000603400003860  rdx = 0x00000000000000ff
rdi = 0x0000000000000001  rsi = 0x0000603400003860  rbp = 0x00007ff7b68a0030  rsp = 0x00007ff7b689fd40
 r8 = 0x0000000000000000   r9 = 0x0000624000004000  r10 = 0x00007fffffffff01  r11 = 0x00007fffffffff01
r12 = 0x00007ff7b68a45d8  r13 = 0x00007ff847d8e3a0  r14 = 0x0000000000000000  r15 = 0x00007ff7b68a4580
AddressSanitizer can not provide additional info.
SUMMARY: AddressSanitizer: BUS IccTagLut.cpp:2510 in CIccCLUT::Interp2d(float*, float const*) const
==27087==ABORTING
zsh: abort      ../../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm -debugcalc  0 3  2
```