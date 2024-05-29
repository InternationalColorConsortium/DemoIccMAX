#!/bin/zsh

echo "Run from DemoIccMAX-master/Build"

# Set relative paths to the tools and files
TOOL_PATH="Tools/IccApplyNamedCmm/iccApplyNamedCmm"
FROM_XML_TOOL="Tools/IccFromXml/iccFromXml"
CHECK_TOOL="Tools/checkInvalidProfiles"
INIT_XML="../Testing/CalcTest/calcCheckInit.xml"
INIT_ICC="../Testing/CalcTest/calcCheckInit.icc"
EXERCISE_XML="../Testing/CalcTest/calcExercizeOps.xml"
EXERCISE_ICC="../Testing/CalcTest/calcExercizeOps.icc"
REPORT_FILE="../Testing/CalcTest/report.txt"
RGB_TEST_FILE="../Testing/CalcTest/rgbExercise8bit.txt"

# Timestamp for logging
current_timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

# Function to log messages with timestamps
log_message() {
  local message="$1"
  echo "$(current_timestamp): ${message}" >>${REPORT_FILE}
  echo "$(current_timestamp): ${message}"
}

# Run the tests with proper logging
run_tests() {
  log_message "Running checkInvalidProfiles"
  ${CHECK_TOOL} >>${REPORT_FILE} 2>&1

  log_message "Generating calcCheckInit.icc from calcCheckInit.xml"
  ${FROM_XML_TOOL} ${INIT_XML} ${INIT_ICC} >>${REPORT_FILE} 2>&1

  log_message "Applying calcCheckInit.icc using iccApplyNamedCmm"
  ${TOOL_PATH} -debugcalc ${RGB_TEST_FILE} 0 1 ${INIT_ICC} 1 >>${REPORT_FILE} 2>&1

  log_message "Generating calcExercizeOps.icc from calcExercizeOps.xml"
  ${FROM_XML_TOOL} ${EXERCISE_XML} ${EXERCISE_ICC} >>${REPORT_FILE} 2>&1

  log_message "Applying calcExercizeOps.icc using iccApplyNamedCmm"
  ${TOOL_PATH} -debugcalc ${RGB_TEST_FILE} 0 1 ${EXERCISE_ICC} 1 >>${REPORT_FILE} 2>&1

  log_message "All tests completed successfully!"
}

# Ensure report file is empty at the beginning
echo "" >${REPORT_FILE}
run_tests
