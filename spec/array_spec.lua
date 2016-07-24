describe("array parsing", function()
	setup(function()
		TOML = require "toml"
	end)

	it("empty", function()
		local obj = TOML.parse[=[
thevoid = [[[[[]]]]]]=]
		local sol = {
			thevoid = {{{{{}}}}}
		}
		assert.same(sol, obj)
	end)

	it("no spaces", function()
		local obj = TOML.parse[=[
ints = [1,2,3]]=]
		local sol = {
			ints = {1, 2, 3}
		}
		assert.same(sol, obj)
	end)

	it("heterogeneous", function()
		local obj = TOML.parse[=[
mixed = [[1, 2], ["a", "b"], [1.1, 2.1]]]=]
		local sol = {
			mixed = {
				{1, 2}, {"a", "b"}, {1.1, 2.1},
			}
		}
		assert.same(sol, obj)
	end)

	it("nested", function()
		local obj = TOML.parse[=[
nest = [["a"], ["b"]]]=]
		local sol = {
			nest = {{"a"}, {"b"}}
		}
		assert.same(sol, obj)
	end)

	it("array", function()
		local obj = TOML.parse[=[
ints = [1, 2, 3]
floats = [1.1, 2.1, 3.1]
strings = ["a", "b", "c"]
dates = [
	1987-07-05T17:45:00Z,
	1979-05-27T07:32:00Z,
	2006-06-01T11:00:00Z,
]
tables = [
	{ x = 1, y = 2, z = 3 },
	{ x = 7, y = 8, z = 9 },
	{ x = 2, y = 4, z = 8 }
]]=]
		local sol = {
			ints = {1, 2, 3},
			floats = {1.1, 2.1, 3.1},
			strings = {"a", "b", "c"},
			dates = {
				"1987-07-05T17:45:00Z",
				"1979-05-27T07:32:00Z",
				"2006-06-01T11:00:00Z",
			},
			tables = {
				{ x = 1, y = 2, z = 3 },
				{ x = 7, y = 8, z = 9 },
				{ x = 2, y = 4, z = 8 },
			}
		}
		assert.same(sol, obj)
	end)
end)
