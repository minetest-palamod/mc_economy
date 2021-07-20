local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_craftitem("mc_economy:money", {
	description = S("Money"),
	_tt_help = minetest.colorize(mcl_colors.GREEN, S("Rightclick to get 1000$")),
	inventory_image = "default_stone.png",
	stack_max = 64,
	on_place = function(itemstack, placer, pointed_thing)
		if placer:is_player() then
			mc_economy.transaction("SERVER", placer:get_player_name(), 1000 * itemstack:get_count())
		end
		if not minetest.is_creative_enabled(placer:get_player_name()) then
			itemstack:clear()
		end
		return itemstack
	end,
})