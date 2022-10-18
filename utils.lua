local utils = {}

-- If true, the player's speed will be displayed
utils.showSpeeds = false

-- Constants for the basic optomizer (which is generally more trouble than it's worth)
utils.optimizationModes = {
	LO = 0,
	HI = 1,
}

-- Number of frames to hold the jump button for a max-height running jump (vanilla characters only, incomplete)
utils.maxJumps = {
	[CHARACTER_MARIO] = 37,
}

-- SMWmap player states
utils.SMWMAP_PLAYER_STATE = {
    NORMAL               = 0, -- just standing there
    WALKING              = 1, -- walking along a path
    SELECTED             = 2, -- just picked a level
    WON                  = 3, -- just returned from a level, and is waiting to unlock some paths
    CUSTOM_WARPING       = 4, -- using star road warp
    PARKING_WHERE_I_WANT = 5, -- illparkwhereiwant / debug mode
    SELECT_START         = 6, -- selecting the start point
}

local startTime = 0
--- Start a frame timer
function utils.startTimer()
	startTime = lunatime.tick()
	return -1
end

--- Stop the timer and display the amount of time elapsed since it started, in ticks. The same as calling lunatime.tick if no timer was started
function utils.stopTimer()
	Misc.dialog("Time: "..lunatime.tick() - startTime.." ticks")
	return -1
end

--- Display the current tick number
function utils.tick()
	Misc.dialog("Tick: "..lunatime.tick())
	return -1
end

local tps
--- Set the tick rate. Can be used to speed up a test (to reduce iteration time), or to slow down the game and get a better look at what's
-- happening. May have undesired results if the level being TASed uses Routines that call Routine.waitRealSeconds or the like
-- @tparam[opt=10000] number newTPS new tick speed, in ticks/sec
function utils.warp(newTPS)
	return function()
		if not tps then
			tps = Misc.GetEngineTPS()
		end
		Misc.SetEngineTPS(newTPS or 10000)
		return -1
	end
end

--- Return the tick rate to the default setting (about 64 fps)
function utils.endWarp()
	return function()
		Misc.SetEngineTPS(tps or Misc.GetEngineTPS()) -- prevent getting an error if warp was never called
		return -1
	end
end

--- Teleport the player. Safe to use between sections. If using this to test a section that the player normally enters through a warp, you should
-- teleport the player to that warp's entrance and have them enter it normally. Otherwise, the timings will be off during the test of the whole
-- level
-- @tparam number x X position
-- @tparam number y Y position
function utils.tp(x, y)
	assert(x, "Missing x coordinate for teleport")
	assert(y, "Missing y coordinate for teleport")
	return function()
		player:teleport(x, y) 
		player.speedX = 0 
		player.speedY = 0 
		return -1
	end
end

--- Set the player's powerup state
-- @tparam number state The powerup state. The constants for these are listed at https://docs.codehaus.moe/#/constants/powerups
function utils.pow(state)
	return function()
		player.powerup = state
		return -1
	end
end

--- Show a dialog message
--@tparam string message Message to display
function utils.dialog(msg)
	return function()
		Misc.dialog(msg)
		return -1
	end
end

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
