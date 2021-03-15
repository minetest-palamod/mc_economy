local modpath = minetest.get_modpath(minetest.get_current_modname())

mc_economy = {}

--if minetest.request_insecure_environment() then
--dofile(modpath.."/database.lua") --TODO
--else
dofile(modpath.."/storage.lua")
dofile(modpath.."/items.lua")
dofile(modpath.."/commands.lua")