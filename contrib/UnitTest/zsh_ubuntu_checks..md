# Ubuntu Build Report

Intent:
  This script polls the unix zsh host, retrieves system, build and development environment
  details, and reports developer-related configurations.

Features:
  - Reports kernel, OS, and CPU details
  - Checks for developer toolchain versions and paths
  - Examines environmental variables relevant to development

Usage:
  Run this script in a terminal from project_root with:

```
    /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/zsh_ubuntu_checks.zsh)"
```
