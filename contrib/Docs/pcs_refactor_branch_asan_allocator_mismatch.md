# PCS_Refactor Branch Review 28-Sept-2024

## Summary:
Issues related to memory management, overflows, and allocator mismatches in the PCS_Refactor Branch. Each identified issue includes the file, line number, and suggested action for refactoring to resolve these issues. These Issues were identified based on analysis of the current ICC profile standards (ICC.1, ICC.2), logs, and cumulative errata documentation.

[c7f457c](https://github.com/InternationalColorConsortium/DemoIccMAX/commit/e7fa1434efdcbfa26bdeeeed0d83b72f1c7f457c) contains memory allocator mismatch, overflow and other issues that should be resolved prior to Merge. See [Build Action](https://github.com/xsscx/DemoIccMAX/actions/runs/11079099338) with the revert of [6ac1cc6](https://github.com/InternationalColorConsortium/DemoIccMAX/commit/b90ac3933da99179df26351c39d8d9d706ac1cc6) and the [scan-build](https://github.com/xsscx/DemoIccMAX/actions/runs/11079099338/artifacts/1989745685) report.

#### Build Log - Allocator Warnings
```
      |                                          ^
/tmp/tmm/DemoIccMAX/IccXML/IccLibXML/IccTagXml.cpp: In member function ‘virtual bool CIccTagXmlCurve::ParseXml(xmlNode*, icConvertType, std::string&)’:
/tmp/tmm/DemoIccMAX/IccXML/IccLibXML/IccTagXml.cpp:2601:15: warning: ‘void free(void*)’ called on pointer returned from a mismatched allocation function [-Wmismatched-new-delete]
 2601 |           free(buf);
      |           ~~~~^~~~~
/tmp/tmm/DemoIccMAX/IccXML/IccLibXML/IccTagXml.cpp:2594:42: note: returned from ‘void* operator new [](std::size_t)’
 2594 |         char *buf = (char *) new char[num];
      |                                          ^
/tmp/tmm/DemoIccMAX/IccXML/IccLibXML/IccTagXml.cpp:2611:15: warning: ‘void free(void*)’ called on pointer returned from a mismatched allocation function [-Wmismatched-new-delete]
 2611 |           free(buf);
      |           ~~~~^~~~~
/tmp/tmm/DemoIccMAX/IccXML/IccLibXML/IccTagXml.cpp:2594:42: note: returned from ‘void* operator new [](std::size_t)’
 2594 |         char *buf = (char *) new char[num];
      |                                          ^
/tmp/tmm/DemoIccMAX/IccXML/IccLibXML/IccTagXml.cpp:2626:17: warning: ‘void free(void*)’ called on pointer returned from a mismatched allocation function [-Wmismatched-new-delete]
 2626 |             free(buf);
      |             ~~~~^~~~~
```

#### Revert to Build

[6ac1cc6](https://github.com/InternationalColorConsortium/DemoIccMAX/commit/b90ac3933da99179df26351c39d8d9d706ac1cc6) must be ***reverted*** to build the [PCS_Refactor](https://github.com/InternationalColorConsortium/DemoIccMAX/tree/PCS_Refactor) branch, as does master, and should be resolved prior to Merge. 

```
echo "Step 2: Cloning DemoIccMAX repository"
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git || { echo "Error: Git clone failed. Exiting."; exit 1; }
cd DemoIccMAX/ || { echo "Error: Failed to change directory to DemoIccMAX. Exiting."; exit 1; }
echo "Repository cloned and switched to DemoIccMAX directory."

echo "Step 3: Checking out PCS_Refactor branch"
git checkout PCS_Refactor || { echo "Error: Git checkout PCS_Refactor failed. Exiting."; exit 1; }
echo "PCS_Refactor branch checked out."
```

See Actions [893686](https://github.com/xsscx/DemoIccMAX/actions/runs/11078893686) and [896000](https://github.com/xsscx/DemoIccMAX/actions/runs/11078896000) for the build logs with and without the revert. See [PR94](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/94) for granular details and reproduction of these and other Issues.

### PCS_Refactor Asan Reproduction

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/pcs_revert_build_asan_report.sh)"
```

## DemoIccMAX Bug Tracker (Q4|2023-Q3|2024)

**Last Updated: 28 September 2024**

##### scan-build

| **Category**                               | **Q4 2023** | **Q2 2024** | **[PR94](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/94)** | **Commit [1c7f457c](https://github.com/InternationalColorConsortium/DemoIccMAX/commit/e7fa1434efdcbfa26bdeeeed0d83b72f1c7f457c)** | **Change** | **Comments**                                                                                                                            
|--------------------------------------------|-------------|-------------|-----------------|-----------------|------------|------------------------------------------------------------------------------------------------------------------------------------------|
| **All Bugs**                               | 113         | 118         | 110             | 110             | -8         | Overall bug count reduced in the latest report, showing improvement in the codebase.                                                     |
| **API**                                    | -           | -           | 4               | 4               | +4         | New category detecting API misuse (null passed where non-null is expected).                                                             |
| **Logic Errors**                           |             |             |                 |                 |            |                                                                                                                                          |
| Assigned value is garbage or undefined     | 2           | 1           | 1               | 1               | No change  | The assigned value garbage issue remains consistent across the last two reports.                                                         |
| Called C++ object pointer is null          | 3           | 2           | 2               | 2               | No change  | No change between Sep 2024 and the latest report, suggesting stability in handling null pointers.                                         |
| Dereference of null pointer                | 13          | 14          | 14              | 14              | No change  | Null pointer dereference issues remained the same between the last two reports.                                                          |
| Garbage return value                       | 1           | 1           | -               | -               | N/A        | No longer reported in the most recent data.                                                                                              | 
| Result of operation is garbage or undefined| 4           | 4           | -               | -               | N/A        | No longer reported in the most recent data.                                                                                              | 
| Uninitialized argument value               | 6           | 3           | 3               | 3               | No change  | Uninitialized arguments remain the same as in the last report.                                                                            |
| **Memory Errors**                          |             |             |                 |                 |            |                                                                                                                                          |
| Bad deallocator                            | 7           | 6           | 2               | 2               | -4         | Significant improvement in deallocation handling in the latest report.                                                                   |
| Double free                                | 2           | 2           | 2               | 2               | No change  | Double free issues remain consistent across all reports.                                                                                 | 
| Memory leak                                | 10          | 13          | 13              | 13              | No change  | Memory leaks persist in both Sep 2024 and the latest report, requiring attention.                                                        | 
| Use-after-free                             | 8           | 9           | 9               | 9               | No change  | No new use-after-free errors introduced in the most recent report.                                                                       | 
| Use of zero allocated                      | -           | 1           | 1               | 1               | No change  | New issue introduced in the Sep 2024 report persists in the latest data.                                                                 |
| **Unix API (Memory)**                      |             |             |                 |                 |            |                                                                                                                                          |
| Allocator sizeof operand mismatch          | 1           | 1           | 1               | 1               | No change  | No change, suggesting this edge case issue is still unresolved.                                                                          |
| **Unused Code**                            |             |             |                 |                 |            |                                                                                                                                          | 
| Dead assignment                            | 28          | 30          | 32              | 32              | +2         | Dead assignments increased slightly in the latest report.                                                                                | 
| Dead increment                             | 3           | 4           | 4               | 4               | No change  | No change between Sep 2024 and the latest report.                                                                                        | 
| Dead initialization                        | 20          | 22          | 21              | 21              | -1         | One dead initialization issue was resolved between the Sep 2024 and latest report.                                                       |
| Dead nested assignment                     | 1           | 1           | 1               | 1               | No change  | The dead nested assignment issue remains consistent across all reports.                                                                  | 

## [PR94](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/94) Unit Testing

PR94 Reproduction
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/development/contrib/UnitTest/pr94-build-asan-check.sh)"
```

For [PR94](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/94), the Unit Testing indicates that: Without addressing the allocator::deallocator issue the same Unit Test yields:

```
+ set -
+ iccFromXml CMYK-3DLUTs.xml CMYK-3DLUTs.icc
=================================================================
==4139==ERROR: AddressSanitizer: heap-buffer-overflow
```

For [PR94](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/94), the Unit Testing indicates that when the allocator::deallocator issues are resolved, the next Bug Class to address for this function are Leaks:

```
+ set -
+ ../../Build/Tools/IccFromXml/iccFromXml CMYK-3DLUTs.xml CMYK-3DLUTs.icc

=================================================================
==8574==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 120718 byte(s) in 5 object(s) allocated from:
    #0 0x7f45cc10a357 in operator new[](unsigned long) ../../../../src/libsanitizer/asan/asan_new_delete.cpp:102
    #1 0x7f45cba8d2ff in CIccSinglSampledeCurveXml::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/sep15/PatchIccMAX-development/IccXML/IccLibXML/IccMpeXml.cpp:687
    #2 0x7f45cba9a4ba in ParseXmlCurve /home/xss/tmp/sep15/PatchIccMAX-development/IccXML/IccLibXML/IccMpeXml.cpp:1101
    #3 0x7f45cba9b554 in CIccMpeXmlCurveSet::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/sep15/PatchIccMAX-development/IccXML/IccLibXML/IccMpeXml.cpp:1159
    #4 0x7f45cbad00ec in CIccMpeXmlCalculator::ParseImport(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/sep15/PatchIccMAX-development/IccXML/IccLibXML/IccMpeXml.cpp:2577
    #5 0x7f45cbae5397 in CIccMpeXmlCalculator::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/sep15/PatchIccMAX-development/IccXML/IccLibXML/IccMpeXml.cpp:3094
    #6 0x7f45cbbc20ee in CIccTagXmlMultiProcessElement::ParseElement(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/sep15/PatchIccMAX-development/IccXML/IccLibXML/IccTagXml.cpp:4034
    #7 0x7f45cbbc4676 in CIccTagXmlMultiProcessElement::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/sep15/PatchIccMAX-development/IccXML/IccLibXML/IccTagXml.cpp:4094
    #8 0x7f45cbb4b26a in CIccProfileXml::ParseTag(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/sep15/PatchIccMAX-development/IccXML/IccLibXML/IccProfileXml.cpp:711
    #9 0x7f45cbb4f6b1 in CIccProfileXml::ParseXml(_xmlNode*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&) /home/xss/tmp/sep15/PatchIccMAX-development/IccXML/IccLibXML/IccProfileXml.cpp:820
    #10 0x7f45cbb4fb72 in CIccProfileXml::LoadXml(char const*, char const*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >*) /home/xss/tmp/sep15/PatchIccMAX-development/IccXML/IccLibXML/IccProfileXml.cpp:877
    #11 0x5655332cb5c7 in main /home/xss/tmp/sep15/PatchIccMAX-development/IccXML/CmdLine/IccFromXml/IccFromXml.cpp:68
    #12 0x7f45c849dd8f in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
...
```
