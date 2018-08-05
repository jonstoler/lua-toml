describe("encoding", function()
	setup(function()
		TOML = require "toml"
	end)

	it("array", function()
		local obj = TOML.encode{ a = { "foo","bar" } }
		local sol = "a = [\n\"foo\",\n\"bar\",\n]"
		assert.same(sol, obj)
	end)
end)
