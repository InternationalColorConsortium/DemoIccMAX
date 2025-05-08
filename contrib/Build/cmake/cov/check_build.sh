#!/bin/bash
## 
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt 
## Date: 15-APRIL-2025 2000 EDT
#
# Branch: PR124
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

echo "🔍 [1] Checking all .a static libraries for LLVM instrumentation..."
for lib in $(find . -name '*.a'); do
  echo ">> Checking $lib"
  mkdir -p tmp_obj && cd tmp_obj
  ar -x "../$lib"
  for f in *.o; do
    if llvm-objdump -h "$f" | grep -q __llvm_prf_data; then
      echo "  ✔ [INSTRUMENTED] $f"
    else
      echo "  ⚠️  [NOT INSTRUMENTED] $f"
    fi
  done
  cd .. && rm -rf tmp_obj
done

echo ""
echo "✅ Validation complete. Check 'asan_leak_report.*' if generated."
