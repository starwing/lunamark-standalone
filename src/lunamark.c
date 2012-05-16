/* Include the Lua API header files. */
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

extern const char main_squished_lua[];
extern size_t     main_squished_lua_len;

int luaopen_lpeg (lua_State *L);
int luaopen_unicode (lua_State *L);

int main( int argc, char *argv[] )
{
    lua_State *L = luaL_newstate();

    /* command line args */
    lua_newtable(L);
    if (argc > 0) {
      int i;
      for (i = 1; i < argc; i++) {
        lua_pushnumber(L, i);
        lua_pushstring(L, argv[i]);
        lua_rawset(L, -3);
      }
    }
    lua_setglobal(L, "arg");

    /* load the libs */
    luaL_openlibs(L);
    lua_getfield(L, LUA_REGISTRYINDEX, "_PRELOAD");
    lua_pushcfunction(L, luaopen_lpeg);
    lua_setfield(L, -2, "lpeg");
    lua_pushcfunction(L, luaopen_unicode);
    lua_setfield(L, -2, "unicode");
    lua_pop(L, 1);

    /* push debug.traceback */
    lua_getglobal(L, LUA_DBLIBNAME);
    lua_getfield(L, -1, "traceback");
    lua_remove(L, -2);

    if (luaL_loadfile(L, "src/main_squished.lua") != 0) {
    /*if (luaL_loadbuffer(L,*/
                /*main_squished_lua, main_squished_lua_len,*/
                /*"main_squished_lua") != 0) {*/
        const char *msg = lua_tostring(L, -1);
        printf("load main chunk: %s\n", msg);
        return 1;
    }

    if (lua_pcall(L, 0, 0, -2) != 0) {
        const char *msg = lua_tostring(L, -1);
        printf("eval main chunk: %s\n", msg);
        return 2;
    }

    lua_close(L);

    return 0;
}
/* cc: flags+='-Id:/lua51/include' */
