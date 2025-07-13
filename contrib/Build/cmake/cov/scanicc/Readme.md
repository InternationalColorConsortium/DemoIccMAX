# Port to Linux for scanicc.c
- Copyright (c) 1998-2015 Marti Maria Saguer
- Copyright (c) 2025 David H Hoyt LLC

**Last Updated:** 15-MAY-2025 0600 EDT

Step 1. Modifed the directory and file functions 

```
#ifdef _WIN32
#include <io.h>
#endif
```

Step 2. Added headers

```
#include <stdint.h>     // for intptr_t
#include <dirent.h>     // for opendir, readdir
#include <sys/stat.h>   // for stat
#include <unistd.h>     // for access
```

- modify checkDir()

Step 3. Build LCMS2 Source

```
mkdir ~/lcms2 && cd lcms2
git clone https://github.com/mm2/Little-CMS.git
cd Little-CMS && ./configure && make -j32 install
cd ../
```

Step 4. Build scanicc-linux-port.c

```
cd lcms2
gcc scanicc-port-linux.c ~/lcms2/Little-CMS/src/*.o \
-I/home/xss/lcms2/Little-CMS/include \
-fsanitize=address -fno-omit-frame-pointer -g3 -O1 -Wall \
-Wextra -pedantic -o scanicc-port-linux -lz -lm \
-Wno-unused-parameter -Wno-type-limits -Wno-misleading-indentation
```

Step. 5 Verify Build

```
./scanicc
LittleCMS ICC profile scanner [LittleCMS 2.14]

scanicc: Checks for corrupted ICC profiles.

usage: scanicc [flags] <profile>

flags:

-v<level> - Verbosity level
```