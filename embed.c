#include <stdlib.h>
#include <stdio.h>

/* Include the Lua API header files. */
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#include "lpeg.h"
#include "alt_getopt.lub.embed"
#include "cosmo.lub.embed"
#include "lunamark.lub.embed"
#include "script.lub.embed"

int main()
{
    int s=0;

    lua_State *L = lua_open();

    // load the libs
    luaL_openlibs(L);
    luaopen_lpeg(L);
    luaopen_unicode(L);

    luaL_loadbuffer(L, cosmo_lub, cosmo_lub_len, "cosmo_lub");
    luaL_loadbuffer(L, alt_getopt_lub, alt_getopt_lub_len, "alt_getopt_lub");
    luaL_loadbuffer(L, lunamark_lub, lunamark_lub_len, "lunamark_lub");
    luaL_loadbuffer(L, script_lub, script_lub_len, "script_lub");

    if (lua_pcall(L, 0, LUA_MULTRET, 0) != 0) {
      lua_error(L);
    }

//    printf("\nI am done with Lua in C.\n");

    lua_close(L);

    return 0;
}
