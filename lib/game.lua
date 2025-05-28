require("lib/copy")

Game = {}
Game.__index = Game

local spacing = {}
for i = 1, 8 do
  spacing[i] = love.graphics.getWidth() / 8 * (i - 1)
end

function Game:new()
  local g = {
    homecells = { Stack:new(spacing[1] - 10, 60), Stack:new(spacing[2] - 10, 60), Stack:new(spacing[3] - 10, 60),
      Stack:new(spacing[4] - 10, 60) },
    freecells = { Stack:new(spacing[5] + 10, 60), Stack:new(spacing[6] + 10, 60), Stack:new(spacing[7] + 10, 60),
      Stack:new(spacing[8] + 10, 60) },
    tableau = { Stack:new(spacing[1], 200, true), Stack:new(spacing[2], 200, true), Stack:new(spacing[3], 200, true),
      Stack:new(spacing[4], 200, true), Stack:new(spacing[5], 200, true), Stack:new(spacing[6], 200, true),
      Stack:new(spacing[7], 200, true), Stack:new(spacing[8], 200, true) }
  }
  local cards = Stack:new()
  for i = 1, 52 do
    local card = Card:new(i)
    cards:insert(card)
  end
  cards:shuffle()
  for i, card in ipairs(cards) do
    local col = (i - 1) % 8 + 1
    g.tableau[col]:push(card)
  end
  return setmetatable(g, self)
end

local function remove_card(game, card)
  for _, list in ipairs({ game.freecells, game.homecells, game.tableau }) do
    for _, stack in ipairs(list) do
      for i, cell in ipairs(stack) do
        if cell == card then
          stack:remove(i)
          return
        end
      end
    end
  end
end

local function available_freecell(game)
  for _, stack in ipairs(game.freecells) do
    if #stack == 0 then
      return stack
    end
  end
  return nil
end

local function available_tableau(game, card)
  for i, stack in ipairs(game.tableau) do
    if #stack == 0 then
      return stack
    end
    if stack[#stack].rank == card.rank + 1 and (stack[#stack].suit % 2) ~= (card.suit % 2) then
      return stack
    end
  end
  return nil
end

local function available_homecell(game, card)
  for i, stack in ipairs(game.homecells) do
    if #stack == 0 and card.rank == 1 then
      return stack
    elseif #stack > 0 and stack[#stack].suit == card.suit and stack[#stack].rank + 1 == card.rank then
      return stack
    end
  end
  return nil
end

function Game:automove_card(card)
  local game = Util.copy(self)

  -- Homecells
  local stack = available_homecell(game, card)
  if stack then
    remove_card(game, card)
    stack:push(Util.copy(card))
    return game
  end
  -- Tableau
  local stack = available_tableau(game, card)
  if stack then
    remove_card(game, card)
    stack:push(Util.copy(card))
    return game
  end
  -- Freecells
  local stack = available_freecell(game)
  if stack then
    remove_card(game, card)
    stack:push(Util.copy(card))
    return game
  end
  return self
end

function Game:cards()
  local cards = List.new()
  for _, stack in ipairs(self.homecells) do
    for _, card in ipairs(stack) do
      cards:push(card)
    end
  end
  for _, stack in ipairs(self.freecells) do
    for _, card in ipairs(stack) do
      cards:push(card)
    end
  end
  for _, stack in ipairs(self.tableau) do
    for _, card in ipairs(stack) do
      cards:push(card)
    end
  end
  return cards
end

function Game:top_cards()
  local cards = {}
  for _, stack in ipairs(self.homecells) do
    if #stack > 0 then
      table.insert(cards, stack[#stack])
    end
  end
  for _, stack in ipairs(self.freecells) do
    if #stack > 0 then
      table.insert(cards, stack[#stack])
    end
  end
  for _, stack in ipairs(self.tableau) do
    if #stack > 0 then
      table.insert(cards, stack[#stack])
    end
  end
  return cards
end

function Game:trigger_animations()
  self:cards():for_each(function(card)
    if card.pos.target and not card.pos:is_animating() and
        (card.pos.target.x ~= card.pos.x or card.pos.target.y ~= card.pos.y) then
      card.pos:animateTo(card.pos.target)
    end
  end)
end
