#!/bin/bash
##
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt
## Date: 02-MAY-2025 2000 EDT
#
# Branch: PR129
# Intent: FIX Makefiles with Spaces
# Production: TRUE
# Runner: TRUE
#
#
# Updates:  Makefile for building instrumented Libs + Tools and checking LLVM coverage symbols
#
#
#
#
#
##  Makefile for building instrumented Libs + Tools and checking LLVM coverage symbols
set -e

echo "[*] Building static libraries..."
make -C iccProfLib -f Makefile.iccProfLib clean all AFL=0
make -C iccXmlLib -f Makefile.iccXmlLib clean all AFL=0

echo "[*] Verifying static lib instrumentation..."
cd iccProfLib
ar -x libIccProfLib2.a && for f in *.o; do llvm-objdump -h "$f" | grep -q __llvm_prf_data && echo "   [INSTRUMENTED] $f"; done; rm -f *.o
cd ../iccXmlLib
ar -x libIccXML2.a && for f in *.o; do llvm-objdump -h "$f" | grep -q __llvm_prf_data && echo "   [INSTRUMENTED] $f"; done; rm -f *.o
cd ..

echo "[*] Building coverage-enabled tools..."
make -C iccToXml -f Makefile.iccToXml.asan clean all AFL=0
make -C iccFromXml -f Makefile.iccFromXml clean all AFL=0
make -C iccDumpProfile -f Makefile.iccDumpProfile clean all AFL=0
# make -C iccPngDump -f Makefile.iccPngDump clean all AFL=0
make -C iccRoundTrip -f Makefile.iccRoundTrip clean all AFL=0
# make -C iccTiffDump -f Makefile.IccTiffDump clean all AFL=0
# make -C iccApplyNamedCmm -f Makefile.iccApplyNamedCmm clean all AFL=0
# make -C iccApplyProfiles -f Makefile.iccApplyProfiles clean all AFL=0

echo "[*] Verifying tool instrumentation..."
for tool in iccToXml iccFromXml iccDumpProfile; do
  BIN="$tool/${tool}_test"
  if [[ -f "$BIN" ]]; then
    llvm-objdump -t "$BIN" | grep __llvm_profile > /dev/null && echo "[PASS] $BIN is instrumented" || echo "[FAIL] $BIN not instrumented"
  else
    echo "[FAIL] $BIN not found"
  fi
done

