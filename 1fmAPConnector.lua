-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "kh1fmAP"
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

function toBits(num)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    return t
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

--- Global Variables ---
frame_count = 1
canExecute = false
worlds_unlocked_array = {3, 0, 0, 0, 0, 0, 0, 0, 0}
monstro_unlocked = 0

--- Addresses ---
offset = 0x3A0606

--- Definitions ---
function define_item_ids()
    item_ids = {}
    item_ids[2641001] = "Potion"
    item_ids[2641002] = "Hi-Potion"
    item_ids[2641003] = "Ether"
    item_ids[2641004] = "Elixir"
    item_ids[2641005] = "BO5"
    item_ids[2641006] = "Mega-Potion"
    item_ids[2641007] = "Mega-Ether"
    item_ids[2641008] = "Megalixir"
    item_ids[2641009] = "Fury Stone"
    item_ids[2641010] = "Power Stone"
    item_ids[2641011] = "Energy Stone"
    item_ids[2641012] = "Blazing Stone"
    item_ids[2641013] = "Frost Stone"
    item_ids[2641014] = "Lightning Stone"
    item_ids[2641015] = "Dazzling Stone"
    item_ids[2641016] = "Stormy Stone"
    item_ids[2641017] = "Protect Chain"
    item_ids[2641018] = "Protera Chain"
    item_ids[2641019] = "Protega Chain"
    item_ids[2641020] = "Fire Ring"
    item_ids[2641021] = "Fira Ring"
    item_ids[2641022] = "Firaga Ring"
    item_ids[2641023] = "Blizzard Ring"
    item_ids[2641024] = "Blizzara Ring"
    item_ids[2641025] = "Blizzaga Ring"
    item_ids[2641026] = "Thunder Ring"
    item_ids[2641027] = "Thundara Ring"
    item_ids[2641028] = "Thundaga Ring"
    item_ids[2641029] = "Ability Stud"
    item_ids[2641030] = "Guard Earring"
    item_ids[2641031] = "Master Earring"
    item_ids[2641032] = "Chaos Ring"
    item_ids[2641033] = "Dark Ring"
    item_ids[2641034] = "Element Ring"
    item_ids[2641035] = "Three Stars"
    item_ids[2641036] = "Power Chain"
    item_ids[2641037] = "Golem Chain"
    item_ids[2641038] = "Titan Chain"
    item_ids[2641039] = "Energy Bangle"
    item_ids[2641040] = "Angel Bangle"
    item_ids[2641041] = "Gaia Bangle"
    item_ids[2641042] = "Magic Armlet"
    item_ids[2641043] = "Rune Armlet"
    item_ids[2641044] = "Atlas Armlet"
    item_ids[2641045] = "Heartguard"
    item_ids[2641046] = "Ribbon"
    item_ids[2641047] = "Crystal Crown"
    item_ids[2641048] = "Brave Warrior"
    item_ids[2641049] = "Ifrit's Horn"
    item_ids[2641050] = "Inferno Band"
    item_ids[2641051] = "White Fang"
    item_ids[2641052] = "Ray of Light"
    item_ids[2641053] = "Holy Circlet"
    item_ids[2641054] = "Raven's Claw"
    item_ids[2641055] = "Omega Arts"
    item_ids[2641056] = "EXP Earring"
    item_ids[2641057] = "A41"
    item_ids[2641058] = "EXP Ring"
    item_ids[2641059] = "EXP Bracelet"
    item_ids[2641060] = "EXP Necklace"
    item_ids[2641061] = "Firagun Band"
    item_ids[2641062] = "Blizzagun Band"
    item_ids[2641063] = "Thundagun Band"
    item_ids[2641064] = "Ifrit Belt"
    item_ids[2641065] = "Shiva Belt"
    item_ids[2641066] = "Ramuh Belt"
    item_ids[2641067] = "Moogle Badge"
    item_ids[2641068] = "Cosmic Arts"
    item_ids[2641069] = "Royal Crown"
    item_ids[2641070] = "Prime Cap"
    item_ids[2641071] = "Obsidian Ring"
    item_ids[2641072] = "A56"
    item_ids[2641073] = "A57"
    item_ids[2641074] = "A58"
    item_ids[2641075] = "A59"
    item_ids[2641076] = "A60"
    item_ids[2641077] = "A61"
    item_ids[2641078] = "A62"
    item_ids[2641079] = "A63"
    item_ids[2641080] = "A64"
    item_ids[2641081] = "Kingdom Key"
    item_ids[2641082] = "Dream Sword"
    item_ids[2641083] = "Dream Shield"
    item_ids[2641084] = "Dream Rod"
    item_ids[2641085] = "Wooden Sword"
    item_ids[2641086] = "Jungle King"
    item_ids[2641087] = "Three Wishes"
    item_ids[2641088] = "Fairy Harp"
    item_ids[2641089] = "Pumpkinhead"
    item_ids[2641090] = "Crabclaw"
    item_ids[2641091] = "Divine Rose"
    item_ids[2641092] = "Spellbinder"
    item_ids[2641093] = "Olympia"
    item_ids[2641094] = "Lionheart"
    item_ids[2641095] = "Metal Chocobo"
    item_ids[2641096] = "Oathkeeper"
    item_ids[2641097] = "Oblivion"
    item_ids[2641098] = "Lady Luck"
    item_ids[2641099] = "Wishing Star"
    item_ids[2641100] = "Ultima Weapon"
    item_ids[2641101] = "Diamond Dust"
    item_ids[2641102] = "One-Winged Angel; -"
    item_ids[2641103] = "Mage's Staff"
    item_ids[2641104] = "Morning Star"
    item_ids[2641105] = "Shooting Star"
    item_ids[2641106] = "Magus Staff"
    item_ids[2641107] = "Wisdom Staff"
    item_ids[2641108] = "Warhammer"
    item_ids[2641109] = "Silver Mallet"
    item_ids[2641110] = "Grand Mallet"
    item_ids[2641111] = "Lord Fortune"
    item_ids[2641112] = "Violetta"
    item_ids[2641113] = "Dream Rod (Donald)"
    item_ids[2641114] = "Save the Queen"
    item_ids[2641115] = "Wizard's Relic"
    item_ids[2641116] = "Meteor Strike"
    item_ids[2641117] = "Fantasista"
    item_ids[2641118] = "Unused (Donald)"
    item_ids[2641119] = "Knight's Shield"
    item_ids[2641120] = "Mythril Shield"
    item_ids[2641121] = "Onyx Shield"
    item_ids[2641122] = "Stout Shield"
    item_ids[2641123] = "Golem Shield"
    item_ids[2641124] = "Adamant Shield"
    item_ids[2641125] = "Smasher"
    item_ids[2641126] = "Gigas Fist"
    item_ids[2641127] = "Genji Shield"
    item_ids[2641128] = "Herc's Shield"
    item_ids[2641129] = "Dream Shield"
    item_ids[2641130] = "Save the King"
    item_ids[2641131] = "Defender"
    item_ids[2641132] = "Mighty Shield"
    item_ids[2641133] = "Seven Elements"
    item_ids[2641134] = "Unused (Goofy)"
    item_ids[2641135] = "Spear"
    item_ids[2641136] = "No Weapon"
    item_ids[2641137] = "Genie"
    item_ids[2641138] = "No Weapon"
    item_ids[2641139] = "No Weapon"
    item_ids[2641140] = "Tinker Bell"
    item_ids[2641141] = "Claws"
    item_ids[2641142] = "Tent"
    item_ids[2641143] = "Camping Set"
    item_ids[2641144] = "Cottage"
    item_ids[2641145] = "C04"
    item_ids[2641146] = "C05"
    item_ids[2641147] = "C06"
    item_ids[2641148] = "C07"
    item_ids[2641149] = "Ansem's Report 11"
    item_ids[2641150] = "Ansem's Report 12"
    item_ids[2641151] = "Ansem's Report 13"
    item_ids[2641152] = "Power Up"
    item_ids[2641153] = "Defense Up"
    item_ids[2641154] = "AP Up"
    item_ids[2641155] = "Serenity Power"
    item_ids[2641156] = "Dark Matter"
    item_ids[2641157] = "Mythril Stone"
    item_ids[2641158] = "Fire Arts"
    item_ids[2641159] = "Blizzard Arts"
    item_ids[2641160] = "Thunder Arts"
    item_ids[2641161] = "Cure Arts"
    item_ids[2641162] = "Gravity Arts"
    item_ids[2641163] = "Stop Arts"
    item_ids[2641164] = "Aero Arts"
    item_ids[2641165] = "Shiitank Rank"
    item_ids[2641166] = "Matsutake Rank"
    item_ids[2641167] = "Mystery Mold"
    item_ids[2641168] = "Ansem's Report 1"
    item_ids[2641169] = "Ansem's Report 2"
    item_ids[2641170] = "Ansem's Report 3"
    item_ids[2641171] = "Ansem's Report 4"
    item_ids[2641172] = "Ansem's Report 5"
    item_ids[2641173] = "Ansem's Report 6"
    item_ids[2641174] = "Ansem's Report 7"
    item_ids[2641175] = "Ansem's Report 8"
    item_ids[2641176] = "Ansem's Report 9"
    item_ids[2641177] = "Ansem's Report 10"
    item_ids[2641178] = "Khama Vol. 8"
    item_ids[2641179] = "Salegg Vol. 6"
    item_ids[2641180] = "Azal Vol. 3"
    item_ids[2641181] = "Mava Vol. 3"
    item_ids[2641182] = "Mava Vol. 6"
    item_ids[2641183] = "Theon Vol. 6"
    item_ids[2641184] = "Nahara Vol. 5"
    item_ids[2641185] = "Hafet Vol. 4"
    item_ids[2641186] = "Empty Bottle"
    item_ids[2641187] = "Old Book"
    item_ids[2641188] = "Emblem Piece (Flame)"
    item_ids[2641189] = "Emblem Piece (Chest)"
    item_ids[2641190] = "Emblem Piece (Statue)"
    item_ids[2641191] = "Emblem Piece (Fountain)"
    item_ids[2641192] = "Log"
    item_ids[2641193] = "Cloth"
    item_ids[2641194] = "Rope"
    item_ids[2641195] = "Seagull Egg"
    item_ids[2641196] = "Fish"
    item_ids[2641197] = "Mushroom"
    item_ids[2641198] = "Coconut"
    item_ids[2641199] = "Drinking Water"
    item_ids[2641200] = "Navi-G Piece 1"
    item_ids[2641201] = "Navi-G Piece 2"
    item_ids[2641202] = "Navi-Gummi Unused"
    item_ids[2641203] = "Navi-G Piece 3"
    item_ids[2641204] = "Navi-G Piece 4"
    item_ids[2641205] = "Navi-Gummi"
    item_ids[2641206] = "Watergleam"
    item_ids[2641207] = "Naturespark"
    item_ids[2641208] = "Fireglow"
    item_ids[2641209] = "Earthshine"
    item_ids[2641210] = "Crystal Trident"
    item_ids[2641211] = "Postcard"
    item_ids[2641212] = "Torn Page 1"
    item_ids[2641213] = "Torn Page 2"
    item_ids[2641214] = "Torn Page 3"
    item_ids[2641215] = "Torn Page 4"
    item_ids[2641216] = "Torn Page 5"
    item_ids[2641217] = "Slide 1"
    item_ids[2641218] = "Slide 2"
    item_ids[2641219] = "Slide 3"
    item_ids[2641220] = "Slide 4"
    item_ids[2641221] = "Slide 5"
    item_ids[2641222] = "Slide 6"
    item_ids[2641223] = "Footprints"
    item_ids[2641224] = "Claw Marks"
    item_ids[2641225] = "Stench"
    item_ids[2641226] = "Antenna"
    item_ids[2641227] = "Forget-Me-Not"
    item_ids[2641228] = "Jack-In-The-Box"
    item_ids[2641229] = "Entry Pass"
    item_ids[2641230] = "Hero License"
    item_ids[2641231] = "Pretty Stone"
    item_ids[2641232] = "N41"
    item_ids[2641233] = "Lucid Shard"
    item_ids[2641234] = "Lucid Gem"
    item_ids[2641235] = "Lucid Crystal"
    item_ids[2641236] = "Spirit Shard"
    item_ids[2641237] = "Spirit Gem"
    item_ids[2641238] = "Power Shard"
    item_ids[2641239] = "Power Gem"
    item_ids[2641240] = "Power Crystal"
    item_ids[2641241] = "Blaze Shard"
    item_ids[2641242] = "Blaze Gem"
    item_ids[2641243] = "Frost Shard"
    item_ids[2641244] = "Frost Gem"
    item_ids[2641245] = "Thunder Shard"
    item_ids[2641246] = "Thunder Gem"
    item_ids[2641247] = "Shiny Crystal"
    item_ids[2641248] = "Bright Shard"
    item_ids[2641249] = "Bright Gem"
    item_ids[2641250] = "Bright Crystal"
    item_ids[2641251] = "Mystery Goo"
    item_ids[2641252] = "Gale"
    item_ids[2641253] = "Mythril Shard"
    item_ids[2641254] = "Mythril"
    item_ids[2641255] = "Orichalcum"
    item_ids[2642001] = "High Jump"
    item_ids[2642002] = "Mermaid Kick"
    item_ids[2642003] = "Glide"
    item_ids[2642004] = "Superglide"
    item_ids[2643005] = "Treasure Magnet"
    item_ids[2643006] = "Combo Plus"
    item_ids[2643007] = "Air Combo Plus"
    item_ids[2643008] = "Critical Plus"
    item_ids[2643009] = "Second Wind"
    item_ids[2643010] = "Scan"
    item_ids[2643011] = "Sonic Blade"
    item_ids[2643012] = "Ars Arcanum"
    item_ids[2643013] = "Strike Raid"
    item_ids[2643014] = "Ragnarok"
    item_ids[2643015] = "Trinity Limit"
    item_ids[2643016] = "Cheer"
    item_ids[2643017] = "Vortex"
    item_ids[2643018] = "Aerial Sweep"
    item_ids[2643019] = "Counterattack"
    item_ids[2643020] = "Blitz"
    item_ids[2643021] = "Guard"
    item_ids[2643022] = "Dodge Roll"
    item_ids[2643023] = "MP Haste"
    item_ids[2643024] = "MP Rage"
    item_ids[2643025] = "Second Chance"
    item_ids[2643026] = "Berserk"
    item_ids[2643027] = "Jackpot"
    item_ids[2643028] = "Lucky Strike"
    item_ids[2643029] = "Charge"
    item_ids[2643030] = "Rocket"
    item_ids[2643031] = "Tornado"
    item_ids[2643032] = "MP Gift"
    item_ids[2643033] = "Raging Boar"
    item_ids[2643034] = "Asp's Bite"
    item_ids[2643035] = "Healing Herb"
    item_ids[2643036] = "Wind Armor"
    item_ids[2643037] = "Crescent"
    item_ids[2643038] = "Sandstorm"
    item_ids[2643039] = "Applause!"
    item_ids[2643040] = "Blazing Fury"
    item_ids[2643041] = "Icy Terror"
    item_ids[2643042] = "Bolts of Sorrow"
    item_ids[2643043] = "Ghostly Scream"
    item_ids[2643044] = "Humming Bird"
    item_ids[2643045] = "Time-Out"
    item_ids[2643046] = "Storm's Eye"
    item_ids[2643047] = "Ferocious Lunge"
    item_ids[2643048] = "Furious Bellow"
    item_ids[2643049] = "Spiral Wave"
    item_ids[2643050] = "Thunder Potion"
    item_ids[2643051] = "Cure Potion"
    item_ids[2643052] = "Aero Potion"
    item_ids[2643053] = "Slapshot"
    item_ids[2643054] = "Sliding Dash"
    item_ids[2643055] = "Hurricane Blast"
    item_ids[2643056] = "Ripple Drive"
    item_ids[2643057] = "Stun Impact"
    item_ids[2643058] = "Gravity Break"
    item_ids[2643059] = "Zantetsuken"
    item_ids[2643060] = "Tech Boost"
    item_ids[2643061] = "Encounter Plus"
    item_ids[2643062] = "Leaf Bracer"
    item_ids[2643063] = "Evolution"
    item_ids[2643064] = "EXP Zero"
    item_ids[2643065] = "Combo Master"
    item_ids[2644001] = "Max HP Up"
    item_ids[2644002] = "Max MP Up"
    item_ids[2644003] = "Max AP Up"
    item_ids[2644004] = "Strength Up"
    item_ids[2644005] = "Defense Up"
    item_ids[2644006] = "Item Slot Up"
    item_ids[2644007] = "Accessory Slot Up"
    item_ids[2645000] = "Dumbo"
    item_ids[2645001] = "Bambi"
    item_ids[2645002] = "Genie"
    item_ids[2645003] = "Tinker Bell"
    item_ids[2645004] = "Mushu"
    item_ids[2645005] = "Simba"
    item_ids[2646001] = "Progressive Fire"
    item_ids[2646002] = "Progressive Blizzard"
    item_ids[2646003] = "Progressive Thunder"
    item_ids[2646004] = "Progressive Cure"
    item_ids[2646005] = "Progressive Gravity"
    item_ids[2646006] = "Progressive Stop"
    item_ids[2646007] = "Progressive Aero"
    item_ids[2647002] = "Wonderland"
    item_ids[2647003] = "Olympus Coliseum"
    item_ids[2647004] = "Deep Jungle"
    item_ids[2647005] = "Agrabah"
    item_ids[2647006] = "Halloween Town"
    item_ids[2647007] = "Atlantica"
    item_ids[2647008] = "Neverland"
    item_ids[2647009] = "Hollow Bastion"
    item_ids[2647010] = "End of the World"
    item_ids[2647011] = "Monstro"
    item_ids[2648001] = "Blue Trinity"
    item_ids[2648002] = "Red Trinity"
    item_ids[2648003] = "Green Trinity"
    item_ids[2648004] = "Yellow Trinity"
    item_ids[2648005] = "White Trinity"
    item_ids[2649001] = "Phil Cup"
    item_ids[2649002] = "Pegasus Cup"
    item_ids[2649003] = "Hercules Cup"
    item_ids[2649004] = "Hades Cup"
    return item_ids
end

item_ids = define_item_ids()

function read_chests_opened_array()
    --Reads an array of bits which represent which chests have been opened by the player
    chests_opened_address = 0x2DE5F9C - offset
    chest_array = ReadArray(chests_opened_address, 509)
    return chest_array
end

function read_soras_abilities_array()
    --Reads an array of Sora's abilties.  The first 7 bits define the ability,
    --while the last bit defines whether its equiped.
    soras_abilities_address   = 0x2DE5A14 - offset
    return ReadArray(soras_abilities_address, 40)
end

function read_soras_level()
    --Reads Sora's Current Level
    soras_level_address = 0x2DE5A08 - offset
    return ReadShort(soras_level_address)
end

function read_shared_abilities_array()
    --Reads an array of the player's current shared abilities.
    shared_abilties_addresss = 0x2DE5F68 - offset
    return ReadArray(shared_abilties_addresss, 4)
end

function read_soras_stats_array()
    --Reads an array of Sora's stats
    soras_stats_address         = 0x2DE59D6 - offset
    sora_hp_offset              = 0x0
    sora_mp_offset              = 0x2
    sora_ap_offset              = 0x3
    sora_strength_offset        = 0x4
    sora_defense_offset         = 0x5
    sora_accessory_slots_offset = 0x16
    sora_item_slots_offset      = 0x1F
    return {ReadByte(soras_stats_address + sora_hp_offset)
          , ReadByte(soras_stats_address + sora_mp_offset)
          , ReadByte(soras_stats_address + sora_ap_offset)
          , ReadByte(soras_stats_address + sora_strength_offset)
          , ReadByte(soras_stats_address + sora_defense_offset)
          , ReadByte(soras_stats_address + sora_accessory_slots_offset)
          , ReadByte(soras_stats_address + sora_item_slots_offset)}
end

function read_check_array()
    --Reads the current check number by getting the sum total of the 3 AP items
    inventory_address = 0x2DE5E69 - offset
    check_number_item_address = inventory_address + 0x48
    return ReadArray(check_number_item_address, 3)
end

function read_room()
    --Gets the numeric value of the currently occupied room
    world_address = 0x233CADC - offset
    room_address = world_address + 0x68
    return ReadByte(room_address)
end

function read_world()
    --Gets the numeric value of the currently occupied world
    world_address = 0x233CADC - offset
    return ReadByte(world_address)
end

function read_chronicles()
    chronicles_address = 0x2DE7367 - offset
    chronicles_array = ReadArray(chronicles_address, 36)
    return chronicles_array
end

function read_ansems_secret_reports()
    ansems_secret_reports = 0x2DE7390 - offset
    ansems_secret_reports_array = ReadArray(ansems_secret_reports, 2)
    return ansems_secret_reports_array
end

function read_olympus_cups_array()
    olympus_cups_address = 0x2DE77D0 - offset
    return ReadArray(olympus_cups_address, 4)
end

function write_world_lines()
    --Opens all world connections on the world map
    world_map_lines_address = 0x2DE78E2 - offset
    WriteArray(world_map_lines_address, {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF})
end

function write_rewards()
    --Removes all obtained items from rewards
    battle_table_address = 0x2D1F3C0 - offset
    rewards_offset = 0xC6A8
    reward_array = {}
    local i = 1
    while i <= 169 * 2 do
        reward_array[i] = 0x00
        i = i + 1
    end
    WriteArray(battle_table_address + rewards_offset, reward_array)
end

function write_chests()
    --Removes all obtained items from chests
    chest_table_address = 0x5259E0 - offset
    chest_array = {}
    local i = 1
    while i <= 511 * 2 do
        chest_array[i] = 0x00
        i = i + 1
    end
    WriteArray(chest_table_address, chest_array)
end

function write_unlocked_worlds(unlocked_worlds_array, monstro_unlocked)
    --Writes unlocked worlds.  Array of 11 values, one for each world
    --TT, WL, OC, DJ, AG, AT, HT, NL, HB, EW, MS
    --00 is invisible
    --01 is visible/unvisited
    --02 is selectable/unvisited
    --03 is incomplete
    --04 is complete
    world_status_address = 0x2DE78C0 - offset
    monstro_status_addresss = world_status_address + 0xA
    WriteArray(world_status_address, unlocked_worlds_array)
    WriteByte(monstro_status_addresss, monstro_unlocked)
end

function write_synth_requirements()
    --Writes to the synth requirements array, making the first 20 items require 
    --an unobtainable material, preventing the player from synthing.
    synth_requirements_address = 0x544320 - offset
    synth_array = {}
    local i = 0
    while i < 20 do --First 20 items should be enough to prevent player from unlocking more recipes
        synth_array[(i*4) + 1] = 0xE8 --Requirement (unobtainable)
        synth_array[(i*4) + 2] = 0x00 --Blank
        synth_array[(i*4) + 3] = 0x01 --Number of items needed
        synth_array[(i*4) + 4] = 0x00 --Blank
        i = i + 1
    end
    WriteArray(synth_requirements_address, synth_array)
end

function write_soras_level_up_rewards()
    --Writes Sora's level up rewards to make them empty.
    --Level up rewards will be handled by the client/server.
    battle_table_address = 0x2D1F3C0 - offset
    soras_stat_level_up_rewards_address = battle_table_address + 0x3AC0
    overwrite_array = {}
    local i = 1
    while i <= 99 do
        overwrite_array[i] = 0
        i = i + 1
    end
    WriteArray(soras_stat_level_up_rewards_address, overwrite_array)
end

function write_soras_stats(soras_stats_array)
    --Writes Sora's calculated stats back to memory
    soras_stats_address         = 0x2DE59D6 - offset
    sora_hp_offset              = 0x00
    sora_mp_offset              = 0x02
    sora_ap_offset              = 0x03
    sora_strength_offset        = 0x04
    sora_defense_offset         = 0x05
    sora_accessory_slots_offset = 0x16
    sora_item_slots_offset      = 0x1F
    WriteByte(soras_stats_address + sora_hp_offset              , soras_stats_array[1])
    WriteByte(soras_stats_address + sora_mp_offset              , soras_stats_array[2])
    WriteByte(soras_stats_address + sora_ap_offset              , soras_stats_array[3])
    WriteByte(soras_stats_address + sora_strength_offset        , soras_stats_array[4])
    WriteByte(soras_stats_address + sora_defense_offset         , soras_stats_array[5])
    WriteByte(soras_stats_address + sora_accessory_slots_offset , soras_stats_array[6])
    WriteByte(soras_stats_address + sora_item_slots_offset      , soras_stats_array[7])
end

function write_check_array(check_array)
    inventory_address = 0x2DE5E69 - offset
    check_number_item_address = inventory_address + 0x48
    WriteArray(check_number_item_address, check_array)
end

function write_evidence_chests()
    lotus_forest_evidence_address = 0x2D39B90 - offset
    bizarre_rooom_evidence_address = 0x2D39230 - offset
    --if read_world() == 4 then
    --    if read_room() == 4 then
    --        WriteLong(lotus_forest_evidence_address, 0)
    --        WriteLong(lotus_forest_evidence_address + 0x4B0, 0)
    --    elseif read_room() == 1 then
    --        WriteLong(bizarre_rooom_evidence_address, 0)
    --        WriteLong(bizarre_rooom_evidence_address + 0x4B0, 0)
    --    end
    --end
    if read_world() == 4 then
        if read_room() == 4 then
            local o = 0
            while ReadInt(lotus_forest_evidence_address+4+o*0x4B0) ~= 0x40013 and ReadInt(lotus_forest_evidence_address+4+o*0x4B0) ~= 0 and o > -5 do
                o = o-1
            end
            if ReadLong(lotus_forest_evidence_address+o*0x4B0) == 0x0004001300008203 then
                WriteLong(lotus_forest_evidence_address+o*0x4B0, 0)
                WriteLong(lotus_forest_evidence_address+(o+1)*0x4B0, 0)
            end
        elseif read_room() == 1 then
            local o = 0
            while ReadInt(bizarre_rooom_evidence_address+4+o*0x4B0) ~= 0x40013 and ReadInt(bizarre_rooom_evidence_address+4+o*0x4B0) ~= 0 and o > -5 do
                o = o-1
            end
            if ReadLong(bizarre_rooom_evidence_address+o*0x4B0) == 0x0004001300008003 then
                    WriteLong(bizarre_rooom_evidence_address+o*0x4B0, 0)
                    WriteLong(bizarre_rooom_evidence_address+(o+1)*0x4B0, 0)
                end
            end
        end
end

function write_slides()
    slide_address = 0x2D3CA70 - offset
    if read_world() == 5 and read_room() == 12 then
        for i=0,5 do
            local o = 0
            while ReadInt(slide_address+o*0x4B0+4) ~= 0x40018 and ReadInt(slide_address+o*0x4B0+4) ~= 0 and o > -5 do
                o = o-1
            end
            if ReadInt(slide_address+o*0x4B0+4) == 0x40018 then
                for i=0,5 do
                    if ReadInt(slide_address+(i+o)*0x4B0+4) == 0x40018+(i>1 and i+4 or i) then
                        WriteLong(slide_address+(i+o)*0x4B0, 0)
                    end
                end
            end
        end
    end
end

function write_item(item_offset)
    inventory_address = 0x2DE5E69 - offset
    WriteByte(inventory_address + item_offset, ReadByte(inventory_address + item_offset) + 1)
end

function write_sora_ability(ability_value)
    abilities_address = 0x2DE5A13 - offset
    local i = 1
    while ReadByte(abilities_address + i) ~= 0 do
        i = i + 1
    end
    WriteByte(abilities_address + i, ability_value + 128)
end

function write_shared_abilities_array(shared_abilities_array)
    shared_abilities_address = 0x2DE5F69 - offset
    WriteArray(shared_abilities_address, shared_abilities_array)
end

function write_summons_array(summons_array)
    summons_address = 0x2DE61A0 - offset
    WriteArray(summons_address, summons_array)
end

function write_magic(magic_unlocked_bits, magic_levels_array)
    magic_unlocked_address = 0x2DE5A44 - offset
    magic_levels_offset = 0x41E
    WriteByte(magic_unlocked_address, 
        (1 * magic_unlocked_bits[1]) + (2 * magic_unlocked_bits[2]) + (4 * magic_unlocked_bits[3]) + (8 * magic_unlocked_bits[4]) 
        + (16 * magic_unlocked_bits[5]) + (32 * magic_unlocked_bits[6]) + (64 * magic_unlocked_bits[7]))
    WriteArray(magic_unlocked_address + magic_levels_offset, magic_levels_array)
end

function write_trinities(trinity_bits)
    trinities_unlocked_address = 0x2DE75EB - offset
    WriteByte(trinities_unlocked_address, (1 * trinity_bits[1]) + (2 * trinity_bits[2]) + (4 * trinity_bits[3]) + (8 * trinity_bits[4]) + (16 * trinity_bits[5]))
end

function write_olympus_cups(olympus_cups_array)
    olympus_cups_address = 0x2DE77D0 - offset
    current_olympus_cups_array = read_olympus_cups_array()
    for k,v in pairs(current_olympus_cups_array) do
        if v == 1 then
            olympus_cups_array[k] = v
        end
    end
    WriteArray(olympus_cups_address, olympus_cups_array)
end

function write_level_up_rewards()
    battle_table_address = 0x2D1F3C0 - offset
    level_up_rewards_offset = 0x3AC0
    abilities_1_table_offset = 0x3BF8
    abilities_2_table_offset = 0x3BF8 - 0xD0
    abilities_3_table_offset = 0x3BF8 - 0x68
    level_up_array = {}
    ability_array = {}
    local i = 1
    while i <= 100 do
        level_up_array[i] = 0
        i = i + 1
    end
    WriteArray(battle_table_address + level_up_rewards_offset, level_up_array)
    WriteArray(battle_table_address + abilities_1_table_offset, level_up_array)
    WriteArray(battle_table_address + abilities_2_table_offset, level_up_array)
    WriteArray(battle_table_address + abilities_3_table_offset, level_up_array)
end

function write_e()
    inventory_address = 0x2DE5E69 - offset
    WriteByte(inventory_address, 0)
end

function increment_check_array(check_array)
    if check_array[1] == 255 and check_array[2] == 255 then
        check_array[3] = check_array[3] + 1
    elseif check_array[1] == 255 then
        check_array[2] = check_array[2] + 1
    else
        check_array[1] = check_array[1] + 1
    end
    return check_array
end

function add_to_soras_stats(value)
    stat_increases = {3, 1, 2, 2, 2, 1, 1}
    soras_stats_array = read_soras_stats_array()
    soras_stats_array[value] = soras_stats_array[value] + stat_increases[value]
    write_soras_stats(soras_stats_array)
end

function add_to_shared_abilities_array(shared_abilities_array, value)
    local i = 1
    while shared_abilities_array[i] ~= 0 do
        i = i + 1
    end
    shared_abilities_array[i] = value
    return shared_abilities_array
end

function add_to_summons_array(summons_array, value)
    local i = 1
    while summons_array[i] < 10 do
        i = i + 1
    end
    summons_array[i] = value
    return summons_array
end

function receive_items()
    check_array = read_check_array()
    i = check_array[1] + check_array[2] + check_array[3] + 1
    while file_exists(client_communication_path .. "AP_" .. tostring(i) .. ".item") do
        file = io.open(client_communication_path .. "AP_" .. tostring(i) .. ".item", "r")
        io.input(file)
        received_item_id = tonumber(io.read())
        io.close(file)
        if received_item_id >= 2641000 and received_item_id < 2642000 then
            write_item(received_item_id % 2641000)
        elseif received_item_id >= 2643000 and received_item_id < 2644000 then
            write_sora_ability(received_item_id % 2643000)
        elseif received_item_id >= 2644000 and received_item_id < 2645000 then
            add_to_soras_stats(received_item_id % 2644000)
        end
        check_array = increment_check_array(check_array)
        i = i + 1
    end
    write_check_array(check_array)
end

function calculate_full()
    magic_unlocked_bits = {0, 0, 0, 0, 0, 0, 0}
    magic_levels_array  = {0, 0, 0, 0, 0, 0, 0}
    worlds_unlocked_array = {3, 0, 0, 0, 0, 0, 0, 0, 0}
    monstro_unlocked = 0
    shared_abilities_array = {0, 0, 0, 0}
    summons_array = {255, 255, 255, 255, 255, 255}
    trinity_bits = {0, 0, 0, 0, 0}
    olympus_cups_array = {0, 0, 0, 0}
    victory = false
    local i = 1
    while file_exists(client_communication_path .. "AP_" .. tostring(i) .. ".item") do
        file = io.open(client_communication_path .. "AP_" .. tostring(i) .. ".item", "r")
        io.input(file)
        received_item_id = tonumber(io.read())
        io.close(file)
        if received_item_id == 2640000 then
            victory = true
        elseif received_item_id >= 2642000 and received_item_id < 2643000 then
            shared_abilities_array = add_to_shared_abilities_array(shared_abilities_array, received_item_id % 2642000)
        elseif received_item_id >= 2645000 and received_item_id < 2646000 then
            summons_array = add_to_summons_array(summons_array, received_item_id % 2645000)
        elseif received_item_id >= 2646000 and received_item_id < 2647000 then
            magic_unlocked_bits[received_item_id % 2646000] = 1
            magic_levels_array[received_item_id % 2646000] = magic_levels_array[received_item_id % 2646000] + 1
        elseif received_item_id >= 2647000 and received_item_id < 2648000 then
            if received_item_id % 2647000 < 10 then
                worlds_unlocked_array[received_item_id % 2647000] = 3
            elseif received_item_id % 2647000 == 11 then
                monstro_unlocked = 3
            end
        elseif received_item_id >= 2648000 and received_item_id < 2649000 then
            trinity_bits[received_item_id % 2648000] = 1
        elseif received_item_id >= 2649000 then
            olympus_cups_array[received_item_id % 2649000] = 10
        end
        i = i + 1
    end
    if olympus_cups_array[1] == 10 and olympus_cups_array[2] == 10 and olympus_cups_array[3] == 10 then
        olympus_cups_array[4] = 10
    end
    write_magic(magic_unlocked_bits, magic_levels_array)
    write_shared_abilities_array(shared_abilities_array)
    write_summons_array(summons_array)
    write_trinities(trinity_bits)
    write_olympus_cups(olympus_cups_array)
    return victory
end

function send_locations()
    chest_array = read_chests_opened_array()
    chronicles_array = read_chronicles()
    ansems_secret_reports_array = read_ansems_secret_reports()
    soras_level = read_soras_level()
    olympus_cups_array = read_olympus_cups_array()
    for k,v in pairs(chest_array) do
        bits = toBits(v)
        for ik,iv in pairs(bits) do
            if iv == 1 then
                location_id = 2650000 + k * 10 + ik
                if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
                    file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
                    io.output(file)
                    io.write("")
                    io.close(file)
                end
            end
        end
    end
    for k,v in pairs(chronicles_array) do
        bits = toBits(v)
        for ik,iv in pairs(bits) do
            if iv == 1 then
                location_id = 2656000 + k * 10 + ik
                if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
                    file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
                    io.output(file)
                    io.write("")
                    io.close(file)
                end
            end
        end
    end
    for k,v in pairs(ansems_secret_reports_array) do
        bits = toBits(v)
        for ik,iv in pairs(bits) do
            if iv == 1 then
                location_id = 2657000 + k * 10 + ik
                if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
                    file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
                    io.output(file)
                    io.write("")
                    io.close(file)
                end
            end
        end
    end
    for j=1,soras_level do
        location_id = 2658000 + j
        if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
            file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end
    for j=1,#olympus_cups_array do
        if olympus_cups_array[j] == 1 then
            location_id = 2659000 + j
            if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
                file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
                io.output(file)
                io.write("")
                io.close(file)
            end
        end
    end
    if victory then
        if not file_exists(client_communication_path .. "victory") then
            file = io.open(client_communication_path .. "victory", "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end
end

function main()
    receive_items()
    victory = calculate_full()
    send_locations(victory)
    
    --Cleaning up static things
    write_synth_requirements()
    write_chests()
    write_rewards()
    --write_evidence_chests()
    --write_slides()
    write_world_lines()
    write_level_up_rewards()
    write_e()
end

function test()
    chests_opened_array = read_chests_opened_array()
    ConsolePrint(toBits(chests_opened_array[21])[1])
    write_world_lines()
    write_unlocked_worlds({0x3, 0x0, 0x3, 0x0, 0x0, 0x0, 0x0, 0x3, 0x0, 0x0, 0x0})
    write_synth_requirements()
    soras_abilities = read_soras_abilities_array()
    ConsolePrint(soras_abilities[1])
    ConsolePrint("Sora's Current Level: " .. tostring(read_soras_level()))
    check_array = read_check_array()
    check_number = check_array[1] + check_array[2] + check_array[3]
    ConsolePrint("Current check number: " .. tostring(check_number))
    sora_stats_array = read_soras_stats_array()
    ConsolePrint("Sora's Max HP = " .. tostring(sora_stats_array[1]))
    write_rewards()
    write_chests()
    ConsolePrint("Current World: " .. tostring(read_world()))
    ConsolePrint("Current Room: " .. tostring(read_room()))
    write_evidence_chests()
    write_slides()
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
    if frame_count % 120 == 0 and canExecute then
        main()
        --test()
        write_unlocked_worlds(worlds_unlocked_array, monstro_unlocked)
    end
    frame_count = frame_count + 1
end