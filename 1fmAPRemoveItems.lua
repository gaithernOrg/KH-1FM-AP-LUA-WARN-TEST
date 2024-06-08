-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "kh1fmAP"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

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
offset = 0x3A0606

function find_items_to_remove()
    removed_bits_address = 0x2DF1848 - offset + 0x98
    stock_address = 0x2DE5E69 - offset
    --Item Data Table Values
    --Address, Bit Number (0 if Byte Value), Compare Value, Item Offset, Special Function
    item_data_table = {
        {0x2DE77A0 - offset, 0x1, 0x1, 0xD7, 0x1} --Dr. Finkelstein Torn Page
        ,{0x2DE6098 - offset, 0x4, 0x1, 0xD4, 0x1} --Ariels Grotto Torn Page
        ,{0x2DE7690 - offset, 0x8, 0x1, 0xD3, 0x0} --Item Shop Postcard
        ,{0x2DE7690 - offset, 0x5, 0x1, 0xD3, 0x0} --Item Workshop Postcard
        ,{0x2DE7690 - offset, 0x7, 0x1, 0xD3, 0x0} --3rd District Balcony Postcard
        ,{0x2DE768E - offset, 0x6, 0x1, 0xD3, 0x0} --Gizmo Shop Postcard 1
        ,{0x2DE768E - offset, 0x7, 0x1, 0xD3, 0x0} --Gizmo Shop Postcard 2
        ,{0x2DE6810 - offset, 0x0, 0x1, 0xD8, 0x1} --50 Puppies Returned Torn Page
        ,{0x2DE7687 - offset, 0x0, 0x1, 0xD3, 0x0} --1st District Blue Safe Postcard
        ,{0x2DE787E - offset, 0x0, 0x2, 0xBC, 0x0} --Emblem Piece Flame
        ,{0x2DE787F - offset, 0x0, 0x2, 0xBD, 0x0} --Emblem Piece Chest
        ,{0x2DE7880 - offset, 0x0, 0x2, 0xBE, 0x0} --Emblem Piece Statue
        ,{0x2DE7881 - offset, 0x0, 0x2, 0xBF, 0x0} --Emblem Piece Fountain
        ,{0x2DE7690 - offset, 0x4, 0x1, 0xD3, 0x0}} --Geppetto's House Postcard
    for item_table_index, item_data in pairs(item_data_table) do
        need_to_delete = false
        byte_offset = math.floor((item_table_index-1) / 8)
        removed_bits_value = ReadByte(removed_bits_address + byte_offset)
        deleted_bit = toBits(removed_bits_value)[((item_table_index-1)%8)+1]
        if deleted_bit == 0 then
            if item_data[2] > 0 then --Need to read a specific bit
                read_bit = toBits(ReadByte(item_data[1]))[item_data[2]]
                bits = toBits(ReadByte(item_data[1]))
                if read_bit >= item_data[3] then
                    need_to_delete = true
                end
            else
                if ReadByte(item_data[1]) >= item_data[3] then
                    need_to_delete = true
                end
            end
            if need_to_delete then
                item_qty = ReadByte(stock_address + item_data[4])
                if item_qty > 0 then
                    WriteByte(stock_address + item_data[4], math.max(item_qty-1, 0))
                    if item_data[5] == 0x1 then --Remove Torn Page
                        torn_pages_available_for_turn_in_address = 0x2DE6DD0 - offset
                        WriteByte(torn_pages_available_for_turn_in_address, math.max(ReadByte(torn_pages_available_for_turn_in_address)-1,0))
                    end
                    removed_bits_value = removed_bits_value + 2^((item_table_index-1)%8)
                    WriteByte(removed_bits_address + byte_offset, removed_bits_value)
                end
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
        find_items_to_remove()
    end
end