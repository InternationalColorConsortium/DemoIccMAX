#!/bin/bash
## 
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt 
## Date: 20-MAR-2025 1400 EDT
#
# Branch: PR121
# Intent: iccToXml_test | RUN + Filter ICC Coverage Harness with Directory Mirroring, Profile Injection & Reporting
# Production: TRUE
# Runner: TRUE
#
#
# Updates:   iccToXml_test | RUN + Filter ICC Coverage Harness with Directory Mirroring, Profile Injection & Reporting
#          
#
# 
# 
#  
##   iccToXml_test | RUN + Filter ICC Coverage Harness with Directory Mirroring, Profile Injection & Reportings

INPUTS_FILE="failed_inputs.txt"
BINARY="./iccToXml_test"
OUTPUT_DIR="logs"
AGGREGATE_LOG="sanitizer_failures.log"

mkdir -p "$OUTPUT_DIR"
rm -f "$AGGREGATE_LOG"

while read f; do
  base=$(basename "$f")
  echo "[*] Testing: $f"

  ASAN_OPTIONS=fast_unwind_on_malloc=0 \
  UBSAN_OPTIONS=print_stacktrace=1 \
  "$BINARY" "$f" /dev/null 2>&1 | tee "$OUTPUT_DIR/$base.log" | \
    grep -E "runtime error|undefined|Segmentation|AddressSanitizer" | \
    sed "s|^|[$base] |" >> "$AGGREGATE_LOG"

done < "$INPUTS_FILE"
