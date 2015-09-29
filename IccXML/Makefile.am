## Process this file with automake to produce Makefile.in

SUBDIRS = \
	IccLibXML \
	CmdLine

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = iccxml.pc

EXTRA_DIST = bootstrap \
	XMLSchema/SampleIccRELAX.rnc \
	XMLSchema/SampleIccRELAX.rng

dist-hook:
	rm -fr `find $(distdir) -name .DS_Store -or -name .svn`
