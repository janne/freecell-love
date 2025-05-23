require("lib/test")
require("lib/card")

stack = {}
stack.__index = stack

setmetatable(stack, {
    __index = table
})

math.randomseed(os.time())

function stack:new(x, y, spread)
    local s = {}
    s.pos = pos:new(x or 0, y or 0)
    s.spread = spread or false
    return setmetatable(s, self)
end

function stack:push(card)
    table.insert(self, card)
    local newPos = self.pos
    if self.spread then
        newPos = self.pos + pos:new(0, #self * 20)
    end
    if card.pos then
        card.pos:animateTo(newPos)
    else
        card.pos = animated_pos:from_pos(newPos)
    end
end

function stack:pop()
    return table.remove(self)
end

function stack:shuffle()
    for i = #self, 1, -1 do
        local j = math.random(i)
        self[i], self[j] = self[j], self[i]
    end
end

-- Test cases

it("allows adding cards", function()
    local s = stack:new()
    local c = card:new(1)
    s:insert(c)
    expect(#s, 1)
end)

it("allows removing cards", function()
    local s = stack:new()
    s:insert(card:new(1))
    s:insert(card:new(2))
    expect(#s, 2)
    s:remove(1)
    expect(#s, 1)
    expect(s[1].rank, 2)
end)
