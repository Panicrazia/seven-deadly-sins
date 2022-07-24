local pills = {}

function pills:IsHorsePill(player)
    return (player:GetPill(0) >= 2048)
end

function pills.PillEffectPILLPOCALYPSE(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
    --turns all drops in room into pills, idk if this should ignore unopened chests or not
    --horse version changes items into pill based items
    --[[
    phd 75
    moms bottle of pills 102
    forget me now 127
    moms coin purse 195
    lil baggy 252
    caffine pill 340
    placebo 348
    plan C 475
    acid baby 491
    lil spewer 537
    false phd 654
    maybe all the syringes too?
    virus 13
    roid rage 14
    growth hormones 70
    speed ball 143
    experimental treatment 240
    synthoil 345
    adrenaline 493
    euthanasia 496
    ]]--
    local entities = Isaac.FindByType(EntityType.ENTITY_PICKUP)
    local newPillID = 0
    local pocalypseID = player:GetPill(0)
    if player:GetPill(0) >= 2048 then 
        pocalypseID = pocalypseID - 2048
    end
    for key, entity in pairs(entities) do
        if(horse and (entity.Variant == 100)) then
            --change items
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

function pills.PillEffectPILLCOLLAPSE(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectPETRIFICATION(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectLEPROSY(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectMETH(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectXANNY(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectFLAX(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectXXLAX(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectOOBE(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectPHANTOM_PAINS(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectSEEING_RED_GOOD(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectSEEING_RED_BAD(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectTHC(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectGBPILLS(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectPLAN_B(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectROSE_TINTED(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectDEMENTIA(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectSPIRIT_SALTS(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectBATH_SALTS(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectIMMAGINARY_FRIENDS(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectSEEING_GOLD_GOOD(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectSEEING_GOLD_BAD(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectFRIENDS_TO_THE_VERY_END(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectSWORN_ENEMIES(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectCALCIFICATION(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectACETOMETAPHIN(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectPARACETOMOL(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectBIPOLAR(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectI_FOUND_BIG_PILLS(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectDIURETICS(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectSOMETHINGS_REALLY_WRONG(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectWEIGHT_GAIN_SUPPLEMENTS(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectWEIGHT_LOSS_SUPPLEMENTS(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectABSOLUTE_CHAOS(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectMINDBLOWING(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectPSILOCYBIN(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectMYSTERY_DRUG(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectSPEED(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectPHARMACEUTICAL_HEALING(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectHEARTBROKEN(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end

function pills.PillEffectCRASH(pillEffect, player, flags)
    local horse = pills:IsHorsePill(player)
end
