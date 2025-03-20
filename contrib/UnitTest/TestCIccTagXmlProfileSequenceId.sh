#!/bin/sh
## Author: David Hoyt
## Date: 25-MAR-2025 1630 EDT by David Hoyt
## Unit Test for TestCIccTagXmlProfileSequenceId.sh
## This Script is for macOS or ubuntu
##
# Shell script to generate a Makefile, build the project, and run the program

# Step 1: Create the Makefile
echo "Generating Makefile..."

cat << 'EOF' > Makefile
# Makefile for building TestCIccTagXmlProfileSequenceId on different platforms (Ubuntu/Linux or macOS).
# Automatically detects the OS and applies the necessary flags and libraries.
# Includes AddressSanitizer (ASan) and UndefinedBehaviorSanitizer (UBSan) build options for debugging memory and undefined behavior issues.

# Detect the operating system
UNAME_S := $(shell uname -s)

# Compiler flags for sanitizers and debugging
CXXFLAGS := -std=c++17 -g -fsanitize=address,undefined -fno-omit-frame-pointer

# Include directories (adjust paths as necessary)
INCLUDES := -I/usr/local/include -I../IccProfLib -I../IccXML/IccLibXML $(shell pkg-config --cflags libxml-2.0)

# Library search paths and libraries
LIBS := -L../Build/IccProfLib -L../Build/IccXML -lpthread $(shell pkg-config --libs libxml-2.0) -lIccProfLib2 -lIccXML2

# Additional linker flags for rpath (for runtime linking)
LDFLAGS := -Wl,-rpath,../Build/IccProfLib -Wl,-rpath,../Build/IccXML

# Output executable
TARGET := TestCIccTagXmlProfileSequenceId

# Source file
SRC := TestCIccTagXmlProfileSequenceId.cpp

# Command to clean the build
clean:
	@echo "Cleaning up..."
	rm -f $(TARGET)
	@echo "Clean complete."

# OS-specific settings for Ubuntu/Linux
ifeq ($(UNAME_S), Linux)
	@echo "Detected OS: Ubuntu/Linux"
	CXX := g++
endif

# OS-specific settings for macOS
ifeq ($(UNAME_S), Darwin)
	@echo "Detected OS: macOS"
	CXX := clang++
	# On macOS, libxml2 might be installed via brew
	LIBS += -L/usr/local/Cellar/libxml2/2.12.6/lib/
endif

# Build rule
all: $(TARGET)

$(TARGET): $(SRC)
	@echo "Building $(TARGET) for $(UNAME_S)..."
	$(CXX) $(CXXFLAGS) $(SRC) $(INCLUDES) $(LIBS) $(LDFLAGS) -o $(TARGET)
	@if [ $$? -eq 0 ]; then \
		echo "$(TARGET) build successful."; \
		echo "Running $(TARGET)..."; \
		./$(TARGET) > run.log 2>&1 || true; \
		if grep -q "AddressSanitizer" run.log; then \
			echo "ASan error detected during program execution."; \
		else \
			echo "Program ran successfully with no ASan errors."; \
		fi; \
	else \
		echo "$(TARGET) build failed."; \
	fi

EOF

echo "Makefile generated."

# Step 2: Build using the generated Makefile
echo "Building the project..."
make all

