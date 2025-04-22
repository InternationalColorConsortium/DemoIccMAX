# 🖨️ iccTiffDump

**iccTiffDump** is a command-line tool for extracting ICC profile metadata and technical characteristics from TIFF images.
It helps color scientists and developers audit TIFF structure, verify embedded color profiles, and analyze imaging parameters.

---

## 🔧 Features

- ✅ **TIFF Metadata Reporting**
  - Image dimensions, DPI, compression type, photometric model
- ✅ **ICC Profile Analysis**
  - Extracts embedded ICC profile with PCS, signature, description
- ✅ **Sample Precision Reporting**
  - Bits per component, sample format, samples per pixel
- ✅ **Tag Visibility**
  - Shows image layout, color space tags, resolution units
- ✅ **Multilingual Support**
  - Recognizes multi-language ICC descriptions and localized tags

---

## 🚀 Usage

### 📤 Extract Profile and Metadata

```bash
iccTiffDump input.tiff
```

Prints TIFF structure summary and ICC profile block if present.

---

## 📘 Output Highlights

- **Image Size** — Width × Height, DPI resolution
- **Color Model** — Photometric (RGB, CMYK, grayscale, etc.)
- **Compression** — e.g., LZW, PackBits, JPEG
- **ICC Block** — Version, size, PCS, rendering intent, description

---

## 🧪 Advanced Use

- Suitable for fuzzing TIFF encoders with profile injection
- Validates deterministic TIFF profile roundtrips

---

## 📚 Related Tools

- `iccEval`, `iccFromXml`, `iccApplyProfiles`
- Compatible with PNG and JPEG ICC tools from same suite

---

## 🔒 Notes

- Supports baseline and BigTIFF variants
- Reports errors for malformed tag blocks

---