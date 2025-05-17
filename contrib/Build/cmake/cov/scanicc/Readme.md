# Source for Port to Linux

This is the Windows to Linux Port for the Code.

## Repro

Install LCMS2 from Source, Build, Install, then......

```
gcc scanicc-port-linux.c /lcms2/Little-CMS/src/*.o -I/lcms2/Little-CMS/include \
-fsanitize=address -fno-omit-frame-pointer -g3 -O1 -Wall -Wextra -pedantic -o scanicc-port-linux  \
lz -lm -Wno-unused-parameter -Wno-type-limits -Wno-misleading-indentation
```
