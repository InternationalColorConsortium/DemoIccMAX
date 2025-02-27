# ICC Profile to TXT Script

## 📌 Overview
This **Zsh script** automates the process of analyzing ICC color profiles in the **current working directory and all subdirectories**.  
It scans for files with known **ICC profile extensions** (`.icc`, `.icm`, `.iccp`, `.icf`, `.profile`, etc.), performs a **hex dump using `xxd`**,  
extracts metadata using `dd`, and **saves the results in a designated output directory** (`icc-xxd/`).  
All operations are logged in a **consolidated report** for easy tracking.

---

## 🚀 Features
✅ **Recursively scans** the current working directory and all subdirectories for ICC profiles  
✅ **Supports multiple ICC profile extensions**:  
   - `.icc`, `.icm`, `.iccp`, `.icf`, `.profile`, `.icd`, `.icr`, `.icb`, `.iic`  
✅ **Performs detailed hex dumps using `xxd`**  
✅ **Extracts key ICC metadata** (Magic Bytes, Profile Version, Device Class, Color Space, etc.)  
✅ **Saves results in `icc-xxd/`** with a structured filename format  
✅ **Generates a full log report (`consolidated_icc_report.txt`)**  

---

## 🔧 Requirements
- **Zsh** (default on macOS, available on Linux)
- **`xxd` utility** (included in `vim-common` on most Unix systems)
- **`dd` command** (default in all Unix/Linux-based systems)

---

## 🛠 Usage

```
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/xnu/contrib/HelperScripts/icc2txt.zsh)"
```

The script will process **all ICC profiles in the current directory and its subdirectories**.  
Each profile's hex dump will be saved in the `icc-xxd/` directory, and logs will be stored in `consolidated_icc_report.txt`.

---

## 📂 Output Structure

### **Hex Dump Output**
The hex dump files are saved in the format:
```
icc-xxd/icc-profile-name-xxd-YYYY-MM-DD_HH-MM-SS.txt
```
Example:
```
icc-xxd/sRGB.icc-xxd-2025-02-16_12-30-45.txt
```

### **Extracted Metadata**
Each ICC file also has a separate **metadata extraction file**, containing:
```
Magic Bytes
Profile Size
Profile Version
Device Class
Color Space
Preferred CMM
Reserved Bytes
```
Example metadata output:
```
icc-xxd/sRGB.icc-metadata-2025-02-16_12-30-45.txt
```

### **Logging**
The script logs each processed file and its corresponding output in:
```
consolidated_icc_report.txt
```
Example:
```
[2025-02-16_12-30-45] Starting ICC profile xxd analysis
[2025-02-16_12-30-46] Processed: ./sRGB.icc -> icc-xxd/sRGB.icc-metadata-2025-02-16_12-30-46.txt (Metadata)
[2025-02-16_12-30-47] Processed: ./sRGB.icc -> icc-xxd/sRGB.icc-xxd-2025-02-16_12-30-47.txt (Full Dump)
[2025-02-16_12-30-48] ICC profile xxd analysis completed
```

---

## ❓ Troubleshooting
- **Ensure `xxd` is installed**  
  - Run `xxd -h` to check  
  - If missing, install it:
    - **macOS**: `brew install vim`
    - **Ubuntu/Debian**: `sudo apt install xxd`
    - **Fedora**: `sudo dnf install vim-common`
    - **Arch Linux**: `sudo pacman -S vim`

- **Ensure the script is being run inside a directory with ICC profiles**  
  - Use: `find . -type f \( -iname "*.icc" -o -iname "*.icm" -o -iname "*.iccp" -o -iname "*.icf" \)`

---
