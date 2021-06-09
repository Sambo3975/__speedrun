# __speedrun
A TASBot for SMBX2

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

3. Create a folder in the `__speedrun` folder named `runs`
4. Create a `.lua` file in the `runs` folder with the same name as the level you wish to TAS. For example, if the level is named `watermelon.lvlx`, you would create a file in the 
`runs` folder named `watermelon.lua`.

5. make that .lua file return a table with the input instructions for the level.
