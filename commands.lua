local S = minetest.get_translator(minetest.get_current_modname())
local C = minetest.colorize
local F = minetest.formspec_escape

mc_economy.chat_prefix = C(mcl_colors.DARK_GREEN, "[").."Money"..C(mcl_colors.DARK_GREEN, "]")

minetest.register_chatcommand("pay", {
	params = "<playername> <amount>",
	description = "Pay money to another player",
	func = function(name, param)
		if (param == "") then
			return false, S("Error: No params specified.")
		end
		local params = {}
		for substring in param:gmatch("%S+") do
		   table.insert(params, substring)
		end
		local playername, amount = string.match(param, "%S+")
		if params[2] and tonumber(params[2]) <= mc_economy.get_player_balance(name) then
			mc_economy.add_player_balance(params[1], tonumber(params[2]), true, name)
			mc_economy.add_player_balance(name, -tonumber(params[2]), false, name)
			return true, "Done."
		else
			return false, "Failed"
		end
	end,
})

local money_msg = mc_economy.chat_prefix..C(mcl_colors.DARK_GREEN, " Balance: ")

minetest.register_chatcommand("money", {
	params = "",
	description = "Get your money",
	func = function(name, param)
		return true, money_msg..mc_economy.get_player_balance(name).." "..S("Dollars")
		--return false, "Failed"
	end,
})


mc_economy.ah = {}
--Categories:
--Blocs
--Minerals
--Plants
--Other

--formspec_version[4]size[7.8,9]label[0.2,0.3;Close <--]box[0.4,2;7,6;]
--https://youtu.be/tQwDGtxZiHs?t=467
local form = table.concat({
	"formspec_version[4]",
	"size[7.8,9]",
	"label[0.2,0.3;Close <--]",
	"box[5.5,1;2,0.7;#313131]",
	"tooltip[5.5,1;2,0.7;"..F("You have 30.000 dollars")..";;]",
	--"hypertext[0.2,0.3;7,1;close_label;<global valign=top halign=right size=16 color=#313131><action name=quit color=#313131>Close <--</action>]",
	"hypertext[0.4,0.3;7,1;shop;<global valign=middle halign=center size=18 color=#313131>Shop]",
	"container[0.4,2]", --;7,6]",
	"button[0,0;7,0.75;blocs;Blocs]",
	"button[0,0.75;7,0.75;minerals;Minerals]",
	"container_end[]",
})

minetest.register_chatcommand("ah", {
	params = "",
	description = "Get your money",
	func = function(name, param)
		minetest.show_formspec(name, "mc_economy:ah", form)
		return true
	end,
})