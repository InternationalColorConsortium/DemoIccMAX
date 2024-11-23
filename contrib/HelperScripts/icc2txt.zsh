#!/bin/zsh
#
## Copyright (c) 2024 The International Color Consortium. All rights reserved.
##
## Written by David Hoyt for ICC color.org & DemoIccMAX Project
## Date: 27-Sept-24
##
## zsh xxd check of Testing/ .icc color profiles
## Purpose: Automates the build and testing for icc color profiles
##
# ============================================================

# Banner
echo "International Color Consortium | DemoIccMAX Project | Copyright 2024."
echo "For more information on The International Color Consortium, please see http://color.org/."
echo "zsh xxd check of Testing/ .icc color profiles"
echo "Written by David Hoyt for DemoIccMAX Project"
echo "Last Updated: 0800 EDT on 08-Oct-2024"

# ICC xxd report file
consolidated_report="consolidated_icc_report.txt"

# Initialize the consolidated report
echo "Consolidated ICC Profile Analysis Report" > "$consolidated_report"
echo "----------------------------------------" >> "$consolidated_report"
echo "" >> "$consolidated_report"

# Set the output directory for xxd dump files
OUTPUT_DIR="./icc-xxd"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Get the current timestamp for logging purposes
current_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Logging function
log_message() {
    local message="$1"
    echo "[$(current_timestamp)] $message" | tee -a "$consolidated_report"
}

# Function to process ICC files
process_icc_file() {
    local file="$1"
    local filename=$(basename "$file")
    local timestamp=$(current_timestamp)
    
    # Generate output filename with the ICC profile name and timestamp
    local output_filename="${filename%.icc}-xxd-${timestamp}.txt"
    
    # Use xxd to dump the file and save it in the output directory
    xxd "$file" > "${OUTPUT_DIR}/${output_filename}"
    
    # Log the action to both the report and console
    log_message "Processed: $file -> ${OUTPUT_DIR}/${output_filename}"
}

# Begin logging the start of the script
log_message "Starting ICC profile xxd analysis"

# Find all ICC files (and variations) recursively in the current directory
find . -type f \( -iname "*.icc" -o -iname "*.icm" -o -iname "*.iccp" -o -iname "*.icf" \) | while read -r icc_file; do
    process_icc_file "$icc_file"
done

# Log completion of the script
log_message "ICC profile xxd analysis completed"
