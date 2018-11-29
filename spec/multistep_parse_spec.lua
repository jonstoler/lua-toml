describe("multi step parsing", function()
	setup(function()
		TOML = require "toml"
	end)

	it("split the input in two chunks", function()
		local parse = TOML.multistep_parser()
		parse [=[
a = "a"
]=]
		parse [=[
b = "b"]=]
		local obj = parse()
		local sol = {
			a = "a",
			b = "b",
		}

		assert.same(sol, obj)
	end)

	it("in middle of string split", function()
		local parse = TOML.multistep_parser()
		parse [=[
a = "a]=]
		parse [=[
"
b = "b"]=]
		local obj = parse()
		local sol = {
			a = "a",
			b = "b",
		}

		assert.same(sol, obj)
	end)

end)
