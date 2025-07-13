# licc | Little ICC Scanner

`licc` is a mashup of [LittleCMS 2.14](https://www.littlecms.com/) and [ICC.1:2024-05 (iccMAX 2.2.25)](https://www.color.org/specification/ICC_Max.xalter), designed to demonstrate a measurement and analysis toolchain for ICC profiles.

---

## 🧪 Coverage Envelope

- **Proof-of-Concept Capabilities**:
  - Detect malformed, corrupted, or heuristically suspicious ICC profiles
  - Evaluate AToB/BToA transform integrity across RGB and CMYK workflows
  - Log detailed tag structure and potential exploit vectors

---

## 🛠 Build Instructions

```
cd contrib/Build/cmake/cov/lic
make -f Makefile.licc clean all AFL=0
```

### Expected Output

```
./iccscan -v 1 ../../../../UnitTest/cve-2023-46602.icc

l'icc Profile Scanner [LittleCMS 2.14, IccProfLib 2.3.0, IccLibXML 2.3.0]
David H Hoyt LLC  https://srd.cx/

Copyright (c) 1998-2015 Marti Maria Saguer
Copyright (c) 2003-2025 International Color Consortium (ICC)
Copyright (c) 2024-2025 David H Hoyt LLC

Licensed under the MIT License (see source headers for full details).

ICC_INFO: [licc.cpp:1011] Logger initialized. Starting argument parse.
ICC_INFO: [licc.cpp:1021] Input path: ../../../../UnitTest/cve-2023-46602.icc

============================
Profile:           '../../../../UnitTest/cve-2023-46602.icc'
[TRACE] Read colorSpace = 0x434d594b
ICC_DEBUG: [IccProfLib/IccTagBasic.cpp:3594] CIccTagXYZ::Read() called with size=20
ICC_DEBUG: [IccProfLib/IccTagBasic.cpp:3615] CIccTagXYZ::Read() read XYZ: X=542792024, Y=0, Z=1239220224
ICC_DEBUG: [IccProfLib/IccUtil.cpp:572] icDtoF: input=1.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:583] icDtoF: scaled=65536.00000000
ICC_DEBUG: [IccProfLib/IccTagLut.cpp:5273] CIccTagLut16::Read() invoked with size=89958
ICC_DEBUG: [IccProfLib/IccTagLut.cpp:5290] CIccTagLut16::Read() parsing block from offset 408988 to 498946
ICC_DEBUG: [IccProfLib/IccUtil.cpp:572] icDtoF: input=1.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:583] icDtoF: scaled=65536.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:572] icDtoF: input=1.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:583] icDtoF: scaled=65536.00000000
ICC_DEBUG: [IccProfLib/IccTagLut.cpp:5273] CIccTagLut16::Read() invoked with size=89958
ICC_DEBUG: [IccProfLib/IccTagLut.cpp:5290] CIccTagLut16::Read() parsing block from offset 498948 to 588906
ICC_DEBUG: [IccProfLib/IccUtil.cpp:572] icDtoF: input=1.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:583] icDtoF: scaled=65536.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:572] icDtoF: input=1.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:583] icDtoF: scaled=65536.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:572] icDtoF: input=1.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:583] icDtoF: scaled=65536.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:572] icDtoF: input=1.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:583] icDtoF: scaled=65536.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:572] icDtoF: input=1.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:583] icDtoF: scaled=65536.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:572] icDtoF: input=1.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:583] icDtoF: scaled=65536.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:572] icDtoF: input=1.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:583] icDtoF: scaled=65536.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:572] icDtoF: input=1.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:583] icDtoF: scaled=65536.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:572] icDtoF: input=1.00000000
ICC_DEBUG: [IccProfLib/IccUtil.cpp:583] icDtoF: scaled=65536.00000000
ICC_INFO: [licc.cpp:933] IsRoundTripable(): Entry point reached.
ICC_INFO: [licc.cpp:935] IsRoundTripable(): Checking profile with deviceClass=0x70727472
ICC_INFO: [licc.cpp:965] Tag pairs found: AToB0/BToA0=1, AToB1/BToA1=1, AToB2/BToA2=1
ICC_INFO: [licc.cpp:967] Tag pairs found: DToB0/BToD0=0, DToB1/BToD1=0, DToB2/BToD2=0
ICC_INFO: [licc.cpp:968] Matrix/TRC tags present: 0
ICC_INFO: [licc.cpp:977] IsRoundTripable(): Profile meets round-trip conditions.
ICC_INFO: [licc.cpp:1069] Round-trip check: PASS
ICC_INFO: [licc.cpp:1078] Profile opened successfully.
Profile:            '../../../../UnitTest/cve-2023-46602.icc'
Profile ID:         00000000000000000000000000000000
Size:               1662880 (0x195fa0) bytes

Header
------
Attributes:         Media-independent (unknown)
Cmm:                [not available]
Creation Date:      [not available]
Creator:            [not available]
Device Manufacturer:[not available]
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x434d594b → 'CMYK'
Data Color Space:   CMYK
Flags:              [not available]
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x4c616220 → 'Lab '
PCS Color Space:    Lab
Platform:           [not available]
Rendering Intent:   Perceptual
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x70727472 → 'prtr'
Profile Class:      prtr
Profile SubClass:   Not Defined
Version:            0.00
Illuminant:         [not available]
Spectral PCS:       Not Defined
Spectral PCS Range: Not Defined
BiSpectral Range:   Not Defined
MCS Color Space:    Not Defined
Media White Point:  X=0.8644 Y=0.8931 Z=0.7637

Profile Tags
------------
                         Tag    ID      Offset      Size             Pad
                        ----  ------    ------      ----             ---
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x64657363 → 'desc'
                        desc  desc         -           -               -
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x63707274 → 'cprt'
                        cprt  cprt         -           -               -
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x77747074 → 'wtpt'
                        wtpt  wtpt         -           -               -
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x41324230 → 'A2B0'
                        A2B0  A2B0         -           -               -
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x41324231 → 'A2B1'
                        A2B1  A2B1         -           -               -
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x42324130 → 'B2A0'
                        B2A0  B2A0         -           -               -
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x42324131 → 'B2A1'
                        B2A1  B2A1         -           -               -
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x42324132 → 'B2A2'
                        B2A2  B2A2         -           -               -
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x67616d74 → 'gamt'
                        gamt  gamt         -           -               -
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x646d6464 → 'dmdd'
                        dmdd  dmdd         -           -               -
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x646d6e64 → 'dmnd'
                        dmnd  dmnd         -           -               -
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x41324232 → 'A2B2'
                        A2B2  A2B2         -           -               -

[2025-05-12 16:11:30] [HEURISTIC] Phase='Info[Manufacturer]' Detail='Excessive text length (420001 bytes)'
[2025-05-12 16:11:30] [HEURISTIC] Phase='Info[Model]' Detail='Excessive text length (60001 bytes)'
[2025-05-12 16:11:30] [HEURISTIC] Phase='Info[Copyright]' Detail='Excessive text length (300001 bytes)'
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x434d594b → 'CMYK'
ICC_DEBUG: [licc.cpp:184] sig2char(): sig=0x70727472 → 'prtr'
[2025-05-12 16:11:30] ICC_INFO: [licc.cpp:651] DeviceClass='prtr' ColorSpace='prtr'
ICC_DEBUG: [licc.cpp:674] Dispatching to CMYK transform checks
ICC_DEBUG: [licc.cpp:611] Creating forward CMYK transform: intent=0 [input perceptual CMYK (AtoB0)]
ICC_DEBUG: [licc.cpp:624] Creating reverse CMYK transform: intent=0 [output perceptual CMYK (BtoA0)]
ICC_DEBUG: [licc.cpp:611] Creating forward CMYK transform: intent=1 [input rel.col CMYK (AtoB1)]
ICC_DEBUG: [licc.cpp:624] Creating reverse CMYK transform: intent=1 [output rel.col CMYK (BtoA1)]
ICC_DEBUG: [licc.cpp:611] Creating forward CMYK transform: intent=2 [input saturation CMYK (AtoB2)]
ICC_DEBUG: [licc.cpp:624] Creating reverse CMYK transform: intent=2 [output saturation CMYK (BtoA2)]

        *** WARNING: Profile may contain exploit characteristicsICC_WARN: [licc.cpp:690] Heuristic exploit indicator flagged
Validation Result: Ok

ICC_INFO: [licc.cpp:1085] Validation passed.
ICC_INFO: [licc.cpp:1097] Execution complete with exitCode=0
```