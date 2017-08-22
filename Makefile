LINK=$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
COMPILE=$(CC) $(CFLAGS) `pkg-config --cflags $(P)` -c -o $@ $<

o/%.d: src/%.c | o
        $(COMPILE) -MG -MM

o/%.o: src/%.c | o
        $(COMPILE)

O=$(patsubst %,o/%.o,$N) | o

N=wanted_tags libxmlfixes
libxmlfixes.a: $O
	ar cr $@ $^

N=make-wanted
o/make-wanted: $O
	$(LINK)

o/wanted_tags.gen.c o/wanted_tags.gen.h: o/make-wanted src/tags.wanted | o
	cd o && ./make-wanted < ../src/tags.wanted

o:
	mkdir $@
