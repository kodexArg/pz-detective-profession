local phrases = {
    searching = {},
    zombieAlert = {}
}

-- Populate searching phrases dynamically
local function initializeSearchingPhrases()
    local i = 1
    while true do
        local textKey = "UI_phrase_" .. i
        local phrase = getTextOrNull(textKey) -- Use getTextOrNull to handle missing keys gracefully
        if not phrase then break end -- Exit loop if no more phrases are found
        table.insert(phrases.searching, phrase)
        i = i + 1
    end
end

-- Populate zombie alert phrases dynamically
local function initializeZombieAlertPhrases()
    local j = 1
    while true do
        local textKey = "UI_zombie_alert_" .. j
        local phrase = getTextOrNull(textKey) -- Use getTextOrNull to handle missing keys gracefully
        if not phrase then break end -- Exit loop if no more phrases are found
        table.insert(phrases.zombieAlert, phrase)
        j = j + 1
    end
end

-- Initialize both categories of phrases only once
local function initializePhrases()
    initializeSearchingPhrases()
    initializeZombieAlertPhrases()
end

initializePhrases() -- Populate the phrases at the start

-- Returns a random detective phrase when searching
local function detectiveIsSearchingPhrase()
    local randomIndex = ZombRand(#phrases.searching) + 1
    return phrases.searching[randomIndex]
end

-- Returns a random detective phrase for zombie alerts
local function detectiveZombieAlertPhrase()
    local randomIndex = ZombRand(#phrases.zombieAlert) + 1
    return phrases.zombieAlert[randomIndex]
end

return {
    searching = detectiveIsSearchingPhrase,
    zombieAlert = detectiveZombieAlertPhrase
}
