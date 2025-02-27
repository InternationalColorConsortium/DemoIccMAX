
# Last Updated: 17-FEB-2025 at 10922 EST by David Hoyt | h02332

## Intent:
   This script polls the macOS device, retrieves system, build and development environment
   details, and reports key security and developer-related configurations.

# Features:
   - Reports macOS kernel, OS, and CPU details
   - Checks for developer toolchain versions and paths
   - Examines environmental variables relevant to development

### Usage:
   Run this script in a terminal with:

     ```
     /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/xnu/contrib/UnitTest/xnu_checks.zsh)"
     ```
