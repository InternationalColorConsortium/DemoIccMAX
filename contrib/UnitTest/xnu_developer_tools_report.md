# macOS Build Troubleshooter

Last Updated by: David Hoyt | h02332 | 16-FEB-2025 0924 EST

## Intent

A Zsh script to collect and log essential macOS system and build environment details for debugging.

### Polling

Logs kernel, macOS, Xcode, Clang, and LLDB details

Checks System Integrity Protection (SIP) status

Reports installed Homebrew packages (if available)

Verifies available disk space and build tools

### Usage

```
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/UnitTest/xnu_developer_tools_report.zsh)"
```
