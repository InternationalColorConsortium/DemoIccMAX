## Ubuntu Runner Outputs for Asan using [6d5523e](https://github.com/InternationalColorConsortium/DemoIccMAX/commit/de9e65e9062ea079a80b4cab948246ab26d5523e)

**22-July-2025**

## Reproduction PoC's

`iccRoundTrip Testing/ICS/Rec2100HlgFull-Part2.icc`

```
IccProfLib/IccEval.cpp:139:28: runtime error: downcast of address 0x507000000090 which does not point to an object of type 'CIccTagLutAtoB'
0x507000000090: note: object is of type 'CIccTagMultiProcessElement'
 00 00 00 00  08 cf b8 a5 28 7f 00 00  00 00 00 00 03 00 03 00  20 02 00 00 30 50 00 00  02 00 00 00
              ^~~~~~~~~~~~~~~~~~~~~~~
              vptr for 'CIccTagMultiProcessElement'

=================================================================
==5223==ERROR: LeakSanitizer: detected memory leaks
```


`Test CalcElement Operations return of zero's indicates that something bad happened`

```

/home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccProfLib/IccMpeCalc.cpp:4563:37: runtime error: downcast of address 0x503000000400 which does not point to an object of type 'CIccMpeCalculator'
0x503000000400: note: object is of type 'CIccMpeCurveSet'
 00 00 00 00  30 6b 98 35 97 7f 00 00  00 00 00 00 03 00 03 00  30 04 00 00 30 50 00 00  60 04 00 00
              ^~~~~~~~~~~~~~~~~~~~~~~
              vptr for 'CIccMpeCurveSet'

=================================================================
==5181==ERROR: LeakSanitizer: detected memory leaks
```

`Test NamedColor with Illuminant A 10degree`

```
===========================================================================
Test Grayscale GSDF Display link profile with ambient luminance of 20cd/m^2
/home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccProfLib/IccMpeCalc.cpp:4563:37: runtime error: downcast of address 0x503000000790 which does not point to an object of type 'CIccMpeCalculator'
0x503000000790: note: object is of type 'CIccMpeCurveSet'
 00 00 00 00  30 6b b8 24 33 7f 00 00  00 00 00 00 01 00 01 00  30 02 00 00 20 50 00 00  50 02 00 00
              ^~~~~~~~~~~~~~~~~~~~~~~
              vptr for 'CIccMpeCurveSet'

=================================================================
==5204==ERROR: LeakSanitizer: detected memory leaks
```

`Test RGB GSDF Display link profile with ambient luminant of 30cd/m^2`


```
/home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccProfLib/IccMpeCalc.cpp:4563:37: runtime error: downcast of address 0x5030000007c0 which does not point to an object of type 'CIccMpeCalculator'
0x5030000007c0: note: object is of type 'CIccMpeCurveSet'
 00 00 00 00  30 6b 58 c4 fa 7f 00 00  00 00 00 00 01 00 01 00  10 05 00 00 20 50 00 00  30 05 00 00
              ^~~~~~~~~~~~~~~~~~~~~~~
              vptr for 'CIccMpeCurveSet'

=================================================================
==5206==ERROR: LeakSanitizer: detected memory leaks
```


`iccFromXml CMYK-3DLUTs.xml CMYK-3DLUTs.icc`

```
==4900==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x52b00001b04f at pc 0x7f393e134444 bp 0x7ffe7b81b570 sp 0x7ffe7b81b560
READ of size 1 at 0x52b00001b04f thread T0
    #0 0x7f393e134443 in CIccXmlArrayType<unsigned short, (icTagTypeSignature)1969828150>::ParseText(unsigned short*, unsigned int, char const*) /home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccXML/IccLibXML/IccUtilXml.cpp:995
    #1 0x7f393e1358b1 in CIccXmlArrayType<unsigned short, (icTagTypeSignature)1969828150>::ParseTextArrayNum(char const*, unsigned int, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccXML/IccLibXML/IccUtilXml.cpp:813
```

`iccFromXml CMYK-3DLUTs2.xml CMYK-3DLUTs2.icc`

```
==4901==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x52b00001b04f at pc 0x7f58d7134444 bp 0x7ffc718b62d0 sp 0x7ffc718b62c0
READ of size 1 at 0x52b00001b04f thread T0
    #0 0x7f58d7134443 in CIccXmlArrayType<unsigned short, (icTagTypeSignature)1969828150>::ParseText(unsigned short*, unsigned int, char const*) /home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccXML/IccLibXML/IccUtilXml.cpp:995
    #1 0x7f58d71358b1 in CIccXmlArrayType<unsigned short, (icTagTypeSignature)1969828150>::ParseTextArrayNum(char const*, unsigned int, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccXML/IccLibXML/IccUtilXml.cpp:813
```

`iccFromXml 17ChanPart1.xml 17ChanPart1.icc`

```
==4971==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x52b00000dbff at pc 0x7f6bf9734444 bp 0x7ffd72d57b60 sp 0x7ffd72d57b50
READ of size 1 at 0x52b00000dbff thread T0
    #0 0x7f6bf9734443 in CIccXmlArrayType<unsigned short, (icTagTypeSignature)1969828150>::ParseText(unsigned short*, unsigned int, char const*) /home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccXML/IccLibXML/IccUtilXml.cpp:995
    #1 0x7f6bf97358b1 in CIccXmlArrayType<unsigned short, (icTagTypeSignature)1969828150>::ParseTextArrayNum(char const*, unsigned int, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccXML/IccLibXML/IccUtilXml.cpp:813
```


`iccFromXml 17ChanWithSpots-MVIS.xml 17ChanWithSpots-MVIS.icc`

```
==4973==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x52b000006bff at pc 0x7f8785934444 bp 0x7ffdfa36a280 sp 0x7ffdfa36a270
READ of size 1 at 0x52b000006bff thread T0
    #0 0x7f8785934443 in CIccXmlArrayType<unsigned short, (icTagTypeSignature)1969828150>::ParseText(unsigned short*, unsigned int, char const*) /home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccXML/IccLibXML/IccUtilXml.cpp:995
    #1 0x7f87859358b1 in CIccXmlArrayType<unsigned short, (icTagTypeSignature)1969828150>::ParseTextArrayNum(char const*, unsigned int, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccXML/IccLibXML/IccUtilXml.cpp:813
```

`iccFromXml 18ChanWithSpots-MVIS.xml 18ChanWithSpots-MVIS.icc`

```
==4974==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x52b000006bff at pc 0x7f9f87b34444 bp 0x7ffe52f483d0 sp 0x7ffe52f483c0
READ of size 1 at 0x52b000006bff thread T0
    #0 0x7f9f87b34443 in CIccXmlArrayType<unsigned short, (icTagTypeSignature)1969828150>::ParseText(unsigned short*, unsigned int, char const*) /home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccXML/IccLibXML/IccUtilXml.cpp:995
    #1 0x7f9f87b358b1 in CIccXmlArrayType<unsigned short, (icTagTypeSignature)1969828150>::ParseTextArrayNum(char const*, unsigned int, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/runner/work/PatchIccMAX/PatchIccMAX/PatchIccMAX/IccXML/IccLibXML/IccUtilXml.cpp:813
```
