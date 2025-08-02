# iccDEV

`brew install iccmax`

## Introduction

The iccDEV project (formally known as RefIccMAX or DemoIccMAX) provides an open source set of libraries and tools that allow for the interaction, manipulation, and application of iccDEV based color management profiles based on the [iccDEV profile specification](http://www.color.org/iccdev.xalter) in addition to legacy ICC profiles defined by [earlier ICC profile specifications](http://www.color.org/icc_specs2.xalter).

Within the project are several libraries and tools as follows:

* Libraries that allow applications to interact with iccDEV profiles

  * IccProfLib - The iccDEV IccProfLib project represents an open source &
    cross platform reference implementation of a C++ library for reading,
    writing, applying, manipulating iccDEV color profiles defined by the [iccDEV
    profile specification](http://www.color.org/iccdev.xalter).

  * IccLibXML - The iccDEV IccLibXML project contains a parallel C++
    extension library (IccLibXML) which provides the ability to interact with the
    objects defined by IccProfLib using an XML representation thus allowing iccDEV
    profiles to be expressed as or created from text based XML files.


* Tools based upon these libraries

  For command line arguments running the application without any arguments
  will display help information about command line options.

  * IccToXML is a cross platform command line tool that allows both legacy ICC
    and iccDEV profiles to be expressed using an XML representation. This allows
    for profiles to be converted to a textual representation that can be directly
    edited using a text editor and then converted back to ICC/iccDEV profile
    formats using IccFromXML.

  * IccFromXML is a cross platform command line tool that allows both legacy ICC
    and iccDEV profiles to be created from the same XML representation provided by
    IccToXML. A schema for iccXML files is forthcoming but can be determined using
    the FromXML() and ToXML() member functions defined in IccLibXML. The
    IccFromXML tool provides a simple direct method to create and manipulate
    iccDEV based profiles.

  * IccApplyNamedCmm is a cross platform command line tool that allows a
    sequence of legacy ICC and/or iccDEV profiles to be applied to colors defined
    in a text based input profile outputting the results to the console, and can
    be redirected to a output text file. Example source text files can be found in
    Testing/ApplyDataFiles. The IccApplyNamedCmm application provides a basis for
    testing various features of iccDEV.

  * IccApplyProfiles is a cross platform command line tool that allows a sequence of
    legacy and/or iccDEV profiles to a source TIFF image resulting in a destination
    TIFF image. The final destination profile can optionally be embedded in the
    resulting TIFF image.

  * IccDumpProfile is a cross platform command line tool that allows information
    from a legacy ICC and or iccDEV profile to be output to the console. Data
    with non-printable values are replaced with '?'. Output from this tool is
    not guaranteed to be ASCII or UTF-8, but line-endings are consistent for a
    given platform.

    Detailed validation messages start with either "Warning!", "Error!" or "NonCompliant!".
    The overall status of validation is reported 2 lines below the line starting
    "Validation Report" and can be located using the following simple `grep`:

    ```bash
    grep --text -A 3 "^Validation Report" out.txt
    ```


  * IccRoundTrip is a cross platform command line tool that allows round trip
    colorimetric processing characteristics of rendering intent of a profile to be
    evaluated. (Evaluation goes from device values to PCS to establish initial PCS
    values. These are then converted to device values and then PCS values for the
    first round trip. Second round trip comparison then converts the second PCS
    values to device values to PCS values for comparison to the second PCS values.

  * IccSpecSepToTiff is a cross platform command line tool that combines separate
    individual TIFF images associated with different spectral wavelengths into a
    single multi-sample per pixel TIFF image. An iccDEV based profile can optionally
    be embedded in the resulting TIFF image.

  * IccTiffDump is a cross platform command line tool that outputs header and
    embedded ICC profile information about a TIFF image to the console.

  * IccPngDump is a cross platform command line tool that outputs header and
    embedded ICC profile information about a PNG image to the console. 

  * IccJpegDump is a cross platform command line tool that outputs header and
    embedded ICC profile information about a JPG image to the console. 

  * wxProfileDump provides a [wxWidgets](https://www.wxwidgets.org/) GUI based
    iccDEV and legacy ICC profile inspector tool. The code for this tool is based on
    wxWidgets 3.2.


## Example iccDEV Profiles

XML files are provided that can be used to create example iccDEV profiles. The
CreateAllProfiles.bat file uses the iccFromXML tool to create ICC profiles for
each of these XML files. The XML files can be found in the following folders:

### [Calc](Testing/Calc)

This folder contains profiles that demonstrate color modeling using the
Calculator MultiProcessElement. The srgbCalcTest profile exercises all specified
calculator operations.

### [Display](Testing/Display)

This folder contains profiles that demonstrate spectral modeling of display
profiles allowing for late binding of the observer using MultiProcessElements
that are transformed at startup to colorimetry for the desired observer.

### [Encoding](Testing/Encoding)

This folder contains 3 channel encoding class profiles. Both "name only"
profiles as well as fully specified profiles are present.

### [Named](Testing/Named)

This folder contains named color profiles showcasing
features such as tints, spectral reflectance, and fluorescence (with and with
out sparse notation).

### [PCC](Testing/PCC)

This folder contains various profiles that can be used to
define Profile Connection Conditions (PCC). All profiles are abstract profiles
that perform no operation to PCS values. However, all profiles contain fully
defined PCC tags that provide information that can be used to define rendering
for various observers and illuminants. Profiles that utilize both absolute
colorimetry as well as Material Adjusted colorimetry are present.

### [SpecRef](Testing/SpaceRef)

This folder contains various profiles that convert data to/from/between a
spectral reflectance PCS. The argbRef (AdobeRGB) and srgbRef (sRGB) convert RGB
values to/from spectral reflectance. RefDecC, RefDecH, and RefIncW are abstract
spectral reflectance profiles that modify "chroma", "hue", and "lightness" of
spectral reflectance values in a spectral reflectance PCS. The argbRef, srgbRef,
RefDecC, RefDecH, RefIncW profiles all estimate and/or manipulate spectral
reflectance using Wpt based spectral estimation (see chapter 7 of
http://scholarworks.rit.edu/theses/8789/. Additionally, examples of 6 channel
abridged spectral encoding is provided.

### Quick Start

- [iccDEV Release Binaries](https://github.com/InternationalColorConsortium/iccDEV/releases) 
- `brew install iccmax`
- [Build](BUILD.md)


---

[The ICC Software License](LICENSE.md)
