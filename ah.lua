local S = minetest.get_translator(minetest.get_current_modname())
--local C = minetest.colorize
local F = minetest.formspec_escape

local pairs = pairs
local table = table
local string = string


---------
--UTILS--
---------

--credit http://lua-users.org/wiki/FormattingNumbers
--credit http://richard.warburton.it

function money_format(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

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

--[[
formspec_version[4]
size[7.8,9]
style[ah_home;bgimg=blank.png;bgimg_pressed=blank.png;bgimg_middle=blank.png]
button[0,0;1.3,0.50;ah_home;Back <--]
box[5.5,1;2,0.7;#313131]
tooltip[5.5,1;2,0.7:you]
hypertext[0.4,0.3;7,1;shop;<global valign=middle halign=center size=18 color=#313131>]
box[0.4,2;6.7,5;#313131]
scrollbaroptions[min=1;max=8;smallstep=1;largestep=1;thumbsize=1]
scrollbar[7.1,2;0.3,5;vertical;scroll_bar;1]
scroll_container[0.4,2;6.7,5;scroll_bar;vertical;]
button[0,0;6.7,0.75;air;air]
button[0,0.75;6.7,0.75;air;air]
button[0,1.5;6.7,0.75;air;air]
button[0,2.25;6.7,0.75;air;air]
button[0,3;6.7,0.75;air;air]
button[0,3.75;6.7,0.75;airg;airg]
button[0,4.5;6.7,0.75;air;air]
button[0,5.25;6.7,0.75;air;air]
scroll_container_end[]
]]

local function get_categorie_formspec(playername, type)
	local form = table.concat({
		"formspec_version[4]",
		"size[7.8,9]",
		"style[ah_home;bgimg=blank.png;bgimg_pressed=blank.png;bgimg_middle=blank.png]",
		"button[0,0;1.3,0.50;ah_home;Back <--]",
		"box[5.5,1;2,0.7;#313131]",
		--"image[5.5,1;2,0.7;mc_economy_gray_background9.png;7]",
		"tooltip[5.5,1;2,0.7;"..F(S("You have @1 dollars", mc_economy.get_player_balance(playername))).."]",
		"hypertext[0.4,0.3;7,1;shop;<global valign=middle halign=center size=18 color=#313131>"
			..mc_economy.ah.categories[type].desc.."]",
		"box[0.3,1.9;7.2,5.2;#313131]",
		--"image[0.3,1.9;7.2,5.2;mc_economy_gray_background9.png;7]",
		"container[0.4,2]", --;7,6]",
		"style_type[button;font_size=18]",
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

--mc_economy_gray_background9.png
--mc_economy_coins.png

local function get_main_formspec(playername)
	local amount = mc_economy.get_player_balance(playername)
	local formated_amount = money_format(amount)
	return table.concat({
		"formspec_version[4]",
		"size[7.8,9]",
		"style[exitbutton;bgimg=blank.png;bgimg_pressed=blank.png;bgimg_middle=blank.png]",
		"button_exit[0,0;1.3,0.50;exitbutton;Close <--]",
		"box[5.5,1;2,0.7;#313131]",
		"image[5.55,1.1;0.5,0.5;mc_economy_coins.png]",
		--"image[5.5,1;2,0.7;mc_economy_gray_background9.png;7]", <--- activate then 9 sliced mage are availlable
		"hypertext[5.6,1.05;2,0.7;balance;<global valign=middle halign=center size=18>"..
			formated_amount.."]",
		"tooltip[5.5,1;2,0.7;"..F(S("You have @1 dollars", formated_amount)).."]",
		--[["hypertext[0.2,0.3;7,1;close_label;
			<global valign=top halign=right size=16 color=#313131><action name=quit color=#313131>Close <--</action>]",]]
		"hypertext[0.4,0.3;7,1;shop;<global valign=middle halign=center size=18 color=#313131>Shop]",
		--"image[0.3,1.9;7.2,5.2;mc_economy_gray_background9.png;7]",
		"box[0.3,1.9;7.2,5.2;#313131]",
		"container[0.4,2]", --;7,6]",
		"style_type[button;font_size=18]",
		--"box[0,0;7,5;#313131]",
		"button[0,0;7,0.75;blocs;Blocs]",
		"button[0,0.75;7,0.75;minerals;Minerals]",
		"button[0,1.5;7,0.75;plants;Plants]",
		"button[0,2.25;7,0.75;other;Other]",
		"container_end[]",
	})
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "mc_economy:ah" then
		local playername = player:get_player_name()
		if fields.ah_home then
			minetest.show_formspec(playername, "mc_economy:ah", get_main_formspec(playername))
		elseif fields.blocs then
			minetest.show_formspec(playername, "mc_economy:ah", get_categorie_formspec(player:get_player_name(), "blocs"))
		end
	end
end)

minetest.register_chatcommand("ah", {
	params = "",
	description = "Get your money",
	func = function(name, param)
		minetest.show_formspec(name, "mc_economy:ah", get_main_formspec(name))
		return true
	end,
})