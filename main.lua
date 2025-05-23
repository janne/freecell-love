require "lib/button"
require "lib/card"
require "lib/game"
require "lib/pos"
require "lib/stack"

local dragged_card = nil
local draggingOffset = nil
local dragging_origin = nil
local state = game:new()

local buttons = {button:new(10, 10, 100, 50, "New Game", function()
    state = game:new()
end)}

function love.update(dt)
    if dragged_card then
        dragged_card.pos = animated_pos:from_pos(pos:new(love.mouse.getPosition()) - draggingOffset)
        if not love.mouse.isDown(1) then
            if dragged_card.pos.x == dragging_origin.x and dragged_card.pos.y == dragging_origin.y then
                state:automove_card(dragged_card)
            else
                dragged_card.pos = animated_pos:from_pos(dragging_origin)
            end
            dragged_card = nil
            dragging_origin = nil
        end
    end

    if love.mouse.isDown(1) then
        for i, button in ipairs(buttons) do
            if button:has_mouse_over() then
                button.isPressed = true
            end
        end
    end

    if not love.mouse.isDown(1) then
        for i, button in ipairs(buttons) do
            if button.isPressed then
                button.isPressed = false
                if button:has_mouse_over() then
                    button:onClick()
                end
            end
        end
    end

    if love.mouse.isDown(1) and not dragged_card then
        local border = pos:new(14, 14)
        local cards = state:cards()
        for i = #cards, 1, -1 do
            local card = cards[i]
            local mouse = pos:new(love.mouse.getPosition())
            if mouse > card.pos + border and mouse < card.pos + card.size - border then
                dragged_card = card
                dragging_origin = card.pos
                draggingOffset = mouse - card.pos
                break
            end
        end
    end

    animated_pos.update(dt)
end

function love.draw(dt)
    for _, card in ipairs(state:cards()) do
        if (card ~= dragged_card and not card.pos:is_animating()) then
            love.graphics.draw(card.gfx, card.pos.x, card.pos.y, 0, card.scale.x, card.scale.y)
        end
    end
    for _, card in ipairs(state:cards()) do
        if (card == dragged_card or card.pos:is_animating()) then
            love.graphics.draw(card.gfx, card.pos.x, card.pos.y, 0, card.scale.x, card.scale.y)
        end
    end
    for i, button in ipairs(buttons) do
        button:draw()
    end
end
