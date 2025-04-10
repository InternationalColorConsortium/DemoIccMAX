#!/bin/bash
## 
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt 
## Date: 30-MAR-2025 1400 EDT
#
# Branch: PR121
# Intent: iccFromXml_test | ICC Coverage Harness with Directory Mirroring, Profile Injection & Reporting
# Production: TRUE
# Runner: TRUE
#
#
# Updates:  iccFromXml_test | ICC Coverage Harness with Directory Mirroring, Profile Injection & Reporting
#          
#
#  
##  
## 
## iccFromXml_test | ICC Coverage Harness with Directory Mirroring, Profile Injection & Reporting

set -euo pipefail

# === Configuration ===
BIN=iccFromXml_test
PROFILE_DIR=profraw
OUTDIR=output_icc
COVTXT=iccFromXml-coverage.txt
COVHTML=htmlcov
PROFDATA=iccFromXml.profdata
FAILED_LOG=failed_inputs.txt
CREATE_PROFILES_SCRIPT=Testing/CreateAllProfiles.sh
CORES=$(nproc || sysctl -n hw.logicalcpu || echo 1)

# Ensure BIN is in PATH
export PATH="$(pwd):$PATH"

# === Optional Clean Command ===
if [[ "${1:-}" == "clean" ]]; then
  echo "[•] Cleaning generated artifacts..."
  rm -rf "$PROFILE_DIR" "$COVHTML" "$OUTDIR" \
         "$FAILED_LOG" "$COVTXT" "$PROFDATA"
  echo "[✓] Clean complete."
  exit 0
fi

# === Cleanup (always) ===
rm -rf "$PROFILE_DIR" "$COVHTML" "$OUTDIR"
rm -f "$FAILED_LOG" "$COVTXT" "$PROFDATA"
mkdir -p "$OUTDIR" "$PROFILE_DIR"

# === File Discovery ===
echo "[✓] Discovering .xml files..."
mapfile -d '' xml_files < <(find . -type f -name "*.xml" -print0)

if [[ "${#xml_files[@]}" -eq 0 ]]; then
  echo "[!] No XML files found. Aborting."
  exit 1
fi

echo "[✓] Found ${#xml_files[@]} XML files"

# === Conversion Function with Directory Mirroring ===
process_xml_file() {
  local f="$1"
  local relf base outdir out prof

  relf="${f#./}"
  base="$(basename "$relf" .xml)"
  outdir="$OUTDIR/$(dirname "$relf")"
  out="${outdir}/${base}.icc"
  prof="${PROFILE_DIR}/iccFromXml_${base}.profraw"

  mkdir -p "$outdir"

  echo "[+] Processing: $relf"
  if LLVM_PROFILE_FILE="$prof" "$BIN" "$f" "$out"; then
    echo "[✓] Success: $relf"
  else
    echo "[✗] Failed: $relf"
    echo "$relf" >> "$FAILED_LOG"
  fi
}

export -f process_xml_file
export BIN PROFILE_DIR OUTDIR FAILED_LOG

# === Parallel Execution ===
printf "%s\0" "${xml_files[@]}" | xargs -0 -n1 -P"$CORES" bash -c 'process_xml_file "$0"' || true

# === Profile Injection Script ===
if [[ -x "$CREATE_PROFILES_SCRIPT" ]]; then
  echo "[•] Running CreateAllProfiles.sh with instrumentation..."
  LLVM_PROFILE_FILE="${PROFILE_DIR}/iccFromXml_all_%p.profraw" "$CREATE_PROFILES_SCRIPT" || \
    echo "[!] Warning: CreateAllProfiles.sh failed (continuing anyway)"
else
  echo "[!] Skipping profile injection: $CREATE_PROFILES_SCRIPT not found or not executable"
fi

# === Profiling & Coverage ===
echo "[•] Merging raw profiles..."
llvm-profdata merge -sparse "$PROFILE_DIR"/*.profraw -o "$PROFDATA"

echo "[•] Generating flat annotated coverage report..."
llvm-cov show "$BIN" -instr-profile="$PROFDATA" > "$COVTXT"

echo "[•] Generating summary coverage table..."
llvm-cov report "$BIN" -instr-profile="$PROFDATA"

echo "[•] Generating HTML coverage report..."
llvm-cov show "$BIN" -instr-profile="$PROFDATA" -format=html -output-dir="$COVHTML"

# === Final Report ===
PASS_COUNT=$(find "$OUTDIR" -name '*.xml' | wc -l)
FAIL_COUNT=$(wc -l < "$FAILED_LOG" 2>/dev/null || echo 0)
TOTAL=$((PASS_COUNT + FAIL_COUNT))

echo ""
echo "================== ✅ Final Report =================="
echo "  Total XML inputs     : $TOTAL"
echo "  Successful conversions: $PASS_COUNT"
echo "  Failures logged in    : $FAILED_LOG"
echo "-----------------------------------------------------"
echo "  ICC output directory  : $OUTDIR"
echo "  Annotated coverage    : $COVTXT"
echo "  HTML coverage report  : $COVHTML/index.html"
echo "====================================================="

exit $([[ "$FAIL_COUNT" -eq 0 ]] && echo 0 || echo 1)
