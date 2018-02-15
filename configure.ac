#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_INIT(cbox, 0.1.0)
AM_INIT_AUTOMAKE([foreign])
AC_PROG_RANLIB

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AC_PROG_CPP
AC_PROG_INSTALL
AC_PROG_AWK
AC_PROG_MKDIR_P
AC_PROG_RANLIB
AC_PROG_MAKE_SET

AC_LANG_C
AC_LANG_CPLUSPLUS

# Checks for libraries.

# Checks for header files.
AC_CHECK_HEADERS(pthread.h)

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.
AC_CHECK_LIB(stdc++, main)
AC_CHECK_LIB(pthread, pthread_create)
AC_CHECK_LIB(pthread, pthread_join)

# Set some values

LIBS="-pthread -Llib"
CFLAGS="-std=c11 -O2 -Wall -fPIC -Iinclude"
CPPFLAGS="-Iinclude"
CXXFLAGS="-std=c++11 -O2 -Wall -fPIC"
LDFLAGS="-shared"

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
