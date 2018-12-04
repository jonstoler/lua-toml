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
			exp3 = -2 * 10^-2,
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

	it("trailing zero", function()
		local obj, err = TOML.parse[=[
float = 1. ]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

	it("trailing zero with exp", function()
		local obj, err = TOML.parse[=[
float = 1.e12 ]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

	it("underscore", function()
		local obj = TOML.parse[=[
before = 3_141.5927
after = 3141.592_7
exponent = 3e1_4
]=]
		local sol = {
			before = 3141.5927,
			after = 3141.5927,
			exponent = 3e14,
		}
		assert.same(sol, obj)
	end)

	it("bad undescore suffix", function()
		local obj, err = TOML.parse[=[
bad = 1.2_
]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

	it("bad undescore after dot", function()
		local obj, err = TOML.parse[=[
bad = 1._2
]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

	it("bad undescore before dot", function()
		local obj, err = TOML.parse[=[
bad = 1_.2
]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

	it("bad double undescore", function()
		local obj, err = TOML.parse[=[
bad = 3__141.5927
]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)
end)
