LUAGUI_NAME = "1fmAPSynthShopHint"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

if os.getenv('LOCALAPPDATA') ~= nil then
    client_communication_path = os.getenv('LOCALAPPDATA') .. "\\KH1FM\\"
else
    client_communication_path = os.getenv('HOME') .. "/KH1FM/"
    ok, err, code = os.rename(client_communication_path, client_communication_path)
    if not ok and code ~= 13 then
        os.execute("mkdir " .. path)
    end
end

local canExecute = false
local world = {0x2340DDC, 0x233FE84}
local room  = {0x2340DDC + 0x68, 0x233FE84 + 0x4}
local spawn = {0x2DEBD28, 0x2DEB3A8}

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
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
        if ReadByte(world) == 0x03 and ReadByte(room) == 0x0B and ReadByte(spawn) == 0x36 then --In Item Workshop
            if not file_exists(client_communication_path .. "insynthshop") then
                file = io.open(client_communication_path .. "insynthshop", "w")
                io.output(file)
                io.write("")
                io.close(file)
            end
        end
    end
end