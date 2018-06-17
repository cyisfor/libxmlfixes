AC_PREREQ([2.69])
AC_INIT([libxmlfixes], [0.d], [meh])
AC_CONFIG_SRCDIR([src/libxmlfixes.c])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([foreign subdir-objects])
LT_INIT([disable-shared])

# Checks for programs.
AC_PROG_CC
AC_PROG_LN_S

# Checks for libraries.
# get libxml2
git submodule update --init

# Checks for header files.
AC_CHECK_HEADERS([fcntl.h stdlib.h string.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL
AC_TYPE_SIZE_T
AC_TYPE_SSIZE_T

# Checks for library functions.
AC_FUNC_ALLOCA
AC_FUNC_ERROR_AT_LINE
AC_FUNC_FORK
AC_FUNC_MALLOC
AC_FUNC_MMAP
AC_FUNC_REALLOC
AC_CHECK_FUNCS([dup2 memchr munmap setenv strcasecmp strtol])

AC_CONFIG_FILES([Makefile])
AC_CONFIG_SUBDIRS([libxml2])
AC_OUTPUT
