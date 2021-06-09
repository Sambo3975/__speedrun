---------------------------
-- Speedrun.lua
-- TAS system for SMBX
---------------------------
-- Created by Sambo

local sr = {}

local keys = {"run", "altRun", "up", "down", "left", "right", "jump", "altJump", "dropItem", "pause"}
local charToKey = {
	j = "jump",
	a = "altJump",
	i = "dropItem",
	p = "pause",
	u = "up",
	d = "down",
	l = "left",
	r = "right",
	n = "run",
	t = "altRun",
}

local sectionInputs, currentInputs, currentSect, addr
local flags = {
	ignorePause = false,
}

local strToComparison = {
	["<"] = function(a, b) return a < b end,
	["<="] = function(a, b) return a <= b end,
	["=="] = function(a, b) return a == b end,
	[">="] = function(a, b) return a >= b end,
	[">"] = function(a, b) return a > b end,
}

local function copy(x)
	if type(x) == "table" then
		return table.deepclone(x)
	else
		return x
	end
end

local runFunction
local showingMessageBox = false
local runFunction

-- args[1] is always the name of the function
-- args[#args] is generally the input codes
local builtins = {
	--[[ repeat n times. Example (performs 4 standing max-height jumps in a row):
	{"dotimes",4,{
		"",{"tg"},  -- wait until on the ground (if starting on the ground, we IMMEDIATELY do the next input)
		"j",{"md"}, -- hold the jump key until beginning to move downward (this will occur at the apex of the jump)
	}}
	]]
	dotimes = function(args)
		local reps = args[2]
		local inputSeq = args[3]
		for i = 1,reps do
			for k,v in ipairs(inputSeq) do
				table.insert(currentInputs, addr+k, copy(v))
			end
		end
		return -1
	end,
	["do"] = function(args)
		local inputSeq = args[2]
		for k,v in ipairs(inputSeq) do
			table.insert(currentInputs, addr+k, copy(v))
		end
		return -1  -- signal that inputs were not manipulated by this function so we will move on to the next instruction
	end,
	--[[ check for the first condition until it is met, and then the second, and so on, until all conditions have been met. Example:
	"rn",{"then",{{"x",">=",-198240},{"tg"}}}, -- run right until x is at least -198240, then we are touching the ground
	]]
	["then"] = function(args)
		local conditions = args[2]
		if runFunction(conditions[1]) then
			table.remove(conditions, 1)
		end
		if #conditions == 0 then
			return true
		end
	end,
	--[[ x position check. examples:
		"rn",{"x",">=",512}, -- run to the right until x position is at least 512 pixels
		"ln",{"x","<",512}, -- run to the left until x position is less than 512 pixels
	]]
	x = function(args)
		return strToComparison[args[2]](player.x, args[3])
	end,
	-- y position check
	y = function(args)
		return strToComparison[args[2]](player.y, args[3])
	end,
	-- x speed check
	sx = function(args)
		return strToComparison[args[2]](player.speedX, args[3])
	end,
	-- y speed check
	sy = function(args) return strToComparison[args[2]](player.speedY, args[3]) end,
	-- moving up
	mu = function() return player.speedY < 0 end,
	-- moving down
	md = function() return not player:isGroundTouching() and player.speedY >= 0 end,
	-- moving left
	ml = function() return player.speedX <= 0 end,
	-- moving right
	mr = function() return player.speedX >= 0 end,
	-- touching ground
	tg = function() return player:isGroundTouching() end,
	-- not touching ground
	ntg = function() return not player:isGroundTouching() end,
	-- showing message box
	mb = function() return showingMessageBox end,
	-- climbing
	cl = function() return player:isClimbing() end,
	-- no forced state
	nfs = function() return player.forcedState == FORCEDSTATE_NONE end
}

--[[ conditional branch
{"if",{condition},
		{actions if true},
	{actions if false},
},
]]
builtins["if"] = function(args)
	-- Misc.dialog(currentInputs)
	local condition = args[2]
	local trueActions = args[3]
	local falseActions = args[4]
	result = runFunction(condition)
	if result and trueActions then
		builtins["do"]{args[1], trueActions}
	elseif not result and falseActions then
		builtins["do"]{args[1], falseActions}
	end
	-- Misc.dialog(currentInputs)
	return -1
end

--[[
{"when",{condition},{
	actions if true
}},
]]
builtins["when"] = function(args)
	return builtins["if"]{args[1], args[2], args[3], nil}
end

--[[
{"unless",{condition},{
	actions if false
}},
]]
builtins["unless"] = function(args)
	return builtins["if"]{args[1], args[2], nil, args[3]}
end

function runFunction(instr)
	if not instr then
		if type(currentInputs[addr]) == "string" then
			instr = currentInputs[addr+1]
		else
			instr = currentInputs[addr]
		end
	end
	
	-- process the condition for this instruction; return true if condition has been met
	-- Misc.dialog(currentInputs)
	-- Misc.dialog(instr)
	local func = instr[1]
	local typ = type(func)
	if typ == "number" then
		instr[1] = func - 1
		return func == 0
	elseif typ == "string" then
		if flags[func] ~= nil then
			flags[func] = not flags[func]
			return true
		else
			if builtins[func] then
				return builtins[func](instr)
			else
				error("No builtin with name '"..func.."'")
			end
		end
	elseif typ == "function" then
		return func(instr)
	else
		error("Invalid instruction: "..func)
	end
end

local function runInstruction()
	local doNext
	if not Misc.isPaused() or not flags.ignorePause then
		doNext = runFunction()
	end
	
	if addr <= #currentInputs then
		if not doNext then
			local inputs = currentInputs[addr]
			-- process player inputs
			local newkeys = {}
			for c in inputs:gmatch(".") do
				newkeys[charToKey[c] or error("Invalid key code: "..c)] = true
			end
			for _,k in ipairs(keys) do
				if newkeys[k] then
					player.keys[k] = true
				else
					player.keys[k] = false
				end
			end
		else
			if doNext == true then
				addr = addr + 2
			elseif doNext == -1 then
				addr = addr + 1
			end
			if addr <= #currentInputs then
				runInstruction()
			end
		end
	end
end

-- registerEvent(sr, "onInputUpdate")
function sr.onInitAPI()
	registerEvent(sr, "onInputUpdate", "onInputUpdate", true)
	registerEvent(sr, "onStart", "onStart", false)
	registerEvent(sr, "onMessageBox")
	-- stuff to find a working seed while AFK
	-- registerEvent(sr, "onPostPlayerKill")
	-- registerEvent(sr, "onExitLevel")
end

local seed
function sr.onPostPlayerKill(p)
	Level.exit(0) -- will immediately restart the level if in testing mode
end

function sr.onExitLevel(winType)
	if winType ~= LEVEL_WIN_TYPE_NONE then
		Misc.dialog("succeeded on seed "..seed)
	end
end

function sr.onMessageBox()
	showingMessageBox = true
end

function sr.onStart()
	local file = "__speedrun/runs/"..Level.filename():gsub(".lvlx", ""):gsub(".lvl","")
	local f = io.open(Misc.episodePath()..file..".lua")
	local seedOverride
	if f ~= nil then
		f:close()
		local inputList = require(file)
		if inputList.global then
			currentInputs = inputList
			addr = 1
			assert(currentInputs, "currentInputs empty after set")
		else
			sectionInputs = inputList
			assert(sectionInputs, "sectionInputs empty after set")
		end
		seedOverride = inputList.seed
	else
		sectionInputs = {}
	end
	-- Disable randomization
	RNG.seed = seedOverride or 8675309
	-- Misc.dialog("seed = "..RNG.seed)
	-- seed = RNG.seed -- store the seed as it was when the level started (grabbing it later gives a much larger value that's not so easy to work with)
	-- registerEvent(sr, "onInputUpdate")
end

function sr.onInputUpdate()
	-- Misc.dialog("seed = "..RNG.seed)
	-- Misc.dialog("speedrun")
	if lunatime.tick() == 0 then return end
	if sectionInputs and player.section ~= currentSect then
		currentSect = player.section
		currentInputs = sectionInputs[player.section]
		addr = 1
	end
	
	-- if not currentInputs then
		-- Misc.dialog("no current inputs")
	-- elseif addr > #currentInputs then
		-- Misc.dialog("addr is too high")
	-- elseif not not flags.ignorePause and Misc.isPaused() then
		-- Misc.dialog("paused")
	-- end
	if not currentInputs or addr > #currentInputs then return end
	
	-- Misc.dialog(lunatime.tick()..": "..addr)
	runInstruction()
	
	showingMessageBox = false
end

return sr
