NanatsuNoTaizai = RegisterMod("Seven Deadly Sins", 1)
local Mod = NanatsuNoTaizai
local Game = Game()
local sfx = SFXManager()
local screenHelper = require("lua.screenhelper")
local json = require("json")
--local pills = include(pills) --it has come to my attention that lua is a pain in the ass when it comes to seprate files, kill me

local PetrifiedHeartStats = {
    DAMAGE = 0.4,
    TEARSPERCENT = -0.018375,
    TEARSMAX = 0.5,
    SPEED = -0.05
}

local MethStatsTable = {
    [-1] = {damage = 0.15, firedelay = 0, firedelayMax = 0.0, shotspeed = 0, range = 0, speed = 0},
    [1] = {damage = 1.5, firedelay = 0, firedelayMax = 0.0, shotspeed = 0.2, range = -40, speed = 0},
    [2] = {damage = 2.85, firedelay = 0, firedelayMax = 0.5, shotspeed = 0.4, range = -80, speed = 0.1},
    [3] = {damage = 3.75, firedelay = 0.60, firedelayMax = 0.5, shotspeed = 0.6, range = -120, speed = 0.3},
    [4] = {damage = 4.5, firedelay = 0.60, firedelayMax = 0.5, shotspeed = 0.8, range = -160, speed = 0.4},
    [5] = {damage = 5.6, firedelay = 1.2, firedelayMax = 0.5, shotspeed = 1.0, range = -200, speed = 0.6},
    [6] = {damage = 6.7, firedelay = 1.2, firedelayMax = 1.0, shotspeed = 1.2, range = -240, speed = 0.8},
    [7] = {damage = 9.9, firedelay = 2.1, firedelayMax = 2.0, shotspeed = 1.4, range = -280, speed = 1.1},
    [8] = {damage = 11.1, firedelay = 2.1, firedelayMax = 2.5, shotspeed = 1.6, range = -380, speed = 2},
    [9] = {damage = 13.4, firedelay = 2.5, firedelayMax = 3, shotspeed = 1.8, range = -480, speed = 2},
    [10] = {damage = 16, firedelay = 3, firedelayMax = 3.5, shotspeed = 2, range = -666, speed = 2},
}

local XanaxStats = {
    TEARS = -1, --yes it is supposed to lower your tears
    SHOTSPEED = -3,
    SPEED = -0.3
}

local DementiaStats = {
    TEARS = 0.35,
    TEARSMAX = 1.05
}

local CharacterIDToCostumes = {
    --all of these will have to replace the actual skin of the char with the 'real' chars skin
    [0] = {nil, "character_001_isaac.png"},    --isaacs costume is no costume
    [1] = {NullItemID.ID_MAGDALENE, "character_002_magdalene.png"},
    [2] = {NullItemID.ID_CAIN, "character_003_cain.png"},
    [3] = {NullItemID.ID_JUDAS, "character_004_judas.png"},
    [4] = {nil, "character_006_bluebaby.png"},   --doesnt exist, need to make skin blue
    [5] = {NullItemID.ID_EVE, "character_005_eve.png"},
    [6] = {NullItemID.ID_SAMSON, "character_007_samson.png"},
    [7] = {NullItemID.ID_AZAZEL, "character_008_azazel.png"},
    [8] = {NullItemID.ID_LAZARUS, "character_009_lazarus.png"},
    [9] = {NullItemID.ID_EDEN, "character_009_eden.png"},
    [10] = {NullItemID.ID_LOST_CURSE, "character_012_thelost.png"},
    [11] = {NullItemID.ID_LAZARUS2, "character_010_lazarus2.png"},
    [12] = {nil, "character_013_blackjudas.png"},   --doesnt exist, need to make skin shadow, needs to use judas shadow file
    [13] = {NullItemID.ID_LILITH, "character_014_lilith.png"},  --need to make skin black
    [14] = {NullItemID.ID_KEEPER, "character_015_keeper.png"},  --need to make skin grey
    [15] = {NullItemID.ID_APOLLYON, "character_016_apollyon.png"},--need to make skin grey
    [16] = {NullItemID.ID_FORGOTTEN, "character_017_theforgotten.png"}, --technically this wont be used so I dont need to be concerend, need to make skin grey
    [17] = {NullItemID.ID_SPIRIT_SHACKLES_SOUL, "character_018_thesoul.png"},  --need to do 'player:SetColor(Color(1.5,1.7,2.0,1.0,0.05,0.11,0.2), -1, 1, false, false)' afterwards to char and chain to give it the ghostly effect
    [18] = {NullItemID.ID_BETHANY, "character_001x_bethany.png"},
    [19] = {NullItemID.ID_JACOB, "character_002x_jacob.png"}, --unneeded
    [20] = {NullItemID.ID_ESAU, "character_003x_esau.png"},  --unneeded
    [21] = {NullItemID.ID_ISAAC_B, "character_001b_isaac.png"},
    [22] = {NullItemID.ID_MAGDALENE_B, "character_002b_magdalene.png"},
    [23] = {NullItemID.ID_CAIN_B, "character_003b_cain.png"},
    [24] = {NullItemID.ID_JUDAS_B, "character_004b_judas.png"},   --need to make skin shadow
    [25] = {NullItemID.ID_BLUEBABY_B, "character_005b_bluebaby.png"},    --need to make skin blue
    [26] = {NullItemID.ID_EVE_B, "character_006b_eve.png"},
    [27] = {NullItemID.ID_SAMSON_B, "character_007b_samson.png"},
    [28] = {NullItemID.ID_AZAZEL_B, "character_008b_azazel.png"}, --need to make skin black, though I think his costume already does that
    [29] = {NullItemID.ID_LAZARUS_B, "character_009b_lazarus.png"},--unneeded
    [30] = {NullItemID.ID_EDEN_B, "character_009_eden.png"},
    [31] = {NullItemID.ID_LOST_B, "character_012b_thelost.png"},  --need to make skin grey
    [32] = {NullItemID.ID_LILITH_B, "character_014b_lilith.png"},  --need to make skin black
    [33] = {NullItemID.ID_KEEPER_B, "character_015b_keeper.png"},--need to make skin grey
    [34] = {NullItemID.ID_APOLLYON_B,"character_016b_apollyon.png"},--need to make skin grey
    [35] = {NullItemID.ID_FORGOTTEN_B, "character_016b_theforgotten.png"},--need to make skin grey
    [36] = {NullItemID.ID_BETHANY_B, "character_018b_bethany.png"},
    [37] = {NullItemID.ID_JACOB_B, "character_019b_jacob.png"},
    [38] = {NullItemID.ID_LAZARUS_B, "character_009b_lazarus2.png"},
    [39] = {NullItemID.ID_JACOBS_CURSE, "character_019b_jacob2.png"},
    [40] = {NullItemID.ID_SOUL_B, "character_017b_thesoul.png"} --need to do 'player:SetColor(Color(1.5,1.7,2.0,1.0,0.05,0.11,0.2), -1, 1, false, false)' afterwards to char to give it the ghostly effect
}

local BloodlustedEnemies = {}

-- Per-heart XY offsets. The first heart has this offset not applied, the second heart has the X offset applied once, etc...
local hudhealthhoroffset = 12
local hudhealthveroffset = 10

-- Load sprites for UI
local petrifiedHeartSprite = Sprite()
petrifiedHeartSprite:Load("gfx/ui/petrifiedheart_sprite.anm2", true)

Mod.DataTable = {}
local playerCustomHealth = {}
local playerId = 0
local trueStageTime = 0
local stopFireSound = false

local Curses = { --each curse uses 1 << (curseid - 1)
    CURSE_BROKEN = 1 << (Isaac.GetCurseIdByName("Curse of the Broken!") - 1),
    CURSE_CAPRICOUS = 1 << (Isaac.GetCurseIdByName("Curse of the Capricous!") - 1)
    --[[,
    CURSE_Dauntless = 1 << (Isaac.GetCurseIdByName("Curse of the Dauntless!") - 1),
    CURSE_HOARDER = 1 << (Isaac.GetCurseIdByName("Curse of the Hoarder!") - 1),
    CURSE_DECIEVER = 1 << (Isaac.GetCurseIdByName("Curse of the Deciever!") - 1),
    CURSE_SOILED = 1 << (Isaac.GetCurseIdByName("Curse of the Soiled!") - 1),
    CURSE_CURDLED = 1 << (Isaac.GetCurseIdByName("Curse of the Curdled!") - 1),
    CURSE_SAVAGE = 1 << (Isaac.GetCurseIdByName("Curse of the Savage!") - 1),
    CURSE_BENIGHTED = 1 << (Isaac.GetCurseIdByName("Curse of the Benighted!") - 1),
    CURSE_ENIGMA = 1 << (Isaac.GetCurseIdByName("Curse of the Enigma!") - 1),
    CURSE_BALEFUL = 1 << (Isaac.GetCurseIdByName("Curse of the Baleful!") - 1),
    CURSE_HARLOT = 1 << (Isaac.GetCurseIdByName("Curse of the Harlot!") - 1),
    CURSE_MISER = 1 << (Isaac.GetCurseIdByName("Curse of the Miser!") - 1),
    CURSE_EMPTY = 1 << (Isaac.GetCurseIdByName("Curse of the Empty!") - 1),
    CURSE_FETTERED = 1 << (Isaac.GetCurseIdByName("Curse of the Fettered!") - 1),
    CURSE_ZEALOT = 1 << (Isaac.GetCurseIdByName("Curse of the Zealot!") - 1),
    CURSE_DESERTER = 1 << (Isaac.GetCurseIdByName("Curse of the Deserter!") - 1),
    CURSE_WISHFUL = 1 << (Isaac.GetCurseIdByName("Curse of the Wishful!") - 1),
    CURSE_FAMISHED = 1 << (Isaac.GetCurseIdByName("Curse of the Famished!") - 1),
    CURSE_UNSTABLE = 1 << (Isaac.GetCurseIdByName("Curse of the Unstable!") - 1),
    CURSE_INDOLENT = 1 << (Isaac.GetCurseIdByName("Curse of the Indolent!") - 1),
    CURSE_CURSED = 1 << (Isaac.GetCurseIdByName("Curse of the Cursed!") - 1),
    CURSE_PRIDE = 1 << (Isaac.GetCurseIdByName("The Curse of Pride?") - 1)
    ]]
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
    CLOTTING_AGENT = Isaac.GetPillEffectByName("Clotting Agent"),
	PHANTOM_PAINS = Isaac.GetPillEffectByName("Phantom Pains"),
    SEEING_RED_GOOD = Isaac.GetPillEffectByName("I'm Seeing Red!"),
    SEEING_RED_BAD = Isaac.GetPillEffectByName("I'm Seeing Red?"),
    THC = Isaac.GetPillEffectByName("THC"),
    JESUS_PILLS = Isaac.GetPillEffectByName("Jesus Pills"),
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
    DUKE_PHEROMONES = Isaac.GetPillEffectByName("Duke Pheromones"),
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

local pauseVars = {
    isPaused = false,
    shouldUnpause = false
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

function Mod:GetEntityIndex(entity)
	if entity then
		if entity.Type == EntityType.ENTITY_PLAYER then
			local player = entity:ToPlayer()
			if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
				player = player:GetOtherTwin()
			end
			local id = 1
			if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B then
				id = 2
			end
			local index = player:GetCollectibleRNG(id):GetSeed()
			if not Mod.DataTable[index] then
				Mod.DataTable[index] = {}
			end
			if not Mod.DataTable[index].ComplianceImmortalHeart then
				Mod.DataTable[index].ComplianceImmortalHeart = 0
			end
			if not Mod.DataTable[index].lastEternalHearts or not Mod.DataTable[index].lastMaxHearts then
				Mod.DataTable[index].lastEternalHearts = 0
				Mod.DataTable[index].lastMaxHearts = 0
			end
			if player:GetPlayerType() == PlayerType.PLAYER_BETHANY and not Mod.DataTable[index].ImmortalCharge then
				Mod.DataTable[index].ImmortalCharge = 0
			end
			return index
		elseif entity.Type == EntityType.ENTITY_FAMILIAR then
			local index = entity:ToFamiliar().InitSeed
			if not Mod.DataTable[index] then
				Mod.DataTable[index] = {}
			end
			return index
		end
	end
	return nil
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

    if type(player:GetData()["CheckDevilPurchase"]) == type(nil) then
        player:GetData()["CheckDevilPurchase"] = 0
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Mod.PostPlayerInit)

function Mod:PostGameStarted(isContinued)
    if not isContinued then
        trueStageTime = 0
        playerCustomHealth = {}
        playerCustomHealth[0] = {}
        --for player_index, player in pairs(getAllPlayers()) do
        --    playerCustomHealth[player_index] = {}
        --end
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Mod.PostGameStarted)

function Curses:onEval(CurseFlags)
    --return CurseFlags | Curses.CURSE_BROKEN
    --give the curses
    
    local level = Game:GetLevel()

    if level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0 then
        
        Mod.DataTable.PreviousStageWasLabyrinth = true--Mod.CurseOfTheBroken()
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL , Curses.onEval)

local function ShowText()
    --Isaac.RenderText("Frame count: "..Game:GetRoom():GetFrameCount(), 70, 50, 1 ,1 ,1 ,1 )
    local level = Game:GetLevel()
    local player = Game:GetPlayer(0)
    local index = Mod:GetEntityIndex(player)
    if level:GetCurses() & Curses.CURSE_BROKEN > 0 then
        
    end
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if(entity.Type == EntityType.ENTITY_DARK_ESAU) then
            Isaac.RenderText("State: " .. (tostring(entity:ToNPC().State)), 70, 50, 1 ,1 ,1 ,1 )
        end
    end

    Isaac.RenderText(player.MaxFireDelay, 70, 50, 1 ,1 ,1 ,1 )
    
    --[[ --lua command to use ingame to get current effects
    lua for i, entity in ipairs(Isaac.GetRoomEntities()) do if(entity.Type == 7) then print(entity.Type, entity.Variant, entity.SubType) print(entity:ToLaser().TearFlags) end end
    
    print(entity:GetColor().R, entity:GetColor().G, entity:GetColor().B, entity:GetColor().A, entity:GetColor().RO, entity:GetColor().GO, entity:GetColor().BO)
    
    lua local room = Game():GetRoom() local roomEntities = room:GetEntities() for i = 0, #roomEntities - 1 do local entity = roomEntities:Get(i) print(entity.Type, entity.Variant, entity.SubType) end
    local wep = Game():GetPlayer(0):GetActiveWeaponEntity() print(wep.Parent.Type)
    ]]
    if(Mod.DataTable[index].ItemsInOrder ~= nil and Mod.DataTable[index].ItemsInOrder[1] ~= nil) then
        --print("hit")
        local itemID = Mod.DataTable[index].ItemsInOrder[1][1]
        local poolType = tostring(Mod.DataTable[index].ItemsInOrder[1][2])
        local quality = tostring(Mod.DataTable[index].ItemsInOrder[1][3])
        Isaac.RenderText(itemID .. " " .. poolType .. " " .. quality, 70, 70, 1 ,1 ,1 ,1 )
    end

    local sprite = player:GetSprite()
    
    --Isaac.GetPlayer().QueuedItem.Item

    --Y6L9 EHEK <-- seed with red monstro on basement 1
    
    Isaac.RenderText(tostring(Game:GetLevel():GetAngelRoomChance()), 70, 90, 1 ,1 ,1 ,1)
    --Game:GetPlayer(0):GetItemState() <-- used for items while youre holding them up but before youve used them (like mom's bracelet and black hole)
    if(Isaac.GetPlayer().QueuedItem.Item ~= nil) then
        Isaac.RenderText(tostring(Game:GetPlayer(0):GetItemState()), 70, 110, 1 ,1 ,1 ,1 )
    end
    --Isaac.RenderText(tostring(Game:GetLevel():GetStateFlag(LevelStateFlag.STATE_SOL_EFFECT)), 70, 110, 1 ,1 ,1 ,1 )
    if(Mod.DataTable.LastNaturalDevilRoom ~= nil) then
        Isaac.RenderText(tostring(Mod.DataTable.LastNaturalDevilRoom), 70, 130, 1 ,1 ,1 ,1 )
    end

    if(not player:IsItemQueueEmpty()) then
        Isaac.RenderText(player.QueuedItem.Item.ID, 70, 145, 1 ,1 ,1 ,1 )
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_RENDER , ShowText)

function Mod:CurseOfTheBroken()
    --TODO: probably have it be a one time reroll with a chance instead turn the enemy into a dice enemy
    --what should happen is there is a timer above the items when you enter, signalling that they will be rerolled and possibly dissapear
    --this timer swould be used in other places so definetly do that, it will be useful later

    --I dont think its possible to spawn an empty pedistal, try spawning a null item (id 0), thats the last thing i can think of (also try -1)
    --also use the command to see and hopefully it isnt one of those dead isaacs effects
    --with that dead isaac effect see if giving the player id as the thing works, it may be something like that

    -- the dice enemies is a good idea but it should be a diff situation, and they should just be possibly random enemies in dice room layouts
    --dice enemies move slowly and do their effect when hitting isaac,
    --(idea is they should be near impossible to be accidentally hit, but if you want to then you can roll the dice)
    local room = Game:GetRoom()
    local entities = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
    for key, entity in pairs(entities) do
        --Isaac.RenderText(entity:ToPickup().State, 60, 60, 1 ,1 ,1 ,1 )
        if((entity.FrameCount > 50) 
        and (entity.FrameCount%60 == 0) 
        --does the rooms framecount not work?
        and (entity.SubType ~= 0) 
        and not (entity:ToPickup().Touched)) then
            --TODO: change poof to the right one, i have it in rosetinted goggles
            Game:SpawnParticles(entity.Position+Vector(0,0), EffectVariant.POOF02, 1, 0)
            
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

function Mod:CurseOfTheCapricous()
    local room = Game:GetRoom()
    --when in boss room trigger the glitched item, try to replace rock sprites with others
    --when boss room is entered do dataminer effect
    --have super secret room always be a version/variant that contains a confessional
end

--TODO: curse of the soiled should turn pickups into poop pickups at random,
--if the player isnt tbb then give them random stuff when they pick up the poo, large poos function as sacks

function Mod.GetPlayerMaxHealthWithBrokenHearts(player)
    return (Mod.GetPlayerMaxHealthContainers(player) + player:GetBrokenHearts())
end

function Mod.GetPlayerMaxHealthContainers(player)
    return (math.ceil(player:GetEffectiveMaxHearts()/2) + math.ceil(player:GetSoulHearts()/2))
end

function Mod.GetPlayerCurrentHealth(player)
    return (player:GetHearts() + player:GetSoulHearts())-- + player:GetBoneHearts()
end

function Mod:OnPlayerDamage(target, DamageAmount, DamageFlags, DamageSource)
    -- No damage (holy mantle), or the damage is inflicted by us? We don't need to handle this.

    local player = target:ToPlayer()

	if player:GetPlayerType() == PlayerType.PLAYER_THESOUL then return nil end
    if DamageAmount <= 0 or (DamageFlags & DamageFlag.DAMAGE_CLONES == DamageFlag.DAMAGE_CLONES) then return nil end

    -- This function should return true if the original damage should be kept.
    -- Returning false allows us to ignore the "original" damage and re-apply it ourselves, our way.
    -- However, this should only happen if the rightmost heart is an immortal heart.
    local shouldKeepOriginalDamage = true

    -- Round up to the nearest whole heart
    local rightmostHeartIndex = math.ceil(Mod.GetPlayerCurrentHealth(player) * 0.5)
    --TODO: fix peftiried hearts being priortized to be destroyed over an enpty bone heart infront of it

    local index = Mod:GetEntityIndex(player)

    if Mod.DataTable[index].PetrifiedHeartSlots ~= nil and Mod.DataTable[index].PetrifiedHeartSlots[rightmostHeartIndex] then

        -- Ignore the original damage
        shouldKeepOriginalDamage = false

        Mod.DataTable[index].PetrifiedHeartSlots[rightmostHeartIndex] = false

        player:TakeDamage(1, DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_CLONES, DamageSource, 5000)

        SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1)

        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end

    -- NOTE: Mod API has yet another bug in it!
    -- Returning anything except nil will break other Mods' damage triggers.
    -- This means that we should return nil if we should keep the original damage, or return false otherwise.
    if not shouldKeepOriginalDamage then
        return false
    end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Mod.OnPlayerDamage, EntityType.ENTITY_PLAYER)

function Mod:PostGameUpdate()

    local level = Game:GetLevel()

    if level:GetCurses() & Curses.CURSE_BROKEN > 0 then
        --Mod.CurseOfTheBroken()
    end
    if(Mod.DataTable.CheckForDeal~= nil and Mod.DataTable.CheckForDeal > 0) then
        if(Mod:CheckForDealDoor()) then
            Mod.DataTable.LastNaturalDevilRoom = level:GetStage()
        end
        Mod.DataTable.CheckForDeal = 0
    end

    for playerNum = 1, Game:GetNumPlayers() do
        local player = Game:GetPlayer(playerNum - 1)

        local index = Mod:GetEntityIndex(player)
        --^ this index thing may need special j+e checks because it might call it twice for them
        if(not player:IsItemQueueEmpty()) then
            local itemInQueue = player.QueuedItem.Item.ID
            if type(player:GetData()["CheckDevilPurchase"]) ~= type(nil) 
            and (player:GetData()["CheckDevilPurchase"] == itemInQueue) then
                if(Mod.DataTable[index].DevilDealsTaken == nil) then
                    Mod.DataTable[index].DevilDealsTaken = 1
                else
                    Mod.DataTable[index].DevilDealsTaken = Mod.DataTable[index].DevilDealsTaken + 1
                end
                player:GetData()["CheckDevilPurchase"] = 0

            end
            --this doesnt count if you pick up the same item twice in a row right now
            local itemPool = Game:GetItemPool():GetLastPool()
            --print(tostring(itemPool))
            local quality = Isaac.GetItemConfig():GetCollectible(itemInQueue).Quality
            --print(tostring(quality))
            local newEntry = {itemInQueue, itemPool, quality}
            --print(tostring(itemInQueue))
            if(Mod.DataTable[index].ItemsInOrder == nil or #(Mod.DataTable[index].ItemsInOrder) < 1) then
                Mod.DataTable[index].ItemsInOrder =  {newEntry}
            elseif(itemInQueue ~= Mod.DataTable[index].ItemsInOrder[#(Mod.DataTable[index].ItemsInOrder)][1]) then
                table.insert(Mod.DataTable[index].ItemsInOrder, newEntry)
            end
        end

        if(Mod.DataTable[index].Methamphetamines ~= nil and Mod.DataTable[index].Methamphetamines[1] > 0) then
            Mod.DataTable[index].Methamphetamines[1] = Mod.DataTable[index].Methamphetamines[1] - 1
            if(Mod.DataTable[index].Methamphetamines[1] == 0 ) then
                Mod.DataTable[index].Methamphetamines = {0,0}
                Mod:MethCacheFlags(player)
            end
        end
    
        if(Mod.DataTable[index].Xanax ~= nil and Mod.DataTable[index].Xanax > 0) then
            Mod.DataTable[index].Xanax = Mod.DataTable[index].Xanax - 1
            --should probs move this to a specific section in this about time being frozen
            Game.TimeCounter = Game.TimeCounter - 1
            Game.BlueWombParTime = Game.BlueWombParTime + 1
            Game.BossRushParTime = Game.BossRushParTime + 1
            if(Mod.DataTable[index].Xanax == 0 ) then
                Mod:XanaxCacheFlags(player)
            end
        end

        if(Mod.DataTable[index].THC ~= nil and Mod.DataTable[index].THC > 0) then
            if((((Mod.DataTable[index].THC-51)+ 51) % 50) == 0) then
                player:SpawnMawOfVoid(75)
                player:AddVelocity(player:GetAimDirection():Rotated(180):Normalized()*Vector(3,3))
            end
            if((Mod.DataTable[index].THC-51) % 50 == 6) then
            --if((Mod.DataTable[index].THC-51) % 50 == 20) then --eye of the occult timing
            --if((Mod.DataTable[index].THC-51) % 50 == 6) then --normal brim timing
                player:AddControlsCooldown(15)
            end
            if((Mod.DataTable[index].THC % 450) == 150 )then --200) or (Mod.DataTable[index].THC == 750) then
                player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, true)
            end
            if(Mod.DataTable[index].THC == 434) then
                player:UseActiveItem(CollectibleType.COLLECTIBLE_MEGA_BLAST, false, false, true, true, -1)
                player:AddVelocity(player:GetAimDirection():Rotated(180):Normalized()*Vector(4,4))
            end
            local coefficient = 1.0/(Mod.DataTable[index].THC+200)*250
            player:AddVelocity(player:GetAimDirection():Rotated(180):Normalized()*Vector(coefficient,coefficient))
            Mod.DataTable[index].THC = Mod.DataTable[index].THC - 1
            if(Mod.DataTable[index].THC == 1) then
                Mod:RemoveTHCItems(player)
            end
            Mod:THCCacheFlags(player)
        end

        if(Mod.DataTable[index].ClottingAgentTimer ~= nil and Mod.DataTable[index].ClottingAgentTimer[1] > 0) then
            Mod.DataTable[index].ClottingAgentTimer[1] = Mod.DataTable[index].ClottingAgentTimer[1] - 1
            local flag = 0
            if(Mod.DataTable[index].ClottingAgentTimer[1] % 20 == 0) then
                flag = 1
                if(Mod.DataTable[index].ClottingAgentTimer[1] <= 0) then
                    flag = 2
                end
            end
            
            for i, entity in ipairs(Isaac.GetRoomEntities()) do
                if entity:IsActiveEnemy(false) and not entity:IsBoss() then
                    if(flag == 1) then
                        entity:SetSize(entity.Size *.80, entity.SizeMulti *.8, 1)
                    end
                    if(flag == 2) then
                        entity:Remove()
                        if((Random()%(Mod.DataTable[index].ClottingAgentTimer[2] and 2 or 4)) == 0) then
                            Mod:SpawnClot(player, 7, entity.Position)
                        else
                            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, entity.Position, Vector(0,0), nil)
                        end
                    end
                    entity.SpriteScale = entity.SizeMulti
                    if(entity:ToNPC().ChampionColor == ChampionColor.DARK_RED) then
                        
                        --entity:shrink()
                    end
                end
            end
        end

        if(Mod.DataTable.BlackCreepGrowth ~= nil and Mod.DataTable.BlackCreepGrowth > 0) then
            Mod.DataTable.BlackCreepGrowth = Mod.DataTable.BlackCreepGrowth - 1
            if(Mod.DataTable.BlackCreepGrowth % 98 == 0) then
                print(Mod.DataTable.BlackCreepGrowth)
                for i, entity in ipairs(Isaac.GetRoomEntities()) do
                    if(entity.Type == 1000 and (entity.Variant == EffectVariant.CREEP_RED)) then
                        print(entity:GetSprite():GetAnimation())
                        entity:GetSprite():SetAnimation("BiggestBlood02", false)
                        entity.Size = 100
                        --entity.SpriteScale = entity.SpriteScale * 1.02
                        --entity.SpriteScale = entity.SpriteScale + Vector(.03,.03)
                        entity:ToEffect().Timeout = entity:ToEffect().Timeout + 2
                        --print(entity:ToEffect().Scale)
                        --entity:Update()
                        --[[
                        
                        print(entity:ToEffect().MinRadius)
                        
                        --creep:GetSprite():Load("1000.026_creep (black).anm2", true)
                        --creep:GetSprite():Play("BiggestBlood02", false)
                        --creep:GetSprite():SetAnimation("BiggestBlood02", true)
                        --creep:GetSprite():PlayOverlay("BiggestBlood02", true)
                        ]]
                    end
                end
            end
        end

        if(Mod.DataTable[index].SpiritSalts ~= nil and Mod.DataTable[index].SpiritSalts[1] > 0) then
            if(Mod.DataTable[index].SpiritSalts[1] % (20/(Mod.DataTable[index].SpiritSalts[2] and 2 or 1)) == 0) then
                --Isaac.Spawn(EntityType.ENTITY_EFFECT, 189, 1, player.Position, Vector(0,0), nil)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, 189, 1, player.Position + Vector(0,600):Rotated(math.random()*360), Vector(0,0), nil)
            end
            Mod.DataTable[index].SpiritSalts[1] = Mod.DataTable[index].SpiritSalts[1] - 1
        end

        if(Mod.DataTable[index].DukePheromones ~= nil and Mod.DataTable[index].DukePheromones[1] > 0) then
            Mod.DataTable[index].DukePheromones[1] = Mod.DataTable[index].DukePheromones[1] - 1
            if(Mod.DataTable[index].DukePheromones[1] % 15 == 0) then
                --local spawn = Isaac.Spawn(EntityType.ENTITY_BEAST, 11, 0, player.Position + Vector(0,300):Rotated(math.random()*360), Vector(0,0), nil)
                --spawn:ToNPC():MakeChampion(spawn.InitSeed, ChampionColor.PULSE_GREEN, false)
                --spawn:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
                --spawn.HitPoints = 1
            end
            if(Mod.DataTable[index].DukePheromones[1] == 100) then
                for i, entity in ipairs(Isaac.GetRoomEntities()) do
                    if entity.Type == EntityType.ENTITY_PUSTULE then
                        entity:ToNPC():MakeChampion(entity.InitSeed, ChampionColor.SIZE_PULSE, false)
                    end
                end
            elseif (Mod.DataTable[index].DukePheromones[1] == 3) then
                for i, entity in ipairs(Isaac.GetRoomEntities()) do
                    if entity.Type == EntityType.ENTITY_PUSTULE then
                        local currentSpawn
                        
                        currentSpawn = Isaac.Spawn(EntityType.ENTITY_SUCKER, 6, 0, entity.Position, Vector(0,0), nil)
                        currentSpawn:ToNPC():MakeChampion(entity.InitSeed, ChampionColor.SIZE_PULSE, true)
                        currentSpawn = Isaac.Spawn(EntityType.ENTITY_SUCKER, 6, 0, entity.Position, Vector(0,0), nil)
                        currentSpawn:ToNPC():MakeChampion(entity.InitSeed, ChampionColor.SIZE_PULSE, true)

                        currentSpawn = Isaac.Spawn(EntityType.ENTITY_MOTER, 0, 0, entity.Position, Vector(0,0), nil)
                        currentSpawn:ToNPC():MakeChampion(entity.InitSeed, ChampionColor.SIZE_PULSE, true)
                    
                        currentSpawn = Isaac.Spawn(EntityType.ENTITY_POOTER, 0, 0, entity.Position, Vector(0,0), nil)
                        currentSpawn:ToNPC():MakeChampion(entity.InitSeed, ChampionColor.SIZE_PULSE, true)
                        
                        currentSpawn = Isaac.Spawn(EntityType.ENTITY_FLY, 0, 0, entity.Position, Vector(0,0), nil)
                        currentSpawn:ToNPC():MakeChampion(entity.InitSeed, ChampionColor.SIZE_PULSE, true)
                        currentSpawn = Isaac.Spawn(EntityType.ENTITY_FLY, 0, 0, entity.Position, Vector(0,0), nil)
                        currentSpawn:ToNPC():MakeChampion(entity.InitSeed, ChampionColor.SIZE_PULSE, true)
                        
                        if(Mod.DataTable[index].DukePheromones[2]) then
                            currentSpawn = Isaac.Spawn(EntityType.ENTITY_SUCKER, 4, 0, entity.Position, Vector(0,0), nil)
                        end
                    end
                end
            elseif (Mod.DataTable[index].DukePheromones[1] == 1) then
                for i, entity in ipairs(Isaac.GetRoomEntities()) do
                    if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == 15 then
                        entity:Remove()
                    end
                end
            end
        end

        if(Mod.DataTable[index].Bipolar ~= nil and Mod.DataTable[index].Bipolar[1] > 0) then
            Mod.DataTable[index].Bipolar[1] = Mod.DataTable[index].Bipolar[1] - 1
            if(Mod.DataTable[index].Bipolar[1] == 0 ) then
                Mod:BipolarChangePlayerBack(player)
            end
        end

        if(Mod.DataTable[index].RedScreaming ~= nil and Mod.DataTable[index].RedScreaming > 0) then
            Mod.DataTable[index].RedScreaming = Mod.DataTable[index].RedScreaming - 1

            if(Mod.DataTable[index].RedScreaming % 5 == 0) then
                player:UseActiveItem(CollectibleType.COLLECTIBLE_LARYNX, true, false, true, false, -1)
                --player:UseActiveItem(CollectibleType.COLLECTIBLE_LARYNX, UseFlag.USE_CUSTOMVARDATA, -1)
                --yeah if someone can figure out how to do a fully charged larynx or even just like a 2 charge that would be great
                if(Mod.DataTable[index].RedScreaming % 45 == 0) then
                    SFXManager():Play(SoundEffect.SOUND_LARYNX_SCREAM_HI,1.5,2,false,1)
                    for i, entity in ipairs(Isaac.GetRoomEntities()) do
                        if entity:IsActiveEnemy(false) then
                            entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
                            if(not entity:IsBoss() and (entity.HitPoints < entity.MaxHitPoints*.5)) then
                                entity:Kill()
                            end
                        end
                    end
                end 
            end
        end

        --Isaac.Spawn(8, 1, 0, player.Position+Vector(0,20), Vector(0,0), nil).Parent = player

        --[[
        if(Game:GetFrameCount() % 1 == 0 )then
            local entity = Isaac.Spawn(1000, 99, 1, player.Position+Vector(0,-10), Vector(0,0), nil)
            entity.Velocity = Vector(0, -math.random(3,8))
            --entity.Velocity = Vector(math.random(4,13), 0)
            entity:SetColor(Color(0.76, 0.0, 0.0, 1, 0.0, 0.0, 0.0), -1, 1, false, false)
            entity:GetSprite():SetLastFrame()
            entity.SpriteScale = entity.SpriteScale*2
            --entity:GetSprite():Update()
        end
        ]]
        trueStageTime = trueStageTime + 1
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE , Mod.PostGameUpdate)


Mod:AddCallback(ModCallbacks.MC_POST_UPDATE , Mod.PostGameUpdate)

function Mod:getTearBoostRawNumber(player, tearBoost, currTears, maxTears, multi, abnormalBoost) 
    local tearRateNoMultipliers = (currTears+1.0)/multi
    local tearRateIngameNoMulti = 30/(tearRateNoMultipliers)
    local tearRateAbnormalBoostsStripped = tearRateIngameNoMulti - abnormalBoost --<< below 5 of this means its below max tears base
    if(tearRateAbnormalBoostsStripped > maxTears) then
        return maxTears
    end
    local desiredTearRate = tearRateAbnormalBoostsStripped + tearBoost
    if(desiredTearRate > maxTears) then
        desiredTearRate = maxTears
    end
    local newMaxTears = math.min(maxTears, desiredTearRate)
    local desiredTearRateAbnormalBoosts = desiredTearRate + abnormalBoost
    local desiredTearRateOutgameNoMulti = (30/desiredTearRateAbnormalBoosts)
    local desiredTearRateOutgameMulti = desiredTearRateOutgameNoMulti*multi
    local desiredMaxTearRate = desiredTearRateOutgameMulti-1
    player.MaxFireDelay = player.MaxFireDelay + (desiredMaxTearRate - currTears)
    return newMaxTears
end

function Mod:getTearBoostPercentage(player, tearBoost, currTears, maxTears, multi, abnormalBoost) 
    local tearRateNoMultipliers = (currTears+1.0)/multi
    local tearRateIngameNoMulti = 30/(tearRateNoMultipliers)
    local tearRateAbnormalBoostsStripped = tearRateIngameNoMulti - abnormalBoost --<< below 5 of this means its below max tears base
    if(tearRateAbnormalBoostsStripped > maxTears) then
        return maxTears
    end
    local desiredTearRate = tearRateAbnormalBoostsStripped - (tearRateAbnormalBoostsStripped * tearBoost)
    if(desiredTearRate > maxTears) then
        desiredTearRate = maxTears
    end
    local newMaxTears = math.min(maxTears, desiredTearRate)
    local desiredTearRateAbnormalBoosts = desiredTearRate + abnormalBoost
    local desiredTearRateOutgameNoMulti = (30/desiredTearRateAbnormalBoosts)
    local desiredTearRateOutgameMulti = desiredTearRateOutgameNoMulti*multi
    local desiredMaxTearRate = desiredTearRateOutgameMulti-1
    player.MaxFireDelay = player.MaxFireDelay + (desiredMaxTearRate - currTears)
    return newMaxTears
end

function Mod:ChangeTears(player, tearBoost, percentage, maxTears, multi, abnormalBoost)
    --TODO: max tears actually should get mutiplied by the multplier, or else you are capped at 120/multiplier
    if(percentage) then
        return Mod:getTearBoostPercentage(player, tearBoost, player.MaxFireDelay, maxTears, multi, abnormalBoost)
    else
        return Mod:getTearBoostRawNumber(player, tearBoost, player.MaxFireDelay, maxTears, multi, abnormalBoost)
    end
end

function Mod:GetMultiplier(player)

end

function Mod:GetAbnormalBoosts(player)

end

function Mod:UnfuckHaemolacria(player)

end

function Mod:CacheUpdate(player, flags)

    --player:AddSoulHearts(1) --a test to easily see when a cache update is actually called
    local index = Mod:GetEntityIndex(player)
    --Game.GetPlayer(0).FireDelay
    local petrifiedHeartsCount = 0
    local methMultiplier = 0
    local onTHC = 0
    local onXanax = false

    if Mod.DataTable[index].PetrifiedHeartSlots ~= nil then
        for i, petrified in pairs(Mod.DataTable[index].PetrifiedHeartSlots) do
            if petrified then
                petrifiedHeartsCount = petrifiedHeartsCount + 1
            end
        end
    end

    if(Mod.DataTable[index].Methamphetamines ~= nil) then
        methMultiplier = Mod.DataTable[index].Methamphetamines[2]
    else
        methMultiplier = 0
    end

    if(Mod.DataTable[index].Xanax ~= nil and Mod.DataTable[index].Xanax > 0) then
        onXanax = true
    end

    if(Mod.DataTable[index].THC ~= nil and Mod.DataTable[index].THC > 0) then
        onTHC = Mod.DataTable[index].THC
    else
        onTHC = 0
    end
    


    if(flags == CacheFlag.CACHE_DAMAGE) then
        player.Damage = player.Damage + (petrifiedHeartsCount * PetrifiedHeartStats.DAMAGE)
        if(methMultiplier ~= 0) then
            if(methMultiplier > 10) then
                player.Damage = player.Damage + MethStatsTable[10].damage + ((methMultiplier-10)*5)
            else
                player.Damage = player.Damage + MethStatsTable[methMultiplier].damage
            end
        end

    elseif(flags == CacheFlag.CACHE_FIREDELAY) then
        --tears number ingame = (30.0/(maxfiredelay+1))

        --[[fuuuuuuuck
        easy raw numbers, if you got it you got it:
            antigrav: +1 (unless char has brimstone)
            cancer: +1 per trinket multi
            tractor beam: +1
            eyedrops: +1
            guillotine: +.5
            crickets body: +.5
            capricorn: +.5
            pices: +.5
            mom's perfume: +.5
        medium raw numbers, minimal coding needed
            it hurts... variable amount per damage taken in room
                1st hit: +1.2
                all further hits: additonal +.4 each hit (literally up to 120 tears lol)
            milk: +1 when damaged in room
            dark prices crown: +2 when active
            brittle bones: +.4 everytime you break a bone heart (im assuming you can go to 120)
            wavy cap my beloved:
                +.75 on each use in current room
                when leaving the room you used it in it divides the bonus gained in said room by 2.5
                loose one stack on room clear
            pashal candle: +.4 per room clear when you dont take damage up to +2

        hard raw numbers, will take more work track correctly and it will probably need some degree of jank
            luna: +1 first time, +.5 the other times
            consolation prize: +.5 (i dont know if you can tell what its effecting, just have it be a +.5)
                (theoretically you can see when the player touches it and then later check if their tears are different, then log that as a plus .5)
            purity: +2 when boosted, dont know how to catch that
                (for initial pickup could be the same as consolation prize where you just check afterwards)
                (for after room clears you can just set a flag and hopefully it would be easy to tell)
            deaths list (im not even sure if it can bring you above 5)
                (should be same as checking purity after room clear)
                (will have to account for pascal candle and other after room clear stuff)
            epiphora: +(5/3) per second shooting in only one direction
                (this may be doable by traking the keys of the player)
            dataminer/metronome
                (after use it has a chance to raise or lower tears by .5, can (hopefully) just check if that changed afterwards)
            void
                (same in theory as dataminer)
        oh jeez (or if they are raw numbers)
            lemetegon wisps? (this all depends on if the methods to catch the items work seamlessly with lemegeton wisps)
            t.blue baby diharrea
                (theoretically same as hallowed if you have instances of each poo puddle, otherwise no idea)
            d8/d100/dinfinity/metronome/6 pin dice rooms/cracked dice?(can cracked dice trigger d8?)/teden
                (d8 changes multipliers, so if i can get the stats before and after I can math out the difference)
            cracked crown 
                (base tears its no change)
                (1 sad onion its 1.047)
                (2 sad onions its 1.077)
                (3 sad onions (which caps at 5 tears) its 1.09 multi)
                (mom's box just causes the decimal to double (ie 1.09 > 1.18))
                (with some small rock testing (which turned out the same as above trend wise) it seems to be anywhere from no multi to 1.09)
                (this seems to be agnostic to things that break the cap)
                (theoretically knowing the base chars tears this multiplier is obtainable)
                (or atleast a rough estimate is, and thats good enough for me)
                


            ORDER OF MULTIPLIERS:
            cracked crown
            -------------------------------
            haemolacria: bro fuck this item's math that I had to do

                inner eye/mutant spider/poly are applied before these calculations
                tech 2 and eves mascara apply afterwards

                (ML: monstros lung)

                6 tears base:
                150.5           (b+i+h+ml)              x3, +20, x4.3
                45 :both        (b+i+h)     25  15      x3, +30
                107.500         (b+h+ml)                +20, x4.3
                107.500         (i+h+ml)                x3, +10, x4.3
                40 :no ipecac   (b+h)       20          x2, +30
                25 :no brim     (i+h)       5           x3, +10
                64.5 :ML        (h+ml)                  +10, x4.3
                30              (h+dr)                     x2, +20?
                20 :only hae    (h)         0           x2, +10
                15 :only ipe    (i)                     x3
                15 :only brim   (i)                     x3
                21.5    :ml     (ml)                    x4.3
                5  :none        ()                      x1
                6.904 = 1.38*5
                4.8 = .96*5

                5 tears base:
                163.4           (b+i+h+ml)              x3, +20, x4.3
                141.9           (i+h+ml+dr)             x3, +15, x4.3
                48 :both        (b+i+h)     26          x3, +30
                111.800         (b+h+ml)                +20, x4.3
                120.400         (i+h+ml)                x3, +10, x4.3
                42 :no ipecac   (b+h)       20          x2, +30
                28 :no brim     (i+h)       6           x3, +10
                68.8 :ML        (h+ml)                  +10, x4.3
                32              (h+dr)                  x2, +20
                22 :only hae    (h)         0           x2, +10
                18 :only ipe    (i)                     x3
                18 :only brim   (b)                     x3
                25.8    :ml     (ml)                    x4.3
                6  :none        ()                      x1

                2 sad onions:
                175.323         (b+i+h+ml)              x3, +20, x4.3
                50.7728         (b+i+h)                 x3, +30
                115.774         (b+h+ml)                +20, x4.3
                132.323         (i+h+ml)                x3, +10, x4.3
                43.848          (b+h)                   x2, +30
                30.772          (i+h)                   x3, +10 
                72.774 :ML      (h+ml)                  +10, x4.3
                33.848          (h+dr)                     x2, +20?
                23.848          (h)                     x2, +10
                33 :only ipe    (i)                     x3  
                33 :only brim   (b)                     x3
                29.77    :ml    (ml)                    x4.3
                6.924           ()                      x1
                
                base tears:
                227.9           (b+i+h+ml)              x3, +20, x4.3
                63 :both        (b+i+h)                 x3, +30        
                63 :both        (b+i+h+dr)              x3, +30         
                133.300         (b+h+ml)                +20, x4.3
                184.900         (i+h+ml)                x3, +10, x4.3
                52 :no ipecac   (b+h)                   x2, +30
                52 :no ipecac   (b+h+dr)                x2, +30
                43 :no brim     (i+h)                   x3, +10
                53 :no brim     (i+h+dr)                x3, +20
                90.299 :ML      (h+ml)                  +10, x4.3
                90.299 :ML      (h+ml+dr)               +15, x4.3
                42              (h+dr)                  x2, +20
                32 :only hae    (h)         0           x2, +10
                33 :only ipe    (i)                     x3
                33 :only brim   (b)                     x3
                47.3    :ml     (ml)                    x4.3
                11 :none        ()                      x1

                
                inner eye: x1.96
                mutant spider: x2.38 (overrides inner eye)
                polyphemus: x2.38 (overrides inner eye/mutant spider)
                melee (forgotten, spirit sword), epic fetus or moms knife cause no multi and no monstro lung effects 
                    (only +10,+20,+30 with normal, dr fetus and brim respetfully)
                normal hae: x2, +10
                monstro lung: removes initial x2 multi
                ipecac applies a x3 multiplier before additions always
                dr fetus causes the addition to be 20 (15 with monstro lung)
                brimstone causes the addition to be 30 (20 with monstro lung)
                monstro lung: apply x4.3 multi at end
                overrides all of these items
            -------------------------------
            monstros lung:  
                brim: x3 (overridden by dr fetus)
                dr fetus: x2.5 (brim synergy overriden by dr fetus)
                ipecac: x3 (overrides dr fetus multi)(overridden by brim synergy)
                x4.3 (unless you specifically have the brim synergy (ie no dr fetus))

                if dr
                    if ipecac
                        x3
                    else
                        x2.5
                    x4.3
                else
                    if brim or azazel or tazazel
                        x3
                    elseif ipe
                        x3
                        x4.3
            -------------------------------

            if dr fetus 
                x2.5    
            elseif azazel (not tainted)
                x3.75
            elseif brim or ipe or tazazel
                x3
            inner eye: x1.96
            mutant spider: x2.38 (overrides inner eye)
            polyphemus: x2.38 (overrides inner eye/mutant spider)

            the following are applied to hae after it does its calcs
            d8
            forgotten boneclub (both forgottens): x2
            technology 2: x1.5
            teve: x1.5151 (stacks with mascara)
            eve's mascara: x1.5151
            hallowed poo: /2.5 multi when in range, a range check for each shouldnt be hard
            almond: /4 (overrides soy)
            soy: /5.5

        special notes
            odd mushroom (thin) (this doesnt actually break max tear rate its just a big damage down and i wanted to point that out lol)
            kidney stone (can safely ignore this one since its kidney stone)
            libra (uh yeah with libra ive got no fuckin idea, on the bright side though through testing ive realized libra is goated)
                (check items without libra, tears get dont go above cap dont add, otherwise add it)
                (no im not doing hae and libra math)
            tsamson raging/beserk has some whacky shit going on but i can probs safely ignore that
            any char not listed but starts with different tears but all have a natural cap at 5
            tmtrainer (lol. lmao.)
        ]]
        local maxTears = 5
        local multi = 1
        local abnormalBoost = 0
        Mod:ChangeTears(player, (petrifiedHeartsCount*-0.018375), true, (maxTears + PetrifiedHeartStats.TEARSMAX), multi, abnormalBoost)
        if(petrifiedHeartsCount > 0) then
            maxTears = Mod:ChangeTears(player, (petrifiedHeartsCount*-0.018375), true, (maxTears + PetrifiedHeartStats.TEARSMAX), multi, abnormalBoost)
        end
        --player.MaxFireDelay = player.MaxFireDelay + (petrifiedHeartsCount * PetrifiedHeartStats.TEARS)
        if(methMultiplier ~= 0) then
            if(methMultiplier > 10) then
                maxTears = Mod:ChangeTears(player, MethStatsTable[10].firedelay, false, (maxTears + MethStatsTable[10].firedelayMax), multi, abnormalBoost)
            else
                maxTears = Mod:ChangeTears(player, MethStatsTable[methMultiplier].firedelay, false, (maxTears + MethStatsTable[methMultiplier].firedelayMax), multi, abnormalBoost)
            end
        end
        if(onXanax) then
            maxTears = Mod:ChangeTears(player, XanaxStats.TEARS, false, maxTears, multi, abnormalBoost)
        end
        if(Mod.DataTable[index].Dementia ~= nil) then
            maxTears = Mod:ChangeTears(player, (math.min(Mod.DataTable[index].Dementia, 3) * DementiaStats.TEARS), false, (maxTears + (Mod.DataTable[index].Dementia > 3 and 0 or DementiaStats.TEARSMAX)), multi, abnormalBoost)
        end
        if(onTHC > 0) then
            if(onTHC > 450) then onTHC = onTHC - 500 end
            maxTears = Mod:ChangeTears(player, (900 - onTHC)*.13, false, 120, 3, 0)
            --maxTears = Mod:ChangeTears(player, , false, 120, 3, 0)
        end
        --TODO: think about putting this new max rate as playerdata so other mods can easily access it and not have to go through my pain

    elseif(flags == CacheFlag.CACHE_SHOTSPEED) then
        if(methMultiplier ~= 0) then
            if(methMultiplier > 10) then
                player.ShotSpeed = player.ShotSpeed + MethStatsTable[10].shotspeed
            else
                player.ShotSpeed = player.ShotSpeed + MethStatsTable[methMultiplier].shotspeed
            end
        end
        if(onXanax) then
            player.ShotSpeed = player.ShotSpeed + XanaxStats.SHOTSPEED
        end

    elseif(flags == CacheFlag.CACHE_RANGE) then
        if(methMultiplier ~= 0) then
            if(methMultiplier > 10) then
                player.TearRange = player.TearRange + MethStatsTable[10].range
            else
                player.TearRange = player.TearRange + MethStatsTable[methMultiplier].range
            end
        end

    elseif(flags == CacheFlag.CACHE_SPEED) then --the game will not let speed be below .1, so i dont have to worry about that
        player.MoveSpeed = player.MoveSpeed + (petrifiedHeartsCount * PetrifiedHeartStats.SPEED)
        if(Mod.DataTable[index].PetrificationPillsTaken ~= nil) then
            player.MoveSpeed = player.MoveSpeed + (Mod.DataTable[index].PetrificationPillsTaken * PetrifiedHeartStats.SPEED * 2)
        end
        if(methMultiplier ~= 0) then
            if(methMultiplier > 10) then
                player.MoveSpeed = player.MoveSpeed + MethStatsTable[10].speed
            else
                player.MoveSpeed = player.MoveSpeed + MethStatsTable[methMultiplier].speed
            end
        end
        if(onXanax) then
            player.MoveSpeed = player.MoveSpeed + XanaxStats.SPEED
        end
        
    elseif(flags == CacheFlag.CACHE_TEARFLAG) then
        if(methMultiplier > 7) then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_HORN
        end
        if(methMultiplier > 3) then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_EXTRA_GORE
        end

    elseif(flags == CacheFlag.CACHE_LUCK) then
        
    elseif(flags == CacheFlag.CACHE_FAMILIARS) then
        if(Mod.DataTable[index].ExtraVanishingTwins ~= nil) then 
            Mod:CheckFamiliar(player, CollectibleType.COLLECTIBLE_VANISHING_TWIN, Mod.DataTable[index].ExtraVanishingTwins, FamiliarVariant.VANISHING_TWIN, -1)
        end

    elseif(flags == CacheFlag.CACHE_FLYING) then
        if(methMultiplier > 9) then
            player.CanFly = true
            --TODO: add a costume for this flight
        end
    end
    --simply picking an item up doesnt cause a cache evaluation
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE , Mod.CacheUpdate)

function Mod:shouldDeHook()
	local reqs = {
	  not Game:GetHUD():IsVisible(),
	  Game:GetSeeds():HasSeedEffect(SeedEffect.SEED_NO_HUD),
	  Game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_THE_UNKNOWN ~= 0,
	}
	return reqs[1] or reqs[2] or reqs[3]
end

local function playersHeartPos(i,hearts,hpOffset,isForgotten)
    local returnPosition = Options.HUDOffset * Vector(20, 12)
	--if i == 1 then return Options.HUDOffset * Vector(20, 12) + Vector(hearts*6+36+hpOffset, 12) + Vector(0,10) * isForgotten end
    --((Options.HUDOffset * Vector(20, 12)) + Vector(hearts*6+36+hpOffset, 12) + Vector(-8,-9)) + (Vector(0,10) * isForgotten)
	if i == 1 then returnPosition = ((Options.HUDOffset * Vector(20, 12)) + Vector(hearts*6+36+hpOffset, 12) + Vector(-8,-9)) + (Vector(0,10) * isForgotten) end --Vector(-8,-8)
	if i == 2 then returnPosition = screenHelper.GetScreenTopRight(0) + Vector(hearts*6-123+hpOffset,12) + Options.HUDOffset * Vector(-20*1.2, 12) + Vector(8,-9) + Vector(0,20) * isForgotten end
	if i == 3 then returnPosition = screenHelper.GetScreenBottomLeft(0) + Vector(hearts*6+46+hpOffset,-27) + Options.HUDOffset * Vector(20*1.1, -12*0.5) + Vector(-8,-9) + Vector(0,20) * isForgotten end
	if i == 4 then returnPosition = screenHelper.GetScreenBottomRight(0) + Vector(hearts*6-131+hpOffset,-27) + Options.HUDOffset * Vector(-20*0.8, -12*0.5) + Vector(8,-9) + Vector(0,20) * isForgotten end
	if i == 5 then returnPosition = screenHelper.GetScreenBottomRight(0) + Vector((-hearts)*6-36+hpOffset,-27) + Options.HUDOffset * Vector(-20*0.8, -12*0.5) + Vector(8,-9) end
	return returnPosition + Game.ScreenShakeOffset
end

local function playersLivesPos(i,hearts,hpOffset,isForgotten)
    local returnPosition = Options.HUDOffset * Vector(20, 12)
	--if i == 1 then return Options.HUDOffset * Vector(20, 12) + Vector(hearts*6+36+hpOffset, 12) + Vector(0,10) * isForgotten end
    --((Options.HUDOffset * Vector(20, 12)) + Vector(hearts*6+36+hpOffset, 12) + Vector(-8,-9)) + (Vector(0,10) * isForgotten)
	if i == 1 then returnPosition = ((Options.HUDOffset * Vector(20, 12)) + Vector(hearts*12+46, 4) + (Vector(0,4) * (isForgotten))) end --Vector(-8,-8)
	if i == 2 then returnPosition = screenHelper.GetScreenTopRight(0) + Vector(hearts*12+hpOffset-123,12) + Options.HUDOffset * Vector(-20*1.2, 12) + Vector(8,-9) + Vector(0,8) * isForgotten end
	if i == 3 then returnPosition = screenHelper.GetScreenBottomLeft(0) + Vector(hearts*12+hpOffset+46,-27) + Options.HUDOffset * Vector(20*1.1, -12*0.5) + Vector(-8,-9) + Vector(0,8) * isForgotten end
	if i == 4 then returnPosition = screenHelper.GetScreenBottomRight(0) + Vector(hearts*12+hpOffset-131,-27) + Options.HUDOffset * Vector(-20*0.8, -12*0.5) + Vector(8,-9) + Vector(0,8) * isForgotten end
	if i == 5 then returnPosition = screenHelper.GetScreenBottomRight(0) + Vector((-hearts)*12-56,-35) + Options.HUDOffset * Vector(-20*0.8, -12*0.5) end
    return returnPosition + Game.ScreenShakeOffset
end

local function RenderCustomHearts(player,playeroffset)
	local index = Mod:GetEntityIndex(player)
	local pType = player:GetPlayerType()
	local isForgotten = ((pType == PlayerType.PLAYER_THESOUL) and 1 or 0)
	local transperancy = 1
	local level = Game:GetLevel()
	if pType == PlayerType.PLAYER_JACOB2_B or player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE) or isForgotten == 1 then
		transperancy = 0.45
	end
	if isForgotten == 1 then
		player = player:GetSubPlayer()
	end

    if(Mod.DataTable[index].PetrifiedHeartSlots ~= nil) then
        local petrifiedHearts = Mod.DataTable[index].PetrifiedHeartSlots
        local goldHearts = 0 --player:GetGoldenHearts() --TODO: do petrified golden hearts
        
        local petrifiedHeartsCount = 0
        for i, petrified in pairs(Mod.DataTable[index].PetrifiedHeartSlots) do
            if petrified then
                petrifiedHeartsCount = petrifiedHeartsCount + 1
            end
        end

        if(petrifiedHeartsCount > 0) then
            for i, value in pairs(petrifiedHearts) do
                if value then
                    --local hearts = ((CanOnlyHaveSoulHearts(player) and player:GetBoneHearts()*2 or player:GetEffectiveMaxHearts()) + player:GetSoulHearts()) - (i * 2)
                    --local hpOffset = petrifiedHeartsCount%2 ~= 0 and (playeroffset == 5 and -6 or 6) or 0
                    --[[local playersHeartPos = {
                        [1] = Options.HUDOffset * Vector(20, 12) + Vector(hearts*6+36+hpOffset, 12) + Vector(0,10) * isForgotten,
                        [2] = screenHelper.GetScreenTopRight(0) + Vector(hearts*6+hpOffset-123,12) + Options.HUDOffset * Vector(-20*1.2, 12) + Vector(0,20) * isForgotten,
                        [3] = screenHelper.GetScreenBottomLeft(0) + Vector(hearts*6+hpOffset+46,-27) + Options.HUDOffset * Vector(20*1.1, -12*0.5) + Vector(0,20) * isForgotten,
                        [4] = screenHelper.GetScreenBottomRight(0) + Vector(hearts*6+hpOffset-131,-27) + Options.HUDOffset * Vector(-20*0.8, -12*0.5) + Vector(0,20) * isForgotten,
                        [5] = screenHelper.GetScreenBottomRight(0) + Vector((-hearts)*6+hpOffset-36,-27) + Options.HUDOffset * Vector(-20*0.8, -12*0.5)
                    }]]
                    local offset = playersHeartPos(playeroffset,(i*2),0,isForgotten)--playersHeartPos[playeroffset]
                    local offsetCol = (playeroffset == 1 or playeroffset == 5) and 6 or 3
                    
                    if (i ~= 0) then
                        if (i>12) then
                            --maggy birthright is the only one that can go past 12 as far as im aware
                            offset.X = offset.X - (playeroffset == 1 and 144 or 72)
                            offset.Y = offset.Y + 20
                        elseif (i>6) then
                            offset.X = offset.X - (playeroffset == 5 and (-72) or (playeroffset == 1 and 72 or 36))
                            offset.Y = offset.Y + 10
                        end

                        --offset.X = offset.X - (math.floor(i-1 / offsetCol) * (playeroffset == 5 and (-72) or (playeroffset == 1 and 72 or 36)))
                        --offset.Y = offset.Y + (math.floor(i-1 / offsetCol) * 10)
                    end
                    

                    local anim = "Petrified_Heart"
                    if goldHearts - i > 0 then
                        anim = anim.."Gold"
                    end
                    
                    --[[
                    if i == 0 and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                    and Mod.GetPlayerMaxHealthContainers(player) == player:GetHeartLimit() and not player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
                    and pType ~= PlayerType.PLAYER_JACOB2_B then
                        anim = anim.."Mantle" --when tf is this active
                    end
                    ]]

                    petrifiedHeartSprite.Color = Color(1,1,1,transperancy)
                    if not petrifiedHeartSprite:IsPlaying(anim) then 
                        petrifiedHeartSprite:Play(anim, true)
                    end
                    petrifiedHeartSprite.FlipX = playeroffset == 5
                    petrifiedHeartSprite:Render(Vector(offset.X, offset.Y), Vector(0,0), Vector(0,0))
                end
            end
        end
	end
end

local function RenderExtraLivesCounter(player, playeroffset)
    local index = Mod:GetEntityIndex(player)
    local pType = player:GetPlayerType()
	local isForgotten = ((((pType == PlayerType.PLAYER_THEFORGOTTEN) and 2) or (pType == PlayerType.PLAYER_THESOUL) and 1) or 0)
    local playerMaxHearts
    if(isForgotten > 0) then
        local theSoulMax
        local theForgottenMax

        if(isForgotten == 2) then
            theForgottenMax = (math.ceil(player:GetEffectiveMaxHearts()/2) + player:GetBrokenHearts())
            theSoulMax = (math.ceil(player:GetSubPlayer():GetSoulHearts()/2) + player:GetSubPlayer():GetBrokenHearts())
        else
            theForgottenMax = (math.ceil(player:GetSubPlayer():GetEffectiveMaxHearts()/2) + player:GetSubPlayer():GetBrokenHearts())
            theSoulMax = (math.ceil(player:GetSoulHearts()/2) + player:GetBrokenHearts())
        end

        playerMaxHearts = math.max(theSoulMax, theForgottenMax)
    else
        playerMaxHearts = Mod.GetPlayerMaxHealthWithBrokenHearts(player)
    end

    if(Mod.DataTable[index].TrueExtraLives and Mod.DataTable[index].TrueExtraLives ~= player:GetExtraLives()) then
    --if(true)then
        local f = Font() -- init font object
        f:Load("font/pftempestasevencondensed.fnt") -- load a font into the font object
        local offset = playersLivesPos(playeroffset,math.min(playerMaxHearts, 6),0,math.min(isForgotten,1))

        if(isForgotten <= 0) then
            offset = offset + Vector(0,math.floor(math.max(playerMaxHearts-1, 0)/6)*4)
        end
        --print(offset)
        f:DrawString("x11!",offset.X,offset.Y,KColor(1,1,1,.99),0,true) -- TODO:make lives actually accurate
        --f:DrawString("x1",126,20,KColor(1,1,1,.99),0,true) -- render string with loaded font on position 60x50y
    end

end

function Mod:OnRender(shaderName)
    -- Only render if the shader is my own
    if shaderName ~= "UI_DrawHearts_DummyShader" then return end
    if Mod:shouldDeHook() then return end
	local isJacobFirst = false
	for i = 0, (Game:GetNumPlayers() - 1), 1 do
		local player = Isaac.GetPlayer(i)
		local index = Mod:GetEntityIndex(player)
		if i == 0 and player:GetPlayerType() == PlayerType.PLAYER_JACOB then
			isJacobFirst = true
		end
		
		if (player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B or player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B) then
			if player:GetOtherTwin() then
				if Mod.DataTable[index].i and Mod.DataTable[index].i == i then
					Mod.DataTable[index].i = nil
				end
				if not Mod.DataTable[index].i then
					local otherIndex = Mod:GetEntityIndex(player:GetOtherTwin())
					Mod.DataTable[otherIndex].i = i
				end
			elseif Mod.DataTable[index].i then
				Mod.DataTable[index].i = nil
			end
		end
		if player:GetPlayerType() ~= PlayerType.PLAYER_THESOUL_B and not player.Parent and not Mod.DataTable[index].i then
			if player:GetPlayerType() == PlayerType.PLAYER_ESAU and isJacobFirst then
                RenderCustomHearts(player,5)
                RenderExtraLivesCounter(player, 5)
			elseif player:GetPlayerType() ~= PlayerType.PLAYER_ESAU then
                RenderCustomHearts(player,i+1)
                RenderExtraLivesCounter(player, i+1)
			end
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, Mod.OnRender)

function Mod:GetPillEffect(pillEffect, pillColor)
    return ModPillEffects.BIPOLAR--.MINDBLOWING--ModPillEffects.MYSTERY_DRUG
    --return PillEffect.PILLEFFECT_SOMETHINGS_WRONG
end
Mod:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT, Mod.GetPillEffect)

function Mod:UsePill(pillEffect, player, _)
    local horse = Mod:IsHorsePill(player)
    if(pillEffect == PillEffect.PILLEFFECT_PARALYSIS) then
        if(horse) then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, false, false, true, false, -1)
        else
            Mod:ShortPause(player)
        end
    elseif(pillEffect == PillEffect.PILLEFFECT_SOMETHINGS_WRONG) then
        Mod:MakePuddlesUnfriendly(player)
        --TODO: seems like even removing the puddles immediately still shows them for a frame so just make al 3 custom pills and remove this from the rotation
    
        --summon a gish puddle on isaac
    end
    --TODO: make xlax accellerate things super fast, to the point that normal enemies hit walls and take damage
    --remake paralysis into a pill that freezes isaac, enemies and enemy shots in the air, essentially a short term pause (mabs just use pause and see if it works well enough?)
    -- pause wisps pause all enemies and enemy shots for 3 seconds when destroyed, look into if this is a viable way to get a short pause
end

function Mod:ShortPause(player)
    local wispToKill = player:AddWisp(CollectibleType.COLLECTIBLE_PAUSE, Vector(-400,-400), false, true)
    wispToKill:Kill()
    SFXManager():Stop(SoundEffect.SOUND_STEAM_HALFSEC)
end

function Mod:MakePuddlesUnfriendly(player)
    local flags
    print(player.Position)
    Mod:SpawnCreep(Vector(200,200))
    for i, entity in ipairs(Isaac.GetRoomEntities()) do 
        if(entity.Type == 1000 and entity.Variant == 45) then
            Mod:SpawnCreep(entity.Position)
            entity.Visible = false
            entity:Remove()
            if(entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
                
            else
                --print("meanie detected")
            end
            --entity:ClearEntityFlags(EntityFlag.FLAG_FRIENDLY)
            --entity:Update()
        end
    end
    Mod.DataTable.BlackCreepGrowth = 100
    
    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        if(entity.Type == 1000 and (entity.Variant == EffectVariant.CREEP_BLACK)) then
            --entity.SpriteScale = Vector(3,3)
            --entity:Update()
            --print(entity:GetSprite():GetFilename())
            
        end
    end
end

function Mod:SpawnCreep(location)
    local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, location, Vector(0,0), nil):ToEffect()
    
    
    creep:GetSprite():SetAnimation("BiggestBlood02", false)
    --creep:GetSprite():Stop()
    --creep:GetSprite():Load("1000.026_creep (black).anm2", true)
    --creep:GetSprite():Play("BiggestBlood02", false)
    --creep:GetSprite():SetAnimation("BiggestBlood02", true)
    --creep:GetSprite():PlayOverlay("BiggestBlood02", true)
    Mod.DataTable.BlackCreepGrowth = 100
    creep.Size = 100
    --creep.Scale = 3
    --creep:Update()
    --Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, entity.Position, Vector(0,0), nil)
end

function Mod:IsHorsePill(player)
    return (player:GetPill(0) >= 2048)
end

function Mod:PillEffectPILLPOCALYPSE(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --turns all drops (mabs enemies too?) in room into pills, idk if this should ignore unopened chests or not
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
        if((entity.Variant ~= PickupVariant.PICKUP_COLLECTIBLE) and (entity.Variant ~= 340) and (entity.Variant ~= 370)) then
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
        TODO: there should also be a tinted petrified heart that has a rare chance to spawn instead,
        horsepills should have a much higher chance to spawn these (like 3-4 for 12 hearts),
        these should simulate a tinted rock breaking when they get destroyed, 
        droping the pickups around isaac as if he were the position of the rock
        
        also need to do keeper coin shaped petrified hearts

        using the pill as a soul will give you petrified hearts equal to your soul hearts and not bone hearts
    ]]--

    player:AddHearts(player:GetEffectiveMaxHearts()-player:GetHearts())
    if player:GetSoulHearts() % 2 == 1 then
        player:AddSoulHearts(1)
    end

    local maxHealth = Mod.GetPlayerMaxHealthContainers(player)

	local index = Mod:GetEntityIndex(player)
	local petrifiedHearts = Mod.DataTable[index].PetrifiedHeartSlots

    if(Mod.DataTable[index].PetrificationPillsTaken == nil) then
        Mod.DataTable[index].PetrificationPillsTaken = 1
    else
        Mod.DataTable[index].PetrificationPillsTaken = Mod.DataTable[index].PetrificationPillsTaken + 1
    end

    if(Mod.DataTable[index].PetrifiedHeartSlots == nil) then 
        Mod.DataTable[index].PetrifiedHeartSlots = {}
    end

    for i=1,maxHealth,1 do
        Mod.DataTable[index].PetrifiedHeartSlots[i] = true
    end

    Mod:PetrificationCacheFlags(player)
end
function Mod:PetrificationCacheFlags(player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:EvaluateItems()
end

function Mod:PillEffectLEPROSY(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)

    if(horse) then
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.LEPROCY, 0, player.Position, Vector(0,0), player)
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.LEPROCY, 0, player.Position, Vector(0,0), player)
        --Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.LEPROSY, 0, player.Position, Vector(0,0), player)
        --seem to be the same?
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.SWARM_FLY_ORBITAL, 0, player.Position, Vector(0,0), player)
    end

    player:AddRottenHearts(player:GetMaxHearts())
end

function Mod:PillEffectPARANOIA(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)

    local index = Mod:GetEntityIndex(player)
	local extraVanishingTwins = horse and 2 or 1

    if(Mod.DataTable[index].ExtraVanishingTwins == nil) then 
        Mod.DataTable[index].ExtraVanishingTwins = extraVanishingTwins
    else
        Mod.DataTable[index].ExtraVanishingTwins = Mod.DataTable[index].ExtraVanishingTwins + extraVanishingTwins
    end

    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
    player:EvaluateItems()
end

function Mod:PillEffectMETH(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)

    local index = Mod:GetEntityIndex(player)

    --Game:GetDevilRoomDeals()
    --Mod.DataTable[index].DevilDealsTaken
    --turns out there was actually a devil deal tracker lol

    if(Game:GetDevilRoomDeals() > 0) then
        Mod.DataTable[index].Methamphetamines = {((horse and 2 or 1) * 900), -1}
    else
        Mod.DataTable[index].Methamphetamines = {((horse and 2 or 1) * 900), math.min(Game:GetDevilRoomDeals(), 10)}
    end

    Mod:MethCacheFlags(player)
end
function Mod:MethCacheFlags(player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
    player:AddCacheFlags(CacheFlag.CACHE_RANGE)
    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
    player:AddCacheFlags(CacheFlag.CACHE_FLYING)
    player:EvaluateItems()
end

function Mod:PillEffectXANNY(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)

    local index = Mod:GetEntityIndex(player)

    Mod.DataTable[index].Xanax = ((horse and 2 or 1) * 900)
    
    Mod:XanaxCacheFlags(player)
end
function Mod:XanaxCacheFlags(player)
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:EvaluateItems()
end

function Mod:PillEffectFLAX(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --again, horse pill idk
    --I thought about the idea of a giant hallowed poop, which honestly sounds pretty cool, if i can figure out how to do that then def do it
    --TODO: see if big hallowed poop gridtiles are possible
    Isaac.GridSpawn(GridEntityType.GRID_POOP, 6, player.Position, true)
    if horse then
        for i=0, 1, 1 do
            player:ThrowFriendlyDip(6, player.Position, Vector.Zero)
        end
    end
end

function Mod:PillEffectXXLAX(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    for i=0, 8, 1 do
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, player.Position+(Vector(0,-90):Rotated(i*45)), Vector(0,0), nil)
    end
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, player.Position, Vector(0,0), nil)
    for i=0, 8, 1 do
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 1, player.Position+(Vector(0,-70):Rotated(i*45)), Vector(0,0), nil)
    end
    player:UsePoopSpell(PoopSpellType.SPELL_FART)
    for i, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0)) do
        entity:ToEffect():SetTimeout(200+math.floor(math.random()*100))
        entity:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
    end
    for i, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 1)) do
        entity:ToEffect():SetTimeout(150+math.floor(math.random()*50))
    end
    if horse then
        for i=0, 5, 1 do
            player:ThrowFriendlyDip(14, player.Position, Vector.Zero)
        end
    end
end

function Mod:PillEffectCLOTTING_AGENT(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    local index = Mod:GetEntityIndex(player)

    if(Mod.DataTable[index].ClottingAgentTimer == nil) then
        Mod.DataTable[index].ClottingAgentTimer = {80, horse}
    else
        Mod.DataTable[index].ClottingAgentTimer[1] = 80
        Mod.DataTable[index].ClottingAgentTimer[2] = horse
    end
    
    Mod:SpawnClot(player, 7, player.Position)
    --TODO: drain a heart, provide clot based on what was taken

    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsActiveEnemy(false) and not entity:IsBoss() then
            --TODO: replace enemy with base version first to account for other champions

            entity:ToNPC():MakeChampion(entity.InitSeed, ChampionColor.DARK_RED, false)
            entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
            --entity:AddEntityFlags(EntityFlag.FLAG_SHRINK)
            entity:Kill()
        end
    end
    --the clot trinket is 5.350.176
end
function Mod:SpawnClot(player, type, postion)
    --TODO: make type determine which clot to spawn, probs with an enum
    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 7, postion, Vector(0,0), player)
end

function Mod:PillEffectPHANTOM_PAINS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    player:TakeDamage(1, DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_NOKILL, EntityRef(player), 1)
    player:ResetDamageCooldown()
    player:SetMinDamageCooldown((horse and 3 or 1)*300)
end

function Mod:PillEffectSEEING_RED_GOOD(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)


    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsActiveEnemy(false) then
            entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
            if(not entity:IsBoss() and (entity.HitPoints < entity.MaxHitPoints*(horse and 1.5 or 0.75))) then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, entity.Position, Vector(0,0), nil)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, entity.Position + (Vector(0,-40)), Vector(0,0), nil)
                entity:Kill()
            end
        end
    end

    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, player.Position, Vector(0,0), nil)
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, player.Position + (Vector(0,-40)), Vector(0,0), nil)

    if horse then
        SFXManager():Play(SoundEffect.SOUND_LARYNX_SCREAM_HI,4,2,false,.85)
    else
        SFXManager():Play(SoundEffect.SOUND_LARYNX_SCREAM_HI,2,2,false,1)
    end

    local index = Mod:GetEntityIndex(player)

    if(Mod.DataTable[index].RedScreaming ~= nil) then
        Mod.DataTable[index].RedScreaming = math.max(Mod.DataTable[index].RedScreaming,0) + ((horse and 5 or 1) * 90)
    else
        Mod.DataTable[index].RedScreaming = (horse and 5 or 1) * 90
    end
    
    
    --player:UseActiveItem(CollectibleType.COLLECTIBLE_LARYNX, UseFlag.USE_CUSTOMVARDATA, -1)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_LARYNX, true, false, true, false, -1)
end

function Mod:PillEffectSEEING_RED_BAD(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    
    for i=1, (horse and 3 or 1) + ((#Isaac.GetRoomEntities() > 0 ) and 2 or 0), 1 do
        Isaac.Spawn(EntityType.ENTITY_NEEDLE, 0, 0, player.Position, Vector(0,0), nil)
        --print(i, "Needle Spawned")
    end
    
    Mod:ForceCloseDoors()

    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsActiveEnemy(false) then
            --TODO: probs shouldnt effect bosses huh
            local data = entity:GetData()
            if data.BasedAndRedPilled == nil then
                --Enemies dont need to be turned to base versions, but I could, i can see either way
                data.BasedAndRedPilled = true
                entity:ToNPC():MakeChampion(entity.InitSeed, ChampionColor.DARK_RED, false)
                entity:ToNPC():PlaySound(SoundEffect.SOUND_LARYNX_SCREAM_MED,(horse and 1.0 or 0.8),2,false,0.7)
                entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS |
                --EntityFlag.FLAG_NO_FLASH_ON_DAMAGE |
                EntityFlag.FLAG_NO_KNOCKBACK |
                EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK |
                EntityFlag.FLAG_EXTRA_GORE |
                EntityFlag.FLAG_NO_SPIKE_DAMAGE)
                if(entity.Type == EntityType.ENTITY_NEEDLE) then
                    entity:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
                    --dark red needles are pretty unfair
                    entity:ToNPC():MakeChampion(entity.InitSeed, ChampionColor.RED, false)
                else
                    entity:ToNPC():MakeChampion(entity.InitSeed, ChampionColor.DARK_RED, false)
                    entity.MaxHitPoints = entity.MaxHitPoints * (horse and 3 or 2)
                    entity.HitPoints = entity.MaxHitPoints
                end
            end
        end
    end
end

function Mod:PillEffectTHC(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    local index = Mod:GetEntityIndex(player)
    local level = Game:GetLevel()
    local effectTime = ((horse and 2 or 1) * 430)

    --TODO: this pill might be a little too OP

    Mod:ApplyTHCItems(player)
    player:SpawnMawOfVoid(75)
    --Game:GetLevel():GetCurrentRoomDesc().Flags = Game:GetLevel():GetCurrentRoomDesc().Flags | RoomDescriptor.FLAG_PITCH_BLACK
    print(Game:GetLevel():GetCurrentRoomDesc().Flags)
    print(Game:GetLevel():GetCurrentRoomDesc().Flags | RoomDescriptor.FLAG_PITCH_BLACK)

    local room = Game:GetRoom()
    
    local writableRoomDesc = level:GetRoomByIdx(level:GetCurrentRoomIndex())
    
    writableRoomDesc.Flags = (Game:GetLevel():GetCurrentRoomDesc().Flags | RoomDescriptor.FLAG_PITCH_BLACK)
    
    --room:Update()
    
    --TODO: make all rooms dark

    --Game:GetLevel():GetCurrentRoomDesc().Flags = 577

    --Game:Darken(1, effectTime)
    Game:GetLevel():SetStateFlag(LevelStateFlag.STATE_SATANIC_BIBLE_USED, true)

    Mod.DataTable[index].THC = effectTime
end
function Mod:THCCacheFlags(player)
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    player:EvaluateItems()
end
function Mod:ApplyTHCItems(player)
    local effectsManager = player:GetEffects()
    effectsManager:AddCollectibleEffect(CollectibleType.COLLECTIBLE_2SPOOKY, true)
    effectsManager:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, true)
    effectsManager:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS, true)
    effectsManager:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HUNGRY_SOUL, true)
    effectsManager:AddCollectibleEffect(CollectibleType.COLLECTIBLE_PENTAGRAM, true)
    effectsManager:AddCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_MATTER, true)
    effectsManager:AddCollectibleEffect(CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID, true)
    effectsManager:AddTrinketEffect(TrinketType.TRINKET_NUMBER_MAGNET, true)
    effectsManager:AddTrinketEffect(TrinketType.TRINKET_DEVILS_CROWN, true)
end
function Mod:RemoveTHCItems(player)
    local effectsManager = player:GetEffects()
    effectsManager:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE, -1)
    effectsManager:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_2SPOOKY, -1)
    effectsManager:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS, -1)
    effectsManager:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HUNGRY_SOUL, -1)
    effectsManager:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_PENTAGRAM, -1)
    effectsManager:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_MATTER, -1)
    effectsManager:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID, -1)
    effectsManager:RemoveTrinketEffect(TrinketType.TRINKET_NUMBER_MAGNET, -1)
    effectsManager:RemoveTrinketEffect(TrinketType.TRINKET_DEVILS_CROWN, -1)
end

function Mod:PillEffectJESUS_PILLS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    
    local stage = Game:GetLevel():GetStage()

    local curFloorIsAltpath = ((Game:GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE) or (Game:GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE_B))
    if(not Game:GetStateFlag(GameStateFlag.STATE_DEVILROOM_SPAWNED)) and (not Mod:IsBasement1()) then
        if((stage == LevelStage.STAGE1_1) or ((stage == LevelStage.STAGE1_2 and not curFloorIsAltpath) and horse)) then
            --yeah with a labarynth on floor 1 you get a 100% angel chance but hey whatever I cant stop that, plus it makes labs marginally better
            Game:SetLastDevilRoomStage(0)
        else
            if(Mod.DataTable.JesusPillsChangedStage == nil or horse) then
                local stageToTurnInto = math.max(Mod.DataTable.LastNaturalDevilRoom, (math.max(stage-(horse and 2 or 1), 1))+(curFloorIsAltpath and 1 or 0))
                Game:SetLastDevilRoomStage(stageToTurnInto)

                Mod.DataTable.JesusPillsChangedStage = true
            end
        end
    end
    Game:GetLevel():AddAngelRoomChance((horse and 2 or 1)*(.5))
    Game:GetLevel():SetStateFlag(LevelStateFlag.STATE_SATANIC_BIBLE_USED, false)
    Game:GetLevel():SetStateFlag(LevelStateFlag.STATE_WOODEN_CROSS_REMOVED, false)
    Game:GetLevel():SetStateFlag(LevelStateFlag.STATE_EVIL_BUM_LEFT, false)
    Game:GetLevel():SetStateFlag(LevelStateFlag.STATE_BUM_KILLED, false)
    Game:GetLevel():SetStateFlag(LevelStateFlag.STATE_SHOPKEEPER_KILLED_LVL, false)
    --:AddCollectibleEffect(CollectibleType, AddCostume, Count)
end

function Mod:PillEffectPLAN_B(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
end

function Mod:PillEffectROSE_TINTED(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    local removedItem = Mod:removeOldestItem(player)
    if(removedItem ~= nil) then
        player:AnimateCollectible(removedItem[1])
        --TODO: do the effect and spawn and whatever delayed like the stars does
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, player.Position, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, player.Position + (Vector(0,-40)), Vector(0,0), nil)
        SFXManager():Play(SoundEffect.SOUND_BLACK_POOF, 1, 2, false, 1)

        local itemPool = Game:GetItemPool():GetPoolForRoom(Game:GetRoom():GetType(), Random())
        --TODO: i dunno what this seed is for but it should probably be reliable
        local newItemID = Mod:getNewItem(player, removedItem, itemPool,((horse or (Random()%2 == 1)) and 3 or 2)) --auto quality 4 is kindof busted
        
        local spawnPostion = Game:GetRoom():FindFreePickupSpawnPosition(player.Position + (Vector(0,65)), 0, false, false)

        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItemID, spawnPostion, Vector(0,0), nil)
        
        Game:GetItemPool():RemoveCollectible(newItemID)
    end
end
function Mod:getNewItem(player, removedItem, pool, minQuality)
    local newItemID
    local itemPool = Game:GetItemPool()
    local itemConfig = Isaac.GetItemConfig()
    local flag = false
    while not flag do
        newItemID = itemPool:GetCollectible(pool, false, Random())
        --TODO: make the seed be reliable
        if(newItemID == CollectibleType.COLLECTIBLE_NULL) then
            minQuality = minQuality - 1
            itemPool:ResetRoomBlacklist()
            if(minQuality <= -1) then
                return CollectibleType.COLLECTIBLE_BREAKFAST
            end
        elseif (not player:CanAddCollectible(newItemID)) then
            print("Player couldnt add collectible: " .. newItemID)
            itemPool:AddRoomBlacklist(newItemID)
        elseif (itemConfig:GetCollectible(newItemID).Quality < minQuality) then
            itemPool:AddRoomBlacklist(newItemID)
        else
            flag = true
        end
    end
    itemPool:ResetRoomBlacklist()
    return newItemID
    --this doesnt remove the collectible, use Game:GetItemPool():RemoveCollectible(newItemID)
end
function Mod:removeOldestItem(player)
    local index = Mod:GetEntityIndex(player)

    if(Mod.DataTable[index].ItemsInOrder ~= nil and Mod.DataTable[index].ItemsInOrder[1] ~= nil) then
        local itemToRemove
        local flag = false
        while((#Mod.DataTable[index].ItemsInOrder) > 0 and not flag) do
            itemToRemove = (table.remove(Mod.DataTable[index].ItemsInOrder, 1))
            --print(itemToRemove)
            if(player:HasCollectible(itemToRemove[1])) then
                player:RemoveCollectible(itemToRemove[1])
                flag = true;
            end
        end
        if(flag) then
            return itemToRemove
        else
            return nil
        end
    end
end

function Mod:PillEffectDEMENTIA(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    local index = Mod:GetEntityIndex(player)

    for i = 1, (horse and 2 or 1), 1 do
        local removedItem = Mod:removeOldestItem(player)
        if(removedItem ~= nil and removedItem[1] > 0) then
            if(Mod.DataTable[index].Dementia == nil) then
                Mod.DataTable[index].Dementia = 1
            else
                Mod.DataTable[index].Dementia = Mod.DataTable[index].Dementia + 1
            end
            if(removedItem[3] >= 4) then    --if quality 4
                Mod.DataTable[index].Dementia = Mod.DataTable[index].Dementia + 1
            end
        end
        --TODO: consider letting dementia infinitely boost tears? 
        --loosing an item is a pretty harsh cost for a fairly low tears up, and would theoretically make people want to do it more
        --plus if my tlust char will be purposefully taking bad pills you would want any bad effects mitigated
    end
    Mod:DementiaCacheFlags(player)
end
function Mod:DementiaCacheFlags(player)
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    player:EvaluateItems()
end

function Mod:PillEffectSPIRIT_SALTS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    local index = Mod:GetEntityIndex(player)

    --I really like how this pill turned out

    if(Mod.DataTable[index].SpiritSalts == nil) then
        Mod.DataTable[index].SpiritSalts = {((horse and 2 or 1) * 100), horse}
    else
        Mod.DataTable[index].SpiritSalts[1] = Mod.DataTable[index].SpiritSalts[1] + ((horse and 2 or 1) * 100)
        Mod.DataTable[index].SpiritSalts[2] = horse
    end
    if(horse) then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, 189, 0, player.Position, Vector(0,0), nil)
    else
        Isaac.Spawn(EntityType.ENTITY_EFFECT, 189, 1, player.Position, Vector(0,0), nil)
    end
    --1000.189.0 are the rifts, 1000.189.1 are the ghoties
end

function Mod:PillEffectBATH_SALTS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --sfx/boo mad.wav is a good sound effect
end

function Mod:PillEffectIMMAGINARY_FRIENDS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)

    for i = 1, ((horse and 2 or 1)*5), 1 do
        player:AddMinisaac(player.Position, true)
    end
end

function Mod:PillEffectHALLUCINATIONS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)

    local x = Game:GetRoom():GetCenterPos().X
    local y = Game:GetRoom():GetCenterPos().Y
    local entityToSpawn
    if horse then 
        entityToSpawn = EntityType.ENTITY_WILLO_L2
    else
        entityToSpawn = EntityType.ENTITY_WILLO
    end

    Isaac.Spawn(entityToSpawn, 0, 0, Vector(-100, y), Vector(0,0), nil)
    Isaac.Spawn(entityToSpawn, 0, 0, Vector(x,-100), Vector(0,0), nil)
    Isaac.Spawn(entityToSpawn, 0, 0, Vector(100+ (2*x),y), Vector(0,0), nil)
    Isaac.Spawn(entityToSpawn, 0, 0, Vector(x,100+ (2*y)), Vector(0,0), nil)
end

function Mod:PillEffectSEEING_GOLD_GOOD(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    
    Game:GetRoom():TurnGold() --probs should turn poops golden too (maybe that and the room thing should be for horsepills only?)

    local entities = Isaac.GetRoomEntities()

    for key, entity in pairs(entities) do
        if(entity:IsEnemy()) then
            entity:AddMidasFreeze(EntityRef(player), 150)
        end
        if(horse) then
            --could add more golden transformations, like trinkets and certain items
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
    local coinsToDrop = math.ceil(player:GetNumCoins()*(horse and 2 or 1)*.25)
    Isaac.GetPlayer():AddCoins(-coinsToDrop)
    for i = 1, coinsToDrop, 1 do 
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, player.Position, Vector(0,-10):Rotated(math.random(360)), player)
        --leaving them random feels better since you can sometimes get more, essentially it gives a reason to use this pill even when knowing it
    end

    for i, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, -1)) do
        entity:ToPickup().Timeout = math.random(35) + 105
    end

    --TODO: with false phd cause coins to be thrown in a cone infront of isaac, increasing the chance he can collect them all again

    player:AnimateSad()
end

function Mod:PillEffectFRIENDS_TO_THE_VERY_END(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    for i=1, ((horse and 2 or 1)*7), 1 do
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, LocustSubtypes.LOCUST_OF_WRATH, player.Position, Vector(0,0), nil)
    end
end

function Mod:PillEffectDUKE_PHEROMONES(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    local index = Mod:GetEntityIndex(player)
    --TODO: right now this isnt friendly when you have pustules already in the room
    local pustule = Isaac.Spawn(EntityType.ENTITY_PUSTULE, 0, 0, player.Position, Vector(0,0), nil)
    pustule.MaxHitPoints = pustule.MaxHitPoints * 100
    pustule.HitPoints = pustule.MaxHitPoints
    pustule:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS |
    EntityFlag.FLAG_NO_FLASH_ON_DAMAGE |
    EntityFlag.FLAG_NO_KNOCKBACK |
    EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK |
    EntityFlag.FLAG_EXTRA_GORE |
    EntityFlag.FLAG_NO_SPIKE_DAMAGE |
    EntityFlag.FLAG_NO_PLAYER_CONTROL |
    EntityFlag.FLAG_AMBUSH |
    EntityFlag.FLAG_NO_REWARD)

    Mod:ForceCloseDoors()

    if(Mod.DataTable[index].DukePheromones == nil) then
        Mod.DataTable[index].DukePheromones = {210, horse}
    else
        Mod.DataTable[index].DukePheromones[1] = 210
        Mod.DataTable[index].DukePheromones[2] = horse
    end
end

function Mod:PillEffectCALCIFICATION(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)

    for i=1,(horse and 2 or 1), 1 do
        if(player:GetMaxHearts() > 0) then
            player:AddMaxHearts(-2, false)
        end
        if(player:CanPickBoneHearts()) then
            player:AddBoneHearts(1)
            --has red heart containers availible
            if((player:GetEffectiveMaxHearts() - (player:GetBoneHearts()*2)) > 0) then
                
            end
            --if any red health is in bone hearts
            local extraHearts = (player:GetHearts() - (player:GetEffectiveMaxHearts() - (player:GetBoneHearts()*2)))
            if( extraHearts > 0) then
                player:AddHearts(-extraHearts)
            end
        else
            Mod:BoneSpray(player)
        end
    end
end
function Mod:BoneSpray(player)
    --TODO: impliment bone spray
end

function Mod:PillEffectACETOMETAPHIN(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    for i=1, (horse and 2 or 1), 1 do
        player:AddWisp(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, player.Position)
    end
end

function Mod:PillEffectPARACETOMOL(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    for i=1, (horse and 7 or 3), 1 do
        player:AddWisp(CollectibleType.COLLECTIBLE_MAMA_MEGA, player.Position)
    end
    player:AddWisp(CollectibleType.COLLECTIBLE_MOMS_BOTTLE_OF_PILLS, player.Position)
end

function Mod:PillEffectBIPOLAR(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)

    local index = Mod:GetEntityIndex(player)

    --TODO: j+e effect being this:
    --[[
        causes them to swap positions, telefragging any normal enemies and sub 50% hp non end bosses, and destroying all tiles inbetween the two
        indication that this happened afterwards can be a massive blood streak left afterwards where any telefragging could have happened,
        this telefrag zone would also duplicate any (non-jera/bipolar) pickup, including pedistals (ie a successful crooked penny effect)

        if used on a char that used a bipolar pill then it turns them back early
    ]]

    --TODO: alter j+e stats and costumes to look like there are two base chars of whoever split
    --[[ ones that still need work:
        keeper, no coin health, no tripple shot, possibly could give them keeper special costumes but that seems like a whole lotta work
        lost: needs flight, spectral, holy mantle on both, somehow making health invisible and locking it at 1
        azazel needs a laser and flight
        laz needs laz rags on both of them
        cain needs shooting from one eye?
        eve needs a bird and whore of bab on each, probs wont be able to make it activate early (but mabs with effects I can?)
        eden needs to set stats right (more than others)
        lilith needs incubi on each, and making the players not shoot
        beth needs soul charges but again im not sure thats possible
        forgotten needs his special shit
        tisaac probs want to limit items (somehow?)
        tforgotten makes horrid monsters (honestly the idea of both just being immovable skeletons is pretty funny, but it should probs be two souls)
        tkeeper needs coin hearts, quad shot, and all items costing money
        tlilith needs to use gello on each shot, and stuff like that
        tlost: needs all lost does
        teden needs to reroll on hit
        tazazel needs sneezing and brim
        tsamson needs to use beserk randomly depending on its internal stat, also give them hair when berserking
        teve needs to make clots every now and then
        tbb needs to throw shit randomly
        tjudas should have them use the judas soul stone, then when that ends the other one gets the soul stone
        tcain, both need bag of crafting, and pedistals to explode into pickups (im not sure if I can drop the pickups from esaus bag (may just need to track those))
        tmaggy, they need to do big hug damage, which im not sure is possible, bleed hearts, enemies need to drop hearts




        ok this can work, I have to replace the files of j&e in runtime to the correct skin,
        this will solve the picking up items and damage and all that jazz, on top of making them look right

        ok wild idea, azazel is actually ez af, lost just give them curse of the lost easy enough, 
        keeper will probably be a bitch and a half to make coin hearts look legit, but otherwise they should be easy
        t forgotten just turn them both into piles of bones that cant move until its over, meme and def how tforgotten would probs work
        forgotten is the tough one, do I do all the work to replicate the club? 
        do I make both of them look like ghosts tied to the orginal forgotten?
        do I just make a different implimentation for forgotten?, 
        the double soul idea is the closest I have yet to a working idea that isnt a massive pain in the ass that might be impossible anyways
    ]] 
    --find out how azazels stump works, because when it triggers you gain azazels laser, flight and costume
    --5.350.162
    -- nah azazel is easy, turns out lasers are actually pretty friendly to work with

    --TODO: esau needs to drop his active when transforming back
    --TODO: switch them back before postit note bosses die

    --theres a vanilla bug with dead cat lives when turning into j+e which I cant really find a great way to work around, 
    --seeing if esau has the item and then giving it back after going back is an option, 
    --but would refresh the lives which isnt great, 
    --and the bigger problem is that the dead cat item seems to still count for guppy transformations even with it dissapeared, 
    --which wil multiply the guppy items in terms of dead cats that esau gets
    --ill see if I can make it so that it doesnt count again and if thats the case ill do that but this transformation stuff is annoying

    --j&e are actually just weird an jank with transformations, 
    --the items get split but who actually picked it up doesnt, so after they split they are counted as permanent transformations, 
    --but you will also only get the transformation when you have one item counting towards it

    local playerTypeToSave = player:GetPlayerType()

    if(playerTypeToSave == PlayerType.PLAYER_LAZARUS_B or playerTypeToSave == PlayerType.PLAYER_LAZARUS2_B) then 
        --switching to j+e from second lazarus doesnt work so it does this instead, which I honestly like better
        player:UseActiveItem(CollectibleType.COLLECTIBLE_FLIP, true, false, true, false, -1)
    elseif(playerTypeToSave == PlayerType.PLAYER_JACOB or playerTypeToSave == PlayerType.PLAYER_ESAU) then
        --filler for j&e effect
    else
        if((flags & UseFlag.USE_MIMIC) == 0) then
            --changing to j&e drops the pill on the ground, creating a duplicate
            player:SetPill(0, PillColor.PILL_NULL)
        end

        if(player:GetPlayerType() == PlayerType.PLAYER_THESOUL) then 
            playerTypeToSave = PlayerType.PLAYER_THEFORGOTTEN
        elseif(player:GetPlayerType() == PlayerType.PLAYER_JACOB2_B) then
            --not doing this causes T.Esau to not spawn again, plus isnt it nice to be able to go back
            playerTypeToSave = PlayerType.PLAYER_JACOB_B
        end

        Mod.DataTable[index].Bipolar = {((horse and 2 or 1) * 900),playerTypeToSave}

        if(player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B) then 
            --holy shit this took so long to figure out
            player:GetMainTwin():ChangePlayerType(PlayerType.PLAYER_ISAAC)
        end

        local nullCostumeToAdd = CharacterIDToCostumes[playerTypeToSave][1]
        local skinToGive = CharacterIDToCostumes[playerTypeToSave][2]

        player:GetMainTwin():ChangePlayerType(PlayerType.PLAYER_JACOB)

        player:GetMainTwin():RemoveSkinCostume() --pretty sure this will do the below 2 lines and they arent nessecary
        player:GetMainTwin():GetOtherTwin():RemoveSkinCostume()
        --player:TryRemoveNullCostume(NullItemID.ID_JACOB)
        --player:TryRemoveNullCostume(NullItemID.ID_ESAU)
        
        Mod:ReplaceSkinWithCharacter(player:GetMainTwin(), CharacterIDToCostumes[playerTypeToSave][2])
        Mod:ReplaceSkinWithCharacter(player:GetMainTwin():GetOtherTwin(), CharacterIDToCostumes[playerTypeToSave][2])

        if(nullCostumeToAdd)then 
            player:GetMainTwin():AddNullCostume(CharacterIDToCostumes[playerTypeToSave][1])
            player:GetMainTwin():GetOtherTwin():AddNullCostume(CharacterIDToCostumes[playerTypeToSave][1])
        end
    end
end
function Mod:ReplaceSkinWithCharacter(player, file)
    local sprite = player:GetSprite() --print(entity:GetSprite():GetLayerCount())
    for i = 0, 14, 1 do --there are 15 layers to the characters anim2 file, 14 of which need to be replaced
        if(i ~= 13) then 
            sprite:ReplaceSpritesheet(i, "gfx/characters/costumes/" .. file)
        end
    end
    sprite:LoadGraphics()
end
function Mod:BipolarChangePlayerBack(player)
    local index = Mod:GetEntityIndex(player)
    if(Mod.DataTable[index].Bipolar ~= nil) and (Mod.DataTable[index].Bipolar[2] ~= nil) then
        player:GetMainTwin():ChangePlayerType(Mod.DataTable[index].Bipolar[2])
        --[[
        if(Mod.DataTable[index].Bipolar[2] == PlayerType.PLAYER_JACOB_B) then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_ANIMA_SOLA, true, false, true, false, -1)
        elseif(Mod.DataTable[index].Bipolar[2] == PlayerType.PLAYER_JACOB2_B) then
            player:GetMainTwin():ChangePlayerType(PlayerType.PLAYER_JACOB_B)
            --Isaac.Spawn(EntityType.ENTITY_DARK_ESAU, 0, 0, player.Position, Vector(0,0), nil)
            player:UseActiveItem(CollectibleType.COLLECTIBLE_ANIMA_SOLA, true, false, true, false, -1)
            player:GetMainTwin():ChangePlayerType(Mod.DataTable[index].Bipolar[2])
        end
        ]]
        Mod.DataTable[index].Bipolar = {0,nil}
    end
end

--just a random comment, but the graphic for tainted esau is a pretty good whole to hell looking thing, use it
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
    --player:TryRemoveNullCostume(NullItemID.ID_JACOB)
    --player:TryRemoveNullCostume(NullItemID.ID_ESAU)
    --player:ResetItemState()
    --print(player:GetCollectibleNum(81, true))
    --print(player:GetCollectibleNum(81, false))
    --player:CheckFamiliar(40, player:GetCollectibleNum(81), RNG(), Isaac.GetItemConfig():GetCollectible(81), -1)
    --player:AddCacheFlags(CacheFlag.CACHE_ALL)
    --player:EvaluateItems()
    --print(player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_DEAD_CAT))
    --print(player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_DEAD_CAT).Cooldown)
    --print(player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_DEAD_CAT).Count)
    --print(player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_DEAD_CAT).Item)
    RenderExtraLivesCounter(player, 1)
    local effects = player:GetEffects():GetEffectsList()

    pauseVars.shouldUnpause = true

    --Isaac.GetPlayer():GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_PAUSE, -1)
    --print(Isaac.GetPlayer():GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_PAUSE).Type)
    print(#effects)
    print(effects.Size)
    --print(effects:Get(0).Item.Name)
    --print(effects:Get(0).Item.Name)
    for i = 0, (#effects)-1, 1 do
        --print(effects:Get(i).Count)
        --print(effects:Get(i).Item.Tags)
        --effects:Get(i).Item.Hidden = true
        --
        print(effects:Get(i).Item.Type)
        print(effects:Get(i).Item.Name)
        print(effects:Get(i).Item.Description)
    end
    local effectsManager = player:GetEffects()
    --effectsManager:AddCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_CHILD, false)
    --effectsManager:AddTrinketEffect(TrinketType.TRINKET_BROKEN_ANKH, false, 1)
    --player:SetColor(Color(1.5,1.7,2.0,1.0,0.05,0.11,0.2), -1, 1, false, false)
end

function Mod:PillEffectABSOLUTE_CHAOS(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)

    --Mod:GlitchItem(player)
    --placeholder to check glitching items, is actually a bomb pill
    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        entity:AddEntityFlags(EntityFlag.FLAG_ICE)
    end
    
end

function Mod:PillEffectMINDBLOWING(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --player:AddEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK)

    --local club = Isaac.Spawn(8, 2, 0, player.Position+Vector(0,0), Vector(0,100), nil)
    --club.Parent = player
    --ok this club will work for tforgotten
    local entity
    local originalLink
    local forgot
    local distance = 20
    forgot = Isaac.Spawn(3, 900, 0, Vector(320,280), Vector(0,0), nil)
    print(forgot.Size)
    forgot.Size = 10
    originalLink = Isaac.Spawn(1000, 114, 0, forgot.Position+Vector(0,distance), Vector(0,0), nil)
    --originalLink:ToEffect():SetRadii(5.0, 10.0)
    originalLink:ToEffect().Scale = 60 --120 is the usual forgotten
    originalLink.Target = player --:GetOtherTwin()
    originalLink.Child = forgot
    --the thing thats chained and has its movement rescricted is the target,
    --the child will be the anchor, they are able to move freely it seems
    --and this shit is giving me a really good idea for iteams, and how judas's summoning circles have suddenly become much easier

    --.Rotation seems like the counter for which one they are, going from .1 to .9
    --.m_Height also seems weird but I cant find a pattern
    --.FallingSpeed is also similarly weird
    --.FallingAcceleration was always 1.3
    --1.0 fricition on all


    --[[
        --dont need more links, the first one automatically creates and links the others
    entity = Isaac.Spawn(1000, 114, 1, entity.Position+Vector(0,distance), Vector(0,0), originalLink)
    entity.Target = player
    entity.Child = forgot
    entity = Isaac.Spawn(1000, 114, 1, entity.Position+Vector(0,distance), Vector(0,0), originalLink)
    entity.Target = player
    entity.Child = forgot
    ]]
end

function Mod:PillEffectPSILOCYBIN(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)

    for i = 1, (horse and 10 or 5), 1 do
        player:UseActiveItem(CollectibleType.COLLECTIBLE_WAVY_CAP, true, false, true, false, -1)
    end
end

function Mod:PillEffectMYSTERY_DRUG(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    Mod:ShootYellowElectricity(player)
    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        --entity:AddEntityFlags(EntityFlag.FLAG_SLOW)
    end
    --random puddles of friendly poison spawn in the room, creating friendly poison clouds
end

function Mod:PillEffectLIQUID_CORN_STARCH(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --for 15 seconds the player produces unfriendly white creep underneath them, 
    --a baby spidersac spawns a few seconds later in the origin point (ie where isaac was when he took the pill)
    --if the player is flying they are still slowed, and have an effect that looks like they are stuck to it like pulling away glue
end

function Mod:PillEffectPHARMACEUTICAL_HEALING(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --removes a broken heart, if it does do a necronomicon effect in the current room,
    --turns into a heartbroken pill if you have no broken hearts
end

function Mod:PillEffectHEARTBROKEN(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --Gain a broken heart, changes to pharma healing if you have 6 or more broken hearts
    player:AddBrokenHearts(horse and 2 or 1)
end

function Mod:PillEffectSPEED(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    local index = Mod:GetEntityIndex(player)
    local timeToAdd = ((horse and 2 or 1) * 900)

    if(Mod.DataTable[index].SpeedPill == nil) then
        Mod.DataTable[index].SpeedPill = {timeToAdd, horse}
    else
        Mod.DataTable[index].SpeedPill[1] = Mod.DataTable[index].SpeedPill[1] + timeToAdd
        Mod.DataTable[index].SpeedPill[2] = horse
    end
    --ChampionColor.YELLOW
    --Isaac is given a burst of speed and shotspeed for a minute which later cools down to normal speed, isaac gains bonus damage for how fast his shotspeed is
    --Isaac also does pulses every 15 (10 with horse) seconds, shooting out lightning to all enemies in the current room, dealing damage relative to how fast isaac is moving 
end

function Mod:PillEffectKRAKATOA(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --shoot out a barage of explosivo shots directly up in the air, they then stick to whatever they hit and eventually explode
end

function Mod:PillEffectCRASH(pillEffect, player, flags)
    local horse = Mod:IsHorsePill(player)
    --Active item looses all charge, enemies speed set to 0, slowly speed up, all shots in room get forced to the ground
    --when the active item is discharged it turns all enemies into speed champions with a lightning shot between isaac and them
end

function Mod:ShootYellowElectricity(player)
    local laser
    for i = 1, 10, 1 do
        laser = EntityLaser.ShootAngle(2, player.Position, math.random(360), 3, Vector(0,0), player)
        laser:SetColor(Color(1.0, 1.0, 1.0, 0.75, 1.0, 1.0, 0.0), -1, 1, false, false)
        laser:SetColor(Color(1.0, 1.0, 1.0, 5.0, 1.0, 1.0, 0.0), 2, 1, true, false)
        laser.SubType = LaserSubType.LASER_SUBTYPE_LINEAR
        laser.MaxDistance = math.random(50,100)
    end
end

function Mod:MawOfTheVoid(position, player)
    local laser = EntityLaser.ShootAngle(3, player.Position, 30.0, 300, Vector(0,0), player)
    --TODO: sound, pulse, make it acutally go on a position, etc
    laser:GetSprite():Load("gfx/spook_laser.anm2", true)
    laser:GetSprite():LoadGraphics()
    laser:GetSprite():Play("LargeRedLaser")
    --laser:Update()
    laser.CollisionDamage = 1
    laser.Radius = 160
    laser.SubType = LaserSubType.LASER_SUBTYPE_RING_FOLLOW_PARENT
    laser:AddTearFlags()--TearFlags.TEAR_HOMING)
    --laser.CurveStrength = .5

    --Noral brimstone particle effects that happen when its going through stuff and the particles you see are:
    --many 1000.99.1
    --a faw 1000.21.10
end

--please do not tell me this shits gotta change when I add unlocks
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPILLPOCALYPSE, ModPillEffects.PILLPOCALYPSE)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPILLCOLLAPSE, ModPillEffects.PILLCOLLAPSE)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPETRIFICATION, ModPillEffects.PETRIFICATION)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectLEPROSY, ModPillEffects.LEPROSY)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPARANOIA, ModPillEffects.PARANOIA)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectMETH, ModPillEffects.METH)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectXANNY, ModPillEffects.XANNY)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectFLAX, ModPillEffects.FLAX)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectXXLAX, ModPillEffects.XXLAX)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectCLOTTING_AGENT, ModPillEffects.CLOTTING_AGENT)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPHANTOM_PAINS, ModPillEffects.PHANTOM_PAINS)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectSEEING_RED_GOOD, ModPillEffects.SEEING_RED_GOOD)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectSEEING_RED_BAD, ModPillEffects.SEEING_RED_BAD)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectTHC, ModPillEffects.THC)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectJESUS_PILLS, ModPillEffects.JESUS_PILLS)
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
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectDUKE_PHEROMONES, ModPillEffects.DUKE_PHEROMONES)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectCALCIFICATION, ModPillEffects.CALCIFICATION)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectACETOMETAPHIN, ModPillEffects.ACETOMETAPHIN)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectPARACETOMOL, ModPillEffects.PARACETOMOL)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectBIPOLAR, ModPillEffects.BIPOLAR)
--Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectI_FOUND_BIG_PILLS, ModPillEffects.I_FOUND_BIG_PILLS)
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
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectLIQUID_CORN_STARCH, ModPillEffects.LIQUID_CORN_STARCH)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectKRAKATOA, ModPillEffects.KRAKATOA)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.PillEffectCRASH, ModPillEffects.CRASH)
Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.UsePill)

function Mod:InputAction(entity, inputHook, buttonAction)
    if (buttonAction ~= ButtonAction.ACTION_SHOOTRIGHT) then return end
    if(pauseVars.shouldUnpause) then
        pauseVars.shouldUnpause = false
        print("unpausing?")
        return 1
    end
end
Mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, Mod.InputAction, InputHook.GET_ACTION_VALUE)



--for methamphetamines, the devil deal counter could work by doing the on collision thing iwth pickups, 
--see if it has a cost, and then seeing if later isaac has the item in his queued inventory


--[[
function Mod:PostEntityRemove(entity, entityType)
    
    local index = Mod:GetEntityIndex(player)
	local petrifiedHearts = Mod.DataTable[index].PetrifiedHeartSlots

    if(Mod.DataTable[index].PetrificationPillsTaken == nil) then
        Mod.DataTable[index].PetrificationPillsTaken = 1
    else
        Mod.DataTable[index].PetrificationPillsTaken = Mod.DataTable[index].PetrificationPillsTaken + 1
    end

    if(Mod.DataTable[index].PetrifiedHeartSlots == nil) then 
        Mod.DataTable[index].PetrifiedHeartSlots = {}
    end

    for i=1,maxHealth,1 do
        Mod.DataTable[index].PetrifiedHeartSlots[i] = true
    end

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

function Mod:ForceCloseDoors()
    if(#Isaac.GetRoomEntities() > 0 ) then
        local room = Game:GetRoom()
        local door
        for i=0, 8, 1 do
            door = room:GetDoor(i)
            if(door ~= nil) then
                door:Close(true)
            end
        end
    end
end

function Mod:PreSpawnCleanAward(RNG, SpawnPosition)
    local currentRoom = Game:GetRoom()
    if(currentRoom:IsCurrentRoomLastBoss()) then
        local level = Game:GetLevel()
        Mod.DataTable.CheckForDeal = 3
        for playerNum = 1, Game:GetNumPlayers() do
            local player = Game:GetPlayer(playerNum - 1)
            local index = Mod:GetEntityIndex(player)

            if(Mod.DataTable[index].ExtraVanishingTwins ~= nil) then 
                Mod.DataTable[index].ExtraVanishingTwins = 0
                player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
                player:EvaluateItems()
            end
        end
        if(Mod:IsBasement1()) then
            if(Game.TimeCounter <= 1800 and trueStageTime > 1800) then
                Game:GetLevel():SetStateFlag(LevelStateFlag.STATE_SHOVEL_QUEST_TRIGGERED, true)
                SFXManager():Play(SoundEffect.SOUND_MOM_FOOTSTEPS, 1, 2, false, 1)
                SFXManager():Play(SoundEffect.SOUND_MOM_VOX_FILTERED_ISAAC, 1, 2, false, 1)
            end
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, Mod.PreSpawnCleanAward)

function Mod:CheckForDealDoor()
    local room = Game:GetRoom()
    local door

    for slot = 1, DoorSlot.NUM_DOOR_SLOTS, 1 do
        door = room:GetDoor(slot-1)
        if(door ~= nil and (door.TargetRoomType == RoomType.ROOM_DEVIL or door.TargetRoomType == RoomType.ROOM_ANGEL)) then
            return true
        end
    end
    return false
end

function Mod:IsBasement1()
    --curse you downpour and dross 1 for also being LevelStage.STAGE1_1
    
    local backdrop = Game:GetRoom():GetBackdropType()
    return (Game:GetLevel():GetStage() == LevelStage.STAGE1_1) and (Game:GetLevel():GetStageType() ~= StageType.STAGETYPE_REPENTANCE)
    --and ((backdrop == BackdropType.BASEMENT) or (backdrop == BackdropType.CELLAR) or (backdrop == BackdropType.BURNING_BASEMENT))
end

function Mod:PrePickupCollision(pickup,collider,isAggressor)
    if not collider:ToPlayer() then return end
	local player = collider:ToPlayer()
    
    if((Game:GetRoom():GetType() == RoomType.ROOM_DEVIL) 
    and (pickup.Price ~= 0) 
    and (pickup.Price > -10)
    and (player:IsItemQueueEmpty())) then
        player:GetData()["CheckDevilPurchase"] = pickup.SubType
        --player:GetData()["DevilDealsTaken"] = player:GetData()["DevilDealsTaken"] + 1
    end
    
end

Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Mod.PrePickupCollision)


function Mod:CheckFamiliar(player, collectibleType, additionalTargetCount, familiarVariant, familiarSubType)
    local itemConfigItem = Isaac.GetItemConfig():GetCollectible(collectibleType)

    local numCollectibles = player:GetCollectibleNum(collectibleType)
    local effects = player:GetEffects()
    local numCollectibleEffects = effects:GetCollectibleEffectNum(collectibleType)
    local targetCount = numCollectibles + numCollectibleEffects + additionalTargetCount

    player:CheckFamiliar(familiarVariant, targetCount, RNG(), itemConfigItem, familiarSubType)
end


function Mod:PostNewRoom()
    for i = 0, (Game:GetNumPlayers() - 1), 1 do
		local player = Isaac.GetPlayer(i)
		local index = Mod:GetEntityIndex(player)

        if(Mod.DataTable[index].THC ~= nil and Mod.DataTable[index].THC > 0) then
            Mod:ApplyTHCItems(player)
        end
    end
    for i, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0)) do
        entity:ToEffect():SetTimeout(100+math.floor(math.random()*100))
        entity:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
    end
    for i, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 1)) do
        entity:ToEffect():SetTimeout(50+math.floor(math.random()*50))
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Mod.PostNewRoom)

function Mod:PostNewLevel()
    local level = Game:GetLevel()
    local stage = level:GetStage()
    local stageType = level:GetStageType()
    if (Mod:IsBasement1()) then
        Mod.DataTable.LastNaturalDevilRoom = 0
    end

    if(Mod.DataTable.LastNaturalDevilRoom ~= nil) then --check because otherwise it errors if reloaded through console
        if(Mod.DataTable.PreviousStageType ~= nil)then
            if(Mod.DataTable.PreviousStageWasLabyrinth ~= nil and Mod.DataTable.PreviousStageWasLabyrinth) then
                --print("was lab")
                Mod.DataTable.LastNaturalDevilRoom = Mod.DataTable.LastNaturalDevilRoom + 1
                Mod.DataTable.PreviousStageWasLabyrinth = false
            end
            if(stageType == StageType.STAGETYPE_REPENTANCE) or (stageType == StageType.STAGETYPE_REPENTANCE_B) then --downpour/mines/ets
                if(Mod.DataTable.PreviousStageType ~= StageType.STAGETYPE_REPENTANCE) or (Mod.DataTable.PreviousStageType ~= StageType.STAGETYPE_REPENTANCE_B)then --no to rep
                    --print("Normal to rep")
                    --Mod.DataTable.LastNaturalDevilRoom = math.max(Mod.DataTable.LastNaturalDevilRoom - 1, 0)
                end
            elseif(Mod.DataTable.PreviousStageType == StageType.STAGETYPE_REPENTANCE) or (Mod.DataTable.PreviousStageType == StageType.STAGETYPE_REPENTANCE_B) then --rep to no
                --print("rep to normal")
                Mod.DataTable.LastNaturalDevilRoom = Mod.DataTable.LastNaturalDevilRoom + 1
            end
        end
        --print("was repentance:")
        --print(tostring((Mod.DataTable.PreviousStageType == StageType.STAGETYPE_REPENTANCE) or (Mod.DataTable.PreviousStageType == StageType.STAGETYPE_REPENTANCE_B)))
        --print(tostring(Mod.DataTable.PreviousStageType))

        if(Mod.DataTable.JesusPillsChangedStage ~= nil and Mod.DataTable.JesusPillsChangedStage)then
            Mod.DataTable.JesusPillsChangedStage = nil
        end
        Game:SetLastDevilRoomStage(Mod.DataTable.LastNaturalDevilRoom)

        Mod.DataTable.PreviousStageType = level:GetStageType()
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Mod.PostNewLevel)

function Mod:OnMonsterDamage(entity, DamageAmount, DamageFlags, DamageSource)
    local data = entity:GetData()
    if(entity:ToNPC() ~= nil) then
        if data.BasedAndRedPilled ~= nil then
            if(math.random() < .15) then --if the sounds get too much i can make it so it also checks if its already playing
                entity:ToNPC():PlaySound(SoundEffect.SOUND_LARYNX_SCREAM_LO,0.8,2,false,0.7)
            end
        end
        --[[
        if(DamageAmount > entity.HitPoints) then --if enemy will die
            if(entity:ToNPC():IsBoss()) then
                if(Mod:IsPostmarkBoss(entity)) then
                    print("Fatal damage detected")
                    local player
                    local index
                    for playerNum = 1, Game:GetNumPlayers() do
                        player = Game:GetPlayer(playerNum - 1)
                        index = Mod:GetEntityIndex(player)
                        
                        if(Mod.DataTable[index].Bipolar ~= nil) and (Mod.DataTable[index].Bipolar[2] ~= nil) then
                            Mod:BipolarChangePlayerBack(player)
                        end
                    end
                end
            end
        end
        ]]
    end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Mod.OnMonsterDamage)

function Mod:JandEUnlockCheesePrevention(entity)
    if(entity:ToNPC() ~= nil) then
        if(entity:ToNPC():IsBoss()) then
            if(Mod:IsPostmarkBoss(entity)) then
                local player
                local index
                for playerNum = 1, Game:GetNumPlayers() do
                    player = Game:GetPlayer(playerNum - 1)
                    index = Mod:GetEntityIndex(player)
                    
                    if(Mod.DataTable[index].Bipolar ~= nil) and (Mod.DataTable[index].Bipolar[2] ~= nil) then
                        Mod:BipolarChangePlayerBack(player)
                    end
                end
            end
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, Mod.JandEUnlockCheesePrevention)

function Mod:IsPostmarkBoss(entity)
    local type = entity.Type
    --TODO: check for floors aswell
    return ((type == EntityType.ENTITY_MOM) or 
    (type == EntityType.ENTITY_MOMS_HEART) or 
    (type == EntityType.ENTITY_SATAN) or 
    (type == EntityType.ENTITY_ISAAC) or 
    (type == EntityType.ENTITY_MEGA_SATAN_2) or 
    (type == EntityType.ENTITY_THE_LAMB) or 
    (type == EntityType.ENTITY_MOTHER) or 
    (type == EntityType.ENTITY_DELIRIUM) or 
    (type == EntityType.ENTITY_HUSH) or 
    (type == EntityType.ENTITY_BEAST and entity.Variant == 0) or 
    (type == EntityType.ENTITY_ULTRA_GREED) or 
    (Game:GetLevel():GetCurrentRoomDesc().Data.Shape == RoomShape.ROOMSHAPE_2x2)) --should work for boss rush and i guess delerium too
    --i dont think there are any other bosses that are in 2x2 rooms so this should basically only fire for boss rush
    --TODO: see if only doing this on the 15th wave is possible

    
    --uhh i dunno how to get boss rush, probs by looking for room id or something
end


function Mod:GlitchItem(player) 
    if(player:HasCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)) then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false)
    else
        player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false)
        player:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
    end
end



--[[
-- Constants
local TEXT_X = 60
local TEXT_Y = 90
local WHITE = KColor(1, 1, 1, 1)

-- Mod variables
local messageArray = {}
local font = Font()
font:Load("font/terminus.fnt")
local lineHeight = font:GetLineHeight()
local sfxManager = SFXManager()

-- From: https://stackoverflow.com/questions/33510736
local function includes(t, val)
  for index, value in ipairs(t) do
    if value == val then
      return true
    end
  end

  return false
end

local function pushMessageArray(msg)
  messageArray[#messageArray + 1] = msg
  if #messageArray > 10 then
    -- We only want to show 10 messages at a time
    -- Remove the first elemenent
    table.remove(messageArray, 1)
  end
end

-- ModCallbacks.MC_POST_RENDER (2)
function Mod:PostRenderSS()
    Mod:RecordPlayingSounds()
    Mod:RenderTextSS()
end

function Mod:RecordPlayingSounds()
  for soundEffectName, soundEffect in pairs(SoundEffect) do
    if sfxManager:IsPlaying(soundEffect) then
      local message = tostring(soundEffect) .. " - " .. soundEffectName
      if not includes(messageArray, message) then
        pushMessageArray(message)
      end
    end
  end
end

function Mod:RenderTextSS()
  for i, msg in ipairs(messageArray) do
    font:DrawStringUTF8(
      msg,
      TEXT_X,
      TEXT_Y + ((i - 1) * lineHeight),
      WHITE,
      0,
      true
    )
  end
end

Mod:AddCallback(ModCallbacks.MC_POST_RENDER, Mod.PostRenderSS)
]]