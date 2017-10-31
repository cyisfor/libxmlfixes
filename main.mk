include coolmake/head.mk

o/wanted_tags.lo: o/%.lo: o/%.gen.c
	$(COMPILE)

$(call $(AUTOMAKE_SUBPROJECT), libxml2, libxml2)

o/libxmlfixes.lo: | libxml2/include
CFLAGS+=-Ilibxml2/include

coolmake/head.mk: git-tools/funcs.sh coolmake/tail.mk libxml2/include
	sh setup.sh # $@

coolmake/tail.mk libxml2/include: ;

git-tools/funcs.sh:
	git submodule update --init

N=wanted_tags libxmlfixes
libxmlfixes.la: $O 
	$(LINK)

N=make-wanted
o/make-wanted: $O
	$(LINK)

o/make-wanted.lo: make-wanted.c | o
	$(COMPILE)

o/wanted_tags.gen.c o/wanted_tags.gen.h: o/make-wanted tags.wanted | o
	$(call STATUS,Generate,wanted_tags)
	$(S)cd o && ../$(firstword $^) < ../$(lastword $^)

include coolmake/tail.mk

all: libxmlfixes.la
