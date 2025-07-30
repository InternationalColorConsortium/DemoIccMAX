RefIccMAX CMM Read Me

OVERVIEW
The RefIccMAX CMM (Color Management Module) provides methods to transform colors using industry standard ICC (International Color Consortium) color profiles. 

The RefIccMAX CMM can be used by applications that support selection of third-party CMMs. It can also be integrated into workflows using operating system-level Color Management Systems to access the RefIccMAX CMM or using custom software to access the RefIccMAX CMM APIs directly.

LICENSE
The ICC Software License, Version 0.2

Copyright (c) 2003-2015 The International Color Consortium. All rights 
reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer. 

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.

3. In the absence of prior written permission, the names "ICC" and "The
   International Color Consortium" must not be used to imply that the
   ICC organization endorses or promotes products derived from this
   software.


THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO EVENT SHALL THE INTERNATIONAL COLOR CONSORTIUM OR
ITS CONTRIBUTING MEMBERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.
====================================================================

This software consists of voluntary contributions made by many
individuals on behalf of the The International Color Consortium. 

Membership in the ICC is encouraged when this software is used for
commercial purposes. 
  
For more information on The International Color Consortium, please
see <http://www.color.org/>.

GETTING STARTED
Follow these steps to get started with the RefIccMAX CMM:
1. Familiarize yourself with the RefIccMAX CMM by reading the Overview above.
2. Download and install the RefIccMAX CMM. 
3. Test compatible applications.
4. Ask questions and share your feedback in the ICC discussion forum.

INSTALLING THE REFICCMAX CMM
To install the RefIccMAX CMM on Windows

1. Create a directory RefIccMAX in Program Files and copy the file RefIccMAXCmm.dll to Program Files\RefIccMAX.
2. In order to make the RefIccMAX CMM available to applications, you will need to add a registry value.  This is described in the remaining steps.

Disclaimer: This procedure involves editing the Windows registry which contains critical system and application information. Make sure to back up the registry before editing it. For more information about the registry, see the Windows documentation, or contact Microsoft.

3. Choose Start > Run.
4. In the Open box, type regedit. Click OK to open the Registry Editor.
5. Navigate to the HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\ICM\ICMatchers key in the left-hand pane of Registry Editor.
a. If the ICMatchers key does not exist, then create it by navigating to the HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\ICM key in the left-hand pane.
b. Under the Edit menu, select New > Key.
c. Give the new Key the name ICMatchers.
6. Under the Edit menu, select New > String Value.
7. Give the new String Value the name SICC.
8. Double-click the SICC name. In the Value data: field, type 
C:\Program Files\RefIccMAX\RefIccMAXCmm.dll 
(make sure the C: drive letter matches the hard drive where you installed the RefIccMAXCmm.dll file).
9. Click the OK button.
10. Go to File > Exit to close the Registry Editor.


