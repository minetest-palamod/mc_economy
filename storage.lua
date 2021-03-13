local storage = minetest.get_mod_storage()
local C = minetest.colorize

local default_amount = 0

function mc_economy.get_player_balance(playername)
	return storage:get_int(playername)
end

function mc_economy.set_player_balance(playername, value)
	return storage:set_int(playername, value)
end

function mc_economy.add_player_balance(playername, value, notification, from)
	if from then
		minetest.chat_send_player(playername, "You received "..tostring(value).."$ from "..from)
	else
		minetest.chat_send_player(playername, "You received "..tostring(value).."$")
	end
	return storage:set_int(playername, storage:get_int(playername) + value)
end

minetest.register_on_newplayer(function(player)
	storage:set_int(player:get_player_name(), default_amount)
end)