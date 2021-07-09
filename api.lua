local is_creative_enabled = minetest.is_creative_enabled
local C = minetest.colorize
local log = minetest.log
local S = minetest.get_translator(minetest.get_current_modname())

local string = string

local default_amount = minetest.settings:get("mc_economy.default_money") or 500

local db = db_manager.database("mc_economy:economy", db_manager.get_schemat("mc_economy:sql/database.sql"))

local cached_balance = {}

function mc_economy.get_player_balance(playername)
	if cached_balance[playername] then
		return cached_balance[playername]
	else
		local t = db:get_rows(string.format("SELECT * FROM money WHERE player = '%s' LIMIT 1", playername))
		minetest.log("error", dump(t))
		cached_balance[playername] = t[1].amount
		return t[1].amount
	end
end

mc_economy.OK = 0
mc_economy.NOT_ENOUGH = 1
function mc_economy.transaction(player1, player2, amount)
	local time = os.time()
	if player1 == player2 then return false end
	if player1 == "SERVER" then --DO NOT TOUCH SERVER BALANCE
		local balance2 = mc_economy.get_player_balance(player2)
		local request = table.concat({
			"BEGIN;",
			string.format("INSERT INTO transactions(date, player1, player2, amount) VALUES ('%s', '%s', '%s', %s);", time, player1, player2, amount),
			string.format("UPDATE money SET amount=%s WHERE player='%s';", balance2 + amount, player2),
			"COMMIT;",
		}, "\n")
		db:exec(request)
		cached_balance[player2] = balance2 + amount
		return 0
	elseif player2 == "SERVER" then
		local balance1 = mc_economy.get_player_balance(player1)
		local request = table.concat({
			"BEGIN;",
			string.format("UPDATE money SET amount=%s WHERE player='%s';", balance1 - amount, player1),
			string.format("INSERT INTO transactions(date, player1, player2, amount) VALUES ('%s', '%s', '%s', %s);", time, player1, player2, amount),
			"COMMIT;",
		}, "\n")
		db:exec(request)
		cached_balance[player1] = balance1 - amount
		return 0
	else
		local balance1 = mc_economy.get_player_balance(player1)
		local balance2 = mc_economy.get_player_balance(player2)
		if balance1 - amount >= 0 then
			local request = table.concat({
				"BEGIN;",
				string.format("UPDATE money SET amount=%s WHERE player='%s';", balance1 - amount, player1),
				string.format("INSERT INTO transactions(date, player1, player2, amount) VALUES ('%s', '%s', '%s', %s);", time, player1, player2, amount),
				string.format("UPDATE money SET amount=%s WHERE player='%s';", balance2 + amount, player2),
				"COMMIT;",
			}, "\n")
			--exec(string.format("UPDATE money SET amount=%s WHERE player='%s'", balance1 - amount, player1))
			--exec(string.format("INSERT INTO transactions(player1, player2, amount) VALUES ('%s', '%s', %s)", player1, player2, amount))
			--exec(string.format("UPDATE money SET amount=%s WHERE player='%s'", balance2 + amount, player2))
			db:exec(request)
			cached_balance[player1] = balance1 - amount
			cached_balance[player2] = balance2 + amount
			return 0
		else
			return 1
		end
	end
end

function mc_economy.reset_player_balance(playername)
	return
end

minetest.register_on_newplayer(function(player)
	local name = player:get_player_name()
	db:exec(string.format("INSERT INTO money VALUES ('%s', 0)", name))
	if default_amount > 0 then
		mc_economy.transaction("SERVER", name, default_amount)
	end
end)

minetest.register_on_prejoinplayer(function(name)
	if name == "SERVER" or name == "unknown" then return "This name isn't allowed!" end
end)