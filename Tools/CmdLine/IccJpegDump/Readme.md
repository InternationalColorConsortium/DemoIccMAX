# 📸 iccJpegDump

**iccJpegDump** is a command-line utility for extracting and injecting ICC color profiles in JPEG images.  
It supports standard `APP2` ICC markers and intelligently scans EXIF or raw JPEG byte streams for profile detection.

---

## 🔧 Features

- ✅ **ICC Extraction:**
  - From `APP2` segments with `ICC_PROFILE\0` (Adobe ICC standard)
  - From `APPx` markers containing the `acsp` ICC signature
  - Via fallback binary scan for malformed or non-standard files

- ✅ **ICC Injection:**
  - Single-segment injection using `APP2`
  - Inserts ICC before the first image scan for maximum compatibility

- 🧪 **Fuzzing Support:**
  - Ideal for image fuzzers and ICC validation pipelines

---

## 🚀 Usage

### 📤 Extract ICC Profile

```bash
iccJpegDump input.jpg output.icc
```

Saves the embedded ICC profile (if any) into `output.icc`.

---

### 📥 Inject ICC Profile

```bash
iccJpegDump input.jpg --write-icc profile.icc --output output.jpg
```

Injects `profile.icc` into the JPEG and creates `output.jpg`.

---

## 📘 Segment Heuristics

- 🔍 `APP2` ICC header: `"ICC_PROFILE\0"`
- 🔍 `APPx` fallback: scans for `"acsp"` ICC signature
- 🔍 Full file scan if no standard marker found

---

## ⚠️ Known Limitations

- Only supports single `APP2` segment (64KB max)
- Will not strip or merge existing ICC tags
- Does not validate ICC contents or conformance

---

## ✅ Reproduction Example

### Inject ICC Profile

```bash
../Build/Tools/IccJpegDump/iccJpegDump \
  xnu_image_fuzzer_non_premultiplied_alpha.jpg \
  --write-icc sRGB_v4_ICC_preference.icc \
  --output export.jpg
```

**Expected Output:**

```
[INFO] ICC profile successfully injected into: export.jpg
```

---

## 🔍 Validation Steps

### 1. Check output with `file`

```bash
file export.jpg
```

```
export.jpg: JPEG image data, Exif Standard: [TIFF image data...], baseline, precision 8, 32x32, components 3
```

---

### 2. Inspect with ImageMagick

```bash
identify export.jpg
```

```
export.jpg JPEG 32x32 32x32+0+0 8-bit sRGB 63054B 0.000u 0:00.001
```

---

### 3. Compare with original JPEG

```bash
file xnu_image_fuzzer_non_premultiplied_alpha.jpg
```

```
JPEG image data, JFIF standard 1.01, density 72x72, baseline, ...
```

---

### 4. Inspect the ICC profile metadata

```bash
file sRGB_v4_ICC_preference.icc
```

```
sRGB_v4_ICC_preference.icc: color profile 4.2, RGB/Lab-spac device, 60960 bytes, 2007-07-25 00:05:37, ...
```

---

## 🧰 Integration

- AFL++, Honggfuzz, Radamsa compatible
- Easily dropped into PNG/JPEG/WebP ICC fuzzing suites

---