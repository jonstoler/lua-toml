describe("integer parsing", function()
	setup(function()
		TOML = require "toml"
	end)

	it("integer", function()
		local obj = TOML.parse[=[
answer = 42
neganswer = -42
posanswer = +42
underscore = 1_000]=]
		local sol = {
			answer = 42,
			neganswer = -42,
			posanswer = 42,
			underscore = 1000,
		}
		assert.same(sol, obj)
	end)

	it("long", function()
		-- BurntSushi's spec uses the largest long available
		-- Lua doesn't have a long type, so we're using
		-- the largest double available instead
		local obj = TOML.parse[=[
answer = 9007199254740992
neganswer = -9007199254740991]=]
		local sol = {
			answer = 9007199254740992,
			neganswer = -9007199254740991
		}
		assert.same(sol, obj)
	end)

end)
