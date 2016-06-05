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

end)
