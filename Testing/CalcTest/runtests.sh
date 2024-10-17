./checkInvalidProfiles.sh
../../Build/Tools/IccFromXml/iccFromXml calcCheckInit.xml calcCheckInit.icc
../../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm -debugcalc rgbExercise8bit.txt 0 1 calcCheckInit.icc 1 >> report.txt
../../Build/Tools/IccFromXml/iccFromXml calcExercizeOps.xml calcExercizeOps.icc
../../Build/Tools/IccApplyNamedCmm/iccApplyNamedCmm -debugcalc rgbExercise8bit.txt 0 1 calcExercizeOps.icc 1 >> report.txt
