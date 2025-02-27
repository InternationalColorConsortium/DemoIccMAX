# IccMAX Dump Profile

## 📜 Description
**IccDumpProfile Helper Script**  
This PowerShell script automates the process of dumping ICC profile details using `IccDumpProfile_d.exe`.  
It recursively scans the project directory for `.icc` files and outputs their processed dumps into a structured output folder.

---

## 🔍 How It Works
- **Scans** the project directory (`$Project_Root/Testing/`) for `.icc` files.
- **Excludes** the output directory (`$Project_Root/Testing/output/iccdumpprofile`).
- **Runs** `IccDumpProfile_d.exe` on each `.icc` file.
- **Saves output** as `.txt` files in a structured format.

---

## 📥 Installation & Execution
### **Run Directly via PowerShell**
```powershell
iex (iwr -Uri "https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/HelperScripts/iccdumpprofile.ps1").Content
