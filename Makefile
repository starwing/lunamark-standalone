target = lunamark
objs = objs/lunamark.o objs/lpeg.o objs/slnudata.o objs/slnunico.o objs/scripts.o

LUA = lua

$(target) : $(objs)
	$(LD) $(LDFLAGS) -o $(target) $(objs)

$(objs) : objs
	mkdir objs

objs/lunamark.o : src/lunamark.c
	$(CC) $(CFLAGS) -c -o $@ $<

objs/lpeg.o : externals/lpeg/lpeg.c externals/lpeg/lpeg.h
	$(CC) $(CFLAGS) -c -o $@ $<

objs/slnudata.o : externals/slnunicode/slnudata.c
	$(CC) $(CFLAGS) -c -o $@ $<

objs/slnunico.o : externals/slnunicode/slnunico.c
	$(CC) $(CFLAGS) -c -o $@ $<

objs/scripts.o : src/scripts.c
	$(CC) $(CFLAGS) -c -o $@ $<

src/scripts.c : src/main_squished.lua

src/main_squished.lua : src/cosmo \
    			src/lunamark \
			src/alt-getopt.lua \
			src/cosmo.lua \
			src/main.lua \
			src/re.lua
	cd squish && $(MAKE)
	cd src && $(LUA) squish/squish

src/cosmo/ : externals/cosmo/src/cosmo/
	$(CP) $< $@

src/lunamark/ : externals/lunamark/lunamark/
	$(CP) $< $@

src/cosmo.lua : externals/cosmo/src/cosmo.lua
	$(CP) $< $@

src/lunamark.lua : externals/lunamark/lunamark.lua
	$(CP) $< $@

src/alt-getopt.lua : externals/alt-getopt/alt-getopt.lua
	$(CP) $< $@

src/re.lua : externals/lpeg/re.lua
	$(CP) $< $@

