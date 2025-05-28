require("lib/pos")

Card = {}
Card.__index = Card

local suits = { "Clubs", "Diamonds", "Spades", "Hearts" }

function Card:new(index, initial_pos)
  local suit = math.floor((index - 1) / 13) + 1
  local rank = (index - 1) % 13 + 1
  local gfx = love.graphics.newImage("gfx/cards/" .. suits[suit] .. " " .. rank .. ".png")
  local scale = Pos:new(1.9, 1.8)
  return setmetatable({
    suit = suit,
    rank = rank,
    pos = nil,
    target = nil,
    size = Pos:new(gfx:getWidth(), gfx:getHeight()) * scale,
    scale = scale,
    gfx = gfx
  }, self)
end

function Card:__eq(other)
  return self.suit == other.suit and self.rank == other.rank
end
