local keywordHandler = KeywordHandler:new() 
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local itemsForSale = {
    {name = "amulet of loss", id = 2173, cost = 50000},
    {name = "scarf", id = 2661, cost = 200}
}

function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid) 			end
function onCreatureDisappear(cid) 			npcHandler:onCreatureDisappear(cid) 		end
function onCreatureSay(cid, type, msg) 		npcHandler:onCreatureSay(cid, type, msg) 	end
function onThink() 							npcHandler:onThink() 						end

function creatureSayCallback(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end
    
    local talkUser = 0 or cid
    local selectedItem = nil

    if(msgcontains(msg, 'amulet of loss') or msgcontains(msg, 'aol')) then
        selectedItem = itemsForSale[1]  -- Amulet of Loss
        local totalCost = selectedItem.cost
        selfSay('Do you want to buy an amulet of loss for ' .. totalCost .. ' gold coins?')
        talkState[talkUser] = 1
    elseif(msgcontains(msg, 'scarf')) then
        selectedItem = itemsForSale[2]  -- Scarf
        local totalCost = selectedItem.cost
        selfSay('Do you want to buy a scarf for ' .. totalCost .. ' gold coins?')
        talkState[talkUser] = 2
    end

    if(msgcontains(msg, 'yes') and talkState[talkUser] > 0) then
        selectedItem = itemsForSale[talkState[talkUser]]
        local totalCost = selectedItem.cost

        if doPlayerRemoveMoney(cid, totalCost) then
            doPlayerAddItem(cid, selectedItem.id, 1)
            selfSay('Here is your ' .. selectedItem.name .. '!')
        else
            selfSay('Sorry, you do not have enough money.')
        end

        talkState[talkUser] = 0
    elseif(msgcontains(msg, 'no') and talkState[talkUser] > 0) then
        talkState[talkUser] = 0
        selfSay('Ok then.', cid)
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
