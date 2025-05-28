require("lib/test")

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

-- Test cases

it("pretty prints", function()
  local p = Pos:new(10, 20)
  expect(tostring(p), "(10, 20)")
end)

it("supports addition", function()
  local p1 = Pos:new(10, 20)
  local p2 = Pos:new(5, 5)
  local p3 = p1 + p2
  expect(tostring(p3), "(15, 25)")
end)

it("supports subtraction", function()
  local p1 = Pos:new(10, 20)
  local p2 = Pos:new(5, 5)
  local p3 = p1 - p2
  expect(tostring(p3), "(5, 15)")
end)

it("supports multiplication", function()
  local p1 = Pos:new(10, 20)
  local p2 = Pos:new(5, 5)
  local p3 = p1 * p2
  expect(tostring(p3), "(50, 100)")
end)

it("supports division", function()
  local p1 = Pos:new(10, 20)
  local p2 = Pos:new(5, 5)
  local p3 = p1 / p2
  expect(tostring(p3), "(2, 4)")
end)

it("supports new and get", function()
  local p = Pos:new(10, 20)
  local x, y = p:get()
  expect(tostring(p), "(10, 20)")
end)

it("defaults to 0 values", function()
  local p = Pos:new(10)
  local x, y = p:get()
  expect(tostring(p), "(10, 0)")
end)

it("allows being called as module function", function()
  local p = Pos:new()
  local x, y = p.get(p)
  expect(tostring(p), "(0, 0)")
end)

it("supports less than comparison", function()
  local p1 = Pos:new(10, 20)
  local p2 = Pos:new(15, 25)
  expect(p1 < p2, true)
end)

it("supports greater than comparison", function()
  local p1 = Pos:new(10, 20)
  local p2 = Pos:new(5, 15)
  expect(p1 > p2, true)
end)

it("supports absolute value", function()
  local p1 = Pos:new(-10, -20)
  local p2 = p1:abs()
  expect(tostring(p2), "(10, 20)")
end)
