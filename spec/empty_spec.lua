describe("empty parsing", function()
	setup(function()
		TOML = require "toml"
	end)

	it("empty", function()
		local obj = TOML.parse""
		local sol = {}
		assert.same(sol, obj)
	end)
end)
