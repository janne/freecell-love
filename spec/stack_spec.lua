require("spec/mocks")
require("lib/stack")

describe("Stack", function()
  it("allows adding cards", function()
    local s = Stack:new()
    local c = Card:new(1)
    s:insert(c)
    assert.equal(#s, 1)
  end)

  it("allows removing cards", function()
    local s = Stack:new()
    s:insert(Card:new(1))
    s:insert(Card:new(2))
    assert.equal(#s, 2)
    s:remove(1)
    assert.equal(#s, 1)
    assert.equal(s[1].rank, 2)
  end)
end)
