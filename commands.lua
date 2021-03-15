local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_chatcommand("pay", {
	params = "<playername> <amount>",
	description = "Pay money to another player",
	func = function(name, param)
		if (param == "") then
			return false, S("Error: No params specified.")
		end
		params = {}
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