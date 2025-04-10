# Profile Checker Scripts

These scripts inspect system profiles or shell configurations across Windows (PowerShell) and Unix-like systems (Zsh). They're useful for administrators, developers, or security engineers validating user environment settings.

## 📁 Scripts Included

### 1. `check_profiles.ps1` (PowerShell)
**Purpose:**  
Scans for and outputs paths or contents of PowerShell-related profile files, such as `Microsoft.PowerShell_profile.ps1`.

**Usage:**
```powershell
.\check_profiles.ps1
```

**Expected Behavior:**
- Outputs a list of profile paths for the current user.
- Indicates whether each profile file exists.
- May print contents of profiles for audit purposes (if implemented in the script).

**Platform:** Windows (PowerShell Core or Windows PowerShell)

---

### 2. `check_profiles.zsh` (Zsh)
**Purpose:**  
Lists or validates Zsh-related startup/configuration files such as `.zshrc`, `.zprofile`, and `.zlogin`.

**Usage:**
```zsh
./check_profiles.zsh
```

> Ensure the script has executable permissions:
```bash
chmod +x check_profiles.zsh
```

**Expected Behavior:**
- Identifies which Zsh configuration files exist in the user's home directory.
- Optionally dumps contents or highlights modifications (if coded to do so).

**Platform:** Unix-like systems (macOS, Linux) with Zsh shell

## ✅ Requirements

- For `check_profiles.ps1`: PowerShell 5+ or PowerShell Core
- For `check_profiles.zsh`: Zsh shell environment

## 🔒 Notes

- These scripts are for inspection only — **they make no changes** to the environment or profile files.
- Review output carefully before taking action based on findings.
