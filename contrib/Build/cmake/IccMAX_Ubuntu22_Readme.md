# IccMAX Build Instructions for Ubuntu 22.04 (WSL2 Compatible)
`Thu Apr 10 16:34:09 EDT 2025`

[![Legacy Check](https://github.com/xsscx/PatchIccMAX/actions/workflows/121-MATRIX.yaml/badge.svg)](https://github.com/xsscx/PatchIccMAX/actions/workflows/121-MATRIX.yaml)

This reproduction builds the [IccMAX](https://github.com/InternationalColorConsortium/DemoIccMAX) project on **Ubuntu 22.04** using **wxWidgets 3.2**, compiled from source.

> ✅ Tested on: WSL2 / Ubuntu 22.04  
> ✅ Target: `Debug` build with AddressSanitizer enabled

---

## 🔧 Dependencies

Install all required libraries:

```bash
sudo apt update
sudo apt install -y \
    libgtk-3-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    libexpat1-dev \
    build-essential \
    cmake \
    git \
    curl \
    libxml2 \
    libxml2-dev \
    nlohmann-json3-dev \
    clang \
    clang-tools
```

---

## 🧱 Build wxWidgets 3.2 from Source

```bash
cd ~/tmp
git clone --branch WX_3_2_BRANCH https://github.com/wxWidgets/wxWidgets.git
cd wxWidgets
git submodule update --init --recursive

./configure --enable-debug --prefix=/usr/local
make -j$(nproc)
sudo make install
sudo ldconfig
```

> 💡 `--enable-debug` is used to support AddressSanitizer and debugging.  
> 🛠️ Install path is `/usr/local`, which will be picked up automatically by most linkers.

---

## 📦 Clone and Build DemoIccMAX

```bash
git clone https://github.com/InternationalColorConsortium/DemoIccMAX.git
cd DemoIccMAX/Build
```

Configure with CMake:

```bash
cmake -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
      -DCMAKE_BUILD_TYPE=Debug \
      -DENABLE_TOOLS=ON \
      -DENABLE_SHARED_LIBS=ON \
      -DENABLE_STATIC_LIBS=ON \
      -DENABLE_TESTS=ON \
      -DENABLE_INSTALL_RIM=ON \
      -DENABLE_ICCXML=ON \
      -DCMAKE_CXX_FLAGS="-g -fsanitize=address,undefined -fno-omit-frame-pointer -Wall" \
      -Wno-dev \
      Cmake/
```

Build:

```bash
make -j$(nproc)
```

---

## ✅ Verify Successful Build

#### Expected Output

```
...
[ 90%] Built target iccFromXml
[ 92%] Built target iccToXml
[ 95%] Built target iccApplyNamedCmm
[100%] Built target iccApplyProfiles
```

#### Binary Tree

```
find . -type f \( -perm -111 -o -name "*.a" -o -name "*.so" -o -name "*.dylib" \) -mmin -1440 ! -path "*/.git/*" ! -path "*/CMakeFiles/*" ! -name "*.sh" -print ``
```


```
./IccProfLib/libIccProfLib2.so.2.1.25
./IccProfLib/libIccProfLib2-static.a
./IccXML/libIccXML2.so.2.1.25
./IccXML/libIccXML2-static.a
./Tools/IccDumpProfile/iccDumpProfile
./Tools/IccRoundTrip/iccRoundTrip
./Tools/IccV5DspObsToV4Dsp/iccV5DspObsToV4Dsp
./Tools/IccFromCube/iccFromCube
./Tools/IccApplyProfiles/iccApplyProfiles
./Tools/IccApplyNamedCmm/iccApplyNamedCmm
./Tools/IccTiffDump/iccTiffDump
./Tools/IccToXml/iccToXml
./Tools/IccSpecSepToTiff/iccSpecSepToTiff
./Tools/IccFromXml/iccFromXml
./Tools/IccApplyToLink/iccApplyToLink
./Tools/wxProfileDump/iccDumpProfileGui
./Tools/IccPngDump/iccPngDump
```

---

## 🧹 Notes

- `libwxgtk3.2-dev` is not available via `apt` on Ubuntu 22.04; compiling from source is required.
- If you skip wxWidgets installation, the build may fallback to wx 3.0 (via `libwxgtk3.0-gtk3-dev`) but GUI features may behave differently.

---

## 🧰 Troubleshooting

If you see linker errors referencing wx libraries:

```bash
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
```

Or update your system’s dynamic linker config:

```bash
echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/local-wxwidgets.conf
sudo ldconfig
```

---
