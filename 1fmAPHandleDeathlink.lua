LUAGUI_NAME = "1fmAPHandleDeathlink"
LUAGUI_AUTH = "denhonator with edits from Gicu"
LUAGUI_DESC = "Handles sending and receiving Death Links. Credits to Denho."

if os.getenv('LOCALAPPDATA') ~= nil then
    client_communication_path = os.getenv('LOCALAPPDATA') .. "\\KH1FM\\"
else
    client_communication_path = os.getenv('HOME') .. "/KH1FM/"
    ok, err, code = os.rename(client_communication_path, client_communication_path)
    if not ok and code ~= 13 then
        os.execute("mkdir " .. path)
    end
end

local extraSafety = false
local offset = 0x3A0606
local addgummi = 0
local lastInput = 0
local prevHUD = 0
local revertCode = false
local removeWhite = 0
local lastDeathPointer = 0
local soraHUD = 0x280EB1C - offset
local soraHP = 0x2D592CC - offset
local stateFlag = 0x2863958 - offset
local deathCheck = 0x2978E0 - offset
local safetyMeasure = 0x297746 - offset
local whiteFade = 0x233C49C - offset
local blackFade = 0x4D93B8 - offset
local closeMenu = 0x2E90820 - offset
local deathPointer = 0x23944B8 - offset
local closeMenu = 0x2E90820 - offset
local warpTrigger = 0x22E86DC - offset
local warpType1 = 0x233C240 - offset
local warpType2 = 0x22E86E0 - offset
local title = 0x233CAB8 - offset
local continue = 0x2DFC5D0 - offset
local config = 0x2DFBDD0 - offset
local cam = 0x503A18 - offset

local canExecute = false
last_death_time = 0
soras_hp_address = 0x2DE59D0 - offset + 0x5
donalds_hp_address = soras_hp_address + 0x74
goofys_hp_address = donalds_hp_address + 0x74
soras_last_hp = 100

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

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

    lastDeathPointer = ReadLong(deathPointer)
    if file_exists(client_communication_path .. "dlreceive") then
        file = io.open(client_communication_path .. "dlreceive")
        io.input(file)
        death_time = tonumber(io.read())
        if death_time ~= nil then
            last_death_time = death_time
        end
        io.close(file)
    end
    soras_last_hp = ReadByte(soraHP)
end

function _OnFrame()
    if not canExecute then
        goto done
    end

    local savemenuopen = ReadByte(0x232A604-offset)
    -- Remove white screen on death (it bugs out this way normally)
    if removeWhite > 0 then
        removeWhite = removeWhite - 1
        -- WriteLong(closeMenu, 0)
        if ReadByte(whiteFade) == 128 then
            WriteByte(whiteFade, 0)
        end
    end
    
    -- Reverts disabling death condition check (or it crashes)
    if revertCode and ReadLong(deathPointer) ~= lastDeathPointer then
        WriteShort(deathCheck, 0x2E74)
        if extraSafety then
            WriteLong(safetyMeasure, 0x8902AB8973058948)
        end
        removeWhite = 1000
        revertCode = false
    end
    
    if file_exists(client_communication_path .. "goofydl.cfg") then
        if ReadByte(goofys_hp_address) == 0 and ReadByte(soras_hp_address) > 0 then
            WriteByte(soraHP, 0)
            WriteByte(soras_hp_address, 0)
            WriteByte(stateFlag, 1)
            WriteShort(deathCheck, 0x9090)
            if extraSafety then
                WriteLong(safetyMeasure, 0x89020B958735894C)
            end
            revertCode = true
        end
    end
    if file_exists(client_communication_path .. "donalddl.cfg") then
        if ReadByte(donalds_hp_address) == 0 and ReadByte(soras_hp_address) > 0 then
            WriteByte(soraHP, 0)
            WriteByte(soras_hp_address, 0)
            WriteByte(stateFlag, 1)
            WriteShort(deathCheck, 0x9090)
            if extraSafety then
                WriteLong(safetyMeasure, 0x89020B958735894C)
            end
            revertCode = true
        end
    end
    
    if file_exists(client_communication_path .. "dlreceive") then
        file = io.open(client_communication_path .. "dlreceive")
        io.input(file)
        death_time = tonumber(io.read())
        io.close(file)
        if death_time ~= nil and last_death_time ~= nil then
            if ReadFloat(soraHUD) > 0 and ReadByte(soraHP) > 0 and ReadByte(blackFade)==128 and ReadShort(deathCheck) == 0x2E74 and death_time >= last_death_time + 3 then
                WriteByte(soraHP, 0)
                WriteByte(stateFlag, 1)
                WriteShort(deathCheck, 0x9090)
                if extraSafety then
                    WriteLong(safetyMeasure, 0x89020B958735894C)
                end
                revertCode = true
                last_death_time = death_time
                soras_last_hp = 0
            end
        end
    end
    
    if ReadByte(soras_hp_address) == 0 and soras_last_hp > 0 then
        ConsolePrint("Sending death")
        ConsolePrint("Sora's HP: " .. tostring(ReadByte(soras_hp_address)))
        ConsolePrint("Sora's Last HP: " .. tostring(soras_last_hp))
        death_date = os.date("!%Y%m%d%H%M%S")
        if not file_exists(client_communication_path .. "dlsend" .. tostring(death_date)) then
            file = io.open(client_communication_path .. "dlsend" .. tostring(death_date), "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end
    soras_last_hp = ReadByte(soras_hp_address)
    ::done::
end