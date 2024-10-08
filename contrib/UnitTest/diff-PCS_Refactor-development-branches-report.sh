#!/bin/bash
## 
##
## git diff script to compare allocator | deallocator issues in the PCS_Refactor Branch of DemoIccMAX Project
##
##
## David Hoyt for DemoIccMAX Project
## Date: 27-Sept-24
##
## Run:  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/diff-PCS_Refactor-development-branches-report.sh)"
##

# Enable strict error handling
set -euo pipefail

# Setup logger for better logging practices
LOGFILE="script.log"
exec > >(tee -i "$LOGFILE") 2>&1

# Set up output files
DIFF_CPP="diff_output_cpp.txt"
ANALYSIS_REPORT="analysis_report.txt"
CONDENSED_REPORT="condensed_report.txt"

# Clean previous outputs
> "$DIFF_CPP"
> "$ANALYSIS_REPORT"
> "$CONDENSED_REPORT"

# Function to print banners
print_banner() {
    echo "========================================"
    echo "$1"
    echo "========================================"
}

# Print startup banner
print_banner "Starting Analysis of PCS_Refactor and Development Branches"

# Sectional banner for cloning
print_banner "Cloning repositories..."

# Clone repositories quietly, with no output except error handling
git clone --quiet --branch PCS_Refactor https://github.com/InternationalColorConsortium/DemoIccMAX.git DemoIccMAX || { echo "ERROR: Failed to clone DemoIccMAX"; exit 1; }
git clone --quiet --branch development https://github.com/xsscx/PatchIccMAX.git PatchIccMAX || { echo "ERROR: Failed to clone PatchIccMAX"; exit 1; }

# Sectional banner for diffing and analysis
print_banner "Performing diff and analyzing memory management issues..."

# Function to analyze memory management issues and log diffs
analyze_memory_management_issues() {
    local file=$1
    local corresponding_file=$2

    # Log the diff between the two files
    {
        echo "========================================"
        echo "Diff between $file and $corresponding_file"
        echo "========================================"
    } >> "$DIFF_CPP"
    git diff --no-index "$file" "$corresponding_file" >> "$DIFF_CPP"

    # Log detailed analysis for allocators and deallocators
    local allocators=$(grep -n -E 'malloc\(|new\s|new\[\]' "$file")
    local deallocators=$(grep -n -E 'free\(|delete\s|delete\[\]' "$file")

    # Log memory management analysis in a detailed report
    echo "Analyzing memory management issues in $file" >> "$ANALYSIS_REPORT"

    # Helper function to log mismatches
    log_mismatch() {
        local message=$1
        local alloc_lines=$2
        echo "$message" >> "$ANALYSIS_REPORT"
        echo "$alloc_lines" >> "$ANALYSIS_REPORT"
        echo "$message" >> "$CONDENSED_REPORT"
    }

    # Check for mismatches
    if echo "$allocators" | grep 'malloc(' && ! echo "$deallocators" | grep 'free('; then
        log_mismatch "MISMATCH in $file: malloc() without free()" "$allocators"
    fi
    if echo "$allocators" | grep 'new\s' && ! echo "$deallocators" | grep 'delete\s'; then
        log_mismatch "MISMATCH in $file: new without delete" "$allocators"
    fi
    if echo "$allocators" | grep 'new\[\]' && ! echo "$deallocators" | grep 'delete\[\]'; then
        log_mismatch "MISMATCH in $file: new[] without delete[]" "$allocators"
    fi
    if echo "$deallocators" | grep 'free(' && ! echo "$allocators" | grep 'malloc('; then
        log_mismatch "MISMATCH in $file: free() without malloc()" "$deallocators"
    fi
    if echo "$deallocators" | grep 'delete\s' && ! echo "$allocators" | grep 'new\s'; then
        log_mismatch "MISMATCH in $file: delete without new" "$deallocators"
    fi
    if echo "$deallocators" | grep 'delete\[\]' && ! echo "$allocators" | grep 'new\[\]'; then
        log_mismatch "MISMATCH in $file: delete[] without new[]" "$deallocators"
    fi
}

# Compare .cpp files and analyze for memory issues (no output to console)
find DemoIccMAX -name '*.cpp' | sort | while read -r file; do
    corresponding_file=$(echo "$file" | sed 's|DemoIccMAX|PatchIccMAX|')
    if [ -f "$corresponding_file" ]; then
        analyze_memory_management_issues "$file" "$corresponding_file"
    fi
done

# Ending banner and final summary (only the condensed report output)
print_banner "Memory Management Issue Report (Condensed)"
cat "$CONDENSED_REPORT"

# End of script
print_banner "Analysis Complete."

