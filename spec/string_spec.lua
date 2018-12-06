describe("string parsing", function()
	setup(function()
		TOML = require "toml"
	end)

	it("multiline", function()
		local obj = TOML.parse[=[
multiline_empty_one = """"""
multiline_empty_two = """
"""
multiline_empty_three = """\
    """
multiline_empty_four = """\
   \
   \
   """

equivalent_one = "The quick brown fox jumps over the lazy dog."
equivalent_two = """
The quick brown \


  fox jumps over \
    the lazy dog."""

equivalent_three = """\
       The quick brown \
       fox jumps over \
       the lazy dog.\
       """]=]
		local sol = {
			multiline_empty_one = "",
			multiline_empty_two = "",
			multiline_empty_three = "",
			multiline_empty_four = "",
			equivalent_one = "The quick brown fox jumps over the lazy dog.",
			equivalent_two = "The quick brown fox jumps over the lazy dog.",
			equivalent_three = "The quick brown fox jumps over the lazy dog.",
		}
		assert.same(sol, obj)
	end)

	it("raw multiline", function()
		local obj = TOML.parse[=[
oneline = '''This string has a ' quote character.'''
firstnl = '''
This string has a ' quote character.'''
multiline = '''
This string
has a ' quote character
and more than
one newline
in it.''']=]
		local sol = {
			oneline = "This string has a ' quote character.",
			firstnl = "This string has a ' quote character.",
			multiline = [[
This string
has a ' quote character
and more than
one newline
in it.]],
		}
		assert.same(sol, obj)
	end)

	it("raw", function()
		local obj = TOML.parse[=[
backspace = 'This string has a \b backspace character.'
tab = 'This string has a \t tab character.'
newline = 'This string has a \n new line character.'
formfeed = 'This string has a \f form feed character.'
carriage = 'This string has a \r carriage return character.'
slash = 'This string has a / slash character.'
backslash = 'This string has a \\ backslash character.']=]
		local sol = {
			backspace = "This string has a \\b backspace character.",
			tab = "This string has a \\t tab character.",
			newline = "This string has a \\n new line character.",
			formfeed = "This string has a \\f form feed character.",
			carriage = "This string has a \\r carriage return character.",
			slash = "This string has a / slash character.",
			backslash = "This string has a \\\\ backslash character."
		}
		assert.same(sol, obj)
	end)

	it("empty", function()
		local obj = TOML.parse[=[
answer = ""	
		]=]
		local sol = {
			answer = ""
		}
		assert.same(sol, obj)
	end)

	it("escapes", function()
		local obj = TOML.parse[=[
backspace = "This string has a \b backspace character."
tab = "This string has a \t tab character."
newline = "This string has a \n new line character."
formfeed = "This string has a \f form feed character."
carriage = "This string has a \r carriage return character."
quote = "This string has a \" quote character."
backslash = "This string has a \\ backslash character."
notunicode1 = "This string does not have a unicode \\u escape."
notunicode2 = "This string does not have a unicode \u005Cu escape."
notunicode3 = "This string does not have a unicode \\u0075 escape."
notunicode4 = "This string does not have a unicode \\\u0075 escape."]=]
		local sol = {
			backspace = "This string has a \b backspace character.",
			tab = "This string has a \t tab character.",
			newline = "This string has a \n new line character.",
			formfeed = "This string has a \f form feed character.",
			carriage = "This string has a \r carriage return character.",
			quote = "This string has a \" quote character.",
			backslash = "This string has a \\ backslash character.",
			notunicode1 = "This string does not have a unicode \\u escape.",
			notunicode2 = "This string does not have a unicode \\u escape.",
			notunicode3 = "This string does not have a unicode \\u0075 escape.",
			notunicode4 = "This string does not have a unicode \\u escape."
		}
		assert.same(sol, obj)
	end)

	it("simple", function()
		local obj = TOML.parse[=[
answer = "You are not drinking enough whisky."]=]
		local sol = {
			answer = "You are not drinking enough whisky."
		}
		assert.same(sol, obj)
	end)

	it("with pound", function()
		local obj = TOML.parse[=[
pound = "We see no # comments here."
poundcomment = "But there are # some comments here." # Did I # mess you up?]=]
		local sol = {
			pound = "We see no # comments here.",
			poundcomment = "But there are # some comments here."
		}
		assert.same(sol, obj)
	end)

	it("unicode", function()
		local obj = TOML.parse[=[
a = "第五福龍丸"
b = "東方地霊殿"]=]
		local sol = {
			a = "第五福龍丸",
			b = "東方地霊殿"
		}
		assert.same(sol, obj)
	end)

	it("supports crlf", function()
		local t, e = TOML.parse("a = " .. '"' .. "\13\10" .. '"')
		assert.same(t, nil)
		assert.same(e, 'At TOML line 1: Single-line string cannot contain line break.')
		local t, e = TOML.parse("a = " .. '"' .. "\13" .. '"')
		assert.same(t, {a='\r'})
		assert.same(e, nil)
	end)

	it("supports crlf at end of the data", function()
		local t, e = TOML.parse('a = "b"\13\10')
		assert.same(t, {a='b'})
		assert.same(e, nil)
	end)

	it("bad escape", function()
		local t, e = TOML.parse[[
bad = "this \aaa is wrong."
]]
		assert.same(nil, t)
		assert.same('string', type(e))
	end)

	it("bad unicode escape", function()
		local t, e = TOML.parse[[
str = "val\ue"
]]
		assert.same(nil, t)
		assert.same('string', type(e))
	end)
end)
