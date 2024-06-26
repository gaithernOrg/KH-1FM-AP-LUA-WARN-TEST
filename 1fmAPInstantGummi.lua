LUAGUI_NAME = "1fmAPInstantGummi"
LUAGUI_AUTH = "denhonator with edits from Gicu"
LUAGUI_DESC = "Instantly arrive at gummi destination"

local worldWarpBase = 0x50F9D0
local cutsceneFlagBase = 0x2DEA8E0-0x200
local djProgressFlag = 0x2DEBCE0+0x6C+0x40
local neverlandProgressFlag = 0x2DEBCE0+0x6C+0xED

local canExecute = false

function _OnInit()
	if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
		canExecute = true
		ConsolePrint("KH1 detected, running script")
	else
		ConsolePrint("KH1 not detected, not running script")
	end
end

function _OnFrame()
	if not canExecute then
		goto done
	end

	local selection = ReadInt(0x507D7C)
	local realSelection = selection
	local realWorld = ReadByte(0x507C94)
	local soraWorld = ReadByte(0x2340DDC)
	local stateFlag = 0x2867C58
	
	local monstroOpen = ReadByte(0x2DEBBDA) > 1
	local neverlandState = ReadByte(cutsceneFlagBase+0xB0D) < 0x14
	local deepJungleState = ReadByte(cutsceneFlagBase+0xB05) < 0x10

	WriteByte(worldWarpBase+0x2A, deepJungleState and 0 or 0xE)
	WriteByte(worldWarpBase+0x2C, deepJungleState and 0 or 0x2D)
	WriteByte(worldWarpBase+0x9A, neverlandState and 6 or 0x7)
	WriteByte(worldWarpBase+0x9C, neverlandState and 0x18 or 0x25)

	if stateFlag == 4 and soraWorld == 0 and selection == 0 then
		WriteInt(0x507D7C, 3)
	end
	
	-- Replace HT and Atlantica with Monstro at first
	--if not monstroOpen and (selection == 10 or selection == 9) then
	--	selection = selection == 9 and 18 or 17
	--	--WriteInt(0x507D7C, selection)
	--end
	-- Change warp to Hollow Bastion
	if selection == 25 then 
		selection = 1
		WriteInt(0x507D7C, selection)
	end
	-- Change warp to Agrabah
	if selection == 21 then
		selection = 1
		WriteInt(0x507D7C, selection)
	end
	
	-- Go directly to location
	local curDest = ReadInt(0x508280)
	if curDest < 40 then
		selection = selection > 20 and 0 or selection
		WriteInt(0x508280, selection)
		WriteInt(0x507C90, selection)
		WriteInt(0x268A1EC, 0)
	else
		WriteInt(0x507C90, realSelection)
	end
	
	::done::
end