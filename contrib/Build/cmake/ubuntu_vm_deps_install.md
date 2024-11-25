
# Ubuntu Deps Install

## Overview
This Remote Script will install the project dependencies on *nix.

## Usage

Copy and Paste the Command into your Terminal:

```
cd /tmp
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/contrib/Build/cmake/ubuntu_vm_deps_install.sh)"
```

### Expected Output

```
sudo apt-get install -y libwxgtk3.2-dev libwxgtk-media3.2-dev libwxgtk-webview3.2-dev wx-common wx3.2-headers libtiff6 curl git make cmake clang clang-tools libxml2 libxml2-dev nlohmann-json3-dev build-essential

Reading package lists... Done
Building dependency tree... Done
Reading state information... Done

libwxgtk3.2-dev is already the newest version (3.2.4+dfsg-4build1).
libwxgtk-media3.2-dev is already the newest version (3.2.4+dfsg-4build1).
libwxgtk-webview3.2-dev is already the newest version (3.2.4+dfsg-4build1).
wx-common is already the newest version (3.2.4+dfsg-4build1).
wx3.2-headers is already the newest version (3.2.4+dfsg-4build1).
libtiff6 is already the newest version (4.5.1+git230720-4ubuntu2.2).
curl is already the newest version (8.5.0-2ubuntu10.5).
git is already the newest version (1:2.43.0-1ubuntu7.1).
make is already the newest version (4.3-4.1build2).
cmake is already the newest version (3.28.3-1build7).
clang is already the newest version (1:18.0-59~exp2).
clang-tools is already the newest version (1:18.0-59~exp2).
libxml2 is already the newest version (2.9.14+dfsg-1.3ubuntu3).
libxml2-dev is already the newest version (2.9.14+dfsg-1.3ubuntu3).
nlohmann-json3-dev is already the newest version (3.11.3-1).
build-essential is already the newest version (12.10ubuntu1).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.

2024-11-24 14:47:52 EST
```
