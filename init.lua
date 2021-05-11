local modpath = minetest.get_modpath(minetest.get_current_modname())

mc_economy = {}

dofile(modpath.."/database.lua")
dofile(modpath.."/api.lua")
dofile(modpath.."/items.lua")
dofile(modpath.."/commands.lua")