local function addDetectiveProfession()
    local detective = ProfessionFactory.addProfession("detective", getText("UI_prof_detective"), "profession_detective", -6)
    
    detective:addXPBoost(Perks.Aiming, 1)
    detective:addXPBoost(Perks.Lightfoot, 1)
    detective:addXPBoost(Perks.Sneak, 2)

    detective:setDescription(getText("UI_profdesc_detective"))
end

local function addDetectiveForageSkills()
    if not forageSkills then forageSkills = {} end

    forageSkills["detective"] = {
        name                    = "detective",
        type                    = "occupation",
        visionBonus             = 2.2,
        weatherEffect           = 33,
        darknessEffect          = 33,
        specialisations         = {
            ["Animals"]             = 10,
            ["Insects"]             = 5,
            ["Medical"]             = 10,
            ["Ammunition"]          = 50,
            ["JunkWeapons"]         = 15,
            ["MedicinalPlants"]     = 5,
            ["ForestRarities"]      = 10,
            ["Trash"]               = 20,
            ["Junk"]                = 20,
            ["WildPlants"]          = 5,
        },
    }
end

Events.OnGameBoot.Add(addDetectiveProfession)
Events.OnGameBoot.Add(addDetectiveForageSkills)
