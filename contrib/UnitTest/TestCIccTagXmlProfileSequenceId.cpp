/**
 * @file TestCIccTagXmlProfileSequenceId.cpp
 * @brief Unit tests for CIccTagXmlProfileSequenceId()
 * @author @h02332 | David Hoyt | @xsscx
 * @date 29 MAY  2024
 * @version 1.0.5
 *
 * This unit test is designed to verify the parsing functionality of the
 * CIccTagXmlProfileSequenceId class from the IccLibXML library. It uses libxml2 to
 * create a sample XML document and tests how the CIccTagXmlProfileSequenceId class
 * processes this input. The test checks for both correct and incorrect scenarios.
 *
 * Expected Outcomes:
 *   - When provided with a properly structured XML document, the ParseXml method
 *     should return true, indicating successful parsing and validation of the XML content.
 *   - If the XML structure is incorrect or critical elements are missing, the method
 *     should return false, indicating a failure to correctly parse the XML.
 *
 * Compile:
 *   clang++ -std=c++11 -g -fsanitize=address,undefined -fno-omit-frame-pointer \
 *    -o TestCIccTagXmlProfileSequenceId TestCIccTagXmlProfileSequenceId.cpp \
 *    -I/usr/local/include \
 *    -I/IccProfLib \
 *    -I/IccXML/IccLibXML \
 *    -L/Build/IccProfLib \
 *    -L/Build/IccXML \
 *    -L/usr/local/Cellar/libxml2/2.12.6/lib/ \
 *    -lIccProfLib2 -lIccXML2 -lpthread -lxml2
 *
 * Usage:
 *   Compile and run this file to perform the tests. The console output will display
 *   the test results, showing whether each scenario passed or failed.
 *
 * Comment: If you run this Code and think you've found a new, unique and distinct Bug...
 *          Please Submit a PR to increase improve the CIccTagXmlProfileSequenceId() Unit Test.
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
 */

#pragma mark - Headers

/**
@brief Core and external libraries necessary for the fuzzer functionality.

@details This section includes the necessary headers for the XML parsing library (libxml), the standard I/O stream
library, and a custom header for the CIccTagXmlProfileSequenceId class. These libraries are essential for handling XML
documents, performing standard input/output operations, and utilizing the custom functionality of the CIccTagXmlProfileSequenceId class.
*/
#include <libxml/parser.h>    // Includes libxml parser functions for XML parsing
#include <libxml/tree.h>      // Includes libxml tree functions for XML document handling
#include "IccTagXml.h"        // Includes custom header file for CIccTagXmlProfileSequenceId class definition
#include <iostream>           // Includes standard I/O stream library for console output
#include <string>             // Includes standard string library

#pragma mark - Main Entry

/**
@brief Main function to initiate unit tests for the CIccTagXmlProfileSequenceId class.

@details This function initializes the libxml library, creates a new XML document with a root node and a child node, and
tests the ParseXml method of the CIccTagXmlProfileSequenceId class. The test result is output to the console. Finally,
the function cleans up the XML document and the libxml parser to prevent memory leaks.

@return int - Returns 0 upon successful completion.
*/
int main() {
    std::cout << "Starting unit tests for CIccTagXmlProfileSequenceId...\n";

    // Initialize libxml library
    xmlInitParser();

    // Create a new XML document
    xmlDocPtr doc = xmlNewDoc(BAD_CAST "1.0");  // Create a new XML document with version 1.0
    xmlNodePtr rootNode = xmlNewNode(nullptr, BAD_CAST "ProfileSequenceId");  // Create the root node named "ProfileSequenceId"
    xmlDocSetRootElement(doc, rootNode);  // Set the root node as the document's root element

    // Create a child node named "ProfileIdDesc" with an attribute
    xmlNodePtr profileNode = xmlNewChild(rootNode, nullptr, BAD_CAST "ProfileIdDesc", nullptr);  // Create a child node under root node
    xmlNewProp(profileNode, BAD_CAST "id", BAD_CAST "12345");  // Add an attribute "id" with value "12345" to the child node

    // Create a CIccTagXmlProfileSequenceId object
    CIccTagXmlProfileSequenceId tag;
    std::string parseStr;

    // Test the parsing function
    bool parseResult = tag.ParseXml(rootNode, parseStr);  // Call the ParseXml method on the tag object with rootNode

    // Define the test results based on the parseResult
    if (!parseResult) {
        std::cout << "Test failed: ParseXml should not return false when a proper node is provided.\n";  // Output failure message if parsing fails
    } else {
        std::cout << "Test succeeded: ParseXml correctly handled the provided node.\n";  // Output success message if parsing succeeds
    }

    // Cleanup
    xmlFreeDoc(doc);  // Free the document to prevent memory leaks
    xmlCleanupParser();  // Cleanup the libxml parser

    return 0;  // Return success
}
