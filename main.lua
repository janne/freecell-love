require "lib/pos"

function love.load()
    cards = {}
    for row, suit in ipairs({"Clubs", "Diamonds", "Hearts", "Spades"}) do
        for rank = 1, 13 do
            local gfx = love.graphics.newImage("gfx/cards/" .. suit .. " " .. rank .. ".png")
            local card = {
                pos = pos:new(),
                startPos = pos:new((rank - 1) * 800 / 13, row * 600 / 5),
                gfx = gfx,
                size = pos:new(gfx:getWidth(), gfx:getHeight())
            }
            function card:animateTo(pos)
                if (pos ~= self.pos) then
                    self.target = pos
                    self.animation = true
                end
            end
            table.insert(cards, card)
        end
    end
end

local animateCard = 1
local animateTimer = 0
local dragging = nil
local draggingOffset = pos:new()

function love.update(dt)
    if (animateCard <= #cards) then
        animateTimer = animateTimer + dt
        if (animateTimer > 0.1) then
            local card = cards[animateCard]
            card:animateTo(card.startPos)
            animateTimer = 0
            animateCard = animateCard + 1
        end
    end

    if dragging then
        local mouse = pos:new(love.mouse.getPosition())
        dragging.pos = mouse - draggingOffset
        if not love.mouse.isDown(1) then
            dragging = nil
        end
    end

    if love.mouse.isDown(1) and not dragging then
        local border = pos:new(14, 14)
        for i = 52, 1, -1 do
            local card = cards[i]
            local mouse = pos:new(love.mouse.getPosition())
            if mouse > card.pos + border and mouse < card.pos + card.size - border then
                --  and mouse.y >
                --     card.pos.y + border and mouse.y < card.pos.y + card.gfx:getHeight() - border then
                dragging = card
                table.remove(cards, i)
                table.insert(cards, card)
                draggingOffset = mouse - card.pos
                break
            end
        end
    end

    if love.mouse.isDown(2) and not dragging then
        for i = 1, 52 do
            local card = cards[i]
            card:animateTo(card.startPos)
        end
    end

    for i = 1, 52 do
        local card = cards[i]
        if card.animation then
            card.pos = card.pos + (card.target - card.pos) * pos:new(dt * 5, dt * 5)
            if (card.pos - card.target):abs() < pos:new(1, 1) then
                card.pos = card.target
                card.target = nil
                card.animation = nil
            end
        end
    end
end

function love.draw(dt)
    for _, card in ipairs(cards) do
        love.graphics.draw(card.gfx, card.pos.x, card.pos.y)
    end
end
