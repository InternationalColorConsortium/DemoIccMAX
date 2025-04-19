# Summary

The overflow occurs in ``deviceCoords array``, the calculated index or the number of elements accessed is incorrect, leading to an out-of-bounds read and the ``ud2`` instruction on macOS 23G93. 

## PoC

```
./iccFromXml WebSafeColors.xml WebSafeColors.icc
```

``Result``
```
./Build/Tools/IccFromXml/iccFromXml /tmp/profiles/WebSafeColors.xml /tmp/profiles/WebSafeColors.icc
=================================================================
==37252==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x604000002cc0 at pc 0x00010db4b6f7 bp 0x7ff7b4461af0 sp 0x7ff7b4461ae8
READ of size 4 at 0x604000002cc0 thread T0
    #0 0x10db4b6f6 in CIccTagNamedColor2::SetSize(unsigned int, int) IccTagBasic.cpp:2810
    #1 0x10c5cf2b6 in CIccTagXmlNamedColor2::ParseXml(_xmlNode*, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char>>&) IccTagXml.cpp:735
    #2 0x10c5a6bf7 in CIccProfileXml::ParseTag(_xmlNode*, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char>>&) IccProfileXml.cpp:680
    #3 0x10c5ac54c in CIccProfileXml::ParseXml(_xmlNode*, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char>>&) IccProfileXml.cpp:837
    #4 0x10c5acb6a in CIccProfileXml::LoadXml(char const*, char const*, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char>>*) IccProfileXml.cpp:894
    #5 0x10ba9f3d1 in main IccFromXml.cpp:68
    #6 0x7ff816825344 in start+0x774 (dyld:x86_64+0xfffffffffff5c344)
...
SUMMARY: AddressSanitizer: heap-buffer-overflow IccTagBasic.cpp:2810 in CIccTagNamedColor2::SetSize(unsigned int, int)
```

### Frame

```
frame #5: 0x000000010214b6f7 libIccProfLib2.2.dylib`CIccTagNamedColor2::SetSize(this=0x000060c00005d1c0, nSize=216, nDeviceCoords=2) at IccTagBasic.cpp:2810:30
   2807	      pTo->pcsCoords[j] = pFrom->pcsCoords[j];
   2808
   2809	    for (j=0; j<nCoords; j++) {
-> 2810	      pTo->deviceCoords[j] = pFrom->deviceCoords[j];
   2811	    }
   2812	  }
   2813	  free(m_NamedColor);
(lldb) fr va
(CIccTagXmlNamedColor2 *) this = 0x000060c00005d1c0
(icUInt32Number) nSize = 216
(icInt32Number) nDeviceCoords = 2
(icInt32Number) nNewCoords = 3
(icUInt32Number) nColorEntrySize = 56
(SIccNamedColorEntry *) pNamedColor = 0x0000627000000100
(icUInt32Number) i = 0
(icUInt32Number) nCopy = 1
(icUInt32Number) j = 1
(icUInt32Number) nCoords = 3
(SIccNamedColorEntry *) pFrom = 0x0000604000002690
(SIccNamedColorEntry *) pTo = 0x0000627000000100
(lldb) re re
General Purpose Registers:
       rbx = 0x00007ff7bfefc9c0
       rbp = 0x00007ff7bfefcd10
       rsp = 0x00007ff7bfefc960
       r12 = 0x00007ff7bfeff250
       r13 = 0x0000000000000000
       r14 = 0x0000000100003420  iccFromXml`main at IccFromXml.cpp:15
       r15 = 0x00007ff7bfeff3c0
       rip = 0x000000010214b6f7  libIccProfLib2.2.dylib`CIccTagNamedColor2::SetSize(unsigned int, int) + 4359 at IccTagBasic.cpp:2810:30
13 registers were unavailable.
```

## Takeaway

The issue arises from the mismatch between the number of device coordinates (nCoords) expected in SetSize and the actual number allocated (nDeviceCoords). Specifically, nDeviceCoords is decremented to 2, but nCoords is set to 3, leading to an attempt to access an unallocated area of memory. The allocation size for deviceCoords does not account for all elements that will be copied, causing the buffer overflow when trying to copy the third coordinate.
