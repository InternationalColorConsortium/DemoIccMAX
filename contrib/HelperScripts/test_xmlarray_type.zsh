#!/bin/zsh

echo "Run from DemoIccMAX-master/Build"
# Define the number of concurrent runs
num_runs=10

# Path to the application command
command_path="Tools/IccFromXml/iccFromXml"
input_xml="../Testing/CMYK-3DLUTs/CMYK-3DLUTs.xml"
output_icc="../Testing/CMYK-3DLUTs/CMYK-3DLUTs.icc"

echo "Run tests for CMYK-3DLUTs.xml"

# Function to run the command
run_command() {
  $command_path $input_xml $output_icc &
}

# Run multiple instances to potentially cause a race condition
for i in {1..$num_runs}; do
  run_command
done

# Wait for all background jobs to finish
wait

# Path to the application command
command_path="Tools/IccFromXml/iccFromXml"
input_xml="../Testing/CMYK-3DLUTs/CMYK-3DLUTs2.xml"
output_icc="../Testing/CMYK-3DLUTs/CMYK-3DLUTs2.icc"

echo "Run tests for CMYK-3DLUTs2.xml"

# Function to run the command
run_command() {
  $command_path $input_xml $output_icc &
}

# Run multiple instances to potentially cause a race condition
for i in {1..$num_runs}; do
  run_command
done

# Wait for all background jobs to finish
wait

echo "All processes have completed."

