-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "kh1fmAP"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

offset = 0x3A0606
chestslocked = true
interactinbattle = false
interactset = false
canExecute = false
settings_read = false

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

function read_settings()
    if not settings_read then
        if file_exists(client_communication_path .. "chestslocked.cfg") then
            chestslocked = true
            settings_read = true
        elseif file_exists(client_communication_path .. "chestsunlocked.cfg") then
            chestslocked = false
            settings_read = true
        end
        if file_exists(client_communication_path .. "interactinbattle.cfg") then
            interactinbattle = true
        end
    end
end

function has_correct_keyblade()
    stock_address = 0x2DE5E69 - offset
    world_address = 0x233CADC - offset
    keyblade_offsets = {nil, nil, 94, 98, 86, 96, nil, 87, 90, 89, 93, 99, 88, 91, nil, 97}
    current_world = ReadByte(world_address)
    if keyblade_offsets[current_world] ~= nil then
        keyblade_amt = ReadByte(stock_address + keyblade_offsets[current_world])
        if keyblade_amt > 0 then
            return true
        end
    end
    return false
end

function get_dg_count()
    dg = 0
    if ReadByte(0x2DE5E5F - offset) == 1 or ReadByte(0x2DE5E5F - offset) == 2 then
        dg = dg + 1
    end
    if ReadByte(0x2DE5E60 - offset) == 1 or ReadByte(0x2DE5E60 - offset) == 2 then
        dg = dg + 1
    end
    return dg
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
        read_settings()
        chests_address = 0x2B12C4 - offset
        chests = ReadByte(chests_address)
        if (chestslocked and has_correct_keyblade() and chests == 0x72) or not chestslocked then
            if interactinbattle then
                WriteByte(chests_address, 0x73)
            else
                WriteByte(chests_address, 0x74)
            end
        elseif chestslocked and not has_correct_keyblade() and chests ~= 0x72 then
            WriteByte(chests_address, 0x72)
        end
        if interactinbattle then
            if not interactset then
                Examine = 0x2903B9 - offset
                Talk = 0x2903F9 - offset
                WriteByte(Examine, 0x70)
                WriteByte(Talk, 0x70)
                interactset = true
            end
            Trinity = 0x1A06CF - offset
            if get_dg_count() >= 2 then
                WriteByte(Trinity, 0x71) -- Forced
            else
                WriteByte(Trinity, 0x75) -- Default
            end
        end
    end
end
