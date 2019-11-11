AC_INIT([FriBidiXeTeX],
        [0.0.2],
        [https://github.com/vafa/fribidixetex/issues],
        [fribidixetex],
        [https://github.com/vafa/fribidixetex])

AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([foreign subdir-objects])
AM_SILENT_RULES([yes])

AC_PROG_CC
AC_PROG_RANLIB
PKG_PROG_PKG_CONFIG([0.20])

PKG_CHECK_MODULES(FRIBIDI, fribidi, , AC_MSG_ERROR([FriBiDi is not found]))

AC_CONFIG_FILES([Makefile])

AC_OUTPUT
