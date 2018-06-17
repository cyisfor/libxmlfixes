wanted_tags.gen.c: make-wanted wanted_tags.gen.h tags.wanted
	./make-wanted $(dir $@) < tags.wanted
wanted_tags.gen.h: ;

noinst_PROGRAMS = make-wanted
lib_LTLIBRARIES = libxmlfixes.la

make_wanted_SOURCES = make-wanted.c

libxmlfixes_la_SOURCES = wanted_tags.gen.c libxmlfixes.c
libxmlfixes_la_CFLAGS = -I $(srcdir)/libxml2/include
libxmlfixes_la_LIBADD = libxml2/libxml2.la
