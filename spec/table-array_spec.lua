describe("table array parsing", function()
	setup(function()
		TOML = require "toml"
	end)

	it("implicit", function()
		local obj = TOML.parse[=[
[[albums.songs]]
name = "Glory Days"]=]
		local sol = {
			albums = {
				songs = {
					{name = "Glory Days"},
				}
			}
		}
		assert.same(sol, obj)
	end)

	it("many", function()
		local obj = TOML.parse[=[
[[people]]
first_name = "Bruce"
last_name = "Springsteen"

[[people]]
first_name = "Eric"
last_name = "Clapton"

[[people]]
first_name = "Bob"
last_name = "Seger"]=]
		local sol = {
			people = {
				{first_name = "Bruce", last_name = "Springsteen"},
				{first_name = "Eric", last_name = "Clapton"},
				{first_name = "Bob", last_name = "Seger"},
			}
		}
		assert.same(sol, obj)
	end)

	it("nest", function()
		local obj = TOML.parse[=[
[[albums]]
name = "Born to Run"

  [[albums.songs]]
  name = "Jungleland"

  [[albums.songs]]
  name = "Meeting Across the River"

[[albums]]
name = "Born in the USA"
  
  [[albums.songs]]
  name = "Glory Days"

  [[albums.songs]]
  name = "Dancing in the Dark"]=]
		local sol = {
			albums = {
				{
					name = "Born to Run",
					songs = {
						{name = "Jungleland"},
						{name = "Meeting Across the River"}
					}
				},
				{
					name = "Born in the USA",
					songs = {
						{name = "Glory Days"},
						{name = "Dancing in the Dark"}
					}
				}
			}
		}
		assert.same(sol, obj)
	end)

	it("one", function()
		local obj = TOML.parse[=[
[[people]]
first_name = "Bruce"
last_name = "Springsteen"]=]
		local sol = {
			people = {
				{first_name = "Bruce", last_name = "Springsteen"}
			}
		}
		assert.same(sol, obj)
	end)

	it("nest-tables", function()
		local obj = TOML.parse[=[
[[people]]
first_name = "Bruce"
last_name = "Springsteen"

[people.birth]
date = "September 23, 1949"
place = "Long Branch, New Jersey"

[people.spouse]
first_name = "Patti"
last_name = "Scialfa"

[[people]]
# an empty element

[[people]]
first_name = "Eric"
last_name = "Clapton"
]=]
		local sol = {
			people = {
				{
					first_name = "Bruce", last_name = "Springsteen",
					birth = {
						date = "September 23, 1949",
						place = "Long Branch, New Jersey"
					},
					spouse = { first_name = "Patti", last_name = "Scialfa" },
				}, {
				}, {
					first_name = "Eric", last_name = "Clapton"
				}
			}
		}
		assert.same(sol, obj)
	end)

	it("implicit table vs array", function()
			local obj, err = TOML.parse[=[
[[shouldbe.array]]
item = "one"

[[shouldbe]]
table = "error"
]=]
		assert.same(nil, obj)
		assert.same('string', type(err))
	end)

	it("sub-table-array", function()
		local obj, err = TOML.parse[=[
[[shouldbe.array]]
item = "one"

[[shouldbe.array]]
table = "error"
]=]
		assert.same(obj,{shouldbe={array={{item="one"},{table="error"}}}})
	end)
end)
