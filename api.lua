--local storage = minetest.get_mod_storage()
local is_creative_enabled = minetest.is_creative_enabled
local C = minetest.colorize
local log = minetest.log
local S = minetest.get_translator(minetest.get_current_modname())

local default_amount = minetest.settings:get("mc_economy.default_money") or 500

function mc_economy.add_player_balance(playername, value, notification, from)
	if from then
		minetest.chat_send_player(playername, "You received "..tostring(value).."$ from "..from)
	else
		minetest.chat_send_player(playername, "You received "..tostring(value).."$")
	end
	return mc_economy.set_player_balance(playername, mc_economy.get_player_balance(playername) + value)
end

function mc_economy.reset_player_balance(playername)
	return mc_economy.set_player_balance(playername, default_amount)
end