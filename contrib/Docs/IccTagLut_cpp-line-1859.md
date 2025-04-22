# IccTagLut.cpp:1859 Bug Sample Repro

**Last Updated:** `Mon Apr 21 09:54:08 EDT 2025 by David Hoyt`

## Runtime Error

### [P0-2225 PoC's as Inputs](https://project-zero.issues.chromium.org/issues/42451346)

```
SUMMARY: AddressSanitizer: 602 byte(s) leaked in 12 allocation(s).
xss@W5:/pr128/PatchIccMAX/Testing$ ls -la 2225-tif-export.icc
-rw-r--r-- 1 xss xss 504 Apr 21 09:42 2225-tif-export.icc
xss@W5:/pr128/PatchIccMAX/Testing$ ../Build/Tools/IccToXml/iccToXml 2225-tif-export.icc
IccToXml built with IccProfLib Version 2.2.5, IccLibXML Version 2.2.5

Usage: IccToXml src_icc_profile dest_xml_file
xss@W5:~/pr128/PatchIccMAX/Testing$ ../Build/Tools/IccToXml/iccToXml 2225-tif-export.icc 2225-tif-export.xml
/home/xss/pr128/PatchIccMAX/IccProfLib/IccTagLut.cpp:1859:14: runtime error: index -1 out of bounds for type 'unsigned int [16]'
/home/xss/pr128/PatchIccMAX/IccProfLib/IccTagLut.cpp:1860:30: runtime error: index -1 out of bounds for type 'unsigned char [16]'
/home/xss/pr128/PatchIccMAX/IccXML/IccLibXML/IccProfileXml.cpp:128:16: runtime error: load of value 2543294359, which is not a valid value for type 'icPlatformSignature'
/home/xss/pr128/PatchIccMAX/IccXML/IccLibXML/IccProfileXml.cpp:129:103: runtime error: load of value 2543294359, which is not a valid value for type 'icPlatformSignature'



SUMMARY: AddressSanitizer: 602 byte(s) leaked in 12 allocation(s).
xss@W5:~/pr128/PatchIccMAX/Testing$ ../Build/Tools/IccTiffDump/iccTiffDump 2225.tif 2225-tif-export.icc


Indirect leak of 24 byte(s) in 1 object(s) allocated from:
    #0 0x7f7424d3e548 in operator new(unsigned long) ../../../../src/libsanitizer/asan/asan_new_delete.cpp:95
    #1 0x7f742385775f in CIccProfile::CIccProfile() /home/xss/pr128/PatchIccMAX/IccProfLib/IccProfile.cpp:106
    #2 0x7f74238b3ebe in OpenIccProfile(unsigned char const*, unsigned int, bool) /home/xss/pr128/PatchIccMAX/IccProfLib/IccProfile.cpp:3471
    #3 0x56044548de27 in main /home/xss/pr128/PatchIccMAX/Tools/CmdLine/IccTiffDump/iccTiffDump.cpp:172
    #4 0x7f7421b001c9 in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
    #5 0x7f7421b0028a in __libc_start_main_impl ../csu/libc-start.c:360
    #6 0x56044548c724 in _start (/home/xss/pr128/PatchIccMAX/Build/Tools/IccTiffDump/iccTiffDump+0x25724) (BuildId: f9469bf01ed52b2879f13607453b53d4e5976f9b)


```

### Reproduction TIF -> ICC -> TXT

```
../Build/Tools/IccTiffDump/iccTiffDump 2225.tif 2225-tif-export.icc
../Build/Tools/IccToXml/iccToXml 2225-tif-export.icc 2225-tif-export.xml
xxd -l 512 2225-tif-export.icc > 2225-tif-export.txt
```

**Output**

```
00000000: 0000 01f8 6170 706c 0220 0000 7363 6e72  ....appl. ..scnr
00000010: 5247 4220 4c61 6220 07d3 0007 0097 9797  RGB Lab ........
00000020: 9797 9797 6163 7370 9797 9797 9797 9797  ....acsp........
00000030: 9797 9797 9797 9797 9797 9797 9797 9797  ................
00000040: 0000 0000 9797 9797 0001 0000 0000 d32d  ...............-
00000050: 6170 706c 0000 0000 0000 0000 0000 0000  appl............
00000060: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000070: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000080: 0000 0005 6465 7363 0000 00c0 0000 006e  ....desc.......n
00000090: 6473 636d 0000 0108 0000 004e 7774 7074  dscm.......Nwtpt
000000a0: 0000 0158 0000 0014 6368 6164 0000 016c  ...X....chad...l
000000b0: 0000 002c 4132 4230 0000 00cc 0000 012c  ...,A2B0.......,
000000c0: 4232 4132 0000 00cc 0000 012c 6d42 4120  B2A2.......,mBA
000000d0: 0000 0020 0004 0000 0000 00fc 0000 0000  ... ............
000000e0: 0000 0000 0000 0060 0000 0020 7061 7261  .......`... para
000000f0: 0000 0000 0000 0000 0001 0000 7061 7261  ............para
00000100: 0000 0000 0000 0000 0001 0000 7061 7261  ............para
00000110: 0000 0000 0000 0000 0001 0000 7061 7261  ............para
00000120: 0000 0000 0000 0000 0001 0000 1111 1100  ................
00000130: 0000 0000 0000 0000 0000 0000 0200 0000  ................
00000140: 0000 8ad0 0000 0000 0000 902f 0000 0000  .........../....
00000150: 0000 9554 0000 0000 0000 9a3a 0000 0000  ...T.......:....
00000160: 0000 9eda 0000 0000 0000 a331 0000 0000  ...........1....
00000170: 0000 a73a 0000 0000 0000 aaee 0000 0000  ...:............
00000180: 0000 ae4b 0000 0000 0000 b14c 158b 0000  ...K.......L....
00000190: 0000 b3ef 3359 0000 0000 b633 5138 0000  ....3Y.....3Q8..
000001a0: 0000 b81a 6f88 0000 0000 b9a7 8f1f 0000  ....o...........
000001b0: 0000 badf b24e 0000 0000 bbc9 e6df 0000  .....N..........
000001c0: 0000 bc6f ffff 0000 7061 7261 0000 0000  ...o....para....
000001d0: 0000 0000 0001 0000 7061 7261 0000 0000  ........para....
000001e0: 0000 0000 0001 0000 7061 7261 0000 0000  ........para....
000001f0: 0000 0000 0001 0000                      ........
```