describe("encoding", function()
	setup(function()
		TOML = require "toml"
	end)

	it("array", function()
		local obj = TOML.encode{ a = { "foo","bar" } }
		local sol = "a = [\nfoo,\nbar,\n]"
		assert.same(sol, obj)
	end)
end)
