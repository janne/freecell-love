require "lib/button"
require "lib/card"
require "lib/game"
require "lib/pos"
require "lib/stack"
require "lib/func"

local dragged_card = nil
local draggingOffset = nil
local dragging_origin = nil
local state = game:new()
local history = {}

local buttons = {button:new(10, 10, 100, 50, "New Game", function()
    history = {}
    state = game:new()
end), button:new(120, 10, 100, 50, "Undo", function()
    if #history > 0 then
        state = table.remove(history) or state
    end
end)}

function love.update(dt)
    if dragged_card then
        dragged_card.pos = animated_pos:from_pos(pos:new(love.mouse.getPosition()) - draggingOffset)
        if not love.mouse.isDown(1) then
            if dragged_card.pos.x == dragging_origin.x and dragged_card.pos.y == dragging_origin.y then
                next_state = state:automove_card(dragged_card)
                if next_state ~= state then
                    table.insert(history, state)
                    next_state:trigger_animations()
                    state = next_state
                end
            else
                dragged_card.pos = animated_pos:from_pos(dragging_origin)
            end
            dragged_card = nil
            dragging_origin = nil
        end
    end

    if love.mouse.isDown(1) then
        local button = find(buttons, function(b)
            return b:has_mouse_over()
        end)
        if button then
            button.isPressed = true
        end
    end

    if not love.mouse.isDown(1) then
        local pressed = find(buttons, function(b)
            return b.isPressed
        end)
        if pressed then
            pressed.isPressed = false
            if pressed:has_mouse_over() then
                pressed:onClick()
            end
        end
    end

    if love.mouse.isDown(1) and not dragged_card then
        local border = pos:new(14, 14)
        local cards = state:top_cards()
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
    for_each(state:cards(), function(card)
        if card ~= dragged_card and not card.pos:is_animating() then
            love.graphics.draw(card.gfx, card.pos.x, card.pos.y, 0, card.scale.x, card.scale.y)
        end
    end)

    -- Draw the dragged and animated cards last so they appears on top
    for_each(state:cards(), function(card)
        if card == dragged_card or card.pos:is_animating() then
            love.graphics.draw(card.gfx, card.pos.x, card.pos.y, 0, card.scale.x, card.scale.y)
        end
    end)

    for_each(buttons, function(button)
        button:draw()
    end)
end
