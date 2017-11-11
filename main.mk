include coolmake/top.mk

VPATH+=$(O)

$(O)/wanted_tags.gen.lo: $(O)/wanted_tags.gen.c | $(O)
	$(COMPILE)

$(call $(AUTOMAKE_SUBPROJECT), libxml2, libxml2)

CFLAGS+=-Ilibxml2/include

N:=wanted_tags.gen libxmlfixes
OUT:=libxmlfixes.la
$(eval $(PROGRAM))

N=make-wanted
OUT=o/make-wanted
$(eval $(PROGRAM))

$(O)/wanted_tags.gen.c: $(O)/make-wanted $(O)/wanted_tags.gen.h $(TOP)tags.wanted  | $(O)
	$(call STATUS,Generate,wanted_tags)
	$(S)$(firstword $^) $(dir $@) < $(lastword $^)

$(O)/wanted_tags.gen.h: ;

$(O)/libxmlfixes.lo: $(TOP)libxml2/include/libxml/xmlversion.h

$(TOP)libxml2/include/libxml/xmlversion.h: $(TOP)libxml2/Makefile
	$(MAKE) -C $(TOP)libxml2

$(TOP)libxml2/Makefile: $(TOP)libxml2/configure
	./configure

$(TOP)libxml2/configure: | $(TOP)libxml2/
	cd $(TOP)libxml2 && sh autogen.sh --disable-shared --enable-static

$(TOP)libxml2/:
	sh setup.sh
