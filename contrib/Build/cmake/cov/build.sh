#!/bin/bash
## 
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt 
## Date: 28-MAR-2025 2000 EDT
#
# Branch: PR121
# Intent: Makefile for building instrumented Libs + Tools and checking LLVM coverage symbols
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
make -C iccProfLib -f Makefile.iccProfLib
make -C iccXmlLib -f Makefile.iccXmlLib

echo "[*] Verifying static lib instrumentation..."
cd iccproflib
ar -x libIccProfLib2.a && for f in *.o; do llvm-objdump -h "$f" | grep -q __llvm_prf_data && echo "   [INSTRUMENTED] $f"; done; rm -f *.o
cd ../iccxml
ar -x libIccXML2.a && for f in *.o; do llvm-objdump -h "$f" | grep -q __llvm_prf_data && echo "   [INSTRUMENTED] $f"; done; rm -f *.o
cd ..

echo "[*] Building coverage-enabled tools..."
make -C iccToXml -f Makefile.iccToXml
make -C iccFromXml -f Makefile.iccFromXml
make -C iccDumpProfile -f Makefile.iccDumpProfile
make -C iccPngDump -f Makefile.iccPngDump
make -c iccRoundTrip -f Makefile.iccRoundTrip
make -c iccTiffDump -f Makefile.iccTiffDump
make -c iccApplyNamedCmm -f Makefile.iccApplyNamedCmm
make -c iccapplyProfiles -f Makefile.iccApplyProfiles

echo "[*] Verifying tool instrumentation..."
for tool in iccToXml iccFromXml iccDumpProfile iccPngdump iccRoundTrip; do
  BIN="$tool/${tool}_test"
  if [[ -f "$BIN" ]]; then
    llvm-objdump -t "$BIN" | grep __llvm_profile > /dev/null && echo "[PASS] $BIN is instrumented" || echo "[FAIL] $BIN not instrumented"
  else
    echo "[FAIL] $BIN not found"
  fi
done
