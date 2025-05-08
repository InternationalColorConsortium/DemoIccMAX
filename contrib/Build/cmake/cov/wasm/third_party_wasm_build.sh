#!/bin/bash
set -e

mkdir -p third_party && cd third_party

# --- ZLIB ---
if [ ! -d "zlib" ]; then
  curl -LO https://zlib.net/zlib-1.3.1.tar.gz
  tar -xzf zlib-1.3.1.tar.gz && mv zlib-1.3.1 zlib
fi

cd zlib
emconfigure ./configure --prefix=$(pwd)/out --static
emmake make libz.a -j$(nproc)
emmake make install
cd ..

# --- LIBPNG ---
if [ ! -d "libpng" ]; then
  curl -LO https://download.sourceforge.net/libpng/libpng-1.6.43.tar.gz
  tar -xzf libpng-1.6.43.tar.gz && mv libpng-1.6.43 libpng
fi

cd libpng
ZLIB_PREFIX="$(pwd)/../zlib/out"
CPPFLAGS="-I${ZLIB_PREFIX}/include" \
LDFLAGS="-L${ZLIB_PREFIX}/lib" \
emconfigure ./configure --prefix=$(pwd)/out --with-zlib-prefix=${ZLIB_PREFIX}
emmake make -j$(nproc)
emmake make install
cd ..

# --- LIBJPEG (jpeg-9e) ---
if [ ! -d "libjpeg" ]; then
  curl -LO https://ijg.org/files/jpegsrc.v9e.tar.gz
  tar -xzf jpegsrc.v9e.tar.gz && mv jpeg-9e libjpeg
fi

cd libjpeg
emconfigure ./configure --prefix=$(pwd)/out --disable-shared --enable-static
emmake make -j$(nproc)
emmake make install
cd ..

echo "✅ All libraries built successfully in third_party/*/out"
