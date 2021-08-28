minetest.log("action", "[mc_economy] loading...")

local modpath = minetest.get_modpath(minetest.get_current_modname())

mc_economy = {}

dofile(modpath.."/api.lua")
dofile(modpath.."/items.lua")

if minetest.settings:get_bool("mc_economy.experimental", false) then
	dofile(modpath.."/commands.lua")
end

minetest.log("action", "[mc_economy] loaded succesfully")