---------------------------
-- Speedrun.lua
-- TAS system for SMBX
---------------------------
-- Created by Sambo

local sr = {}

-- Instruction types
-- {time(num), inputs(str)} : hold the given <inputs> for <time> frames
-- {func(str/function), [args], ..., inputs}

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

local sectInputs, currentInputs, currentSect, addr, doNext
local flags = {
	ignorePause = false,
}

local strToComparison = {
	["<"] = function(a, b) return a < b end,
	["<="] = function(a, b) return a <= b end,
	["=="] = function(a, b) return a == b end,
	[">="] = function(a, b) return a >= b end,
	["<"] = function(a, b) return a > b end,
}

-- args[1] is always the name of the function
-- args[#args] is generally the input codes
local builtins = {
	-- x position check
	x = function(args)
		print(lunatime.tick()..": called x")
		return strToComparison[args[2]](player.x, args[3])
	end,
	-- y position check
	y = function(args)
		return strToComparison[args[2]](player.y, args[3])
	end,
	-- moving up
	mu = function() return player.speedY < 0 end,
	-- moving down
	md = function() return player.speedY >= 0 end,
	-- moving left
	ml = function() return player.speedX <= 0 end,
	-- moving right
	mr = function() return player.speedX >= 0 end,
	-- touching ground
	tg = function() return player:isGroundTouching() end,
	-- not touching ground
	ntg = function() return not player:isGroundTouching() end,
	
	-- not
	-- ["not"] = function(args)
		-- local func = args[2]
		-- local typ = type(cond)
		-- if typ == "string" then
			-- if builtins[func] then
				-- return not builtins[func](args)
			-- else
				-- error("No builtin with name '"..func.."'")
			-- end
		-- elseif typ == "function" then
			-- return not func()
		-- end
	-- end
}

local function runInstruction()
	doNext = false
	local instr = currentInputs[addr+1]
	
	-- process the condition for this instruction; return true if condition has been met
	local done = false
	local func = instr[1]
	local typ = type(func)
	if typ == "number" then
		instr[1] = func - 1
		done = func == 0
	elseif typ == "string" then
		if flags[func] ~= nil then
			flags[func] = not flags[func]
			doNext = true
		else
			if builtins[func] then
				done = builtins[func](instr)
			else
				error("No builtin with name '"..func.."'")
			end
		end
	elseif typ == "function" then
		done = func(instr)
	else
		error("Invalid instruction: "..func)
	end
	
	if done and addr + 2 <= #currentInputs then
		addr = addr + 2
	end
	
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
		addr = addr + 2
		parseInstruction()
	end
	
	return done
end

function sr.onInitAPI()
	registerEvent(sr, "onInputUpdate")
	registerEvent(sr, "onStart", "onStart", false)
end

function sr.onStart()
	local file = "__speedrun/runs/"..Level.filename():gsub(".lvlx", ""):gsub(".lvl","")
	local f = io.open(Misc.episodePath()..file..".lua")
	if f ~= nil then
		f:close()
		sectInputs = require(file)
	else
		sectInputs = {}
	end
end

function sr.onInputUpdate()
	if player.section ~= currentSect then
		currentSect = player.section
		currentInputs = sectInputs[player.section]
		addr = 1
	end
	
	-- if not currentInputs then
		-- Misc.dialog("no current inputs")
	-- elseif addr > #currentInputs then
		-- Misc.dialog("addr is too high")
	-- elseif not not flags.ignorePause and Misc.isPaused() then
		-- Misc.dialog("paused")
	-- end
	if not currentInputs or addr > #currentInputs or (not flags.ignorePause and Misc.isPaused()) then return end
	
	runInstruction()
end

return sr
