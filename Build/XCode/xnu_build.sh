#!/bin/sh
config="Release"

cd ../../IccProfLib
xcodebuild -target IccProfLib-macOS -configuration "$config" -arch x86_64 clean
xcodebuild -target IccProfLib-macOS -configuration "$config" -arch x86_64
cp build/$config/libIccProfLib.a ../Build/XCode/lib

cd ../IccXML/IccLibXML
xcodebuild -target IccLibXML-macOS -configuration "$config" -arch x86_64 clean
xcodebuild -target IccLibXML-macOS -configuration "$config" -arch x86_64
cp build/$config/libIccLibXML.a ../../Build/XCode/lib

cd ../../Tools/CmdLine/IccApplyNamedCmm
xcodebuild -target IccApplyNamedCMM -configuration "$config" -arch x86_64 clean
xcodebuild -target IccApplyNamedCMM -configuration "$config" -arch x86_64
cp build/$config/IccApplyNamedCmm ../../../Testing

cd ../IccApplyProfiles
xcodebuild -target iccApplyProfiles -configuration "$config" -arch x86_64 clean
xcodebuild -target iccApplyProfiles -configuration "$config" -arch x86_64
cp build/$config/IccApplyProfiles ../../../Testing

cd ../IccDumpProfile
xcodebuild -target IccDumpProfile -configuration "$config" -arch x86_64 clean
xcodebuild -target IccDumpProfile -configuration "$config" -arch x86_64
cp build/$config/IccDumpProfile ../../../Testing

cd ../IccRoundTrip
xcodebuild -target IccRoundTrip -configuration "$config" -arch x86_64 clean
xcodebuild -target IccRoundTrip -configuration "$config" -arch x86_64 
cp build/$config/IccRoundTrip ../../../Testing

cd ../IccSpecSepToTiff
cp ../IccApplyProfiles/TiffImg.* .
xcodebuild -target IccSpecSepToTiff -configuration "$config" -arch x86_64 clean
xcodebuild -target IccSpecSepToTiff -configuration "$config" -arch x86_64
cp build/$config/IccSpecSepToTiff ../../../Testing

cd ../IccTiffDump
cp ../IccApplyProfiles/TiffImg.* .
xcodebuild -target IccTiffDump -configuration "$config" -arch x86_64 clean
xcodebuild -target IccTiffDump -configuration "$config" -arch x86_64
cp build/$config/IccTiffDump ../../../Testing

cd ../../../IccXML/CmdLine/IccFromXml
xcodebuild -target iccFromXml -configuration "$config" -arch x86_64 clean
xcodebuild -target iccFromXml -configuration "$config" -arch x86_64
cp $config/IccFromXml ../../../Testing

cd ../../../IccXML/CmdLine/IccToXml
xcodebuild -target IccToXml -configuration "$config" -arch x86_64 clean
xcodebuild -target IccToXml -configuration "$config" -arch x86_64
cp $config/IccToXml ../../../Testing
