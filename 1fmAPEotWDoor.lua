-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "kh1fmAP"
LUAGUI_AUTH = "Gicu and Sonicshadowsilver2"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

canExecute = false
required_reports_door = 14
door_goal = "reports"
offset = 0x3A0606
frame_count = 0

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

function read_required_reports()
    if file_exists(client_communication_path .. "required_reports_door.cfg") then
        file = io.open(client_communication_path .. "required_reports_door.cfg", "r")
        io.input(file)
        required_reports_door = tonumber(io.read())
        io.close(file)
    end
end

function read_door_goal()
    if file_exists(client_communication_path .. "door.cfg") then
        file = io.open(client_communication_path .. "door.cfg", "r")
        io.input(file)
        door_goal = io.read()
        io.close(file)
    end
end

function all_postcards_mailed()
    postcards_mailed_address = 0x2DE78C0 - 0x231 - offset
    postcards_mailed = ReadByte(postcards_mailed_address)
    return postcards_mailed >= 10
end

function all_puppies_returned()
    all_puppies_returned_address = 0x2DE6815 - offset
    all_puppies_returned_byte = ReadByte(all_puppies_returned_address)
    return all_puppies_returned_byte > 0
end

function all_super_bosses_defeated()
    sephiroth_address             = 0x2DE693A - offset
    unknown_and_kurt_zisa_address = 0x2DE7391 - offset
    phantom_address               = 0x2DE6EDD - offset
    
    sephiroth_complete             = ReadByte(sephiroth_address) > 0
    unknown_complete               = (ReadByte(unknown_and_kurt_zisa_address) % 16) >= 8
    kurt_zisa_complete             = (ReadByte(unknown_and_kurt_zisa_address) % 64) >= 32
    phantom_complete               = ReadByte(phantom_address) >= 0x96
    
    return sephiroth_complete and unknown_complete and kurt_zisa_complete and phantom_complete
end

function read_report_qty()
    inventory_address = 0x2DE5E69 - offset
    reports_1 = ReadArray(inventory_address + 149, 3)
    reports_2 = ReadArray(inventory_address + 168, 10)
    reports_acquired = 0
    for k,v in pairs(reports_1) do
        if v > 0 then
            reports_acquired = reports_acquired + 1
        end
    end
    for k,v in pairs(reports_2) do
        if v > 0 then
            reports_acquired = reports_acquired + 1
        end
    end
    return reports_acquired
end

function write_ansem_door(ansem_door_on)
    final_rest = 0x2DE7B1C - offset
    if ansem_door_on then
        WriteByte(final_rest, 0)
    else
        WriteByte(final_rest, 1)
    end
end

function main()
    read_door_goal()
    if door_goal == "reports" then
        read_required_reports()
        write_ansem_door(read_report_qty() >= required_reports_door)
    elseif door_goal == "puppies" then
        write_ansem_door(all_puppies_returned())
    elseif door_goal == "postcards" then
        write_ansem_door(all_postcards_mailed())
    elseif door_goal == "superbosses" then
        write_ansem_door(all_super_bosses_defeated())
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
    if frame_count == 0 and canExecute then
        main()
    end
    frame_count = (frame_count + 1) % 30
end