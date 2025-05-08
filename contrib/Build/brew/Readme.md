# [BREW REPRO](https://github.com/Homebrew/homebrew-core/pull/221560)

## [iccMAX v2.1.26 for Brew](https://github.com/InternationalColorConsortium/DemoIccMAX/releases/tag/v2.1.26)

_Last Updated: 21-JULY-2025 1200Z by David Hoyt_

---

## Overview

This Homebrew formula packages the [International Color Consortium's](https://www.color.org/) **iccMAX** demonstration implementation tools, version **2.1.26**, for cross-platform color management support.  

It provides command-line tools and libraries used for profile management, XML conversions, and ICC testing.

---

## Brew Packaging Reproduction Steps

```bash
# 1. Uninstall any existing version
brew uninstall local/iccmax/iccmax

# 2. Install from local source (skip API bottles)
HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source local/iccmax/iccmax

# 3. Check Ruby and formula style
brew style local/iccmax/iccmax

# 4. Perform strict auditing
brew audit --strict local/iccmax/iccmax

# 5. Audit again with new formula checks
brew audit --new local/iccmax/iccmax

# 6. Run package tests
brew test local/iccmax/iccmax

# 7. Final style verification
brew style local/iccmax/iccmax
