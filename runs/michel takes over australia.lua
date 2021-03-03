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
		"jrn",{"md"},               -- jump over the first 3 Chucks
		"rn",{"x",">=",-193152},
		"jrn",{"md"},
		"rn",{"tg"},
		"jrn",{6},
		
		"rn",{"x",">=",-192288},
		"r",{1},
		"rn",{4},
		"r",{1},
		"rn",{"x",">=",-192160},
		"arn",{4},
		
		"rn",{100},
	},
}