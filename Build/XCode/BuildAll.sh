#!/bin/sh
config="Release"

cd ../../IccProfLib
xcodebuild -target IccProfLib-Static -configuration "$config"
cp Build/$config/* ../Build/XCode/lib

cd ../IccXML/IccLibXML
xcodebuild -target IccLibXML -configuration "$config"
cp build/$config/* ../../Build/XCode/lib

cd ../../Tools/CmdLine/IccApplyNamedCmm
xcodebuild -target IccApplyNamedCMM -configuration "$config"
cp build/$config/IccApplyNamedCmm ../../../Testing

cd ../IccApplyProfiles
xcodebuild -target iccApplyProfiles -configuration "$config"
cp build/$config/IccApplyProfiles ../../../Testing

cd ../IccDumpProfile
xcodebuild -target IccDumpProfile -configuration "$config"
cp build/$config/IccDumpProfile ../../../Testing

cd ../IccRoundTrip
xcodebuild -target IccRoundTrip -configuration "$config"
cp build/$config/IccRoundTrip ../../../Testing

cd ../IccSpecSepToTiff
cp ../IccApplyProfiles/TiffImg.* .
xcodebuild -target IccSpecSepToTiff -configuration "$config"
cp build/$config/IccSpecSepToTiff ../../../Testing

cd ../IccTiffDump
cp ../IccApplyProfiles/TiffImg.* .
xcodebuild -target IccTiffDump -configuration "$config"
cp build/$config/IccTiffDump ../../../Testing

cd ../../../IccXML/CmdLine/IccFromXml
xcodebuild -target IccFromXml -configuration "$config"
cp build/$config/IccFromXml ../../../Testing

cd ../../../IccXML/CmdLine/IccToXml
xcodebuild -target IccToXML -configuration "$config"
cp build/$config/IccToXml ../../../Testing

cd ../../../Tools/MacOS-X/RefIccMAXCmm
xcodebuild -target RefIccMAXCmm -configuration "$config"

cd ../../wxWidget/wxProfileDump/
xcodebuild -target wxProfileDump -configuration "$config"
