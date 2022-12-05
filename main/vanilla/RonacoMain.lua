--[[

    Ronaco
    (c) Ooflet 2022

    - Hello!

]]

--[[
    
     Feel free to modify Ronaco for your own purposes as long as you credit in one way or another. A simple "This script uses Ronaco" will do.

     Supports UNC standards. No need to declare every goddamn possible function. 

]]

--[[
    
    - Licence to skid 

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
    to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, 
    sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
    FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]

----------------------------------------------------------------------
-- Lexer Setup --
----------------------------------------------------------------------

local yield, wrap  = coroutine.yield, coroutine.wrap
local strfind      = string.find
local strsub       = string.sub
local append       = table.insert
local type         = type

local NUMBER1	= "^[%+%-]?%d+%.?%d*[eE][%+%-]?%d+"
local NUMBER2	= "^[%+%-]?%d+%.?%d*"
local NUMBER3	= "^0x[%da-fA-F]+"
local NUMBER4	= "^%d+%.?%d*[eE][%+%-]?%d+"
local NUMBER5	= "^%d+%.?%d*"
local IDEN		= "^[%a_][%w_]*"
local WSPACE	= "^%s+"
local STRING1	= "^(['\"])%1"							--Empty String
local STRING2	= [[^(['"])(\*)%2%1]]
local STRING3	= [[^(['"]).-[^\](\*)%2%1]]
local STRING4	= "^(['\"]).-.*"						--Incompleted String
local STRING5	= "^%[(=*)%[.-%]%1%]"					--Multiline-String
local STRING6	= "^%[%[.-.*"							--Incompleted Multiline-String
local CHAR1		= "^''"
local CHAR2		= [[^'(\*)%1']]
local CHAR3		= [[^'.-[^\](\*)%1']]
local PREPRO	= "^#.-[^\\]\n"
local MCOMMENT1	= "^%-%-%[(=*)%[.-%]%1%]"				--Completed Multiline-Comment
local MCOMMENT2	= "^%-%-%[%[.-.*"						--Incompleted Multiline-Comment
local SCOMMENT1	= "^%-%-.-\n"							--Completed Singleline-Comment
local SCOMMENT2	= "^%-%-.-.*"							--Incompleted Singleline-Comment
local THINGY 	= "^[%.:]%w-%s?%(.-%)"

local lua_keyword = {
	["and"] = true,  ["break"] = true,  ["do"] = true,      ["else"] = true,      ["elseif"] = true,
	["end"] = true,  ["false"] = true,  ["for"] = true,     ["function"] = true,  ["if"] = true,
	["in"] = true,   ["local"] = true,  ["nil"] = true,     ["not"] = true,       ["while"] = true,
	["or"] = true,   ["repeat"] = true, ["return"] = true,  ["then"] = true,      ["true"] = true,
	["self"] = true, ["until"] = true
}

local lua_builtin = {
	["assert"] = true;["collectgarbage"] = true;["error"] = true;["_G"] = true;
	["gcinfo"] = true;["getfenv"] = true;["getmetatable"] = true;["ipairs"] = true;
	["loadstring"] = true;["newproxy"] = true;["next"] = true;["pairs"] = true;
	["pcall"] = true;["print"] = true;["rawequal"] = true;["rawget"] = true;["rawset"] = true;
	["select"] = true;["setfenv"] = true;["setmetatable"] = true;["tonumber"] = true;
	["tostring"] = true;["type"] = true;["unpack"] = true;["_VERSION"] = true;["xpcall"] = true;
	["delay"] = true;["elapsedTime"] = true;["require"] = true;["spawn"] = true;["tick"] = true;
	["time"] = true;["typeof"] = true;["UserSettings"] = true;["wait"] = true;["warn"] = true;
	["game"] = true;["Enum"] = true;["script"] = true;["shared"] = true;["workspace"] = true;
	["Axes"] = true;["BrickColor"] = true;["CFrame"] = true;["Color3"] = true;["ColorSequence"] = true;
	["ColorSequenceKeypoint"] = true;["Faces"] = true;["Instance"] = true;["NumberRange"] = true;
	["NumberSequence"] = true;["NumberSequenceKeypoint"] = true;["PhysicalProperties"] = true;
	["Random"] = true;["Ray"] = true;["Rect"] = true;["Region3"] = true;["Region3int16"] = true;
	["TweenInfo"] = true;["UDim"] = true;["UDim2"] = true;["Vector2"] = true;["Vector3"] = true;
	["Vector3int16"] = true;
	["os"] = true;
	--["os.time"] = true;["os.date"] = true;["os.difftime"] = true;
	["debug"] = true;
	--["debug.traceback"] = true;["debug.profilebegin"] = true;["debug.profileend"] = true;
	["math"] = true;
	--["math.abs"] = true;["math.acos"] = true;["math.asin"] = true;["math.atan"] = true;["math.atan2"] = true;["math.ceil"] = true;["math.clamp"] = true;["math.cos"] = true;["math.cosh"] = true;["math.deg"] = true;["math.exp"] = true;["math.floor"] = true;["math.fmod"] = true;["math.frexp"] = true;["math.ldexp"] = true;["math.log"] = true;["math.log10"] = true;["math.max"] = true;["math.min"] = true;["math.modf"] = true;["math.noise"] = true;["math.pow"] = true;["math.rad"] = true;["math.random"] = true;["math.randomseed"] = true;["math.sign"] = true;["math.sin"] = true;["math.sinh"] = true;["math.sqrt"] = true;["math.tan"] = true;["math.tanh"] = true;
	["coroutine"] = true;
	--["coroutine.create"] = true;["coroutine.resume"] = true;["coroutine.running"] = true;["coroutine.status"] = true;["coroutine.wrap"] = true;["coroutine.yield"] = true;
	["string"] = true;
	--["string.byte"] = true;["string.char"] = true;["string.dump"] = true;["string.find"] = true;["string.format"] = true;["string.len"] = true;["string.lower"] = true;["string.match"] = true;["string.rep"] = true;["string.reverse"] = true;["string.sub"] = true;["string.upper"] = true;["string.gmatch"] = true;["string.gsub"] = true;
	["table"] = true;
	--["table.concat"] = true;["table.insert"] = true;["table.remove"] = true;["table.sort"] = true;
}

local function tdump(tok)
	return yield(tok, tok)
end

local function ndump(tok)
	return yield("number", tok)
end

local function sdump(tok)
	return yield("string", tok)
end

local function cdump(tok)
	return yield("comment", tok)
end

local function wsdump(tok)
	return yield("space", tok)
end

local function lua_vdump(tok)
	if (lua_keyword[tok]) then
		return yield("keyword", tok)
	elseif (lua_builtin[tok]) then
		return yield("builtin", tok)
	else
		return yield("iden", tok)
	end
end

local function thingy_dump(tok)
	return yield("thingy", tok)
end

local lua_matches = {
	{THINGY, thingy_dump},

	{IDEN,      lua_vdump},        -- Indentifiers
	{WSPACE,    wsdump},           -- Whitespace
	{NUMBER3,   ndump},            -- Numbers
	{NUMBER4,   ndump},
	{NUMBER5,   ndump},
	{STRING1,   sdump},            -- Strings
	{STRING2,   sdump},
	{STRING3,   sdump},
	{STRING4,   sdump},
	{STRING5,   sdump},            -- Multiline-Strings
	{STRING6,   sdump},            -- Multiline-Strings

	{MCOMMENT1, cdump},            -- Multiline-Comments
	{MCOMMENT2, cdump},			
	{SCOMMENT1, cdump},            -- Singleline-Comments
	{SCOMMENT2, cdump},

	{"^==",     tdump},            -- Operators
	{"^~=",     tdump},
	{"^<=",     tdump},
	{"^>=",     tdump},
	{"^%.%.%.", tdump},
	{"^%.%.",   tdump},
	{"^.",      tdump},
}

local num_lua_matches = #lua_matches


--- Create a plain token iterator from a string.
-- @tparam string s a string.
function scan(s)

	local function lex(first_arg)

		local line_nr = 0
		local sz = #s
		local idx = 1

		-- res is the value used to resume the coroutine.
		local function handle_requests(res)
			while (res) do
				local tp = type(res)
				-- Insert a token list:
				if (tp == "table") then
					res = yield("", "")
					for i = 1,#res do
						local t = res[i]
						res = yield(t[1], t[2])
					end
				elseif (tp == "string") then -- Or search up to some special pattern:
					local i1, i2 = strfind(s, res, idx)
					if (i1) then
						local tok = strsub(s, i1, i2)
						idx = (i2 + 1)
						res = yield("", tok)
					else
						res = yield("", "")
						idx = (sz + 1)
					end
				else
					res = yield(line_nr, idx)
				end
			end
		end

		handle_requests(first_arg)
		line_nr = 1

		while (true) do

			if (idx > sz) then
				while (true) do
					handle_requests(yield())
				end
			end

			for i = 1,num_lua_matches do
				local m = lua_matches[i]
				local pat = m[1]
				local fun = m[2]
				local findres = {strfind(s, pat, idx)}
				local i1, i2 = findres[1], findres[2]
				if (i1) then
					local tok = strsub(s, i1, i2)
					idx = (i2 + 1)
					local res = fun(tok, findres)
					if (tok:find("\n")) then
						-- Update line number:
						local _,newlines = tok:gsub("\n", {})
						line_nr = (line_nr + newlines)
					end
					handle_requests(res)
					break
				end
			end

		end

	end

	return wrap(lex)

end

----------------------------------------------------------------------
-- Theme Setup --
----------------------------------------------------------------------

_G.Ronaco.Theme = {
	DefaultThemes = {
		["default"] = {
			["keyword"] = Color3.fromRGB(248, 109, 124),
			["builtin"] = Color3.fromRGB(84, 184, 247),
			["string"] = Color3.fromRGB(130, 241, 149),
			["number"] = Color3.fromRGB(255, 198, 0),
			["comment"] = Color3.fromRGB(106, 106, 100),
			["thingy"] = Color3.fromRGB(253, 251, 154)
		},
	}
}

----------------------------------------------------------------------
-- Highlighter Setup --
----------------------------------------------------------------------

local function ColorToFont(text, color)
	return string.format(
		'<font color="rgb(%s,%s,%s)">%s</font>',
		tostring(math.floor(color.R * 255)),
		tostring(math.floor(color.G * 255)),
		tostring(math.floor(color.B * 255)),
		text
	)
end

local function Highlight(textbox, source)
	textbox.Text = ""
	for tokenType, text in scan(source) do
		local currentTheme = _G.Ronaco.Theme.DefaultTheme["default"]
		local tokenCol = currentTheme[tokenType]

		if tokenCol then
			textbox.Text = textbox.Text .. ColorToFont(text, tokenCol)
		else
			textbox.Text = textbox.Text .. text
		end
	end
end

----------------------------------------------------------------------
-- GUI Setup --
----------------------------------------------------------------------

local function CreateIDE(parent)
	local EditorFrame = Instance.new("ScrollingFrame")
	local Source = Instance.new("TextBox")
	local Lines = Instance.new("TextLabel")

	EditorFrame.Name = "EditorFrame"
	EditorFrame.Parent = parent
	EditorFrame.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
	EditorFrame.BorderColor3 = Color3.fromRGB(61, 61, 61)
	EditorFrame.Size = UDim2.new(1, 0, 1, 0)
	EditorFrame.ZIndex = 3
	EditorFrame.BottomImage = "rbxassetid://148970562"
	EditorFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	EditorFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	EditorFrame.MidImage = "rbxassetid://148970562"
	EditorFrame.ScrollBarThickness = 5
	EditorFrame.TopImage = "rbxassetid://148970562"
	EditorFrame.AutomaticCanvasSize = Enum.AutomaticSize.XY

	Source.Name = "Source"
	Source.Parent = EditorFrame
	Source.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Source.BackgroundTransparency = 1.000
	Source.Position = UDim2.new(0, 45, 0, 0)
	Source.Size = UDim2.new(1, -45, 1, 0)
	Source.ZIndex = 3
	Source.ClearTextOnFocus = false
	Source.Font = Enum.Font.RobotoMono
	Source.MultiLine = true
	Source.PlaceholderColor3 = Color3.fromRGB(204, 204, 204)
	Source.Text = ""
	Source.TextColor3 = Color3.fromRGB(255, 255, 255)
	Source.TextSize = 16.000
	Source.TextXAlignment = Enum.TextXAlignment.Left
	Source.TextYAlignment = Enum.TextYAlignment.Top
	Source.AutomaticSize = Enum.AutomaticSize.XY

	Lines.Name = "Lines"
	Lines.Parent = EditorFrame
	Lines.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Lines.BorderSizePixel = 0
	Lines.Size = UDim2.new(0, 40, 1, 0)
	Lines.ZIndex = 4
	Lines.Font = Enum.Font.RobotoMono
	Lines.Text = "1"
	Lines.TextColor3 = Color3.fromRGB(255, 255, 255)
	Lines.TextSize = 16.000
	Lines.TextYAlignment = Enum.TextYAlignment.Top
	
	local lines = 1
	
	Source.Changed:Connect(function()
		-- Line Count	
		local _, count = Source:gsub("\n", "")
		if count ~= lines then
			if count > lines then
				Lines.Text = Lines.Text.."\n"..lines
			elseif count < lines then
				Lines.Text = Lines.Text:gsub(".?$","")	
			end
		end
		-- Highlighting
		Highlight(Source, Source.Text)
	end)
	
	
end
