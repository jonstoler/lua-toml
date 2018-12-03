describe("strictness setting", function()
	setup(function()
		TOML = require "toml"
	end)

	it("allows for mixed types in tables", function()
		TOML.strict = false
		local obj = TOML.parse[=[
mixed = [true, true, 3]]=]
		TOML.strict = true
		local sol = {
			mixed = {true, true, 3}
		}
		assert.same(sol, obj)
	end)
end)
