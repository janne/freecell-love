AnimatedPos = {}
AnimatedPos.__index = AnimatedPos

-- Set pos as the metatable’s __index fallback for inheritance
setmetatable(AnimatedPos, {
  __index = Pos
})

function AnimatedPos:__tostring()
  return "(" .. self.x .. ", " .. self.y .. ", target: " .. tostring(self.target) .. ")"
end

local animations = {}

function AnimatedPos:new(x, y)
  local pos = Pos:new(x, y)
  pos.target = pos
  return setmetatable(pos, self)
end

function AnimatedPos:from_pos(pos)
  return AnimatedPos:new(pos.x, pos.y)
end

function AnimatedPos:animateTo(target_pos)
  if target_pos.x ~= self.x or target_pos.y ~= self.y then
    self.target = target_pos
    table.insert(animations, self)
  end
end

function AnimatedPos:is_animating()
  return find(animations, function(animation)
    return animation == self
  end) ~= nil
end

function AnimatedPos.update(dt)
  for i, animation in ipairs(animations) do
    local newPos = animation + (animation.target - animation) * Pos:new(dt * 5, dt * 5)
    animation.x = newPos.x
    animation.y = newPos.y
    if (newPos - animation.target):abs() < Pos:new(1, 1) then
      table.remove(animations, i)
      animation.x = animation.target.x
      animation.y = animation.target.y
    end
  end
end
