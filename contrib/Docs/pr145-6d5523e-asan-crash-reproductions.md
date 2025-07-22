## Ubuntu Runner Outputs for Asan using [6d5523e](https://github.com/InternationalColorConsortium/DemoIccMAX/commit/de9e65e9062ea079a80b4cab948246ab26d5523e)

**22-July-2025**

## Reproduction PoC's

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
