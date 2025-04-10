# iccPngDump

## Overview

`iccPngDump` is a cross platform command line tool for extracting and analyzing ICC color profiles embedded in PNG images. It reads metadata from PNG files and, if present, extracts and optionally saves the ICC profile. 


## Features
- Parses and displays detailed PNG metadata
- Extracts embedded ICC profiles from PNG images
- Outputs ICC profile information including color space, PCS, and version
- Optionally saves ICC profile data to a separate file



## Output Details
- **PNG Metadata**
  - Image dimensions (width x height)
  - Bit depth
  - Color type (e.g., RGB, Grayscale, Palette, RGBA)
  - Interlace type (e.g., None, Adam7)

- **ICC Profile Information (if present)**
  - Profile size
  - Color Space
  - Colorimetric PCS
  - Profile version

## Useful Command History and Examples

### Build and Compilation Commands

#### Remove cached build files and clean up before a fresh build

```
cd Build/
rm -rf CMakeCache.txt CMakeFiles/ Makefile IccProfLib/ IccXML/ Testing/ Tools/
```

##### Configure build with debugging flags and AddressSanitizer enabled

```
cd Build/
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
      -Wno-dev -DENABLE_TOOLS=YES Cmake/
```

#### Compile the project with 32 threads for faster build

```
make -j32
```

#### Clean and rebuild

```
make clean
make -j32
```

### Running iccPngDump

#### Run iccPngDump on a single PNG file and save ICC profile

```
Tools/IccPngDump/iccPngDump poc.png poc.icc
```


#### Batch process all PNG files in the current directory


```
find . -type f -name "*.png" -exec iccPngDump {} \;
```

### Extracting Profiles with `exiftool`

#### Extract ICC profile from a PNG file using exiftool

```
exiftool -icc_profile -b poc.png > extracted.icc
```

#### View extracted ICC profile in hex

```
hexdump -C extracted.icc | head
xxd extracted.icc > extracted.txt
```


#### Inspect ICC profile content

```
more extracted.txt
```

### Hash Verification for File Integrity


#### Generate SHA256 and MD5 checksums for PNG files

```
sha256sum notpublic.png poc.png
md5sum notpublic.png poc.png
```

#### Find duplicate PNG files based on SHA256 and MD5 hashes


```
find . -maxdepth 1 -type f -name "*.png" -exec sha256sum {} + | awk '{print $1, $2}' | sort | uniq -w 64 -d
find . -maxdepth 1 -type f -name "*.png" -exec md5sum {} + | awk '{print $1, $2}' | sort | uniq -w 32 -d
```

#### Find duplicate ICC files based on SHA256 and MD5 hashes

```
find . -maxdepth 1 -type f -name "*.icc" -exec sha256sum {} + | awk '{print $1, $2}' | sort | uniq -w 64 -d
find . -maxdepth 1 -type f -name "*.icc" -exec md5sum {} + | awk '{print $1, $2}' | sort | uniq -w 32 -d
```

#### PNG File Manipulation
```sh
# Remove ICC profile from PNG and reattach a random ICC profile from existing files
pngcrush -rem iCCP -q poc.png tmp.png && pngcrush -q -icc $(ls *.icc | shuf -n1) tmp.png new_poc.png

# Check PNG metadata
pngcheck -v poc.png
```

### History

- Initial implementation by Max Derhak 12-7-2013

- CopyPasta for Png implementation by David Hoyt 20-MAR-2025
