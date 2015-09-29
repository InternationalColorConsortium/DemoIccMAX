dnl Process this file with autoconf to produce a configure script.
AC_INIT(CmdLine/IccToXml/IccToXml.cpp)

dnl Checks for target
AC_CANONICAL_TARGET

ICCXML_MAJOR_VERSION=0
ICCXML_MINOR_VERSION=9
ICCXML_MICRO_VERSION=6

ICCXML_VERSION=$ICCXML_MAJOR_VERSION.$ICCXML_MINOR_VERSION.${ICCXML_MICRO_VERSION}
AC_SUBST(ICCXML_VERSION)
AC_SUBST(ICCXML_MAJOR_VERSION)
AC_SUBST(ICCXML_MINOR_VERSION)
AC_SUBST(ICCXML_MICRO_VERSION)

LIBTOOL_CURRENT=2
LIBTOOL_REVISION=3
LIBTOOL_AGE=0
LIBTOOL_VERSION=$LIBTOOL_CURRENT:$LIBTOOL_REVISION:$LIBTOOL_AGE
AC_SUBST(LIBTOOL_VERSION)

dnl GNU automake support.
AM_INIT_AUTOMAKE(IccXML, ${ICCXML_VERSION})
AM_MAINTAINER_MODE

dnl Checks for programs.
AC_PROG_CXX
AC_PROG_INSTALL
AC_PROG_CC
AC_PROG_LN_S
AM_PROG_LIBTOOL
AC_PROG_MAKE_SET

dnl Checks for libraries.

dnl Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS(limits.h unistd.h)

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE
AC_TYPE_SIZE_T

dnl Checks for library functions.
AC_CHECK_FUNCS(strerror)

ERROR=0

echo ""
echo PKG_CONFIG_PATH = $PKG_CONFIG_PATH
echo ""
if test -z "$PKG_CONFIG_PATH"; then
  PKG_CONFIG_PATH="$libdir/pkgconfig"
else
  PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$libdir/pkgconfig"
fi

export PKG_CONFIG_PATH
AC_PATH_PROG(PKG_CONFIG, pkg-config, no)
if test "x$PKG_CONFIG" == "xno"; then
  AC_MSG_WARN([
*** Check for pkg-config failed. Many packages requires it.
*** You can download it from http://pkgconfig.sourceforge.net/  .])
  ERROR=1
fi

PKG_CHECK_MODULES(SAMPLEICC, [sampleicc >= 1.6.0],
  # succss
  v=`$PKG_CONFIG --modversion sampleicc`
  AC_MSG_RESULT([checking for SampleICC... $v yes]),
  # fail
  SAMPLE=1
  ERROR=1
  AC_MSG_WARN([
*** Check for SampleICC failed.
*** You can download it from http://sampleicc.sourceforge.net/ .]) )

PKG_CHECK_MODULES(XML, [libxml-2.0 >= 1],
  # succss
  v=`$PKG_CONFIG --modversion libxml-2.0`
  AC_MSG_RESULT([checking for libxml-2.0... $v yes]),
  # fail
  XML=1
  ERROR=1
  AC_MSG_WARN([
*** Check for libxml-2.0 failed.
*** You can download it from http://www.xmlsoft.org/ .]) )


dnl Platform-specific stuff
case "$host" in
*irix*) 
  AC_DEFINE(PLATFORM_IRIX) 
  ;;
*solaris*) 
  AC_DEFINE(PLATFORM_SUNOS5) 
  ;;
*osf*) 
  AC_DEFINE(PLATFORM_OSF1) 
  ;;
*darwin*) 
  AC_DEFINE(PLATFORM_DARWIN_PPC) 
  OSX_APPLICATION_LIBS="-framework ApplicationServices"
  ;;
esac

dnl Processor-specific optimizations
AC_MSG_CHECKING(for processor-specific optimizations)
case $target_cpu in
i686) EXTRA_CPU_CFLAGS=$(if $CC -march=i686 -S -o /dev/null -xc /dev/null > /dev/null; then echo "-march=i686"; fi) ;;
*athlon*)  EXTRA_CPU_CFLAGS=$(if $CC -march=i686 -S -o /dev/null -xc /dev/null > /dev/null; then echo "-march=i686"; fi) ;;
esac
AC_MSG_RESULT([$EXTRA_CPU_CFLAGS])

AM_CFLAGS="$EXTRA_OPT_CFLAGS $EXTRA_CPU_CFLAGS"
AM_CXXFLAGS="$EXTRA_OPT_CFLAGS $EXTRA_CPU_CFLAGS"

AC_SUBST(AM_CFLAGS)
AC_SUBST(AM_CXXFLAGS)
AC_SUBST(OSX_APPLICATION_LIBS)

if test $ERROR -ne 0 ; then
  AC_MSG_ERROR([ !!! Something went wrong during configuration !!!
  echo Please check above messages.])
fi

AC_OUTPUT([
Makefile
iccxml.pc
IccLibXML/Makefile
CmdLine/Makefile
CmdLine/IccToXml/Makefile
CmdLine/IccFromXml/Makefile
])
