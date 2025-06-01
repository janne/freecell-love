package = "freecell-love"
version = "1-0"
source = {
   url = "git+ssh://git@github.com/janne/freecell-love.git"
}
description = {
   summary = "A Freecell solitaire game implemented in Lua with [LÖVE](https://love2d.org/).",
   detailed = "A Freecell solitaire game implemented in Lua with [LÖVE](https://love2d.org/).",
   homepage = "*** please enter a project homepage ***",
   license = "MIT"
}

dependencies = {
    "lua >= 5.1",
    "busted >= 2.2",
}

build = {
    type = "builtin"
}