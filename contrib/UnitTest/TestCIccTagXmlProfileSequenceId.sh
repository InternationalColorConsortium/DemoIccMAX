#!/bin/sh
##################################################################################
#
# Author: David Hoyt
# Date: 21-APRIL-2025 1000 EDT by David Hoyt
# Unit Test for TestCIccTagXmlProfileSequenceId.sh (macOS + Ubuntu)
#
##
# Shell script to generate a Makefile, build the project, and run the program
#
#
# Intent: iccMAX CICD
#
#
#
#
#
#
#
##################################################################################

echo "Generating Makefile for Unit Test by TestCIccTagXmlProfileSequenceId"

cat << 'EOF' > Makefile
UNAME_S := $(shell uname -s)

# Base config
TARGET := TestCIccTagXmlProfileSequenceId
SRC := TestCIccTagXmlProfileSequenceId.cpp

# Default toolchain
CXX := g++
CXXFLAGS := -std=c++17 -g -fsanitize=address,undefined -fno-omit-frame-pointer

# Base include paths
INCLUDES := -I../IccProfLib -I../IccXML/IccLibXML
# Base library search paths and dependencies
LIBS := -L../Build/IccProfLib -L../Build/IccXML -lpthread -lIccProfLib2 -lIccXML2
# Runtime linker paths
LDFLAGS := -Wl,-rpath,/usr/local/lib -Wl,-rpath,../Build/IccProfLib -Wl,-rpath,../Build/IccXML
# Try to detect libxml2 using pkg-config
PKG_CFLAGS := $(shell pkg-config --cflags libxml-2.0 2>/dev/null)
PKG_LIBS := $(shell pkg-config --libs libxml-2.0 2>/dev/null)

# Fallback if pkg-config fails (assumes default install)
ifeq ($(PKG_CFLAGS),)
    INCLUDES += -I/usr/include/libxml2
else
    INCLUDES += $(PKG_CFLAGS)
endif

ifeq ($(PKG_LIBS),)
    LIBS += -lxml2
else
    LIBS += $(PKG_LIBS)
endif

# macOS-specific overrides
ifeq ($(UNAME_S), Darwin)
    CXX := /usr/bin/clang++
    CXXFLAGS := -std=c++17 -g -fsanitize=address -fno-omit-frame-pointer
    LDFLAGS := -Wl,-rpath,/usr/local/lib -Wl,-rpath,../Build/IccProfLib -Wl,-rpath,../Build/IccXML
endif

all: $(TARGET)

$(TARGET): $(SRC)
        @echo "Compiling for $(UNAME_S)..."
        $(CXX) $(CXXFLAGS) $(SRC) $(INCLUDES) $(LIBS) $(LDFLAGS) -o $(TARGET)
        @echo "Build complete."
        @echo "Running $(TARGET)..."
        ./$(TARGET) > run.log 2>&1 || true
        @if grep -q "AddressSanitizer" run.log; then \
                echo "ASan error detected."; \
        else \
                echo "Execution successful, no ASan errors."; \
        fi

clean:
        @echo "Cleaning..."
        rm -f $(TARGET) run.log
EOF

echo "Makefile generated."
echo "Building the project..."
make all
