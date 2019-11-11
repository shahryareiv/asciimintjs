NULL =


bin_PROGRAMS = \
  fribidixetex \
  $(NULL)

fribidixetex_SOURCES = \
  src/fribidixetex-bidi.c \
  src/fribidixetex.c \
  src/fribidixetex-dict.c \
  src/fribidixetex-io.c \
  src/fribidixetex-util.c \
  src/fribidixetex-ignore.c \
  $(NULL)

AM_CPPFLAGS = \
  $(FRIBIDI_CFLAGS) \
  $(NULL)

LDADD = \
  $(FRIBIDI_LIBS) \
  $(NULL)

EXTRA_DIST = \
  GPLv2.txt \
  $(NULL)
