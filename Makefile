CFLAGS+=-g
CFLAGS+=-Ilibxml2/include
LIBTOOL:=libtool --tag=CC --mode=
ifeq ($(V),)
S:=@
else
S:=
endif
define LINK
	@echo LINK $*
	$(S)$(LIBTOOL)link $(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
endef
define COMPILE
	@echo COMPILE $*
	$(S)$(LIBTOOL)compile $(CC) $(CFLAGS) -c -o $@ $<
endef






o/%.d: %.c | o
	$(COMPILE) -MG -MM

o/%.o: %.c | o
	$(COMPILE)

o/%.o: o/%.gen.c | o
	$(COMPILE)

O=$(patsubst %,o/%.o,$N) | o

N=wanted_tags libxmlfixes
libxmlfixes.la: $O
	ar cr $@ $^

N=make-wanted
o/make-wanted: $O
	$(LINK)

o/make-wanted.o: make-wanted.c | o
	$(CC) -c -o $@ $<

o/wanted_tags.gen.c o/wanted_tags.gen.h: o/make-wanted tags.wanted | o
	cd o && ./make-wanted < ../tags.wanted

o:
	mkdir $@
