# Reproduction

## icPlatformSignature undefined behavior

### PoC
```
cd /tmp/DemoIccMAX-master/testing
wget https://github.com/xsscx/PatchIccMAX/raw/development/contrib/UnitTest/icPlatformSignature-ubsan-poc.icc
./iccDumpProfile icPlatformSignature-ubsan-poc.icc
```

### Result
```
Built with IccProfLib version 2.2.3

Profile:            'icPlatformSignature-ubsan-poc.icc'
Profile ID:         Profile ID not calculated.
Size:               504 (0x1f8) bytes

Header
------
Attributes:         Transparency | Matte
Cmm:                Apple
Creation Date:      7/151/2003 (M/D/Y)  38807:38807:38807
Creator:            'appl'
Device Manufacturer:'????'
Data Color Space:   RgbData
Flags:              EmbeddedProfileTrue | UseWithEmbeddedDataOnly
PCS Color Space:    LabData
Tools/CmdLine/IccDumpProfile/iccDumpProfile.cpp:227:69: runtime error: load of value 2543294359, which is not a valid value for type 'icPlatformSignature'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior Tools/CmdLine/IccDumpProfile/iccDumpProfile.cpp:227:69 in
IccProfLib/IccUtil.cpp:1845:11: runtime error: load of value 2543294359, which is not a valid value for type 'icPlatformSignature'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior IccProfLib/IccUtil.cpp:1845:11 in
IccProfLib/IccUtil.cpp:1865:27: runtime error: load of value 2543294359, which is not a valid value for type 'icPlatformSignature'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior IccProfLib/IccUtil.cpp:1865:27 in
Platform:           Unknown '????'
Rendering Intent:   Perceptual
Profile Class:      InputClass
Profile SubClass:   Not Defined
Version:            2.20
Illuminant:         X=-26728.4082, Y=1.0000, Z=0.8249
Spectral PCS:       NoSpectralData
Spectral PCS Range: Not Defined
BiSpectral Range:   Not Defined
MCS Color Space:    Not Defined

Profile Tags
------------
                         Tag    ID      Offset	    Size	     Pad
                        ----  ------    ------	    ----	     ---
       profileDescriptionTag  'desc'       192	     110	      42
             Unknown 'dscm'   'dscm'       264	      78	       2
          mediaWhitePointTag  'wtpt'       344	      20	       0
      chromaticAdaptationTag  'chad'       364	      44	      96
                    AToB0Tag  'A2B0'       204	     300	       0




EXIT 0
```


