# ExampleMod

This is an example mod for my [SNKRX modloader](https://github.com/sharpdev-me/SNKMD)! It highlights a few of the simpler effects of the modloader, and helps explain some of the easier concepts.

## main.lua

This file is responsible for executing all the code of the mod. It create a new unit, the Bishop, which heals all allied units in an area around it.

If you try to edit this file, you may receive warnings from your editor about "undefined globals." In the future, I will have a solution for this (at the very least, a wiki), but for now you will just have to look at the SNKRX code.

## mod_data.txt

This file describes the mod for the modloader. The file in this example displays all the possible settings, but your mod will load with only `name` and `main`.