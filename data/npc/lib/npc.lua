-- Include the Advanced NPC System
dofile(getDataDir() .. 'npc/lib/npcsystem/npcsystem.lua')

function getCount(msg)
	b, e = string.find(msg, "%d+")
	
	if b == nil or e == nil then
		count = 1
	else
		count = tonumber(string.sub(msg, b, e))
	end
	
	if count > 2000 then
		count = 2000
	elseif count == 0 then
		count = 1
	end
	
	return count
end

function selfIdle()
	following = false
	attacking = false

	selfAttackCreature(0)
	target = 0
end

function selfSayChannel(cid, message)
	return selfSay(message, cid, false)
end

function selfMoveToCreature(id)
	if(not id or id == 0) then
		return
	end

	local t = getCreaturePosition(id)
	if(not t.x or t.x == nil) then
		return
	end

	selfMoveTo(t.x, t.y, t.z)
	return
end

function getNpcDistanceToCreature(id)
	if(not id or id == 0) then
		selfIdle()
		return nil
	end

	local c = getCreaturePosition(id)
	if(not c.x or c.x == 0) then
		return nil
	end

	local s = getCreaturePosition(getNpcId())
	if(not s.x or s.x == 0 or s.z ~= c.z) then
		return nil
	end

	return math.max(math.abs(s.x - c.x), math.abs(s.y - c.y))
end

function doMessageCheck(message, keyword)
	if(type(keyword) == "table") then
		return table.isStrIn(keyword, message)
	end

	local a, b = message:lower():find(keyword:lower())
	if(a ~= nil and b ~= nil) then
		return true
	end

	return false
end

function doRemoveItemIdFromPos (id, n, position)
	local thing = getThingFromPos({x = position.x, y = position.y, z = position.z, stackpos = 1})
	if(thing.itemid == id) then
		doRemoveItem(thing.uid, n)
		return true
	end

	return false
end

function getNpcName()
	return getCreatureName(getNpcId())
end

function getNpcPos()
	return getCreaturePosition(getNpcId())
end

function selfGetPosition()
	local t = getNpcPos()
	return t.x, t.y, t.z
end

function doNpcSellItem(cid, itemid, count, cost)
	local item = 0
	local cost = count * cost
	local amount = count

	if doPlayerRemoveMoney(cid, cost) then
		if isItemStackable(itemid) then
			while count > 100 do
				item = doPlayerAddItem(cid, itemid, 100)
				count = count - 100
			end
			
			doPlayerAddItem(cid, itemid, count) -- add the last items, if there is left
		else
			while count > 0 do
				item = doPlayerAddItem(cid, itemid, 1)
				if(itemid == ITEM_PARCEL) then
					doAddContainerItem(item, ITEM_LABEL)
				end
				count = count - 1
			end
		end

		if amount <= 1 then
			selfSay('Here is your '.. getItemName(itemid) .. '!')
		else
			selfSay('Here are your '.. amount ..' '.. getItemName(itemid) .. 's!')		
		end
	else
		selfSay('Sorry, you do not have enough money.')
	end
end

msgcontains = doMessageCheck
moveToPosition = selfMoveTo
moveToCreature = selfMoveToCreature
selfMoveToPosition = selfMoveTo
selfGotoIdle = selfIdle
isPlayerPremiumCallback = isPremium
doPosRemoveItem = doRemoveItemIdFromPos
doNpcBuyItem = doPlayerRemoveItem
doNpcSetCreatureFocus = selfFocus
getNpcCid = getNpcId
getDistanceTo = getNpcDistanceTo
getDistanceToCreature = getNpcDistanceToCreature
