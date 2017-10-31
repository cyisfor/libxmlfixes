$(TOP)o/wanted_tags.lo: o/%.lo: o/%.gen.c
	$(COMPILE)

$(call $(AUTOMAKE_SUBPROJECT), libxml2, libxml2)

$(TOP)o/libxmlfixes.lo: | libxml2/include
CFLAGS+=-Ilibxml2/include

coolmake/head.mk: git-tools/funcs.sh coolmake/tail.mk libxml2/include

N=wanted_tags libxmlfixes
$(TOP)libxmlfixes.la: $O 
	$(LINK)

N=make-wanted
$(TOP)o/make-wanted: $O
	$(LINK)

$(TOP)o/make-wanted.lo: make-wanted.c | o
	$(COMPILE)

$(TOP)o/wanted_tags.gen.c o/wanted_tags.gen.h: o/make-wanted tags.wanted | o
	$(call STATUS,Generate,wanted_tags)
	$(S)cd o && ../$(firstword $^) < ../$(lastword $^)

