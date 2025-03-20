/*!
 *  @file iccPngDump.cpp
 *  @brief IccMAX PNG Dump Utility
 *  @author David Hoyt
 *  @date 08 MAR 2025
 *  @version 2.0.1
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
 */

#pragma mark - Headers

/*!
* @brief Core and external libraries necessary for the fuzzer functionality.
*
* @details This section includes the necessary headers for the Foundation framework, UIKit, Core Graphics,
* standard input/output, standard library, memory management, mathematical functions,
* Boolean type, floating-point limits, and string functions. These libraries support
* image processing, UI interaction, and basic C operations essential for the application.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <png.h>
#include "IccCmm.h"
#include "IccUtil.h"
#include "IccDefs.h"
#include "IccProfLibVer.h"

#pragma mark - Traps

// Platform-specific trap macro for debugging fatal errors
#ifdef __x86_64__
    #define TRAP() asm volatile ("ud2")
#elif defined(__aarch64__)
    #define TRAP() asm volatile ("brk #0")
#else
    #define TRAP() abort()
#endif

#pragma mark - Logging

// Logging macros for error handling
#define LOG_ERROR(msg) do { fprintf(stderr, "[ERROR] %s\n", msg); } while (0)
#define BAIL_OUT(msg) do { LOG_ERROR(msg); TRAP(); } while (0)


// Function declarations
#pragma mark - Utility Functions
/**
 * Displays usage information for the program.
 */

void Usage();

/**
 * Safely exits the program with a given reason.
 * 
 * @param reason The reason for exiting.
 */

void safe_exit(const char *reason);

#pragma mark - PNG and ICC Profile Handling
/**
 * Extracts the ICC profile from a PNG image.
 *
 * @param png_ptr   Pointer to the PNG structure.
 * @param info_ptr  Pointer to the PNG info structure.
 * @param pProfMem  Output pointer to store the ICC profile data.
 * @param nLen      Output length of the extracted ICC profile.
 * @return          1 on success, 0 on failure.
 */
int ExtractIccProfile(png_structp png_ptr, png_infop info_ptr, unsigned char **pProfMem, unsigned int *nLen);


/**
 * Prints information about a given PNG file.
 *
 * @param png_ptr  Pointer to the PNG structure.
 * @param info_ptr Pointer to the PNG info structure.
 */
void PrintPngInfo(png_structp png_ptr, png_infop info_ptr);


/**
 * Prints details of an ICC profile extracted from a PNG image.
 *
 * @param pProfMem    Pointer to the ICC profile data.
 * @param nLen        Length of the ICC profile data.
 * @param outputFile  Path to the output file where information should be saved.
 */
void PrintIccProfileInfo(const unsigned char *pProfMem, unsigned int nLen, const char *outputFile);


#pragma mark - Main Program Execution

/**
 * Entry point of the iccPngDump program.
 *
 * This function handles command-line arguments, opens a PNG file,
 * validates its format, and extracts an embedded ICC profile if available.
 *
 * @param argc Argument count.
 * @param argv Argument vector.
 * @return 0 on success, non-zero on failure.
 */
int main(int argc, char* argv[]) {
    printf("[INFO] Starting iccPngDump...\n");

    // Ensure correct number of arguments
    if (argc < 2) {
        Usage();
        safe_exit("Missing input file argument.");
    }

    const char *inputFile = argv[1];
    const char *outputIccFile = (argc > 2) ? argv[2] : NULL;

    printf("[INFO] Opening PNG file: %s\n", inputFile);

    // Open the PNG file for reading
    FILE *fp = fopen(inputFile, "rb");
    if (!fp) {
        LOG_ERROR("File cannot be opened.");
        safe_exit("File error.");
    }

    // Read and validate PNG signature
    unsigned char header[8];
    if (fread(header, 1, 8, fp) != 8 || png_sig_cmp(header, 0, 8)) {
        LOG_ERROR("Not a valid PNG file.");
        fclose(fp);
        safe_exit("Invalid PNG format.");
    }

    // Initialize PNG read structure
    png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png_ptr) {
        fclose(fp);
        BAIL_OUT("Failed to create PNG read structure.");
    }

    // Initialize PNG info structure
    png_infop info_ptr = png_create_info_struct(png_ptr);
    if (!info_ptr) {
        png_destroy_read_struct(&png_ptr, NULL, NULL);
        fclose(fp);
        BAIL_OUT("Failed to create PNG info structure.");
    }

    // Set up error handling for libpng
    if (setjmp(png_jmpbuf(png_ptr))) {
        png_destroy_read_struct(&png_ptr, &info_ptr, NULL);
        fclose(fp);
        BAIL_OUT("LibPNG error encountered.");
    }

    // Initialize PNG I/O and process file signature bytes
    png_init_io(png_ptr, fp);
    png_set_sig_bytes(png_ptr, 8);
    png_read_info(png_ptr, info_ptr);

    // Print PNG metadata
    PrintPngInfo(png_ptr, info_ptr);

    // Attempt to extract ICC profile from the PNG file
    unsigned char *pProfMem = NULL;
    unsigned int nLen = 0;
    if (ExtractIccProfile(png_ptr, info_ptr, &pProfMem, &nLen)) {
        // If ICC profile found, process it
        PrintIccProfileInfo(pProfMem, nLen, outputIccFile);
        free(pProfMem);
    } else {
        printf("[INFO] No embedded ICC Profile found.\n");
    }

    // Cleanup PNG structures and close the file
    png_destroy_read_struct(&png_ptr, &info_ptr, NULL);
    fclose(fp);

    printf("[INFO] iccPngDump completed successfully.\n");
    return 0;
}


#pragma mark - Error Handling

// =====================================================================
// Function: safe_exit
// Description: Logs an error message and safely exits the program
// =====================================================================
/**
 * Logs an error message and exits the program safely.
 *
 * @param reason A string containing the reason for exiting.
 */
void safe_exit(const char *reason) {
    LOG_ERROR(reason);
    exit(EXIT_FAILURE);
}


#pragma mark - Utility Functions

// =====================================================================
// Function: Usage
// Description: Prints usage information for the program
// =====================================================================
/**
 * Displays usage information for the iccPngDump tool.
 *
 * This function provides details on the correct command-line syntax.
 */
void Usage() {
    printf("Usage: iccPngDump <input.png> [output.icc]\n");
    printf("  Extracts the ICC profile from a PNG file.\n");
    printf("  If an output file is provided, the ICC profile is saved.\n");
}

#pragma mark - ICC Profile Extraction

// =====================================================================
// Function: ExtractIccProfile
// Description: Extracts ICC profile data from a PNG image
// =====================================================================

/**
 * Extracts the embedded ICC profile from a PNG image.
 *
 * @param png_ptr    Pointer to the PNG read structure.
 * @param info_ptr   Pointer to the PNG info structure.
 * @param pProfMem   Output pointer to store the ICC profile data.
 * @param nLen       Output variable to store the profile data length.
 * @return           1 if an ICC profile is found and extracted successfully, 0 otherwise.
 */
int ExtractIccProfile(png_structp png_ptr, png_infop info_ptr, unsigned char **pProfMem, unsigned int *nLen) {
    png_charp profile_name;
    int compression_type;
    png_bytep profile_data;
    png_uint_32 profile_length;

    // Check if PNG contains an embedded ICC profile
    if (png_get_iCCP(png_ptr, info_ptr, &profile_name, &compression_type, &profile_data, &profile_length)) {
        if (profile_length == 0) {
            LOG_ERROR("Empty ICC profile found.");
            return 0;
        }

        // Allocate memory for the ICC profile data
        *nLen = profile_length;
        *pProfMem = (unsigned char*)malloc(profile_length);
        if (!(*pProfMem)) {
            LOG_ERROR("Memory allocation for ICC profile failed.");
            return 0;
        }

        // Copy the ICC profile data to the allocated memory
        memcpy(*pProfMem, profile_data, profile_length);
        printf("[INFO] ICC Profile extracted: %u bytes\n", profile_length);
        
        return 1;  // Successfully extracted ICC profile
    }

    return 0;  // No ICC profile found
}


#pragma mark - PNG Metadata Display

// =====================================================================
// Function: PrintPngInfo
// Description: Displays detailed PNG metadata
// =====================================================================

/**
 * Displays detailed metadata information about a PNG image.
 *
 * @param png_ptr   Pointer to the PNG read structure.
 * @param info_ptr  Pointer to the PNG info structure.
 */
void PrintPngInfo(png_structp png_ptr, png_infop info_ptr) {
    // Retrieve PNG metadata
    int width = png_get_image_width(png_ptr, info_ptr);
    int height = png_get_image_height(png_ptr, info_ptr);
    int bit_depth = png_get_bit_depth(png_ptr, info_ptr);
    int color_type = png_get_color_type(png_ptr, info_ptr);
    int interlace_type = png_get_interlace_type(png_ptr, info_ptr);

    printf("--------------------> PNG Image Metadata <---------------------------\n");
    printf("Size:              (%d x %d) pixels\n", width, height);
    printf("Bit Depth:         %d\n", bit_depth);

    // Decode color type
    printf("Color Type:        ");
    switch (color_type) {
        case PNG_COLOR_TYPE_GRAY:
            printf("Grayscale\n");
            break;
        case PNG_COLOR_TYPE_RGB:
            printf("RGB (Truecolor)\n");
            break;
        case PNG_COLOR_TYPE_PALETTE:
            printf("Indexed Color (Palette)\n");
            break;
        case PNG_COLOR_TYPE_GRAY_ALPHA:
            printf("Grayscale with Alpha\n");
            break;
        case PNG_COLOR_TYPE_RGB_ALPHA:
            printf("RGBA (Truecolor with Alpha)\n");
            break;
        default:
            printf("Unknown (%d)\n", color_type);
            break;
    }

    // Decode interlace type
    printf("Interlace Type:    ");
    switch (interlace_type) {
        case PNG_INTERLACE_NONE:
            printf("None\n");
            break;
        case PNG_INTERLACE_ADAM7:
            printf("Adam7 Interlacing\n");
            break;
        default:
            printf("Unknown (%d)\n", interlace_type);
            break;
    }

    printf("--------------------------------------------------------------------\n");
}


#pragma mark - ICC Profile Information Display

// =====================================================================
// Function: PrintIccProfileInfo
// Description: Parses and displays ICC profile data, and optionally saves it
// =====================================================================

/**
 * Parses and displays ICC profile metadata, and optionally saves it to a file.
 *
 * @param pProfMem   Pointer to the ICC profile data.
 * @param nLen       Length of the ICC profile data in bytes.
 * @param outputFile Path to the output file for saving the ICC profile (optional).
 */
void PrintIccProfileInfo(const unsigned char *pProfMem, unsigned int nLen, const char *outputFile) {
    printf("--------------------> ICC Profile Information <---------------------------\n");
    printf("Profile Size:      %u bytes\n", nLen);

    // Attempt to parse the ICC profile
    CIccProfile *pProfile = OpenIccProfile(pProfMem, nLen);
    if (!pProfile) {
        LOG_ERROR("Failed to parse ICC Profile.");
        return;
    }

    // Extract ICC header details
    icHeader *pHdr = &pProfile->m_Header;
    CIccInfo Fmt;

    printf(" Color Space:      %s\n", Fmt.GetColorSpaceSigName(pHdr->colorSpace));
    printf(" Colorimetric PCS: %s\n", Fmt.GetColorSpaceSigName(pHdr->pcs));
    printf(" Profile Version:  %d.%d.%d\n", 
           (pHdr->version >> 24) & 0xFF,   // Major version
           (pHdr->version >> 20) & 0x0F,   // Minor version
           (pHdr->version >> 16) & 0x0F);  // Sub-minor version

    delete pProfile;

    // If an output file is specified, save the ICC profile
    if (outputFile) {
        FILE *outFile = fopen(outputFile, "wb");
        if (!outFile) {
            LOG_ERROR("Unable to open output file for writing.");
            return;
        }
        fwrite(pProfMem, 1, nLen, outFile);
        fclose(outFile);
        printf("[INFO] ICC Profile saved to: %s\n", outputFile);
    }
    
    printf("--------------------------------------------------------------------\n");
}
