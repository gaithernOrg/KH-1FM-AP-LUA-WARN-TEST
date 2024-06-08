LUAGUI_NAME = "1fmAPBoardGummi"
LUAGUI_AUTH = "denhonator with slight edits from Gicu"
LUAGUI_DESC = "Read readme for button combinations.  Modified for AP by Gicu"

local extraSafety = false
local offset = 0x3A0606
local addgummi = 0
local deathCheck = 0x2978E0 - offset
local safetyMeasure = 0x297746 - offset

local canExecute = false
local lastsavemenuopen = 0

function _OnInit()
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        if ReadShort(deathCheck) == 0x2E74 then
            ConsolePrint("Global version detected")    
        elseif ReadShort(deathCheck-0x1C0) == 0x2E74 then
            deathCheck = deathCheck-0x1C0
            safetyMeasure = safetyMeasure-0x1C0
            extraSafety = false
            ConsolePrint("JP detected")
        end
        canExecute = true
    else
        ConsolePrint("KH1 not detected, not running script")
    end
end

function _OnFrame()
    if not canExecute then
        goto done
    end

    local savemenuopen = ReadByte(0x232A604-offset)
    
    if savemenuopen == 4 and lastsavemenuopen ~= 4 then
        addgummi = 5
    end
    if savemenuopen == 4 and addgummi==1 then
        WriteByte(0x2E1CC28-offset, 3) --Unlock gummi
        WriteByte(0x2E1CB9C-offset, 5) --Set 5 buttons to save menu
        WriteByte(0x2E8F450-offset, 5) --Set 5 buttons to save menu
        WriteByte(0x2E8F452-offset, 5) --Set 5 buttons to save menu
        for i=0,4 do
            WriteByte(0x2E1CBA0+i*4-offset, i) --Set button types
        end
    end
    
    addgummi = addgummi > 0 and addgummi-1 or addgummi
    
    lastsavemenuopen = savemenuopen
    ::done::
end