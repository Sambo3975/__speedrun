local function jumpNotify()
	Misc.dialog("jump")
	return true
end

return {
	[0] = {
		"rn",{"x",">=",-199240},
		"jrn",{"md"},              -- collect #1-2 of coin group (CG) #1
		"rn",{"tg"},
		"jrn",{"x",">=",-198592},  -- collect CG #2
		{"dotimes",4,{
			"r",{1},
			"rn",{8}, -- break through brick pile (BP) #1
		}},
		"rn",{"then",{{"x",">=",-198240},{"tg"}}},
		"jrn",{2},               -- jump over the small slope
		"rn",{"tg"},
		"r",{1},
		"rn",{"x",">=",-197616}, -- kill Dino Torch (DT) #1; run down the slope for a bit of extra speed
		{"dotimes",3,{
			"r",{1},
			"rn",{4},            -- break through BP #3,
		}},
		{"dotimes",5,{
			"r",{1},
			"jrn",{4},           -- break through BP #2, ignoring DT #2
		}},
		"r",{1},
		"rn",{9},
		"jrn",{2},               -- jump onto the pipe
		"rn",{"tg"},
		"jrn",{6},               -- jump just high enough to bounce off Dino Rhino (DR) #1
		"rn",{9},
		"jrn",{10},              -- bounce off DR #1 over the Muncher pit; collect #2-3 of CG #3
		"rn",{"tg"},
		"jrn",{15},              -- jump onto the next pipe (it was a bit tricky to avoid slowing down here)
		"rn",{"tg"},
		"jrn",{9},               -- jump up to the platform with DT #3 on it 
		"rn",{"md"},
		"r",{1},
		"rn",{"tg"},             -- kill DT #3
		"jrn",{7},               -- jump up to collect #1-3 of CG #4
		"rn",{"tg"},
		"jrn",{"md"},            -- jump onto DR #2's head
		"rn",{"mu"},
		"jrn",{20},              -- collect Heart #1
		"rn",{"tg"},
		"jrn",{"md"},            -- jump onto the pipe
		"rn",{"x",">=",-194752},
		"r",{1},
		"rn",{"x",">=",-194496-16}, -- kill the plant and one of the DTs
		{"dotimes",3,{
			"r",{1},
			"rn",{4},               -- break through BP #3,
		}},
		{"dotimes",6,{
			"r",{1},
			"jrn",{4},              -- break through BP #3,
		}},
		"rn",{20},
		"jrn",{1},
		"rn",{"x",">=",-193616},
		{"dotimes",2,{
			"jrn",{"md"},           -- jump over the first 3 Chucks
			"rn",{"tg"},
		}},		
		"jrn",{8},
		"rn",{"tg"},
		"jrn",{"x",">=",-192576},
		"jr",{1},
		"jrn",{"md"},
		"rn",{"x",">=",-192224},
		"r",{1},
		"rn",{8},
		"r",{1},
		"rn",{"x",">=",-192080},
		"arn",{9},                  -- collect Heart #2
		"rn",{"then",{{"tg"},{1}}}, -- kill the first jumping Piranha Plant
		"jrn",{16},
		"rn",{"then",{{"md"},{"mu"}}},
		"jrn",{"md"},               -- bounce off the first DR
		"rn",{"tg"},
		"jrn",{1},                  -- collect Heart #3
		"rn",{7},
		"ln",{"ml"},
		"n",{"then",{{"y",">=",-200280-256},{5}}},
		"rn",{"y",">=",-200184},
		{"dotimes",3,{
			"drn",{"tg"},               -- repeatedly duck jump to get through the tight space between the pipe and the ground
			"jdrn",{"md"},
		}},     
		"d",{26},                       -- charge a big spinjump
		"arn",{"then",{{"md"},{12}}},   -- big spinjump up to the platform to the right of the blue coins
		"drn",{"tg"},
		"rn",{"x",">=",-190272},
		"r",{1},
		"rn",{"then",{{"ntg"},{"tg"}}}, -- kill the DT; run off the edge
		"jrn",{1},                      -- collect the 3 Coins 
		"rn",{20},
		"d",{50},                       -- another big spinjump
		"arn",{"md"},                   -- break the bricks to land on the platform
		"drn",{4},
		"rn",{"tg"},
		"r",{1},
		"rn",{"then",{{"x",">=",-188992},{"tg"}}}, -- run off the end of the platform
		"jrn",{20}, -- jump over the rocks to collect the two Coins above them
		"rn",{"tg"},
		"jrn",{16}, -- jump over the Fire Snake
		"rn",{"then",{{"tg"},{"ntg"},{"tg"},{3}}},
		"arn",{"md"}, -- spinjump to kill both 
		"rn",{"mu"},
		"jrn",{1},    -- get a tiny bit of extra height off the Fire Snake to hit the first ? block
		"rn",{"tg"},
		"jrn",{10},   -- collect the three coins
		"rn",{48},
		"d",{43},
		"arn",{"md"}, -- another big spinjump to get out of the hole
		"drn",{"tg"},
		"rn",{"then",{{"x",">=",-186624},{2}}},
		"jrn",{6},    -- jump over the Fire Snake
		"rn",{"tg"},
		"jrn",{10},   -- collect as many of the coins as possible
		"rn",{"tg"},
		"jrn",{12},   -- jump over the falling rocks
		"rn",{8},
		"d",{59},
		"arn",{"md"},
		"drn",{"x",">=",-185472-8},
		"dln",{"ml"},
		-- "dn",{4},
		"drn",{"tg"},
		"rn",{35},
		"jrn",{12},
		"rn",{"tg"},
		"jrn",{7},
		"drn",{"tg"},
		
		"rn",{100},
	},
}