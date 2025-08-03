# iccDEV WASM

The International Color Consortium....promoting and encouraging the standardization of an open color management system

> [!NOTE]
> **Upcoming Repository Name Change**
>
> This project will be renamed to iccDEV on September 5, 2025. On that date, both the project name and its GitHub repository location will be updated accordingly.
> Please update any bookmarks or dependencies to reflect this change.

## Quick Start

```
npm install iccwasm
cd node_modules/iccwasm
node .\test_iccFromXml.js
```

### Expected Output

```
IccFromXml built with IccProfLib Version 2.2.61, IccLibXML Version 2.2.61
Usage: IccFromXml xml_file saved_profile_file {-noid -v{=[relax_ng_schema_file - optional]}}
```

### Web Browser

```
npx http-server .
Browse URL http://localhost:8080
```

[![iccwasm](https://xss.cx/2025/08/03/img/iccwasm-npm-landing-page-3.png?raw=true "color.org")](https://color.org)

## Introduction

The iccDEV project (formally known as RefIccMAX or DemoIccMAX) provides an open source set of libraries and tools that allow for the interaction, manipulation, and application of iccDEV based color management profiles based on the [iccDEV profile specification](http://www.color.org/iccdev.xalter) in addition to legacy ICC profiles defined by [earlier ICC profile specifications](http://www.color.org/icc_specs2.xalter) and [documentation](ReadMeFiles/Readme.md).

Within this NPM Bundle are the IccProfLib & IccXML libraries compiled for WASM and the command line tools as Browser Apps:

* WASM Libraries that allow applications to interact with iccDEV profiles using modern Web Browsers

  * IccProfLib WASM - The iccDEV IccProfLib project represents an open source &
    cross platform reference implementation of a C++ library for reading,
    writing, applying, manipulating iccDEV color profiles defined by the [iccDEV
    profile specification](http://www.color.org/iccdev.xalter).

  * IccLibXML WASM - The iccDEV IccLibXML project contains a parallel C++
    extension library (IccLibXML) which provides the ability to interact with the
    objects defined by IccProfLib using an XML representation thus allowing iccDEV
    profiles to be expressed as or created from text based XML files.


* Web Apps based upon these libraries

  Run the Javascript without any arguments to display help information.

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

### Related Links

- [iccDEV Repo](https://github.com/InternationalColorConsortium/DemoIccMAX)
- `brew install iccmax`
- [Build](BUILD.md)


---

[The ICC Software License](LICENSE.md)
