LUAGUI_NAME = "kh1fmAP_flag_fixes"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Flag Fixes"

local offset = 0x3A0606
local btltbl = 0x2D1F3C0 - offset
local itemTable = btltbl+0x1A58
local weaponTable = btltbl+0x94F8
local soraStatTable = btltbl+0x3AC0
local donaldStatTable = soraStatTable+0x3F8
local goofyStatTable = donaldStatTable+0x198
local soraAbilityTable = btltbl+0x3BF8
local soraAbilityTable2 = soraAbilityTable-0xD0
local soraAbilityTable3 = soraAbilityTable-0x68
local donaldAbilityTable = soraAbilityTable+0x328
local goofyAbilityTable = donaldAbilityTable+0x198
local rewardTable = btltbl+0xC6A8
local chestTable = 0x5259E0 - offset
local shopTableBase = 0x4FB374 - offset
local synthRequirements = 0x544320 - offset
local synthItems = synthRequirements + 0x1E0

local chestsOpened = 0x2DE5E00 - offset
local summonsReturned = 0x2DE66FC - offset
local summons = 0x2DE61A0 - offset
local inventory = 0x2DE5E6A - offset
local tornPageCount = 0x2DE6DD0 - offset
local poohProgress = 0x2DE7718 - offset
local poohProgress2 = 0x2DE6DF0 - offset
local emblemCount = 0x2DE787D - offset
local slides = 0x2DE6BD7 - offset
local slideActive = 0x2D3CA70 - offset
local evidence = 0x2DE67D8 - offset
local evidenceActiveForest = 0x2D39B90 - offset
local evidenceActiveBizarre = 0x2D39230 - offset
local khamaActive = 0x2D34730 - offset
local theonActive = 0x2D35EA0 - offset
local emblemDoor = 0x2DE788C - offset
local minigameStatus = 0x2DE73A5 - offset
local gummiInventory = 0x2DF1848 - offset
local reports = 0x2DE7390 - offset

--local TTWarp = 0x5229B0+0x9B570C+6
local worldWarps = 0x50B940 - offset
local worldFlagBase = 0x2DE79D0+0x6C - offset
local gummiFlagBase = 0x2DE78C0 - offset
local worldMapLines = 0x2DE78E2 - offset
local gummiselect = 0x503CEC - offset
local inGummi = 0x504218 - offset
local battleLevel = 0x2DE7394 - offset
local unlockedWarps = 0x2DE78D6 - offset
local warpCount = 0x50BA30 - offset
local cutsceneFlags = 0x2DE65D0-0x200 - offset
local libraryFlag = 0x2DE7AF3 - offset
local scriptPointer = 0x23944B8 - offset
local OCCupUnlock = 0x2DE77D0 - offset
local OCCupDialog = 0x23966B0 - offset
local ardoffset = 0x2394BB0 - offset
local ardoffsetClock = 0x2394F10 - offset
local textBox = 0x23D09E4 - offset
local cupCurrentSeed = 0x2389480 - offset
local waterwayGate = 0x2DE763D - offset
local waterwayTrinity = 0x2DE7681 - offset
local currentTerminus = 0x2392964 - offset
local terminusTeleUsable = 0x23928A4 - offset --On: 0000111A Off: FFFFD8F0
local terminusTeleVisible = 0x2674AC8 - offset --On: 4588D000 Off: C61C4000
local speedup = 0x233C24C - offset
local sliderProgress = 0x2DE7709 - offset
local savedFruits = 0x2DE770E - offset
local minigameTimer = 0x232A684 - offset
local collectedFruits = minigameTimer + 4
local unequipBlacklist = 0x541FA0 - offset
local tutorialFlag = 0x2DE7394 - offset
local oppositeState = 0x2DE7688 - offset
local oppositeTrigger = 0x2DE66ED - offset

local chronicles = 0x2DE7367 - offset
local journalCharacters = 0x2DE70B3 - offset

local infoBoxNotVisible = 0x23D0890 - offset
local preventMenu = 0x232A60C - offset
local blackfade = 0x4D93B8 - offset
local enableRC = 0x2DE6244 - offset
local lockMenu = 0x232A60C - offset
local party1 = 0x2DE5E5F - offset
local party2 = 0x2E1CBE5 - offset
local soraHUD = 0x280EB1C - offset
local stateFlag = 0x2863958 - offset
local magicUnlock = 0x2DE5A44 - offset
local magicLevels = magicUnlock + 0x41E
local magicFlags = 0x2DE75EE - offset
local shortcuts = 0x2DE6214 - offset
local trinityUnlock = magicUnlock + 0x1BA7
local world = 0x233CADC - offset
local room = world + 0x68
local soraCurAbilities = 0x2DE5A14 - offset
local sharedAbilities = 0x2DE5F69 - offset
local soraPointer = 0x2534680 - offset
local soraJumpHeight = 0x2D592A0 - offset
local jumpHeights = 0x2D1F46C - offset
local mermaidKickSpeed = 0x3ED5FC - offset
local soraHP = 0x2D592CC - offset
local superglideSpeedHack = 0x2AE2B4 - offset

local soraStats = 0x2DE59D0 - offset
local donaldStats = soraStats + 0x74
local goofyStats = donaldStats + 0x74
local experienceMult = 0x2D59180 - offset

local gotoWorldMap = 0x2E1CC24 - offset
local startGameWarpHack = 0x38C315 - offset
local worldMapTriggerFlag = 0x2DE6ED0 - offset
local openMenu = 0x2350CD4 - offset
local closeMenu = 0x2E90820 - offset
local menuCheck = 0x2E8EE98 - offset
local input = 0x233D034 - offset
local menuState = 0x2E8F268 - offset
local report1 = 0x1D03584 - offset
local language = 0x2E17BAB - offset
local worldWarp = 0x233CB70 - offset
local roomWarp = worldWarp + 4
local roomWarpRead = 0x232A588 - offset
local warpTrigger = 0x22E86DC - offset
local warpType1 = 0x233C240 - offset
local warpType2 = 0x22E86E0 - offset
local warpDefinitions = 0x232A580 - offset
local RCName = 0x2863390 - offset

local itemDropID = 0x2849FC8 - offset
local textsBase = 0x2EE03B0 - offset
local textPointerBase = 0x2B98900 - offset
local textPos = 0
local idFind = 0
local idReplace = 0
local textFind = ""
local nextTextFind = ""
local textReplace = ""
local nextTextReplace = ""
local magicTexts = {"fire.","ice.","thunder.","healing.","stars.","time.","wind."}
local magicTexts2 = {"Fire","Blizzard","Thunder","Cure","Gravity","Stop","Aero"}
local trinityTexts = {"Blue Trinity", "Red Trinity", "Green Trinity", "Yellow Trinity", "White Trinity"}
local abilityNames = {"High Jump", "Mermaid Kick", "Glide", "Superglide"}
local infoBoxWas = 1

local trinityTable = {}
local magicShuffled = {}
local perMagicShuffle = {}
local magicUpdater = {}
local inventoryUpdater = {}
local gummiUpdater = {}
local sliderSavedProg = {0,0,0,0,0}
local dodgeDataAddr = 0
local reportUpdater = 0
local bufferRemove = 0
local bufferRemoveTimer = 10
local HUDWas = 0
local menuWas = 0
local removeBlackTimer = 0
local prevBlack = 128
local prevWorld = 0
local prevRoom = 0
local prevTTFlag = 0
local OCTextFix = 0
local introJump = true

local important = {0xBC, 0xBD, 0xBE, 0xBF, 0xC0, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xCD, 0xE5}
local shopPool = {}
local gummiNames = {}
local itemNames = {}
local chestDetails = {}
local rewardDetails = {}
local vanillaChests = {}
local vanillaRewards = {}
local itemids = {}
local rewards = {}
local soraLevels = {}
local soraAbilities = {}
local soraAbilities2 = {}
local soraAbilities3 = {}
local donaldLevels = {}
local donaldAbilities = {}
local goofyLevels = {}
local goofyAbilities = {}
local weaponStr = {}
local weaponMag = {}
local itemData = {}
local shops = {}
local synths = {}
local chests = {}
local itemsAvailable = {}
local abilitiesAvailable = {}
local magicAvailable = {}
local reportData = {}
local dalmatiansAvailable = 0
local seedstring = ""
local randomized = false
local successfulRando = true
local isValidSeed = false
local initDone = false
local infiniteDetection = 0
local canExecute = false

local checksDebug = {}
local checksDebug2 = {}
local sets = {}

function FlagFixes()
    if ReadByte(world) == 0 and ReadByte(room) == 0 and ReadByte(cutsceneFlags+0xB01) == 0xA then
        WriteByte(cutsceneFlags+0xB01, 0xD)
        WriteByte(warpType1, 7)
        WriteByte(warpType2, 6)
        WriteByte(warpTrigger, 2)
        WriteLong(0x25346D0-offset, 0) -- Fixes InstantGummi
    end

    if ReadByte(world) == 1 and ReadFloat(soraHUD) > 0 and ReadInt(inGummi) == 0 then
        WriteByte(party1, 0xFF)
        WriteByte(party1+1, 0xFF)
    end

    -- Reset TT to avoid softlocks
    if ReadByte(cutsceneFlags+0xB04) < 0x14 and ReadByte(world) > 3 then
        WriteByte(cutsceneFlags+0xB04, 0)
        WriteByte(worldFlagBase+0x1C, 2)
    end

    -- Secret waterway Leon unmissable
    if ReadByte(cutsceneFlags+0x312) == 0 and ReadByte(cutsceneFlags+0xB04) >= 0x31 then
        WriteByte(cutsceneFlags+0xB04, 0x31)
        WriteByte(worldFlagBase+0x32, 2)
    end
    
    -- Skip TT2
    if ReadByte(cutsceneFlags+0xB04) == 0x3E then
        WriteByte(cutsceneFlags+0xB04, 0x4E)
        WriteByte(worldFlagBase+0x1C, 5)
    end
    
    if ReadByte(cutsceneFlags+0xB04) ~= prevTTFlag then
        --ConsolePrint(string.format("%x, %x", prevTTFlag, ReadByte(cutsceneFlags+0xB04)))
    end
    -- Revert HB1 effect on TT story
    if (ReadByte(cutsceneFlags+0xB04) == 0x6E and ReadByte(worldFlagBase+0x1C) ~= 5)
                                            or ReadByte(cutsceneFlags+0xB04) == 0x96 then
        WriteByte(cutsceneFlags+0xB04, prevTTFlag)
    end
    
    if ReadByte(cutsceneFlags+0xB0E) >= 0xA0 and ReadByte(worldFlagBase+0x1C) == 5
                                            and ReadByte(cutsceneFlags+0xB04) < 0x6E then
        WriteByte(cutsceneFlags+0xB04, 0x6E)
        WriteByte(cutsceneFlags+0xB00, math.max(0xBE, ReadByte(cutsceneFlags+0xB00)))
        --ConsolePrint("Post HB TT")
    end

    prevTTFlag = ReadByte(cutsceneFlags+0xB04)
    
    if ReadByte(oppositeState) >= 5 then
        WriteByte(oppositeTrigger, 0)
    end
    
    if ReadByte(world) == 3 and ReadByte(room) == 0x13 then
        local simbaAddr = ReadLong(scriptPointer) + 0x131C8
        local earthshine = -0x423B
        if ReadInt(simbaAddr, true) == 0x53090000 then
            simbaAddr = simbaAddr + 0x460 --Spanish
        elseif ReadInt(simbaAddr, true) == 0x01400500 then
            simbaAddr = simbaAddr + 0x10B0 --German
        elseif ReadInt(simbaAddr, true) == 0x6D090000 then
            simbaAddr = simbaAddr - 0x1F68 --Japanese
            earthshine = -0x4227
        end
        if ReadByte(simbaAddr, true)==5 then
            local hasSummons = {}
            local hasAll = true
            for i=0,5 do
                hasSummons[ReadByte(summons+i)] = true
                hasAll = hasAll and ReadByte(summons+i) < 0xFF
            end
            
            WriteByte(summonsReturned, hasSummons[1] and 1 or 0)
            WriteByte(summonsReturned+1, hasSummons[0] and 1 or 0)
            WriteByte(summonsReturned+2, hasSummons[4] and 1 or 0)
            WriteByte(summonsReturned-1, hasSummons[5] and 1 or 0)
            
            local c = ReadByte(inventory+0xD0) > 0
            local genie = ReadByte(inventory+0x88) > 0
            local tbell = ReadByte(inventory+0x8B) > 0

            -- Nullify normal simba acqusition
            WriteInt(simbaAddr+4, c and 0x18000238 or 0x18000004, true)
            WriteInt(simbaAddr+12, c and 0x18000233 or 0x18000004, true)
            -- Replace another summon with Simba
            WriteByte(simbaAddr+earthshine, c and 0xD1 or 0xCF, true)
            WriteByte(simbaAddr+0x16FB, c and 0xD1 or 0xCF, true)
            WriteByte(simbaAddr+0x164B, c and 5 or 1, true)
            WriteByte(simbaAddr+0x164B+8, c and 5 or 1, true)
        end
    end
    
    if ReadByte(world) == 8 and ReadByte(room) == 0x12 and ReadShort(ardoffset) == 0x7F then
        WriteShort(ardoffset, 0xD1)
        --ConsolePrint("Removed normal genie")
    end
    
    if ReadByte(world) == 0xD and ReadByte(room) == 9 and ReadShort(ardoffsetClock) == 0x5F2 then
        WriteShort(ardoffsetClock, 0x628)
        --ConsolePrint("Removed normal tinker bell")
    end

    if ReadByte(cutsceneFlags+0xB04) >= 0x31 then
        WriteByte(worldFlagBase+0x26, 2) -- Cid in accessory shop
        WriteByte(worldFlagBase+0x1D, 3)
    end
    if ReadByte(cutsceneFlags+0xB09) < 0x14 then -- Fix monstro DI cutscene softlock
        WriteByte(cutsceneFlags+0xB09, 0x14)
    end

    -- Shorten solo and time trial
    if ReadByte(world) == 0xB then
        if (ReadShort(cupCurrentSeed) == 0x0101 or ReadShort(cupCurrentSeed) == 0x0B0B)
        and ReadFloat(soraHUD) > 0 and (ReadByte(party1) == 0xFF or ReadInt(minigameTimer) > 0) then
            WriteShort(cupCurrentSeed, ReadShort(cupCurrentSeed) == 0x0101 and 0x0909 or 0x1212)
        elseif ReadByte(world) == 0xB and ReadByte(room) == 1 then
            WriteInt(minigameTimer, 0)
        end

        --for i=0,3 do
        --    if ReadByte(OCCupUnlock+i) ~= 0xA and ReadByte(OCCupUnlock+i) ~= 1 then
        --        WriteByte(OCCupUnlock+i, 0x0A) -- Unlock cups
        --    end
        --end
        
        --if ReadInt(OCCupDialog) == 0xF9 and ReadByte(room) == 1 then
        --    WriteInt(OCCupDialog, 0x290)
        --    OCTextFix = 60
        --elseif OCTextFix > 0 and ReadInt(OCCupDialog) > 0x290 then
        --    WriteFloat(textBox, ReadFloat(textBox) > 0 and 155 or -110)
        --    WriteFloat(textBox+0x50, 160)
        --    OCTextFix = 0
        --end
        
        -- Require Entry Pass
        if ReadByte(cutsceneFlags+0xB06) == 0x10 then
            WriteByte(worldFlagBase+0x94, ReadByte(inventory+0xE4) > 0 and 3 or 2)
        end
    end

    if (ReadByte(waterwayGate) // 0x80) % 2 == 0 then
        WriteByte(waterwayGate, ReadByte(waterwayGate)+0x80)
    end
    
    if (ReadByte(waterwayTrinity) // 0x20) % 2 == 0 then
        WriteByte(waterwayTrinity, ReadByte(waterwayTrinity)+0x20)
    end
    
    if ReadByte(worldFlagBase+0x36) >= 0 then
        if (ReadByte(chestsOpened+0x1F8)//2) % 2 == 0 then
            WriteByte(worldFlagBase+0x36, 0xD)
        elseif (ReadByte(chestsOpened+0x1F8)//4) % 2 == 0 then
            WriteByte(worldFlagBase+0x36, 0xE)
        elseif (ReadByte(chestsOpened+0x1F8)//8) % 2 == 0 then
            WriteByte(worldFlagBase+0x36, 0x10)
        end
    end
    
    if ReadByte(world) == 3 and ReadByte(room) == 2 and ReadByte(cutsceneFlags+0xB04) == 0x23 then
        WriteByte(unequipBlacklist, ReadByte(soraStats+0x36))
    else
        for i=0,3 do
            WriteByte(unequipBlacklist + (i*4), 0)
        end
    end

    if ReadInt(inGummi) > 0 then
    --    if ReadByte(gummiselect)==3 then
    --        --WriteShort(worldWarps+0x18, 1) -- Add DI warp
    --        if (ReadByte(unlockedWarps-7) // 8) % 2 == 0 then
    --            WriteByte(unlockedWarps-7, math.max(ReadByte(unlockedWarps-7)+8, 9))
    --        end
    --        WriteByte(warpCount+4*3, 4)
    --    else
    --        WriteShort(worldWarps+0x18, 4) -- Revert to Wonderland
    --    end
    --
        if ReadByte(gummiselect) == 3 and ReadByte(cutsceneFlags+0xB04) < 0x31 then
            WriteByte(party1, 0xFF)
            WriteByte(party1+1, 0xFF)
        elseif ReadByte(gummiselect) == 0xF and ReadByte(cutsceneFlags+0xB0E) < 0x31
                                            and ReadByte(cutsceneFlags+0xB0E) >= 0x1E then
            WriteByte(party1, 9)
            WriteByte(party1+1, 0xFF)
            WriteByte(party2, 9)
            WriteByte(party2+1, 0xFF)
        elseif ReadByte(party1) >= 9 then
            for i=0,1 do
                WriteByte(party1+i, i+1)
                WriteByte(party2+i, i+1)
            end
        end

        if ReadByte(lockMenu) > 0 then
            WriteByte(lockMenu, 0) -- Unlock menu
        end

        if ReadByte(enableRC) ~= 0x0 then
            WriteByte(enableRC, 0x0)
        end
        
        if ReadByte(reports+4) == 0 then
            WriteByte(reports+4, 0xE)
        end
        
        if (ReadByte(tutorialFlag) // 0x10) % 2 == 0 then
            WriteByte(tutorialFlag, ReadByte(tutorialFlag)+0x10)
        end
    end
    
    -- Shop upgrades
    local clearedWorlds = 0
    for i=1, 9 do
        if ReadByte(chronicles+(i*4)) == 0x20 then
            clearedWorlds = clearedWorlds + 1
        end
    end
    for i=0,6 do
        local baseCount = i <= 3 and 4 or 2
        WriteInt(shopTableBase+(i*0xD4)-4, baseCount+(clearedWorlds*2))
    end
    
    -- if ReadByte(world) == 1 and ReadByte(blackfade)>0 then -- DI Day2 Warp to EotW
        -- local warpAddr = ReadLong(scriptPointer)+0x6F9D
        -- if ReadByte(warpAddr, true)==2 and ReadByte(warpAddr+4, true)==1 then
            -- ConsolePrint("DI to EotW warp")
            -- WriteByte(warpAddr,0x10, true)
            -- WriteByte(warpAddr+4,0x1E, true)
            -- WriteByte(party1, 1)
            -- WriteByte(party1+1, 2)
        -- end
    -- end
    
    if ReadByte(world) == 1 and ReadByte(blackfade)>0 and ReadByte(worldFlagBase+0xA) == 2 then -- DI Day2 Warp to EotW
        RoomWarp(0x10, 0x42)
        WriteByte(party1, 1)
        WriteByte(party1+1, 2)
        WriteByte(worldFlagBase+0xA, 0)
        if ReadByte(cutsceneFlags+0xB0F) >= 0x5A then
            WriteByte(cutsceneFlags+0xB0F, 0)
        end
    end
    
    if ReadByte(cutsceneFlags+0xB0D) == 0x64 then
        RoomWarp(0xD, 0x27)
        WriteByte(cutsceneFlags+0xB0D, 0x6A)
    end
    
    -- if ReadByte(cutsceneFlags+0xB0D) == 0x64 then -- Skip HB cutscene at end of Neverland
        -- local warpAddr = ReadLong(scriptPointer)+0x677D
        -- if ReadByte(warpAddr, true)==0xF and ReadByte(warpAddr+4, true)==0xB and ReadByte(blackfade)>0 then
            -- ConsolePrint("Skipping HB cutscenes to avoid story flag conflicts")
            -- WriteByte(cutsceneFlags+0xB0D, 0x6A)
            -- WriteByte(warpAddr,0xD, true)
            -- WriteByte(warpAddr+4,0x9, true)
        -- end
    -- end
    
    -- Fall in flight sections without glide
    -- if ReadFloat(soraHUD) > 0 and ReadLong(soraPointer) > 0 then
        -- local soraYPos = ReadFloat(ReadLong(soraPointer)+0x14, true)
        -- if ReadByte(world) == 0xD then
            -- if ReadByte(room) == 8 and soraYPos > 600 then
                -- InstantContinue()
            -- elseif ReadByte(room) == 9 and soraYPos > 900 then
                -- RoomWarp(0xD, 0x27)
            -- end
        -- end
        
        -- if ReadByte(world) == 0x10 then
            -- if ReadByte(room) == 0x1A and soraYPos > -400 then
                -- InstantContinue()
            -- elseif ReadByte(room) == 0x21 and soraYPos > 2500 then
                -- WriteFloat(ReadLong(soraPointer)+0x14, -7000, true)
            -- end
        -- end
    -- end
    
    if ReadByte(cutsceneFlags+0xB07) < 0x11 and ReadByte(world) == 4 then
        ---local evidenceCount = 0
        --for i=0xDE, 0xE1 do
        --    evidenceCount = evidenceCount + math.min(ReadByte(inventory+i), 1)
        --end
        --if evidenceCount >= 1 then
        --    for i=0,3 do
        --        WriteByte(evidence+i, math.min(ReadByte(inventory+0xDE+i), 1))
        --    end
        --else
        --    for i=0,3 do
        --        WriteByte(evidence+i, 0)
        --    end
        --end
        if ReadByte(room) == 4 then
            local o = 0
            while ReadInt(evidenceActiveForest+4+o*0x4B0) ~= 0x40013 and ReadInt(evidenceActiveForest+4+o*0x4B0) ~= 0 and o > -5 do
                o = o-1
            end
            if ReadLong(evidenceActiveForest+o*0x4B0) == 0x0004001300008203 then
                WriteLong(evidenceActiveForest+o*0x4B0, 0)
                WriteLong(evidenceActiveForest+(o+1)*0x4B0, 0)
            end
        elseif ReadByte(room) == 1 then
            local o = 0
            while ReadInt(evidenceActiveBizarre+4+o*0x4B0) ~= 0x40013 and ReadInt(evidenceActiveBizarre+4+o*0x4B0) ~= 0 and o > -5 do
                o = o-1
            end
            if ReadLong(evidenceActiveBizarre+o*0x4B0) == 0x0004001300008003 then
                WriteLong(evidenceActiveBizarre+o*0x4B0, 0)
                WriteLong(evidenceActiveBizarre+(o+1)*0x4B0, 0)
            end
        end
    end
    
    if ReadByte(world) == 5 then
        -- if ReadByte(blackfade) < 128 and prevBlack == 128 then
            -- sliderSavedProg = ReadArray(sliderProgress, 5)
            -- WriteArray(sliderProgress, {1,1,1,1,1})
        -- elseif ReadByte(blackfade) == 128 and prevBlack < 128 then
            -- WriteArray(sliderProgress, sliderSavedProg)
        -- end
        if ReadByte(room) == 8 and ReadByte(sliderProgress) == 1 then
            WriteByte(collectedFruits, 0)
            WriteByte(savedFruits, 0)
            local warpsAddr = ReadLong(warpDefinitions)
            if ReadByte(warpsAddr, true)==0 and ReadByte(warpsAddr+0x40, true)==1 then
                for i=0, 4 do
                    if ReadByte(sliderProgress+i) == 1 and ReadByte(warpsAddr+0x9C0) < 0x10+i then
                        WriteArray(warpsAddr+0x9C0, ReadArray(warpsAddr+0x9C0+(0x40*(i+1)), 0x40, true), true)
                    end
                end
            end
        end
        if ReadByte(room) > 0xF then
            WriteByte(collectedFruits, math.max(ReadByte(collectedFruits), (ReadByte(room)-0xF)*10))
        end
        
        if ReadByte(cutsceneFlags+0xB05) <= 0x1A then
            -- for i=0,5 do
                -- if itemids[0xD9+i] ~= 0xD9+i and ReadByte(room) == 0xC then
                    -- WriteByte(slides+i, 0)
                -- else
                    -- WriteByte(slides+i, ReadByte(inventory+0xD8+i))
                -- end
            -- end
            if ReadByte(room) == 0xC then
                local slideCount = 0
                for i=0,5 do
                    slideCount = slideCount + math.min(ReadByte(inventory+0xD8+i), 1)
                end
                if slideCount < 1 then
                    local o = 0
                    while ReadInt(slideActive+o*0x4B0+4) ~= 0x40018 and ReadInt(slideActive+o*0x4B0+4) ~= 0 and o > -5 do
                        o = o-1
                    end
                    if ReadInt(slideActive+o*0x4B0+4) == 0x40018 then
                        for i=0,5 do
                            if ReadInt(slideActive+(i+o)*0x4B0+4) == 0x40018+(i>1 and i+4 or i) then
                                WriteLong(slideActive+(i+o)*0x4B0, 0)
                            end
                        end
                    end
                end
            end
        end
        
        -- if ReadByte(cutsceneFlags+0xB05) >= 0x6E and (ReadByte(chestsOpened+0x218) // 8) % 2 == 0
        -- and ReadByte(room) ~= 2 and ReadByte(blackfade) == 128 then
            -- WriteByte(worldFlagBase+0x42, 12)
        -- end
    end
    
    if ReadByte(world) == 6 then
        if ReadInt(poohProgress) == 0 then
            WriteInt(poohProgress, 1) --Intro cutscene
            WriteInt(poohProgress2, 0x00020002) --1st and 2nd area
            WriteInt(poohProgress2+4, 0x00020005) --3rd area and 4th (4,9 final)
            WriteInt(poohProgress2+8, 0x00020002) --5th area and 6th (4,9 final)
        end
        if ReadByte(collectedFruits) >= 100 and ReadByte(room) == 4 then
            WriteInt(minigameTimer, 0)
        end
    end
    
    --Early EotW, blocked until HB2
    --if ReadByte(cutsceneFlags+0xB0E) < 0xC3 and ReadByte(world) == 0x10 then
    --    if ReadByte(currentTerminus) == 9 then        --Hide teleporter to HB portal
    --        WriteInt(terminusTeleUsable, 0xFFFFD8F0)
    --        WriteInt(terminusTeleVisible, 0xC61C4000)
    --    end
    --elseif ReadByte(cutsceneFlags+0xB0E) >= 0xC3 and ReadInt(inGummi) > 0 and ReadByte(unlockedWarps+2) < 3 and true then
    --    WriteByte(unlockedWarps+2, 3)
    --    WriteByte(cutsceneFlags+0xB0F, math.max(ReadByte(cutsceneFlags+0xB0F), 8))
    --    WriteByte(worldFlagBase+0xDC, 0xD)
    --    WriteByte(worldFlagBase+0xDF, 0xD)
    --end
    if ReadInt(inGummi) > 0 and ReadByte(unlockedWarps+2) < 3 and true then
        WriteByte(unlockedWarps+2, 3)
        WriteByte(cutsceneFlags+0xB0F, math.max(ReadByte(cutsceneFlags+0xB0F), 8))
        WriteByte(worldFlagBase+0xDC, 0xD)
        WriteByte(worldFlagBase+0xDF, 0xD)
    end
    
    if ReadByte(battleLevel) % 2 == 1 and ReadByte(cutsceneFlags+0xB0E) < 0x8C then
        WriteByte(battleLevel, ReadByte(battleLevel)-1)
    end
    
    -- Prevent issues in early HB exploration
    if ReadByte(cutsceneFlags+0xB0E) <= 1 then
        WriteByte(cutsceneFlags+0xB0E, 0xA)
    end
    
    if ReadByte(world) == 0xF then
        --local embCount = 0
        --for i=0xBB, 0xBE do
        --    embCount = embCount + math.min(ReadByte(inventory+i), 1)
        --    WriteByte(inventory+i, math.min(1, ReadByte(inventory+i)))
        --end
        --
        --local canPlace = embCount == 4 or ReadByte(emblemDoor) > 0
        --
        --WriteByte(emblemCount, canPlace and 4 or 0)
        --if ReadByte(cutsceneFlags+0xB0E) > 0x32 and (ReadByte(room) ~= 4 or ReadByte(blackfade)==0) then
        --    local doorClose = ReadByte(roomWarpRead) >= 0x10 and ReadByte(roomWarpRead) <= 0x13
        --    WriteByte(emblemDoor, doorClose and 3 or 4)
        --    WriteByte(emblemDoor+3, doorClose and 1 or 5)
        --end
        
        --if ReadByte(libraryFlag) == 0 then
        --    WriteByte(libraryFlag, 2)
        --end
        
        if ReadByte(room) == 5 then --and ReadLong(khamaActive) == 0x0004000000008003 then
            --WriteLong(khamaActive, 0)
            WriteLong(theonActive, 0)
        end
    end

    if ReadByte(cutsceneFlags+0xB00) == 0xDC then
        WriteByte(gummiFlagBase+11, 3)
    end

    --WriteInt(worldMapLines, 0xFFFFFFFF)
    --WriteByte(worldMapLines+4, ReadByte(gummiFlagBase+11) >= 3 and 0xFF or 0)
    
    --if ReadByte(gummiFlagBase+9)==0 then
    --    OpenGummi()
    --end
end

function OpenGummi()
    for i=0,14 do
        if i~=11 then
            WriteByte(gummiFlagBase+i, 3)
        end
    end
end

function RoomWarp(w, r)
	WriteByte(warpType1, 5)
	WriteByte(warpType2, 10)
	WriteByte(worldWarp, w)
	WriteByte(roomWarp, r)
	WriteByte(warpTrigger, 2)
end

function _OnInit()
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        canExecute = true
        ConsolePrint("KH1 detected, running script")
    else
        ConsolePrint("KH1 not detected, not running script")
    end
end

function _OnFrame()
    if canExecute then
        FlagFixes()
    end
end