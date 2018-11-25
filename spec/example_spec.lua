describe("example parsing", function()
	setup(function()
		TOML = require "toml"
	end)

	it("example", function()
		local obj = TOML.parse[=[
best-day-ever = 1987-07-05T17:45:00Z

[numtheory]
boring = false
perfection = [6, 28, 496]]=]
		local sol = {
			["best-day-ever"] = {
			    year = 1987,
			    month = 7,
			    day = 5,
			    hour = 17,
			    min = 45,
			    sec = 0,
			    zone = 0,
			},
			numtheory = {
				boring = false,
				perfection = {6, 28, 496},
			}
		}
		assert.same(sol, obj)
	end)
end)
