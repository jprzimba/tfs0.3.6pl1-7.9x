local keywordHandler = KeywordHandler:new() 
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local itemsForSale = {
    {name = "bag", id = 1987, cost = 8},
    {name = "backpack", id = 1988, cost = 20},
    {name = "rope", id = 2120, cost = 15},
    {name = "shovel", id = 2554, cost = 50},
    {name = "mace", id = 2398, cost = 30},
    {name = "chain armor", id = 2464, cost = 60},
    {name = "wooden shield", id = 2512, cost = 15},
    {name = "brass shield", id = 2511, cost = 40},
    {name = "leather boots", id = 2643, cost = 10},
    {name = "brass helmet", id = 2460, cost = 25},
    {name = "leather helmet", id = 2461, cost = 10},
    {name = "torch", id = 2050, cost = 2}
}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end
    
    local talkUser = 0 or cid
    local selectedItem = nil
    local amount = getCount(msg)

    for i, item in ipairs(itemsForSale) do
        if msgcontains(msg, item.name) then
            selectedItem = item
            local totalCost = selectedItem.cost * amount
            selfSay('Do you want to buy ' .. amount .. ' ' .. item.name .. ' for ' .. totalCost .. ' gold coins?')
            talkState[talkUser] = {index = i, amount = amount}
            break
        end
    end

    if msgcontains(msg, 'yes') and talkState[talkUser] then
        selectedItem = itemsForSale[talkState[talkUser].index]
        local totalCost = selectedItem.cost * talkState[talkUser].amount
        buyItems(cid, selectedItem.id, talkState[talkUser].amount, totalCost)
        talkState[talkUser] = nil
    elseif(msgcontains(msg, 'no') and talkState[talkUser] > 0) then
        selfSay('Maybe another time.')
        talkState[talkUser] = nil
    end
    
    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
