describe("boolean parsing", function()
	setup(function()
		TOML = require "toml"
	end)

	it("boolean", function()
		local obj = TOML.parse[=[
t = true
f = false]=]
		local sol = {
			t = true,
			f = false,
		}
		assert.same(sol, obj)
	end)
end)
