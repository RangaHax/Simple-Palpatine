--[[ Lua code. See documentation: https://api.tabletopsimulator.com/ --]]
button_GUID = '17c26c'
function onLoad()
    button = getObjectFromGUID(button_GUID)
    button.createButton({ click_function='who', function_owner=nil, label='Who\'s who?',
        position={0,0.8,0}, rotation={0,0,0}, width=500, height=500, font_size=80 })
    button.lock()
    button.interactable = false
    button.tooltip = false
    button.setPosition({-30, -1.2, 10})

end

palpatine_GUID = '085cc7'
separatist_GUIDs = {'470704', '10f24a', 'be120e'}
loyalist_GUIDs = {'248396', '08b2f0', 'adce24', '8a38b3', '0f150e', '38c0db'}

function who()
    playerList = Player.getPlayers()
    palpatinePlayer = findPalpatine()
    separatistList = findPlayersWithCards(separatist_GUIDs)
    loyalistList = findPlayersWithCards(loyalist_GUIDs)
    numPlayers = table.length(Player.getPlayers())

    --error checks
    if palpatinePlayer == nil then
        broadcastError('No one is palpatine!')
        return
    end
    if table.length(separatistList) == 0 then
        broadcastError('No one is a separatist!')
        return
    end
    if table.length(loyalistList) == 0 then
        broadcastError('No one is a loyalist!')
        return
    end

    -- Tell Palpatine
    palpatinePlayer.broadcast("You are palpatine", {r=1, g=0.6, b=0})
    if(numPlayers == 5 or numPlayers == 6) then
        for _, separatist in ipairs(separatistList) do
                palpatinePlayer.broadcast(separatist.steam_name .. ' is a separatist', {r=1, g=0.6, b=0})
        end
    end

    -- Tell Separatists
    for _, player in ipairs(separatistList) do
        for _, separatist in ipairs(separatistList) do
            player.broadcast(separatist.steam_name .. " is a a separatist", {r=1, g=0.6, b=0})
        end
        player.broadcast(palpatinePlayer.steam_name .. " is palpatine", {r=1, g=0.6, b=0})
    end

    -- Tell Loyalists
    for _, player in ipairs(loyalistList) do
        player.broadcast("You are a loyalist", {r=0.2, g=0.2, b=1})
    end

end


function findPalpatine()
    playerList = Player.getPlayers()
    for _, playerReference in ipairs(playerList) do
        for _, objectReference in ipairs(playerReference.getHandObjects()) do
            if objectReference.guid == palpatine_GUID then return playerReference end
        end
    end
    return nil
end

function findPlayersWithCards(GUID_list)
    playerList = Player.getPlayers()
    playersWithCards = { }
    for _, playerReference in ipairs(playerList) do
        for _, objectReference in ipairs(playerReference.getHandObjects()) do
            if table.contains(GUID_list, objectReference.guid) then return table.insert(playersWithCards, playerReference) end
        end
    end
    return playersWithCards
end

--helper functions
function table.length(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end
function broadcastError(error)
    for _, player in ipairs(Player.getPlayers()) do
        player.broadcast(error, {r=1, g=0.2, b=0.2})
    end
end
