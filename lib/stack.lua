require("lib/card")
require("lib/animated_pos")

Stack = {}
Stack.__index = Stack

setmetatable(Stack, {
  __index = table
})

math.randomseed(os.time())

function Stack:new(x, y, spread)
  local s = {}
  s.pos = Pos:new(x or 0, y or 0)
  s.spread = spread or false
  return setmetatable(s, self)
end

function Stack:push(card)
  table.insert(self, card)
  local new_pos = self.pos
  if self.spread then
    new_pos = self.pos + Pos:new(0, #self * 25)
  end
  if card.pos then
    card.pos:animateTo(new_pos)
  else
    card.pos = AnimatedPos:from_pos(new_pos)
  end
end

function Stack:pop()
  return table.remove(self)
end

function Stack:shuffle()
  for i = #self, 1, -1 do
    local j = math.random(i)
    self[i], self[j] = self[j], self[i]
  end
end
