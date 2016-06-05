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
end)
