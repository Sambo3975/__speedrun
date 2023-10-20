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
<<<<<<< HEAD

--- Start a timer that counts from the current tick.
=======
--- Start a frame timer
>>>>>>> 08e0c78c3a269356fa0fe1adb29f29383b09fd5d
function utils.startTimer()
	startTime = lunatime.tick()
	return -1
end

<<<<<<< HEAD
--- Stop the timer and show a dialog box with the total counted time. Shows time since tick 0 if no timer was started.
=======
--- Stop the timer and display the amount of time elapsed since it started, in ticks. The same as calling lunatime.tick if no timer was started
>>>>>>> 08e0c78c3a269356fa0fe1adb29f29383b09fd5d
function utils.stopTimer()
	Misc.dialog("Time: "..lunatime.tick() - startTime.." ticks")
	return -1
end

<<<<<<< HEAD
--- Show the current tick number in a dialog box
=======
--- Display the current tick number
>>>>>>> 08e0c78c3a269356fa0fe1adb29f29383b09fd5d
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

--- Return the simulation speed to normal.
function utils.endWarp()
	return function()
		Misc.SetEngineTPS(tps or Misc.GetEngineTPS()) -- prevent getting an error if warp was never called
		return -1
	end
end

--- Teleport the player and set their speed to zero. Used to skip portions of the run during testing to reduce wait time. This uses Player:teleport, so it is safe to teleport between sections. Note that skipping parts of a run may change some RNG outputs, changing timings. When skipping a section in the level with this, you should teleport to the warp that exits the section, then have the player enter it. This ensures that timings in the next section are the same as when entering it normally.
-- @tparam number x X-position to teleport to
-- @tparam number y Y-position to teleport to
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

--- Set the player's HP. (for Peach, Toad, and Link)
-- @tparam number amt Amount of HP.
function utils.hp(amt)
	return function()
		player:mem(0x16, FIELD_WORD, amt) -- strange that the player doesn't have a named field for this
		return -1
	end
end

--- Show a dialog box
-- @tparam string msg Message to display. Used mostly to figure out timings during testing.
function utils.dialog(msg)
	return function()
		Misc.dialog(msg)
		return -1
	end
end

utils.lastSpeed = math.huge

--- Count the time needed for a vertical speed increase, then display that time in ticks.
function utils.vsi()
	return function()
		if (startTime == 0) then
			startTime = lunatime.tick()
		end
		if (player.speedY > utils.lastSpeed) then
			Misc.dialog("Speed increased after "..(lunatime.tick()-startTime).." ticks.")
			startTime = 0			
			return true
		else
			utils.lastSpeed = player.speedY
			return false
		end
	end
end

--- This function was used to change settings for a TAS of a specific episode. It isn't generally useful and will be moved out of this file.
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
