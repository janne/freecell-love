require("lib/util")
require("spec/mocks")

it("copies a table", function()
  local original = {
    a = 1,
    b = {
      c = 2
    }
  }
  local clone = Util.copy(original)
  assert.equal(clone.a, 1)
  assert.equal(clone.b.c, 2)
end)

it("copies a table with overrides", function()
  local original = {
    a = 1,
    b = 2
  }
  local clone = Util.copyWith(original, {
    b = 3
  })
  assert.equal(clone.a, 1)
  assert.equal(clone.b, 3) -- Should override the original value
end)
