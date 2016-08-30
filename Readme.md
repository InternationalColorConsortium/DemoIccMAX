<h1 style="text-align: center;"><img style="width: 256px; height: 251px;" alt="" src="ReadMeFiles/RefIccMAX-Logo.png"><br></h1><h1 style="text-align: center;">RefIccMAX</h1><h2>Introduction</h2>

<p class="MsoNormal">The RefIccMAX project provides an open source set of
libraries and tools that allow for the interaction, manipulation, and
application of iccMAX based color management profiles based on the iccMAX
profile specification (<a href="http://www.color.org/iccmax.xalter">http://www.color.org/iccmax.xalter</a>)
in addition to legacy ICC profiles defined by earlier ICC profile
specifications (<a href="http://www.color.org/icc_specs2.xalter">http://www.color.org/icc_specs2.xalter</a>).</p>

<p class="MsoNormal">iccMAX is not intended as a replacement for legacy ICC.1
based profiles, the existing architecture, but as an extension or alternative
where requirements cannot be fully met by ICC.1.<span style="">&nbsp; </span>Some of the areas covered by iccMAX include:
Multi-spectral, Medical Imaging, Image Capture/Digital Photography, Package
Printing, Color Management on Internet, Fine Art, and Color Information
Archiving. <span style="">&nbsp;</span>A more fuller description of
capabilities and functionality can be found on the ICC web site (<a href="http://www.color.org/iccmax.xalter">http://www.color.org/iccmax.xalter</a>).</p>

<p class="MsoNormal">Note: The code in RefIccMAX was initially based on the
SampleICC (<a href="https://sourceforge.net/projects/sampleicc/">https://sourceforge.net/projects/sampleicc/</a>)
and IccXML (<a href="https://sourceforge.net/projects/iccxml/">https://sourceforge.net/projects/iccxml/</a>)
open source projects, and therefore concepts, files and data structures within
RefIccMAX<span style="">&nbsp; </span>may have similarities (as well
as various differences) to those in the SampleICC and IccXML projects. </p>

<h2>Overview</h2>

<p class="MsoNormal">Within the RefIccMAX project are several libraries and tools
as follows:</p>

<p class="MsoListParagraphCxSpFirst" style="text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: Symbol;"><span style="">·<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><!--[endif]-->Libraries that allow applications to interact
with iccMAX profiles</p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;
</span></span></span><!--[endif]-->IccProfLib &#8211; The RefIccMAX IccProfLib project
represents an open source / cross platform &#8220;reference implementation&#8221; of a C++
library for reading/writing/applying/manipulating iccMAX color profiles defined
by the iccMAX profile specification (<a href="http://www.color.org/iccmax.xalter">http://www.color.org/iccmax.xalter</a>).<span style="">&nbsp; </span>Class and object interaction documentation
for IccProfLib can be found at ().</p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.5in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: Wingdings;"><span style="">§<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;
</span></span></span><!--[endif]-->Note 1: There are no intentional discrepancies
between the RefIccMAX implementation and the iccMAX specification.<span style="">&nbsp; </span>If any should occur then this should be
brought to the attention of and resolved by the RefIccMAX project team within
the Architecture Working Group of the ICC organization. </p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.5in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: Wingdings;"><span style="">§<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;
</span></span></span><!--[endif]-->Note 2: Though SampleICC provides a sample
implementation, it does NOT represent a &#8220;reference implementation&#8221; of ICC.1 color management.<span style="">&nbsp; </span></p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;
</span></span></span><!--[endif]-->IccLibXML &#8211; The RefIccMax IccLibXML project
contains a parallel C++ extension library (IccLibXML) which provides the
ability to interact with the objects defined by IccProfLib using an XML
representation thus allowing iccMAX profiles to be expressed as or created from
text based XML files.<span style="">&nbsp; </span>The IccLibXML
project has a dependencies on the libxml<span style="">&nbsp;
</span>(<a href="http://www.xmlsoft.org/">http://www.xmlsoft.org/</a>) project
(which also has a dependency on iconv&nbsp;which must be separately installed
under windows platforms).<span style="">&nbsp; </span></p>

<p class="MsoListParagraphCxSpMiddle" style="text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: Symbol;"><span style="">·<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span></span><!--[endif]-->Tools based upon these libraries that allow for
iccMAX profiles to be investigated, created, manipulated, and applied.<span style="">&nbsp; </span>For command line arguments running the
application without any arguments will display help information about command
line options.</p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;
</span></span></span><!--[endif]-->IccToXML is a cross platform command line tool
that allows both legacy ICC and iccMAX profiles to be expressed using an XML
representation.<span style="">&nbsp; </span>This allows for profiles
to be converted to a textual representation that can be directly edited using a
text editor and then converted back to ICC/iccMAX profile formats using
IccFromXML. </p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.5in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: Wingdings;"><span style="">§<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;
</span></span></span><!--[endif]-->This tool is dependent upon the IccLibXML
project as well as libXML and iconv.</p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;
</span></span></span><!--[endif]-->IccFromXML is a cross platform command line tool
that allows both legacy ICC and iccMAX profiles to be created from the same XML
representation provided by IccToXML.<span style="">&nbsp; </span>A
schema for iccXML files is forthcoming but can be determined using the
FromXML() and ToXML() member functions defined in IccLibXML.<span style="">&nbsp; </span>The IccFromXML tool provides a simple direct
method to create and manipulate iccMAX based profiles.<span style="">&nbsp; </span></p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.5in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: Wingdings;"><span style="">§<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;
</span></span></span><!--[endif]-->This tool is dependent upon the IccLibXML
project as well as libXML and iconv.</p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;
</span></span></span><!--[endif]-->IccApplyNamedCmm is a cross platform command
line tool that allows a sequence of legacy ICC and/or iccMAX profiles to be applied
to colors defined in a text based input profile outputting the results to the
console, and can be redirected to a output text file.<span style="">&nbsp; </span>Example source text files can be found in
Testing/ApplyDataFiles.<span style="">&nbsp; </span>The
IccApplyNamedCmm application provides a basis for testing various features of
iccMAX.</p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;
</span></span></span><!--[endif]-->IccApplyProfiles is a cross platform command
line tool that allows a sequence of legacy and/or iccMAX profiles to a source
TIFF image resulting in a destination TIFF image.<span style="">&nbsp; </span>The final destination profile can optionally
be embedded in the resulting TIFF image.</p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.5in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: Wingdings;"><span style="">§<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;
</span></span></span><!--[endif]-->This tool has a dependency on the LibTIFF (<a href="http://www.libtiff.org/">http://www.libtiff.org/</a>) project.</p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;
</span></span></span><!--[endif]-->IccDumpProfile is a cross platform command line
tool that allows information from a legacy ICC and or iccMAX profile to be
output to the console. </p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;
</span></span></span><!--[endif]-->IccRoundTrip is a cross platform command line
tool that allows round trip colorimetric processing characteristics of
rendering intent of a profile to be evaluated.<span style="">&nbsp;
</span>(Evaluation goes from device values to PCS to establish intial PCS
values.<span style="">&nbsp; </span>These are then coverted to
device values and then PCS values for the first round trip.<span style="">&nbsp; </span>Second round trip comparison then converts
the second PCS values to device values to PCS values for campison to the second
PCS values.</p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;
</span></span></span><!--[endif]-->IccSpecSepToTiff is a cross platform command
line tool that combines separate individual TIFF images associated with
different spectral wavelengths into a single multi-sample per pixel TIFF
image.<span style="">&nbsp; </span>An iccMAX based profile can
optionally be embedded in the resulting TIFF image.<span style="">&nbsp; </span></p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.5in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: Wingdings;"><span style="">§<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;
</span></span></span><!--[endif]-->This tool has a dependency on the LibTIFF (<a href="http://www.libtiff.org/">http://www.libtiff.org/</a>) project.</p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;
</span></span></span><!--[endif]-->IccTiffDump is a cross platform command line
tool that outputs header and embedded ICC profile information about a TIFF
image to the console.<span style="">&nbsp; </span>This tool has a
dependency on the LibTIFF project.</p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.5in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: Wingdings;"><span style="">§<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;
</span></span></span><!--[endif]-->This tool has a dependency on the LibTIFF (<a href="http://www.libtiff.org/">http://www.libtiff.org/</a>) project.</p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;
</span></span></span><!--[endif]-->RefIccLabsCMM provides a MacOS-X based Color
Management Module that can be used within the ColorSync environment.<span style="">&nbsp; </span></p>

<p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.5in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: Wingdings;"><span style="">§<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;
</span></span></span><!--[endif]-->Note: Many features of iccMAX based profiles are
not accessable due to the limitation in support for only legacy ICC concepts
within ColorSync.</p>

<p class="MsoListParagraphCxSpLast" style="margin-left: 1in; text-indent: -0.25in;"><!--[if !supportLists]--><span style="font-family: &quot;Courier New&quot;;"><span style="">o<span style="font-family: &quot;Times New Roman&quot;; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp;&nbsp;
</span></span></span><!--[endif]-->wxProfileDump provies a wxWidgets based (<a href="https://www.wxwidgets.org/">https://www.wxwidgets.org/</a>) GUI based
legacy ICC and iccMAX profile inspector tool.<span style="">&nbsp;
</span>The code for this tool is based on wxWidgets 2.x, and is therefore
dependent on this version of wxWidgets.<span style="">&nbsp;
</span>At present only Windows based testing has been performed on this
(though wxWidgets is a cross-platform development environment).<span style="">&nbsp; </span>A development effort to port this tool to the
cross-platform QT development environment is greatly needed.</p>

<h2>Example iccMAX Profiles</h2>

<p class="MsoNormal">XML files are provided that can be used to create example iccMAX
profiles. <span style="">&nbsp;</span>The CreateAllProfiles.bat file
uses the iccFromXML tool to create ICC profiles for eache of these XML files.<span style="">&nbsp; </span>The XML files can be found in the following
folders: </p>

<h3>Calc</h3>

<p class="MsoNormal">This folder contains profiles that demonstrate color modeling
using the Calculator MultiProcessElement.<span style="">&nbsp;
</span>The srgbCalcTest profile exercises all specified calculator operations.</p>

<h3>Display</h3>

<p class="MsoNormal">This folder contains profiles that demonstrate spectral
modeling of display profiles allowing for late binding of the observer using
MultiProcessElements that are transformed at startup to colorimetry for the
desired observer.</p>

<h3>Encoding</h3>

<p class="MsoNormal">This folder contains 3 channel encoding class profiles.<span style="">&nbsp; </span>Both "name only" profiles as well
as fully specified profiles are present.</p>

<h3>Named</h3>

<p class="MsoNormal">This folder contains named color profiles showcasing
features such as tints, spectral reflectance, and fluorescence (with and with
out sparse notation).</p>

<h3>PCC</h3>

<p class="MsoNormal">This folder contains various profiles that can be used to
define Profile Connection Conditions (PCC).<span style="">&nbsp;
</span>All profiles are abstract profiles that<span style="">&nbsp;
</span>perform no operation to PCS values.<span style="">&nbsp;
</span>However, all profiles contain fully defined PCC tags that provide
information that can be used to define rendering for various observers and
illuminants.<span style="">&nbsp; </span>Profiles that utilize both
absolute colorimetry as well as Material Adjusted colorimetry are present.</p>

<h3>SpecRef</h3>

<p class="MsoNormal">This folder contains various profiles that convert data to/from/betweteen<span style=""> a </span>spectral reflectance PCS.<span style="">&nbsp; </span>The
argbRef (AdobeRGB) and srgbRef (sRGB) convert
RGB values to/from spectral reflectance. &nbsp;RefDecC, RefDecH, and
RefIncW are abstract spectral reflectance profiles that modify
"chroma", "hue", and "lightness" of spectral reflectance values in a
spectral reflectance PCS. &nbsp;The argbRef, srgbRef, RefDecC, RefDecH,
RefIncW profiles all estimate and/or manipulate spectral reflectance
using&nbsp;Wpt based spectral estimation
(see chapter 7 of <a href="http://scholarworks.rit.edu/theses/8789/">http://scholarworks.rit.edu/theses/8789/</a> ).<span style="">&nbsp; Additionally, e</span>xamples of 6 channel abridged spectral
encoding is provided.</p>

<h2>Project Build Considerations</h2>

<h3>Windows</h3>

<p class="MsoNormal">The project solution BuildAll.sln file for the Visual Studio
development IDE can be found in the ./Build/MSVC folder.<span style="">&nbsp; </span>This references additional .vcproj files for
the various libraries and applications provided by RefIccMAX.<span style="">&nbsp; </span>Projects without any further dependencies
should build and link correctly.<span style="">&nbsp; </span>Both 32
and 64bit compile options are supported.<span style="">&nbsp;&nbsp;&nbsp;
</span>Some of the projects have further dependencies on third party libraries
requiring that the SDK libraries are installed, and some system environment
variables need to be set to correctly reference the include files and
libraries.<span style="">&nbsp; </span>(Note: Projects with
additional dependencies may not correctly build if these libraries and
environment variable are not set up before running Visual Studio).</p>

<p class="MsoNormal">The dependency on libxml2 and iconv by the IccLibXML library
as well as the IccToXML and IccFromXML applications requires these SDK&#8217;s are
accessible, and are referenced using the system environment variables LIBXML
and ICONV.<span style="">&nbsp;&nbsp; </span>64-bit versions of these
SDK&#8217;s can be found on the gnome website (<a href="http://ftp.gnome.org/pub/GNOME/binaries/win64/dependencies/">http://ftp.gnome.org/pub/GNOME/binaries/win64/dependencies/</a>).
For example:</p>

<p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal;">ICONV=C:\DevLibs\iconv\iconv-1.9.2</p>

<p class="MsoNormal">LIBXML2=C:\DevLibs\libxml2\libxml2-2.7.8</p>

<p class="MsoNormal">The dependency on libtiff by the IccApplyProfiles,
IccSpecSepToTiff, and IccTiffDump tools requires that the libtiff SDK is
accessible, and is referenced using the system environment variables
LIBTIFF_DLIB (debug library to use), LIBTIFF_INCLUDE, LIBTIFF_LIB (release
library to use), and LIBTIFF_LIBDIR.<span style="">&nbsp; </span>For
example:</p>

<p class="MsoNormal" style="margin-bottom: 0.0001pt;">LIBTIFF_DLIB=libtiff.lib</p>

<p class="MsoNormal" style="margin-bottom: 0.0001pt;">LIBTIFF_INCLUDE=C:\DevLibs\libtiff\tiff-4.0.3\libtiff</p>

<p class="MsoNormal" style="margin-bottom: 0.0001pt;">LIBTIFF_LIB=libtiff.lib</p>

<p class="MsoNormal">LIBTIFF_LIBDIR=C:\DevLibs\libtiff\tiff-4.0.3\libtiff</p>

<p class="MsoNormal">The dependency on wxWidgets by the wxProfileDump tool
requires that the wxWidgets SDK is accessible,<span style="">&nbsp;
</span>and is reference using the system environment variables WXWIN and WXVER.
For example:</p>

<p class="MsoNormal" style="margin-bottom: 0.0001pt;">WXWIN=C:\DevLibs\WXWidgets\wxWidgets-2.8.11</p>

<p class="MsoNormal">WXVER=28</p><p class="MsoNormal">When the
ICC_USE_EIGEN_SOLVER is defined in IccProfLibConf.h then the Calc
element solv operator will be implementd using the Eigen math C++
template library (<a href="http://eigen.tuxfamily.org/index.php?title=Main_Page">http://eigen.tuxfamily.org/index.php?title=Main_Page</a>), and is referenced using the system environeent variable EIGEN. &nbsp;Fore example:</p>EIGEN=C:\DevLibs\eigen\eigen-3.2.8<h3>MacOS-X</h3>

<p class="MsoNormal">XCODE projects can be found in each of the library
and project folders that are presently supported for building on the
MacOS-X platform. The file Build/XCode/BuildAll.sh contains a bash Terminal script that can be used to build all of the XCODE projects. &nbsp;</p><p class="MsoNormal">Header
files and&nbsp;binaries for the libtiff and libxml libraries&nbsp;need
to be manually installed before the BuildAll.sh script is executed.
&nbsp;The libtiff header files need to be placed in the
Build/XCode/libtiff folder (specified by the LibTifSetup.txt file in
this folder). &nbsp;The libxml header files need to be placed in the
Build/XCode/libxml folder (specified by the LibXmlSetup.txt file in
this folder). &nbsp;<span style=""></span>(Note: Projects with
additional dependencies may not correctly build if these folders not set up before running the BuildAll.sh script).</p><p class="MsoNormal">The
BuildAll.sh script file will make a copy of the libIccProfLib.a and
libIccXML.a library binaries into the Build/XCode/lib folder. &nbsp;The
libraries in Build/XCode/Lib are then referenced by the rest of the
projects in RefIccMAX. &nbsp;Executables for the various tools will be
placed into the Testing folder after a successful run
of&nbsp;BuildAll.sh.</p>

<h3>Linux</h3>
<p class="MsoNormal">TBD</p>

<h2>License</h2>
The ICC Software License, Version 0.2<br><br><br>Copyright (c) 2003-2015 The International Color Consortium. All rights <br>reserved.<br><br>Redistribution and use in source and binary forms, with or without<br>modification, are permitted provided that the following conditions<br>are met:<br><br>1. Redistributions of source code must retain the above copyright<br>&nbsp;&nbsp; notice, this list of conditions and the following disclaimer. <br><br>2. Redistributions in binary form must reproduce the above copyright<br>&nbsp;&nbsp; notice, this list of conditions and the following disclaimer in<br>&nbsp;&nbsp; the documentation and/or other materials provided with the<br>&nbsp;&nbsp; distribution.<br><br>3. In the absence of prior written permission, the names "ICC" and "The<br>&nbsp;&nbsp; International Color Consortium" must not be used to imply that the<br>&nbsp;&nbsp; ICC organization endorses or promotes products derived from this<br>&nbsp;&nbsp; software.<br><br>THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED<br>WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES<br>OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE<br>DISCLAIMED.&nbsp; IN NO EVENT SHALL THE INTERNATIONAL COLOR CONSORTIUM OR<br>ITS CONTRIBUTING MEMBERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,<br>SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT<br>LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF<br>USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND<br>ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,<br>OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT<br>OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF<br>SUCH DAMAGE.<br>====================================================================<br><br>This software consists of voluntary contributions made by many<br>individuals on behalf of the The International Color Consortium. <br><br><br>Membership in the ICC is encouraged when this software is used for<br>commercial purposes. <br><br>&nbsp; <br>For more information on The International Color Consortium, please<br>see <a href="http://www.color.org/">http://www.color.org/</a>.<br>
