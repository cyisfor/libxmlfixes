include coolmake/top.mk

VPATH+=$(O)

OUT=wanted_tags
N=wanted_tags.gen
$(eval $(OBJECT))

$(call $(AUTOMAKE_SUBPROJECT), libxml2, libxml2)

$(O)/libxmlfixes.lo: | libxml2/include
CFLAGS+=-Ilibxml2/include

coolmake/head.mk: git-tools/funcs.sh coolmake/tail.mk libxml2/include

N:=wanted_tags libxmlfixes
OUT:=libxmlfixes.la
$(error $(PROGRAM))

N=make-wanted
OUT=make-wanted
$(eval $(PROGRAM))

N=make-wanted
OUT=make-wanted
$(eval $(OBJECT))

$(O)/wanted_tags.gen.c: $(O)/make-wanted $(O)/wanted_tags.gen.h $(TOP)tags.wanted  | $(O)
	$(call STATUS,Generate,wanted_tags)
	$(S)cd $(O) && ./$(notdir $(firstword $^)) < ../$(notdir $(lastword $^))

$(O)/wanted_tags.gen.h: ;
