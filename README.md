# toml.lua

Version: 2.1.0

Use [toml](https://github.com/toml-lang/toml) with lua!

The core parser is based on TOML 0.4.0. However the underscores between digits
are not supported. Moreover, for the time being, the date parsing should be
considered experimental.

The following features of TOML 0.5.0 are supported too (descriptions taken from
the TOML changelog):

- Add Local Date-Time.
- Add Local Date.
- Add Local Time.
- Allow space (instead of T) to separate date and time in Date-Time.

# Usage

	TOML = require "toml"
	TOML.parse(string)
	tomlOut = TOML.encode(table)

To process a file in multiple chunks:

	local parser = TOML.multistep_parser()
	parser(string_part_1)
	parser(string_part_2)
	-- ...
	local result = parser()

To enable more lua-friendly features (like mixed arrays):

	TOML.strict = false

or:

	TOML.parse(string, {strict = false})

or:

	local parser = TOML.multistep_parser{strict = false}

In case of error, nil plus an error message is returned.

<span></span>

# License

lua-toml is licensed under [MIT](https://opensource.org/licenses/MIT).

```
Copyright (c) 2017 Jonathan Stoler

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
