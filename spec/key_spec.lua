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

end)
