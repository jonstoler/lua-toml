describe("table", function()
	setup(function()
		TOML = require "toml"
	end)

	it("empty", function()
		local obj = TOML.parse "[a]"
		local sol = {
			a = {}
		}
		assert.same(sol, obj)
	end)

	it("sub empty", function()
		local obj = TOML.parse[=[
[a]
[a.b]]=]
		local sol = {
			a = {
				b = {}
			}
		}
		assert.same(sol, obj)
	end)
end)
