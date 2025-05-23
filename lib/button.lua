button = {}
button.__index = button

function button:new(x, y, w, h, text, onClick)
    local b = {}
    b.pos = pos:new(x or 0, y or 0)
    b.size = pos:new(w or 100, h or 50)
    b.text = text or ""
    b.isPressed = false
    b.onClick = onClick or function()
    end
    return setmetatable(b, self)
end

function button:has_mouse_over()
    local mouse = pos:new(love.mouse.getPosition())
    return mouse > self.pos and mouse < self.pos + self.size
end

function button:draw()
    if self.isPressed then
        love.graphics.setColor(0.5, 0.5, 0.5)
    elseif self:has_mouse_over() then
        love.graphics.setColor(1, 1, 1)
    else
        love.graphics.setColor(0.9, 0.9, 0.9)
    end
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.size.x, self.size.y)
    love.graphics.print(self.text, self.pos.x + 10, self.pos.y + 10)
    love.graphics.setColor(1, 1, 1)
end
