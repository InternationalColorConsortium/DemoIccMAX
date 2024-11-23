#!/bin/zsh
# macOS sips check of Testing/ .icc color profiles
# Refactor Date: 30-Sept-2024
# Author: David Hoyt
# Purpose: Automates the build and testing for icc color profiles
#
# ============================================================

echo "macOS sips check of Testing/ .icc color profiles"
echo "Written by David Hoyt for DemoIccMAX Project"
echo "Last Updated: 1440 on 30-Sept-2024"

# Summary counters for unique and recurring issues
declare -A header_issues
declare -A tag_issues
declare -A general_issues

# Loop through all .icc files in the current directory and subdirectories
find . -type f -name "*.icc" | while IFS= read -r icc_file; do
  # Extract the base name of the file without the directory and extension
  base_name=$(basename "$icc_file" .icc)

  # Create the output file name based on the base name
  output_file="${base_name}-sips.txt"

  # Run the sips --verify command and save the output to the file
  echo "Verifying file: $icc_file"
  sips --verify "$icc_file" > "$output_file" 2>&1

  # Parse the output for header and tag messages
  while IFS= read -r line; do
    # Check for header-related issues
    if [[ $line =~ "Header" ]]; then
      header_issues["$line"]=$((header_issues["$line"] + 1))
    fi

    # Check for tag-related issues
    if [[ $line =~ "Tag" ]]; then
      tag_issues["$line"]=$((tag_issues["$line"] + 1))
    fi

    # Capture general warnings and errors
    if [[ $line =~ "Warning" || $line =~ "Error" ]]; then
      general_issues["$line"]=$((general_issues["$line"] + 1))
    fi
  done < "$output_file"
done

# Final report
report_file="sips_verification_report.txt"
echo "Generating final report: $report_file"
echo "Summary of sips verification:" > "$report_file"

# Header issues summary
echo "" >> "$report_file"
echo "=== Header Issues ===" >> "$report_file"
for issue in "${(@k)header_issues}"; do
  echo "$issue: ${header_issues[$issue]}" >> "$report_file"
done

# Tag issues summary
echo "" >> "$report_file"
echo "=== Tag Issues ===" >> "$report_file"
for issue in "${(@k)tag_issues}"; do
  echo "$issue: ${tag_issues[$issue]}" >> "$report_file"
done

# General warnings and errors summary
echo "" >> "$report_file"
echo "=== General Warnings and Errors ===" >> "$report_file"
for issue in "${(@k)general_issues}"; do
  echo "$issue: ${general_issues[$issue]}" >> "$report_file"
done

echo "Report generated: $report_file"
tail -n 100 sips_verification_report.txt
echo "Done!"
