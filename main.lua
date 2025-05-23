require "lib/pos"
require "lib/card"
require "lib/stack"

local dragged_card = nil
local draggingOffset = nil
local dragging_origin = nil
local freecells = {stack:new(420, 20), stack:new(520, 20), stack:new(620, 20), stack:new(720, 20)}
local homecells = {stack:new(20, 20), stack:new(120, 20), stack:new(220, 20), stack:new(320, 20)}
local tableau = {stack:new(20, 200, true), stack:new(120, 200, true), stack:new(220, 200, true),
                 stack:new(320, 200, true), stack:new(420, 200, true), stack:new(520, 200, true),
                 stack:new(620, 200, true), stack:new(720, 200, true)}
local hand = stack:new()

function love.load()
    for i = 1, 52 do
        local card = card:new(i)
        card.pos = animated_pos:new(375, 500)
        hand:insert(card)
    end
    hand:shuffle()
    for i, card in ipairs(hand) do
        local col = (i - 1) % 8 + 1
        tableau[col]:push(card)
    end
end

function matching_freecell()
    for _, stack in ipairs(freecells) do
        if #stack == 0 then
            return stack
        end
    end
    return nil
end

function remove_card(card)
    for _, list in ipairs({freecells, homecells, tableau}) do
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

function matching_tableau(card)
    for i, stack in ipairs(tableau) do
        if #stack == 0 then
            return stack
        end
        if stack[#stack].rank == card.rank + 1 and (stack[#stack].suit % 2) ~= (card.suit % 2) then
            -- error("Matching tableau")
            return stack
        end
    end
    return nil
end

function matching_homecell(card)
    for i, stack in ipairs(homecells) do
        if #stack == 0 and card.rank == 1 then
            return stack
        elseif #stack > 0 and stack[#stack].suit == card.suit and stack[#stack].rank + 1 == card.rank then
            return stack
        end
    end
    return nil
end

function automove_card(card)
    local stacks = {}
    -- Homecells
    local cells = matching_homecell(card)
    if (cells ~= nil) then
        table.insert(stacks, cells)
    end
    -- Tableau
    local cells = matching_tableau(card)
    if (cells ~= nil) then
        table.insert(stacks, cells)
    end
    -- Freecells
    local cells = matching_freecell()
    if (cells ~= nil) then
        table.insert(stacks, cells)
    end
    for i, s in ipairs(stacks) do
        if (s ~= nil) then
            remove_card(card)
            s:push(card)
            return
        end
    end
end

function love.update(dt)
    if dragged_card then
        dragged_card.pos = animated_pos:from_pos(pos:new(love.mouse.getPosition()) - draggingOffset)
        if not love.mouse.isDown(1) then
            if dragged_card.pos.x == dragging_origin.x and dragged_card.pos.y == dragging_origin.y then
                automove_card(dragged_card)
            end
            dragged_card = nil
            dragging_origin = nil
        end
    end

    if love.mouse.isDown(1) and not dragged_card then
        local border = pos:new(14, 14)
        for i = 52, 1, -1 do
            local card = hand[i]
            local mouse = pos:new(love.mouse.getPosition())
            if mouse > card.pos + border and mouse < card.pos + card.size - border then
                dragged_card = card
                dragging_origin = card.pos
                hand:remove(i)
                hand:insert(card)
                draggingOffset = mouse - card.pos
                break
            end
        end
    end

    animated_pos.update(dt)
end

function love.draw(dt)
    for _, card in ipairs(hand) do
        love.graphics.draw(card.gfx, card.pos.x, card.pos.y)
    end
end
