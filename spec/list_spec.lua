require("lib/list")

it("creates a new list", function()
  local t = List.new { 1, 2, 3 }
  assert.equal(#t, 3)
  assert.equal(t[1], 1)
  assert.equal(t[2], 2)
  assert.equal(t[3], 3)
end)

it("iterates over cards", function()
  local t = List.new { 1, 2, 3 }
  local sum = 0
  t:for_each(function(item)
    sum = sum + item
  end)
  assert.equal(sum, 6)
end)

it("maps items to new values", function()
  local t = List.new { 1, 2, 3 }
  local res = t:map(function(item)
    return item * 2
  end)
  assert.equal(#res, 3)
  assert.equal(res[1], 2)
  assert.equal(res[2], 4)
  assert.equal(res[3], 6)
end)

it("filters items based on a condition", function()
  local t = List.new { 1, 2, 3, 4, 5 }
  local res = t:filter(function(item)
    return item % 2 == 0
  end)
  assert.equal(#res, 2)
  assert.equal(res[1], 2)
  assert.equal(res[2], 4)
end)

it("reduces items to a single value", function()
  local t = List.new { 1, 2, 3, 4 }
  local sum = t:reduce(0, function(acc, item)
    return acc + item
  end)
  assert.equal(sum, 10)
end)

it("finds an item based on a condition", function()
  local t = List.new { 1, 2, 3, 4, 5 }
  local found = t:find(function(item)
    return item == 3
  end)
  assert.equal(found, 3)

  local not_found = t:find(function(item)
    return item == 6
  end)
  assert.equal(not_found, nil)
end)
