all: build/Makefile
	$(MAKE) -C build && $(MAKE) -C build install

ifeq ($(prefix),)
prefix=$(realpath derp)
ifeq ($(prefix),)
prefix=$(realpath .)/derp
endif
endif

build/Makefile: | configure build
	cd build && ../configure -C --prefix=$(prefix) --without-python

configure: configure.ac Makefile.am
	autoreconf -i

build:
	mkdir $@

.PHONY: all
