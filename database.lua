local worldpath = minetest.get_worldpath()

local ie = minetest.request_insecure_environment()
if not ie then
	error("Cannot access insecure environment!")
end

local sql = ie.require("lsqlite3")
-- Remove public table
if sqlite3 then
	sqlite3 = nil
end

function mc_economy.get_player_balance(playername)
	return storage:get_int(playername)
end

function mc_economy.set_player_balance(playername, value)
	return storage:set_int(playername, value)
end

function mc_economy.add_player_balance(playername, value, notification)
	minetest.chat_send_player(playername, tostring(value))
	return storage:set_int(playername, storage:get_int(playername) + value)
end
