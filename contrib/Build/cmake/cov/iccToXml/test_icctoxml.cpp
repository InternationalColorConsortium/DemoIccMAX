// File: test_icctoxml.cpp
//
// Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
//
// Written by David Hoyt 
// Date: 30-MAR-2025 1400 EDT
//
// Branch: PR121
// Intent: Makefile for building gtest instrumented iccToXml and checking LLVM coverage symbols
// Production: TRUE
// Runner: TRUE
//
//
// Updates:  Makefile for building gtest instrumented iccToXml and checking LLVM coverage symbols
//         
//
//
//
//
// Makefile for building gtest instrumented iccToXml and checking LLVM coverage symbols

#include <gtest/gtest.h>
#include "IccTagXml.h"  // Adjust or add additional headers from IccToXml if needed

// Dummy test to confirm GTest setup works
TEST(IccToXmlTest, BasicSanity) {
    EXPECT_TRUE(true);  // Replace with real checks later
}

// Entry point for Google Test
int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
