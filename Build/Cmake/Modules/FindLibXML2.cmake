# Distributed under the OSI-approved BSD 3-Clause License.  
# See https://cmake.org/licensing for details.

#.rst:
# FindLibXML2
# -----------
#
# Try to find the LibXML2 XML processing library.
#
# Once done, this will define:
#
#   LIBXML2_FOUND - System has LibXML2
#   LIBXML2_INCLUDE_DIR - The LibXML2 include directory
#   LIBXML2_LIBRARIES - The libraries needed to use LibXML2
#   LIBXML2_DEFINITIONS - Compiler switches required for using LibXML2
#   LIBXML2_XMLLINT_EXECUTABLE - The XML checking tool xmllint
#   LIBXML2_VERSION_STRING - Version of LibXML2 (since CMake 2.8.8)

# Use pkg-config if available
find_package(PkgConfig QUIET)
pkg_check_modules(PC_LIBXML QUIET libxml-2.0)
set(LIBXML2_DEFINITIONS ${PC_LIBXML_CFLAGS_OTHER})

# Find headers
find_path(LIBXML2_INCLUDE_DIR NAMES libxml/xpath.h
  HINTS
    ${PC_LIBXML_INCLUDEDIR}
    ${PC_LIBXML_INCLUDE_DIRS}
  PATH_SUFFIXES libxml2
)

# Find library
find_library(LIBXML2_LIBRARIES NAMES xml2 libxml2
  HINTS
    ${PC_LIBXML_LIBDIR}
    ${PC_LIBXML_LIBRARY_DIRS}
)

# Find xmllint executable
find_program(LIBXML2_XMLLINT_EXECUTABLE NAMES xmllint)

# Legacy compatibility
set(XMLLINT_EXECUTABLE "${LIBXML2_XMLLINT_EXECUTABLE}")

# Determine version
if(PC_LIBXML_VERSION)
  set(LIBXML2_VERSION_STRING ${PC_LIBXML_VERSION})
elseif(LIBXML2_INCLUDE_DIR AND EXISTS "${LIBXML2_INCLUDE_DIR}/libxml/xmlversion.h")
  file(STRINGS "${LIBXML2_INCLUDE_DIR}/libxml/xmlversion.h" libxml2_version_str
       REGEX "^#define[\t ]+LIBXML_DOTTED_VERSION[\t ]+\".*\"")
  string(REGEX REPLACE "^#define[\t ]+LIBXML_DOTTED_VERSION[\t ]+\"([^\"]*)\".*" "\\1"
         LIBXML2_VERSION_STRING "${libxml2_version_str}")
  unset(libxml2_version_str)
endif()

# Handle result
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibXml2
  REQUIRED_VARS LIBXML2_LIBRARIES LIBXML2_INCLUDE_DIR
  VERSION_VAR LIBXML2_VERSION_STRING
)

# Back-compat variable for any code checking the old name
set(LIBXML2_FOUND "${LibXml2_FOUND}")

mark_as_advanced(
  LIBXML2_INCLUDE_DIR 
  LIBXML2_LIBRARIES 
  LIBXML2_XMLLINT_EXECUTABLE
)
