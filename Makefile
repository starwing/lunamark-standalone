EXE = .exe
target = lunamark$(EXE)
objs = objs/lunamark.o objs/lpeg.o objs/slnunico.o objs/scripts.o

SQUISH_V = squish-14f827efadf2
LUA_V = lua-5.2.0
LUA = $(LUA_V)/src/lua$(EXE)
PLAT = generic

CC = gcc
LD = gcc
CP = cp
RM = rm

CFLAGS = -O2 -Wall -I$(LUA_V)/src $(MYCFLAGS)
LIBS = -L$(LUA_V)/src -llua

$(target) : objs $(objs) $(LUA_V)/src/liblua.a
	$(LD) $(LDFLAGS) -o $(target) $(objs) $(LIBS)

clean:
	-$(RM) -fr $(SQUISH_V)/squish $(SQUISH_V)/squish.debug \
	    $(SQUISH_V)/gunzip.lua
	-$(RM) -fr $(LUA_V)/src/*.o $(LUA_V)/src/*.a \
	    $(LUA_V)/src/*.exe
	-$(RM) -fr objs $(target) src/cosmo src/lunamark \
	    src/cosmo.lua src/lunamark.lua \
	    src/alt_getopt.lua src/re.lua \
	    src/main_squished.lua src/scripts.c

objs:
	mkdir objs

objs/lunamark.o : src/lunamark.c
	$(CC) $(CFLAGS) -c -o $@ $<

objs/lpeg.o : externals/lpeg/lpeg.c externals/lpeg/lpeg.h
	$(CC) $(CFLAGS) -c -o $@ $<

objs/slnunico.o : externals/slnunicode/slnunico.c
	$(CC) $(CFLAGS) -c -o $@ $<

objs/scripts.o : src/scripts.c
	$(CC) $(CFLAGS) -c -o $@ $<

src/scripts.c : src/main_squished.lua $(LUA)
	$(LUA) src/bin2c.lua -n main_squished_lua -o $@ $<

src/main_squished.lua : $(LUA) $(SQUISH_V)/squish \
			src/cosmo \
    			src/lunamark \
			src/alt_getopt.lua \
			src/cosmo.lua \
			src/lunamark.lua \
			src/main.lua \
			src/re.lua
	cd src && ../$(LUA) ../$(SQUISH_V)/squish

$(LUA) $(LUA_V)/src/liblua.a: $(LUA_V)
	cd $(LUA_V) && $(MAKE) $(PLAT)

$(SQUISH_V)/squish:
	cd $(SQUISH_V) && $(MAKE)

src/cosmo : externals/cosmo/src/cosmo
	$(CP) -r $< $@

src/lunamark : externals/lunamark/lunamark
	$(CP) -r $< $@

src/cosmo.lua : externals/cosmo/src/cosmo.lua
	$(CP) $< $@

src/lunamark.lua : externals/lunamark/lunamark.lua
	$(CP) $< $@

src/alt_getopt.lua : externals/alt-getopt/alt_getopt.lua
	$(CP) $< $@

src/re.lua : externals/lpeg/re.lua
	$(CP) $< $@

