local keywordHandler = KeywordHandler:new() 
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local itemsForSale = {
    ["aol"] = {id = 2173, cost = 50000},
    ["amulet of loss"] = {id = 2173, cost = 50000},
    ["scarf"] = {id = 2661, cost = 200}
}

-- Função para determinar o uso de "a" ou "an"
--local function getArticle(itemName)
  --  local firstChar = string.sub(itemName, 1, 1):lower()
    --if firstChar == 'a' or firstChar == 'e' or firstChar == 'i' or firstChar == 'o' or firstChar == 'u' then
      --  return "an"
    --else
      --  return "a"
    --end
--end

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

    -- Processando o pedido de compra
    for itemName, itemData in pairs(itemsForSale) do
        if msgcontains(msg, itemName) then
            selectedItem = itemData
            local article = getArticle(itemName)
            selfSay('Do you want to buy ' .. article .. ' ' .. itemName .. ' for ' .. selectedItem.cost .. ' gold coins?')
            talkState[talkUser] = itemName
            return true
        end
    end

    -- Processando confirmação de compra
    if msgcontains(msg, 'yes') and talkState[talkUser] then
        selectedItem = itemsForSale[talkState[talkUser]]
        
        if doPlayerRemoveMoney(cid, selectedItem.cost) then
            doPlayerAddItem(cid, selectedItem.id, 1)
            selfSay('Here is your ' .. talkState[talkUser] .. '!')
        else
            selfSay('Sorry, you do not have enough money.')
        end
        talkState[talkUser] = nil
        return true
    end

    -- Processando negativa de compra
    if msgcontains(msg, 'no') and talkState[talkUser] then
        selfSay('Ok then.')
        talkState[talkUser] = nil
        return true
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
