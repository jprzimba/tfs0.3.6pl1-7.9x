local keywordHandler = KeywordHandler:new() 
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local itemsForSale = {
    -- chairs
    {name = "wooden chair", id = 3901, cost = 500},
    {name = "sofa chair", id = 3902, cost = 500},
    {name = "red cushioned chair", id = 3903, cost = 500},
    {name = "green cushioned chair", id = 3904, cost = 500},
    {name = "tusk chair", id = 3905, cost = 500},
    {name = "ivory chair", id = 3906, cost = 500},

    -- tables
    {name = "big table", id = 3909, cost = 500},
    {name = "square table", id = 3910, cost = 500},
    {name = "round table", id = 3911, cost = 500},
    {name = "small table", id = 3912, cost = 500},
    {name = "stone table", id = 3913, cost = 500},
    {name = "tusk table", id = 3914, cost = 500},
    {name = "bamboo table", id = 3919, cost = 500},

    -- plants
    {name = "pink flower", id = 3928, cost = 500},
    {name = "green flower", id = 3929, cost = 500},
    {name = "christmas tree", id = 3931, cost = 500},

    -- containers
    {name = "large trunk", id = 3938, cost = 500},
    {name = "drawer", id = 3921, cost = 500},
    {name = "dresser", id = 3932, cost = 500},
    {name = "locker", id = 3934, cost = 500},
    {name = "trough", id = 3935, cost = 500},
    {name = "box", id = 3915, cost = 500},

    -- more
    {name = "coal basin", id = 3908, cost = 500},
    {name = "birdcage", id = 3918, cost = 500},
    {name = "harp", id = 3917, cost = 500},
    {name = "piano", id = 3926, cost = 500},
    {name = "globe", id = 3927, cost = 500},
    {name = "clock", id = 3933, cost = 500},
    {name = "lamp", id = 3937, cost = 500},

    -- tapestry
    {name = "blue tapestry", id = 1872, cost = 500},
    {name = "green tapestry", id = 1860, cost = 500},
    {name = "orange tapestry", id = 1866, cost = 500},
    {name = "pink tapestry", id = 1857, cost = 500},
    {name = "red tapestry", id = 1869, cost = 500},
    {name = "white tapestry", id = 1880, cost = 500},
    {name = "yellow tapestry", id = 1863, cost = 500},

    -- pillows
    {name = "small purple pillow", id = 1678, cost = 500},
    {name = "small green pillow", id = 1679, cost = 500},
    {name = "small red pillow", id = 1680, cost = 500},
    {name = "small blue pillow", id = 1681, cost = 500},
    {name = "small orange pillow", id = 1682, cost = 500},
    {name = "small turquiose pillow", id = 1683, cost = 500},
    {name = "small white pillow", id = 1684, cost = 500},
    {name = "heart pillow", id = 1685, cost = 500},
    {name = "blue pillow", id = 1686, cost = 500},
    {name = "red pillow", id = 1687, cost = 500},
    {name = "green pillow", id = 1688, cost = 500},
    {name = "yellow pillow", id = 1689, cost = 500},
    {name = "round blue pillow", id = 1690, cost = 500},
    {name = "round red pillow", id = 1691, cost = 500},
    {name = "round purple pillow", id = 1692, cost = 500},
    {name = "round turquiose pillow", id = 1693, cost = 500},
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
        buyItems(cid, selectedItem.id, talkState[talkUser].amount, totalCost)
        talkState[talkUser] = nil
    elseif msgcontains(msg, 'chairs') then
        selfSay('I sell wooden chair, sofa chair, red cushioned chair, green cushioned chair, tusk chair and ivory chair.')
        talkState[talkUser] = nil
    elseif msgcontains(msg, 'tables') then
        selfSay('I sell big table, square table, round table, small table, stone table, tusk table, bamboo table.')
        talkState[talkUser] = nil
    elseif msgcontains(msg, 'plants') then
        selfSay('I sell pink flower, green flower and christmas tree.')
        talkState[talkUser] = nil
    elseif msgcontains(msg, 'containers') then
        selfSay('I sell large trunk, box, drawer, dresser, locker and trough.')
        talkState[talkUser] = nil
    elseif msgcontains(msg, 'round') then
        selfSay('I sell round blue pillow, round red pillow, round purple pillow, round turquiose pillow and round blue pillow.')
        talkState[talkUser] = nil
    elseif msgcontains(msg, 'pillows') then
        selfSay('I sell heart pillow, blue pillow, red pillow, green pillow, yellow pillow, small white pillow, small turquiose pillow, small orange pillow, small purple pillow, small green pillow, small red pillow and small blue pillow.')
        talkState[talkUser] = nil
    elseif msgcontains(msg, 'more')  then
        selfSay('I sell coal basin, birdcage, harp, piano, globe, clock and lamp.')
        talkState[talkUser] = nil
    elseif msgcontains(msg, 'no') and talkState[talkUser] then
        selfSay('Maybe another time.')
        talkState[talkUser] = nil
    end

    return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())