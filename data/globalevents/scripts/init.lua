function onStartup()
	local time = os.time()
	db.executeQuery("UPDATE `players` SET `online` = 0 WHERE `world_id` = " .. getConfigValue('worldId') .. " AND `online` > 0;")
	db.executeQuery("UPDATE `bans` SET `active` = 0 WHERE `expires` <= " .. time .. " AND `expires` >= 0 AND `active` = 1")

	return true
end

function onGlobalSave()
	if(getGameState() ~= GAMESTATE_CLOSING) then
		return onStartup()
	end

	return true
end
