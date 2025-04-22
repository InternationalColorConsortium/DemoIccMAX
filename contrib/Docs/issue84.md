# PR for CIccTagSpectralViewingConditions + CIccProfile
PR will be based on Commit: https://github.com/InternationalColorConsortium/DemoIccMAX/commit/f891074a0f1c9d61a3dfa53749265f8c14ed4ee6

##  Memory Management Issues
Description: The code in CIccTagSpectralViewingConditions and CIccProfile exhibits improper memory management practices. 
There is a mismatch in allocation and deallocation methods for dynamically allocated memory. 
This leads to the detection of alloc-dealloc-mismatch errors by AddressSanitizer.

## PoC
```
~/tmp/git/PatchMAX-f891074a0f1c9d61a3dfa53749265f8c14ed4ee6/Testing/Calc$ ../iccFromXml CameraModel.xml CameraModel.icc
...
ERROR: AddressSanitizer: alloc-dealloc-mismatch (malloc vs operator delete []) on 0x614000000a40
    #0 0x7f0eb134ae57 in operator delete[](void*) ../../../../src/libsanitizer/asan/asan_new_delete.cpp:163
    #1 0x7f0eaf6ef9e5 in CIccTagSpectralViewingConditions::~CIccTagSpectralViewingConditions() /home/xss/tmp/git/PatchMAX-f891074a0f1c9d61a3dfa53749265f8c14ed4ee6/IccProfLib/IccTagBasic.cpp:10908
    #2 0x7f0eb0e3b006 in CIccTagXmlSpectralViewingConditions::~CIccTagXmlSpectralViewingConditions() (/home/xss/tmp/git/PatchMAX-f891074a0f1c9d61a3dfa53749265f8c14ed4ee6/Build/IccXML/libIccXML2.so.2+0x4e1006)
    #3 0x7f0eb0e3b037 in CIccTagXmlSpectralViewingConditions::~CIccTagXmlSpectralViewingConditions() (/home/xss/tmp/git/PatchMAX-f891074a0f1c9d61a3dfa53749265f8c14ed4ee6/Build/IccXML/libIccXML2.so.2+0x4e1037)
    #4 0x7f0eaf58115e in CIccProfile::Cleanup() /home/xss/tmp/git/PatchMAX-f891074a0f1c9d61a3dfa53749265f8c14ed4ee6/IccProfLib/IccProfile.cpp:263
    #5 0x7f0eaf58019e in CIccProfile::~CIccProfile() /home/xss/tmp/git/PatchMAX-f891074a0f1c9d61a3dfa53749265f8c14ed4ee6/IccProfLib/IccProfile.cpp:239
    #6 0x56030e3bad89 in CIccProfileXml::~CIccProfileXml() /home/xss/tmp/git/PatchMAX-f891074a0f1c9d61a3dfa53749265f8c14ed4ee6/Build/Cmake/../../IccXML/IccLibXML/IccProfileXml.h:82
    #7 0x56030e3b9f99 in main /home/xss/tmp/git/PatchMAX-f891074a0f1c9d61a3dfa53749265f8c14ed4ee6/IccXML/CmdLine/IccFromXml/IccFromXml.cpp:113
    #8 0x7f0ead6ead8f in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
    #9 0x7f0ead6eae3f in __libc_start_main_impl ../csu/libc-start.c:392
    #10 0x56030e3b88c4 in _start (/home/xss/tmp/git/PatchMAX-f891074a0f1c9d61a3dfa53749265f8c14ed4ee6/Build/Tools/IccFromXml/iccFromXml+0x88c4)
```

### Issue 1 
File: IccTagBasic.cpp
Line: 10908
Incorrect use of delete[] for memory allocated using malloc.
CIccProfile Cleanup Function:

#### malloc()
The code from [IccTagXml.cpp#L2105](https://github.com/InternationalColorConsortium/DemoIccMAX/blob/master/IccXML/IccLibXML/IccTagXml.cpp#L2105) shows the allocation of m_observer using malloc:

```
if (pChild->children && pChild->children->content) {
    CIccFloatArray vals;
    vals.ParseTextArray((icChar*)pChild->children->content);
    if (vals.GetSize() != m_observerRange.steps * 3)
        return false;
    m_observer = (icFloatNumber*)malloc(m_observerRange.steps * 3 * sizeof(icFloatNumber));
    if (!m_observer)
        return false;
    icFloatNumber *pBuf = vals.GetBuf();
    memcpy(m_observer, pBuf, m_observerRange.steps * 3 * sizeof(icFloatNumber));
}
```
### Corrected Destructor
Given that m_observer is allocated using malloc, it should be deallocated using free in the destructor.

Here is the corrected destructor code:

### Refactored Code
```
/**
 ****************************************************************************
 * Name: CIccTagSpectralViewingConditions::~CIccTagSpectralViewingConditions
 * 
 * Purpose: Destructor
 * 
 *****************************************************************************
 */
CIccTagSpectralViewingConditions::~CIccTagSpectralViewingConditions()
{
  if (m_observer)
    free(m_observer);  // Correct deallocation for malloc

  if (m_illuminant)
    free(m_illuminant);  // Correct deallocation for malloc
}
```

#### History

The initial [Commit](https://github.com/xsscx/PatchIccMAX/commit/1f0a9dd2863f498fa333ddd3a93e998f5fcf9352) is from 2015. Address Sanitizer reported a alloc-dealloc-mismatch (malloc vs operator delete []) when run on Ubuntu and macOS in 2024.

##### malloc () Guidelines

Allocation Functions:

- malloc – for dynamic memory allocation.
- calloc – for zero-initialized dynamic memory allocation.
- new – for object creation that also allocates memory.

Deallocation Functions:

- free – for deallocating memory allocated with malloc or calloc.
- delete – for deallocating memory allocated with new.
- delete[] – for deallocating memory allocated with new[].

Other Functions:

- realloc – used to resize dynamically allocated memory.
- memcpy or memmove – often appear near dynamic memory handling for copying contents from one block of memory to another.
- strdup – dynamically allocates memory to copy a string, typically requires free() for deallocation.

## Issue 2
File: IccProfile.cpp
Line: 263
Improper handling of dynamically allocated memory using manual delete and free operations.

### Refactored Code
```
/**
 ****************************************************************************
 * Name: CIccProfile::Cleanup
 * 
 * Purpose: Detach from a pending IO object
 *****************************************************************************
 */
void CIccProfile::Cleanup()
{
  // Delete the attached IO object if it exists
  if (m_pAttachIO) {
    delete m_pAttachIO;
    m_pAttachIO = nullptr;
  }

  // Iterate through the tag values and delete them if they are not null
  for (auto &tagVal : *m_TagVals) {
    if (tagVal.ptr != nullptr) {
      delete tagVal.ptr;
      tagVal.ptr = nullptr;
    }
  }

  // Clear the tag lists
  m_Tags->clear();
  m_TagVals->clear();

  // Reset the header to zero
  std::memset(&m_Header, 0, sizeof(m_Header));
}

```

### Explanation of Changes

Nullptr Assignment: Replaced NULL with nullptr for better type safety and clarity. After deleting pointers, set them to nullptr to avoid dangling pointers.

Range-based Loop: Replaced the manual iterator loop with a range-based loop for better readability and to reduce the potential for errors.

Clear Lists: Clear the tag lists using the clear method of the standard library containers.

Memset: Used std::memset instead of memset to adhere to C++ standards.

Memory Allocation Consistency: Ensure that the memory for m_pAttachIO and tagVal.ptr is consistently allocated with new if they are deleted with delete.

## Other Patches
```
 git diff IccProfLib/IccCmm.cpp.unpatched IccProfLib/IccCmm.cpp
diff --git a/IccProfLib/IccCmm.cpp.unpatched b/IccProfLib/IccCmm.cpp
index 32582e2..abe7e2f 100644
--- a/IccProfLib/IccCmm.cpp.unpatched
+++ b/IccProfLib/IccCmm.cpp
@@ -1937,21 +1937,21 @@ CIccApplyPcsXform::CIccApplyPcsXform(CIccXform *pXform) : CIccApplyXform(pXform)
 */
 CIccApplyPcsXform::~CIccApplyPcsXform()
 {
-
-  if (m_list) {
-    CIccApplyPcsStepList::iterator i;
-    for (i=m_list->begin(); i!=m_list->end(); i++) {
-      if (i->ptr)
-        delete i->ptr;
+    if (m_list) {
+        for (auto& step : *m_list) {
+            if (step.ptr) {
+                delete step.ptr; // Properly deallocate the object
+                step.ptr = nullptr; // Nullify pointer after deletion for safety
+            }
+        }
+        delete m_list;
+        m_list = nullptr; // Nullify pointer after deletion for safety
     }

-    delete m_list;
-  }
-
-  if (m_temp1)
-    delete m_temp1;
-  if (m_temp2)
-    delete m_temp2;
+    delete[] m_temp1; // Use delete[] to match array allocation
+    delete[] m_temp2; // Use delete[] to match array allocation
+    m_temp1 = nullptr; // Nullify pointer after deletion for safety
+    m_temp2 = nullptr; // Nullify pointer after deletion for safety
 }

 /**
@@ -3891,30 +3891,30 @@ CIccPcsStep *CIccPcsStepXYZToLab2::concat(CIccPcsStep *pNext) const
 /**
 **************************************************************************
 * Name: CIccPcsStepOffset::CIccPcsStepOffset
-*
-* Purpose:
-*  Constructor
+*
+* Purpose:
+*  Constructor - Initializes the offset with the given number of channels.
 **************************************************************************
 */
 CIccPcsStepOffset::CIccPcsStepOffset(icUInt16Number nChannels)
 {
-  m_nChannels = nChannels;
-  m_vals = new icFloatNumber[nChannels];
+    m_nChannels = nChannels;
+    m_vals = new icFloatNumber[nChannels]; // Allocate an array using new[]
 }


 /**
 **************************************************************************
-* Name: CIccPcsStepOffset::CIccPcsStepOffset
-*
-* Purpose:
-*  Destructor
+* Name: CIccPcsStepOffset::~CIccPcsStepOffset
+*
+* Purpose:
+*  Destructor - Cleans up allocated resources.
 **************************************************************************
 */
 CIccPcsStepOffset::~CIccPcsStepOffset()
 {
-  if (m_vals)
-    delete m_vals;
+    delete[] m_vals; // Use delete[] to properly deallocate the array
+    m_vals = nullptr; // Nullify the pointer for safety
 }


@@ -4030,30 +4030,30 @@ bool CIccPcsStepOffset::isIdentity() const
 /**
 **************************************************************************
 * Name: CIccPcsStepScale::CIccPcsStepScale
-*
-* Purpose:
-*  Constructor
+*
+* Purpose:
+*  Constructor - Initializes the scale with the given number of channels.
 **************************************************************************
 */
 CIccPcsStepScale::CIccPcsStepScale(icUInt16Number nChannels)
 {
-  m_nChannels = nChannels;
-  m_vals = new icFloatNumber[nChannels];
+    m_nChannels = nChannels;
+    m_vals = new icFloatNumber[nChannels]; // Allocate an array using new[]
 }


 /**
 **************************************************************************
 * Name: CIccPcsStepScale::~CIccPcsStepScale
-*
-* Purpose:
-*  Destructor
+*
+* Purpose:
+*  Destructor - Cleans up allocated resources.
 **************************************************************************
 */
 CIccPcsStepScale::~CIccPcsStepScale()
 {
-  if (m_vals)
-    delete m_vals;
+    delete[] m_vals; // Use delete[] to properly deallocate the array
+    m_vals = nullptr; // Nullify the pointer for safety
 }

 /**
```

### Common Weakness Enumeration (CWE)
CWE-762: Mismatched Memory Management Routines
CWE-401: Improper Release of Memory Before Removing Last Reference ('Memory Leak')

### Exploit Value

Crashes occurring in destructors due to zero-page dereferences are typically considered benign and are often just null pointer dereferences without significant security implications. However, crashes occurring in constructors are more concerning as they may indicate a product defect or a security vulnerability.


#### Exploitable if:

Crash on write instruction
Crash executing invalid address
Crash calling an invalid address
Illegal instruction exception
Abort due to fstack protector, FORTIFYSOURCE, heap corruption detected
Stack trace of crashing thread contains certain functions such as malloc, free, szone_error, objc_MsgSend, etc.

#### Not exploitable if:

Divide by zero exception
Stack grows too large due to recursion
Null dereference (read or write)
Other abort
Crash on read instruction


## Caveat
A reference implementation __is not__ production code. In general, any Code being used in production should undergo additional security reviews and product testing.