include coolmake/top.mk

VPATH+=$(O)

OUT=wanted_tags
N=wanted_tags.gen
$(eval $(OBJECT))

$(call $(AUTOMAKE_SUBPROJECT), libxml2, libxml2)

$(O)/libxmlfixes.lo: | libxml2/include
CFLAGS+=-Ilibxml2/include

coolmake/head.mk coolmake/tail.mk libxml2/include :
	sh setup.sh

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
