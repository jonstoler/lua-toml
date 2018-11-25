# toml.lua

Use [toml](https://github.com/toml-lang/toml) with lua!

Latest supported version: 0.4.0  
Current lua-toml version: 2.0.0

# Usage

	TOML = require "toml"
	TOML.parse(string)
	tomlOut = TOML.encode(table)

To enable more lua-friendly features (like mixed arrays):

	TOML.strict = false

or:

	TOML.parse(string, {strict = false})

<span></span>

> Note: For the moment, a basic implementation of dates is under test.

# License

lua-toml is licensed under [MIT](https://opensource.org/licenses/MIT).

```
Copyright (c) 2017 Jonathan Stoler

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
