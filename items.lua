minetest.register_craftitem("mc_economy:money", {
	description = "Money",
	inventory_image = "default_stone.png",
	on_place = function(itemstack, placer, pointed_thing)
		if placer:is_player() then
			mc_economy.add_player_balance(placer:get_player_name(), 1000*itemstack:get_count(), true)
		end
		itemstack:clear()
		return itemstack
	end,
})