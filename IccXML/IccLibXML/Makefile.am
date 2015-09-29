## Process this file with automake to produce Makefile.in

lib_LTLIBRARIES = libIccXML.la

libIccXML_la_SOURCES = \
	IccIoXml.cpp \
	IccMpeXml.cpp \
	IccMpeXmlFactory.cpp \
	IccProfileXml.cpp \
	IccTagXml.cpp \
	IccTagXmlFactory.cpp \
	IccUtilXml.cpp

libIccXML_la_LDFLAGS = -version-info @LIBTOOL_VERSION@ \
	@SAMPLEICC_LIBS@ \
	@XML_LIBS@

libIccXMLincludedir = $(includedir)/IccXML

libIccXMLinclude_HEADERS = \
	IccIoXml.h \
	IccMpeXml.h \
	IccMpeXmlFactory.h \
	IccProfileXml.h \
	IccTagXml.h \
	IccTagXmlFactory.h \
	IccUtilXml.h \
	IccXmlConfig.h \
	IccLibXMLVer.h

INCLUDES = -I$(top_builddir) -I$(top_srcdir)/IccXML \
	@SAMPLEICC_CFLAGS@ \
	@XML_CFLAGS@

EXTRA_DIST = MainPage.h
