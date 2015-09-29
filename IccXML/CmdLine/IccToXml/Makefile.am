## Process this file with automake to produce Makefile.in

bin_PROGRAMS = \
	iccToXml

INCLUDES = -I$(top_builddir) -I$(top_srcdir)/IccLibXML \
	@SAMPLEICC_CFLAGS@ \
	@XML_CFLAGS@

LDADD = -L$(top_builddir)/IccLibXML -lIccXML \
	@SAMPLEICC_LIBS@ \
	@XML_LIBS@

iccToXml_SOURCES = \
	IccToXml.cpp
