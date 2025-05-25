require("lib/test")

func = {}

function func.for_each(t, fn)
    for _, item in ipairs(t) do
        fn(item)
    end
end

function func.map(t, fn)
    local res = {}
    for _, item in ipairs(t) do
        table.insert(res, fn(item))
    end
    return res
end

function func.filter(t, fn)
    local res = {}
    for _, item in ipairs(t) do
        if fn(item) then
            table.insert(res, item)
        end
    end
    return res
end

function func.reduce(t, fn, initial)
    local acc = initial
    for _, item in ipairs(t) do
        acc = fn(acc, item)
    end
    return acc
end

function func.find(t, fn)
    for _, item in ipairs(t) do
        if fn(item) then
            return item
        end
    end
    return nil
end

for_each = func.for_each
map = func.map
filter = func.filter
reduce = func.reduce
find = func.find

-- Test cases

it("iterates over cards", function()
    local t = {1, 2, 3}
    local sum = 0
    func.for_each(t, function(item)
        sum = sum + item
    end)
    expect(sum, 6)
end)

it("maps items to new values", function()
    local t = {1, 2, 3}
    local res = func.map(t, function(item)
        return item * 2
    end)
    expect(#res, 3)
    expect(res[1], 2)
    expect(res[2], 4)
    expect(res[3], 6)
end)

it("filters items based on a condition", function()
    local t = {1, 2, 3, 4, 5}
    local res = func.filter(t, function(item)
        return item % 2 == 0
    end)
    expect(#res, 2)
    expect(res[1], 2)
    expect(res[2], 4)
end)

it("reduces items to a single value", function()
    local t = {1, 2, 3, 4}
    local sum = func.reduce(t, function(acc, item)
        return acc + item
    end, 0)
    expect(sum, 10)
end)

it("finds an item based on a condition", function()
    local t = {1, 2, 3, 4, 5}
    local found = func.find(t, function(item)
        return item == 3
    end)
    expect(found, 3)

    local not_found = func.find(t, function(item)
        return item == 6
    end)
    expect(not_found, nil)
end)
