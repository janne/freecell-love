require("lib/pos")

it("pretty prints", function()
  local p = Pos:new(10, 20)
  assert.equal(tostring(p), "(10, 20)")
end)

it("supports addition", function()
  local p1 = Pos:new(10, 20)
  local p2 = Pos:new(5, 5)
  local p3 = p1 + p2
  assert.equal(tostring(p3), "(15, 25)")
end)

it("supports subtraction", function()
  local p1 = Pos:new(10, 20)
  local p2 = Pos:new(5, 5)
  local p3 = p1 - p2
  assert.equal(tostring(p3), "(5, 15)")
end)

it("supports multiplication", function()
  local p1 = Pos:new(10, 20)
  local p2 = Pos:new(5, 5)
  local p3 = p1 * p2
  assert.equal(tostring(p3), "(50, 100)")
end)

it("supports division", function()
  local p1 = Pos:new(10, 20)
  local p2 = Pos:new(5, 5)
  local p3 = p1 / p2
  assert.equal(tostring(p3), "(2.0, 4.0)")
end)

it("supports new and get", function()
  local p = Pos:new(10, 20)
  local x, y = p:get()
  assert.equal(tostring(p), "(10, 20)")
end)

it("defaults to 0 values", function()
  local p = Pos:new(10)
  local x, y = p:get()
  assert.equal(tostring(p), "(10, 0)")
end)

it("allows being called as module function", function()
  local p = Pos:new()
  local x, y = p.get(p)
  assert.equal(tostring(p), "(0, 0)")
end)

it("supports less than comparison", function()
  local p1 = Pos:new(10, 20)
  local p2 = Pos:new(15, 25)
  assert.equal(p1 < p2, true)
end)

it("supports greater than comparison", function()
  local p1 = Pos:new(10, 20)
  local p2 = Pos:new(5, 15)
  assert.equal(p1 > p2, true)
end)

it("supports absolute value", function()
  local p1 = Pos:new(-10, -20)
  local p2 = p1:abs()
  assert.equal(tostring(p2), "(10, 20)")
end)
