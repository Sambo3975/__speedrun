# __speedrun
A TASBot for SMBX2, implemented in the engine's Lua API. This bot allows for full input manipulation on player 1, including manipulation of the `rawKeys` table. This bot is capable of simple timed inputs, but integration with LunaLua allows for much more functionality, including position- and speed-based inputs. You can write your own checks as well, allowing for inputs based on anything in the engine state. It also includes loops, conditional branching, basic input optimization, and a derandomizer.

Note: The derandomizer sets the built-in RNG library to always use a specific seed. As such, it will not derandomize NPCs from SMBX 1.3, nor will it derandomize any code that creates its own RNG instance.

See the wiki for documentation.
