-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "kh1fmAP"
LUAGUI_AUTH = "Sonicshadowsilver2 with edits from Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

Now = 0x2340DDC
RoomFlags = 0x2DEBDBE
CutsceneFlags = 0x2DEA6E0
eotw_world_terminus_hb_chest_address = 0x2DEA10F + 0x379
canExecute = false

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
        if ReadByte(CutsceneFlags+0x0B0F) == 0x08 and ReadByte(CutsceneFlags+0x020D) == 0x00 then
            WriteByte(CutsceneFlags+0x020D, 0x01)
            WriteByte(RoomFlags+0x55, 0x0D)
            WriteByte(RoomFlags+0x58, 0x0D)
            WriteByte(RoomFlags+0x5B, 0x0D)
            WriteByte(RoomFlags+0x5F, 0x0D)
            WriteInt(RoomFlags+0x61, 0x0D0D0D0D)
            WriteInt(RoomFlags+0x65, 0x0D0D0D0D)
        end
    end
end