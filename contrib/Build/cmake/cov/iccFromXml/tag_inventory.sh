#!/bin/bash
## 
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt 
## Date: 30-MAR-2025 1400 EDT
#
# Branch: PR121
# Intent: tag_inventory.sh — Icc Tag inventory processor with output redirection
# Production: TRUE
# Runner: TRUE
#
#
# Updates:  tag_inventory.sh — Icc Tag inventory processor with output redirection
#          
#
#  
##  
## 
# tag_inventory.sh — Icc Tag inventory processor with output redirection

set -euo pipefail

OUTDIR="inventory_output"
SUMMARY_DIR="inventory_summary"
mkdir -p "$SUMMARY_DIR"

TAG_LIST="$SUMMARY_DIR/all_tags.txt"
FILE_LIST="$SUMMARY_DIR/all_files.txt"
MATRIX_CSV="$SUMMARY_DIR/tag_matrix.csv"
TAG_FREQ="$SUMMARY_DIR/tag_frequencies.txt"

echo "[•] Collecting tag and file lists..."
find "$OUTDIR" -name '*.tags.txt' > "$FILE_LIST"

# Extract all tags across all files
> "$TAG_LIST"
while IFS= read -r TAGFILE; do
  cat "$TAGFILE"
done < "$FILE_LIST" | sort | uniq > "$TAG_LIST"

TAG_COUNT=$(wc -l < "$TAG_LIST")
FILE_COUNT=$(wc -l < "$FILE_LIST")
echo "[✓] Found $FILE_COUNT files with $TAG_COUNT unique tags"

# Tag frequency
> "$TAG_FREQ"
while IFS= read -r TAGFILE; do
  cat "$TAGFILE"
done < "$FILE_LIST" | sort | uniq -c | sort -nr > "$TAG_FREQ"
echo "[✓] Tag frequency written to: $TAG_FREQ"

# Generate CSV matrix with output redirection
{
  printf "File"
  while IFS= read -r TAG; do
    printf ","%s"" "$TAG"
  done < "$TAG_LIST"
  printf "\n"

  while IFS= read -r FILE; do
    REL_FILE="${FILE#$OUTDIR/}"
    printf ""%s"" "$REL_FILE"

    while IFS= read -r TAG; do
      if grep -Fxq "$TAG" "$FILE"; then
        printf ",1"
      else
        printf ",0"
      fi
    done < "$TAG_LIST"
    printf "\n"
  done < "$FILE_LIST"
} > "$MATRIX_CSV"

echo ""
echo "=== Summary ==="
echo "• Files processed   : $FILE_COUNT"
echo "• Unique tags found : $TAG_COUNT"
echo "• CSV Matrix        : $MATRIX_CSV"
echo "• Tag Frequencies   : $TAG_FREQ"
echo "• Tag List          : $TAG_LIST"
