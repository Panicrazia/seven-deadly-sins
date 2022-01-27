local Mod = RegisterMod("Seven Deadly Sins", 1)
local json = require("json")
--local pills = include(pills) --it has come to my attention that lua is a pain in the ass when it comes to seprate files, kill me

--HUD offset details shown below from immortal hearts mod
-- Translate mod config menu's HUD offsets into actual X/Y offsets that we can use.
-- If MCM isn't installed, index 10 (max) is used because it's the default HUD offset.
local mcmHudOffsets = {
    [0] = {x = 40, y = 4},
    [1] = {x = 42, y = 5},
    [2] = {x = 44, y = 6},
    [3] = {x = 46, y = 7},
    [4] = {x = 48, y = 9},
    [5] = {x = 50, y = 10},
    [6] = {x = 52, y = 11},
    [7] = {x = 54, y = 12},
    [8] = {x = 56, y = 13},
    [9] = {x = 58, y = 15},
    [10] = {x = 60, y = 16}
}

local PetrifiedHeartStats = {
    DAMAGE = .5,
    TEARS = -.2,
    SPEED = -.1
}

local function getHudOffsets()
    -- Get the HUD offset.
    -- TODO: make this use Options.HUDOffset (why is this a 0-1 float??? How does that work?)
    if ModConfigMenu and ModConfigMenu.Config and ModConfigMenu.Config["General"] and ModConfigMenu.Config["General"].HudOffset then
        return mcmHudOffsets[ModConfigMenu.Config["General"].HudOffset] or mcmHudOffsets[10]
    else
        return mcmHudOffsets[10]
    end
end

-- Per-heart XY offsets. The first heart has this offset not applied, the second heart has the X offset applied once, etc...
local hudhealthhoroffset = 12
local hudhealthveroffset = 10

-- Load sprites for UI
local petrifiedHeartSprite = Sprite()
petrifiedHeartSprite:Load("gfx/ui/petrifiedheart_sprite.anm2", true)

local playerCustomHealth = {}
local playerId = 0

local Curses = {
    CURSE_BROKEN = 1 << (Isaac.GetCurseIdByName("Curse of the Broken!") - 1)
}

local ModPillEffects = {
	PILLPOCALYPSE = Isaac.GetPillEffectByName("PILLPOCALYPSE!"),
    PILLCOLLAPSE = Isaac.GetPillEffectByName("Pillcollapse?"),
    PETRIFICATION = Isaac.GetPillEffectByName("Petrification"),
    LEPROSY = Isaac.GetPillEffectByName("Leprosy"),
    PARANOIA = Isaac.GetPillEffectByName("Paranoia"),
    METH = Isaac.GetPillEffectByName("Methamphetamines"),
    XANNY = Isaac.GetPillEffectByName("Xanax"),
    FLAX = Isaac.GetPillEffectByName("ƒ-lax"),
    XXLAX = Isaac.GetPillEffectByName("Ж-lax"),
    OOBE = Isaac.GetPillEffectByName("Out of Body Experience"),
	PHANTOM_PAINS = Isaac.GetPillEffectByName("Phantom Pains"),
    SEEING_RED_GOOD = Isaac.GetPillEffectByName("I'm Seeing Red!"),
    SEEING_RED_BAD = Isaac.GetPillEffectByName("I'm Seeing Red?"),
    THC = Isaac.GetPillEffectByName("THC"),
    GBPILLS = Isaac.GetPillEffectByName("Good Boy Pills"),
    PLAN_B = Isaac.GetPillEffectByName("Plan B"),
    ROSE_TINTED = Isaac.GetPillEffectByName("Rose Tinted Glasses"),
    DEMENTIA = Isaac.GetPillEffectByName("Dementia"),
    SPIRIT_SALTS = Isaac.GetPillEffectByName("Spirit Salts"),
    BATH_SALTS = Isaac.GetPillEffectByName("Bath Salts"),
    IMMAGINARY_FRIENDS = Isaac.GetPillEffectByName("Imaginary Friends"),
    HALLUCINATIONS = Isaac.GetPillEffectByName("Hallucinations"),
    SEEING_GOLD_GOOD = Isaac.GetPillEffectByName("I'm Seeing Gold!"),
    SEEING_GOLD_BAD = Isaac.GetPillEffectByName("I'm Seeing Gold?"),
    FRIENDS_TO_THE_VERY_END = Isaac.GetPillEffectByName("Friends to the Very End"),
    SWORN_ENEMIES = Isaac.GetPillEffectByName("Sworn Enemies"),
    CALCIFICATION = Isaac.GetPillEffectByName("Calcification"),
    ACETOMETAPHIN = Isaac.GetPillEffectByName("Acetaminophen"),
    PARACETOMOL = Isaac.GetPillEffectByName("Paracetamol"),
    BIPOLAR = Isaac.GetPillEffectByName("Bipolar"),
    I_FOUND_BIG_PILLS = Isaac.GetPillEffectByName("I found BIG pills!"),
    DIURETICS = Isaac.GetPillEffectByName("Diuretics"),
    SOMETHINGS_REALLY_WRONG = Isaac.GetPillEffectByName("Somethings really wrong"),
    WEIGHT_GAIN_SUPPLEMENTS = Isaac.GetPillEffectByName("Weight Gain Supplements"),
    WEIGHT_LOSS_SUPPLEMENTS = Isaac.GetPillEffectByName("Weight Loss Supplements"),
    ABSOLUTE_CHAOS = Isaac.GetPillEffectByName("Absolute Chaos"),
    MINDBLOWING = Isaac.GetPillEffectByName("Mindblowing"),
    PSILOCYBIN = Isaac.GetPillEffectByName("Psilocybin"),
    MYSTERY_DRUG = Isaac.GetPillEffectByName("Mystery Drug"),
    SPEED = Isaac.GetPillEffectByName("Speed"),
    PHARMACEUTICAL_HEALING = Isaac.GetPillEffectByName("Pharmaceutical Healing"),
    HEARTBROKEN = Isaac.GetPillEffectByName("Heartbroken"),
    CRASH = Isaac.GetPillEffectByName("Energy Crash!")
}

local DoctorItemPool = {
    CollectibleType.COLLECTIBLE_VIRUS,
    CollectibleType.COLLECTIBLE_ROID_RAGE,
    CollectibleType.COLLECTIBLE_GROWTH_HORMONES,
    CollectibleType.COLLECTIBLE_PHD,
    CollectibleType.COLLECTIBLE_MOMS_BOTTLE_OF_PILLS,
    CollectibleType.COLLECTIBLE_FORGET_ME_NOW,
    CollectibleType.COLLECTIBLE_SPEED_BALL,
    CollectibleType.COLLECTIBLE_MOMS_COIN_PURSE,
    CollectibleType.COLLECTIBLE_EXPERIMENTAL_TREATMENT,
    CollectibleType.COLLECTIBLE_LITTLE_BAGGY,
    CollectibleType.COLLECTIBLE_CAFFEINE_PILL,
    CollectibleType.COLLECTIBLE_SYNTHOIL,
    CollectibleType.COLLECTIBLE_PLACEBO,
    CollectibleType.COLLECTIBLE_PLAN_C,
    CollectibleType.COLLECTIBLE_ACID_BABY,
    CollectibleType.COLLECTIBLE_ADRENALINE,
    CollectibleType.COLLECTIBLE_LIL_SPEWER,
    CollectibleType.COLLECTIBLE_EUTHANASIA,
    CollectibleType.COLLECTIBLE_FALSE_PHD
}

--Gotten from immortal hearts again, and apparently:
-- These hacky workarounds are necessary because the JSON serializer does not like unordered numerical keys.
-- So instead, before encoding the table, the keys are all converted to strings.
-- After decode, the keys are all turned into numbers again.
--oh dear oh my I have to save all data like this
local function tableToString(table)
    local output = {}
    for player_index, player_health in pairs(table) do
        local playerdata_output = {}
        for heart_index, heart_info in pairs(player_health) do
            playerdata_output[tostring(heart_index)] = heart_info
        end
        output[tostring(player_index)] = playerdata_output
    end

    return json.encode(output)
end

local function stringToTable(str)
    local table = json.decode(str)
    local output = {}

    for player_index, player_health in pairs(table) do
        local playerdata_output = {}
        for heart_index, heart_info in pairs(player_health) do
            playerdata_output[tonumber(heart_index)] = heart_info
        end
        output[tonumber(player_index)] = playerdata_output
    end

    return output
end


function Mod:PreGameExit( isSaving)
    if isSaving then
        Mod:SaveData(tableToString(playerCustomHealth))
    end

    playerCustomHealth = {}
    playerId = 0
end

Mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, Mod.PreGameExit)

function Mod:PostPlayerInit(player)
    if Mod:HasData() and next(playerCustomHealth) == nil then
        local savedData = Mod:LoadData()
        if savedData then
            local decodedSavedData = stringToTable(savedData)
            if decodedSavedData and type(decodedSavedData) == "table" then
                playerCustomHealth = decodedSavedData
            end
        end
    end

    if not playerCustomHealth[playerId] then
        playerCustomHealth[playerId] = {}
    end

    player:GetData().playerId = playerId
    playerId = playerId + 1

    if type(player:GetData()["DevilDealsTaken"]) == type(nil) then
        player:GetData()["DevilDealsTaken"] = 0
    end
    if type(player:GetData()["CheckDevilPurchase"]) == type(nil) then
        player:GetData()["CheckDevilPurchase"] = 0
    end
    if type(player:GetData()["HealthIndex"]) == type(nil) then
        player:GetData()["HealthIndex"] = {}
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Mod.PostPlayerInit)

-- If the player starts a new game, clear out all existing save data and rebuild the immortalhealth array fresh.
function Mod:PostGameStarted(isContinued)
    if not isContinued then
        playerCustomHealth = {}
        for player_index, player in pairs(getAllPlayers()) do
            playerCustomHealth[player_index] = {}
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Mod.PostGameStarted)

function Curses:onEval(CurseFlags)
    return CurseFlags | Curses.CURSE_BROKEN
    --give the curses
end

Mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL , Curses.onEval)

local function ShowText()
    Isaac.RenderText("Frame count: "..Game():GetRoom():GetFrameCount(), 50, 50, 1 ,1 ,1 ,1 )
    local level = Game():GetLevel()
    if level:GetCurses() & Curses.CURSE_BROKEN > 0 then
        
        
    end
    if(not Game():GetPlayer(0):IsItemQueueEmpty()) then
        Isaac.RenderText(Game():GetPlayer(0).QueuedItem.Item.ID, 50, 70, 1 ,1 ,1 ,1 )
    end
    Isaac.RenderText(Mod.GetPlayerMaxHealth(Game():GetPlayer(0)), 50, 90, 1 ,1 ,1 ,1 )
    --Isaac.RenderText(Game():GetPlayer(0):GetData()["CheckDevilPurchase"], 50, 110, 1 ,1 ,1 ,1 )
end

Mod:AddCallback(ModCallbacks.MC_POST_RENDER , ShowText)

function Mod:CurseOfTheBroken()
    local room = Game():GetRoom()
    local entities = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
    for key, entity in pairs(entities) do
        --Isaac.RenderText(entity:ToPickup().State, 60, 60, 1 ,1 ,1 ,1 )
        if((entity.FrameCount > 50) 
        and (entity.FrameCount%60 == 0) 
        and (entity.SubType ~= 0) 
        and not (entity:ToPickup().Touched)) then
            Game():SpawnParticles(entity.Position+Vector(0,0), EffectVariant.POOF02, 1, 0)
            
            if(entity:GetDropRNG():RandomInt(2) == 0) then
                entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0)
                --entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, entity:GetDropRNG():Next())
                --apparently just putting in 0 also makes it random idk
            else
                entity:Remove()
                --if someone knows how to make a pedestal empty please tell me
            end
        end
    end
end

function Mod.GetPlayerMaxHealth(player)
    return (player:GetMaxHearts() + player:GetSoulHearts() + (player:GetBoneHearts() * 2))
end

function Mod.GetPlayerMaxHealthContainers(player)
    return (math.ceil(player:GetMaxHearts()/2) + math.ceil(player:GetSoulHearts()/2))
end

function Mod.GetPlayerCurrentHealth(player)
    return (player:GetHearts() + player:GetSoulHearts() + (player:GetBoneHearts() * 2))
end

function Mod:OnPlayerDamage(target, DamageAmount, DamageFlags, DamageSource)
    -- No damage (holy mantle), or the damage is inflicted by us? We don't need to handle this.

    if DamageAmount <= 0 or (DamageFlags & DamageFlag.DAMAGE_CLONES == DamageFlag.DAMAGE_CLONES) then
        return nil
    end

    local player = target:ToPlayer()

    -- This function should return true if the original damage should be kept.
    -- Returning false allows us to ignore the "original" damage and re-apply it ourselves, our way.
    -- However, this should only happen if the rightmost heart is an immortal heart.
    local shouldKeepOriginalDamage = true

    -- Round up to the nearest whole heart
    local rightmostHeartIndex = math.ceil(Mod.GetPlayerCurrentHealth(player) * 0.5)

    if player:GetData()["HealthIndex"][rightmostHeartIndex] ~= nil and player:GetData()["HealthIndex"][rightmostHeartIndex].petrified then

        -- Ignore the original damage
        shouldKeepOriginalDamage = false

        player:GetData()["HealthIndex"][rightmostHeartIndex] = nil

        player:TakeDamage(1, DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_CLONES, DamageSource, 5000)

        SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1)

        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end

    -- NOTE: Mod API has yet another bug in it!
    -- Returning anything except nil will break other mods' damage triggers.
    -- This means that we should return nil if we should keep the original damage, or return false otherwise.
    if not shouldKeepOriginalDamage then
        return false
    end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Mod.OnPlayerDamage, EntityType.ENTITY_PLAYER)

function Mod:PostGameUpdate()
    local level = Game():GetLevel()
    if level:GetCurses() & Curses.CURSE_BROKEN > 0 then
        Mod.CurseOfTheBroken()
    end
    for playerNum = 1, Game():GetNumPlayers() do
        local player = Game():GetPlayer(playerNum - 1)
        if type(player:GetData()["CheckDevilPurchase"] ~= type(nil)) then
            if((not player:IsItemQueueEmpty()) 
            and (player:GetData()["CheckDevilPurchase"] == player.QueuedItem.Item.ID)) then
                player:GetData()["DevilDealsTaken"] = player:GetData()["DevilDealsTaken"] + 1
                player:GetData()["CheckDevilPurchase"] = 0
            end
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE , Mod.PostGameUpdate)

function Mod:CacheUpdate(player, flags)
    local petrifiedHeartsCount = 0
    for heart_index, heart_info in pairs(player:GetData()["HealthIndex"]) do
        if heart_info ~= nil then
            if heart_info.petrified ~= nil and heart_info.petrified == true then
                petrifiedHeartsCount = petrifiedHeartsCount + 1
            end
        end
    end

    if(flags == CacheFlag.CACHE_DAMAGE) then
        player.Damage = player.Damage + (petrifiedHeartsCount * PetrifiedHeartStats.DAMAGE)
    elseif(flags == CacheFlag.CACHE_FIREDELAY) then
        player.MaxFireDelay = player.MaxFireDelay + (petrifiedHeartsCount * PetrifiedHeartStats.TEARS)
    elseif(flags == CacheFlag.CACHE_SHOTSPEED) then
        
    elseif(flags == CacheFlag.CACHE_RANGE) then
        
    elseif(flags == CacheFlag.CACHE_SPEED) then
        player.MoveSpeed = player.MoveSpeed + (petrifiedHeartsCount * PetrifiedHeartStats.SPEED)
        if(player:GetData()["PetrificationPillsTaken"] ~= nil) then
            player.MoveSpeed = player.MoveSpeed + (player:GetData()["PetrificationPillsTaken"] * PetrifiedHeartStats.SPEED)
        end
    elseif(flags == CACHE_LUCK) then
        
    end
    player:AddGoldenBomb()
    --this is to see if brekfast causes a cache evaluation
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE , Mod.CacheUpdate)

local function RenderPetrifyHearts()
    petrifiedHeartSprite:Play("Petrified_Heart", true)
    
    -- TODO: Do other chars, shouldnt be too difficult assuming the player index to health location on screen is the same each time
    local player = Game():GetPlayer(0)
    for heart_index, heart_info in pairs(player:GetData()["HealthIndex"]) do
        if heart_info ~= nil then
            if heart_info.petrified ~= nil and heart_info.petrified == true then

                -- First heart starts at 1, but the X/Y offsets for the sprites should start at 0
                local heart_offset = heart_index - 1

                local baseoffsets = getHudOffsets()

                local x_offset = baseoffsets.x + (heart_offset * hudhealthhoroffset)
                local y_offset
                if heart_index > 12 then
                    x_offset = x_offset - (hudhealthhoroffset * 6)
                    y_offset = baseoffsets.y + (hudhealthveroffset * 2)
                elseif heart_index > 6 then
                    x_offset = x_offset - (hudhealthhoroffset * 6)
                    y_offset = baseoffsets.y + hudhealthveroffset
                else
                    y_offset = baseoffsets.y
                end

                petrifiedHeartSprite:Render(Vector(x_offset, y_offset), Vector(0,0), Vector(0,0))
            end
        end
    end
end

--TY immortal hearts have my 17th born child pls
-- We need to do the rendering here rather than in POST_RENDER, because now we can render our sprites *over* the HUD rather than under it.
-- This is done by using a dummy shader.
function Mod:RenderHearts(shaderName)
    -- Only render if the shader is my own
    if shaderName ~= "UI_DrawHearts_DummyShader" then
        return nil
    end

    RenderPetrifyHearts()

    return nil
end

Mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, Mod.RenderHearts)

function Mod:ReplacePillEffect(pillEffect, pillColor)
    return ModPillEffects.LEPROSY
end
Mod:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT, Mod.ReplacePillEffect)

function Mod:UsePill(pillEffect, player, _)
    --remake paralysis into a pill that freezes isaac, enemies and enemy shots in the air, essentially a short term pause
end

function Mod:IsHorsePill(player)
    return (player:GetPill(0) >= 2048)
end

function Mod:PillEffectPILLPOCALYPSE(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --turns all drops in room into pills, idk if this should ignore unopened chests or not
    --horse version changes items into pill based items
    
    local entities = Isaac.FindByType(EntityType.ENTITY_PICKUP)
    local newPillID = 0
    local pocalypseID = player:GetPill(0)
    if player:GetPill(0) >= 2048 then 
        pocalypseID = pocalypseID - 2048
    end
    for key, entity in pairs(entities) do
        if(horse and (entity.Variant == PickupVariant.PICKUP_COLLECTIBLE)) then
            local newItemID = (entity:GetDropRNG():RandomInt(#DoctorItemPool)+1)
            entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, DoctorItemPool[newItemID])
        end
        if((entity.Variant ~= PickupVariant.PICKUP_COLLECTIBLE) and (entity.Variant ~= 340) and (entity.Variant < 370)) then
            newPillID = entity:GetDropRNG():RandomInt(13) + 1
            if(pocalypseID == newPillID) then
                --cannot reroll into pillpocalypse pills
                newPillID = ((newPillID + entity:GetDropRNG():RandomInt(11)) % 13) + 1
            end
            if(entity:GetDropRNG():RandomInt(1000) == 0) then
                --.1% chance for golden pill
                newPillID = 14
            elseif(entity:GetDropRNG():RandomInt(200) == 0) then
                --.5% chence for horsepill, can only get golden horsepills if og pill is horsepill
                newPillID = newPillID + 2048
            end
            if((newPillID < 2000) and horse) then
                newPillID = newPillID + 2048
            end
            entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, newPillID)
        end
    end
end

function Mod:PillEffectPILLCOLLAPSE(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectPETRIFICATION(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --horsepill also gives you a small rock item
    if(horse) then
        player:AddCollectible(CollectibleType.COLLECTIBLE_SMALL_ROCK, 0, true)
    end

    --[[
        there should also be a tinted petrified heart that has a rare chance to spawn instead,
        horsepills should have a much higher chance to spawn these (like 3-4 for 12 hearts),
        these should simulate a tinted rock breaking when they get destroyed, 
        droping the pickups around isaac as if he were the position of the rock
        
        also need to do keeper coin shaped petrified hearts
    ]]--

    player:AddHearts(player:GetMaxHearts()-player:GetHearts())
    if player:GetSoulHearts() % 2 == 1 then
        player:AddSoulHearts(1)
    end

    local maxHealth = Mod.GetPlayerMaxHealthContainers(player)

    if(player:GetData()["PetrificationPillsTaken"] == nil) then
        player:GetData()["PetrificationPillsTaken"] = 1
    else
        player:GetData()["PetrificationPillsTaken"] = player:GetData()["PetrificationPillsTaken"] + 1
    end

    for i=1,maxHealth,1 do
        --if(player:GetData()["HealthIndex"][i].petrified ~= nil 
        --or player:GetData()["HealthIndex"][i].petrified == false) then
            player:GetData()["HealthIndex"][i] = {
                petrified = true 
            }
        --end
    end
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:EvaluateItems()
end

function Mod:PillEffectLEPROSY(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)

    if(horse) then
        --yes this is a lazy and redundant way to do this shaddup
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.SWARM_FLY_ORBITAL, 0, player.Position, Vector(0,0), player)
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.SWARM_FLY_ORBITAL, 0, player.Position, Vector(0,0), player)
    end

    player:AddRottenHearts(player:GetMaxHearts())
end

function Mod:PillEffectMETH(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectXANNY(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectFLAX(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --again, horse pill idk
    --I thought about the idea of a giant hallowed poop, which honestly sounds pretty cool
    Isaac.GridSpawn(GridEntityType.GRID_POOP, 6, entity.Position, true)
end

function Mod:PillEffectXXLAX(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectOOBE(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectPHANTOM_PAINS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --idk what a horse should do

    --as it turns out damage countdown does literally nothing, neat
    --idk mabs its something in entityplayer class, it has alot of damagecooldown functions
    player:TakeDamage(1, DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_NOKILL, EntityRef(player), 1)
end

function Mod:PillEffectSEEING_RED_GOOD(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectSEEING_RED_BAD(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectTHC(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectGBPILLS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectPLAN_B(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectROSE_TINTED(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectDEMENTIA(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectSPIRIT_SALTS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectBATH_SALTS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectIMMAGINARY_FRIENDS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)

    --make them spawn in different positions around isaac
    --i dunno what horse should do, just make 10?

    player:AddMinisaac(player.Position, true)
    player:AddMinisaac(player.Position, true)
    player:AddMinisaac(player.Position, true)
    player:AddMinisaac(player.Position, true)
    player:AddMinisaac(player.Position, true)
end

function Mod:PillEffectHALLUCINATIONS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    
    --horsepill should make those big wisps?
    --also the positions should be far away from the screen and not all in the same place
    
    Isaac.Spawn(EntityType.ENTITY_WILLO, 0, 0, player.Position, Vector(0,0), nil)
    Isaac.Spawn(EntityType.ENTITY_WILLO, 0, 0, player.Position, Vector(0,0), nil)
    Isaac.Spawn(EntityType.ENTITY_WILLO, 0, 0, player.Position, Vector(0,0), nil)
    Isaac.Spawn(EntityType.ENTITY_WILLO, 0, 0, player.Position, Vector(0,0), nil)
    Isaac.Spawn(EntityType.ENTITY_WILLO, 0, 0, player.Position, Vector(0,0), nil)
end

function Mod:PillEffectSEEING_GOLD_GOOD(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    
    Game():GetRoom():TurnGold()
    Game()
    local entities = Isaac.GetRoomEntities()

    for key, entity in pairs(entities) do
        if(entitiy:IsEnemy()) then
            entity:AddMidasFreeze(EntityRef(player), 150)
        end
        if(horse) then
            if(entity.Type == EntityType.ENTITY_PICKUP) then
                if(entity.Variant == PickupVariant.PICKUP_KEY and entity.SubType ~= KeySubType.KEY_GOLDEN) then
                    entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN, true, true, true)
                elseif(entity.Variant == PickupVariant.PICKUP_BOMB and (entity.SubType ~= BombSubType.BOMB_GOLDEN or entity.SubType ~= BombSubType.BOMB_GOLDENTROLL)) then
                    if(entity.SubType == BombSubType.BOMB_TROLL or entity.SubType == BombSubType.BOMB_GOLDENTROLL) then
                        entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDENTROLL, true, true, true)
                    else
                        entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN, true, true, true)
                    end
                end
            end
        end
    end
end

function Mod:PillEffectSEEING_GOLD_BAD(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectFRIENDS_TO_THE_VERY_END(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectSWORN_ENEMIES(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectCALCIFICATION(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectACETOMETAPHIN(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectPARACETOMOL(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectBIPOLAR(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectI_FOUND_BIG_PILLS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectDIURETICS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectSOMETHINGS_REALLY_WRONG(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectWEIGHT_GAIN_SUPPLEMENTS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectWEIGHT_LOSS_SUPPLEMENTS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectABSOLUTE_CHAOS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectMINDBLOWING(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectPSILOCYBIN(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectMYSTERY_DRUG(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectSPEED(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectPHARMACEUTICAL_HEALING(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectHEARTBROKEN(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectCRASH(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end


--please do not tell me this shits gotta change when unlocks get added
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPILLPOCALYPSE, ModPillEffects.PILLPOCALYPSE)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPILLCOLLAPSE, ModPillEffects.PILLCOLLAPSE)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPETRIFICATION, ModPillEffects.PETRIFICATION)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectLEPROSY, ModPillEffects.LEPROSY)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectMETH, ModPillEffects.METH)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectXANNY, ModPillEffects.XANNY)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectFLAX, ModPillEffects.FLAX)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectXXLAX, ModPillEffects.XXLAX)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectOOBE, ModPillEffects.OOBE)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPHANTOM_PAINS, ModPillEffects.PHANTOM_PAINS)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectSEEING_RED_GOOD, ModPillEffects.SEEING_RED_GOOD)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectSEEING_RED_BAD, ModPillEffects.SEEING_RED_BAD)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectTHC, ModPillEffects.THC)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectGBPILLS, ModPillEffects.GBPILLS)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPLAN_B, ModPillEffects.PLAN_B)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectROSE_TINTED, ModPillEffects.ROSE_TINTED)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectDEMENTIA, ModPillEffects.DEMENTIA)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectSPIRIT_SALTS, ModPillEffects.SPIRIT_SALTS)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectBATH_SALTS, ModPillEffects.BATH_SALTS)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectIMMAGINARY_FRIENDS, ModPillEffects.IMMAGINARY_FRIENDS)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectHALLUCINATIONS, ModPillEffects.HALLUCINATIONS)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectSEEING_GOLD_GOOD, ModPillEffects.SEEING_GOLD_GOOD)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectSEEING_GOLD_BAD, ModPillEffects.SEEING_GOLD_BAD)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectFRIENDS_TO_THE_VERY_END, ModPillEffects.FRIENDS_TO_THE_VERY_END)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectSWORN_ENEMIES, ModPillEffects.SWORN_ENEMIES)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectCALCIFICATION, ModPillEffects.CALCIFICATION)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectACETOMETAPHIN, ModPillEffects.ACETOMETAPHIN)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPARACETOMOL, ModPillEffects.PARACETOMOL)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectBIPOLAR, ModPillEffects.BIPOLAR)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectI_FOUND_BIG_PILLS, ModPillEffects.I_FOUND_BIG_PILLS)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectDIURETICS, ModPillEffects.DIURETICS)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectSOMETHINGS_REALLY_WRONG, ModPillEffects.SOMETHINGS_REALLY_WRONG)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectWEIGHT_GAIN_SUPPLEMENTS, ModPillEffects.WEIGHT_GAIN_SUPPLEMENTS)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectWEIGHT_LOSS_SUPPLEMENTS, ModPillEffects.WEIGHT_LOSS_SUPPLEMENTS)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectABSOLUTE_CHAOS, ModPillEffects.ABSOLUTE_CHAOS)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectMINDBLOWING, ModPillEffects.MINDBLOWING)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPSILOCYBIN, ModPillEffects.PSILOCYBIN)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectMYSTERY_DRUG, ModPillEffects.MYSTERY_DRUG)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectSPEED, ModPillEffects.SPEED)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPHARMACEUTICAL_HEALING, ModPillEffects.PHARMACEUTICAL_HEALING)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectHEARTBROKEN, ModPillEffects.HEARTBROKEN)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectCRASH, ModPillEffects.CRASH)
--Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.UsePill)



--for methamphetamines, the devil deal counter could work by doing the on collision thing iwth pickups, 
--see if it has a cost, and then seeing if later isaac has the item in his queued inventory


--[[
function Mod:PostEntityRemove(entity, entityType)
    
    if(entityType == EntityType.ENTITY_PICKUP) then
        if((entity.Variant == 100) and (entity.ToPickup().Price < 0) and (entity.ToPickup().Price > -10)) then
            if type(player:GetData()["DevilDealsTaken"]) ~= type(nil) then
                player:GetData()["DevilDealsTaken"] = player:GetData()["DevilDealsTaken"] + 1
            else
                player:GetData()["DevilDealsTaken"] = 0
            end
        end
    end
    player:GetData()["DevilDealsTaken"] = 0
    
end

Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, Mod.PostEntityRemove)
]]--

function Mod:PrePickupCollision(pickup,collider,isAggressor)
    if not collider:ToPlayer() then return end
	local player = collider:ToPlayer()
    
    if((Game():GetRoom():GetType() == RoomType.ROOM_DEVIL) 
    and (pickup.Price ~= 0) 
    and (pickup.Price > -10)
    and (player:IsItemQueueEmpty())) then
        player:GetData()["CheckDevilPurchase"] = pickup.SubType
        --player:GetData()["DevilDealsTaken"] = player:GetData()["DevilDealsTaken"] + 1
    end
    
end

Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Mod.PrePickupCollision)