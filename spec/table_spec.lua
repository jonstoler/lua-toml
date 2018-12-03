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

	it("whitespace", function()
		local obj = TOML.parse[=[
[a.b.c]
key = "value"

[ d.e.f ]
key = "value"

[ g . h . i ]
key = "value"]=]
		local sol = {
			a = {
				b = {
					c = {
						key = "value",
					}
				}
			},
			d = {
				e = {
					f = {
						key = "value"
					}
				}
			},
			g = {
				h = {
					i = {
						key = "value"
					}
				}
			}
		}
		assert.same(sol, obj)
	end)

	it("quoted", function()
		local obj = TOML.parse[=[
[dog."tater.man"]
type = "pug"]=]
		local sol = {
			dog = {
				["tater.man"] = {
					type = "pug"
				}
			}
		}
		assert.same(sol, obj)
	end)

	it("inline", function()
		
		local obj = TOML.parse[=[
name = { first = "Tom", last = "Preston-Werner" }
point = { x = 1, y = 2 }]=]
		local sol = {
			name = {
				first = "Tom",
				last = "Preston-Werner",
			},
			point = {
				x = 1,
				y = 2,
			}
		}
		assert.same(sol, obj)
	end)

	it("additional brace", function()

		local obj, err = TOML.parse[=[
[ [table]]
field = 1
]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

	it("duplicated table", function()

		local obj, err = TOML.parse[=[
[a]
[a]
]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

end)
