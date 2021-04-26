local is_creative_enabled = minetest.is_creative_enabled
local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_craftitem("mc_economy:money", {
	description = S("Money"),
	inventory_image = "default_stone.png",
	stack_max = 64,
	on_place = function(itemstack, placer, pointed_thing)
		if placer:is_player() then
			mc_economy.add_player_balance(placer:get_player_name(), 1000*itemstack:get_count(), true)
		end
		if not is_creative_enabled(placer:get_player_name()) then
			itemstack:clear()
		end
		return itemstack
	end,
})