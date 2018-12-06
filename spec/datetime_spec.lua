describe("datetime parsing", function()
	setup(function()
		TOML = require "toml"
	end)

  it("datetime", function()
		local obj = TOML.parse[=[datetime = 2018-06-21T16:17:18.19+00:20]=]
		local sol = {
			datetime = {
				year = 2018,
				month = 6,
				day = 21,
				hour = 16,
				min = 17,
				sec = 18.19,
				zone = 0,
			}
		}
		assert.same(sol, obj)
		assert.same(true, TOML.isdate(obj.datetime))
	end)

	it("multiple formats", function()
		local obj = TOML.parse[=[
full = 1937-01-01T12:00:27.87+00:20
nozone = 1937-01-01T12:00:27.87Z
human = 1937-01-01 12:00:27.87+00:20
humannozone = 1937-01-01 12:00:27.87Z]=]
		local date_table = {
			year = 1937,
			month = 1,
			day = 1,
			hour = 12,
			min = 0,
			sec = 27.87,
			zone = 0,
		}
		local sol = {
			full = date_table,
			nozone = date_table,
			human = date_table,
			humannozone = date_table,
		}
		assert.same(sol, obj)
	end)

	it("date only", function()
		local obj = TOML.parse[=[
date = 1937-01-01]=]
		local sol = {
		    date = {
			year = 1937,
			month = 1,
			day = 1,
			},
		}
		assert.same(sol, obj)
	end)

	it("time only", function()
		local obj = TOML.parse[=[
time = 12:00:27.87Z]=]
		local sol = {
			time = {
				hour = 12,
				min = 0,
				sec = 27.87,
			},
		}
		assert.same(sol, obj)
	end)
end)

describe("datetime encoding", function()
	setup(function()
		TOML = require "toml"
	end)

	it("encode date in TOML", function()
		local obj = [=[datetime = 2018-06-21 16:17:18.19+00:00]=]
		local sol = TOML.encode {
			datetime = TOML.datefy{
				year = 2018,
				month = 6,
				day = 21,
				hour = 16,
				min = 17,
				sec = 18.190,
				zone = 0,
			}
		}
		assert.same(sol, obj)
	end)

	it("encode date", function()
		local obj = tostring(TOML.datefy {
			year = 2018,
			month = 6,
			day = 21,
			hour = 16,
			min = 17,
			sec = 18.19,
			zone = 0,
		})
		local sol = [[2018-06-21 16:17:18.19+00:00]]
		assert.same(sol, obj)
	end)

	it("negative zone", function()
		local obj = tostring(TOML.datefy {
			year = 2018,
			month = 6,
			day = 21,
			hour = 16,
			min = 17,
			sec = 18.19,
			zone = -5,
		})
		local sol = [[2018-06-21 16:17:18.19-05:00]]
		assert.same(sol, obj)
	end)

	it("number of digits for the seconds", function()
		local obj = tostring(TOML.datefy {
			year = 2018,
			month = 6,
			day = 21,
			hour = 16,
			min = 17,
			sec = 0,
			zone = -5,
		})
		local sol = [[2018-06-21 16:17:00-05:00]]
		assert.same(sol, obj)
	end)
end)
