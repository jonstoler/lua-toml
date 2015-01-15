# toml.lua

Use [toml](https://github.com/toml-lang/toml) with lua!

Latest supported version: 0.3.1

# Usage

	TOML.parse(string)
	tomlOut = TOML.encode(table)

To enable more lua-friendly features (like mixed arrays):

	TOML.strict = false

<span></span>

> Note: For the moment, dates are *not* supported, since there is no simple way to serialize them in lua.
