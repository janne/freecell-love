require("lib/pos")
require("lib/animated_pos")

card = {}
card.__index = card

local suits = {"Clubs", "Diamonds", "Hearts", "Spades"}

function card:new(index, initial_pos)
    local suit = math.floor((index - 1) / 13) + 1
    local rank = (index - 1) % 13 + 1
    local gfx = love.graphics.newImage("gfx/cards/" .. suits[suit] .. " " .. rank .. ".png")
    return setmetatable({
        suit = suit,
        rank = rank,
        pos = animated_pos:new(initial_pos),
        startPos = initial_pos or pos:new(),
        target = nil,
        size = pos:new(gfx:getWidth(), gfx:getHeight()),
        gfx = gfx
    }, self)
end
