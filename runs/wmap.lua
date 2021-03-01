print("loaded wmap")
SaveData.speedrunProgress = SaveData.speedrunProgress or 0

local inputsByProgress = {
	{ -- initial game setup
		{"dotimes",4,{
			"j",{1}, -- Welcome...; I have a...; language select; wonderful...
			"",{65},
		}},
		{"dotimes",3,{
			"j",{1}, -- enable input display; enable speedrun timer; disable cutscenes
			"d",{1},
		}},
		"",{1},
		{"dotimes",8,{
			"d",{1},
			"",{1}, -- navigate to Done!
		}},
		{"dotimes",3,{
			"j",{1}, -- select Done!; thank you; I hope you...
			"",{65},
		}},
	},
}

SaveData.speedrunProgress = SaveData.speedrunProgress + 1

-- freeze for testing
if SaveData.speedrunProgress > 2 then
	SaveData.speedrunProgress = 2
end

inputsByProgress[SaveData.speedrunProgress].global = true
return inputsByProgress[SaveData.speedrunProgress]
