game = {}
game.__index = game

local spacing = {}
for i = 1, 8 do
    spacing[i] = love.graphics.getWidth() / 8 * (i - 1)
end

function game:new()
    local g = {
        homecells = {stack:new(spacing[1] - 10, 60), stack:new(spacing[2] - 10, 60), stack:new(spacing[3] - 10, 60),
                     stack:new(spacing[4] - 10, 60)},
        freecells = {stack:new(spacing[5] + 10, 60), stack:new(spacing[6] + 10, 60), stack:new(spacing[7] + 10, 60),
                     stack:new(spacing[8] + 10, 60)},
        tableau = {stack:new(spacing[1], 200, true), stack:new(spacing[2], 200, true), stack:new(spacing[3], 200, true),
                   stack:new(spacing[4], 200, true), stack:new(spacing[5], 200, true), stack:new(spacing[6], 200, true),
                   stack:new(spacing[7], 200, true), stack:new(spacing[8], 200, true)}
    }
    local cards = stack:new()
    for i = 1, 52 do
        local card = card:new(i)
        cards:insert(card)
    end
    cards:shuffle()
    for i, card in ipairs(cards) do
        local col = (i - 1) % 8 + 1
        g.tableau[col]:push(card)
    end
    return setmetatable(g, self)
end

function game:remove_card(card)
    for _, list in ipairs({self.freecells, self.homecells, self.tableau}) do
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

function game:available_freecell()
    for _, stack in ipairs(self.freecells) do
        if #stack == 0 then
            return stack
        end
    end
    return nil
end

function game:available_tableau(card)
    for i, stack in ipairs(self.tableau) do
        if #stack == 0 then
            return stack
        end
        if stack[#stack].rank == card.rank + 1 and (stack[#stack].suit % 2) ~= (card.suit % 2) then
            return stack
        end
    end
    return nil
end

function game:available_homecell(card)
    for i, stack in ipairs(self.homecells) do
        if #stack == 0 and card.rank == 1 then
            return stack
        elseif #stack > 0 and stack[#stack].suit == card.suit and stack[#stack].rank + 1 == card.rank then
            return stack
        end
    end
    return nil
end

function game:automove_card(card)
    -- Homecells
    local stack = self:available_homecell(card)
    if (stack ~= nil) then
        self:remove_card(card)
        stack:push(card)
        return
    end
    -- Tableau
    local stack = self:available_tableau(card)
    if (stack ~= nil) then
        self:remove_card(card)
        stack:push(card)
        return
    end
    -- Freecells
    local stack = self:available_freecell()
    if (stack ~= nil) then
        self:remove_card(card)
        stack:push(card)
        return
    end
end

function game:cards()
    local cards = {}
    for _, stack in ipairs(self.homecells) do
        for _, card in ipairs(stack) do
            table.insert(cards, card)
        end
    end
    for _, stack in ipairs(self.freecells) do
        for _, card in ipairs(stack) do
            table.insert(cards, card)
        end
    end
    for _, stack in ipairs(self.tableau) do
        for _, card in ipairs(stack) do
            table.insert(cards, card)
        end
    end
    return cards
end
