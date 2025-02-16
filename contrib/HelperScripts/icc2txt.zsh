#!/bin/zsh
#
# Copyright (c) 2024-2025. International Color Consortium. All rights reserved.
#
# Last Updated: 16-FEB-2025 at 0906 EST by David Hoyt | h02332
#
# Intent:
#   xxd dump of Testing/ .icc color profiles
#
#
#
#
#
# Usage:
#   Run this script in a terminal with:
#     /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/HelperScripts/icc2txt.zsh)"
#
#
#
# ============================================================

# Banner
echo "Copyright (c) 2025 International Color Consortium | All rights reserved."
echo "Copyright (c) 2024 David H Hoyt LLC | All rights reserved."
echo "zsh xxd dump of Testing/ .icc color profiles"
echo "Last Updated: 0906 EST on 16-FEB-2025"

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

# Get the current timestamp (safe for filenames)
current_timestamp() {
    date +"%Y-%m-%d_%H-%M-%S"
}

# Logging function
log_message() {
    local message="$1"
    echo "[$(current_timestamp)] $message" | tee -a "$consolidated_report"
}

# Function to process ICC files and dump extracted hex data
process_icc_file() {
    local file="$1"
    local filename=$(basename "$file")
    local timestamp=$(current_timestamp)  # Timestamp for unique file naming

    # Ensure filename is safe for filesystem
    local safe_filename="${filename// /_}"  # Replace spaces with underscores
    local output_filename="${safe_filename}-xxd-${timestamp}.txt"
    local metadata_filename="${safe_filename}-metadata-${timestamp}.txt"
    local output_filepath="${OUTPUT_DIR}/${output_filename}"
    local metadata_filepath="${OUTPUT_DIR}/${metadata_filename}"

    # Extract specific ICC fields using dd and xxd -p
    {
        echo "ICC Profile Metadata for: $filename"
        echo "----------------------------------------"
        printf "Magic Bytes: " 
        dd if="$file" bs=1 skip=36 count=4 2>/dev/null | xxd -p
        printf "\nProfile Size: " 
        dd if="$file" bs=1 skip=0 count=4 2>/dev/null | xxd -p
        printf "\nProfile Version: " 
        dd if="$file" bs=1 skip=8 count=4 2>/dev/null | xxd -p
        printf "\nDevice Class: " 
        dd if="$file" bs=1 skip=12 count=4 2>/dev/null | xxd -p
        printf "\nColor Space: " 
        dd if="$file" bs=1 skip=16 count=4 2>/dev/null | xxd -p
        printf "\nCMM Type: " 
        dd if="$file" bs=1 skip=4 count=4 2>/dev/null | xxd -p
        printf "\nReserved Bytes: " 
        dd if="$file" bs=1 skip=76 count=4 2>/dev/null | xxd -p
        echo ""
    } > "$metadata_filepath"

    # Dump full ICC profile to xxd format
    xxd "$file" > "$output_filepath"

    # Log the action to both the report and console
    log_message "Processed: $file -> $metadata_filepath (Metadata)"
    log_message "Processed: $file -> $output_filepath (Full Dump)"
}

# Begin logging the start of the script
log_message "Starting ICC profile xxd analysis"

# Supported ICC profile extensions
find . -type f \( -iname "*.icc" -o -iname "*.icm" -o -iname "*.iccp" -o -iname "*.icf" -o -iname "*.profile" -o -iname "*.icd" -o -iname "*.icr" -o -iname "*.icb" -o -iname "*.iic" \) | while IFS= read -r icc_file; do
    process_icc_file "$icc_file"
done

# Log completion of the script
log_message "ICC profile xxd analysis completed"
