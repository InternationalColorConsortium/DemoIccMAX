#!/bin/zsh
#
# Copyright (c) 2025. International Color Consortium. All rights reserved.
# Copyright (c) 2024. David H Hoyt LLC. All rights reserved.
#
# Last Updated: 16-FEB-2025 at 1525 EST by David Hoyt | h02332
#
# Intent:
#   This script polls the macOS device, retrieves system, build and development environment
#   details, and reports key security and developer-related configurations.
#
# Features:
#   - Reports macOS kernel, OS, and CPU details
#   - Checks for developer toolchain versions and paths
#   - Examines environmental variables relevant to development
#
# Usage:
#   Run this script in a terminal from project_root with:
#     /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/xnu_checks.zsh)"
#
# Output files
LOG_FILE="build-troubleshooter.log"
HTML_FILE="iccmax_build_report.html"

echo "=== macOS Build Host Report ===" > "$LOG_FILE"

# Function to log commands and their outputs
log_command() {
    echo "=== Command: $1 ===" | tee -a "$LOG_FILE"
    eval "$1" 2>&1 | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
}

# === COLLECT BUILD SYSTEM INFO ===
log_command "sysctl -a | grep kern.version"
log_command "sysctl -a | grep kern.osversion"
log_command "sysctl -a | grep kern.osproductversion"
log_command "sysctl -a | grep machdep.cpu.brand_string"
log_command "csrutil status"
log_command "xcrun --show-sdk-path"
log_command "xcode-select -p"
log_command "clang -v"
log_command "clang -### -c test.c 2>&1 | grep -i 'cc1args'"
log_command "ld -v"
log_command "lldb --version"
log_command "env | grep -i xcode"
log_command "env | grep -i sdk"
log_command "env | grep -i clang"
log_command "env | grep -i cflags"
log_command "env | grep -i ldflags"

if command -v brew >/dev/null 2>&1; then
    log_command "brew list --versions"
else
    echo "Homebrew not installed." | tee -a "$LOG_FILE"
fi

log_command "ls /Applications | grep Xcode"
log_command "ls -l /usr/lib/dyld"
log_command "dyldinfo /usr/lib/dyld"
log_command "df -h"
log_command "which make"
log_command "which cmake"
log_command "which ninja"
log_command "pkgutil --pkgs | grep -i 'commandlinetools'"
log_command "pkgutil --pkg-info=com.apple.pkg.CLTools_Executables"

# === BINARY ANALYSIS ===
log_file="qqq.zsh_top_$(date +%Y%m%d_%H%M%S).log"
total_files=0
executables_count=0
dynamic_libs_count=0
static_libs_count=0
codesigned_count=0
unsigned_files=0

typeset -a executables dynamic_libs static_libs codesigned_files unsigned_files_list

log_message() {
    echo "$(date): $1" | tee -a "$log_file"
}

escape_html() {
    echo "$1" | sed -E 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g'
}

check_codesigning() {
    if codesign --verify "$1" &>/dev/null; then
        codesigned_files+=("$1")
        ((codesigned_count++))
    else
        unsigned_files_list+=("$1")
        ((unsigned_files++))
    fi
}

log_message "Starting inventory for compiled build files (excluding scripts & CMakeFiles/)"

find Build/ Tools/ Testing/ IccXML/ IccProfLib/ -type f \( \
    -name "*.dylib" -o -name "*.a" -o -perm -111 \) \
    ! -name "*.sh" ! -name "*.zsh" ! -name "*.py" \
    ! -path "*/CMakeFiles/*" | while read -r binary; do

    file_info=$(file "$binary")

    case "$file_info" in
        (*"Mach-O 64-bit executable"*)
            executables+=("$binary")
            ((executables_count++))
            ;;
        (*"Mach-O 64-bit dynamically linked shared library"*)
            dynamic_libs+=("$binary")
            ((dynamic_libs_count++))
            ;;
        (*"current ar archive"*)
            static_libs+=("$binary")
            ((static_libs_count++))
            ;;
    esac
    
    check_codesigning "$binary"
    ((total_files++))
done

log_message "\nBuild Report"
log_message "--------------"
log_message "Total Files Found: $total_files"
log_message "Executables Found: $executables_count"
log_message "Dynamic Libraries Found: $dynamic_libs_count"
log_message "Static Libraries Found: $static_libs_count"
log_message "Codesigned Files: $codesigned_count"
log_message "Unsigned Files: $unsigned_files"

# === GENERATE HTML REPORT ===
generate_html_report() {
    cat <<EOF > "$HTML_FILE"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IccMAX Developer Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        header { display: flex; align-items: center; padding: 10px 0; }
        header img { height: 60px; margin-right: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f4f4f4; }
        pre { background: #f4f4f4; padding: 10px; border-radius: 5px; overflow-x: auto; }
    </style>
</head>
<body>
    <header>
        <a href="https://color.org" target="_blank">
            <img src="https://color.org/system/images/ICC_logo_text.gif" alt="ICC Text">
        </a>
    </header>
    <p>Generated on: $(date)</p>
    <h1>IccMAX Developer Report</h1>

    <h2>Build Summary</h2>
    <table>
        <tr><th>Total Files</th><td>$total_files</td></tr>
        <tr><th>Executables</th><td>${executables_count}</td></tr>
        <tr><th>Dynamic Libraries</th><td>${dynamic_libs_count}</td></tr>
        <tr><th>Static Libraries</th><td>${static_libs_count}</td></tr>
        <tr><th>Codesigned Files</th><td>${codesigned_count}</td></tr>
        <tr><th>Unsigned Files</th><td>${unsigned_files}</td></tr>
    </table>
EOF

    generate_table_section() {
        local title="$1"
        shift
        local files=("$@")

        echo "<h2>$title</h2><table><tr><th>#</th><th>Path</th></tr>" >> "$HTML_FILE"

        if (( ${#files[@]} > 0 )); then
            local index=1
            for file in "${files[@]}"; do
                local escaped_file
                escaped_file=$(escape_html "$file")
                echo "<tr><td>$index</td><td>$escaped_file</td></tr>" >> "$HTML_FILE"
                ((index++))
            done
        else
            echo "<tr><td colspan='2'>No files found.</td></tr>" >> "$HTML_FILE"
        fi

        echo "</table>" >> "$HTML_FILE"
    }

    generate_table_section "Executables" "${executables[@]}"
    generate_table_section "Dynamic Libraries" "${dynamic_libs[@]}"
    generate_table_section "Static Libraries" "${static_libs[@]}"
    generate_table_section "Codesigned Files" "${codesigned_files[@]}"
    generate_table_section "Unsigned Files" "${unsigned_files_list[@]}"

    echo "<h2>Build Host Details</h2>" >> "$HTML_FILE"
    echo "<pre>$(escape_html "$(cat $LOG_FILE)")</pre>" >> "$HTML_FILE"
    
    echo "</body></html>" >> "$HTML_FILE"
    log_message "HTML report generated at $HTML_FILE"
}

generate_html_report

