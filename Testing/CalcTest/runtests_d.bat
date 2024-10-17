call checkInvalidProfiles_d
..\iccFromXml_d.exe calcCheckInit.xml calcCheckInit.icc
..\iccApplyNamedCmm_d.exe -debugcalc rgbExercise8bit.txt 0 1 calcCheckInit.icc 1
..\iccFromXml_d.exe calcExercizeOps.xml calcExercizeOps.icc
..\iccApplyNamedCmm_d.exe -debugcalc rgbExercise8bit.txt 0 1 calcExercizeOps.icc 1
