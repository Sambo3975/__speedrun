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

local tps
function utils.warp(newTPS)
	return function()
		tps = Misc.GetEngineTPS()
		Misc.SetEngineTPS(newTPS or 10000)
		return -1
	end
end

function utils.endWarp()
	return function()
		Misc.SetEngineTPS(tps)
		return -1
	end
end

function utils.tp(x, y)
	return function()
		player:teleport(x, y) 
		player.speedX = 0 
		player.speedY = 0 
		return -1
	end
end

function utils.pow(state)
	return function()
		player.powerup = state
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

registerEvent(utils, "onCameraDraw")
function utils.onCameraDraw(idx)
	local prints = {}
	if utils.showSpeeds then
		table.insert(prints, player.speedX)
		table.insert(prints, player.speedY)
	end
	if utils.showInWater then
		table.insert(prints, player.isInWater)
	end
	local y = Camera(idx).height
	for i = #prints,1,-1 do
		y = y - 20
		Text.printWP(prints[i], 10, y, 10)
	end
end

return utils
