#!/bin/zsh
#
# Copyright (c) 2025. International Color Consortium. All rights reserved.
# Copyright (c) 2024. David H Hoyt LLC. All rights reserved.
#
# Last Updated: 16-FEB-2025 at 0919 EST by David Hoyt | h02332
#
# Intent:
#   This point and shoot script polls the macOS device, retrieves system and development environment
#   details, and generates a macOS Build Troubleshooting Report.
#
# Usage:
#   Run this script in a terminal with:
#     /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/xnu_developer_tools_report.zsh)"
#
#
#
#
#
#

# Output file for logs
LOG_FILE="build-troubleshooter.log"
echo "=== macOS Build Troubleshooting Report ===" > "$LOG_FILE"

# Function to log commands and their outputs
log_command() {
    echo "=== Command: $1 ===" | tee -a "$LOG_FILE"
    eval "$1" 2>&1 | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
}

# Collect kernel and system information
log_command "sysctl -a | grep kern.version"
log_command "sysctl -a | grep kern.osversion"
log_command "sysctl -a | grep kern.iossupportversion"
log_command "sysctl -a | grep kern.osproductversion"
log_command "sysctl -a | grep machdep.cpu.brand_string"

# Check System Integrity Protection status
log_command "csrutil status"

# Check Xcode and SDK paths
log_command "xcrun --show-sdk-path"
log_command "xcode-select -p"

# Check clang version
log_command "clang -v"

# Check compiler default flags
log_command "clang -### -c test.c 2>&1 | grep -i 'cc1args'"

# Check linker default flags
log_command "ld -v"

# Check LLDB version
log_command "lldb --version"

# Check active environment variables
log_command "env | grep -i xcode"
log_command "env | grep -i sdk"
log_command "env | grep -i clang"
log_command "env | grep -i cflags"
log_command "env | grep -i ldflags"

# Check installed Homebrew packages
if command -v brew >/dev/null 2>&1; then
    log_command "brew list --versions"
else
    echo "Homebrew not installed." | tee -a "$LOG_FILE"
fi

# Check available Xcode versions (if multiple)
log_command "ls /Applications | grep Xcode"

# Check dynamic linker shared cache (dyld)
log_command "ls -l /usr/lib/dyld"
log_command "dyldinfo /usr/lib/dyld"

# Check system disk space
log_command "df -h"

# Collect system build tools and paths
log_command "which make"
log_command "which cmake"
log_command "which ninja"

# Collect details on build-related packages
log_command "pkgutil --pkgs | grep -i 'commandlinetools'"
log_command "pkgutil --pkg-info=com.apple.pkg.CLTools_Executables"

# Collect LLDB debugger info
log_command "lldb --version"


# Final Summary to Console
echo -e "\n=== Summary: Key Information Collected ==="
echo "Kernel Version:" $(sysctl -n kern.version | head -n 1)
echo "OS Version:" $(sysctl -n kern.osproductversion)
echo "Xcode Path:" $(xcode-select -p)
echo "Clang Version:" $(clang --version | head -n 1)
echo "LLDB Version:" $(lldb --version | head -n 1)
if command -v brew >/dev/null 2>&1; then
    echo "Homebrew Installed Packages:" $(brew list --versions | wc -l)
else
    echo "Homebrew: Not Installed"
fi
echo -e "\nFull details have been logged to: $LOG_FILE"

