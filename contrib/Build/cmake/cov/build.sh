#!/bin/bash
#
# The ICC Software License, Version 0.2
# Copyright (c) 2003-2025 The International Color Consortium. All rights reserved.
# Copyright (c) 2024-2025 David H Hoyt LLC. All rights reserved.
#
# Contributed by David Hoyt
# Date: 15-MAY-2025 2000 EDT
#
# Branch: research
# Intent: Public Domain
# Production: TRUE
# Runner: TRUE
#
# Updates:  Makefile for building instrumented Libs + Tools and checking LLVM coverage symbols
#
# TODO: SWAP the Copyright, License, Branding for ICC 
#
#
#  Makefile for building instrumented Libs + Tools and checking LLVM coverage symbols

# Runners are manual compile atm, wip

set -e

          echo ""
          echo "Little ICC Scanner v.01 [licc]"
          echo "[Research Branch | v.2.3.0 | -lIccProfLib2 -lIccXML2 -llcms2]"
          echo "Copyright (©) 2022-2025 David H Hoyt LLC. All rights reserved."
          echo "Demonstration measurement and analysis toolchain for ICC profiles."
          echo "Evaluate AToB/BToA transform integrity for RGB and CMYK workflows"
          echo "Detect malformed, corrupted, or heuristics in ICC profiles"
          echo "Log detailed tag structure and potential exploit vectors"
          echo "Bug Class: Profile Bleed | https://srd.cx/cve-2022-26730"
          echo ""

echo "[*] ========== Building Instrumentation Package =========="
echo ""
echo "[*] Building static libraries..."
echo "[*] Building iccProfLib..."
set -e

echo "[*] Building static libraries..."
make -C iccProfLib -f Makefile.iccProfLib
make -C iccXmlLib -f Makefile.iccXmlLib

echo "[*] Verifying static lib instrumentation..."
cd iccProfLib
ar -x libIccProfLib2.a && for f in *.o; do llvm-objdump -h "$f" | grep -q __llvm_prf_data && echo "   [INSTRUMENTED] $f"; done; rm -f *.o
cd ../iccXmlLib
ar -x libIccXML2.a && for f in *.o; do llvm-objdump -h "$f" | grep -q __llvm_prf_data && echo "   [INSTRUMENTED] $f"; done; rm -f *.o
cd ..

echo "[*] Building coverage-enabled tools..."
echo "[*] Building coverage-enabled iccToXml..."
make -C iccToXml -f Makefile.iccToXml.asan clean all AFL=0
echo "[*] Building coverage-enabled iccFromXml..."
make -C iccFromXml -f Makefile.iccFromXml clean all AFL=0
echo "[*] Building coverage-enabled iccDumpProfile..."
make -C iccDumpProfile -f Makefile.iccDumpProfile clean all AFL=0
echo "[*] Building coverage-enabled iccPngDump..."
make -C iccPngDump -f Makefile.iccPngDump clean all AFL=0
echo "[*] Building coverage-enabled iccRoundTrip..."
make -C iccRoundTrip -f Makefile.iccRoundTrip clean all AFL=0
make -C  licc -f Makefile.licc clean all AFL=0
# make -C iccTiffDump -f Makefile.IccTiffDump clean all AFL=0
# make -C iccApplyNamedCmm -f Makefile.iccApplyNamedCmm clean all AFL=0
# make -C iccApplyProfiles -f Makefile.iccApplyProfiles clean all AFL=0

echo "[*] Verifying tool instrumentation..."
for tool in iccToXml iccFromXml iccDumpProfile iccRoundTrip iccPngDump; do
  BIN="$tool/${tool}_test"
  if [[ -f "$BIN" ]]; then
    llvm-objdump -t "$BIN" | grep __llvm_profile > /dev/null && echo "[PASS] $BIN is instrumented" || echo "[FAIL] $BIN not instrumented"
  else
    echo "[FAIL] $BIN not found"
  fi
done

licc/licc
