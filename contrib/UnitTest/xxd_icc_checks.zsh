#!/bin/zsh
#
## Copyright (c) 2024 The International Color Consortium. All rights reserved.
##
## Written by David Hoyt for ICC color.org & DemoIccMAX Project
## Date: 27-Sept-24
##
## zsh xxd check of Testing/ .icc color profiles
## Purpose: Automates the build and testing for icc color profiles
##
# ============================================================

echo "International Color Consortium | DemoIccMAX Project | Copyright 2024." 
echo "For more information on The International Color Consortium, please see http://color.org/."
echo "zsh xxd check of Testing/ .icc color profiles"
echo "Written by David Hoyt for DemoIccMAX Project"
echo "Last Updated: 1941 EDT on 07-Oct-2024"

# ICC xxd report file
consolidated_report="consolidated_icc_report.txt"

# Initialize the consolidated report
echo "Consolidated ICC Profile Analysis Report" > "$consolidated_report"
echo "----------------------------------------" >> "$consolidated_report"
echo "" >> "$consolidated_report"

# Function to analyze an ICC profile's xxd output
analyze_icc_profile() {
  local xxd_file="$1"

  echo "Analyzing: $xxd_file" >> "$consolidated_report"
  echo "---------------------------------" >> "$consolidated_report"

  # Magic bytes (0x00 to 0x03) - should match 'acsp'
  local magic_bytes=$(head -n 2 "$xxd_file" | awk 'NR==2 {print substr($0, 37, 8)}')
  echo "Magic Bytes: $magic_bytes (should be 'acsp')" >> "$consolidated_report"

  # Profile size (0x00 to 0x03) - 4 bytes
  local profile_size=$(head -n 1 "$xxd_file" | awk '{print substr($0, 7, 8)}')
  echo "Profile Size: $profile_size bytes" >> "$consolidated_report"

  # Preferred CMM Type (0x04 to 0x07) - 4 bytes
  local cmm_type=$(head -n 1 "$xxd_file" | awk '{print substr($0, 19, 8)}')
  echo "Preferred CMM Type: $cmm_type" >> "$consolidated_report"

  # Profile version (0x08 to 0x0B) - 4 bytes
  local profile_version=$(head -n 1 "$xxd_file" | awk '{print substr($0, 31, 8)}')
  echo "Profile Version: $profile_version" >> "$consolidated_report"

  # Profile/device class (0x0C to 0x0F) - 4 bytes
  local device_class=$(head -n 2 "$xxd_file" | awk 'NR==2 {print substr($0, 7, 8)}')
  echo "Profile/Device Class: $device_class" >> "$consolidated_report"

  # Data color space (0x10 to 0x13) - 4 bytes
  local color_space=$(head -n 2 "$xxd_file" | awk 'NR==2 {print substr($0, 19, 8)}')
  echo "Data Color Space: $color_space" >> "$consolidated_report"

  # PCS (Profile Connection Space) (0x14 to 0x17) - 4 bytes
  local pcs=$(head -n 2 "$xxd_file" | awk 'NR==2 {print substr($0, 31, 8)}')
  echo "Profile Connection Space (PCS): $pcs" >> "$consolidated_report"

  # Creation Date (0x18 to 0x1F) - 8 bytes
  local creation_date=$(head -n 2 "$xxd_file" | awk 'NR==2 {print substr($0, 43, 23)}')
  echo "Creation Date: $creation_date" >> "$consolidated_report"

  # Profile Signature (should be 'acsp') (0x20 to 0x23) - 4 bytes
  local profile_signature=$(head -n 3 "$xxd_file" | awk 'NR==3 {print substr($0, 7, 8)}')
  echo "Profile Signature: $profile_signature (should be 'acsp')" >> "$consolidated_report"

  # Primary Platform (0x24 to 0x27) - 4 bytes
  local primary_platform=$(head -n 3 "$xxd_file" | awk 'NR==3 {print substr($0, 19, 8)}')
  echo "Primary Platform: $primary_platform" >> "$consolidated_report"

  # CMM Flags (0x28 to 0x2B) - 4 bytes
  local cmm_flags=$(head -n 3 "$xxd_file" | awk 'NR==3 {print substr($0, 31, 8)}')
  echo "CMM Flags: $cmm_flags" >> "$consolidated_report"

  # Device Manufacturer (0x2C to 0x2F) - 4 bytes
  local device_manufacturer=$(head -n 3 "$xxd_file" | awk 'NR==3 {print substr($0, 43, 8)}')
  echo "Device Manufacturer: $device_manufacturer" >> "$consolidated_report"

  # Device Model (0x30 to 0x33) - 4 bytes
  local device_model=$(head -n 4 "$xxd_file" | awk 'NR==4 {print substr($0, 7, 8)}')
  echo "Device Model: $device_model" >> "$consolidated_report"

  # Device Attributes (0x34 to 0x3B) - 8 bytes
  local device_attributes=$(head -n 4 "$xxd_file" | awk 'NR==4 {print substr($0, 19, 23)}')
  echo "Device Attributes: $device_attributes" >> "$consolidated_report"

  # Rendering Intent (0x3C to 0x3F) - 4 bytes
  local rendering_intent=$(head -n 5 "$xxd_file" | awk 'NR==5 {print substr($0, 7, 8)}')
  echo "Rendering Intent: $rendering_intent" >> "$consolidated_report"

  # PCS Illuminant (0x40 to 0x47) - 12 bytes
  local pcs_illuminant=$(head -n 5 "$xxd_file" | awk 'NR==5 {print substr($0, 19, 23)}')
  echo "PCS Illuminant: $pcs_illuminant" >> "$consolidated_report"

  # Profile Creator (0x48 to 0x4B) - 4 bytes
  local profile_creator=$(head -n 6 "$xxd_file" | awk 'NR==6 {print substr($0, 7, 8)}')
  echo "Profile Creator: $profile_creator" >> "$consolidated_report"

  # Reserved (0x4C to 0x4F) - 4 bytes, should be 0
  local reserved=$(head -n 6 "$xxd_file" | awk 'NR==6 {print substr($0, 19, 8)}')
  echo "Reserved: $reserved (should be 0)" >> "$consolidated_report"

  echo "" >> "$consolidated_report"
}

# Find and process each xxd output file
find . -type f -name "*-xxd.txt" | while IFS= read -r xxd_file; do
  analyze_icc_profile "$xxd_file"
done

echo "----------------------------------------" >> "$consolidated_report"
echo "tail -n 50 consolidated_icc_report.txt"
tail -n 50 consolidated_icc_report.txt
echo "All ICC profiles have been analyzed. Consolidated report saved to $consolidated_report."
