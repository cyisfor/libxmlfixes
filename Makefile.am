ACLOCAL_AMFLAGS = -I m4

#AM_LIBTOOLFLAGS = --quiet --no-warnings

BUILT_SOURCES = wanted_tags.gen.c
wanted_tags.gen.c: make-wanted wanted_tags.gen.h $(srcdir)/tags.wanted
	./make-wanted $(dir $@) < $(srcdir)/tags.wanted
wanted_tags.gen.h: ;

noinst_PROGRAMS = make-wanted
lib_LTLIBRARIES = libxmlfixes.la

make_wanted_SOURCES = src/make-wanted.c

libxmlfixes_la_SOURCES = wanted_tags.gen.c src/libxmlfixes.c
libxmlfixes_la_CFLAGS = \
	-I $(srcdir)/libxml2/include \
	-I libxml2/include

libxmlfixes_la_HEADERS = \
	$(srcdir)/src/libxmlfixes.h \
	$(srcdir)/src/selectors.h

libxmlfixes_ladir = $(includedir)/libxmlfixes

libxmlfixes_la_LIBADD = libxml2/libxml2.la

SUBDIRS = libxml2
