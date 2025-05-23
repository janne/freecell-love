animated_pos = {}
animated_pos.__index = animated_pos

-- Set pos as the metatable’s __index fallback for inheritance
setmetatable(animated_pos, {
    __index = pos
})

local animations = {}

function animated_pos:new(x, y)
    local pos = pos:new(x, y)
    pos.target = pos
    return setmetatable(pos, self)
end

function animated_pos:from_pos(pos)
    return animated_pos:new(pos.x, pos.y)
end

function animated_pos:animateTo(target_pos)
    if (target_pos.x ~= self.x or target_pos.y ~= self.y) then
        self.target = target_pos
        table.insert(animations, self)
    end
end

function animated_pos.update(dt)
    for i, animation in ipairs(animations) do
        local newPos = animation + (animation.target - animation) * pos:new(dt * 5, dt * 5)
        animation.x = newPos.x
        animation.y = newPos.y
        if (newPos - animation.target):abs() < pos:new(1, 1) then
            table.remove(animations, i)
            animation.x = animation.target.x
            animation.y = animation.target.y
        end
    end
end
