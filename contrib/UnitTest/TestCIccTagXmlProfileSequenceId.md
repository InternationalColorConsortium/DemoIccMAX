# TestCIccTagXmlProfileSequenceId Unit Test

## Overview

This unit test is designed to verify the **parsing functionality** of the `CIccTagXmlProfileSequenceId` class from the **IccLibXML** library. It uses **libxml2** to create a sample XML document and tests how the `CIccTagXmlProfileSequenceId` class processes this input. 

The test checks for both **correct** and **incorrect** XML parsing scenarios, ensuring that the class behaves as expected under various conditions.

## Files

- **TestCIccTagXmlProfileSequenceId.cpp**: Contains the unit test code for testing the `CIccTagXmlProfileSequenceId` class.
- **TestCIccTagXmlProfileSequenceId.sh**: A shell script that automates the process of generating a Makefile, building the test executable, and running the unit tests.

## Test Description

The `CIccTagXmlProfileSequenceId` class is responsible for parsing and processing XML documents in the context of ICC profiles. This unit test aims to validate the behavior of the `ParseXml` method.

### Expected Outcomes

- **Correct XML Structure**: 
  - When provided with a **properly structured** XML document, the `ParseXml` method should return `true`, indicating **successful parsing** and validation of the XML content.
  
- **Incorrect XML Structure**: 
  - If the XML structure is **incorrect** or **critical elements are missing**, the `ParseXml` method should return `false`, indicating **failure** to correctly parse the XML.

### AddressSanitizer (ASan) Integration

This unit test also integrates **AddressSanitizer (ASan)** to detect potential memory-related issues such as segmentation faults, buffer overflows, or use-after-free errors. If ASan detects any issues, they will be displayed in the output, making it easier to debug memory-related errors.

## Setup and Installation

### Prerequisites

- **g++** (on Ubuntu/Linux) or **clang++** (on macOS) with support for C++17.
- **libxml2** and its development headers.
- **pkg-config** to ensure the proper linking of `libxml2`.

On **Ubuntu**, install the dependencies with:
```bash
sudo apt-get install g++ libxml2-dev pkg-config
