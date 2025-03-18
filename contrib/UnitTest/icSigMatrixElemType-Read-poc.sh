#!/bin/bash  # Ensure we are using bash

###############################################################################
#
#  Written by David Hoyt for DemoIccMAX Project
#
#  @file icSigMatrixElemType-Read-poc.sh
#  @brief Automates the reproduction of a Type Confusion bug in 
#         CIccMpeCalculator::Read using LLDB debugging tools.
#
#  This script automates the following steps:
#    1. Runs iccToXml on the provided ICC file.
#    2. Starts LLDB, sets up breakpoints in IccMpeCalc.cpp, and inspects pointers.
#    3. Detects AddressSanitizer (ASan) errors and reports them in the final output.
#  
#  Requirements:
#    - LLDB installed
#    - iccToXml tool located at ../Build/Tools/IccToXml/iccToXml
#
###############################################################################

# Function to display a startup banner
startup_banner() {
  echo "############################################################"
  echo "#  Starting Type Confusion Reproduction Script              #"
  echo "#  Automating debugging with LLDB                           #"
  echo "############################################################"
}

# Function to display an end banner
end_banner() {
  echo "############################################################"
  if [ "$1" = "asan_error" ]; then
    echo "#  Script completed with AddressSanitizer errors.           #"
    echo "#  ASan Output detected. Please review the log.             #"
  else
    echo "#  Script completed successfully with no ASan errors.       #"
  fi
  echo "############################################################"
}

# Trap function to handle unexpected exits
cleanup() {
  echo "An error occurred. Exiting script."
  end_banner "asan_error"
  exit 1
}
trap cleanup INT TERM ERR

# Start the script with a banner
startup_banner

# Set up variables
POC_FILE="icSigMatrixElemType-Read-poc.icc"
OUTPUT_XML="icSigMatrixElemType-Read-poc.xml"
ICC_TO_XML=$(realpath ../Build/Tools/IccToXml/iccToXml)
ASAN_LOG="asan_log.txt"
LLDB_LOG="lldb_output.txt"

# Step 1: Verify that the iccToXml tool exists
if [ ! -x "$ICC_TO_XML" ]; then
  echo "Error: iccToXml tool not found at $ICC_TO_XML. Please ensure it is correctly located."
  exit 1
fi

# Step 2: Run iccToXml on the PoC ICC file and capture output
echo "Running iccToXml on the PoC ICC file..."
"$ICC_TO_XML" "$POC_FILE" "$OUTPUT_XML" 2>&1 | tee "$ASAN_LOG"
ICC_EXIT_CODE=${PIPESTATUS[0]}

# Check if ASan errors occurred by scanning the log file
if grep -q "AddressSanitizer" "$ASAN_LOG"; then
  echo "AddressSanitizer errors detected in iccToXml execution."
  ASAN_ERROR="yes"
else
  ASAN_ERROR="no"
fi

# Note: Do not exit here even if ASan errors are detected. Proceed to LLDB.

# Step 3: Proceed to the LLDB session regardless of ASan errors
# echo "Launching LLDB for debugging..."
# lldb -- "$ICC_TO_XML" "$POC_FILE" "$OUTPUT_XML" > "$LLDB_LOG" 2>&1 << EOF
# target create "$ICC_TO_XML"
# settings set target.run-args "$POC_FILE" "$OUTPUT_XML"

# Set a breakpoint at the problematic line in IccMpeCalc.cpp
# breakpoint set --file IccMpeCalc.cpp --line 4562

# Run the program
# run

# Step 4: Inspect 'this' pointer
# p *this

# Step 5: Inspect 'pElem' pointer
# p *pElem

# Step 6: Check the virtual table pointer (vptr)
# p *(void**)this

# Step 7: Check the element signature (elemSig)
# p elemSig

# Exit LLDB after inspection
#quit
# EOF

# Step 4: Final check if LLDB encountered any issues
# if [ $? -ne 0 ]; then
#  echo "Error: LLDB session encountered an error."
#  end_banner "asan_error"
#  exit 1
# fi

# Step 5: Display the final banner, taking ASan errors into account
[ "$ASAN_ERROR" = "yes" ] && end_banner "asan_error" || end_banner "no_asan_error"
