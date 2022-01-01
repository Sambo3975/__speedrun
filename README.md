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

5. make that .lua file return a table with the input instructions for the level. Look inside `__speedrun/speedrun.lua` for documentation. I am currently working on adding more documentation here

# Using the Library

This library uses input instruction tables to tell the bot what to input to the player. Input instruction tables have an appearance similar to a Lisp (list-processing) language. This is because they do essentially the same thing, but with a Lua table instead of a linked list.

This library expects the `.lua` file for each level to return a table of input instructions. Read on for more information. For the samples of code below, we will stick with the `watermelon` example from the previous section

## Structure

There are two types of structures available. The input instructions may be stored per-section, or they may be global to the entire level.

### Per-section inputs

This is generally the recommended structure to use. To use it, simply store inputs at indexes corresponding to the section indexes. Since sections are zero-indexed and Lua tables are normally one-indexed, you will need to manually assign to index zero, giving you a `watermelon.lua` file that looks like this:

```lua
return {
    [0] = {
        -- ... instructions for section 0 here ...
    },
    {
        -- ... instructions for section 1 here ...
    },
    -- ... instructions for any other sections. There may be gaps in this table if necessary ...
}
```

### Level-wide inputs

This stores inputs for the whole level in a single list. This should only be used in a limited set of circumstances, such as on a world map. To use this mode, set the `global` key in your table. This results in a file like this:

```lua
return {
    global = true,
    -- ... instructions for level here ...
}
```

## Setting the seed for the derandomizer

By default, the derandomizer sets the RNG seed to `8675309`. Chances are, this isn't the optimal seed. You can change the seed by setting the `seed` key in the inputs table:

```lua
return {
    seed = 23409485023
    [0] = {
        -- ...
    },
    -- ...
}
```

As for methods for finding the best seed, you're on your own. This is not an area I know much about. However, if, like me, you put the TAS together one section at a time, you may find that the RNG stuff differs from your testing during the final run. There is some crude functionality in this library for handling that situation. This works by repeatedly selecting random seeds until one is found that does not result in the player's death. This isn't yet fully implemented.

To enable it, uncomment lines 527, 528, and 570, and comment out line 568 in `speedrun.lua`, then run the level with the TASBot. The run will proceed until the player dies, then it will restart. This will continue until the level has been cleared, at which point, a dialog will appear showing the seed that worked. Copy that seed into the seed field of the instruction table. Note that this could take several hours. I would recommend running it overnight or at any other time when you will be away from the computer.
