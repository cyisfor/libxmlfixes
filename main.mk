include coolmake/top.mk

OUT=wanted_tags
N=wanted_tags.gen
$(eval $(OBJECT))

$(call $(AUTOMAKE_SUBPROJECT), libxml2, libxml2)

$(O)/libxmlfixes.lo: | libxml2/include
CFLAGS+=-Ilibxml2/include

coolmake/head.mk: git-tools/funcs.sh coolmake/tail.mk libxml2/include

N:=wanted_tags libxmlfixes
OUT:=libxmlfixes.la
$(eval $(PROGRAM))

N=make-wanted
OUT=make-wanted
$(eval $(PROGRAM))

N=make-wanted
OUT=make-wanted
$(eval $(OBJECT))

$(O)/wanted_tags.gen.c $(O)/wanted_tags.gen.h: $(O)/make-wanted tags.wanted | $(O)
	$(call STATUS,Generate,wanted_tags)
	$(S)cd o && ../$(firstword $^) < ../$(lastword $^)

