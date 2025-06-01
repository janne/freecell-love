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
