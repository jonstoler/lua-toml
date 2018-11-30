describe("error api", function()
	setup(function()
		TOML = require "toml"
	end)

	it("single step error", function()
		local n, e = TOML.parse[[
a="a"
b="b"
asdf="aaa
	 ]]
		assert.same('At TOML line 3: Single-line string cannot contain line break.', n or e)
	end)

	it("multi step error", function()
		local tp = TOML.multistep_parser()
		tp('a="a"\n')
		tp('b="b"\n')
		tp('asdf="aaa\n	')
		local n, e = tp()
		assert.same('At TOML line 3: Single-line string cannot contain line break.', n or e)
	end)

	it("partial step error", function()
		local tp = TOML.multistep_parser()
		assert.same(tp('a="a"\n') ~= nil, true)
		assert.same(tp('b="b"\n') ~= nil, true)
		local n, e = tp('asdf="aaa\n	')
		assert.same('At TOML line 3: Single-line string cannot contain line break.', n or e)
		local n, e = tp('c="c"')
		assert.same('At TOML line 3: Single-line string cannot contain line break.', n or e)
	end)
end)

