return {
	strict = true,

	version = 0.31,

	parse = function(toml)
		local ws = "[\009\032]"
		
		local buffer = ""
		local cursor = 1
		local out = {}

		local obj = out

		local function char(n)
			n = n or 0
			return toml:sub(cursor + n, cursor + n)
		end

		local function step(n)
			n = n or 1
			cursor = cursor + n
		end

		local function skipWhitespace()
			while(char():match(ws)) do
				step()
			end
		end

		local function trim(str)
			return str:gsub("^%s*(.-)%s*$", "%1")
		end

		local function split(str, delim)
			if str == "" then return {} end
			local result = {}
			local append = delim
			if delim:match("%%") then
				append = delim:gsub("%%", "")
			end
			for match in (str .. append):gmatch("(.-)" .. delim) do
				table.insert(result, match)
			end
			return result
		end

		local function err(message, strictOnly)
			strictOnly = (strictOnly == nil) or true
			if not strictOnly or (strictOnly and TOML.strict) then
				local line = 1
				local c = 0
				for l in toml:gmatch("(.-)\n") do
					c = c + l:len()
					if c >= cursor then
						break
					end
					line = line + 1
				end
				error("TOML: " .. message .. " on line " .. line .. ".", 4)
			end
		end

		local function bounds()
			-- prevent infinite loops
			return cursor <= toml:len()
		end

		local function parseString()
			local quoteType = char() -- should be single or double quote
			local multiline = (char(1) == char(2) and char(1) == char())

			local str = ""
			step(multiline and 3 or 1)

			while(bounds()) do
				if multiline and char() == "\n" and str == "" then
					-- skip line break line at the beginning of multiline string
					step()
				end

				if char() == quoteType then
					if multiline then
						if char(1) == char(2) and char(1) == quoteType then
							step(3)
							break
						else
							err("Mismatching quotes")
						end
					else
						step()
						break
					end
				end

				if char() == "\n" and not multiline then
					err("Single-line string cannot contain line break")
				end

				if quoteType == '"' and char() == "\\" then
					if multiline and char(1) == "\n" then
						-- skip until first non-whitespace character
						step(1)
						while(bounds()) do
							if char() ~= " " and char() ~= "\t" and char() ~= "\n" then
								break
							end
							step()
						end
					else
						local escape = {
							b = "\b",
							t = "\t",
							n = "\n",
							f = "\f",
							r = "\r",
							['"'] = '"',
							["/"] = "/",
							["\\"] = "\\",
						}
						-- utf function from http://stackoverflow.com/a/26071044
						local function utf(char)
							local bytemarkers = {{0x7ff, 192}, {0xffff, 224}, {0x1fffff, 240}}
							if char < 128 then return string.char(char) end
							local charbytes = {}
							for bytes, vals in pairs(bytemarkers) do
								if char <= vals[1] then
									for b = bytes + 1, 2, -1 do
										local mod = char % 64
										char = (char - mod) / 64
										charbytes[b] = string.char(128 + mod)
									end
									charbytes[1] = string.char(vals[2] + char)
									break
								end
							end
							return table.concat(charbytes)
						end
						if escape[char(1)] then
							str = str .. escape[char(1)]
							step(2)
						elseif char(1) == "u" then
							-- utf-16
							step()
							local uni = char(1) .. char(2) .. char(3) .. char(4)
							step(5)
							uni = tonumber(uni, 16)
							str = str .. utf(uni)
						elseif char(1) == "U" then
							-- utf-32
							step()
							local uni = char(1) .. char(2) .. char(3) .. char(4) .. char(5) .. char(6) .. char(7) .. char(8)
							step(9)
							uni = tonumber(uni, 16)
							str = str .. utf(uni)
						else
							err("Invalid escape")
						end
					end
				else
					str = str .. char()
					step()
				end
			end

			return {value = str, type = "string"}
		end

		local function parseNumber()
			local num = ""
			local exp
			local date = false
			while(bounds()) do
				if char():match("[%+%-%.eE0-9]") then
					if not exp then
						if char():lower() == "e" then
							exp = ""
						else
							num = num .. char()
						end
					elseif char():match("[%+%-0-9]") then
						exp = exp .. char()
					else
						err("Invalid exponent")
					end
				elseif char():match(ws) or char() == "#" or char() == "\n" or char() == "," or char() == "]" then
					break
				elseif char() == "T" or char() == "Z" then
					date = true
					while(bounds()) do
						if char() == "," or char() == "]" or char() == "#" or char() == "\n" or char():match(ws) then
							break
						end
						num = num .. char()
						step()
					end
				else
					err("Invalid number")
				end
				step()
			end

			if date then
				return {value = num, type = "date"}
			end

			local float = false
			if num:match("%.") then float = true end

			exp = exp and tonumber(exp) or 1
			num = tonumber(num)

			return {value = num ^ exp, type = float and "float" or "int"}
		end

		local parseArray, getValue
		function parseArray()
			step()
			skipWhitespace()

			local arrayType
			local array = {}

			while(bounds()) do
				if char() == "]" then
					break
				elseif char() == "\n" then
					-- skip
					step()
					skipWhitespace()
				elseif char() == "#" then
					while(bounds() and char() ~= "\n") do
						step()
					end
				else
					local v = getValue()
					if not v then break end
					if arrayType == nil then
						arrayType = v.type
					elseif arrayType ~= v.type then
						err("Mixed types in array", true)
					end

					array = array or {}
					table.insert(array, v.value)
					
					if char() == "," then
						step()
					end
					skipWhitespace()
				end
			end
			step()

			return {value = array, type = "array"}
		end

		local function parseBoolean()
			local v
			if toml:sub(cursor, cursor + 3) == "true" then
				step(4)
				v = {value = true, type = "boolean"}
			elseif toml:sub(cursor, cursor + 4) == "false" then
				step(5)
				v = {value = false, type = "boolean"}
			else
				err("Invalid primitive")
			end

			skipWhitespace()
			if char() == "#" then
				while(char() ~= "\n") do
					step()
				end
			end

			return v
		end

		function getValue()
			if char() == '"' or char() == "'" then
				return parseString()
			elseif char():match("[%+%-0-9]") then
				return parseNumber()
			elseif char() == "[" then
				return parseArray()
			else
				return parseBoolean()
			end
			-- date regex:
			-- %d%d%d%d%-[0-1][0-9]%-[0-3][0-9]T[0-2][0-9]%:[0-6][0-9]%:[0-6][0-9][Z%:%+%-%.0-9]*
		end

		local tableArrays = {}
		while(cursor <= toml:len()) do
			if char() == "#" then
				while(char() ~= "\n") do
					step()
				end
			end

			if char():match(ws) then
				skipWhitespace()
			end

			if char() == "\n" then
				-- skip
			end

			if char() == "=" then
				step()
				skipWhitespace()
				buffer = trim(buffer)

				if buffer == "" then
					err("Empty key name")
				end

				local v = getValue()
				if v then
					if obj[buffer] then
						err("Cannot redefine key " .. buffer, true)
					end
					obj[buffer] = v.value
				end
				buffer = ""

				skipWhitespace()
				if char() == "#" then
					while(bounds() and char() ~= "\n") do
						step()
					end
				end
				if char() ~= "\n" and cursor < toml:len() then
					err("Invalid primitive")
				end

			elseif char() == "[" then
				buffer = ""
				step()
				local tableArray = false
				if char() == "[" then
					tableArray = true
					step()
				end

				while(bounds()) do
					buffer = buffer .. char()
					step()
					if char() == "]" then
						if tableArray and char(1) ~= "]" then
							err("Mismatching brackets")
						elseif tableArray then
							step()
						end
						break
					end
				end
				step()

				buffer = trim(buffer)

				obj = out
				local spl = split(buffer, "%.")
				for i, tbl in pairs(spl) do
					if tbl == "" then
						err("Empty table name")
					end

					if i == #spl and obj[tbl] and not tableArray then
						err("Cannot redefine table", true)
					end

					if tableArrays[tbl] then
						if buffer ~= tbl and #spl > 1 then
							obj = tableArrays[tbl]
						else
							obj = tableArrays[tbl]
							obj[tbl] = obj[tbl] or {}
							obj = obj[tbl]
							if tableArray then
								table.insert(obj, {})
								obj = obj[#obj]
							end
						end
					else
						obj[tbl] = obj[tbl] or {}
						obj = obj[tbl]
						if tableArray then
							table.insert(obj, {})
							obj = obj[#obj]
						end
					end

					tableArrays[buffer] = obj
				end

				buffer = ""
			end

			buffer = buffer .. char()
			step()
		end

		return out
	end,

	encode = function(tbl)
		local toml = ""

		local cache = {}

		local function parse(tbl)
			for k, v in pairs(tbl) do
				if type(v) == "boolean" then
					toml = toml .. k .. " = " .. tostring(v) .. "\n"
				elseif type(v) == "number" then
					toml = toml .. k .. " = " .. tostring(v) .. "\n"
				elseif type(v) == "string" then
					local quote = '"'
					v = v:gsub("\\", "\\\\")

					if v:match("^\n(.*)$") then
						quote = quote:rep(3)
						v = "\\n" .. v
					elseif v:match("\n") then
						quote = quote:rep(3)
					end

					v = v:gsub("\b", "\\b")
					v = v:gsub("\t", "\\t")
					v = v:gsub("\f", "\\f")
					v = v:gsub("\r", "\\r")
					v = v:gsub('"', '\\"')
					v = v:gsub("/", "\\/")
					toml = toml .. k .. " = " .. quote .. v .. quote .. "\n"
				elseif type(v) == "table" then
					local array, arrayTable = true, true
					local first = {}
					for kk, vv in pairs(v) do
						if type(kk) ~= "number" then array = false end
						if type(vv) ~= "table" then
							v[kk] = nil
							first[kk] = vv
							arrayTable = false
						end
					end

					if array then
						if arrayTable then
							-- double bracket syntax go!
							table.insert(cache, k)
							for kk, vv in pairs(v) do
								toml = toml .. "[[" .. table.concat(cache, ".") .. "]]\n"
								for k3, v3 in pairs(vv) do
									if type(v3) ~= "table" then
										vv[k3] = nil
										first[k3] = v3
									end
								end
								parse(first)
								parse(vv)
							end
							table.remove(cache)
						else
							-- plain ol boring array
							toml = toml .. k .. " = [\n"
							for kk, vv in pairs(v) do
								toml = toml .. tostring(vv) .. ",\n"
							end
							toml = toml .. "]\n"
						end
					else
						-- just a key/value table, folks
						table.insert(cache, k)
						toml = toml .. "[" .. table.concat(cache, ".") .. "]\n"
						parse(first)
						parse(v)
						table.remove(cache)
					end
				end
			end
		end
		
		parse(tbl)
		
		return toml:sub(1, -2)
	end
}
