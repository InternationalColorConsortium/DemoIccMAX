# 📸 iccPngDump

**iccPngDump** is a cross platform command line tool for extracting and analyzing ICC color profiles embedded in PNG images. It reads metadata from PNG files and, if present, extracts and optionally saves the ICC profile. 

---

## 🔧 Features
- **PNG Metadata**
  - Image dimensions (width x height)
  - Bit depth
  - Color type (e.g., RGB, Grayscale, Palette, RGBA)
  - Interlace type (e.g., None, Adam7)
  
✅ **ICC Extraction:**
- Parses and displays detailed PNG metadata
- Extracts embedded ICC profiles from PNG images
- Outputs ICC profile information including color space, PCS, and version
- Optionally saves ICC profile data to a separate file

✅ **ICC Injection:**
  - Profile size
  - Color Space
  - Colorimetric PCS
  - Profile version

- 🧪 **Fuzzing Support:**
  - Ideal for image fuzzers and ICC validation pipelines

---

## 🚀 Usage

### 📤 Extract ICC Profile

```bash
iccPngDump input.png output.icc
```

Saves the embedded ICC profile (if any) into `output.icc`.

---

### 📥 Inject ICC Profile

```bash
iccPngDump input.png --write-icc profile.icc --output output.png
```

Injects `profile.icc` into the PNG and creates `output.png`.

---

