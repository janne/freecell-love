Pos = {}
Pos.__index = Pos

function Pos:new(x, y)
  local p = {
    x = x or 0,
    y = y or 0
  }
  return setmetatable(p, Pos)
end

function Pos:get()
  return self.x or 0, self.y or 0
end

function Pos:__tostring()
  return "(" .. self.x .. ", " .. self.y .. ")"
end

function Pos:__add(other)
  return Pos:new(self.x + other.x, self.y + other.y)
end

function Pos:__sub(other)
  return Pos:new(self.x - other.x, self.y - other.y)
end

function Pos:__mul(other)
  return Pos:new(self.x * other.x, self.y * other.y)
end

function Pos:__div(other)
  return Pos:new(self.x / other.x, self.y / other.y)
end

function Pos:__lt(other)
  return self.x < other.x and self.y < other.y
end

function Pos:__gt(other)
  return self.x > other.x and self.y > other.y
end

function Pos:__eq(other)
  return self.x == other.x and self.y == other.y
end

function Pos:abs()
  return Pos:new(math.abs(self.x), math.abs(self.y))
end
