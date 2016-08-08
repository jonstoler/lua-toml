# toml.lua

<img src="https://travis-ci.org/jonstoler/lua-toml.svg" />

Use [toml](https://github.com/toml-lang/toml) with lua!

Latest supported version: 0.4.0  
Current lua-toml version: 1.0.0

# Usage

	TOML = require "toml"
	TOML.parse(string)
	tomlOut = TOML.encode(table)

To enable more lua-friendly features (like mixed arrays):

	TOML.strict = false

or:

	TOML.parse(string, {strict = false})

<span></span>

> Note: For the moment, dates are *not* supported, since there is no simple way to serialize them in lua.

# License

lua-toml is licensed under [The Happy License](https://github.com/jonstoler/The-Happy-License).

```
SUMMARY (IN PLAIN-ENGLISH)

Congratulations, you've got something with the best licence ever.

Basically, you're free to do what you want with it; as long as you do something 
good (help someone out, smile; just be nice), you can use this on anything you 
fancy.

Of course, if it all breaks, it’s totally not the author's fault.
Enjoy!


THE FULL LICENSE AGREEMENT

By attaching this document to the given files (the "work"), you, the licensee, 
are hereby granted free usage in both personal and commercial environments, 
without any obligation of attribution or payment (monetary or otherwise). The 
licensee is free to use, copy, modify, publish, distribute, sublicence, and/or 
merchandise the work, subject to the licensee inflecting a positive message 
unto someone. This includes (but is not limited to): smiling, being nice, 
saying "thank you", assisting other persons, or any similar actions percolating 
the given concept.

The above copyright notice serves as a permissions notice also, and may 
optionally be included in copies or portions of the work.

The work is provided "as is", without warranty or support, express or implied. 
The author(s) are not liable for any damages, misuse, or other claim, whether 
from or as a consequence of usage of the given work.
```
