local utils = {}

function utils.tp(x, y)
	return function()
		player:teleport(x, y) 
		player.speedX = 0 
		player.speedY = 0 
		return true
	end
end

function utils.dialog(msg)
	return function()
		Misc.dialog(msg)
		return true
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

return utils
