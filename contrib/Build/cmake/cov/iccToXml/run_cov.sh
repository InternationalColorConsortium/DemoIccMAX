#!/bin/bash
## 
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt 
## Date: 20-MAR-2025 1400 EDT
#
# Branch: PR121
# Intent: iccToXml_test | ICC Coverage Harness with Directory Mirroring, Profile Injection & Reporting
# Production: TRUE
# Runner: TRUE
#
#
# Updates:   iccToXml_test | ICC Coverage Harness with Directory Mirroring, Profile Injection & Reporting
#          
#
# 
# 
#  
##   iccToXml_test | ICC Coverage Harness with Directory Mirroring, Profile Injection & Reportings

# === Batch Runner: iccToXml LLVM-Coverage with Crash Resilience and HTML Output ===

set -euo pipefail

BIN=./iccToXml_test
PROFILE_DIR=profraw
OUTDIR=output_xml
COVTXT=iccToXml-coverage.txt
COVHTML=htmlcov
PROFDATA=iccToXml.profdata
FAILED_LOG=failed_inputs.txt

mkdir -p "$OUTDIR" "$PROFILE_DIR"
rm -f "$PROFILE_DIR"/*.profraw "$COVTXT" "$PROFDATA" "$FAILED_LOG"
rm -rf "$COVHTML"

FAILED=0

# === Run Conversion on All .icc Files ===
find . -type f -name "*.icc" -print0 | while IFS= read -r -d '' f; do
  base="$(basename "$f" .icc)"
  out="${OUTDIR}/${base}.xml"
  prof="${PROFILE_DIR}/iccToXml_${base}.profraw"

  echo "[+] $f -> $out"
  if LLVM_PROFILE_FILE="$prof" "$BIN" "$f" "$out"; then
    echo "XML successfully created"
  else
    echo "[!] Failed to process $f"
    echo "$f" >> "$FAILED_LOG"
    FAILED=1
  fi
done

# === Merge Coverage Data ===
llvm-profdata merge -sparse "$PROFILE_DIR"/*.profraw -o "$PROFDATA"

# === Text Coverage Report ===
llvm-cov show "$BIN" -instr-profile="$PROFDATA" > "$COVTXT"
echo "[✓] Text coverage report written to $COVTXT"

# === HTML Coverage Report ===
llvm-cov show "$BIN" -instr-profile="$PROFDATA" -format=html -output-dir="$COVHTML"
echo "[✓] HTML coverage report generated in $COVHTML/index.html"

# === Summary ===
if [ "$FAILED" -ne 0 ]; then
  echo "[!] Some files failed to process. See $FAILED_LOG"
  exit 1
else
  echo "[✓] All files processed successfully."
fi
