require("lib/test")

pos = {}
pos.__index = pos

function pos:new(x, y)
    return setmetatable({
        x = x or 0,
        y = y or 0
    }, self)
end

function pos:get()
    return self.x or 0, self.y or 0
end

function pos:__tostring()
    return "(" .. self.x .. ", " .. self.y .. ")"
end

function pos:__add(other)
    return pos:new(self.x + other.x, self.y + other.y)
end

function pos:__sub(other)
    return pos:new(self.x - other.x, self.y - other.y)
end

function pos:__mul(other)
    return pos:new(self.x * other.x, self.y * other.y)
end

function pos:__div(other)
    return pos:new(self.x / other.x, self.y / other.y)
end

function pos:__lt(other)
    return self.x < other.x and self.y < other.y
end

function pos:__gt(other)
    return self.x > other.x and self.y > other.y
end

function pos:abs()
    return pos:new(math.abs(self.x), math.abs(self.y))
end

-- Test cases

it("pretty prints", function()
    local p = pos:new(10, 20)
    expect(tostring(p), "(10, 20)")
end)

it("supports addition", function()
    local p1 = pos:new(10, 20)
    local p2 = pos:new(5, 5)
    local p3 = p1 + p2
    expect(tostring(p3), "(15, 25)")
end)

it("supports subtraction", function()
    local p1 = pos:new(10, 20)
    local p2 = pos:new(5, 5)
    local p3 = p1 - p2
    expect(tostring(p3), "(5, 15)")
end)

it("supports multiplication", function()
    local p1 = pos:new(10, 20)
    local p2 = pos:new(5, 5)
    local p3 = p1 * p2
    expect(tostring(p3), "(50, 100)")
end)

it("supports division", function()
    local p1 = pos:new(10, 20)
    local p2 = pos:new(5, 5)
    local p3 = p1 / p2
    expect(tostring(p3), "(2, 4)")
end)

it("supports new and get", function()
    local p = pos:new(10, 20)
    local x, y = p:get()
    expect(tostring(p), "(10, 20)")
end)

it("defaults to 0 values", function()
    local p = pos:new(10)
    local x, y = p:get()
    expect(tostring(p), "(10, 0)")
end)

it("allows being called as module function", function()
    local p = pos:new()
    local x, y = p.get(p)
    expect(tostring(p), "(0, 0)")
end)

it("supports less than comparison", function()
    local p1 = pos:new(10, 20)
    local p2 = pos:new(15, 25)
    expect(p1 < p2, true)
end)

it("supports greater than comparison", function()
    local p1 = pos:new(10, 20)
    local p2 = pos:new(5, 15)
    expect(p1 > p2, true)
end)

it("supports absolute value", function()
    local p1 = pos:new(-10, -20)
    local p2 = p1:abs()
    expect(tostring(p2), "(10, 20)")
end)
