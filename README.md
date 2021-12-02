# __speedrun
A TASBot for SMBX2, implemented in the engine's Lua API. This bot allows for full input manipulation on player 1, including manipulation of the `rawKeys` table. This bot is capable of simple timed inputs, but integration with LunaLua allows for much more functionality, including position- and speed-based inputs. You can write your own checks as well, allowing for inputs based on anything in the engine state. It also includes loops, conditional branching, basic input optimization, and a derandomizer.

Note: The derandomizer sets the built-in RNG library to always use a specific seed. As such, it will not derandomize NPCs from SMBX 1.3, nor will it derandomize any code that creates its own RNG instance.

To use this, do the following:
1. Drop a copy of the `__speedrun` folder into the directory of the episode you wish to make a TAS in.
2. Add the following lines to the very top of the episode- or level-wide luna.lua file:

```lua
-- small mod for TAS
if Misc.saveSlot() == 2 or Misc.inEditor() then
	require("__speedrun/speedrun")
end
```
This will load the TASBot for the episode, which will override inputs if a) a level in the episode folder is tested from the PGE/Moondust editor, or a level in the folder is 
entered in-game with the second save file slot being used; and b) there is a .lua file containing input instructions for the current level. You must put this at the _very top_ 
of the episode's luna.lua file, to ensure that it runs before all onInputUpdate functions in libraries, episode code, and level code. Otherwise, you may get strange behavior.

3. In the episode folder, create a folder named `__runs`. This should be on the same level as the `__speedrun` folder, not inside it.

4. Create a `.lua` file in the `runs` folder with the same name as the level you wish to TAS. For example, if the level is named `watermelon.lvlx`, you would create a file in the 
`runs` folder named `watermelon.lua`.

Keeping with the `watermelon` example from above, the resulting directory structure should look like this:
```
EpisodeFolder/
	__speedrun/
	__runs/
		watermelon.lua
	watermelon/
	watermelon.lvlx
```

5. make that .lua file return a table with the input instructions for the level. Look inside `__speedrun/speedrun.lua` for documentation.
