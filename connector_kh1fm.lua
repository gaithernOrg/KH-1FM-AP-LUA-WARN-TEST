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

--- Addresses ---
offset = 0x3A0606

--- Definitions ---
function define_item_ids()
    item_ids = {}
    item_ids["Potion"]                  = 2641001
    item_ids["Hi-Potion"]               = 2641002
    item_ids["Ether"]                   = 2641003
    item_ids["Elixir"]                  = 2641004
    item_ids["BO5"]                     = 2641005
    item_ids["Mega-Potion"]             = 2641006
    item_ids["Mega-Ether"]              = 2641007
    item_ids["Megalixir"]               = 2641008
    item_ids["Fury Stone"]              = 2641009
    item_ids["Power Stone"]             = 2641010
    item_ids["Energy Stone"]            = 2641011
    item_ids["Blazing Stone"]           = 2641012
    item_ids["Frost Stone"]             = 2641013
    item_ids["Lightning Stone"]         = 2641014
    item_ids["Dazzling Stone"]          = 2641015
    item_ids["Stormy Stone"]            = 2641016
    item_ids["Protect Chain"]           = 2641017
    item_ids["Protera Chain"]           = 2641018
    item_ids["Protega Chain"]           = 2641019
    item_ids["Fire Ring"]               = 2641020
    item_ids["Fira Ring"]               = 2641021
    item_ids["Firaga Ring"]             = 2641022
    item_ids["Blizzard Ring"]           = 2641023
    item_ids["Blizzara Ring"]           = 2641024
    item_ids["Blizzaga Ring"]           = 2641025
    item_ids["Thunder Ring"]            = 2641026
    item_ids["Thundara Ring"]           = 2641027
    item_ids["Thundaga Ring"]           = 2641028
    item_ids["Ability Stud"]            = 2641029
    item_ids["Guard Earring"]           = 2641030
    item_ids["Master Earring"]          = 2641031
    item_ids["Chaos Ring"]              = 2641032
    item_ids["Dark Ring"]               = 2641033
    item_ids["Element Ring"]            = 2641034
    item_ids["Three Stars"]             = 2641035
    item_ids["Power Chain"]             = 2641036
    item_ids["Golem Chain"]             = 2641037
    item_ids["Titan Chain"]             = 2641038
    item_ids["Energy Bangle"]           = 2641039
    item_ids["Angel Bangle"]            = 2641040
    item_ids["Gaia Bangle"]             = 2641041
    item_ids["Magic Armlet"]            = 2641042
    item_ids["Rune Armlet"]             = 2641043
    item_ids["Atlas Armlet"]            = 2641044
    item_ids["Heartguard"]              = 2641045
    item_ids["Ribbon"]                  = 2641046
    item_ids["Crystal Crown"]           = 2641047
    item_ids["Brave Warrior"]           = 2641048
    item_ids["Ifrit's Horn"]            = 2641049
    item_ids["Inferno Band"]            = 2641050
    item_ids["White Fang"]              = 2641051
    item_ids["Ray of Light"]            = 2641052
    item_ids["Holy Circlet"]            = 2641053
    item_ids["Raven's Claw"]            = 2641054
    item_ids["Omega Arts"]              = 2641055
    item_ids["EXP Earring"]             = 2641056
    item_ids["A41"]                     = 2641057
    item_ids["EXP Ring"]                = 2641058
    item_ids["EXP Bracelet"]            = 2641059
    item_ids["EXP Necklace"]            = 2641060
    item_ids["Firagun Band"]            = 2641061
    item_ids["Blizzagun Band"]          = 2641062
    item_ids["Thundagun Band"]          = 2641063
    item_ids["Ifrit Belt"]              = 2641064
    item_ids["Shiva Belt"]              = 2641065
    item_ids["Ramuh Belt"]              = 2641066
    item_ids["Moogle Badge"]            = 2641067
    item_ids["Cosmic Arts"]             = 2641068
    item_ids["Royal Crown"]             = 2641069
    item_ids["Prime Cap"]               = 2641070
    item_ids["Obsidian Ring"]           = 2641071
    item_ids["A56"]                     = 2641072
    item_ids["A57"]                     = 2641073
    item_ids["A58"]                     = 2641074
    item_ids["A59"]                     = 2641075
    item_ids["A60"]                     = 2641076
    item_ids["A61"]                     = 2641077
    item_ids["A62"]                     = 2641078
    item_ids["A63"]                     = 2641079
    item_ids["A64"]                     = 2641080
    item_ids["Kingdom Key"]             = 2641081
    item_ids["Dream Sword"]             = 2641082
    item_ids["Dream Shield"]            = 2641083
    item_ids["Dream Rod"]               = 2641084
    item_ids["Wooden Sword"]            = 2641085
    item_ids["Jungle King"]             = 2641086
    item_ids["Three Wishes"]            = 2641087
    item_ids["Fairy Harp"]              = 2641088
    item_ids["Pumpkinhead"]             = 2641089
    item_ids["Crabclaw"]                = 2641090
    item_ids["Divine Rose"]             = 2641091
    item_ids["Spellbinder"]             = 2641092
    item_ids["Olympia"]                 = 2641093
    item_ids["Lionheart"]               = 2641094
    item_ids["Metal Chocobo"]           = 2641095
    item_ids["Oathkeeper"]              = 2641096
    item_ids["Oblivion"]                = 2641097
    item_ids["Lady Luck"]               = 2641098
    item_ids["Wishing Star"]            = 2641099
    item_ids["Ultima Weapon"]           = 2641100
    item_ids["Diamond Dust"]            = 2641101
    item_ids["One-Winged Angel; -"]     = 2641102
    item_ids["Mage's Staff"]            = 2641103
    item_ids["Morning Star"]            = 2641104
    item_ids["Shooting Star"]           = 2641105
    item_ids["Magus Staff"]             = 2641106
    item_ids["Wisdom Staff"]            = 2641107
    item_ids["Warhammer"]               = 2641108
    item_ids["Silver Mallet"]           = 2641109
    item_ids["Grand Mallet"]            = 2641110
    item_ids["Lord Fortune"]            = 2641111
    item_ids["Violetta"]                = 2641112
    item_ids["Dream Rod (Donald)"]      = 2641113
    item_ids["Save the Queen"]          = 2641114
    item_ids["Wizard's Relic"]          = 2641115
    item_ids["Meteor Strike"]           = 2641116
    item_ids["Fantasista"]              = 2641117
    item_ids["Unused (Donald)"]         = 2641118
    item_ids["Knight's Shield"]         = 2641119
    item_ids["Mythril Shield"]          = 2641120
    item_ids["Onyx Shield"]             = 2641121
    item_ids["Stout Shield"]            = 2641122
    item_ids["Golem Shield"]            = 2641123
    item_ids["Adamant Shield"]          = 2641124
    item_ids["Smasher"]                 = 2641125
    item_ids["Gigas Fist"]              = 2641126
    item_ids["Genji Shield"]            = 2641127
    item_ids["Herc's Shield"]           = 2641128
    item_ids["Dream Shield"]            = 2641129
    item_ids["Save the King"]           = 2641130
    item_ids["Defender"]                = 2641131
    item_ids["Mighty Shield"]           = 2641132
    item_ids["Seven Elements"]          = 2641133
    item_ids["Unused (Goofy)"]          = 2641134
    item_ids["Spear"]                   = 2641135
    item_ids["No Weapon"]               = 2641136
    item_ids["Genie"]                   = 2641137
    item_ids["No Weapon"]               = 2641138
    item_ids["No Weapon"]               = 2641139
    item_ids["Tinker Bell"]             = 2641140
    item_ids["Claws"]                   = 2641141
    item_ids["Tent"]                    = 2641142
    item_ids["Camping Set"]             = 2641143
    item_ids["Cottage"]                 = 2641144
    item_ids["C04"]                     = 2641145
    item_ids["C05"]                     = 2641146
    item_ids["C06"]                     = 2641147
    item_ids["C07"]                     = 2641148
    item_ids["Ansem's Report 11"]       = 2641149
    item_ids["Ansem's Report 12"]       = 2641150
    item_ids["Ansem's Report 13"]       = 2641151
    item_ids["Power Up"]                = 2641152
    item_ids["Defense Up"]              = 2641153
    item_ids["AP Up"]                   = 2641154
    item_ids["Serenity Power"]          = 2641155
    item_ids["Dark Matter"]             = 2641156
    item_ids["Mythril Stone"]           = 2641157
    item_ids["Fire Arts"]               = 2641158
    item_ids["Blizzard Arts"]           = 2641159
    item_ids["Thunder Arts"]            = 2641160
    item_ids["Cure Arts"]               = 2641161
    item_ids["Gravity Arts"]            = 2641162
    item_ids["Stop Arts"]               = 2641163
    item_ids["Aero Arts"]               = 2641164
    item_ids["Shiitank Rank"]           = 2641165
    item_ids["Matsutake Rank"]          = 2641166
    item_ids["Mystery Mold"]            = 2641167
    item_ids["Ansem's Report 1"]        = 2641168
    item_ids["Ansem's Report 2"]        = 2641169
    item_ids["Ansem's Report 3"]        = 2641170
    item_ids["Ansem's Report 4"]        = 2641171
    item_ids["Ansem's Report 5"]        = 2641172
    item_ids["Ansem's Report 6"]        = 2641173
    item_ids["Ansem's Report 7"]        = 2641174
    item_ids["Ansem's Report 8"]        = 2641175
    item_ids["Ansem's Report 9"]        = 2641176
    item_ids["Ansem's Report 10"]       = 2641177
    item_ids["Khama Vol. 8"]            = 2641178
    item_ids["Salegg Vol. 6"]           = 2641179
    item_ids["Azal Vol. 3"]             = 2641180
    item_ids["Mava Vol. 3"]             = 2641181
    item_ids["Mava Vol. 6"]             = 2641182
    item_ids["Theon Vol. 6"]            = 2641183
    item_ids["Nahara Vol. 5"]           = 2641184
    item_ids["Hafet Vol. 4"]            = 2641185
    item_ids["Empty Bottle"]            = 2641186
    item_ids["Old Book"]                = 2641187
    item_ids["Emblem Piece (Flame)"]    = 2641188
    item_ids["Emblem Piece (Chest)"]    = 2641189
    item_ids["Emblem Piece (Statue)"]   = 2641190
    item_ids["Emblem Piece (Fountain)"] = 2641191
    item_ids["Log"]                     = 2641192
    item_ids["Cloth"]                   = 2641193
    item_ids["Rope"]                    = 2641194
    item_ids["Seagull Egg"]             = 2641195
    item_ids["Fish"]                    = 2641196
    item_ids["Mushroom"]                = 2641197
    item_ids["Coconut"]                 = 2641198
    item_ids["Drinking Water"]          = 2641199
    item_ids["Navi-G Piece 1"]          = 2641200
    item_ids["Navi-G Piece 2"]          = 2641201
    item_ids["Navi-Gummi Unused"]       = 2641202
    item_ids["Navi-G Piece 3"]          = 2641203
    item_ids["Navi-G Piece 4"]          = 2641204
    item_ids["Navi-Gummi"]              = 2641205
    item_ids["Watergleam"]              = 2641206
    item_ids["Naturespark"]             = 2641207
    item_ids["Fireglow"]                = 2641208
    item_ids["Earthshine"]              = 2641209
    item_ids["Crystal Trident"]         = 2641210
    item_ids["Postcard"]                = 2641211
    item_ids["Torn Page 1"]             = 2641212
    item_ids["Torn Page 2"]             = 2641213
    item_ids["Torn Page 3"]             = 2641214
    item_ids["Torn Page 4"]             = 2641215
    item_ids["Torn Page 5"]             = 2641216
    item_ids["Slide 1"]                 = 2641217
    item_ids["Slide 2"]                 = 2641218
    item_ids["Slide 3"]                 = 2641219
    item_ids["Slide 4"]                 = 2641220
    item_ids["Slide 5"]                 = 2641221
    item_ids["Slide 6"]                 = 2641222
    item_ids["Footprints"]              = 2641223
    item_ids["Claw Marks"]              = 2641224
    item_ids["Stench"]                  = 2641225
    item_ids["Antenna"]                 = 2641226
    item_ids["Forget-Me-Not"]           = 2641227
    item_ids["Jack-In-The-Box"]         = 2641228
    item_ids["Entry Pass"]              = 2641229
    item_ids["Hero License"]            = 2641230
    item_ids["Pretty Stone"]            = 2641231
    item_ids["N41"]                     = 2641232
    item_ids["Lucid Shard"]             = 2641233
    item_ids["Lucid Gem"]               = 2641234
    item_ids["Lucid Crystal"]           = 2641235
    item_ids["Spirit Shard"]            = 2641236
    item_ids["Spirit Gem"]              = 2641237
    item_ids["Power Shard"]             = 2641238
    item_ids["Power Gem"]               = 2641239
    item_ids["Power Crystal"]           = 2641240
    item_ids["Blaze Shard"]             = 2641241
    item_ids["Blaze Gem"]               = 2641242
    item_ids["Frost Shard"]             = 2641243
    item_ids["Frost Gem"]               = 2641244
    item_ids["Thunder Shard"]           = 2641245
    item_ids["Thunder Gem"]             = 2641246
    item_ids["Shiny Crystal"]           = 2641247
    item_ids["Bright Shard"]            = 2641248
    item_ids["Bright Gem"]              = 2641249
    item_ids["Bright Crystal"]          = 2641250
    item_ids["Mystery Goo"]             = 2641251
    item_ids["Gale"]                    = 2641252
    item_ids["Mythril Shard"]           = 2641253
    item_ids["Mythril"]                 = 2641254
    item_ids["Orichalcum"]              = 2641255
    item_ids["High Jump"]               = 2642001
    item_ids["Mermaid Kick"]            = 2642002
    item_ids["Glide"]                   = 2642003
    item_ids["Superglide"]              = 2642004
    item_ids["Treasure Magnet"]         = 2643005
    item_ids["Combo Plus"]              = 2643006
    item_ids["Air Combo Plus"]          = 2643007
    item_ids["Critical Plus"]           = 2643008
    item_ids["Second Wind"]             = 2643009
    item_ids["Scan"]                    = 2643010
    item_ids["Sonic Blade"]             = 2643011
    item_ids["Ars Arcanum"]             = 2643012
    item_ids["Strike Raid"]             = 2643013
    item_ids["Ragnarok"]                = 2643014
    item_ids["Trinity Limit"]           = 2643015
    item_ids["Cheer"]                   = 2643016
    item_ids["Vortex"]                  = 2643017
    item_ids["Aerial Sweep"]            = 2643018
    item_ids["Counterattack"]           = 2643019
    item_ids["Blitz"]                   = 2643020
    item_ids["Guard"]                   = 2643021
    item_ids["Dodge Roll"]              = 2643022
    item_ids["MP Haste"]                = 2643023
    item_ids["MP Rage"]                 = 2643024
    item_ids["Second Chance"]           = 2643025
    item_ids["Berserk"]                 = 2643026
    item_ids["Jackpot"]                 = 2643027
    item_ids["Lucky Strike"]            = 2643028
    item_ids["Charge"]                  = 2643029
    item_ids["Rocket"]                  = 2643030
    item_ids["Tornado"]                 = 2643031
    item_ids["MP Gift"]                 = 2643032
    item_ids["Raging Boar"]             = 2643033
    item_ids["Asp's Bite"]              = 2643034
    item_ids["Healing Herb"]            = 2643035
    item_ids["Wind Armor"]              = 2643036
    item_ids["Crescent"]                = 2643037
    item_ids["Sandstorm"]               = 2643038
    item_ids["Applause!"]               = 2643039
    item_ids["Blazing Fury"]            = 2643040
    item_ids["Icy Terror"]              = 2643041
    item_ids["Bolts of Sorrow"]         = 2643042
    item_ids["Ghostly Scream"]          = 2643043
    item_ids["Humming Bird"]            = 2643044
    item_ids["Time-Out"]                = 2643045
    item_ids["Storm's Eye"]             = 2643046
    item_ids["Ferocious Lunge"]         = 2643047
    item_ids["Furious Bellow"]          = 2643048
    item_ids["Spiral Wave"]             = 2643049
    item_ids["Thunder Potion"]          = 2643050
    item_ids["Cure Potion"]             = 2643051
    item_ids["Aero Potion"]             = 2643052
    item_ids["Slapshot"]                = 2643053
    item_ids["Sliding Dash"]            = 2643054
    item_ids["Hurricane Blast"]         = 2643055
    item_ids["Ripple Drive"]            = 2643056
    item_ids["Stun Impact"]             = 2643057
    item_ids["Gravity Break"]           = 2643058
    item_ids["Zantetsuken"]             = 2643059
    item_ids["Tech Boost"]              = 2643060
    item_ids["Encounter Plus"]          = 2643061
    item_ids["Leaf Bracer"]             = 2643062
    item_ids["Evolution"]               = 2643063
    item_ids["EXP Zero"]                = 2643064
    item_ids["Combo Master"]            = 2643065
    item_ids["Max HP Up"]               = 2644001
    item_ids["Max MP Up"]               = 2644002
    item_ids["Max AP Up"]               = 2644003
    item_ids["Strength Up"]             = 2644004
    item_ids["Defense Up"]              = 2644005
    item_ids["Item Slot Up"]            = 2644006
    item_ids["Accessory Slot Up"]       = 2644007
    item_ids["Dumbo"]                   = 2645000
    item_ids["Bambi"]                   = 2645001
    item_ids["Genie"]                   = 2645002
    item_ids["Tinker Bell"]             = 2645003
    item_ids["Mushu"]                   = 2645004
    item_ids["Simba"]                   = 2645005
    item_ids["Progressive Fire"]        = 2646001
    item_ids["Progressive Blizzard"]    = 2646002
    item_ids["Progressive Thunder"]     = 2646003
    item_ids["Progressive Cure"]        = 2646004
    item_ids["Progressive Gravity"]     = 2646005
    item_ids["Progressive Stop"]        = 2646006
    item_ids["Progressive Aero"]        = 2646007
    item_ids["Wonderland"]              = 2647002
    item_ids["Olympus Coliseum"]        = 2647003
    item_ids["Deep Jungle"]             = 2647004
    item_ids["Agrabah"]                 = 2647005
    item_ids["Halloween Town"]          = 2647006
    item_ids["Atlantica"]               = 2647007
    item_ids["Neverland"]               = 2647008
    item_ids["Hollow Bastion"]          = 2647009
    item_ids["End of the World"]        = 2647010
    item_ids["Monstro"]                 = 2647011
    item_ids["Blue Trinity"]            = 2648001
    item_ids["Red Trinity"]             = 2648002
    item_ids["Green Trinity"]           = 2648003
    item_ids["Yellow Trinity"]          = 2648004
    item_ids["White Trinity"]           = 2648005
    item_ids["Phil Cup"]                = 2649001
    item_ids["Pegasus Cup"]             = 2649002
    item_ids["Hercules Cup"]            = 2649003
    item_ids["Hades Cup"]               = 2649004
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
    soras_stats_address  = 0x2DE59D6 - offset
    sora_hp_offset       = 0x0
    sora_mp_offset       = 0x2
    sora_ap_offset       = 0x3
    sora_strength_offset = 0x4
    sora_defense_offset  = 0x5
    return {ReadByte(soras_stats_address + sora_hp_offset)
          , ReadByte(soras_stats_address + sora_mp_offset)
          , ReadByte(soras_stats_address + sora_ap_offset)
          , ReadByte(soras_stats_address + sora_strength_offset)
          , ReadByte(soras_stats_address + sora_defense_offset)}
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

function write_unlocked_worlds(unlocked_worlds_array)
    --Writes unlocked worlds.  Array of 11 values, one for each world
    --TT, WL, OC, DJ, AG, AT, HT, NL, HB, EW, MS
    --00 is invisible
    --01 is visible/unvisited
    --02 is selectable/unvisited
    --03 is incomplete
    --04 is complete
    world_status_address = 0x2DE78C0 - offset
    WriteArray(world_status_address, unlocked_worlds_array)
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
    sora_item_slots_offset      = 0x1C
    sora_accessory_slots_offset = 0x25
    WriteByte(soras_stats_address + sora_hp_offset              , soras_stats_array[1])
    WriteByte(soras_stats_address + sora_mp_offset              , soras_stats_array[2])
    WriteByte(soras_stats_address + sora_ap_offset              , soras_stats_array[3])
    WriteByte(soras_stats_address + sora_strength_offset        , soras_stats_array[4])
    WriteByte(soras_stats_address + sora_defense_offset         , soras_stats_array[5])
    WriteByte(soras_stats_address + sora_item_slots_offset      , soras_stats_array[6])
    WriteByte(soras_stats_address + sora_accessory_slots_offset , soras_stats_array[7])
end

function write_check_array(check_array)
    inventory_address = 0x2DE5E69 - offset
    check_number_item_address = inventory_address + 0x48
    WriteArray(check_number_item_address, check_array)
end

function write_evidence_chests()
    lotus_forest_evidence_address = 0x2D39B90 - offset
    bizarre_rooom_evidence_address = 0x2D39230 - offset
    if read_world() == 4 then
        if read_room() == 4 then
            WriteLong(lotus_forest_chest_address, 0)
            WriteLong(lotus_forest_chest_address + 0x4B0, 0)
        elseif read_room() == 1 then
            WriteLong(bizarre_rooom_evidence_address, 0)
            WriteLong(bizarre_rooom_evidence_address + 0x4B0, 0)
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
    worlds_unlocked_array = {3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    shared_abilities_array = {0, 0, 0, 0}
    summons_array = {255, 255, 255, 255, 255, 255}
    trinity_bits = {0, 0, 0, 0, 0}
    olympus_cups_array = {0, 0, 0, 0}
    local i = 1
    while file_exists(client_communication_path .. "AP_" .. tostring(i) .. ".item") do
        file = io.open(client_communication_path .. "AP_" .. tostring(i) .. ".item", "r")
        io.input(file)
        received_item_id = tonumber(io.read())
        io.close(file)
        if received_item_id >= 2642000 and received_item_id < 2643000 then
            shared_abilities_array = add_to_shared_abilities_array(shared_abilities_array, received_item_id % 2642000)
        elseif received_item_id >= 2645000 and received_item_id < 2646000 then
            summons_array = add_to_summons_array(summons_array, received_item_id % 2645000)
        elseif received_item_id >= 2646000 and received_item_id < 2647000 then
            magic_unlocked_bits[received_item_id % 2646000] = 1
            magic_levels_array[received_item_id % 2646000] = magic_levels_array[received_item_id % 2646000] + 1
        elseif received_item_id >= 2647000 and received_item_id < 2648000 then
            worlds_unlocked_array[received_item_id % 2647000] = 3
        elseif received_item_id >= 2648000 and received_item_id < 2649000 then
            trinity_bits[received_item_id % 2648000] = 1
        elseif received_item_id >= 2649000 then
            olympus_cups_array[received_item_id % 2649000] = 10
        end
        i = i + 1
    end
    write_magic(magic_unlocked_bits, magic_levels_array)
    write_unlocked_worlds(worlds_unlocked_array)
    write_shared_abilities_array(shared_abilities_array)
    write_summons_array(summons_array)
    write_trinities(trinity_bits)
    write_olympus_cups(olympus_cups_array)
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
end

function main()
    receive_items()
    calculate_full()
    send_locations()
    
    --Cleaning up static things
    write_synth_requirements()
    write_chests()
    write_rewards()
    write_evidence_chests()
    write_slides()
    write_world_lines()
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
    ConsolePrint("KH1FM AP Running...")
end

function _OnFrame()
    if frame_count % 120 == 0 then
        main()
        --test()
    end
    frame_count = frame_count + 1
end