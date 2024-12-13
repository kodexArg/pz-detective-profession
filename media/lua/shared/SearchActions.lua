local phrases = require("Phrases")
local checkRoomForZombies = require("ZombieDetection")

-- Toggle search mode
local function onToggleSearchMode(player, isSearchMode)
    local modData = player:getModData()
    modData.isSearchMode = isSearchMode
    if isSearchMode then 
        player:Say(phrases.searching()) 
    end
end

-- Check if the player is in search mode
local function checkSearchMode(player)
    return player:getModData().isSearchMode or false
end

-- Get an adjacent square based on offsets
local function getAdjacentSquare(square, dx, dy)
    if not square then return nil end
    local x = square:getX() + dx
    local y = square:getY() + dy
    local z = square:getZ()
    return getCell():getGridSquare(x, y, z)
end

-- Obtener el nombre de la habitación de una casilla
local function getRoomName(square)
    if not square then return "Unknown" end
    local room = square:getRoom()
    return room and room:getName() or "Outside"
end

-- Check for doors around the current tile
local function checkDoors(player, currentSquare)
    if not currentSquare then return end

    -- Get adjacent squares
    local northSquare = getAdjacentSquare(currentSquare, 0, -1)
    local southSquare = getAdjacentSquare(currentSquare, 0, 1)
    local eastSquare = getAdjacentSquare(currentSquare, 1, 0)
    local westSquare = getAdjacentSquare(currentSquare, -1, 0)

    -- Check doors
    if currentSquare:hasDoorOnEdge(IsoDirections.N, true) or 
       (northSquare and northSquare:hasDoorOnEdge(IsoDirections.S, true)) then
        local message = checkRoomForZombies(northSquare)
        if message then player:Say(message) end
    end

    if currentSquare:hasDoorOnEdge(IsoDirections.S, true) or 
       (southSquare and southSquare:hasDoorOnEdge(IsoDirections.N, true)) then
        local message = checkRoomForZombies(southSquare)
        if message then player:Say(message) end
    end

    if currentSquare:hasDoorOnEdge(IsoDirections.E, true) or 
       (eastSquare and eastSquare:hasDoorOnEdge(IsoDirections.W, true)) then
        local message = checkRoomForZombies(eastSquare)
        if message then player:Say(message) end
    end

    if currentSquare:hasDoorOnEdge(IsoDirections.W, true) or 
       (westSquare and westSquare:hasDoorOnEdge(IsoDirections.E, true)) then
        local message = checkRoomForZombies(westSquare)
        if message then player:Say(message) end
    end
end

-- Main handler for player movement
local function onPlayerMove(player)
    if not player then return end
    
    local currentSquare = player:getSquare()
    if not currentSquare then return end

    local modData = player:getModData()
    
    -- Solo proceder si el jugador cambió de cuadro
    if modData.lastSquare ~= currentSquare then
        local isSearchMode = checkSearchMode(player)
        local random = ZombRand(100)
        
        -- If in search mode, 75% chance to detect
        -- If not in search mode, 20% chance to detect
        if (isSearchMode and random < 66) or (not isSearchMode and random < 10) then
            checkDoors(player, currentSquare)
        end
        
        modData.lastSquare = currentSquare
    end
end

-- Initialize events
local function onGameStart()
    Events.onToggleSearchMode.Add(onToggleSearchMode)
    Events.OnPlayerMove.Add(onPlayerMove)
end

Events.OnGameStart.Add(onGameStart)
