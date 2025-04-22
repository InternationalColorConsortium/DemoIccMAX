#!/bin/bash
###############################################################
#
## Copyright (©) 2024-2025 David H Hoyt LLC. All rights reserved.
##                 https://srd.cx
##
## Last Updated: 17-APRIL-2025 0800 EDT by David Hoyt (©)
#
## Intent: Latest-iccMAX
#
## 
#
#
#
#
#
#
#
#
###############################################################

# Set relative path to the tool and test files
TOOL_PATH="Tools/IccApplyNamedCmm/iccApplyNamedCmm"
TEST_FILE="../Testing/CalcTest/rgbExercise8bit.txt"
PROFILE_FILE="../Testing/CalcTest/calcExercizeOps.icc"
LOG_FILE="../Testing/CalcTest/test_results.log"

# Expected parameters
FINAL_DATA_ENCODING="1"
INTERPOLATION="0"

# Timestamp for logging
current_timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

# Function to log messages with timestamps
log_message() {
  local message="$1"
  echo "$(current_timestamp): ${message}" >> "${LOG_FILE}"
  echo "$(current_timestamp): ${message}"
}

# Function to run the tool and capture output
run_test() {
  local debugcalc="$1"
  local final_data_encoding="$2"
  local interpolation="$3"
  local profile="$4"
  local expected_output="$5"

  log_message "Starting test for Patch in PR https://github.com/InternationalColorConsortium/DemoIccMAX/pull/53/files"
  log_message "Checking for stack buffer overflow at the icFixXml and global buffer overflow in the CIccPRMG::GetChroma functions"

  # Run the tool with correct parameters
  "${TOOL_PATH}" -debugcalc "${debugcalc}" "${final_data_encoding}" "${interpolation}" "${profile}" 1 > "${LOG_FILE}" 2>&1

  # Check for expected output in the log file
  if grep -q "${expected_output}" "${LOG_FILE}"; then
    log_message "Test passed: Found expected output '${expected_output}' in the results."
  else
    log_message "Test failed: Did not find expected output '${expected_output}' in the results."
    echo "Log output:"
    cat "${LOG_FILE}"
    exit 1
  fi
}

# Running the test
run_test "${TEST_FILE}" "${FINAL_DATA_ENCODING}" "${INTERPOLATION}" "${PROFILE_FILE}" "Begin Calc Apply"

log_message "All tests passed successfully!"
