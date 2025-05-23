local run_tests = true
local running_test = nil

-- Support running tests standalone
if love == nil and run_tests then
    love = {}
end

function it(description, func)
    running_test = description
    if run_tests then
        func()
    end
    running_test = nil
end

function expect(actual, expected)
    if actual ~= expected then
        error(string.format("Running 'it %s' -- expected %s but got %s ", running_test, expected, actual))
    end
end
