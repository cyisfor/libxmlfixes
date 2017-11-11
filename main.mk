include coolmake/top.mk

VPATH+=$(O)

$(O)/wanted_tags.gen.lo: $(O)/wanted_tags.gen.c | $(O)
	$(COMPILE)

$(call $(AUTOMAKE_SUBPROJECT), libxml2, libxml2)

$(O)/libxmlfixes.lo: | libxml2/include
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
