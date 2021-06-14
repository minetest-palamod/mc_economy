local is_creative_enabled = minetest.is_creative_enabled
local C = minetest.colorize
local log = minetest.log
local S = minetest.get_translator(minetest.get_current_modname())

local worldpath = minetest.get_worldpath()

local ie = minetest.request_insecure_environment()
if not ie then
	error("Cannot access insecure environment!")
end

--local libpath = minetest.settings:get("mc_economy.lsqlite3_path") or ""
package.cpath = "/usr/local/lib/lua/5.1/?.so"--..libpath

local sql = ie.require("lsqlite3")
-- Prevent other mods from using the global sqlite3 library
if sqlite3 then
    sqlite3 = nil
end

local db = sql.open(worldpath .. "/mc_economy.sqlite3")

local function sql_exec(q)
	if db:exec(q) ~= sql.OK then
		minetest.log("info", "[mc_economy] lSQLite: " .. db:errmsg())
	end
end

local function sql_row(q)
	q = q .. " LIMIT 1;"
	for row in db:nrows(q) do
		return row
	end
end

sql_exec("CREATE TABLE IF NOT EXISTS money (player TEXT, amount INTEGER)")

--[[ function s_protect.load_db() end
function s_protect.load_shareall() end
function s_protect.save_share_db() end

function s_protect.set_claim(cpos, claim)
	local id, row = s_protect.get_claim(cpos)

	if not claim then
		if not id then
			-- Claim never existed
			return
		end

		-- Remove claim
		sql_exec(
			("DELETE FROM claims WHERE id = %i LIMIT 1;"):format(id)
		)
	end

	if id then
		local vals = {}
		for k, v in pairs(claim) do
			if row[k] ~= v and type(v) == "string" then
				vals[#vals + 1] = ("%s = `%s`"):format(k, v)
			end
		end
		if #vals == 0 then
			return
		end
		sql_exec(
			("UPDATE claims SET %s WHERE id = %i LIMIT 1;")
			:format(table.concat(vals, ","), id)
		)
	else
		sql_exec(
			("INSERT INTO claims VALUES (%i, %i, %i, %s, %s, %s);")
			:format(pos.x, pos.y, pos.z, claim.owner,
				claim.shared or "", claim.data or "")
		)
	end
end

function s_protect.get_claim(cpos)
	local q
	if type(pos) == "number" then
		-- Direct index
		q = "id = " .. cpos
	else
		q = ("x = %i AND y = %i AND z = %z"):format(cpos.x, cpos.y, cpos.z)
	end
	local row = 
	if not row then
		return
	end

	local id = row.id
	row.id = nil
	return id, row
end ]]



local default_amount = minetest.settings:get("mc_economy.default_money") or 500

function mc_economy.get_player_balance(playername)
	return sql_row("SELECT amount FROM money WHERE player = "..playername)
end

function mc_economy.set_player_balance(playername, value)
	sql_exec(string.format("UPDATE money SET amount WHERE player = %i LIMIT 1", playername))
end

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
	if not mc_economy.get_player_balance(name) then
        sql_exec(string.format("INSERT INTO money VALUES (%i, %s)", name, default_amount))
    end
end)