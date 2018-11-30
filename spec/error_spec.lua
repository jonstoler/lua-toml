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
		assert.same(n, nil)
		assert.same(e, 'At TOML line 3: Single-line string cannot contain line break.')
	end)

	it("multi step error", function()
		local tp = TOML.multistep_parser()
		tp('a="a"\n')
		tp('b="b"\n')
		tp('asdf="aaa\n	')
		local n, e = tp()
		assert.same(n, nil)
		assert.same(e, 'At TOML line 3: Single-line string cannot contain line break.')
	end)

	it("partial step error", function()
		local tp = TOML.multistep_parser()
		assert.same(true, nil ~= tp('a="a"\n'))
		assert.same(true, nil ~= tp('b="b"\n'))
		local n, e = tp('asdf="aaa\n	')
		assert.same(n, nil)
		assert.same(e, 'At TOML line 3: Single-line string cannot contain line break.')
		local n, e = tp('c="c"')
		assert.same(n, nil)
		assert.same(e, 'At TOML line 3: Single-line string cannot contain line break.')
	end)
end)

