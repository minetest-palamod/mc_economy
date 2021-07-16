local S = minetest.get_translator(minetest.get_current_modname())
local C = minetest.colorize
local F = minetest.formspec_escape

local pairs = pairs
local table = table

mc_economy.chat_prefix = C(mcl_colors.DARK_GREEN, "[").."Money"..C(mcl_colors.DARK_GREEN, "]")

--[[
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
]]


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

mc_economy.ah.categories = {
	blocs = {
		desc = S("Blocs"),
		items = {},
	},
	minerals = {
		desc = S("Minerals"),
		items = {},
	},
	plants = {
		desc = S("Plants"),
		items = {},
	},
	other = {
		desc = S("Other"),
		items = {},
	},
}

function mc_economy.ah.add_item(category, itemname)
	if not mc_economy.ah.categories[category] then
		error("[mc_economy] Mod '"..minetest.get_current_modname().."' tried to add item to ah with wrong category '"..category.."'")
	end
	table.insert(mc_economy.ah.categories[category].items, itemname)
end

function mc_economy.ah.remove_item(category, itemname)
	if not mc_economy.ah.categories[category] then
		error("[mc_economy] Mod '"..minetest.get_current_modname().."' tried to remove item from ah with wrong category '"..category.."'")
	end
	for i,name in pairs(mc_economy.ah.categories[category].items) do
		if name == itemname then
			table.remove(mc_economy.ah.categories[category].items, i)
			break
		end
	end
end

--mc_economy.ah.add_item("ttt", itemname)
mc_economy.ah.add_item("blocs", "mcl_core:stone")
mc_economy.ah.add_item("blocs", "mcl_core:cobblestone")
mc_economy.ah.add_item("blocs", "mcl_core:dirt")
mc_economy.ah.add_item("blocs", "mcl_core:dirt_with_grass")

local function get_formspec(type)
	local form = table.concat({
		"formspec_version[4]",
		"size[7.8,9]",
		--"label[0.2,0.3;Close <--]",
		"button[0,0;1.3,0.50;ah_home;Back <--]",
		"style[exitbutton;border=false]",
		"box[5.5,1;2,0.7;#313131]",
		"tooltip[5.5,1;2,0.7;"..F("You have 30.000 dollars").."]",
		"hypertext[0.4,0.3;7,1;shop;<global valign=middle halign=center size=18 color=#313131>"
			..mc_economy.ah.categories[type].desc.."]",
		"container[0.4,2]", --;7,6]",
		"box[0,0;7,5;#313131]",
	})
	local nb = 0
	for _,item in pairs(mc_economy.ah.categories[type].items) do
		form = form.."button[0,"..nb..";7,0.75;"..item..";"..item.."]"
		nb = nb + 0.75
	end
	form = form.."container_end[]"
	return form
end

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
	--"label[0.2,0.3;Close <--]",
	"button_exit[0,0;1.3,0.50;exitbutton;Close <--]",
	"style[exitbutton;border=false]",
	"box[5.5,1;2,0.7;#313131]",
	"tooltip[5.5,1;2,0.7;"..F("You have 30.000 dollars").."]",
	--[["hypertext[0.2,0.3;7,1;close_label;
		<global valign=top halign=right size=16 color=#313131><action name=quit color=#313131>Close <--</action>]",]]
	"hypertext[0.4,0.3;7,1;shop;<global valign=middle halign=center size=18 color=#313131>Shop]",
	"container[0.4,2]", --;7,6]",
	"box[0,0;7,5;#313131]",
	"button[0,0;7,0.75;blocs;Blocs]",
	"button[0,0.75;7,0.75;minerals;Minerals]",
	"button[0,1.5;7,0.75;plants;Plants]",
	"button[0,2.25;7,0.75;other;Other]",
	"container_end[]",
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "mc_economy:ah" then
		if fields.ah_home then
			minetest.show_formspec(player:get_player_name(), "mc_economy:ah", form)
		elseif fields.blocs then
			minetest.show_formspec(player:get_player_name(), "mc_economy:ah", get_formspec("blocs"))
		end
	end
end)

minetest.register_chatcommand("ah", {
	params = "",
	description = "Get your money",
	func = function(name, param)
		minetest.show_formspec(name, "mc_economy:ah", form)
		return true
	end,
})