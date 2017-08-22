LINK=$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
COMPILE=$(CC) $(CFLAGS) `pkg-config --cflags $(P)` -c -o $@ $<

o/%.d: %.c | o
	$(COMPILE) -MG -MM

o/%.o: %.c | o
	$(COMPILE)

o/%.o: o/%.gen.c | o
	$(COMPILE)

O=$(patsubst %,o/%.o,$N) | o

N=wanted_tags libxmlfixes
libxmlfixes.a: $O
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
