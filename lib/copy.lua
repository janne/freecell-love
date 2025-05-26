require("lib/test")

function copy(obj, seen)
  if type(obj) ~= 'table' then
    return obj
  end
  if seen and seen[obj] then
    return seen[obj]
  end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do
    res[copy(k, s)] = copy(v, s)
  end
  return res
end

function copyWith(t, values)
  local res = copy(t)
  for k, v in pairs(values) do
    res[k] = v
  end
  return res
end

-- Test cases

it("copies a table", function()
  local original = {
    a = 1,
    b = {
      c = 2
    }
  }
  local clone = copy(original)
  expect(clone.a, 1)
  expect(clone.b.c, 2)
end)

it("copies a table with overrides", function()
  local original = {
    a = 1,
    b = 2
  }
  local clone = copyWith(original, {
    b = 3
  })
  expect(clone.a, 1)
  expect(clone.b, 3) -- Should override the original value
end)
