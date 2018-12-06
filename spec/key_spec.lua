describe("key parsing", function()
	setup(function()
		TOML = require "toml"
	end)

	it("no space", function()
		local obj = TOML.parse[=[
answer=42]=]
		local sol = {
			answer = 42,
		}
		assert.same(sol, obj)
	end)

	it("quote no space", function()
		local obj = TOML.parse[=[
"answer"=42]=]
		local sol = {
			answer = 42,
		}
		assert.same(sol, obj)
	end)

	it("inline table quoted key", function()
		local obj = TOML.parse[=[
the = {"answer" = 42}]=]
		local sol = {
			the = { answer = 42 },
		}
		assert.same(sol, obj)
	end)

	it("bare number", function()
		local obj = TOML.parse[=[
1234 = "value"]=]
		local sol = {
			[1234] = "value"
		}
		assert.same(sol, obj)
	end)

	it("empty", function()
		local obj = TOML.parse[=[
"" = "blank"]=]
		local sol = {
			[""] = "blank",
		}
		assert.same(sol, obj)
	end)

	it("space", function()
		local obj = TOML.parse[=[
"a b" = 1
		]=]
		local sol = {
			["a b"] = 1,
		}
		assert.same(sol, obj)
	end)

	it("special chars", function()
		local obj = TOML.parse[=[
"~!@$^&*()_+-`1234567890[]|/?><.,;:'" = 1
		]=]
		local sol = {
			["~!@$^&*()_+-`1234567890[]|/?><.,;:'"] = 1
		}
		assert.same(sol, obj)
	end)

	it("additional equal", function()
		local obj, err = TOML.parse[=[ b = = 1 ]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

	it("duplicated key", function()
    local a, b = TOML.parse[[
[t]
f = "v"
[t.f]
]]
		assert.same(nil, a)
		assert.same('string', type(b))
	end)

	it("duplicated key", function()
		local obj, err = TOML.parse[=[
dup = false
dup = true]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

	it("error key with space", function()
		local obj, err = TOML.parse[=[
a b = 1
]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

	it("error key with braket", function()
		local obj, err = TOML.parse[=[
a[b = 1
]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

	it("error key with newline", function()
		local obj, err = TOML.parse[=[
a
= 1
]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

	it("key with hash", function()
		local obj, err = TOML.parse[=[
a# = 1
]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)
end)
