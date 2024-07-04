# nvim-rubocop-textwidth

This LazyVim plugin will wait until a ruby file is opened and then check for a
`.rubocop.yml` and if it finds one will load it, and check the settings for the
configured `Layout/LineLength` and then set `vim.opt.textwidth` to match.

## Installing

On macos with brew it refuses to install lua@5.1 since there is a newer version,
which is what is being used by nvim and therefore luarocks so that we can
install lyaml. `lyaml` is required to parse the `.rubocop.yml` file.

To get this working I did the following on my macos machine:

```
❯ luarocks remove lyaml
Checking stability of dependencies in the absence of
lyaml 6.2.8-1...

Removing lyaml 6.2.8-1...
Removal successful.

❯ luarocks install lyaml YAML_DIR=/opt/homebrew --lua-version=5.1 --force


Installing https://luarocks.org/lyaml-6.2.8-1.src.rock

lyaml 6.2.8-1 depends on lua >= 5.1, < 5.5 (5.1-1 provided by VM: success)
/opt/homebrew/bin/luajit build-aux/luke package="lyaml" version="6.2.8" PREFIX="/Users/nick/.luarocks/lib/luarocks/rocks-5.1/lyaml/6.2.8-1" CFLAGS="-O2 -fPIC" LIBFLAG="-bundle -undefined dynamic_lookup -all_load" LIB_EXTENSION="so" OBJ_EXTENSION="o" LUA="/opt/homebrew/bin/luajit" LUA_DIR="/Users/nick/.luarocks/lib/luarocks/rocks-5.1/lyaml/6.2.8-1/lua" LUA_INCDIR="/opt/homebrew/include/luajit-2.1" YAML_DIR="/opt/homebrew" YAML_INCDIR="/opt/homebrew/include" YAML_LIBDIR="/opt/homebrew/lib"
creating build-aux/config.ld
env MACOSX_DEPLOYMENT_TARGET=11.0 gcc -O2 -fPIC -bundle -undefined dynamic_lookup -all_load   -D_BSD_SOURCE -DPACKAGE='"lyaml"' -D_DARWIN_C_SOURCE -DVERSION='"6.2.8"' -DNDEBUG -D_FORTIFY_SOURCE=2 -Iext/include -I/opt/homebrew/include/luajit-2.1 -I/opt/homebrew/include ext/yaml/yaml.c ext/yaml/emitter.c ext/yaml/parser.c ext/yaml/scanner.c -o macosx/yaml.so  -L/opt/homebrew/lib  -lyaml
true -c build-aux/config.ld .
/opt/homebrew/bin/luajit build-aux/luke install --quiet INST_LIBDIR="/Users/nick/.luarocks/lib/luarocks/rocks-5.1/lyaml/6.2.8-1/lib" INST_LUADIR="/Users/nick/.luarocks/lib/luarocks/rocks-5.1/lyaml/6.2.8-1/lua"
lyaml 6.2.8-1 is now installed in /Users/nick/.luarocks (license: MIT/X11)
```

We can see from the above output that `lyaml` was installed into
`/Users/nick/.luarocks`. Then I put the following in my `init.lua` so that nvim
can find `lyaml`.

```
-- LuaRocks paths for the user-specific installation
local home = os.getenv("HOME")
package.path = home
  .. "/.luarocks/share/lua/5.1/?.lua;"
  .. home
  .. "/.luarocks/share/lua/5.1/?/init.lua;"
  .. package.path

package.cpath = home .. "/.luarocks/lib/lua/5.1/?.so;" .. package.cpath
```

Lastly, the trick to getting LazyVim to load the luarocks package was to add a
dependency with a `rocks = "lyaml"`, and we'll set the dependency as
`plenary.nvim` since a lot of other plugins use it and therefore it will
probably already be loaded.

```
return {
	"nickpoorman/nvim-rubocop-textwidth",
	ft = "ruby", -- Load this plugin for Ruby files only
	dependencies = {
		{ "nvim-lua/plenary.nvim", rocks = "lyaml" },
	},
	config = function()
		require("rubocop_textwidth").setup()
	end,
}
```
