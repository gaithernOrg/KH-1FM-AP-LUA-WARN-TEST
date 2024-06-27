-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "1fmAPRemoveItems"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

game_version = 1 --1 for ESG 1.0.0.9, 2 for Steam 1.0.0.9

function toBits(num)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    while #t < 8 do
        t[#t+1] = 0
    end
    return t
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

canExecute = false

function find_items_to_remove()
    removed_bits_address = 0x2DF5B58 + 0x98
    stock_address = 0x2DEA179
    --Item Data Table Values
    --Address, Bit Number (0 if Byte Value), Compare Value, Item Offset, Special Function
    item_data_table = {
         {{0x2DEBAB0, 0x2DEB130}, 0x1, 0x01, 0xD7, 0x1}  --Dr. Finkelstein Torn Page
        ,{{0x2DEA3A8, 0x2DE9A28}, 0x4, 0x01, 0xD4, 0x1}  --Ariels Grotto Torn Page
        ,{{0x2DEB9A0, 0x2DEB020}, 0x8, 0x01, 0xD3, 0x0}  --Item Shop Postcard
        ,{{0x2DEB9A0, 0x2DEB020}, 0x5, 0x01, 0xD3, 0x0}  --Item Workshop Postcard
        ,{{0x2DEB9A0, 0x2DEB020}, 0x7, 0x01, 0xD3, 0x0}  --3rd District Balcony Postcard
        ,{{0x2DEB99E, 0x2DEB01E}, 0x6, 0x01, 0xD3, 0x0}  --Gizmo Shop Postcard 1
        ,{{0x2DEB99E, 0x2DEB01E}, 0x7, 0x01, 0xD3, 0x0}  --Gizmo Shop Postcard 2
        ,{{0x2DEAB20, 0x2DEA1A0}, 0x0, 0x01, 0xD8, 0x1}  --50 Puppies Returned Torn Page
        ,{{0x2DEB997, 0x2DEB017}, 0x0, 0x01, 0xD3, 0x0}  --1st District Blue Safe Postcard
        ,{{0x2DEBB8E, 0x2DEB20E}, 0x0, 0x02, 0xBC, 0x0}  --Emblem Piece Flame
        ,{{0x2DEBB8F, 0x2DEB20F}, 0x0, 0x02, 0xBD, 0x0}  --Emblem Piece Chest
        ,{{0x2DEBB90, 0x2DEB210}, 0x0, 0x02, 0xBE, 0x0}  --Emblem Piece Statue
        ,{{0x2DEBB91, 0x2DEB211}, 0x0, 0x02, 0xBF, 0x0}  --Emblem Piece Fountain
        ,{{0x2DEB9A0, 0x2DEB020}, 0x4, 0x01, 0xD3, 0x0}  --Geppetto's House Postcard
        ,{{0x2DEB1EA, 0x2DEA86A}, 0x0, 0x32, 0xD2, 0x0}  --Crystal Trident
        ,{{0x2DEB1E6, 0x2DEA866}, 0x0, 0x10, 0xE5, 0x0}  --Entry Pass
        ,{{0x2DEB1EC, 0x2DEA86C}, 0x0, 0x21, 0xE3, 0x0}} --Forget-Me-Not
    for item_table_index, item_data in pairs(item_data_table) do
        need_to_delete = false
        byte_offset = math.floor((item_table_index-1) / 8)
        removed_bits_value = ReadByte(removed_bits_address + byte_offset)
        deleted_bit = toBits(removed_bits_value)[((item_table_index-1)%8)+1]
        if deleted_bit == 0 then
            if item_data[2] > 0 then --Need to read a specific bit
                read_bit = toBits(ReadByte(item_data[1][game_version]))[item_data[2]]
                bits = toBits(ReadByte(item_data[1][game_version]))
                if read_bit >= item_data[3] then
                    need_to_delete = true
                end
            else
                if ReadByte(item_data[1][game_version]) >= item_data[3] then
                    need_to_delete = true
                end
            end
            if need_to_delete then
                item_qty = ReadByte(stock_address + item_data[4])
                if item_qty > 0 then
                    WriteByte(stock_address + item_data[4], math.max(item_qty-1, 0))
                    if item_data[5] == 0x1 then --Remove Torn Page
                        torn_pages_available_for_turn_in_address = 0x2DEB0E0
                        WriteByte(torn_pages_available_for_turn_in_address, math.max(ReadByte(torn_pages_available_for_turn_in_address)-1,0))
                    end
                    removed_bits_value = removed_bits_value + 2^((item_table_index-1)%8)
                    WriteByte(removed_bits_address + byte_offset, removed_bits_value)
                end
            end
        end
    end
    WriteArray(stock_address + 200, {0,0,0,0,0,0}) --Remove Navi Gummis
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
        find_items_to_remove()
    end
end