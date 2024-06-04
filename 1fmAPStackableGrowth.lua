-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "kh1fmAP"
LUAGUI_AUTH = "Denhonator with edits by Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

offset = 0x3A0606
canExecute = false

function CountSharedAbilities()
    sharedAbilities = 0x2DE5F69 - offset
    local shared = {0,0,0}
    for i=0,9 do
        local ab = ReadByte(sharedAbilities+i)
        if ab == 3 or ab == 4 then
            shared[3] = shared[3]+1
        elseif ab > 0 and ab <= 4 then
            shared[ab] = shared[ab]+1
        end
    end
    return shared
end

function DodgeDataValid(a)
    return ReadShort(a+0x18, true) == 0xEF and ReadShort(a+0x34, true) == 0x94
end

function CountSoraAbilities()
    soraCurAbilities = 0x2DE5A14 - offset
    local abils = {}
    for i=0, 40 do
        local ab = ReadByte(soraCurAbilities+i)
        if ab==0 then
            break
        elseif not abils[ab] then
            abils[ab] = 1
        else
            abils[ab] = abils[ab]+1
        end
    end
    return abils
end

function StackAbilities()
    jumpHeights         = 0x2D1F46C - offset
    world               = 0x233CADC - offset
    room                = world + 0x68
    soraHUD             = 0x280EB1C - offset
    cutsceneFlags       = 0x2DE65D0-0x200 - offset
    sharedAbilities     = 0x2DE5F69 - offset
    superglideSpeedHack = 0x2AE2B4 - offset
    mermaidKickSpeed    = 0x3ED5FC - offset
    soraPointer         = 0x2534680 - offset
    stateFlag           = 0x2863958 - offset
    local countedAbilities = CountSharedAbilities()
    local jumpHeight = math.max(290, 190+(countedAbilities[1]*100))

    WriteShort(jumpHeights+2, jumpHeight)
    if ReadByte(world) == 0x10 and countedAbilities[3] == 0 and stackAbilities == 3 and (ReadByte(room) == 0x21 or 
            (ReadByte(cutsceneFlags+0xB0F) >= 0x6E) and ReadFloat(soraHUD) > 0) then
        WriteShort(jumpHeights, 390)
        WriteShort(jumpHeights+2, math.max(390, jumpHeight))
    end

    if stackAbilities > 1 then
        local glides = false
        for i=0,9 do
            local ab = ReadByte(sharedAbilities+i)
            if ab % 0x80 >= 3 and not glides then
                WriteByte(sharedAbilities+i, (ab % 0x80 == 4) and ab-1 or ab)
                glides = true
            elseif ab % 0x80 == 3 and glides then
                WriteByte(sharedAbilities+i, ab+1)
            end
        end
        
        if ReadShort(superglideSpeedHack+1) == 0x17F3 then
            WriteInt(superglideSpeedHack, 0x17F35C + math.max(countedAbilities[3]-2, 0)*4)
        end
        
        WriteFloat(mermaidKickSpeed, 10+(8*countedAbilities[2]))
        
        if stackAbilities == 3 then
            if countedAbilities[3] == 0 and ReadLong(soraPointer) then
                if (ReadByte(stateFlag) // 0x20) % 2 == 1 then
                    WriteByte(stateFlag, ReadByte(stateFlag) - 0x20)
                end
                local airGround = ReadLong(soraPointer)+0x70
                if ReadInt(ReadLong(soraPointer)+0xB0) > 0 then
                    WriteByte(airGround, 2, true)
                end
            end
        end
        
        -- Allow early flight in Neverland if glide equipped
        if countedAbilities[3] > 0 and ReadByte(world) == 0xD then
            if (ReadByte(stateFlag) // 0x20) % 2 == 0 then
                WriteByte(stateFlag, ReadByte(stateFlag) + 0x20)
            end
        end
        
        if not DodgeDataValid(dodgeDataAddr) then
            dodgeDataAddr = GetDodgeDataAddr()
        end
        
        if DodgeDataValid(dodgeDataAddr) then
            local abils = CountSoraAbilities()
            if abils[0x16] then
                WriteShort(dodgeDataAddr+4, math.max(50-(12*abils[0x16]), 22), true)
            end
        end
    end
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
        StackAbilities()
    end
end