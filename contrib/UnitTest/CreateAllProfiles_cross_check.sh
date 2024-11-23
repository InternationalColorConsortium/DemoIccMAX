#!/bin/sh
##
## Copyright (c) 2024 The International Color Consortium. All rights reserved.
##
## Unit Test for Profile Creation
## Cross Check with Report
##
## Written by David Hoyt for DemoIccMAX Project
## Date: 28-Sept-24
##
echo "Creating Profiles..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/Testing/CreateAllProfiles.sh)" > profile-checks.log 2>&1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/Testing/RunTests.sh)" >> profile-checks.log 2>&1
echo "cd to CalcTest"
cd CalcTest
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/Testing/Testing/CalcTest/runtests.sh)" >> ../profile-checks.log 2>&1
echo "cd to HDR"
cd ../HDR
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/Testing/Testing/HDR/mkprofiles.sh)" >> ../profile-checks.log 2>&1
echo "cd to Overprint"
cd ../Overprint
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/Testing/Testing/Overprint/RunTests.sh)" >> ../profile-checks.log 2>&1
echo "cd mcs"
cd ../mcs
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/Testing/esting/mcs/updateprevWithBkgd.sh)" >> ../profile-checks.log 2>&1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/Testing/Testing/mcs/updateprev.sh)" >> ../profile-checks.log 2>&1
echo "cd Testing"
cd ../
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/Testing/Testing/testing_summary.sh)" >> ../profile-checks.log 2>&1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/InternationalColorConsortium/DemoIccMAX/refs/heads/master/Testing/Testing/testing_summary.sh)"
echo "Cross-Check for CreateAllProfiles Done!"
