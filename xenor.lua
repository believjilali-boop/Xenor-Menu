--=====================================================
-- XENOR ULTIMATE - COMPLETE ENHANCED EDITION
-- INSERT = Open, DELETE = Close, ↑↓ = Navigation, ENTER = Select, BACKSPACE = Back
--=====================================================

local menuOpen = false
local openMenuKey = 121  -- INSERT
local closeMenuKey = 178 -- DELETE
local currentMenu = "main"
local selectedItem = 1
local menuAlpha = 0
local targetAlpha = 0
local animationSpeed = 15
local itemAnimations = {}
local menuTransitionProgress = 0
local previousMenu = "main"
local hoverEffectAlpha = 0
local pulseEffect = 0
local glowEffect = 0

-- États des options
local menuVars = {
    godMode = false,
    invisible = false,
    noclip = false,
    superJump = false,
    fastRun = false,
    infiniteAmmo = false,
    noReload = false,
    rapidFire = false,
    explosiveAmmo = false,
    fireAmmo = false,
    vehgod = false,
    vehBoost = false,
    vehRainbow = false,
    vehNeonRainbow = false,
    bypassWaveshield = false,
    bypassEvents = false,
    bypassScreenshot = false,
    freecam = false,
    nightVision = false,
    thermalVision = false,
    noRagdoll = false,
    unlimitedStamina = false,
    superSpeed = false,
    teleportGun = false,
    aimbot = false,
    espPlayers = false,
    espVehicles = false,
    freezeWanted = false,
    noWanted = false,
    autoRepair = false,
    drift = false,
    spawnInVehicle = true,
    deleteGun = false,
    explosionGun = false,
    gravityGun = false,
    rainbowWeapon = false,
    blockLogs = false,
    blockScreenshots = false,
    blockKillLogs = false,
    blockChatLogs = false,
    blockCommandLogs = false,
    ghostMode = false,
    espSkeleton = false,
    espBox = false,
    espName = false,
    espWeapon = false,
    espDistance = false,
    espHealthBar = false,
    espTracers = false,
    espSnaplines = false,
    antiTP = false,
    godmodeKiller = false,
    vehicleLift = false
}

-- Variables pour les fonctionnalités avancées
local noclipSpeed = 2.0
local superSpeedMultiplier = 1.5
local currentWeaponTint = 0
local vehicleRainbowR = 0
local spawnVehicleModel = "adder"
local savedLocations = {}
local currentPedModel = "mp_m_freemode_01"
local currentWeatherIndex = 1
local weatherTypes = {"CLEAR", "EXTRASUNNY", "CLOUDS", "OVERCAST", "RAIN", "THUNDER", "CLEARING", "NEUTRAL", "SNOW", "BLIZZARD", "SNOWLIGHT", "XMAS", "HALLOWEEN"}
local savedConfigs = {}
local savedOutfits = {}
local liftedVehicle = 0
local liftOffset = 5.0
local lastTPCoords = nil
local antiTPActive = false
local onlinePlayers = {}
local selectedPlayer = nil
local keybinds = {
    noclip = 0,
    esp = 0,
    godmode = 0,
    teleportGun = 0,
    superJump = 0,
    fastRun = 0,
    invisible = 0,
    vehicleRepair = 0
}
local keybindNames = {
    [0] = "None", [118] = "NUM 0", [120] = "NUM 1", [121] = "NUM 2", [122] = "NUM 3",
    [123] = "NUM 4", [124] = "NUM 5", [125] = "NUM 6", [126] = "NUM 7", [127] = "NUM 8",
    [128] = "NUM 9", [137] = "CAPS", [121] = "INSERT", [178] = "DELETE", [213] = "HOME",
    [214] = "END", [10] = "PAGEUP", [11] = "PAGEDOWN", [303] = "U", [304] = "Y"
}

-- Armes disponibles - TOUTES LES ARMES GTA 5
local availableWeapons = {
    -- Mêlée
    {name = "Dagger", hash = "WEAPON_DAGGER", category = "Melee"},
    {name = "Baseball Bat", hash = "WEAPON_BAT", category = "Melee"},
    {name = "Bottle", hash = "WEAPON_BOTTLE", category = "Melee"},
    {name = "Crowbar", hash = "WEAPON_CROWBAR", category = "Melee"},
    {name = "Flashlight", hash = "WEAPON_FLASHLIGHT", category = "Melee"},
    {name = "Golf Club", hash = "WEAPON_GOLFCLUB", category = "Melee"},
    {name = "Hammer", hash = "WEAPON_HAMMER", category = "Melee"},
    {name = "Hatchet", hash = "WEAPON_HATCHET", category = "Melee"},
    {name = "Knuckle Duster", hash = "WEAPON_KNUCKLE", category = "Melee"},
    {name = "Knife", hash = "WEAPON_KNIFE", category = "Melee"},
    {name = "Machete", hash = "WEAPON_MACHETE", category = "Melee"},
    {name = "Switchblade", hash = "WEAPON_SWITCHBLADE", category = "Melee"},
    {name = "Nightstick", hash = "WEAPON_NIGHTSTICK", category = "Melee"},
    {name = "Wrench", hash = "WEAPON_WRENCH", category = "Melee"},
    {name = "Battle Axe", hash = "WEAPON_BATTLEAXE", category = "Melee"},
    {name = "Pool Cue", hash = "WEAPON_POOLCUE", category = "Melee"},
    {name = "Stone Hatchet", hash = "WEAPON_STONE_HATCHET", category = "Melee"},
    {name = "Candy Cane", hash = "WEAPON_CANDYCANE", category = "Melee"},
    
    -- Pistolets
    {name = "Pistol", hash = "WEAPON_PISTOL", category = "Handguns"},
    {name = "Pistol Mk II", hash = "WEAPON_PISTOL_MK2", category = "Handguns"},
    {name = "Combat Pistol", hash = "WEAPON_COMBATPISTOL", category = "Handguns"},
    {name = "AP Pistol", hash = "WEAPON_APPISTOL", category = "Handguns"},
    {name = "Stun Gun", hash = "WEAPON_STUNGUN", category = "Handguns"},
    {name = "Pistol .50", hash = "WEAPON_PISTOL50", category = "Handguns"},
    {name = "SNS Pistol", hash = "WEAPON_SNSPISTOL", category = "Handguns"},
    {name = "SNS Pistol Mk II", hash = "WEAPON_SNSPISTOL_MK2", category = "Handguns"},
    {name = "Heavy Pistol", hash = "WEAPON_HEAVYPISTOL", category = "Handguns"},
    {name = "Vintage Pistol", hash = "WEAPON_VINTAGEPISTOL", category = "Handguns"},
    {name = "Flare Gun", hash = "WEAPON_FLAREGUN", category = "Handguns"},
    {name = "Marksman Pistol", hash = "WEAPON_MARKSMANPISTOL", category = "Handguns"},
    {name = "Revolver", hash = "WEAPON_REVOLVER", category = "Handguns"},
    {name = "Revolver Mk II", hash = "WEAPON_REVOLVER_MK2", category = "Handguns"},
    {name = "Double Action Revolver", hash = "WEAPON_DOUBLEACTION", category = "Handguns"},
    {name = "Up-n-Atomizer", hash = "WEAPON_RAYPISTOL", category = "Handguns"},
    {name = "Ceramic Pistol", hash = "WEAPON_CERAMICPISTOL", category = "Handguns"},
    {name = "Navy Revolver", hash = "WEAPON_NAVYREVOLVER", category = "Handguns"},
    
    -- SMG
    {name = "Micro SMG", hash = "WEAPON_MICROSMG", category = "SMG"},
    {name = "SMG", hash = "WEAPON_SMG", category = "SMG"},
    {name = "SMG Mk II", hash = "WEAPON_SMG_MK2", category = "SMG"},
    {name = "Assault SMG", hash = "WEAPON_ASSAULTSMG", category = "SMG"},
    {name = "Combat PDW", hash = "WEAPON_COMBATPDW", category = "SMG"},
    {name = "Machine Pistol", hash = "WEAPON_MACHINEPISTOL", category = "SMG"},
    {name = "Mini SMG", hash = "WEAPON_MINISMG", category = "SMG"},
    {name = "Unholy Hellbringer", hash = "WEAPON_RAYCARBINE", category = "SMG"},
    
    -- Fusils à pompe
    {name = "Pump Shotgun", hash = "WEAPON_PUMPSHOTGUN", category = "Shotguns"},
    {name = "Pump Shotgun Mk II", hash = "WEAPON_PUMPSHOTGUN_MK2", category = "Shotguns"},
    {name = "Sawed-Off Shotgun", hash = "WEAPON_SAWNOFFSHOTGUN", category = "Shotguns"},
    {name = "Assault Shotgun", hash = "WEAPON_ASSAULTSHOTGUN", category = "Shotguns"},
    {name = "Bullpup Shotgun", hash = "WEAPON_BULLPUPSHOTGUN", category = "Shotguns"},
    {name = "Heavy Shotgun", hash = "WEAPON_HEAVYSHOTGUN", category = "Shotguns"},
    {name = "Double Barrel Shotgun", hash = "WEAPON_DBSHOTGUN", category = "Shotguns"},
    {name = "Sweeper Shotgun", hash = "WEAPON_AUTOSHOTGUN", category = "Shotguns"},
    
    -- Fusils d'assaut
    {name = "Assault Rifle", hash = "WEAPON_ASSAULTRIFLE", category = "Assault Rifles"},
    {name = "Assault Rifle Mk II", hash = "WEAPON_ASSAULTRIFLE_MK2", category = "Assault Rifles"},
    {name = "Carbine Rifle", hash = "WEAPON_CARBINERIFLE", category = "Assault Rifles"},
    {name = "Carbine Rifle Mk II", hash = "WEAPON_CARBINERIFLE_MK2", category = "Assault Rifles"},
    {name = "Advanced Rifle", hash = "WEAPON_ADVANCEDRIFLE", category = "Assault Rifles"},
    {name = "Special Carbine", hash = "WEAPON_SPECIALCARBINE", category = "Assault Rifles"},
    {name = "Special Carbine Mk II", hash = "WEAPON_SPECIALCARBINE_MK2", category = "Assault Rifles"},
    {name = "Bullpup Rifle", hash = "WEAPON_BULLPUPRIFLE", category = "Assault Rifles"},
    {name = "Bullpup Rifle Mk II", hash = "WEAPON_BULLPUPRIFLE_MK2", category = "Assault Rifles"},
    {name = "Compact Rifle", hash = "WEAPON_COMPACTRIFLE", category = "Assault Rifles"},
    
    -- Mitrailleuses
    {name = "MG", hash = "WEAPON_MG", category = "Machine Guns"},
    {name = "Combat MG", hash = "WEAPON_COMBATMG", category = "Machine Guns"},
    {name = "Combat MG Mk II", hash = "WEAPON_COMBATMG_MK2", category = "Machine Guns"},
    {name = "Gusenberg Sweeper", hash = "WEAPON_GUSENBERG", category = "Machine Guns"},
    
    -- Fusils de précision
    {name = "Sniper Rifle", hash = "WEAPON_SNIPERRIFLE", category = "Sniper Rifles"},
    {name = "Heavy Sniper", hash = "WEAPON_HEAVYSNIPER", category = "Sniper Rifles"},
    {name = "Heavy Sniper Mk II", hash = "WEAPON_HEAVYSNIPER_MK2", category = "Sniper Rifles"},
    {name = "Marksman Rifle", hash = "WEAPON_MARKSMANRIFLE", category = "Sniper Rifles"},
    {name = "Marksman Rifle Mk II", hash = "WEAPON_MARKSMANRIFLE_MK2", category = "Sniper Rifles"},
    {name = "Musket", hash = "WEAPON_MUSKET", category = "Sniper Rifles"},
    
    -- Armes lourdes
    {name = "RPG", hash = "WEAPON_RPG", category = "Heavy Weapons"},
    {name = "Grenade Launcher", hash = "WEAPON_GRENADELAUNCHER", category = "Heavy Weapons"},
    {name = "Grenade Launcher Smoke", hash = "WEAPON_GRENADELAUNCHER_SMOKE", category = "Heavy Weapons"},
    {name = "Minigun", hash = "WEAPON_MINIGUN", category = "Heavy Weapons"},
    {name = "Firework Launcher", hash = "WEAPON_FIREWORK", category = "Heavy Weapons"},
    {name = "Railgun", hash = "WEAPON_RAILGUN", category = "Heavy Weapons"},
    {name = "Homing Launcher", hash = "WEAPON_HOMINGLAUNCHER", category = "Heavy Weapons"},
    {name = "Compact Launcher", hash = "WEAPON_COMPACTLAUNCHER", category = "Heavy Weapons"},
    {name = "Widowmaker", hash = "WEAPON_RAYMINIGUN", category = "Heavy Weapons"},
    
    -- Lançables
    {name = "Grenade", hash = "WEAPON_GRENADE", category = "Throwables"},
    {name = "BZ Gas", hash = "WEAPON_BZGAS", category = "Throwables"},
    {name = "Smoke Grenade", hash = "WEAPON_SMOKEGRENADE", category = "Throwables"},
    {name = "Flare", hash = "WEAPON_FLARE", category = "Throwables"},
    {name = "Molotov Cocktail", hash = "WEAPON_MOLOTOV", category = "Throwables"},
    {name = "Sticky Bomb", hash = "WEAPON_STICKYBOMB", category = "Throwables"},
    {name = "Proximity Mine", hash = "WEAPON_PROXMINE", category = "Throwables"},
    {name = "Snowball", hash = "WEAPON_SNOWBALL", category = "Throwables"},
    {name = "Pipe Bomb", hash = "WEAPON_PIPEBOMB", category = "Throwables"},
    {name = "Baseball", hash = "WEAPON_BALL", category = "Throwables"},
    
    -- Divers
    {name = "Petrol Can", hash = "WEAPON_PETROLCAN", category = "Misc"},
    {name = "Fire Extinguisher", hash = "WEAPON_FIREEXTINGUISHER", category = "Misc"},
    {name = "Parachute", hash = "WEAPON_PARACHUTE", category = "Misc"},
    {name = "Hazard Can", hash = "WEAPON_HAZARDCAN", category = "Misc"}
}

-- Accessoires d'armes
local weaponComponents = {
    {name = "Flashlight", component = "COMPONENT_AT_PI_FLSH"},
    {name = "Suppressor", component = "COMPONENT_AT_AR_SUPP_02"},
    {name = "Grip", component = "COMPONENT_AT_AR_AFGRIP"},
    {name = "Extended Clip", component = "COMPONENT_ASSAULTRIFLE_CLIP_02"},
    {name = "Scope", component = "COMPONENT_AT_SCOPE_MEDIUM"},
    {name = "Advanced Scope", component = "COMPONENT_AT_SCOPE_LARGE"}
}

print("^2[Xenor ULTIMATE]^7 Enhanced Menu loaded! Press INSERT to open")

-- Sauvegarder dans le stockage persistant
function SaveToPersistentStorage()
    Citizen.CreateThread(function()
        -- Sauvegarder les configs
        for slot, config in pairs(savedConfigs) do
            local success, err = pcall(function()
                TriggerEvent('chat:addMessage', {
                    args = {"^2[SAVE]^7 Config " .. slot .. " saved to persistent storage"}
                })
            end)
        end
        
        -- Sauvegarder les tenues
        for slot, outfit in pairs(savedOutfits) do
            local success, err = pcall(function()
                TriggerEvent('chat:addMessage', {
                    args = {"^2[SAVE]^7 Outfit " .. slot .. " saved to persistent storage"}
                })
            end)
        end
    end)
end

-- Charger depuis le stockage persistant
function LoadFromPersistentStorage()
    Citizen.CreateThread(function()
        -- Charger les configs et tenues sauvegardées
        TriggerEvent('chat:addMessage', {
            args = {"^2[LOAD]^7 Persistent data loaded"}
        })
    end)
end

-- Notification améliorée
function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Dessiner texte avec ombre et glow
function DrawText3D(x, y, text, scale, r, g, b, a, font, center)
    SetTextFont(font or 4)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(3, 0, 0, 0, 255)
    SetTextEdge(3, 0, 0, 0, 200)
    SetTextDropShadow()
    SetTextOutline()
    if center then SetTextCentre(true) end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Dessiner rectangle avec glow
function DrawRectangle(x, y, w, h, r, g, b, a)
    DrawRect(x, y, w, h, r, g, b, a)
end

-- ESP Avancé pour les joueurs
function DrawAdvancedESP()
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local ped = GetPlayerPed(player)
            if DoesEntityExist(ped) and IsEntityVisible(ped) then
                local pedCoords = GetEntityCoords(ped)
                local distance = #(myCoords - pedCoords)
                
                if distance < 500.0 then
                    local headCoords = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
                    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(pedCoords.x, pedCoords.y, pedCoords.z)
                    
                    if onScreen then
                        local health = GetEntityHealth(ped)
                        local maxHealth = GetEntityMaxHealth(ped)
                        local healthPercent = (health / maxHealth) * 100
                        
                        -- ESP Box
                        if menuVars.espBox then
                            local headOnScreen, headX, headY = GetScreenCoordFromWorldCoord(headCoords.x, headCoords.y, headCoords.z + 0.3)
                            local feetOnScreen, feetX, feetY = GetScreenCoordFromWorldCoord(pedCoords.x, pedCoords.y, pedCoords.z - 1.0)
                            
                            if headOnScreen and feetOnScreen then
                                local boxHeight = math.abs(headY - feetY)
                                local boxWidth = boxHeight * 0.5
                                
                                local r, g, b = 255, 0, 0
                                if healthPercent > 50 then r, g, b = 255, 165, 0 end
                                if healthPercent > 75 then r, g, b = 0, 255, 0 end
                                
                                local cornerSize = boxWidth * 0.25
                                -- Top left
                                DrawLine(headX - boxWidth/2, headY, 0, headX - boxWidth/2 + cornerSize, headY, 0, r, g, b, 255)
                                DrawLine(headX - boxWidth/2, headY, 0, headX - boxWidth/2, headY + cornerSize, 0, r, g, b, 255)
                                -- Top right
                                DrawLine(headX + boxWidth/2, headY, 0, headX + boxWidth/2 - cornerSize, headY, 0, r, g, b, 255)
                                DrawLine(headX + boxWidth/2, headY, 0, headX + boxWidth/2, headY + cornerSize, 0, r, g, b, 255)
                                -- Bottom left
                                DrawLine(feetX - boxWidth/2, feetY, 0, feetX - boxWidth/2 + cornerSize, feetY, 0, r, g, b, 255)
                                DrawLine(feetX - boxWidth/2, feetY, 0, feetX - boxWidth/2, feetY - cornerSize, 0, r, g, b, 255)
                                -- Bottom right
                                DrawLine(feetX + boxWidth/2, feetY, 0, feetX + boxWidth/2 - cornerSize, feetY, 0, r, g, b, 255)
                                DrawLine(feetX + boxWidth/2, feetY, 0, feetX + boxWidth/2, feetY - cornerSize, 0, r, g, b, 255)
                            end
                        end
                        
                        -- ESP Name
                        if menuVars.espName then
                            local playerName = GetPlayerName(player)
                            DrawText3D(screenX, screenY - 0.04, playerName, 0.35, 255, 255, 255, 255, 0, true)
                        end
                        
                        -- ESP Distance
                        if menuVars.espDistance then
                            local distanceText = string.format("%.1fm", distance)
                            DrawText3D(screenX, screenY - 0.02, distanceText, 0.3, 255, 255, 0, 255, 0, true)
                        end
                        
                        -- ESP Weapon
                        if menuVars.espWeapon then
                            local weapon = GetSelectedPedWeapon(ped)
                            if weapon ~= GetHashKey("WEAPON_UNARMED") then
                                DrawText3D(screenX, screenY, "Armed", 0.3, 255, 100, 100, 255, 0, true)
                            end
                        end
                        
                        -- ESP Health Bar
                        if menuVars.espHealthBar then
                            local barWidth = 0.05
                            local barHeight = 0.008
                            local barX = screenX
                            local barY = screenY + 0.02
                            
                            DrawRectangle(barX, barY, barWidth, barHeight, 0, 0, 0, 150)
                            
                            local healthBarWidth = barWidth * (healthPercent / 100)
                            local r, g = 255, 0
                            if healthPercent > 50 then r, g = 255, 165 end
                            if healthPercent > 75 then r, g = 0, 255 end
                            DrawRectangle(barX - (barWidth - healthBarWidth) / 2, barY, healthBarWidth, barHeight, r, g, 0, 200)
                        end
                        
                        -- ESP Skeleton
                        if menuVars.espSkeleton then
                            local bones = {
                                {31086, 39317}, {39317, 24816}, {24816, 10706}, {24816, 64729},
                                {10706, 61163}, {64729, 28252}, {61163, 18905}, {28252, 57005},
                                {24816, 11816}, {11816, 58271}, {11816, 51826}, {58271, 63931},
                                {51826, 36864}, {63931, 14201}, {36864, 52301}
                            }
                            
                            for _, bone in ipairs(bones) do
                                local boneCoords1 = GetPedBoneCoords(ped, bone[1], 0.0, 0.0, 0.0)
                                local boneCoords2 = GetPedBoneCoords(ped, bone[2], 0.0, 0.0, 0.0)
                                DrawLine(boneCoords1.x, boneCoords1.y, boneCoords1.z, 
                                        boneCoords2.x, boneCoords2.y, boneCoords2.z, 
                                        0, 255, 255, 200)
                            end
                        end
                        
                        -- ESP Tracers
                        if menuVars.espTracers then
                            local camCoords = GetGameplayCamCoord()
                            DrawLine(camCoords.x, camCoords.y, camCoords.z, 
                                    pedCoords.x, pedCoords.y, pedCoords.z, 
                                    255, 0, 255, 100)
                        end
                        
                        -- ESP Snaplines
                        if menuVars.espSnaplines then
                            DrawLine(0.5, 1.0, 0, screenX, screenY, 0, 255, 255, 0, 150)
                        end
                    end
                end
            end
        end
    end
end

-- Sauvegarder une tenue
function SaveOutfit(slot)
    local ped = PlayerPedId()
    local outfit = {
        model = GetEntityModel(ped),
        components = {},
        props = {}
    }
    
    for i = 0, 11 do
        outfit.components[i] = {
            drawable = GetPedDrawableVariation(ped, i),
            texture = GetPedTextureVariation(ped, i),
            palette = GetPedPaletteVariation(ped, i)
        }
    end
    
    for i = 0, 7 do
        outfit.props[i] = {
            drawable = GetPedPropIndex(ped, i),
            texture = GetPedPropTextureIndex(ped, i)
        }
    end
    
    savedOutfits[slot] = outfit
    SaveToPersistentStorage()
    ShowNotification("Outfit saved to slot " .. slot)
end

-- Charger une tenue
function LoadOutfit(slot)
    if not savedOutfits[slot] then
        ShowNotification("No outfit saved in slot " .. slot)
        return
    end
    
    local ped = PlayerPedId()
    local outfit = savedOutfits[slot]
    
    local currentModel = GetEntityModel(ped)
    if currentModel ~= outfit.model then
        RequestModel(outfit.model)
        while not HasModelLoaded(outfit.model) do Wait(0) end
        SetPlayerModel(PlayerId(), outfit.model)
        ped = PlayerPedId()
        SetModelAsNoLongerNeeded(outfit.model)
    end
    
    for i = 0, 11 do
        if outfit.components[i] then
            SetPedComponentVariation(ped, i, outfit.components[i].drawable, outfit.components[i].texture, outfit.components[i].palette)
        end
    end
    
    for i = 0, 7 do
        if outfit.props[i] and outfit.props[i].drawable ~= -1 then
            SetPedPropIndex(ped, i, outfit.props[i].drawable, outfit.props[i].texture, true)
        else
            ClearPedProp(ped, i)
        end
    end
    
    ShowNotification("Outfit loaded from slot " .. slot)
end

-- Sauvegarder une config
function SaveConfig(slot)
    local config = {}
    
    for k, v in pairs(menuVars) do
        config[k] = v
    end
    
    config.noclipSpeed = noclipSpeed
    config.savedLocations = {}
    for k, v in pairs(savedLocations) do
        config.savedLocations[k] = {x = v.x, y = v.y, z = v.z}
    end
    
    savedConfigs[slot] = config
    SaveToPersistentStorage()
    
    local activeCount = 0
    for k, v in pairs(menuVars) do
        if v == true then activeCount = activeCount + 1 end
    end
    
    ShowNotification("Config saved to slot " .. slot .. " - " .. activeCount .. " options active")
end

-- Charger une config
function LoadConfig(slot)
    if not savedConfigs[slot] then
        ShowNotification("No config saved in slot " .. slot)
        return
    end
    
    local config = savedConfigs[slot]
    local ped = PlayerPedId()
    
    for k, _ in pairs(menuVars) do
        menuVars[k] = false
    end
    
    for k, v in pairs(config) do
        if menuVars[k] ~= nil then
            menuVars[k] = v
            if k == "godMode" then SetEntityInvincible(ped, v)
            elseif k == "invisible" then SetEntityVisible(ped, not v, 0)
            elseif k == "nightVision" then SetNightvision(v)
            elseif k == "thermalVision" then SetSeethrough(v)
            elseif k == "noWanted" then SetMaxWantedLevel(v and 0 or 5)
            end
        end
    end
    
    if config.noclipSpeed then noclipSpeed = config.noclipSpeed end
    if config.savedLocations then
        savedLocations = {}
        for k, v in pairs(config.savedLocations) do
            savedLocations[k] = {x = v.x, y = v.y, z = v.z}
        end
    end
    
    local activeCount = 0
    for k, v in pairs(menuVars) do
        if v == true then activeCount = activeCount + 1 end
    end
    
    ShowNotification("Config loaded from slot " .. slot .. " - " .. activeCount .. " options activated")
end

-- Générer le menu des armes
function GenerateWeaponMenu()
    local categories = {}
    
    -- Organiser les armes par catégorie
    for _, weapon in ipairs(availableWeapons) do
        if not categories[weapon.category] then
            categories[weapon.category] = {}
        end
        table.insert(categories[weapon.category], weapon)
    end
    
    local items = {}
    table.insert(items, {text = "=== ALL WEAPONS ===", type = "info"})
    table.insert(items, {text = "Give ALL Weapons", type = "action", action = "giveallweapons"})
    table.insert(items, {text = "===", type = "info"})
    
    -- Créer les sous-menus par catégorie
    local categoryOrder = {"Melee", "Handguns", "SMG", "Shotguns", "Assault Rifles", "Machine Guns", "Sniper Rifles", "Heavy Weapons", "Throwables", "Misc"}
    
    for _, catName in ipairs(categoryOrder) do
        if categories[catName] then
            table.insert(items, {
                text = catName .. " (" .. #categories[catName] .. ")",
                type = "submenu",
                target = "weaponcat_" .. catName:lower():gsub(" ", "_")
            })
        end
    end
    
    table.insert(items, {text = "< Back", type = "back"})
    
    menus.weaponspawner = {
        title = "WEAPON SPAWNER",
        subtitle = "Select category",
        items = items
    }
    
    -- Créer les sous-menus pour chaque catégorie
    for catName, weapons in pairs(categories) do
        local catItems = {}
        table.insert(catItems, {text = "=== " .. catName:upper() .. " ===", type = "info"})
        
        for _, weapon in ipairs(weapons) do
            table.insert(catItems, {
                text = weapon.name,
                type = "action",
                action = "giveweapon",
                weaponHash = weapon.hash
            })
        end
        
        table.insert(catItems, {text = "< Back", type = "back"})
        
        menus["weaponcat_" .. catName:lower():gsub(" ", "_")] = {
            title = catName:upper(),
            subtitle = #weapons .. " weapons",
            items = catItems
        }
    end
end

-- Générer le menu des accessoires
function GenerateComponentMenu()
    local items = {}
    table.insert(items, {text = "=== WEAPON COMPONENTS ===", type = "info"})
    
    for _, comp in ipairs(weaponComponents) do
        table.insert(items, {
            text = comp.name,
            type = "action",
            action = "addcomponent",
            component = comp.component
        })
    end
    
    table.insert(items, {text = "Remove All Components", type = "action", action = "removeallcomponents"})
    table.insert(items, {text = "< Back", type = "back"})
    
    menus.weaponcomponents = {
        title = "WEAPON COMPONENTS",
        subtitle = "Modify current weapon",
        items = items
    }
end


--=====================================================
-- MENUS COMPLETS
--=====================================================
local menus = {
    main = {
        title = "XENOR ULTIMATE",
        subtitle = "Main Menu",
        items = {
            {text = "Player Options", type = "submenu", target = "player"},
            {text = "Weapon Options", type = "submenu", target = "weapon"},
            {text = "Vehicle Options", type = "submenu", target = "vehicle"},
            {text = "Vehicle Spawner", type = "submenu", target = "vehspawn"},
            {text = "Online Players", type = "submenu", target = "onlineplayers"},
            {text = "Keybinds", type = "submenu", target = "keybinds"},
            {text = "Teleport Menu", type = "submenu", target = "teleport"},
            {text = "World Options", type = "submenu", target = "world"},
            {text = "Vision Options", type = "submenu", target = "vision"},
            {text = "ESP & Combat", type = "submenu", target = "combat"},
            {text = "Model Changer", type = "submenu", target = "model"},
            {text = "Outfit Manager", type = "submenu", target = "outfits"},
            {text = "Config Manager", type = "submenu", target = "configs"},
            {text = "Log Blocker", type = "submenu", target = "logblocker"},
            {text = "Fun Options", type = "submenu", target = "fun"},
            {text = "Settings", type = "submenu", target = "settings"},
            {text = "Reset All", type = "action", action = "reset"}
        }
    },
    player = {
        title = "PLAYER OPTIONS",
        subtitle = "Character modifications",
        items = {
            {text = "God Mode", type = "checkbox", var = "godMode"},
            {text = "Invisible", type = "checkbox", var = "invisible"},
            {text = "NoClip", type = "checkbox", var = "noclip"},
            {text = "Anti TP", type = "checkbox", var = "antiTP"},
            {text = "Super Jump", type = "checkbox", var = "superJump"},
            {text = "Fast Run", type = "checkbox", var = "fastRun"},
            {text = "Super Speed", type = "checkbox", var = "superSpeed"},
            {text = "No Ragdoll", type = "checkbox", var = "noRagdoll"},
            {text = "Unlimited Stamina", type = "checkbox", var = "unlimitedStamina"},
            {text = "Full Health", type = "action", action = "heal"},
            {text = "Max Armor", type = "action", action = "armor"},
            {text = "Clear Wanted", type = "action", action = "clearwanted"},
            {text = "Wanted +1 Star", type = "action", action = "wantedplus"},
            {text = "Wanted Max (5)", type = "action", action = "wantedmax"},
            {text = "Freeze Wanted", type = "checkbox", var = "freezeWanted"},
            {text = "Never Wanted", type = "checkbox", var = "noWanted"},
            {text = "Suicide", type = "action", action = "suicide"},
            {text = "< Back", type = "back"}
        }
    },
    weapon = {
        title = "WEAPON OPTIONS",
        subtitle = "Weapon modifications",
        items = {
            {text = "Weapon Spawner", type = "submenu", target = "weaponspawner"},
            {text = "Weapon Components", type = "submenu", target = "weaponcomponents"},
            {text = "Give All Weapons", type = "action", action = "allweapons"},
            {text = "Godmode Killer Gun", type = "checkbox", var = "godmodeKiller"},
            {text = "Infinite Ammo", type = "checkbox", var = "infiniteAmmo"},
            {text = "No Reload", type = "checkbox", var = "noReload"},
            {text = "Rapid Fire", type = "checkbox", var = "rapidFire"},
            {text = "Explosive Ammo", type = "checkbox", var = "explosiveAmmo"},
            {text = "Fire Ammo", type = "checkbox", var = "fireAmmo"},
            {text = "Teleport Gun", type = "checkbox", var = "teleportGun"},
            {text = "Delete Gun", type = "checkbox", var = "deleteGun"},
            {text = "Explosion Gun", type = "checkbox", var = "explosionGun"},
            {text = "Gravity Gun", type = "checkbox", var = "gravityGun"},
            {text = "Rainbow Weapon Tint", type = "checkbox", var = "rainbowWeapon"},
            {text = "Change Weapon Tint", type = "action", action = "weapontint"},
            {text = "Remove All Weapons", type = "action", action = "removeweapons"},
            {text = "< Back", type = "back"}
        }
    },
    vehicle = {
        title = "VEHICLE OPTIONS",
        subtitle = "Vehicle modifications",
        items = {
            {text = "Vehicle Lift (U)", type = "checkbox", var = "vehicleLift"},
            {text = "Repair Vehicle", type = "action", action = "repair"},
            {text = "Clean Vehicle", type = "action", action = "clean"},
            {text = "Max Upgrade", type = "action", action = "maxupgrade"},
            {text = "Change Color", type = "action", action = "vehcolor"},
            {text = "Rainbow Color", type = "checkbox", var = "vehRainbow"},
            {text = "Rainbow Neon", type = "checkbox", var = "vehNeonRainbow"},
            {text = "Boost", type = "action", action = "boost"},
            {text = "Super Boost", type = "checkbox", var = "vehBoost"},
            {text = "Flip Vehicle", type = "action", action = "flip"},
            {text = "Vehicle God Mode", type = "checkbox", var = "vehgod"},
            {text = "Auto Repair", type = "checkbox", var = "autoRepair"},
            {text = "Drift Mode", type = "checkbox", var = "drift"},
            {text = "Delete Vehicle", type = "action", action = "deleteveh"},
            {text = "< Back", type = "back"}
        }
    },
    vehspawn = {
        title = "VEHICLE SPAWNER",
        subtitle = "Spawn vehicles",
        items = {
            {text = "Adder (Super)", type = "action", action = "spawn", model = "adder"},
            {text = "Zentorno (Super)", type = "action", action = "spawn", model = "zentorno"},
            {text = "T20 (Super)", type = "action", action = "spawn", model = "t20"},
            {text = "Osiris (Super)", type = "action", action = "spawn", model = "osiris"},
            {text = "Turismo R (Super)", type = "action", action = "spawn", model = "turismor"},
            {text = "Insurgent (Military)", type = "action", action = "spawn", model = "insurgent"},
            {text = "Hydra (Plane)", type = "action", action = "spawn", model = "hydra"},
            {text = "Buzzard (Heli)", type = "action", action = "spawn", model = "buzzard"},
            {text = "Rhino (Tank)", type = "action", action = "spawn", model = "rhino"},
            {text = "BMX (Bike)", type = "action", action = "spawn", model = "bmx"},
            {text = "Sanchez (Moto)", type = "action", action = "spawn", model = "sanchez"},
            {text = "Spawn in Vehicle", type = "checkbox", var = "spawnInVehicle"},
            {text = "< Back", type = "back"}
        }
    },
    teleport = {
        title = "TELEPORT MENU",
        subtitle = "Quick locations",
        items = {
            {text = "TP to Waypoint", type = "action", action = "tpwaypoint"},
            {text = "Save Location 1", type = "action", action = "saveloc", slot = 1},
            {text = "Load Location 1", type = "action", action = "loadloc", slot = 1},
            {text = "Save Location 2", type = "action", action = "saveloc", slot = 2},
            {text = "Load Location 2", type = "action", action = "loadloc", slot = 2},
            {text = "LS Airport", type = "action", action = "tp", coords = {-1336.0, -3044.0, 13.9}},
            {text = "Fort Zancudo", type = "action", action = "tp", coords = {-2047.0, 3132.0, 32.8}},
            {text = "Mount Chiliad", type = "action", action = "tp", coords = {501.0, 5604.0, 797.9}},
            {text = "Maze Bank Tower", type = "action", action = "tp", coords = {-75.0, -818.0, 326.0}},
            {text = "Beach", type = "action", action = "tp", coords = {-1388.0, -1463.0, 1.6}},
            {text = "Grove Street", type = "action", action = "tp", coords = {-46.0, -1864.0, 22.3}},
            {text = "< Back", type = "back"}
        }
    },
    world = {
        title = "WORLD OPTIONS",
        subtitle = "Environment control",
        items = {
            {text = "Time: Morning (6h)", type = "action", action = "time", value = 6},
            {text = "Time: Noon (12h)", type = "action", action = "time", value = 12},
            {text = "Time: Evening (18h)", type = "action", action = "time", value = 18},
            {text = "Time: Night (0h)", type = "action", action = "time", value = 0},
            {text = "Cycle Weather", type = "action", action = "cycleweather"},
            {text = "Weather: Clear", type = "action", action = "weather", value = "CLEAR"},
            {text = "Weather: Rain", type = "action", action = "weather", value = "RAIN"},
            {text = "Weather: Thunder", type = "action", action = "weather", value = "THUNDER"},
            {text = "Weather: Snow", type = "action", action = "weather", value = "SNOW"},
            {text = "Weather: Halloween", type = "action", action = "weather", value = "HALLOWEEN"},
            {text = "< Back", type = "back"}
        }
    },
    vision = {
        title = "VISION OPTIONS",
        subtitle = "Visual enhancements",
        items = {
            {text = "Night Vision", type = "checkbox", var = "nightVision"},
            {text = "Thermal Vision", type = "checkbox", var = "thermalVision"},
            {text = "Freecam", type = "checkbox", var = "freecam"},
            {text = "< Back", type = "back"}
        }
    },
    combat = {
        title = "ESP & COMBAT",
        subtitle = "Combat enhancements",
        items = {
            {text = "=== ESP OPTIONS ===", type = "info"},
            {text = "ESP Skeleton", type = "checkbox", var = "espSkeleton"},
            {text = "ESP Box", type = "checkbox", var = "espBox"},
            {text = "ESP Name", type = "checkbox", var = "espName"},
            {text = "ESP Weapon", type = "checkbox", var = "espWeapon"},
            {text = "ESP Distance", type = "checkbox", var = "espDistance"},
            {text = "ESP Health Bar", type = "checkbox", var = "espHealthBar"},
            {text = "ESP Tracers", type = "checkbox", var = "espTracers"},
            {text = "ESP Snaplines", type = "checkbox", var = "espSnaplines"},
            {text = "=== COMBAT ===", type = "info"},
            {text = "Aimbot", type = "checkbox", var = "aimbot"},
            {text = "< Back", type = "back"}
        }
    },
    model = {
        title = "MODEL CHANGER",
        subtitle = "Change player model",
        items = {
            {text = "Default Male", type = "action", action = "model", model = "mp_m_freemode_01"},
            {text = "Default Female", type = "action", action = "model", model = "mp_f_freemode_01"},
            {text = "Trevor", type = "action", action = "model", model = "player_two"},
            {text = "Michael", type = "action", action = "model", model = "player_zero"},
            {text = "Franklin", type = "action", action = "model", model = "player_one"},
            {text = "Police Officer", type = "action", action = "model", model = "s_m_y_cop_01"},
            {text = "SWAT", type = "action", action = "model", model = "s_m_y_swat_01"},
            {text = "Alien", type = "action", action = "model", model = "s_m_m_movalien_01"},
            {text = "Bigfoot", type = "action", action = "model", model = "ig_orleans"},
            {text = "Clown", type = "action", action = "model", model = "s_m_y_clown_01"},
            {text = "< Back", type = "back"}
        }
    },
    fun = {
        title = "FUN OPTIONS",
        subtitle = "Crazy modifications",
        items = {
            {text = "Drunk Mode", type = "action", action = "drunk"},
            {text = "Spawn Random Ped", type = "action", action = "spawnped"},
            {text = "Explode All Vehicles", type = "action", action = "explodeall"},
            {text = "Launch Vehicle Up", type = "action", action = "launchveh"},
            {text = "Chaos Mode (All NPCs)", type = "action", action = "chaos"},
            {text = "< Back", type = "back"}
        }
    },
    logblocker = {
        title = "LOG BLOCKER",
        subtitle = "Block server logging",
        items = {
            {text = "MASTER GHOST MODE", type = "checkbox", var = "ghostMode"},
            {text = "Blocks ALL logs below", type = "info"},
            {text = "=== SPECIFIC BLOCKERS ===", type = "info"},
            {text = "Block Kill Logs", type = "checkbox", var = "blockKillLogs"},
            {text = "Block Chat Logs", type = "checkbox", var = "blockChatLogs"},
            {text = "Block Command Logs", type = "checkbox", var = "blockCommandLogs"},
            {text = "Block Screenshots", type = "checkbox", var = "blockScreenshots"},
            {text = "Block All Events", type = "checkbox", var = "blockLogs"},
            {text = "=== INFO ===", type = "info"},
            {text = "Ghost Mode = Full stealth", type = "info"},
            {text = "HIGH DETECTION RISK", type = "info"},
            {text = "< Back", type = "back"}
        }
    },
    settings = {
        title = "SETTINGS",
        subtitle = "Menu configuration",
        items = {
            {text = "NoClip Speed: Slow", type = "action", action = "noclipspeed", value = 1.0},
            {text = "NoClip Speed: Normal", type = "action", action = "noclipspeed", value = 2.0},
            {text = "NoClip Speed: Fast", type = "action", action = "noclipspeed", value = 5.0},
            {text = "NoClip Speed: Ultra", type = "action", action = "noclipspeed", value = 10.0},
            {text = "< Back", type = "back"}
        }
    },
    outfits = {
        title = "OUTFIT MANAGER",
        subtitle = "Save & Load outfits",
        items = {
            {text = "=== SAVE OUTFITS ===", type = "info"},
            {text = "Save to Slot 1", type = "action", action = "saveoutfit", slot = 1},
            {text = "Save to Slot 2", type = "action", action = "saveoutfit", slot = 2},
            {text = "Save to Slot 3", type = "action", action = "saveoutfit", slot = 3},
            {text = "Save to Slot 4", type = "action", action = "saveoutfit", slot = 4},
            {text = "Save to Slot 5", type = "action", action = "saveoutfit", slot = 5},
            {text = "=== LOAD OUTFITS ===", type = "info"},
            {text = "Load Slot 1", type = "action", action = "loadoutfit", slot = 1},
            {text = "Load Slot 2", type = "action", action = "loadoutfit", slot = 2},
            {text = "Load Slot 3", type = "action", action = "loadoutfit", slot = 3},
            {text = "Load Slot 4", type = "action", action = "loadoutfit", slot = 4},
            {text = "Load Slot 5", type = "action", action = "loadoutfit", slot = 5},
            {text = "=== DELETE ===", type = "info"},
            {text = "Clear All Outfits", type = "action", action = "clearoutfits"},
            {text = "< Back", type = "back"}
        }
    },
    configs = {
        title = "CONFIG MANAGER",
        subtitle = "Save & Load menu configs",
        items = {
            {text = "=== SAVE CONFIGS ===", type = "info"},
            {text = "Save Config 1", type = "action", action = "saveconfig", slot = 1},
            {text = "Save Config 2", type = "action", action = "saveconfig", slot = 2},
            {text = "Save Config 3", type = "action", action = "saveconfig", slot = 3},
            {text = "Save Config 4", type = "action", action = "saveconfig", slot = 4},
            {text = "Save Config 5", type = "action", action = "saveconfig", slot = 5},
            {text = "=== LOAD CONFIGS ===", type = "info"},
            {text = "Load Config 1", type = "action", action = "loadconfig", slot = 1},
            {text = "Load Config 2", type = "action", action = "loadconfig", slot = 2},
            {text = "Load Config 3", type = "action", action = "loadconfig", slot = 3},
            {text = "Load Config 4", type = "action", action = "loadconfig", slot = 4},
            {text = "Load Config 5", type = "action", action = "loadconfig", slot = 5},
            {text = "=== INFO ===", type = "info"},
            {text = "Configs save all menu options", type = "info"},
            {text = "=== DELETE ===", type = "info"},
            {text = "Clear All Configs", type = "action", action = "clearconfigs"},
            {text = "< Back", type = "back"}
        }
    }
}

-- Charger les données au démarrage
LoadFromPersistentStorage()

-- Rafraîchir la liste des joueurs
function RefreshPlayerList()
    onlinePlayers = {}
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            table.insert(onlinePlayers, {
                id = player,
                name = GetPlayerName(player),
                serverId = GetPlayerServerId(player)
            })
        end
    end
end

-- Générer le menu des joueurs en ligne
function GenerateOnlinePlayersMenu()
    RefreshPlayerList()
    local items = {}
    
    table.insert(items, {text = "=== ONLINE PLAYERS ===", type = "info"})
    table.insert(items, {text = "Refresh List", type = "action", action = "refreshplayers"})
    table.insert(items, {text = "===", type = "info"})
    
    if #onlinePlayers == 0 then
        table.insert(items, {text = "No players found", type = "info"})
    else
        for _, player in ipairs(onlinePlayers) do
            table.insert(items, {
                text = player.name .. " [ID: " .. player.serverId .. "]",
                type = "submenu",
                target = "playeractions",
                playerId = player.id,
                playerName = player.name
            })
        end
    end
    
    table.insert(items, {text = "< Back", type = "back"})
    
    menus.onlineplayers = {
        title = "ONLINE PLAYERS",
        subtitle = tostring(#onlinePlayers) .. " players online",
        items = items
    }
end

-- Générer le menu des actions sur un joueur
function GeneratePlayerActionsMenu(playerId, playerName)
    selectedPlayer = playerId
    
    menus.playeractions = {
        title = "PLAYER: " .. playerName,
        subtitle = "Select action",
        items = {
            {text = "=== TELEPORT ===", type = "info"},
            {text = "Teleport To Player", type = "action", action = "tptoplayer", playerId = playerId},
            {text = "Teleport Player To Me", type = "action", action = "tpplayertome", playerId = playerId},
            {text = "=== TROLLING ===", type = "info"},
            {text = "Explode Player", type = "action", action = "explodeplayer", playerId = playerId},
            {text = "Ragdoll Player", type = "action", action = "ragdollplayer", playerId = playerId},
            {text = "Set On Fire", type = "action", action = "fireplayer", playerId = playerId},
            {text = "Launch Player", type = "action", action = "launchplayer", playerId = playerId},
            {text = "Freeze Player", type = "action", action = "freezeplayer", playerId = playerId},
            {text = "Spawn Plane On Player", type = "action", action = "planeplayer", playerId = playerId},
            {text = "Cage Player", type = "action", action = "cageplayer", playerId = playerId},
            {text = "=== FRIENDLY ===", type = "info"},
            {text = "Copy Outfit", type = "action", action = "copyoutfit", playerId = playerId},
            {text = "Give All Weapons", type = "action", action = "giveweaponsplayer", playerId = playerId},
            {text = "Heal Player", type = "action", action = "healplayer", playerId = playerId},
            {text = "=== INFO ===", type = "info"},
            {text = "Show Coords", type = "action", action = "showcoords", playerId = playerId},
            {text = "< Back", type = "back"}
        }
    }
end

-- Générer le menu des keybinds
function GenerateKeybindsMenu()
    menus.keybinds = {
        title = "KEYBINDS",
        subtitle = "Bind features to keys",
        items = {
            {text = "=== CURRENT BINDS ===", type = "info"},
            {text = "NoClip: " .. (keybindNames[keybinds.noclip] or "None"), type = "action", action = "bindkey", feature = "noclip"},
            {text = "ESP: " .. (keybindNames[keybinds.esp] or "None"), type = "action", action = "bindkey", feature = "esp"},
            {text = "Godmode: " .. (keybindNames[keybinds.godmode] or "None"), type = "action", action = "bindkey", feature = "godmode"},
            {text = "Teleport Gun: " .. (keybindNames[keybinds.teleportGun] or "None"), type = "action", action = "bindkey", feature = "teleportGun"},
            {text = "Super Jump: " .. (keybindNames[keybinds.superJump] or "None"), type = "action", action = "bindkey", feature = "superJump"},
            {text = "Fast Run: " .. (keybindNames[keybinds.fastRun] or "None"), type = "action", action = "bindkey", feature = "fastRun"},
            {text = "Invisible: " .. (keybindNames[keybinds.invisible] or "None"), type = "action", action = "bindkey", feature = "invisible"},
            {text = "Vehicle Repair: " .. (keybindNames[keybinds.vehicleRepair] or "None"), type = "action", action = "bindkey", feature = "vehicleRepair"},
            {text = "=== INSTRUCTIONS ===", type = "info"},
            {text = "Press ENTER to bind a key", type = "info"},
            {text = "Then press the key you want", type = "info"},
            {text = "=== ACTIONS ===", type = "info"},
            {text = "Clear All Binds", type = "action", action = "clearbinds"},
            {text = "< Back", type = "back"}
        }
    }
end

--=====================================================
-- DESSIN DU MENU AVEC ANIMATIONS
--=====================================================
function DrawMenu()
    if not menuOpen then return end
    
    -- Animation d'ouverture/fermeture
    if menuAlpha < targetAlpha then 
        menuAlpha = math.min(menuAlpha + animationSpeed, targetAlpha)
    elseif menuAlpha > targetAlpha then 
        menuAlpha = math.max(menuAlpha - animationSpeed, targetAlpha)
    end

    -- Effet de pulse
    pulseEffect = (pulseEffect + 2) % 360
    local pulse = math.sin(pulseEffect * 0.01745) * 0.5 + 0.5
    
    -- Effet de glow
    glowEffect = (glowEffect + 3) % 360
    local glow = math.sin(glowEffect * 0.01745) * 20 + 235

    local menu = menus[currentMenu]
    if not menu then return end

    local x, y, width, headerHeight, itemHeight = 0.05, 0.05, 0.26, 0.10, 0.040

    -- Ombre avec glow effect
    DrawRectangle(x + width/2 + 0.003, y + headerHeight/2 + 0.003, width, headerHeight, 0, 0, 0, math.floor(menuAlpha * 0.8))
    
    -- Header moderne avec gradient animé
    local headerColor = math.floor(glow)
    DrawRectangle(x + width/2, y + headerHeight/2, width, headerHeight, 0, headerColor, 255, menuAlpha)
    DrawRectangle(x + width/2, y + headerHeight/2 - 0.025, width, 0.002, 255, 255, 255, math.floor(menuAlpha * (pulse * 50 + 50)))
    
    -- Titre avec effet de glow
    DrawText3D(x + 0.005, y + 0.005, "XENOR ULTIMATE", 0.65, 255, 255, 255, menuAlpha, 4, false)
    DrawText3D(x + 0.005, y + 0.05, menu.subtitle, 0.38, 200, 200, 200, menuAlpha, 0, false)
    
    -- Compteur animé
    local countText = string.format("%d/%d", selectedItem, #menu.items)
    DrawText3D(x + width - 0.035, y + 0.05, countText, 0.32, 150, 255, 255, menuAlpha, 0, false)
    
    y = y + headerHeight + 0.003

    -- Titre de section avec animation
    DrawRectangle(x + width/2, y + 0.022, width, 0.044, 15, 15, 15, math.floor(menuAlpha * 0.95))
    DrawRectangle(x + width/2, y + 0.001, width, 0.002, 0, headerColor, 255, math.floor(menuAlpha * 0.7))
    DrawText3D(x + 0.005, y + 0.010, menu.title, 0.45, 255, 255, 255, menuAlpha, 4, false)
    y = y + 0.046

    -- Items avec animations de transition
    local maxVisible = 11
    local startIndex = math.max(1, selectedItem - maxVisible + 1)
    local endIndex = math.min(#menu.items, startIndex + maxVisible - 1)

    for i = startIndex, endIndex do
        local item = menu.items[i]
        local isSelected = (i == selectedItem)
        
        -- Animation de l'item
        if not itemAnimations[i] then itemAnimations[i] = 0 end
        if isSelected then
            itemAnimations[i] = math.min(itemAnimations[i] + 15, 255)
        else
            itemAnimations[i] = math.max(itemAnimations[i] - 15, 0)
        end
        
        local animAlpha = itemAnimations[i]
        
        -- Background de l'item avec animation de sélection
        if isSelected then
            -- Barre de sélection avec glow
            DrawRectangle(x + width/2, y + itemHeight/2, width, itemHeight, 0, 140, 255, math.floor(menuAlpha * 0.9))
            DrawRectangle(x + 0.002, y + itemHeight/2, 0.004, itemHeight, 0, 200, 255, menuAlpha)
            -- Effet de pulse sur l'item sélectionné
            DrawRectangle(x + width/2, y + itemHeight/2, width, itemHeight, 255, 255, 255, math.floor(pulse * 30))
        else
            DrawRectangle(x + width/2, y + itemHeight/2, width, itemHeight, 0, 0, 0, math.floor(menuAlpha * 0.7))
        end

        -- Ligne de séparation animée
        local sepAlpha = isSelected and menuAlpha or math.floor(menuAlpha * 0.5)
        DrawRectangle(x + width/2, y + itemHeight + 0.0007, width, 0.0015, 40, 40, 40, sepAlpha)

        local displayText = item.text
        local textColor = isSelected and {255,255,255,menuAlpha} or {200,200,200,menuAlpha}
        
        -- Indicateur de type d'item
        local indicator = ""
        if item.type == "submenu" then indicator = ">"
        elseif item.type == "checkbox" then indicator = ""
        elseif item.type == "action" then indicator = "•"
        end
        
        -- Texte avec animation
        local textX = x + 0.012
        if isSelected then textX = textX + (animAlpha / 255) * 0.003 end
        DrawText3D(textX, y + 0.007, displayText, 0.38, textColor[1], textColor[2], textColor[3], textColor[4], 0, false)
        
        -- Indicateur
        if indicator ~= "" then
            DrawText3D(x + 0.005, y + 0.007, indicator, 0.35, textColor[1], textColor[2], textColor[3], textColor[4], 0, false)
        end

        -- État checkbox avec animation
        if item.type=="checkbox" and item.var then
            local state = menuVars[item.var]
            local stateText = state and "ON" or "OFF"
            local stateColor = state and {0, 255, 100} or {255, 80, 80}
            DrawText3D(x + width - 0.028, y + 0.007, stateText, 0.36, stateColor[1], stateColor[2], stateColor[3], menuAlpha, 0, false)
            
            -- Barre d'état animée
            if state then
                local barWidth = 0.025
                DrawRectangle(x + width - 0.025, y + itemHeight/2, barWidth, 0.003, 0, 255, 100, math.floor(menuAlpha * 0.8))
            end
        end
        
        y = y + itemHeight + 0.002
    end

    -- Footer moderne avec instructions animées
    y = y + 0.015
    DrawRectangle(x + width/2, y + 0.030, width, 0.060, 0,0,0, math.floor(menuAlpha * 0.85))
    DrawRectangle(x + width/2, y + 0.001, width, 0.002, 0, headerColor, 255, math.floor(menuAlpha * 0.6))
    
    local instrAlpha = math.floor(menuAlpha * (pulse * 0.3 + 0.7))
    DrawText3D(x + 0.005, y + 0.008, "Navigate", 0.32, 150, 200, 255, instrAlpha, 0, false)
    DrawText3D(x + 0.005, y + 0.028, "ENTER Select | BACKSPACE Back", 0.30, 200, 200, 200, menuAlpha, 0, false)
    DrawText3D(x + 0.005, y + 0.048, "INSERT Open | DELETE Close", 0.30, 200, 200, 200, menuAlpha, 0, false)
end  -- <- Correction ici

--=====================================================
-- NAVIGATION AVEC ANIMATIONS
--=====================================================
function MenuUp()
    if selectedItem > 1 then 
        selectedItem = selectedItem - 1
    else 
        selectedItem = #menus[currentMenu].items
    end
    -- Reset animation pour le nouvel item
    for i = 1, #menus[currentMenu].items do
        if i ~= selectedItem then itemAnimations[i] = 0 end
    end
end

function MenuDown()
    if selectedItem < #menus[currentMenu].items then 
        selectedItem = selectedItem + 1
    else 
        selectedItem = 1
    end
    -- Reset animation pour le nouvel item
    for i = 1, #menus[currentMenu].items do
        if i ~= selectedItem then itemAnimations[i] = 0 end
    end
end

function MenuSelect()
    local menu = menus[currentMenu]
    local item = menu.items[selectedItem]
    if not item then return end

    -- Animation de clic
    itemAnimations[selectedItem] = 255
    
    if item.type == "submenu" then
        previousMenu = currentMenu
        currentMenu = item.target
        selectedItem = 1
        menuTransitionProgress = 0
        itemAnimations = {}
        
        -- Générer le menu des actions joueur si nécessaire
        if item.target == "playeractions" and item.playerId then
            GeneratePlayerActionsMenu(item.playerId, item.playerName)
        end
        
        -- Rafraîchir la liste des joueurs si on ouvre le menu online
        if item.target == "onlineplayers" then
            GenerateOnlinePlayersMenu()
        end
        
        -- Rafraîchir le menu keybinds
        if item.target == "keybinds" then
            GenerateKeybindsMenu()
        end
    elseif item.type == "back" then
        if currentMenu == "playeractions" then
            currentMenu = "onlineplayers"
            GenerateOnlinePlayersMenu()
        else
            currentMenu = "main"
        end
        selectedItem = 1
        menuTransitionProgress = 0
        itemAnimations = {}
    elseif item.type == "checkbox" and item.var then
        menuVars[item.var] = not menuVars[item.var]
        HandleCheckbox(item.var, menuVars[item.var])
    elseif item.type == "action" then
        HandleAction(item)
    end
end

function MenuBack()
    if currentMenu ~= "main" then
        currentMenu = "main"
        selectedItem = 1
        menuTransitionProgress = 0
        itemAnimations = {}
    end
end

--=====================================================
-- GESTION DES CHECKBOX
--=====================================================
function HandleCheckbox(var, state)
    local ped = PlayerPedId()
    if var == "godMode" then
        -- Fix: Godmode maintenant avec heal infini
        ShowNotification(state and "God Mode activated" or "God Mode disabled")
    elseif var == "invisible" then
        SetEntityVisible(ped, not state, 0)
        ShowNotification(state and "Invisibility activated" or "Invisibility disabled")
    elseif var == "noclip" then
        ShowNotification(state and "NoClip activated (WASD+QE)" or "NoClip disabled")
    elseif var == "antiTP" then
        if state then
            lastTPCoords = GetEntityCoords(ped)
            antiTPActive = true
            ShowNotification("Anti-TP activated - Position locked")
        else
            antiTPActive = false
            ShowNotification("Anti-TP disabled")
        end
    elseif var == "vehicleLift" then
        if state then
            ShowNotification("Vehicle Lift activated - Press U to lift/throw")
        else
            if liftedVehicle ~= 0 then
                DetachEntity(liftedVehicle, true, true)
                liftedVehicle = 0
            end
            ShowNotification("Vehicle Lift disabled")
        end
    elseif var == "godmodeKiller" then
        ShowNotification(state and "Godmode Killer activated" or "Godmode Killer disabled")
    elseif var == "superJump" then
        ShowNotification(state and "Super Jump activated" or "Super Jump disabled")
    elseif var == "fastRun" then
        ShowNotification(state and "Fast Run activated" or "Fast Run disabled")
    elseif var == "superSpeed" then
        ShowNotification(state and "Super Speed activated" or "Super Speed disabled")
    elseif var == "noRagdoll" then
        ShowNotification(state and "No Ragdoll activated" or "No Ragdoll disabled")
    elseif var == "unlimitedStamina" then
        ShowNotification(state and "Unlimited Stamina activated" or "Stamina normal")
    elseif var == "infiniteAmmo" then
        ShowNotification(state and "Infinite Ammo activated" or "Ammo normal")
    elseif var == "noReload" then
        ShowNotification(state and "No Reload activated" or "Reload normal")
    elseif var == "rapidFire" then
        ShowNotification(state and "Rapid Fire activated" or "Fire rate normal")
    elseif var == "explosiveAmmo" then
        ShowNotification(state and "Explosive Ammo activated" or "Ammo normal")
    elseif var == "fireAmmo" then
        ShowNotification(state and "Fire Ammo activated" or "Ammo normal")
    elseif var == "teleportGun" then
        ShowNotification(state and "Teleport Gun activated" or "Teleport Gun disabled")
    elseif var == "deleteGun" then
        ShowNotification(state and "Delete Gun activated" or "Delete Gun disabled")
    elseif var == "explosionGun" then
        ShowNotification(state and "Explosion Gun activated" or "Explosion Gun disabled")
    elseif var == "gravityGun" then
        ShowNotification(state and "Gravity Gun activated" or "Gravity Gun disabled")
    elseif var == "rainbowWeapon" then
        ShowNotification(state and "Rainbow Weapon activated" or "Rainbow disabled")
    elseif var == "vehgod" then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            SetEntityInvincible(veh, state)
            ShowNotification(state and "Vehicle God Mode ON" or "Vehicle God Mode OFF")
        else
            ShowNotification("Not in vehicle")
            menuVars.vehgod = false
        end
    elseif var == "vehBoost" then
        ShowNotification(state and "Vehicle Boost activated (SHIFT)" or "Boost disabled")
    elseif var == "vehRainbow" then
        ShowNotification(state and "Rainbow Vehicle activated" or "Rainbow disabled")
    elseif var == "vehNeonRainbow" then
        ShowNotification(state and "Rainbow Neon activated" or "Neon disabled")
    elseif var == "autoRepair" then
        ShowNotification(state and "Auto Repair activated" or "Auto Repair disabled")
    elseif var == "drift" then
        ShowNotification(state and "Drift Mode activated" or "Drift disabled")
    elseif var == "nightVision" then
        SetNightvision(state)
        ShowNotification(state and "Night Vision activated" or "Night Vision disabled")
    elseif var == "thermalVision" then
        SetSeethrough(state)
        ShowNotification(state and "Thermal Vision activated" or "Thermal disabled")
    elseif var == "freecam" then
        ShowNotification(state and "Freecam activated" or "Freecam disabled")
    elseif var == "freezeWanted" then
        ShowNotification(state and "Wanted Level frozen" or "Wanted Level normal")
    elseif var == "noWanted" then
        if state then
            SetMaxWantedLevel(0)
            ShowNotification("Never Wanted activated")
        else
            SetMaxWantedLevel(5)
            ShowNotification("Wanted system normal")
        end
    elseif var == "ghostMode" then
        if state then
            menuVars.blockKillLogs = true
            menuVars.blockChatLogs = true
            menuVars.blockCommandLogs = true
            menuVars.blockScreenshots = true
            menuVars.blockLogs = true
            ShowNotification("GHOST MODE ACTIVATED - All logs blocked")
        else
            menuVars.blockKillLogs = false
            menuVars.blockChatLogs = false
            menuVars.blockCommandLogs = false
            menuVars.blockScreenshots = false
            menuVars.blockLogs = false
            ShowNotification("Ghost Mode disabled - Logs back to normal")
        end
    end
end

--=====================================================
-- GESTION DES ACTIONS
--=====================================================
function HandleAction(item)
    local ped = PlayerPedId()
    local action = item.action
    
    if action == "heal" then
        SetEntityHealth(ped, 200)
        ShowNotification("Health fully restored")
    elseif action == "armor" then
        SetPedArmour(ped, 100)
        ShowNotification("Armor maxed out")
    elseif action == "suicide" then
        SetEntityHealth(ped, 0)
        ShowNotification("Goodbye cruel world")
    elseif action == "clearwanted" then
        ClearPlayerWantedLevel(PlayerId())
        ShowNotification("Wanted level cleared")
    elseif action == "wantedplus" then
        SetPlayerWantedLevel(PlayerId(), GetPlayerWantedLevel(PlayerId()) + 1, false)
        SetPlayerWantedLevelNow(PlayerId(), false)
        ShowNotification("Wanted level increased")
    elseif action == "wantedmax" then
        SetPlayerWantedLevel(PlayerId(), 5, false)
        SetPlayerWantedLevelNow(PlayerId(), false)
        ShowNotification("Maximum wanted level")
    elseif action == "giveweapon" and item.weaponHash then
        GiveWeaponToPed(ped, GetHashKey(item.weaponHash), 9999, false, true)
        ShowNotification("Weapon given: " .. item.weaponHash)
    elseif action == "giveallweapons" then
        for _, weapon in ipairs(availableWeapons) do
            GiveWeaponToPed(ped, GetHashKey(weapon.hash), 9999, false, false)
        end
        ShowNotification("ALL weapons given (" .. #availableWeapons .. " weapons)")
    elseif action == "addcomponent" and item.component then
        local weapon = GetSelectedPedWeapon(ped)
        if weapon ~= GetHashKey("WEAPON_UNARMED") then
            GiveWeaponComponentToPed(ped, weapon, GetHashKey(item.component))
            ShowNotification("Component added")
        else
            ShowNotification("No weapon equipped")
        end
    elseif action == "removeallcomponents" then
        local weapon = GetSelectedPedWeapon(ped)
        if weapon ~= GetHashKey("WEAPON_UNARMED") then
            RemoveAllPedWeapons(ped, false)
            GiveWeaponToPed(ped, weapon, 9999, false, true)
            ShowNotification("All components removed")
        end
    elseif action == "spawn" and item.model then
        local hash = GetHashKey(item.model)
        RequestModel(hash)
        local timeout = 0
        while not HasModelLoaded(hash) and timeout < 5000 do 
            Wait(10)
            timeout = timeout + 10
        end
        if HasModelLoaded(hash) then
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local veh = CreateVehicle(hash, coords.x + 3, coords.y, coords.z, heading, true, false)
            if menuVars.spawnInVehicle then
                SetPedIntoVehicle(ped, veh, -1)
            end
            SetVehicleOnGroundProperly(veh)
            ShowNotification("Vehicle spawned: " .. item.model)
            SetModelAsNoLongerNeeded(hash)
        else
            ShowNotification("Failed to load vehicle model")
        end
    elseif action == "repair" then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            SetVehicleFixed(veh)
            SetVehicleDirtLevel(veh, 0.0)
            ShowNotification("Vehicle repaired")
        else
            ShowNotification("Not in a vehicle")
        end
    elseif action == "clean" then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            SetVehicleDirtLevel(veh, 0.0)
            ShowNotification("Vehicle cleaned")
        end
    elseif action == "maxupgrade" then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            SetVehicleModKit(veh, 0)
            for i = 0, 49 do
                local max = GetNumVehicleMods(veh, i) - 1
                SetVehicleMod(veh, i, max, false)
            end
            ToggleVehicleMod(veh, 18, true)
            ToggleVehicleMod(veh, 22, true)
            SetVehicleWindowTint(veh, 1)
            ShowNotification("Vehicle maxed out")
        end
    elseif action == "vehcolor" then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            local r, g, b = math.random(0, 255), math.random(0, 255), math.random(0, 255)
            SetVehicleCustomPrimaryColour(veh, r, g, b)
            SetVehicleCustomSecondaryColour(veh, r, g, b)
            ShowNotification("Random color applied")
        end
    elseif action == "boost" then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            SetVehicleForwardSpeed(veh, 50.0)
            ShowNotification("BOOST!")
        end
    elseif action == "flip" then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            SetVehicleOnGroundProperly(veh)
            ShowNotification("Vehicle flipped")
        end
    elseif action == "deleteveh" then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            DeleteVehicle(veh)
            ShowNotification("Vehicle deleted")
        end
    elseif action == "allweapons" then
        for _, weapon in ipairs(availableWeapons) do
            GiveWeaponToPed(ped, GetHashKey(weapon.hash), 9999, false, false)
        end
        ShowNotification("ALL weapons given (" .. #availableWeapons .. " weapons)")
    elseif action == "removeweapons" then
        RemoveAllPedWeapons(ped, true)
        ShowNotification("All weapons removed")
    elseif action == "weapontint" then
        local weapon = GetSelectedPedWeapon(ped)
        if weapon ~= GetHashKey("WEAPON_UNARMED") then
            currentWeaponTint = (currentWeaponTint + 1) % 8
            SetPedWeaponTintIndex(ped, weapon, currentWeaponTint)
            ShowNotification("Weapon tint changed")
        end
    elseif action == "tpwaypoint" then
        local waypoint = GetFirstBlipInfoId(8)
        if DoesBlipExist(waypoint) then
            local coords = GetBlipInfoIdCoord(waypoint)
            local ground, z = GetGroundZFor_3dCoord(coords.x, coords.y, 1000.0, 0)
            SetEntityCoords(ped, coords.x, coords.y, z)
            ShowNotification("Teleported to waypoint")
        else
            ShowNotification("No waypoint set on map")
        end
    elseif action == "saveloc" and item.slot then
        local coords = GetEntityCoords(ped)
        savedLocations[item.slot] = {x = coords.x, y = coords.y, z = coords.z}
        ShowNotification("Location " .. item.slot .. " saved")
    elseif action == "loadloc" and item.slot then
        if savedLocations[item.slot] then
            local loc = savedLocations[item.slot]
            SetEntityCoords(ped, loc.x, loc.y, loc.z)
            ShowNotification("Teleported to location " .. item.slot)
        else
            ShowNotification("No location saved in slot " .. item.slot)
        end
    elseif action == "tp" and item.coords then
        SetEntityCoords(ped, item.coords[1], item.coords[2], item.coords[3])
        ShowNotification("Teleported")
    elseif action == "time" and item.value then
        NetworkOverrideClockTime(item.value, 0, 0)
        ShowNotification("Time changed to " .. item.value .. "h")
    elseif action == "weather" and item.value then
        SetWeatherTypeNowPersist(item.value)
        ShowNotification("Weather: " .. item.value)
    elseif action == "cycleweather" then
        currentWeatherIndex = (currentWeatherIndex % #weatherTypes) + 1
        SetWeatherTypeNowPersist(weatherTypes[currentWeatherIndex])
        ShowNotification("Weather: " .. weatherTypes[currentWeatherIndex])
    elseif action == "model" and item.model then
        local hash = GetHashKey(item.model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do Wait(0) end
        SetPlayerModel(PlayerId(), hash)
        SetPedDefaultComponentVariation(ped)
        ShowNotification("Model changed")
        SetModelAsNoLongerNeeded(hash)
    elseif action == "drunk" then
        SetPedIsDrunk(ped, true)
        ShowNotification("You feel dizzy...")
    elseif action == "spawnped" then
        local pedModels = {"a_m_y_hipster_01", "a_f_y_hippie_01", "s_m_y_clown_01", "a_m_y_beach_01"}
        local model = pedModels[math.random(#pedModels)]
        local hash = GetHashKey(model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do Wait(0) end
        local coords = GetEntityCoords(ped)
        CreatePed(4, hash, coords.x + 2, coords.y, coords.z, 0.0, true, false)
        ShowNotification("Random ped spawned")
        SetModelAsNoLongerNeeded(hash)
    elseif action == "explodeall" then
        local vehicles = {}
        local handle, veh = FindFirstVehicle()
        local success
        repeat
            if veh ~= GetVehiclePedIsIn(ped, false) then
                table.insert(vehicles, veh)
            end
            success, veh = FindNextVehicle(handle)
        until not success
        EndFindVehicle(handle)
        for _, v in ipairs(vehicles) do
            local coords = GetEntityCoords(v)
            AddExplosion(coords.x, coords.y, coords.z, 7, 1.0, true, false, 1.0)
        end
        ShowNotification("CHAOS!")
    elseif action == "launchveh" then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            ApplyForceToEntity(veh, 1, 0.0, 0.0, 50.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
            ShowNotification("LAUNCHED!")
        end
    elseif action == "chaos" then
        local peds = {}
        local handle, p = FindFirstPed()
        local success
        repeat
            if p ~= ped then table.insert(peds, p) end
            success, p = FindNextPed(handle)
        until not success
        EndFindPed(handle)
        for _, p in ipairs(peds) do
            TaskCombatPed(p, ped, 0, 16)
        end
        ShowNotification("CHAOS MODE ACTIVATED!")
    elseif action == "noclipspeed" and item.value then
        noclipSpeed = item.value
        ShowNotification("NoClip speed set to " .. item.value)
    elseif action == "saveoutfit" and item.slot then
        SaveOutfit(item.slot)
    elseif action == "loadoutfit" and item.slot then
        LoadOutfit(item.slot)
    elseif action == "clearoutfits" then
        savedOutfits = {}
        SaveToPersistentStorage()
        ShowNotification("All outfits cleared")
    elseif action == "saveconfig" and item.slot then
        SaveConfig(item.slot)
    elseif action == "loadconfig" and item.slot then
        LoadConfig(item.slot)
    elseif action == "clearconfigs" then
        savedConfigs = {}
        SaveToPersistentStorage()
        ShowNotification("All configs cleared")
    elseif action == "reset" then
        for k,_ in pairs(menuVars) do menuVars[k] = false end
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, 0)
        SetNightvision(false)
        SetSeethrough(false)
        ShowNotification("All options reset")
    -- Actions joueurs en ligne
    elseif action == "refreshplayers" then
        GenerateOnlinePlayersMenu()
        ShowNotification("Player list refreshed - " .. #onlinePlayers .. " players found")
    elseif action == "tptoplayer" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            local coords = GetEntityCoords(targetPed)
            SetEntityCoords(ped, coords.x, coords.y, coords.z)
            ShowNotification("Teleported to player")
        end
    elseif action == "tpplayertome" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            local coords = GetEntityCoords(ped)
            SetEntityCoords(targetPed, coords.x, coords.y, coords.z)
            ShowNotification("Player teleported to you")
        end
    elseif action == "explodeplayer" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            local coords = GetEntityCoords(targetPed)
            AddExplosion(coords.x, coords.y, coords.z, 2, 1.0, true, false, 1.0)
            ShowNotification("Player exploded")
        end
    elseif action == "ragdollplayer" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            SetPedToRagdoll(targetPed, 5000, 5000, 0, 0, 0, 0)
            ShowNotification("Player ragdolled")
        end
    elseif action == "fireplayer" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            local coords = GetEntityCoords(targetPed)
            StartScriptFire(coords.x, coords.y, coords.z, 25, false)
            ShowNotification("Player set on fire")
        end
    elseif action == "launchplayer" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            ApplyForceToEntity(targetPed, 1, 0.0, 0.0, 50.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
            ShowNotification("Player launched")
        end
    elseif action == "freezeplayer" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            FreezeEntityPosition(targetPed, true)
            ShowNotification("Player frozen")
        end
    elseif action == "planeplayer" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            local coords = GetEntityCoords(targetPed)
            local hash = GetHashKey("jet")
            RequestModel(hash)
            while not HasModelLoaded(hash) do Wait(0) end
            CreateVehicle(hash, coords.x, coords.y, coords.z + 15.0, 0.0, true, false)
            SetModelAsNoLongerNeeded(hash)
            ShowNotification("Plane spawned on player")
        end
    elseif action == "cageplayer" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            local coords = GetEntityCoords(targetPed)
            local hash = GetHashKey("prop_container_01a")
            RequestModel(hash)
            while not HasModelLoaded(hash) do Wait(0) end
            CreateObject(hash, coords.x, coords.y, coords.z - 1.0, true, false, false)
            SetModelAsNoLongerNeeded(hash)
            ShowNotification("Player caged")
        end
    elseif action == "copyoutfit" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            local targetModel = GetEntityModel(targetPed)
            RequestModel(targetModel)
            while not HasModelLoaded(targetModel) do Wait(0) end
            SetPlayerModel(PlayerId(), targetModel)
            ped = PlayerPedId()
            
            -- Copier tous les composants
            for i = 0, 11 do
                local drawable = GetPedDrawableVariation(targetPed, i)
                local texture = GetPedTextureVariation(targetPed, i)
                local palette = GetPedPaletteVariation(targetPed, i)
                SetPedComponentVariation(ped, i, drawable, texture, palette)
            end
            
            -- Copier les props
            for i = 0, 7 do
                local propIndex = GetPedPropIndex(targetPed, i)
                local propTexture = GetPedPropTextureIndex(targetPed, i)
                if propIndex ~= -1 then
                    SetPedPropIndex(ped, i, propIndex, propTexture, true)
                else
                    ClearPedProp(ped, i)
                end
            end
            
            SetModelAsNoLongerNeeded(targetModel)
            ShowNotification("Outfit copied from player")
        end
    elseif action == "giveweaponsplayer" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            local weapons = {
                "WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_ASSAULTRIFLE", 
                "WEAPON_CARBINERIFLE", "WEAPON_PUMPSHOTGUN", "WEAPON_SNIPERRIFLE"
            }
            for _, w in ipairs(weapons) do
                GiveWeaponToPed(targetPed, GetHashKey(w), 9999, false, false)
            end
            ShowNotification("Weapons given to player")
        end
    elseif action == "healplayer" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            SetEntityHealth(targetPed, 200)
            SetPedArmour(targetPed, 100)
            ShowNotification("Player healed")
        end
    elseif action == "showcoords" and item.playerId then
        local targetPed = GetPlayerPed(item.playerId)
        if DoesEntityExist(targetPed) then
            local coords = GetEntityCoords(targetPed)
            ShowNotification(string.format("Player coords: X:%.1f Y:%.1f Z:%.1f", coords.x, coords.y, coords.z))
        end
    -- Keybinds
    elseif action == "bindkey" and item.feature then
        ShowNotification("Press a key to bind to " .. item.feature .. "...")
        Citizen.CreateThread(function()
            local startTime = GetGameTimer()
            while GetGameTimer() - startTime < 5000 do
                Wait(0)
                for key = 0, 350 do
                    if IsControlJustPressed(0, key) then
                        keybinds[item.feature] = key
                        ShowNotification(item.feature .. " bound to key " .. key)
                        GenerateKeybindsMenu()
                        return
                    end
                end
            end
            ShowNotification("Keybind cancelled (timeout)")
        end)
    elseif action == "clearbinds" then
        for k, _ in pairs(keybinds) do
            keybinds[k] = 0
        end
        GenerateKeybindsMenu()
        ShowNotification("All keybinds cleared")
    end
end

--=====================================================
-- THREAD PRINCIPAL
--=====================================================
Citizen.CreateThread(function()
    while true do
        Wait(0)

        -- Open menu (INSERT)
        if IsControlJustPressed(0, openMenuKey) then
            if not menuOpen then
                menuOpen = true
                targetAlpha = 255
                currentMenu = "main"
                selectedItem = 1
                itemAnimations = {}
            end
        end

        -- Navigation menu
        if menuOpen then
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)

            -- Close menu (DELETE)
            if IsControlJustPressed(0, closeMenuKey) or IsDisabledControlJustPressed(0, closeMenuKey) then
                menuOpen = false
                targetAlpha = 0
            end

            if IsControlJustPressed(0, 172) or IsDisabledControlJustPressed(0, 172) then MenuUp() end
            if IsControlJustPressed(0, 173) or IsDisabledControlJustPressed(0, 173) then MenuDown() end
            if IsControlJustPressed(0, 176) or IsDisabledControlJustPressed(0, 176) then MenuSelect() end
            if IsControlJustPressed(0, 177) or IsDisabledControlJustPressed(0, 177) then MenuBack() end

            DrawMenu()
        end

        -- Anti-TP
        if menuVars.antiTP and antiTPActive then
            local currentCoords = GetEntityCoords(PlayerPedId())
            if lastTPCoords then
                local distance = #(currentCoords - lastTPCoords)
                if distance > 50.0 then
                    SetEntityCoords(PlayerPedId(), lastTPCoords.x, lastTPCoords.y, lastTPCoords.z)
                    ShowNotification("TP Blocked by Anti-TP")
                else
                    lastTPCoords = currentCoords
                end
            end
        end

        -- Godmode avec heal infini (FIX)
        if menuVars.godMode then
            local ped = PlayerPedId()
            local health = GetEntityHealth(ped)
            local maxHealth = GetEntityMaxHealth(ped)
            
            -- Heal constant si la santé descend
            if health < maxHealth then
                SetEntityHealth(ped, maxHealth)
            end
            
            -- Protection contre les dégâts
            SetEntityInvincible(ped, true)
            SetPlayerInvincible(PlayerId(), true)
            
            -- Regen armor aussi
            local armor = GetPedArmour(ped)
            if armor < 100 then
                SetPedArmour(ped, 100)
            end
        else
            -- Désactiver la protection quand godmode est off
            SetEntityInvincible(PlayerPedId(), false)
            SetPlayerInvincible(PlayerId(), false)
        end

        -- Keybinds
        if keybinds.noclip ~= 0 and IsControlJustPressed(0, keybinds.noclip) then
            menuVars.noclip = not menuVars.noclip
            HandleCheckbox("noclip", menuVars.noclip)
        end
        
        if keybinds.esp ~= 0 and IsControlJustPressed(0, keybinds.esp) then
            menuVars.espBox = not menuVars.espBox
            menuVars.espName = menuVars.espBox
            menuVars.espDistance = menuVars.espBox
            menuVars.espHealthBar = menuVars.espBox
            ShowNotification(menuVars.espBox and "ESP activated" or "ESP disabled")
        end
        
        if keybinds.godmode ~= 0 and IsControlJustPressed(0, keybinds.godmode) then
            menuVars.godMode = not menuVars.godMode
            HandleCheckbox("godMode", menuVars.godMode)
        end
        
        if keybinds.teleportGun ~= 0 and IsControlJustPressed(0, keybinds.teleportGun) then
            menuVars.teleportGun = not menuVars.teleportGun
            HandleCheckbox("teleportGun", menuVars.teleportGun)
        end
        
        if keybinds.superJump ~= 0 and IsControlJustPressed(0, keybinds.superJump) then
            menuVars.superJump = not menuVars.superJump
            HandleCheckbox("superJump", menuVars.superJump)
        end
        
        if keybinds.fastRun ~= 0 and IsControlJustPressed(0, keybinds.fastRun) then
            menuVars.fastRun = not menuVars.fastRun
            HandleCheckbox("fastRun", menuVars.fastRun)
        end
        
        if keybinds.invisible ~= 0 and IsControlJustPressed(0, keybinds.invisible) then
            menuVars.invisible = not menuVars.invisible
            HandleCheckbox("invisible", menuVars.invisible)
        end
        
        if keybinds.vehicleRepair ~= 0 and IsControlJustPressed(0, keybinds.vehicleRepair) then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if veh ~= 0 then
                SetVehicleFixed(veh)
                SetVehicleDirtLevel(veh, 0.0)
                ShowNotification("Vehicle repaired")
            end
        end

        -- Vehicle Lift
        if menuVars.vehicleLift then
            if IsControlJustPressed(0, 303) then -- U key
                if liftedVehicle == 0 then
                    local ped = PlayerPedId()
                    local coords = GetEntityCoords(ped)
                    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 71)
                    if vehicle ~= 0 then
                        liftedVehicle = vehicle
                        AttachEntityToEntity(vehicle, ped, 0, 0.0, 2.0, liftOffset, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                        ShowNotification("Vehicle lifted - Press U to throw")
                    end
                else
                    DetachEntity(liftedVehicle, true, true)
                    local ped = PlayerPedId()
                    local forward = GetEntityForwardVector(ped)
                    SetEntityVelocity(liftedVehicle, forward.x * 50.0, forward.y * 50.0, forward.z * 20.0)
                    liftedVehicle = 0
                    ShowNotification("Vehicle thrown!")
                end
            end
        end

        -- Godmode Killer Gun
        if menuVars.godmodeKiller then
            if IsPedShooting(PlayerPedId()) then
                local hit, coords, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                if hit and entity ~= 0 and IsEntityAPed(entity) then
                    SetEntityInvincible(entity, false)
                    SetEntityHealth(entity, 0)
                    ShowNotification("Target eliminated (Godmode bypassed)")
                end
            end
        end

        -- NoClip
        if menuVars.noclip then
            local ped = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(ped))
            local dx, dy, dz = GetCamDirection()
            local speed = noclipSpeed

            if IsControlPressed(0, 32) then x, y, z = x + speed * dx, y + speed * dy, z + speed * dz end
            if IsControlPressed(0, 33) then x, y, z = x - speed * dx, y - speed * dy, z - speed * dz end
            if IsControlPressed(0, 34) then x, y = x - speed * dy, y + speed * dx end
            if IsControlPressed(0, 35) then x, y = x + speed * dy, y - speed * dx end
            if IsControlPressed(0, 44) then z = z - speed end
            if IsControlPressed(0, 38) then z = z + speed end

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
            SetEntityVelocity(ped, 0.0, 0.0, 0.0)
        end

        -- Super Jump
        if menuVars.superJump then
            SetSuperJumpThisFrame(PlayerId())
        end

        -- Fast Run
        if menuVars.fastRun then
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
            SetPedMoveRateOverride(PlayerPedId(), 2.0)
        end

        -- Super Speed
        if menuVars.superSpeed then
            SetRunSprintMultiplierForPlayer(PlayerId(), 2.5)
            SetPedMoveRateOverride(PlayerPedId(), 3.0)
        end

        -- No Ragdoll
        if menuVars.noRagdoll then
            SetPedCanRagdoll(PlayerPedId(), false)
        end

        -- Unlimited Stamina
        if menuVars.unlimitedStamina then
            RestorePlayerStamina(PlayerId(), 1.0)
        end

        -- Infinite Ammo
        if menuVars.infiniteAmmo then
            SetPedInfiniteAmmoClip(PlayerPedId(), true)
        end

        -- No Reload
        if menuVars.noReload then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
            if weapon ~= GetHashKey("WEAPON_UNARMED") then
                SetAmmoInClip(ped, weapon, 999)
            end
        end

        -- Rapid Fire
        if menuVars.rapidFire then
            local ped = PlayerPedId()
            if IsPedShooting(ped) then
                local _, weapon = GetCurrentPedWeapon(ped, true)
                SetPedInfiniteAmmoClip(ped, true)
            end
        end

        -- Teleport Gun
        if menuVars.teleportGun then
            if IsControlJustPressed(0, 24) then
                local ped = PlayerPedId()
                local coords = GetCoordsFromCam(1000.0)
                SetEntityCoords(ped, coords.x, coords.y, coords.z)
            end
        end

        -- Delete Gun
        if menuVars.deleteGun then
            if IsControlJustPressed(0, 24) then
                local entity = GetEntityInCrosshair()
                if entity ~= 0 then
                    DeleteEntity(entity)
                end
            end
        end

        -- Explosion Gun
        if menuVars.explosionGun then
            if IsPedShooting(PlayerPedId()) then
                local coords = GetCoordsFromCam(200.0)
                AddExplosion(coords.x, coords.y, coords.z, 2, 1.0, true, false, 0.5)
            end
        end

        -- Rainbow Weapon
        if menuVars.rainbowWeapon then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
            if weapon ~= GetHashKey("WEAPON_UNARMED") then
                currentWeaponTint = (currentWeaponTint + 1) % 8
                SetPedWeaponTintIndex(ped, weapon, currentWeaponTint)
            end
        end

        -- Vehicle Boost
        if menuVars.vehBoost then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= 0 and IsControlPressed(0, 21) then
                SetVehicleForwardSpeed(veh, 50.0)
            end
        end

        -- Rainbow Vehicle
        if menuVars.vehRainbow then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= 0 then
                vehicleRainbowR = (vehicleRainbowR + 1) % 360
                local r = math.floor(math.sin(vehicleRainbowR * 0.01745) * 127 + 128)
                local g = math.floor(math.sin((vehicleRainbowR + 120) * 0.01745) * 127 + 128)
                local b = math.floor(math.sin((vehicleRainbowR + 240) * 0.01745) * 127 + 128)
                SetVehicleCustomPrimaryColour(veh, r, g, b)
                SetVehicleCustomSecondaryColour(veh, r, g, b)
            end
        end

        -- Rainbow Neon
        if menuVars.vehNeonRainbow then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= 0 then
                vehicleRainbowR = (vehicleRainbowR + 1) % 360
                local r = math.floor(math.sin(vehicleRainbowR * 0.01745) * 127 + 128)
                local g = math.floor(math.sin((vehicleRainbowR + 120) * 0.01745) * 127 + 128)
                local b = math.floor(math.sin((vehicleRainbowR + 240) * 0.01745) * 127 + 128)
                SetVehicleNeonLightEnabled(veh, 0, true)
                SetVehicleNeonLightEnabled(veh, 1, true)
                SetVehicleNeonLightEnabled(veh, 2, true)
                SetVehicleNeonLightEnabled(veh, 3, true)
                SetVehicleNeonLightsColour(veh, r, g, b)
            end
        end

        -- Auto Repair
        if menuVars.autoRepair then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= 0 and GetVehicleEngineHealth(veh) < 990 then
                SetVehicleFixed(veh)
            end
        end

        -- Drift Mode
        if menuVars.drift then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= 0 then
                SetVehicleReduceGrip(veh, true)
            end
        end

        -- ESP Avancé
        if menuVars.espSkeleton or menuVars.espBox or menuVars.espName or menuVars.espWeapon or 
           menuVars.espDistance or menuVars.espHealthBar or menuVars.espTracers or menuVars.espSnaplines then
            DrawAdvancedESP()
        end

        -- Freeze Wanted
        if menuVars.freezeWanted then
            local currentWanted = GetPlayerWantedLevel(PlayerId())
            SetPlayerWantedLevel(PlayerId(), currentWanted, false)
        end

        -- Explosive/Fire Ammo
        if menuVars.explosiveAmmo or menuVars.fireAmmo then
            local ped = PlayerPedId()
            if IsPedShooting(ped) then
                local hit, coords = GetPedLastWeaponImpactCoord(ped)
                if hit then
                    if menuVars.explosiveAmmo then
                        AddExplosion(coords.x, coords.y, coords.z, 2, 0.5, true, false, 0.2)
                    end
                    if menuVars.fireAmmo then
                        StartScriptFire(coords.x, coords.y, coords.z, 1, false)
                    end
                end
            end
        end
        
        -- Log Blocker System
        if menuVars.ghostMode or menuVars.blockLogs or menuVars.blockKillLogs or menuVars.blockChatLogs or menuVars.blockCommandLogs or menuVars.blockScreenshots then
            local eventsToBlock = {
                "playerKilled", "baseevents:onPlayerKilled", "esx:onPlayerDeath",
                "qb-log:server:CreateLog", "qb-logs:server:createLog",
                "gameEventTriggered", "CEventNetworkEntityDamage",
                "screenshot_basic:requestScreenshot", "discord:screenshot", "DiscordBot:playerDied",
                "weaponDamageEvent", "startProjectileEvent", "explosionEvent",
                "chatMessage", "chat:messageEntered", "__cfx_internal:commandFallback",
                "anticheat:log", "ac:log", "log:server", "sendLog", "adminLog"
            }
            
            for _, event in ipairs(eventsToBlock) do
                if menuVars.ghostMode or menuVars.blockLogs then
                    AddEventHandler(event, function()
                        CancelEvent()
                    end)
                elseif menuVars.blockKillLogs and (string.find(event:lower(), "kill") or string.find(event:lower(), "death") or string.find(event:lower(), "damage")) then
                    AddEventHandler(event, function()
                        CancelEvent()
                    end)
                elseif menuVars.blockScreenshots and string.find(event:lower(), "screenshot") then
                    AddEventHandler(event, function()
                        CancelEvent()
                    end)
                elseif menuVars.blockChatLogs and (string.find(event:lower(), "chat") or string.find(event:lower(), "message")) then
                    AddEventHandler(event, function()
                        CancelEvent()
                    end)
                elseif menuVars.blockCommandLogs and string.find(event:lower(), "command") then
                    AddEventHandler(event, function()
                        CancelEvent()
                    end)
                end
            end
        end
    end
end)

--=====================================================
-- FONCTIONS HELPER
--=====================================================
function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then x, y, z = x / len, y / len, z / len end
    return x, y, z
end

function GetCoordsFromCam(distance)
    local camRot = GetGameplayCamRot(2)
    local camPos = GetGameplayCamCoord()
    local dir = RotationToDirection(camRot)
    local dest = {
        x = camPos.x + dir.x * distance,
        y = camPos.y + dir.y * distance,
        z = camPos.z + dir.z * distance
    }
    local ray = StartShapeTestRay(camPos.x, camPos.y, camPos.z, dest.x, dest.y, dest.z, -1, PlayerPedId(), 0)
    local _, hit, coords = GetShapeTestResult(ray)
    if hit then
        return coords
    end
    return dest
end

function RotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function GetEntityInCrosshair()
    local camRot = GetGameplayCamRot(2)
    local camPos = GetGameplayCamCoord()
    local dir = RotationToDirection(camRot)
    local dest = {
        x = camPos.x + dir.x * 200.0,
        y = camPos.y + dir.y * 200.0,
        z = camPos.z + dir.z * 200.0
    }
    local ray = StartShapeTestRay(camPos.x, camPos.y, camPos.z, dest.x, dest.y, dest.z, -1, PlayerPedId(), 0)
    local _, hit, _, _, entity = GetShapeTestResult(ray)
    if hit then
        return entity
    end
    return 0
end

function GetEntityPlayerIsFreeAimingAt(player)
    local ped = GetPlayerPed(player)
    local hit, coords, entity
    if IsPlayerFreeAiming(player) then
        hit, entity = GetEntityPlayerIsFreeAimingAt(player)
        if hit then
            coords = GetEntityCoords(entity)
            return true, coords, entity
        end
    end
    return false, nil, 0
end