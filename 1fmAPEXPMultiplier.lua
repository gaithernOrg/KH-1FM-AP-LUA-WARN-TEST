-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "kh1fmAP"
LUAGUI_AUTH = "denhonator with edits from Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"


local offset = 0x3A0606

local btltbl = 0x2D1F3C0 - offset
local itemTable = btltbl+0x1A58
local soraStats = 0x2DE59D0 - offset
local experienceMult = 0x2D59180 - offset

local canExecute = false
frame_count = 0
xp_mult = 1.0

if os.getenv('LOCALAPPDATA') ~= nil then
    client_communication_path = os.getenv('LOCALAPPDATA') .. "\\KH1FM\\"
else
    client_communication_path = os.getenv('HOME') .. "/KH1FM/"
    ok, err, code = os.rename(client_communication_path, client_communication_path)
    if not ok and code ~= 13 then
        os.execute("mkdir " .. path)
    end
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function read_mult()
    if file_exists(client_communication_path .. "xpmult.cfg") then
        file = io.open(client_communication_path .. "xpmult.cfg", "r")
        io.input(file)
        xp_mult = tonumber(io.read())
        io.close(file)
    elseif file_exists(client_communication_path .. "EXP Multiplier.cfg") then
        file = io.open(client_communication_path .. "EXP Multiplier.cfg", "r")
        io.input(file)
        xp_mult = tonumber(io.read())
        io.close(file)
    else
        xp_mult = 1.0
    end
end

function main()
    read_mult()
    for p=0,2 do
        local accOff = (p*0x74) + 0x1D
        for i=0,3 do
            local eqID = ReadByte(soraStats + accOff+i)
            local eqName = ReadByte(itemTable+((eqID-1)*20))
            if eqName == 0x56 or eqName == 0x58 then
                xp_mult = xp_mult + 0.2
            elseif eqName == 0x59 or eqName == 0x5A then
                xp_mult = xp_mult + 0.3
            end
        end
    end
    WriteFloat(experienceMult, xp_mult)
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
    if frame_count == 0 and canExecute then
        main()
    end
    frame_count = (frame_count + 1) % 30
end