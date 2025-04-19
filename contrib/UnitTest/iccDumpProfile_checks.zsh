#!/bin/zsh
#
## Copyright (c) 2024 The International Color Consortium. All rights reserved.
##
## Written by David Hoyt for ICC color.org & DemoIccMAX Project
## Date: 27-Sept-24
##
## zsh iccDumpProfile check of Testing/ .icc color profiles
## Purpose: Automates the build and testing for icc color profiles
##
#
#
#
#
# Run from Testing/
# /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/iccDumpProfile_checks.zsh)"
#
#
#
# ============================================================

# Path to the iccDumpProfile tool
iccDumpProfile_path="../Build/Tools/IccDumpProfile/iccDumpProfile"

# Expand the full path (expanding the '~' to the home directory)
iccDumpProfile_path=$(eval echo $iccDumpProfile_path)

# Directory to store individual report files
report_dir="./icc_reports"

# Create the report directory if it doesn't exist
mkdir -p $report_dir

# Timestamp format for filenames
timestamp=$(date +'%Y%m%d_%H%M%S')

# Summary file
summary_file="icc_profile_summary_$timestamp.txt"
echo "ICC Profile Summary Report - Generated on $timestamp" > $summary_file
echo "=====================================================" >> $summary_file
echo "" >> $summary_file

# Traverse the current directory and subdirectories for .icc files
find . -type f -name "*.icc" | while read -r icc_file; do
    echo "Processing: $icc_file"

    # Create a timestamped report file for each .icc file
    base_name=$(basename "$icc_file" .icc)
    report_file="$report_dir/${base_name}_report_$timestamp.txt"

    # Run the iccDumpProfile tool and capture both stdout and stderr
    $iccDumpProfile_path "$icc_file" > "$report_file" 2>&1

    echo "Generated report: $report_file"

    # Analyze the report file and tabulate key-value pairs
    echo "Analyzing report: $report_file" >> $summary_file
    echo "File: $icc_file" >> $summary_file

    # Parsing the report to capture Header section key-value pairs
    in_header_section=false
    while IFS= read -r line; do
        # Detect when we are in the Header section
        if [[ "$line" == "Header" ]]; then
            in_header_section=true
            echo "Header Information:" >> $summary_file
            continue
        fi

        # Detect when we leave the Header section (at the next section)
        if [[ "$line" == "Profile Tags" ]]; then
            in_header_section=false
            echo "" >> $summary_file  # Separate header from other sections
        fi

        # Extract and log key-value pairs from the Header section
        if $in_header_section && [[ "$line" =~ ^[[:space:]]*([^:]+):[[:space:]]*(.*)$ ]]; then
            key="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"

            # Clean up extra spaces around key and value
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)

            # Write key-value pair to the summary if both are not empty
            if [[ -n "$key" && -n "$value" ]]; then
                echo "  $key: $value" >> $summary_file
            fi
        fi

        # Capture UndefinedBehaviorSanitizer runtime errors and log them
        if [[ "$line" =~ ^SUMMARY:[[:space:]]UndefinedBehaviorSanitizer ]]; then
            echo "  Runtime Error: $line" >> $summary_file
        fi
    done < "$report_file"

    echo "" >> $summary_file
    echo "-----------------------------------------------------" >> $summary_file
done

# Output the summary to the console
cat $summary_file
