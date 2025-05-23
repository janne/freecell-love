require "lib/pos"
require "lib/card"

local animateCard = 1
local animateTimer = 0
local draggedCard = nil
local draggingOffset = nil
local cards = {}

function love.load()
    for i = 1, 52 do
        local card = card:new(i)
        card.startPos = pos:new((card.rank - 1) * 800 / 13, card.suit * 600 / 5)
        table.insert(cards, card)
    end
end

function love.update(dt)
    if (animateCard <= #cards) then
        animateTimer = animateTimer + dt
        if (animateTimer > 0.1) then
            local card = cards[animateCard]
            card.pos:animateTo(card.startPos)
            animateTimer = 0
            animateCard = animateCard + 1
        end
    end

    if draggedCard then
        draggedCard.pos = animated_pos:from_pos(pos:new(love.mouse.getPosition()) - draggingOffset)
        if not love.mouse.isDown(1) then
            draggedCard = nil
        end
    end

    if love.mouse.isDown(1) and not draggedCard then
        local border = pos:new(14, 14)
        for i = 52, 1, -1 do
            local card = cards[i]
            local mouse = pos:new(love.mouse.getPosition())
            if mouse > card.pos + border and mouse < card.pos + card.size - border then
                draggedCard = card
                table.remove(cards, i)
                table.insert(cards, card)
                draggingOffset = mouse - card.pos
                break
            end
        end
    end

    if love.mouse.isDown(2) and not draggedCard then
        for i = 1, 52 do
            local card = cards[i]
            card.pos:animateTo(card.startPos)
        end
    end

    animated_pos.update(dt)
end

function love.draw(dt)
    for _, card in ipairs(cards) do
        love.graphics.draw(card.gfx, card.pos.x, card.pos.y)
    end
end
