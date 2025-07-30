# IccFromXml

## Overview

`IccFromXml` is a command-line utility that converts binary ICC profiles to their XML representations. This is useful for inspection, validation, and editing of profile contents in a human-readable format, or for round-trip transformations in conjunction with `IccToXml`.

---

## Features

- Converts `.icc` binary profiles into `.xml` representation
- Preserves all tag and header data using ICC XML schema
- Supports profiles using multi-process elements (MPEs)
- Based on ICC ProfLib and ICC LibXML libraries
- Outputs well-formed XML suitable for re-import or validation

---

## Usage

```sh
IccFromXml source.xml output.icc
```

---

## Parameters

- `source.xml`: The input XML document
- `output.icc`: The profile to be output

---

## Example

```sh
IccToXml DisplayProfile.icc DisplayProfile.xml
```

---

## Changelog

- Original version by Max Derhak
- XML serialization reliability improvements by David Hoyt (2025)
