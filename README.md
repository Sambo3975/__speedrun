# __speedrun

Version 1.1

A TASBot for SMBX2, implemented in the engine's Lua API. This bot allows for full input manipulation on player 1, including manipulation of the `rawKeys` table. This bot is capable of simple timed inputs, but integration with LunaLua allows for much more functionality, including position- and speed-based inputs. You can write your own checks as well, allowing for inputs based on anything in the engine state. It also includes loops, conditional branching, basic input optimization, and a derandomizer.

This can be used to create a TAS of a single level or a whole episode (as long as that episode does not use an SMBX 1.3-style world map).

You are free to use and modify this code as you see fit, so long as I am credited for my work.

Notes: 
- The derandomizer sets the built-in RNG library to always use a specific seed. As such, it will not derandomize NPCs from SMBX 1.3, nor will it derandomize any code that creates its own RNG instance.
- This library currently does not support SMBX 1.3-style world maps. I am looking into adding support, but it may not be possible.

See the [wiki](https://github.com/Sambo3975/__speedrun/wiki/) for documentation.

## Changelogs:

Note: New features may not yet be documented. You may need to inspect the code to figure out how to use new features.

### v. 1.1:
- Added an experimental input recording/playback system.
- Inputs are no longer overridden while the game is paused unless the ignorePause flag is set (this was supposed to be a feature for some time but was implemented incorrectly).
- Inputs are no longer overridden while the player is dead unless the ignoreDeath flag is set.

Note: There is currently an issue where input playback can differ slightly from the original inputs. It appears that switching from playback to manual control as the level is running results in a hiccup in the recording for some reason, but I didn't have much time to investigate.
