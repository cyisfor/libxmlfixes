include coolmake/top.mk

VPATH+=$(O)

$(O)/wanted_tags.gen.lo: $(O)/wanted_tags.gen.c | $(O)
	$(COMPILE)

$(call $(AUTOMAKE_SUBPROJECT), libxml2, libxml2)

$(O)/libxmlfixes.lo: | libxml2/include
CFLAGS+=-Ilibxml2/include

coolmake/head.mk: git-tools/funcs.sh coolmake/tail.mk libxml2/include

N:=libxmlfixes
NN:=wanted_tags.gen
OUT:=libxmlfixes.la
$(eval $(PROGRAM))

N=make-wanted
OUT=o/make-wanted
$(eval $(PROGRAM))

$(O)/wanted_tags.gen.c: $(O)/make-wanted $(O)/wanted_tags.gen.h $(TOP)tags.wanted  | $(O)
	$(call STATUS,Generate,wanted_tags)
	$(S)cd $(O) && ./$(notdir $(firstword $^)) < ../$(notdir $(lastword $^))

$(O)/wanted_tags.gen.h: ;
