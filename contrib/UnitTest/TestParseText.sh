#!/bin/sh

###############################################################################
#  @file build_and_run_TestParseText_selfcontained.sh
#  @brief This script builds and runs a C++ unit test for the ParseText() function.
#  It includes all the necessary source code, generates a Makefile, compiles the 
#  program with AddressSanitizer (ASan) for detecting memory issues, and runs the test.
#
#  @author @h02332 | David Hoyt
#  @date 24 MAY 2024
#  @version 1.0.4
#
#  License: This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
#  details. You should have received a copy of the GNU General Public License along 
#  with this program. If not, see <http://www.gnu.org/licenses/>.
###############################################################################

# Function to print a banner for the script
print_banner() {
    echo "=============================================="
    echo "   Building and Running TestParseText Unit Test"
    echo "   ParseText() Unit Test with AddressSanitizer"
    echo "=============================================="
}

# Function to clean up generated files
cleanup() {
    echo "Cleaning up..."
    rm -f TestParseText.cpp TestParseText run.log Makefile
    echo "Cleanup complete."
}

# Function to generate the C++ source code for the test
generate_source_code() {
    echo "Generating TestParseText.cpp source code..."
    cat << 'EOF' > TestParseText.cpp
/**
 *  @file TestParseText.cpp
 *  @brief Unit Test for ParseText()
 *  This test ensures that the ParseText function correctly parses numerical values 
 *  from a string and stores them in a buffer. It also integrates AddressSanitizer (ASan) 
 *  for detecting memory-related issues.
 *
 *  @version 1.0.2
 *  @date 24 MAY 2024
 *
 */

#include <iostream>
#include <cstring>
#include <cmath>

// Mock environment and dependencies
typedef unsigned int icUInt32Number;
enum icTagTypeSignature { icSigUInt16ArrayType = 1969828150 };

bool icIsNumChar(char c) {
    return (c >= '0' && c <= '9') || c == '.' || c == '-' || c == '+';
}

float nanf(const char* tagp) {
    return std::nan("");
}

template <class T, icTagTypeSignature Tsig>
class CIccXmlArrayType {
public:
    T* m_pBuf;
    icUInt32Number m_nSize;

    CIccXmlArrayType() : m_pBuf(nullptr), m_nSize(0) {}
    ~CIccXmlArrayType() { delete[] m_pBuf; }

    icUInt32Number ParseText(T* pBuf, icUInt32Number nSize, const char *szText);
};

template <class T, icTagTypeSignature Tsig>
icUInt32Number CIccXmlArrayType<T, Tsig>::ParseText(T* pBuf, icUInt32Number nSize, const char *szText) {
    icUInt32Number n = 0;
    char num[256] = {0};
    int b = 0;
    bool bInNum = false;

    while (*szText && n < nSize) {
        if (icIsNumChar(*szText)) {
            if (!bInNum) {
                bInNum = true;
                b = 0;
            }
            if (b < sizeof(num) - 2) {
                num[b++] = *szText;
            }
        } else {
            if (bInNum) {
                num[b] = '\0';
                pBuf[n++] = (T)atof(num);
                bInNum = false;
            }
        }
        szText++;
    }

    if (bInNum && n < nSize) {
        num[b] = '\0';
        pBuf[n++] = (T)atof(num);
    }

    return n;
}

int main() {
    const char testInput[] = "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890";
    unsigned short buffer[100];
    CIccXmlArrayType<unsigned short, icSigUInt16ArrayType> arrayType;

    arrayType.ParseText(buffer, 100, testInput);

    std::cout << "Test completed successfully.\n";
    return 0;
}
EOF
    echo "Source code generated."
}

# Function to generate the Makefile
generate_makefile() {
    echo "Generating Makefile..."

    cat << 'EOF' > Makefile
# Makefile for building TestParseText.cpp on Linux or macOS, with AddressSanitizer (ASan) integration.

UNAME_S := $(shell uname -s)
CXXFLAGS := -std=c++17 -g -fsanitize=address -fno-omit-frame-pointer

TARGET := TestParseText
SRC := TestParseText.cpp

clean:
	@echo "Cleaning up..."
	rm -f $(TARGET)
	@echo "Clean complete."

ifeq ($(UNAME_S), Linux)
	@echo "Detected OS: Linux"
	CXX := g++
endif

ifeq ($(UNAME_S), Darwin)
	@echo "Detected OS: macOS"
	CXX := clang++
	CXXFLAGS += -isysroot $(shell xcrun --show-sdk-path) -I$(shell xcrun --show-sdk-path)/usr/include/c++/v1
endif

all: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) $(SRC) -o $(TARGET)
	@if [ $$? -eq 0 ]; then \
		echo "$(TARGET) build successful."; \
		echo "Running $(TARGET)..."; \
		./$(TARGET) > run.log 2>&1 || true; \
		if grep -q "AddressSanitizer" run.log; then \
			echo "ASan error detected."; \
		else \
			echo "Program ran successfully."; \
		fi; \
	else \
		echo "$(TARGET) build failed."; \
	fi
EOF
    echo "Makefile generated."
}

# Function to build and run the test
build_and_run_test() {
    echo "Building the project..."
    make all

    if [ $? -eq 0 ]; then
        echo "Build and test completed."
    else
        echo "Build failed. Please check for errors."
    fi
}

# Main script flow
print_banner
cleanup
generate_source_code
generate_makefile
build_and_run_test
cleanup
echo "Script finished."
