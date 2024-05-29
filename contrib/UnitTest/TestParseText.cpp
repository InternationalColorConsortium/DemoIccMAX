/**
 *  @file TestParseText.cpp
 *  @brief Unit Test for ParseText()
 *  @author @h02332 | David Hoyt | @xsscx
 *  @date 24 MAY 2024
 *  @version 1.0.2
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Compile: clang++ -std=c++17 -fsanitize=address -isysroot $(xcrun --show-sdk-path) -I$(xcrun --show-sdk-path)/usr/include/c++/v1 TestParseText.cpp -o TestParseText

 *
 *
 */

#include <iostream>
#include <cstring>
#include <cmath>

// Mock the required environment and dependencies
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

