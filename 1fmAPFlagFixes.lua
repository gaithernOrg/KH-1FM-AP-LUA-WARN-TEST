LUAGUI_NAME = "1fmAPFlagFixes"
LUAGUI_AUTH = "denhonator with edits from Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Flag Fixes"

game_version = 1 --1 for ESG 1.0.0.9, 2 for Steam 1.0.0.9

local chestsOpened = {0x2DEA110, 0x2DE9790}
local summonsReturned = {0x2DEAA0C, 0x2DEA08C}
local summons = {0x2DEA4B0, 0x2DE9B30}
local inventory = {0x2DEA17A, 0x2DE97FA}
local tornPageCount = {0x2DEB0E0, 0x2DEA760}
local poohProgress = {0x2DEBA28, 0x2DEB0A8}
local poohProgress2 = {0x2DEB100, 0x2DEA780}
local emblemCount = {0x2DEBB8D, 0x2DEB20D}
local slides = {0x2DEAEE7, 0x2DEA567}
local slideActive = {0x2D40D70, 0x2D403F0}
local evidence = {0x2DEAAE8, 0x2DEA168}
local evidenceActiveForest = {0x2D3DE90, 0x2D3D510}
local evidenceActiveBizarre = {0x2D3D530, 0x2D3CBB0}
local theonActive = {0x2D3A1A0, 0x2D39820}
local emblemDoor = {0x2DEBB9C, 0x2DEB21C}
local reports = {0x2DEB6A0, 0x2DEAD20}

local worldFlagBase = {0x2DEBD4C, 0x2DEB3CC}
local gummiFlagBase = {0x2DEBBD0, 0x2DEB250}
local gummiselect = {0x507D7C, 0x50707C}
local inGummi = {0x5082A8, 0x5075A8}
local battleLevel = {0x2DEB6A4, 0x2DEAD24}
local unlockedWarps = {0x2DEBBE6, 0x2DEB266}
local cutsceneFlags = {0x2DEA6E0, 0x2DE9D60}
local libraryFlag = {0x2DEBE03, 0x2DEB483}
local scriptPointer = {0x23987B8, 0x2382568}
local ardoffset = {0x2398EB0, 0x23854E0}
local ardoffsetClock = {0x2399210, 0x2385840}
local cupCurrentSeed = {0x238D780, 0x238BBF0}
local waterwayGate = {0x2DEB94D, 0x2DEAFCD}
local waterwayTrinity = {0x2DEB991, 0x2DEB991}
local sliderProgress = {0x2DEBA19, 0x2DEB099}
local savedFruits = {0x2DEBA1E, 0x2DEB09E}
local minigameTimer = {0x232E984, 0x232E000}
local collectedFruits = {0x232E984 + 4, 0x232E000 + 4}
local unequipBlacklist = {0x546020, 0x545330}
local tutorialFlag = {0x2DEB6A4, 0x2DEAD24}
local oppositeState = {0x2DEB998, 0x2DEB018}
local oppositeTrigger = {0x2DEA9FD,0x2DEA07D}

local blackFade = {0x4DD3F8, 0x4DC718}
local enableRC = {0x2DEA554, 0x2DE9BD4}
local lockMenu = 0x232E90C
local party1 = {0x2DEA16F, 0x2DE97EF}
local party2 = {0x2E20EE5, 0x2E20565}
local soraHUD = {0x2812E1C, 0x281249C}
local world = {0x2340DDC, 0x233FE84}
local room = {0x2340DDC + 0x68, 0x233FE84 + 4}

local soraStats = {0x2DE9CE0, 0x2DE9360}

local worldWarp = {0x2340E70, 0x233FEB8}
local roomWarp = {0x2340E70 + 4, 0x233FEB8 + 4}
local roomWarpRead = {0x232E888, 0x232DF18}
local warpTrigger = {0x22EC9DC, 0x22EC07C}
local warpType1 = {0x2340540, 0x233FBC0}
local warpType2 = {0x22EC9E0, 0x22EC080}
local warpDefinitions = {0x232E880, 0x232DF10}

local prevTTFlag = 0

local canExecute = false

function FlagFixes()
    if ReadByte(world[game_version]) == 0 and ReadByte(room[game_version]) == 0 and ReadByte(cutsceneFlags[game_version]+0xB01) == 0xA then
        WriteByte(cutsceneFlags[game_version]+0xB01, 0xD)
        WriteByte(warpType1[game_version], 7)
        WriteByte(warpType2[game_version], 6)
        WriteByte(warpTrigger[game_version], 2)
        instant_gummi_fix_address = {0x25389D0, 0x2538060}
        WriteLong(instant_gummi_fix_address[game_version], 0) -- Fixes InstantGummi
    end

    if ReadByte(world[game_version]) == 1 and ReadFloat(soraHUD[game_version]) > 0 and ReadInt(inGummi[game_version]) == 0 then
        WriteByte(party1[game_version], 0xFF)
        WriteByte(party1[game_version]+1, 0xFF)
    end

    -- Reset TT to avoid softlocks
    if ReadByte(cutsceneFlags[game_version]+0xB04) < 0x14 and ReadByte(world[game_version]) > 3 then
        WriteByte(cutsceneFlags[game_version]+0xB04, 0)
        WriteByte(worldFlagBase[game_version]+0x1C, 2)
    end

    -- Secret waterway Leon unmissable
    if ReadByte(cutsceneFlags[game_version]+0x312) == 0 and ReadByte(cutsceneFlags[game_version]+0xB04) >= 0x31 then
        WriteByte(cutsceneFlags[game_version]+0xB04, 0x31)
        WriteByte(worldFlagBase[game_version]+0x32, 2)
    end
    
    -- Skip TT2
    if ReadByte(cutsceneFlags[game_version]+0xB04) == 0x3E then
        WriteByte(cutsceneFlags[game_version]+0xB04, 0x4E)
        WriteByte(worldFlagBase[game_version]+0x1C, 5)
    end
    
    -- Revert HB1 effect on TT story
    if (ReadByte(cutsceneFlags[game_version]+0xB04) == 0x6E and ReadByte(worldFlagBase[game_version]+0x1C) ~= 5)
                                            or ReadByte(cutsceneFlags[game_version]+0xB04) == 0x96 then
        WriteByte(cutsceneFlags[game_version]+0xB04, prevTTFlag)
    end
    
    if ReadByte(cutsceneFlags[game_version]+0xB0E) >= 0xA0 and ReadByte(worldFlagBase[game_version]+0x1C) == 5
                                            and ReadByte(cutsceneFlags[game_version]+0xB04) < 0x6E then
        WriteByte(cutsceneFlags[game_version]+0xB04, 0x6E)
        WriteByte(cutsceneFlags[game_version]+0xB00, math.max(0xBE, ReadByte(cutsceneFlags[game_version]+0xB00)))
        --ConsolePrint("Post HB TT")
    end

    prevTTFlag = ReadByte(cutsceneFlags[game_version]+0xB04)
    
    if ReadByte(oppositeState[game_version]) >= 5 then
        WriteByte(oppositeTrigger[game_version], 0)
    end
    
    if ReadByte(world[game_version]) == 3 and ReadByte(room[game_version]) == 0x13 then
        local simbaAddr = ReadLong(scriptPointer[game_version]) + 0x131C8
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
            
            WriteByte(summonsReturned[game_version], hasSummons[1] and 1 or 0)
            WriteByte(summonsReturned[game_version]+1, hasSummons[0] and 1 or 0)
            WriteByte(summonsReturned[game_version]+2, hasSummons[4] and 1 or 0)
            WriteByte(summonsReturned[game_version]-1, hasSummons[5] and 1 or 0)
            
            local c = ReadByte(inventory[game_version]+0xD0) > 0
            local genie = ReadByte(inventory[game_version]+0x88) > 0
            local tbell = ReadByte(inventory[game_version]+0x8B) > 0

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
    
    if ReadByte(world[game_version]) == 8 and ReadByte(room[game_version]) == 0x12 and ReadShort(ardoffset[game_version]) == 0x7F then
        WriteShort(ardoffset[game_version], 0xD1)
    end
    
    if ReadByte(world[game_version]) == 0xD and ReadByte(room[game_version]) == 9 and ReadShort(ardoffsetClock[game_version]) == 0x5F2 then
        WriteShort(ardoffsetClock[game_version], 0x628)
    end

    if ReadByte(cutsceneFlags[game_version]+0xB04) >= 0x31 then
        WriteByte(worldFlagBase[game_version]+0x26, 2) -- Cid in accessory shop
        WriteByte(worldFlagBase[game_version]+0x1D, 3)
    end
    if ReadByte(cutsceneFlags[game_version]+0xB09) < 0x14 then -- Fix monstro DI cutscene softlock
        WriteByte(cutsceneFlags[game_version]+0xB09, 0x14)
    end

    -- Shorten solo and time trial
    if ReadByte(world[game_version]) == 0xB then
        if (ReadShort(cupCurrentSeed[game_version]) == 0x0101 or ReadShort(cupCurrentSeed[game_version]) == 0x0B0B)
        and ReadFloat(soraHUD[game_version]) > 0 and (ReadByte(party1[game_version]) == 0xFF or ReadInt(minigameTimer[game_version]) > 0) then
            WriteShort(cupCurrentSeed[game_version], ReadShort(cupCurrentSeed[game_version]) == 0x0101 and 0x0909 or 0x1212)
        elseif ReadByte(world[game_version]) == 0xB and ReadByte(room[game_version]) == 1 then
            WriteInt(minigameTimer[game_version], 0)
        end
        
        -- Require Entry Pass
        if ReadByte(cutsceneFlags[game_version]+0xB06) == 0x10 then
            WriteByte(worldFlagBase[game_version]+0x94, ReadByte(inventory[game_version]+0xE4) > 0 and 3 or 2)
        end
    end

    if (ReadByte(waterwayGate[game_version]) // 0x80) % 2 == 0 then
        WriteByte(waterwayGate[game_version], ReadByte(waterwayGate[game_version])+0x80)
    end
    
    if (ReadByte(waterwayTrinity[game_version]) // 0x20) % 2 == 0 then
        WriteByte(waterwayTrinity[game_version], ReadByte(waterwayTrinity[game_version])+0x20)
    end
    
    if ReadByte(worldFlagBase[game_version]+0x36) >= 0 then
        if (ReadByte(chestsOpened[game_version]+0x1F8)//2) % 2 == 0 then
            WriteByte(worldFlagBase[game_version]+0x36, 0xD)
        elseif (ReadByte(chestsOpened[game_version]+0x1F8)//4) % 2 == 0 then
            WriteByte(worldFlagBase[game_version]+0x36, 0xE)
        elseif (ReadByte(chestsOpened[game_version]+0x1F8)//8) % 2 == 0 then
            WriteByte(worldFlagBase[game_version]+0x36, 0x10)
        end
    end
    
    if ReadByte(world[game_version]) == 3 and ReadByte(room[game_version]) == 2 and ReadByte(cutsceneFlags[game_version]+0xB04) == 0x23 then
        WriteByte(unequipBlacklist[game_version], ReadByte(soraStats[game_version]+0x36))
    else
        for i=0,3 do
            WriteByte(unequipBlacklist[game_version] + (i*4), 0)
        end
    end

    if ReadInt(inGummi) > 0 then
        if ReadByte(gummiselect[game_version]) == 3 and ReadByte(cutsceneFlags[game_version]+0xB04) < 0x31 then
            WriteByte(party1[game_version], 0xFF)
            WriteByte(party1[game_version]+1, 0xFF)
        elseif ReadByte(gummiselect[game_version]) == 0xF and ReadByte(cutsceneFlags[game_version]+0xB0E) < 0x31
                                            and ReadByte(cutsceneFlags[game_version]+0xB0E) >= 0x1E then
            WriteByte(party1[game_version], 9)
            WriteByte(party1[game_version]+1, 0xFF)
            WriteByte(party2[game_version], 9)
            WriteByte(party2[game_version]+1, 0xFF)
        elseif ReadByte(party1[game_version]) >= 9 then
            for i=0,1 do
                WriteByte(party1[game_version]+i, i+1)
                WriteByte(party2[game_version]+i, i+1)
            end
        end

        --if ReadByte(lockMenu[game_version]) > 0 then
        --    WriteByte(lockMenu[game_version], 0) -- Unlock menu
        --end

        if ReadByte(enableRC[game_version]) ~= 0x0 then
            WriteByte(enableRC[game_version], 0x0)
        end
        
        if ReadByte(reports[game_version]+4) == 0 then
            WriteByte(reports[game_version]+4, 0xE)
        end
        
        if (ReadByte(tutorialFlag[game_version]) // 0x10) % 2 == 0 then
            WriteByte(tutorialFlag[game_version], ReadByte(tutorialFlag[game_version])+0x10)
        end
    end
    
    if ReadByte(world[game_version]) == 1 and ReadByte(blackfade[game_version])>0 and ReadByte(worldFlagBase[game_version]+0xA) == 2 then -- DI Day2 Warp to EotW
        RoomWarp(0x10, 0x42)
        WriteByte(party1[game_version], 1)
        WriteByte(party1[game_version]+1, 2)
        WriteByte(worldFlagBase[game_version]+0xA, 0)
        if ReadByte(cutsceneFlags[game_version]+0xB0F) >= 0x5A then
            WriteByte(cutsceneFlags[game_version]+0xB0F, 0)
        end
    end
    
    if ReadByte(cutsceneFlags[game_version]+0xB0D) == 0x64 then
        RoomWarp(0xD, 0x27)
        WriteByte(cutsceneFlags[game_version]+0xB0D, 0x6A)
    end
    
    if ReadByte(cutsceneFlags[game_version]+0xB07) < 0x11 and ReadByte(world[game_version]) == 4 then
        if ReadByte(room[game_version]) == 4 then
            local o = 0
            while ReadInt(evidenceActiveForest[game_version]+4+o*0x4B0) ~= 0x40013 and ReadInt(evidenceActiveForest[game_version]+4+o*0x4B0) ~= 0 and o > -5 do
                o = o-1
            end
            if ReadLong(evidenceActiveForest[game_version]+o*0x4B0) == 0x0004001300008203 then
                WriteLong(evidenceActiveForest[game_version]+o*0x4B0, 0)
                WriteLong(evidenceActiveForest[game_version]+(o+1)*0x4B0, 0)
            end
        elseif ReadByte(room) == 1 then
            local o = 0
            while ReadInt(evidenceActiveBizarre[game_version]+4+o*0x4B0) ~= 0x40013 and ReadInt(evidenceActiveBizarre+4+o*0x4B0) ~= 0 and o > -5 do
                o = o-1
            end
            if ReadLong(evidenceActiveBizarre[game_version]+o*0x4B0) == 0x0004001300008003 then
                WriteLong(evidenceActiveBizarre[game_version]+o*0x4B0, 0)
                WriteLong(evidenceActiveBizarre[game_version]+(o+1)*0x4B0, 0)
            end
        end
    end
    
    if ReadByte(world[game_version]) == 5 then
        if ReadByte(room[game_version]) == 8 and ReadByte(sliderProgress[game_version]) == 1 then
            WriteByte(collectedFruits[game_version], 0)
            WriteByte(savedFruits[game_version], 0)
            local warpsAddr = ReadLong(warpDefinitions[game_version])
            if ReadByte(warpsAddr, true)==0 and ReadByte(warpsAddr+0x40, true)==1 then
                for i=0, 4 do
                    if ReadByte(sliderProgress[game_version]+i) == 1 and ReadByte(warpsAddr+0x9C0) < 0x10+i then
                        WriteArray(warpsAddr+0x9C0, ReadArray(warpsAddr+0x9C0+(0x40*(i+1)), 0x40, true), true)
                    end
                end
            end
        end
        if ReadByte(room[game_version]) > 0xF then
            WriteByte(collectedFruits[game_version], math.max(ReadByte(collectedFruits[game_version]), (ReadByte(room[game_version])-0xF)*10))
        end
        
        if ReadByte(cutsceneFlags[game_version]+0xB05) <= 0x1A then
            if ReadByte(room[game_version]) == 0xC then
                local o = 0
                while ReadInt(slideActive[game_version]+o*0x4B0+4) ~= 0x40018 and ReadInt(slideActive[game_version]+o*0x4B0+4) ~= 0 and o > -5 do
                    o = o-1
                end
                if ReadInt(slideActive[game_version]+o*0x4B0+4) == 0x40018 then
                    for i=0,5 do
                        if ReadInt(slideActive[game_version]+(i+o)*0x4B0+4) == 0x40018+(i>1 and i+4 or i) then
                            WriteLong(slideActive[game_version]+(i+o)*0x4B0, 0)
                        end
                    end
                end
                --end
            end
        end
    end
    
    if ReadByte(world[game_version]) == 6 then
        if ReadInt(poohProgress[game_version]) == 0 then
            WriteInt(poohProgress[game_version], 1) --Intro cutscene
            WriteInt(poohProgress2[game_version], 0x00020002) --1st and 2nd area
            WriteInt(poohProgress2[game_version]+4, 0x00020005) --3rd area and 4th (4,9 final)
            WriteInt(poohProgress2[game_version]+8, 0x00020002) --5th area and 6th (4,9 final)
        end
        if ReadByte(collectedFruits[game_version]) >= 100 and ReadByte(room[game_version]) == 4 then
            WriteInt(minigameTimer[game_version], 0)
        end
    end
    if ReadInt(inGummi[game_version]) > 0 and ReadByte(unlockedWarps[game_version]+2) < 3 and true then
        WriteByte(unlockedWarps[game_version]+2, 3)
        WriteByte(cutsceneFlags[game_version]+0xB0F, math.max(ReadByte(cutsceneFlags[game_version]+0xB0F), 8))
        WriteByte(worldFlagBase[game_version]+0xDC, 0xD)
        WriteByte(worldFlagBase[game_version]+0xDF, 0xD)
    end
    
    if ReadByte(battleLevel[game_version]) % 2 == 1 and ReadByte(cutsceneFlags[game_version]+0xB0E) < 0x8C then
        WriteByte(battleLevel[game_version], ReadByte(battleLevel[game_version])-1)
    end
    
    -- Prevent issues in early HB exploration
    if ReadByte(cutsceneFlags[game_version]+0xB0E) <= 1 then
        WriteByte(cutsceneFlags[game_version]+0xB0E, 0xA)
    end
    
    if ReadByte(world[game_version]) == 0xF then
        local embCount = 0
        for i=0xBB, 0xBE do
            embCount = embCount + math.min(ReadByte(inventory[game_version]+i), 1)
        end
        
        local canPlace = embCount == 4 or ReadByte(emblemDoor[game_version]) > 0
        
        WriteByte(emblemCount, canPlace and 4 or 0)
        --Save Emblem Piece Event Progress & Keep Emblem Door Opened if All Emblem Piece Events are done
        if ReadByte(cutsceneFlags[game_version]+0xB0E) > 0x32 and (ReadByte(room[game_version]) ~= 4 or ReadByte(blackfade[game_version])==0) then
            local doorClose = ReadByte(roomWarpRead[game_version]) >= 0x10 and ReadByte(roomWarpRead[game_version]) <= 0x13
            WriteByte(emblemDoor[game_version], doorClose and 3 or 4)
            WriteByte(emblemDoor[game_version]+3, doorClose and 1 or 5)
            --if ReadByte(emblemCount+1) > 1 and ReadByte(emblemCount+2) > 1 and ReadByte(emblemCount+3) > 1 and ReadByte(emblemCount+4) > 1 then
            --    WriteByte(emblemDoor, 4)
            --elseif ReadByte(emblemDoor+3) == 0x05 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x01)
            --elseif ReadByte(emblemDoor+3) == 0x15 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x11)
            --elseif ReadByte(emblemDoor+3) == 0x25 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x21)
            --elseif ReadByte(emblemDoor+3) == 0x35 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x31)
            --elseif ReadByte(emblemDoor+3) == 0x45 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x41)
            --elseif ReadByte(emblemDoor+3) == 0x45 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x41)
            --elseif ReadByte(emblemDoor+3) == 0x55 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x51)
            --elseif ReadByte(emblemDoor+3) == 0x65 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x61)
            --elseif ReadByte(emblemDoor+3) == 0x75 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x71)
            --elseif ReadByte(emblemDoor+3) == 0x85 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x81)
            --elseif ReadByte(emblemDoor+3) == 0x95 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x91)
            --elseif ReadByte(emblemDoor+3) == 0xA5 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0xA1)
            --elseif ReadByte(emblemDoor+3) == 0xB5 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0xB1)
            --elseif ReadByte(emblemDoor+3) == 0xC5 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0xC1)
            --elseif ReadByte(emblemDoor+3) == 0xD5 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0xD1)
            --elseif ReadByte(emblemDoor+3) == 0xE5 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0xE1)
            --elseif ReadByte(emblemDoor+3) == 0xF5 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0xF1)
            --end
        end
        
        if ReadByte(room[game_version]) == 5 then
            WriteLong(theonActive[game_version], 0)
        end
    end

    if ReadByte(cutsceneFlags[game_version]+0xB00) == 0xDC then
        WriteByte(gummiFlagBase[game_version]+11, 3)
    end
    
    --BEGIN SONIC AND GICU BLOCK---

    if ReadByte(world[game_version]) == 0x03 and ReadByte(room[game_version]) > 0x00 and ReadByte(cutsceneFlags[game_version]+0xB04) == 0x01 then --Prevent Start of TT1 Softlock
        WriteByte(room[game_version], 0x00)
        WriteByte(warpType1[game_version], 5)
        WriteByte(warpType2[game_version], 12)
        WriteByte(warpTrigger[game_version], 0x02)
    end
    if (ReadByte(world[game_version]) ~= 0x03 or ReadByte(room[game_version]) ~= 0x16) and (ReadByte(cutsceneFlags[game_version]+0xB04) >= 0x31 and ReadByte(cutsceneFlags[game_version]+0xB04) < 0x3E) and ReadByte(cutsceneFlags[game_version]+0x312) == 1 then --Prevent Missing Earthshine after talking to Leon only once in Secret Waterway
        WriteByte(cutsceneFlags[game_version]+0x312,0)
    end
    if ReadByte(cutsceneFlags[game_version]+0xB0A) < 0x21 then --Prevent Atlantica Sunken Ship Softlock
        WriteByte(worldFlagBase[game_version]+0x7B, 0x0E)
    elseif ReadByte(cutsceneFlags[game_version]+0xB0A) == 0x21 then
        WriteByte(worldFlagBase[game_version]+0x7B, 0x00)
    end
    if ReadByte(cutsceneFlags[game_version]+0xB0A) == 0x32 then --Require Crystal Trident
        if ReadByte(inventory[game_version]+0xD1) > 0 then
            WriteByte(worldFlagBase[game_version]+0x82, 2)
        else
            WriteByte(worldFlagBase[game_version]+0x82, 0)
        end
    end
    if ReadByte(cutsceneFlags[game_version]+0xB0C) == 0x21 then --Require Forget-Me-Not
        lab_room_address = {0x2DEBDDC, 0x2DEB45C}
        if ReadByte(inventory[game_version]+0xE2) > 0 then
            WriteByte(lab_room_address[game_version], 2)
        else
            WriteByte(lab_room_address[game_version], 3)
        end
    end
    if ReadByte(world[game_version]) == 0x09 and ReadByte(room[game_version]) == 0x10 and ReadByte(cutsceneFlags[game_version]+0xB04+0x6) < 0x53 then --Prevent Ursula II Early
        WriteByte(room[game_version], 0x02)
        WriteByte(warpType1[game_version], 5)
        WriteByte(warpType2[game_version], 12)
        WriteByte(warpTrigger[game_version], 0x02)
    end
    if ReadByte(cutsceneFlags[game_version]+0xB04+0x9) > 0x00 then --Prevent Neverland Ship: Cabin from being missable
        neverland_warps_address = {0x2DEBBE6, 0x2DEB266}
        neverland_warps = ReadByte(neverland_warps_address[game_version])
        if (neverland_warps % 2) < 1 then
            WriteByte(neverland_warps_address[game_version], neverland_warps + 1)
        end
    end
    if ReadByte(world[game_version]) == 0x0F and ReadByte(room[game_version]) == 0x04 then --Prevent HB Entrance Hall Early
        if ReadByte(unlockedWarps[game_version]+0x0142) > 0x10 and ReadByte(cutsceneFlags[game_version]+0xB0E) < 0x28 then
            WriteByte(room[game_version], 0x06)
            WriteByte(warpType1[game_version], 5)
            WriteByte(warpType2[game_version], 12)
            WriteByte(warpTrigger[game_version], 0x02)
        end
    end
    hb_library_shelves_address = {0x2DEBB8B, 0x2DEB20B}
    if ReadByte(hb_library_shelves_address[game_version]) == 0 then --Fix shelves in HB library
        WriteByte(hb_library_shelves_address[game_version], 0xF6)
    end
    hb_library_book_address = {0x2DEBB94, 0x2DEB214}
    if ReadByte(hb_library_book_address[game_version]) == 0 then --Fix books in HB library
        WriteArray(hb_library_book_address[game_version], {0x14,0x14,0x14,0x14,0x14,0x0A,0x14,0x14})
    end
    if ReadByte(cutsceneFlags[game_version]+0xB0E) == 0xA0 and ReadByte(worldFlagBase+0xB6) == 0x0A then --Post HB1 Flags -> HB2 Flags
        WriteInt(worldFlagBase[game_version]+0xB3, 0x0E0E0E0E)
        WriteShort(worldFlagBase[game_version]+0xB8, 0x0E0E)
        WriteShort(worldFlagBase[game_version]+0xBB, 0x0E0E)
        WriteShort(worldFlagBase[game_version]+0xC0, 0x000E)
    end
    hb_library_green_trinity_address   = {0x2DEB95C, 0x2DEAFDC}
    hb_library_green_trinity_address_2 = {0x2DEB949, 0x2DEAFC9}
    if ReadByte(hb_library_green_trinity_address[game_version]) == 0x00 then --Fix HB Library Green Trinity
        WriteByte(hb_library_green_trinity_address[game_version], 0x40)
        WriteByte(hb_library_green_trinity_address_2[game_version], 0x01)
    end
end

function OpenGummi()
    for i=0,14 do
        if i~=11 then
            WriteByte(gummiFlagBase[game_version]+i, 3)
        end
    end
end

function RoomWarp(w, r)
	WriteByte(warpType1[game_version], 5)
	WriteByte(warpType2[game_version], 10)
	WriteByte(worldWarp[game_version], w)
	WriteByte(roomWarp[game_version], r)
	WriteByte(warpTrigger[game_version], 2)
end

function _OnInit()
    IsEpicGLVersion  = 0x3A2B86
    IsSteamGLVersion = 0x3A29A6
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        if ReadByte(IsEpicGLVersion) == 0xFF then
            ConsolePrint("Epic Version Detected")
            game_version = 1
        end
        if ReadByte(IsSteamGLVersion) == 0xFF then
            ConsolePrint("Steam Version Detected")
            game_version = 2
        end
        canExecute = true
    end
end

function _OnFrame()
    if canExecute then
        FlagFixes()
    end
end