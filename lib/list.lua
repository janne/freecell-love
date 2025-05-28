require("lib/test")

List = {}
List.__index = List

function List.new(t)
  return setmetatable(t or {}, List)
end

function List:push(item)
  table.insert(self, item)
end

function List:for_each(fn)
  for _, item in ipairs(self) do
    fn(item)
  end
end

function List:map(fn)
  local res = {}
  for _, item in ipairs(self) do
    table.insert(res, fn(item))
  end
  return res
end

function List:filter(fn)
  local res = {}
  for _, item in ipairs(self) do
    if fn(item) then
      table.insert(res, item)
    end
  end
  return res
end

function List:reduce(initial, fn)
  local acc = initial
  for _, item in ipairs(self) do
    acc = fn(acc, item)
  end
  return acc
end

function List:find(fn)
  for _, item in ipairs(self) do
    if fn(item) then
      return item
    end
  end
  return nil
end

-- Test cases

it("creates a new list", function()
  local t = List.new { 1, 2, 3 }
  expect(#t, 3)
  expect(t[1], 1)
  expect(t[2], 2)
  expect(t[3], 3)
end)

it("iterates over cards", function()
  local t = List.new { 1, 2, 3 }
  local sum = 0
  t:for_each(function(item)
    sum = sum + item
  end)
  expect(sum, 6)
end)

it("maps items to new values", function()
  local t = List.new { 1, 2, 3 }
  local res = t:map(function(item)
    return item * 2
  end)
  expect(#res, 3)
  expect(res[1], 2)
  expect(res[2], 4)
  expect(res[3], 6)
end)

it("filters items based on a condition", function()
  local t = List.new { 1, 2, 3, 4, 5 }
  local res = t:filter(function(item)
    return item % 2 == 0
  end)
  expect(#res, 2)
  expect(res[1], 2)
  expect(res[2], 4)
end)

it("reduces items to a single value", function()
  local t = List.new { 1, 2, 3, 4 }
  local sum = t:reduce(0, function(acc, item)
    return acc + item
  end)
  expect(sum, 10)
end)

it("finds an item based on a condition", function()
  local t = List.new { 1, 2, 3, 4, 5 }
  local found = t:find(function(item)
    return item == 3
  end)
  expect(found, 3)

  local not_found = t:find(function(item)
    return item == 6
  end)
  expect(not_found, nil)
end)
