
# Build Clang Master Branch

## Overview
This Remote Script builds the master branch using Clang.

## Usage
Copy and Paste the Command into your Terminal to Build the Project with all dependencies.

```
cd /tmp
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/build_clang_master_branch.sh)"
```

### Expected Output

```
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_COMPILER=$COMPILER -DCMAKE_CXX_FLAGS="$CXX_FLAGS" -Wno-dev Cmake/

-- ##########################################################################
-- ## Starting to Configure the DemoIccMAX Project at 2024-11-24 14:42:41
-- ##########################################################################
-- The C compiler identification is GNU 13.2.0
-- The CXX compiler identification is Clang 18.1.3
...
```
