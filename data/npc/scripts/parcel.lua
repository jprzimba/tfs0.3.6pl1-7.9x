local keywordHandler = KeywordHandler:new() 
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local itemsForSale = {
    {name = "parcel", id = 2595, cost = 15},
    {name = "letter", id = 2597, cost = 10},
}

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end
    
    local talkUser = cid
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
        doNpcSellItem(cid, selectedItem.id, talkState[talkUser].amount, totalCost)
        talkState[talkUser] = nil
    elseif msgcontains(msg, 'offer') or msgcontains(msg, 'help') then
        selfSay('I sell parcel (15 gps) and letter (10 gps).')
        talkState[talkUser] = nil
    elseif msgcontains(msg, 'no') and talkState[talkUser] then
        selfSay('Maybe another time.')
        talkState[talkUser] = nil
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
