local utils = {}

local startTime = 0
function utils.startTimer()
	startTime = lunatime.tick()
	return -1
end

function utils.stopTimer()
	Misc.dialog("Time: "..lunatime.tick() - startTime.." ticks")
	return -1
end

function utils.tick()
	Misc.dialog("Tick: "..lunatime.tick())
	return -1
end

function utils.tp(x, y)
	return function()
		player:teleport(x, y) 
		player.speedX = 0 
		player.speedY = 0 
		return -1
	end
end

function utils.dialog(msg)
	return function()
		Misc.dialog(msg)
		return -1
	end
end

function utils.setupSpeedrun()
	local setup = true
	if not GameData.setupSpeedrun then
		setup = false
		GameData.setupSpeedrun = true
	end
	return setup
end

utils.setupInputs = {
	-- menu handles keys in this order, d, u, j, r, l, n
	-- this takes 0.5 seconds
	"pu",{1,ignorePause=true},
	"",{1},
	"uj",{1},  -- Options
	"",{1},
	"j",{1},   -- enable Input Display
	"d",{1},
	"j",{1},   -- enable Speedrun Timer
	{"dotimes",9,{
		"",{1},
		"d",{1}
	}},
	"",{1},
	"djn",{1}, -- disable Checkpoints; back
	"u",{1},
	"",{1},
	"uj",{1},  -- restart
	"l",{1},
	"j",{1},   -- confirm restart; comment this out for recording
}

utils.showSpeeds = false

utils.optimizationModes = {
	LO = 0,
	HI = 1,
}
utils.maxJumps = {
	[CHARACTER_MARIO] = 37,
}

registerEvent(utils, "onDraw")
function utils.onDraw()
	if utils.showSpeeds then
		Text.print(player.speedX, 10, 560)
		Text.print(player.speedY, 10, 580)
		Text.print(tostring(player.IsInWater), 10, 540)
	end
end

return utils
