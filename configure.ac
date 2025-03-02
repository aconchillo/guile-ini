dnl   configuration script for Guile-INI
dnl   Process this file with autoconf to produce configure.
dnl

define(GUILE_INI_CONFIGURE_COPYRIGHT, [[
Copyright (C) 2021 Artyom V. Poptsov <poptsov.artyom@gmail.com>

This file is part of Guile-INI.

Guile-INI is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

Guile-INI is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with Guile-INI.  If not, see <http://www.gnu.org/licenses/>.
]])

AC_INIT([Guile-INI], [0.1.0], [poptsov.artyom@gmail.com],
                     [guile-ini],
                     [https://github.com/artyom-poptsov/guile-ini])

AC_COPYRIGHT(GUILE_INI_CONFIGURE_COPYRIGHT)
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([build-aux/m4])

AM_INIT_AUTOMAKE([gnu silent-rules -Wall -Wno-portability
                      color-tests])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])], [AC_SUBST([AM_DEFAULT_VERBOSITY],1)])

AC_ARG_WITH([guilesitedir],
            [AS_HELP_STRING([--with-guilesitedir],
                            [use the specified installation path for Guile modules])],
            [case "x$withval" in
             xyes|xno) guilesitedir="";;
             *)        guilesitedir="$withval";;
             esac],
             [guilesitedir=""])

GUILE_PKG([3.0 2.2])
GUILE_PROGS
GUILE_SITE_DIR

pkgdatadir="$datadir/$PACKAGE"
if test "x$guilesitedir" = "x"; then
   guilesitedir="$pkgdatadir"
fi
AC_SUBST([guilesitedir])

AC_CONFIG_FILES([
        Makefile
        build-aux/am/Makefile
        build-aux/Makefile
        build-aux/m4/Makefile
        modules/ini/Makefile
        modules/Makefile
])

dnl texinfo package required to make the documentation in Texinfo format.
AC_CHECK_PROG(MAKEINFO_CHECK, makeinfo, yes)
AS_IF([test x"$MAKEINFO_CHECK" != x"yes"],
            [ AC_MSG_ERROR([Please install texinfo before configuring])])

# Generate a Makefile, based on the results.
AC_OUTPUT

if test "$guilesitedir" != "$GUILE_SITE"; then
   # Guile has a different prefix than this module
   AC_MSG_WARN([]
   [The Guile modules will be installed in ${guilesitedir}.]
   [You should probably re-run `configure' with]
   [`--with-guilesitedir=$GUILE_SITE']
   [Otherwise, you will have to adjust the `GUILE_LOAD_PATH' environment]
   [variable.])
fi
