include coolmake/head.mk
include main.mk
include coolmake/tail.mk

git-tools/funcs.sh:
	git submodule update --init

$(O)/libxmlfixes.lo: $(TOP)libxml2/include/libxml/xmlversion.h

$(TOP)libxml2/include/libxml/xmlversion.h: $(TOP)libxml2/Makefile
	$(MAKE) -C $(TOP)libxml2

$(TOP)libxml2/Makefile: $(TOP)libxml2/configure
	./configure

$(TOP)libxml2/configure: | $(TOP)libxml2/
	cd $(TOP)libxml2 && sh autogen.sh --disable-shared --enable-static

$(TOP)libxml2/:
	sh setup.sh

coolmake/head.mk: coolmake/tail.mk coolmake/top.mk | libxml2/include
	sh setup.sh
coolmake/tail.mk coolmake/top.mk libxml2/include: ;

all: libxmlfixes.la
