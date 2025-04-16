#!/bin/bash
## 
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt 
## Date: 20-MAR-2025 1400 EDT
#
# Branch: PR121
# Intent: iccToXml_test | Generate Report ICC Coverage Harness with Directory Mirroring, Profile Injection & Reporting
# Production: TRUE
# Runner: TRUE
#
#
# Updates:   iccToXml_test | Generate Report ICC Coverage Harness with Directory Mirroring, Profile Injection & Reporting
#          
#
# 
# 
#  
##   iccToXml_test | Generate Report ICC Coverage Harness with Directory Mirroring, Profile Injection & Reportings

INPUT_LOG="sanitizer_failures.log"
TXT_OUT="report.txt"
HTML_OUT="report.html"

echo "[*] Generating reports..."

# Reset files
: > "$TXT_OUT"
: > "$HTML_OUT"

# Group and summarize
echo "====== Sanitizer Report (Text) ======" >> "$TXT_OUT"
for category in "AddressSanitizer" "runtime error" "Segmentation"; do
  echo -e "\n--- $category ---" >> "$TXT_OUT"
  grep "$category" "$INPUT_LOG" | sort | uniq >> "$TXT_OUT"
done

# HTML output
cat <<EOF >> "$HTML_OUT"
<!DOCTYPE html>
<html><head>
  <meta charset="UTF-8">
  <title>Sanitizer Report</title>
  <style>
    body { font-family: monospace; background: #f8f8f8; padding: 1em; }
    h2 { border-bottom: 1px solid #ccc; }
    .asan { color: red; font-weight: bold; }
    .ubsan { color: orange; font-weight: bold; }
    .segv { color: purple; font-weight: bold; }
    .log { margin-left: 2em; white-space: pre-wrap; }
  </style>
</head><body>
<h1>Sanitizer Failure Report</h1>
EOF

for category in "AddressSanitizer" "runtime error" "Segmentation"; do
  class=$(echo "$category" | tr '[:upper:]' '[:lower:]' | cut -d' ' -f1)
  echo "<h2 class=\"$class\">$category</h2><div class=\"log\">" >> "$HTML_OUT"
  grep "$category" "$INPUT_LOG" | sort | uniq | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' >> "$HTML_OUT"
  echo "</div>" >> "$HTML_OUT"
done

echo "</body></html>" >> "$HTML_OUT"

echo "[✓] Created: $TXT_OUT, $HTML_OUT"
