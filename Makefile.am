ACLOCAL_AMFLAGS = -I m4

BUILT_SOURCES = wanted_tags.gen.c
wanted_tags.gen.c: make-wanted wanted_tags.gen.h $(srcdir)/tags.wanted
	./make-wanted $(dir $@) < $(srcdir)/tags.wanted
wanted_tags.gen.h: ;

noinst_PROGRAMS = make-wanted
lib_LTLIBRARIES = libxmlfixes.la

make_wanted_SOURCES = src/make-wanted.c

libxmlfixes_la_SOURCES = wanted_tags.gen.c src/libxmlfixes.c
libxmlfixes_la_CFLAGS = -I $(srcdir)/libxml2/include \
	-I $(srcdir)/libxml2/build/include
libxmlfixes_la_HEADERS = \
	$(srcdir)/src/libxmlfixes.h \
	$(srcdir)/src/selectors.h
libxmlfixes_ladir = $(includedir)/libxmlfixes

libxmlfixes_la_LIBADD = $(srcdir)/libxml2/lib/libxml2.la

libxml2/libxml2.la:
	$(MAKE) -C libxml2/build
