# `iccMAX-cicd-build-checks.sh`

This Post-Build Runner Stub is for all iccMAX bugs fixed, to be fixed, other reproducers and regession testers.

Please add Test Cases via PR.

## STUB
```
        ...
        cd DemoIccMAX/Build
        make -j$(sysctl -n hw.ncpu)
        cd ../Testing
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/xsscx/PatchIccMAX/refs/heads/pr119/contrib/UnitTest/iccMAX-cicd-build-checks.sh)"
```
