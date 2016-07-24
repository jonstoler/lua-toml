describe("float parsing", function()
	setup(function()
		TOML = require "toml"
	end)

	it("float", function()
		local obj = TOML.parse[=[
pi = 3.14
negpi = -3.14
pluspi = +3.14]=]
		local sol = {
			pi = 3.14,
			negpi = -3.14,
			pluspi = 3.14,
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

	it("exponent", function()
		local obj = TOML.parse[=[
exp1 = 5e+22
exp2 = 1e6
exp3 = -2E-2
exp4 = 6.626e-34]=]
		local sol = {
			exp1 = math.floor(5 * 10^22),
			exp2 = math.floor(1 * 10^6),
			exp3 = math.floor(-2 * 10^-2),
			exp4 = 6.626 * 10^-34,
		}
		assert.same(sol, obj)
	end)

	it("underscore", function()
		local obj = TOML.parse[=[
underscore = 9_224_617.445_991]=]
		local sol = {
			underscore = 9224617.445991
		}
		assert.same(sol, obj)
	end)

end)
