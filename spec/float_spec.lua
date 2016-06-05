describe("float parsing", function()
	setup(function()
		TOML = require "toml"
	end)

	it("float", function()
		local obj = TOML.parse[=[
pi = 3.14
negpi = -3.14]=]
		local sol = {
			pi = 3.14,
			negpi = -3.14,
		}
		assert.same(sol, obj)
	end)

	it("long", function()
		local obj = TOML.parse[=[
longpi = 3.141592653589793
neglongpi = -3.141592653589793]=]
		local sol = {
			longpi = 3.141592653589793,
			neglongpi = -3.141592653589793
		}
		assert.same(sol, obj)
	end)

end)
