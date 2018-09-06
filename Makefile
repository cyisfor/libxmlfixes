all: build/Makefile
	$(MAKE) -C build && $(MAKE) -C build install

ifeq ($(prefix),)
prefix=$(realpath derp)
ifeq ($(prefix),)
prefix=$(realpath .)/derp
endif
endif

build/Makefile: configure | build
	cd build && ../configure -C --prefix=$(prefix) --without-python

configure: configure.ac Makefile.in 
	autoconf
	touch $@

config.h.in:
	autoheader

Makefile.in: Makefile.am aclocal.m4 config.h.in
	automake --add-missing

aclocal.m4: m4/libtool.m4
	aclocal -I m4

m4/libtool.m4:
	libtoolize --automake

build:
	mkdir $@

.PHONY: all
