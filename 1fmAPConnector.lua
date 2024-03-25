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
frame_count = 0
canExecute = false
worlds_unlocked_array = {3, 0, 0, 0, 0, 0, 0, 0, 0, 0}
monstro_unlocked = 0
magic_unlocked_bits = {0, 0, 0, 0, 0, 0, 0}
trinity_bits = {0, 0, 0, 0, 0}
initializing = true
required_reports = 14 --EotW won't appear until you've connected to confirm amount
item_categories = {
    equipment = 0,
    consumable = 1,
    unlock = 2,
    ability = 3,
    magic = 4,
    trinity = 5,
    summon = 6,
    statsUp = 7,
    synthesis = 8,
}
message_cache = {
    items = {},
    sent  = {},
    debug = { {} },
    locationID = -1,
}
prompt_colours = {
    blue_donald = -8,
    green_goofy = -4,
    red_sora = 0,
    purple_evil = 4,
    green_goofy_dark = 8,
    purple_pink = 12,
    blue_light = 16,
    green_mint = 20,
    orange = 24,
    violet = 28,
    green_goofy_intensiv = 32,
    purple_pink_intensiv = 36,
    blue_light_intensiv = 40,
    red_rose = 64,
    red_trap = 140
}

item_usefulness = {
    trap = 0,
    useless = 1,
    normal = 2,
    progression = 3,
    special = 4,
}

colourOffsetIterator = -8

--- Addresses ---
offset = 0x3A0606


--- Definitions ---

function define_items()
  items = {

  --Consumables
  { ID = 2640000, Name = "Victory", Usefulness = item_usefulness.special },
  { ID = 2641001, Name = "Potion", },
  { ID = 2641002, Name = "Hi-Potion", },
  { ID = 2641003, Name = "Ether", },
  { ID = 2641004, Name = "Elixir", },
  { ID = 2641005, Name = "BO5" },
  { ID = 2641006, Name = "Mega-Potion", },
  { ID = 2641007, Name = "Mega-Ether", },
  { ID = 2641008, Name = "Megalixir", },

  --Synthesis
  { ID = 2641009, Name = "Fury Stone" },
  { ID = 2641010, Name = "Power Stone" },
  { ID = 2641011, Name = "Energy Stone" },
  { ID = 2641012, Name = "Blazing Stone" },
  { ID = 2641013, Name = "Frost Stone" },
  { ID = 2641014, Name = "Lightning Stone" },
  { ID = 2641015, Name = "Dazzling Stone" },
  { ID = 2641016, Name = "Stormy Stone" },

    --Equipment
  { ID = 2641017, Name = "Protect Chain" },
  { ID = 2641018, Name = "Protera Chain" },
  { ID = 2641019, Name = "Protega Chain" },
  { ID = 2641020, Name = "Fire Ring" },
  { ID = 2641021, Name = "Fira Ring" },
  { ID = 2641022, Name = "Firaga Ring" },
  { ID = 2641023, Name = "Blizzard Ring" },
  { ID = 2641024, Name = "Blizzara Ring" },
  { ID = 2641025, Name = "Blizzaga Ring" },
  { ID = 2641026, Name = "Thunder Ring" },
  { ID = 2641027, Name = "Thundara Ring" },
  { ID = 2641028, Name = "Thundaga Ring" },
  { ID = 2641029, Name = "Ability Stud" },
  { ID = 2641030, Name = "Guard Earring" },
  { ID = 2641031, Name = "Master Earring" },
  { ID = 2641032, Name = "Chaos Ring" },
  { ID = 2641033, Name = "Dark Ring" },
  { ID = 2641034, Name = "Element Ring" },
  { ID = 2641035, Name = "Three Stars" },
  { ID = 2641036, Name = "Power Chain" },
  { ID = 2641037, Name = "Golem Chain" },
  { ID = 2641038, Name = "Titan Chain" },
  { ID = 2641039, Name = "Energy Bangle" },
  { ID = 2641040, Name = "Angel Bangle" },
  { ID = 2641041, Name = "Gaia Bangle" },
  { ID = 2641042, Name = "Magic Armlet" },
  { ID = 2641043, Name = "Rune Armlet" },
  { ID = 2641044, Name = "Atlas Armlet" },
  { ID = 2641045, Name = "Heartguard" },
  { ID = 2641046, Name = "Ribbon" },
  { ID = 2641047, Name = "Crystal Crown" },
  { ID = 2641048, Name = "Brave Warrior" },
  { ID = 2641049, Name = "Ifrit's Horn" },
  { ID = 2641050, Name = "Inferno Band" },
  { ID = 2641051, Name = "White Fang" },
  { ID = 2641052, Name = "Ray of Light" },
  { ID = 2641053, Name = "Holy Circlet" },
  { ID = 2641054, Name = "Raven's Claw" },
  { ID = 2641055, Name = "Omega Arts" },
  { ID = 2641056, Name = "EXP Earring" },
  { ID = 2641057, Name = "A41" },
  { ID = 2641058, Name = "EXP Ring" },
  { ID = 2641059, Name = "EXP Bracelet" },
  { ID = 2641060, Name = "EXP Necklace" },
  { ID = 2641061, Name = "Firagun Band" },
  { ID = 2641062, Name = "Blizzagun Band" },
  { ID = 2641063, Name = "Thundagun Band" },
  { ID = 2641064, Name = "Ifrit Belt" },
  { ID = 2641065, Name = "Shiva Belt" },
  { ID = 2641066, Name = "Ramuh Belt" },
  { ID = 2641067, Name = "Moogle Badge" },
  { ID = 2641068, Name = "Cosmic Arts" },
  { ID = 2641069, Name = "Royal Crown" },
  { ID = 2641070, Name = "Prime Cap" },
  { ID = 2641071, Name = "Obsidian Ring" },
  { ID = 2641072, Name = "A56" },
  { ID = 2641073, Name = "A57" },
  { ID = 2641074, Name = "A58" },
  { ID = 2641075, Name = "A59" },
  { ID = 2641076, Name = "A60" },
  { ID = 2641077, Name = "A61" },
  { ID = 2641078, Name = "A62" },
  { ID = 2641079, Name = "A63" },
  { ID = 2641080, Name = "A64" },
  { ID = 2641081, Name = "Kingdom Key" },
  { ID = 2641082, Name = "Dream Sword" },
  { ID = 2641083, Name = "Dream Shield" },
  { ID = 2641084, Name = "Dream Rod" },
  { ID = 2641085, Name = "Wooden Sword" },
  { ID = 2641086, Name = "Jungle King" },
  { ID = 2641087, Name = "Three Wishes" },
  { ID = 2641088, Name = "Fairy Harp" },
  { ID = 2641089, Name = "Pumpkinhead" },
  { ID = 2641090, Name = "Crabclaw" },
  { ID = 2641091, Name = "Divine Rose" },
  { ID = 2641092, Name = "Spellbinder" },
  { ID = 2641093, Name = "Olympia" },
  { ID = 2641094, Name = "Lionheart" },
  { ID = 2641095, Name = "Metal Chocobo" },
  { ID = 2641096, Name = "Oathkeeper" },
  { ID = 2641097, Name = "Oblivion" },
  { ID = 2641098, Name = "Lady Luck" },
  { ID = 2641099, Name = "Wishing Star" },
  { ID = 2641100, Name = "Ultima Weapon" },
  { ID = 2641101, Name = "Diamond Dust" },
  { ID = 2641102, Name = "One-Winged Angel" },
  { ID = 2641103, Name = "Mage's Staff" },
  { ID = 2641104, Name = "Morning Star" },
  { ID = 2641105, Name = "Shooting Star" },
  { ID = 2641106, Name = "Magus Staff" },
  { ID = 2641107, Name = "Wisdom Staff" },
  { ID = 2641108, Name = "Warhammer" },
  { ID = 2641109, Name = "Silver Mallet" },
  { ID = 2641110, Name = "Grand Mallet" },
  { ID = 2641111, Name = "Lord Fortune" },
  { ID = 2641112, Name = "Violetta" },
  { ID = 2641113, Name = "Dream Rod (Donald)" },
  { ID = 2641114, Name = "Save the Queen" },
  { ID = 2641115, Name = "Wizard's Relic" },
  { ID = 2641116, Name = "Meteor Strike" },
  { ID = 2641117, Name = "Fantasista" },
  { ID = 2641118, Name = "Unused (Donald)" },
  { ID = 2641119, Name = "Knight's Shield" },
  { ID = 2641120, Name = "Mythril Shield" },
  { ID = 2641121, Name = "Onyx Shield" },
  { ID = 2641122, Name = "Stout Shield" },
  { ID = 2641123, Name = "Golem Shield" },
  { ID = 2641124, Name = "Adamant Shield" },
  { ID = 2641125, Name = "Smasher" },
  { ID = 2641126, Name = "Gigas Fist" },
  { ID = 2641127, Name = "Genji Shield" },
  { ID = 2641128, Name = "Herc's Shield" },
  { ID = 2641129, Name = "Dream Shield" },
  { ID = 2641130, Name = "Save the King" },
  { ID = 2641131, Name = "Defender" },
  { ID = 2641132, Name = "Mighty Shield" },
  { ID = 2641133, Name = "Seven Elements" },
  { ID = 2641134, Name = "Unused (Goofy)" },
  { ID = 2641135, Name = "Spear" },

  { ID = 2641136, Name = "No Weapon" },
  { ID = 2641137, Name = "Genie" },
  { ID = 2641138, Name = "No Weapon" },
  { ID = 2641139, Name = "No Weapon" },
  { ID = 2641140, Name = "Tinker Bell" },
  { ID = 2641141, Name = "Claws" },
  { ID = 2641142, Name = "Tent" },
  { ID = 2641143, Name = "Camping Set" },
  { ID = 2641144, Name = "Cottage" },
  { ID = 2641145, Name = "C04" },
  { ID = 2641146, Name = "C05" },
  { ID = 2641147, Name = "C06" },
  { ID = 2641148, Name = "C07" },
  { ID = 2641149, Name = "Ansem's Report 11", Usefulness = item_usefulness.progression },
  { ID = 2641150, Name = "Ansem's Report 12", Usefulness = item_usefulness.progression },
  { ID = 2641151, Name = "Ansem's Report 13", Usefulness = item_usefulness.progression },
  { ID = 2641152, Name = "Power Up" },
  { ID = 2641153, Name = "Defense Up" },
  { ID = 2641154, Name = "AP Up" },
  { ID = 2641155, Name = "Serenity Power" },
  { ID = 2641156, Name = "Dark Matter" },
  { ID = 2641157, Name = "Mythril Stone" },
  { ID = 2641158, Name = "Fire Arts" ,     Usefulness = item_usefulness.progression },
  { ID = 2641159, Name = "Blizzard Arts" , Usefulness = item_usefulness.progression },
  { ID = 2641160, Name = "Thunder Arts" ,  Usefulness = item_usefulness.progression },
  { ID = 2641161, Name = "Cure Arts" ,     Usefulness = item_usefulness.progression },
  { ID = 2641162, Name = "Gravity Arts" ,  Usefulness = item_usefulness.progression },
  { ID = 2641163, Name = "Stop Arts" ,     Usefulness = item_usefulness.progression },
  { ID = 2641164, Name = "Aero Arts" ,     Usefulness = item_usefulness.progression },
  { ID = 2641165, Name = "Shiitank Rank" },
  { ID = 2641166, Name = "Matsutake Rank" },
  { ID = 2641167, Name = "Mystery Mold" },
  { ID = 2641168, Name = "Ansem's Report 1",  Usefulness = item_usefulness.progression },
  { ID = 2641169, Name = "Ansem's Report 2",  Usefulness = item_usefulness.progression },
  { ID = 2641170, Name = "Ansem's Report 3",  Usefulness = item_usefulness.progression },
  { ID = 2641171, Name = "Ansem's Report 4",  Usefulness = item_usefulness.progression },
  { ID = 2641172, Name = "Ansem's Report 5",  Usefulness = item_usefulness.progression },
  { ID = 2641173, Name = "Ansem's Report 6",  Usefulness = item_usefulness.progression },
  { ID = 2641174, Name = "Ansem's Report 7",  Usefulness = item_usefulness.progression },
  { ID = 2641175, Name = "Ansem's Report 8",  Usefulness = item_usefulness.progression },
  { ID = 2641176, Name = "Ansem's Report 9",  Usefulness = item_usefulness.progression },
  { ID = 2641177, Name = "Ansem's Report 10", Usefulness = item_usefulness.progression },
  { ID = 2641178, Name = "Khama Vol. 8" },
  { ID = 2641179, Name = "Salegg Vol. 6" },
  { ID = 2641180, Name = "Azal Vol. 3" },
  { ID = 2641181, Name = "Mava Vol. 3" },
  { ID = 2641182, Name = "Mava Vol. 6" },
  { ID = 2641183, Name = "Theon Vol. 6" ,     Usefulness = item_usefulness.progression },
  { ID = 2641184, Name = "Nahara Vol. 5" },
  { ID = 2641185, Name = "Hafet Vol. 4" },
  { ID = 2641186, Name = "Material" ,               Usefulness = item_usefulness.progression },
  { ID = 2641187, Name = "Old Book" ,               Usefulness = item_usefulness.progression },
  { ID = 2641188, Name = "Emblem Piece (Flame)",    Usefulness = item_usefulness.progression },
  { ID = 2641189, Name = "Emblem Piece (Chest)",    Usefulness = item_usefulness.progression },
  { ID = 2641190, Name = "Emblem Piece (Statue)",   Usefulness = item_usefulness.progression },
  { ID = 2641191, Name = "Emblem Piece (Fountain)", Usefulness = item_usefulness.progression },
  { ID = 2641192, Name = "Log" },
  { ID = 2641193, Name = "Cloth" },
  { ID = 2641194, Name = "Rope" },
  { ID = 2641195, Name = "Seagull Egg" },
  { ID = 2641196, Name = "Fish" },
  { ID = 2641197, Name = "Mushroom" },
  { ID = 2641198, Name = "Coconut" },
  { ID = 2641199, Name = "Drinking Water" },
  { ID = 2641200, Name = "Navi-G Piece 1" },
  { ID = 2641201, Name = "Navi-G Piece 2" },
  { ID = 2641202, Name = "Navi-Gummi Unused" },
  { ID = 2641203, Name = "Navi-G Piece 3" },
  { ID = 2641204, Name = "Navi-G Piece 4" },
  { ID = 2641205, Name = "Navi-Gummi" },
  { ID = 2641206, Name = "Watergleam" ,     Usefulness = item_usefulness.progression },
  { ID = 2641207, Name = "Naturespark" ,    Usefulness = item_usefulness.progression },
  { ID = 2641208, Name = "Fireglow",        Usefulness = item_usefulness.progression },
  { ID = 2641209, Name = "Earthshine" },
  { ID = 2641210, Name = "Crystal Trident" },
  { ID = 2641211, Name = "Postcard",        Usefulness = item_usefulness.progression },
  { ID = 2641212, Name = "Torn Page 1" ,    Usefulness = item_usefulness.progression },
  { ID = 2641213, Name = "Torn Page 2" ,    Usefulness = item_usefulness.progression },
  { ID = 2641214, Name = "Torn Page 3" ,    Usefulness = item_usefulness.progression },
  { ID = 2641215, Name = "Torn Page 4" ,    Usefulness = item_usefulness.progression },
  { ID = 2641216, Name = "Torn Page 5" ,    Usefulness = item_usefulness.progression },
  { ID = 2641217, Name = "Slide 1",         Usefulness = item_usefulness.progression },
  { ID = 2641218, Name = "Slide 2" },
  { ID = 2641219, Name = "Slide 3" },
  { ID = 2641220, Name = "Slide 4" },
  { ID = 2641221, Name = "Slide 5" },
  { ID = 2641222, Name = "Slide 6" },
  { ID = 2641223, Name = "Footprints", Usefulness = item_usefulness.progression },
  { ID = 2641224, Name = "Claw Marks" },
  { ID = 2641225, Name = "Stench" },
  { ID = 2641226, Name = "Antenna" },
  { ID = 2641227, Name = "Forget-Me-Not" },
  { ID = 2641228, Name = "Jack-In-The-Box", Usefulness = item_usefulness.progression },
  { ID = 2641229, Name = "Entry Pass" },
  { ID = 2641230, Name = "Hero License" },
  { ID = 2641231, Name = "Pretty Stone" },
  { ID = 2641232, Name = "N41" },
  { ID = 2641233, Name = "Lucid Shard" },
  { ID = 2641234, Name = "Lucid Gem" },
  { ID = 2641235, Name = "Lucid Crystal" },
  { ID = 2641236, Name = "Spirit Shard" },
  { ID = 2641237, Name = "Spirit Gem" },
  { ID = 2641238, Name = "Power Shard" },
  { ID = 2641239, Name = "Power Gem" },
  { ID = 2641240, Name = "Power Crystal" },
  { ID = 2641241, Name = "Blaze Shard" },
  { ID = 2641242, Name = "Blaze Gem" },
  { ID = 2641243, Name = "Frost Shard" },
  { ID = 2641244, Name = "Frost Gem" },
  { ID = 2641245, Name = "Thunder Shard" },
  { ID = 2641246, Name = "Thunder Gem" },
  { ID = 2641247, Name = "Shiny Crystal" },
  { ID = 2641248, Name = "Bright Shard" },
  { ID = 2641249, Name = "Bright Gem" },
  { ID = 2641250, Name = "Bright Crystal" },
  { ID = 2641251, Name = "Mystery Goo" },
  { ID = 2641252, Name = "Gale" },
  { ID = 2641253, Name = "Mythril Shard" },
  { ID = 2641254, Name = "Mythril" },
  { ID = 2641255, Name = "Orichalcum" },

  -- Abilities
  { ID = 2642001, Name = "High Jump",     Usefulness = item_usefulness.progression },
  { ID = 2642002, Name = "Mermaid Kick",  Usefulness = item_usefulness.progression },
  { ID = 2642003, Name = "Glide",         Usefulness = item_usefulness.progression },
  { ID = 2642004, Name = "Superglide",    Usefulness = item_usefulness.progression },
  { ID = 2642101, Name = "Puppy 01",      Usefulness = item_usefulness.progression },
  { ID = 2642102, Name = "Puppy 02",      Usefulness = item_usefulness.progression },
  { ID = 2642103, Name = "Puppy 03",      Usefulness = item_usefulness.progression },
  { ID = 2642104, Name = "Puppy 04",      Usefulness = item_usefulness.progression },
  { ID = 2642105, Name = "Puppy 05",      Usefulness = item_usefulness.progression },
  { ID = 2642106, Name = "Puppy 06",      Usefulness = item_usefulness.progression },
  { ID = 2642107, Name = "Puppy 07",      Usefulness = item_usefulness.progression },
  { ID = 2642108, Name = "Puppy 08",      Usefulness = item_usefulness.progression },
  { ID = 2642109, Name = "Puppy 09",      Usefulness = item_usefulness.progression },
  { ID = 2642110, Name = "Puppy 10",      Usefulness = item_usefulness.progression },
  { ID = 2642111, Name = "Puppy 11",      Usefulness = item_usefulness.progression },
  { ID = 2642112, Name = "Puppy 12",      Usefulness = item_usefulness.progression },
  { ID = 2642113, Name = "Puppy 13",      Usefulness = item_usefulness.progression },
  { ID = 2642114, Name = "Puppy 14",      Usefulness = item_usefulness.progression },
  { ID = 2642115, Name = "Puppy 15",      Usefulness = item_usefulness.progression },
  { ID = 2642116, Name = "Puppy 16",      Usefulness = item_usefulness.progression },
  { ID = 2642117, Name = "Puppy 17",      Usefulness = item_usefulness.progression },
  { ID = 2642118, Name = "Puppy 18",      Usefulness = item_usefulness.progression },
  { ID = 2642119, Name = "Puppy 19",      Usefulness = item_usefulness.progression },
  { ID = 2642120, Name = "Puppy 20",      Usefulness = item_usefulness.progression },
  { ID = 2642121, Name = "Puppy 21",      Usefulness = item_usefulness.progression },
  { ID = 2642122, Name = "Puppy 22",      Usefulness = item_usefulness.progression },
  { ID = 2642123, Name = "Puppy 23",      Usefulness = item_usefulness.progression },
  { ID = 2642124, Name = "Puppy 24",      Usefulness = item_usefulness.progression },
  { ID = 2642125, Name = "Puppy 25",      Usefulness = item_usefulness.progression },
  { ID = 2642126, Name = "Puppy 26",      Usefulness = item_usefulness.progression },
  { ID = 2642127, Name = "Puppy 27",      Usefulness = item_usefulness.progression },
  { ID = 2642128, Name = "Puppy 28",      Usefulness = item_usefulness.progression },
  { ID = 2642129, Name = "Puppy 29",      Usefulness = item_usefulness.progression },
  { ID = 2642130, Name = "Puppy 30",      Usefulness = item_usefulness.progression },
  { ID = 2642131, Name = "Puppy 31",      Usefulness = item_usefulness.progression },
  { ID = 2642132, Name = "Puppy 32",      Usefulness = item_usefulness.progression },
  { ID = 2642133, Name = "Puppy 33",      Usefulness = item_usefulness.progression },
  { ID = 2642134, Name = "Puppy 34",      Usefulness = item_usefulness.progression },
  { ID = 2642135, Name = "Puppy 35",      Usefulness = item_usefulness.progression },
  { ID = 2642136, Name = "Puppy 36",      Usefulness = item_usefulness.progression },
  { ID = 2642137, Name = "Puppy 37",      Usefulness = item_usefulness.progression },
  { ID = 2642138, Name = "Puppy 38",      Usefulness = item_usefulness.progression },
  { ID = 2642139, Name = "Puppy 39",      Usefulness = item_usefulness.progression },
  { ID = 2642140, Name = "Puppy 40",      Usefulness = item_usefulness.progression },
  { ID = 2642141, Name = "Puppy 41",      Usefulness = item_usefulness.progression },
  { ID = 2642142, Name = "Puppy 42",      Usefulness = item_usefulness.progression },
  { ID = 2642143, Name = "Puppy 43",      Usefulness = item_usefulness.progression },
  { ID = 2642144, Name = "Puppy 44",      Usefulness = item_usefulness.progression },
  { ID = 2642145, Name = "Puppy 45",      Usefulness = item_usefulness.progression },
  { ID = 2642146, Name = "Puppy 46",      Usefulness = item_usefulness.progression },
  { ID = 2642147, Name = "Puppy 47",      Usefulness = item_usefulness.progression },
  { ID = 2642148, Name = "Puppy 48",      Usefulness = item_usefulness.progression },
  { ID = 2642149, Name = "Puppy 49",      Usefulness = item_usefulness.progression },
  { ID = 2642150, Name = "Puppy 50",      Usefulness = item_usefulness.progression },
  { ID = 2642151, Name = "Puppy 51",      Usefulness = item_usefulness.progression },
  { ID = 2642152, Name = "Puppy 52",      Usefulness = item_usefulness.progression },
  { ID = 2642153, Name = "Puppy 53",      Usefulness = item_usefulness.progression },
  { ID = 2642154, Name = "Puppy 54",      Usefulness = item_usefulness.progression },
  { ID = 2642155, Name = "Puppy 55",      Usefulness = item_usefulness.progression },
  { ID = 2642156, Name = "Puppy 56",      Usefulness = item_usefulness.progression },
  { ID = 2642157, Name = "Puppy 57",      Usefulness = item_usefulness.progression },
  { ID = 2642158, Name = "Puppy 58",      Usefulness = item_usefulness.progression },
  { ID = 2642159, Name = "Puppy 59",      Usefulness = item_usefulness.progression },
  { ID = 2642160, Name = "Puppy 60",      Usefulness = item_usefulness.progression },
  { ID = 2642161, Name = "Puppy 61",      Usefulness = item_usefulness.progression },
  { ID = 2642162, Name = "Puppy 62",      Usefulness = item_usefulness.progression },
  { ID = 2642163, Name = "Puppy 63",      Usefulness = item_usefulness.progression },
  { ID = 2642164, Name = "Puppy 64",      Usefulness = item_usefulness.progression },
  { ID = 2642165, Name = "Puppy 65",      Usefulness = item_usefulness.progression },
  { ID = 2642166, Name = "Puppy 66",      Usefulness = item_usefulness.progression },
  { ID = 2642167, Name = "Puppy 67",      Usefulness = item_usefulness.progression },
  { ID = 2642168, Name = "Puppy 68",      Usefulness = item_usefulness.progression },
  { ID = 2642169, Name = "Puppy 69",      Usefulness = item_usefulness.progression },
  { ID = 2642170, Name = "Puppy 70",      Usefulness = item_usefulness.progression },
  { ID = 2642171, Name = "Puppy 71",      Usefulness = item_usefulness.progression },
  { ID = 2642172, Name = "Puppy 72",      Usefulness = item_usefulness.progression },
  { ID = 2642173, Name = "Puppy 73",      Usefulness = item_usefulness.progression },
  { ID = 2642174, Name = "Puppy 74",      Usefulness = item_usefulness.progression },
  { ID = 2642175, Name = "Puppy 75",      Usefulness = item_usefulness.progression },
  { ID = 2642176, Name = "Puppy 76",      Usefulness = item_usefulness.progression },
  { ID = 2642177, Name = "Puppy 77",      Usefulness = item_usefulness.progression },
  { ID = 2642178, Name = "Puppy 78",      Usefulness = item_usefulness.progression },
  { ID = 2642179, Name = "Puppy 79",      Usefulness = item_usefulness.progression },
  { ID = 2642180, Name = "Puppy 80",      Usefulness = item_usefulness.progression },
  { ID = 2642181, Name = "Puppy 81",      Usefulness = item_usefulness.progression },
  { ID = 2642182, Name = "Puppy 82",      Usefulness = item_usefulness.progression },
  { ID = 2642183, Name = "Puppy 83",      Usefulness = item_usefulness.progression },
  { ID = 2642184, Name = "Puppy 84",      Usefulness = item_usefulness.progression },
  { ID = 2642185, Name = "Puppy 85",      Usefulness = item_usefulness.progression },
  { ID = 2642186, Name = "Puppy 86",      Usefulness = item_usefulness.progression },
  { ID = 2642187, Name = "Puppy 87",      Usefulness = item_usefulness.progression },
  { ID = 2642188, Name = "Puppy 88",      Usefulness = item_usefulness.progression },
  { ID = 2642189, Name = "Puppy 89",      Usefulness = item_usefulness.progression },
  { ID = 2642190, Name = "Puppy 90",      Usefulness = item_usefulness.progression },
  { ID = 2642191, Name = "Puppy 91",      Usefulness = item_usefulness.progression },
  { ID = 2642192, Name = "Puppy 92",      Usefulness = item_usefulness.progression },
  { ID = 2642193, Name = "Puppy 93",      Usefulness = item_usefulness.progression },
  { ID = 2642194, Name = "Puppy 94",      Usefulness = item_usefulness.progression },
  { ID = 2642195, Name = "Puppy 95",      Usefulness = item_usefulness.progression },
  { ID = 2642196, Name = "Puppy 96",      Usefulness = item_usefulness.progression },
  { ID = 2642197, Name = "Puppy 97",      Usefulness = item_usefulness.progression },
  { ID = 2642198, Name = "Puppy 98",      Usefulness = item_usefulness.progression },
  { ID = 2642199, Name = "Puppy 99",      Usefulness = item_usefulness.progression },
  { ID = 2642201, Name = "Puppies 01-03", Usefulness = item_usefulness.progression },
  { ID = 2642202, Name = "Puppies 04-06", Usefulness = item_usefulness.progression },
  { ID = 2642203, Name = "Puppies 07-09", Usefulness = item_usefulness.progression },
  { ID = 2642204, Name = "Puppies 10-12", Usefulness = item_usefulness.progression },
  { ID = 2642205, Name = "Puppies 13-15", Usefulness = item_usefulness.progression },
  { ID = 2642206, Name = "Puppies 16-18", Usefulness = item_usefulness.progression },
  { ID = 2642207, Name = "Puppies 19-21", Usefulness = item_usefulness.progression },
  { ID = 2642208, Name = "Puppies 22-24", Usefulness = item_usefulness.progression },
  { ID = 2642209, Name = "Puppies 25-27", Usefulness = item_usefulness.progression },
  { ID = 2642210, Name = "Puppies 28-30", Usefulness = item_usefulness.progression },
  { ID = 2642211, Name = "Puppies 31-33", Usefulness = item_usefulness.progression },
  { ID = 2642212, Name = "Puppies 34-36", Usefulness = item_usefulness.progression },
  { ID = 2642213, Name = "Puppies 37-39", Usefulness = item_usefulness.progression },
  { ID = 2642214, Name = "Puppies 40-42", Usefulness = item_usefulness.progression },
  { ID = 2642215, Name = "Puppies 43-45", Usefulness = item_usefulness.progression },
  { ID = 2642216, Name = "Puppies 46-48", Usefulness = item_usefulness.progression },
  { ID = 2642217, Name = "Puppies 49-51", Usefulness = item_usefulness.progression },
  { ID = 2642218, Name = "Puppies 52-54", Usefulness = item_usefulness.progression },
  { ID = 2642219, Name = "Puppies 55-57", Usefulness = item_usefulness.progression },
  { ID = 2642220, Name = "Puppies 58-60", Usefulness = item_usefulness.progression },
  { ID = 2642221, Name = "Puppies 61-63", Usefulness = item_usefulness.progression },
  { ID = 2642222, Name = "Puppies 64-66", Usefulness = item_usefulness.progression },
  { ID = 2642223, Name = "Puppies 67-69", Usefulness = item_usefulness.progression },
  { ID = 2642224, Name = "Puppies 70-72", Usefulness = item_usefulness.progression },
  { ID = 2642225, Name = "Puppies 73-75", Usefulness = item_usefulness.progression },
  { ID = 2642226, Name = "Puppies 76-78", Usefulness = item_usefulness.progression },
  { ID = 2642227, Name = "Puppies 79-81", Usefulness = item_usefulness.progression },
  { ID = 2642228, Name = "Puppies 82-84", Usefulness = item_usefulness.progression },
  { ID = 2642229, Name = "Puppies 85-87", Usefulness = item_usefulness.progression },
  { ID = 2642230, Name = "Puppies 88-90", Usefulness = item_usefulness.progression },
  { ID = 2642231, Name = "Puppies 91-93", Usefulness = item_usefulness.progression },
  { ID = 2642232, Name = "Puppies 94-96", Usefulness = item_usefulness.progression },
  { ID = 2642233, Name = "Puppies 97-99", Usefulness = item_usefulness.progression },
  { ID = 2642240, Name = "All Puppies",   Usefulness = item_usefulness.progression },
  { ID = 2643005, Name = "Treasure Magnet" },
  { ID = 2643006, Name = "Combo Plus" },
  { ID = 2643007, Name = "Air Combo Plus" },
  { ID = 2643008, Name = "Critical Plus" },
  { ID = 2643009, Name = "Second Wind" },
  { ID = 2643010, Name = "Scan" },
  { ID = 2643011, Name = "Sonic Blade" },
  { ID = 2643012, Name = "Ars Arcanum" },
  { ID = 2643013, Name = "Strike Raid" },
  { ID = 2643014, Name = "Ragnarok" },
  { ID = 2643015, Name = "Trinity Limit" },
  { ID = 2643016, Name = "Cheer" },
  { ID = 2643017, Name = "Vortex" },
  { ID = 2643018, Name = "Aerial Sweep" },
  { ID = 2643019, Name = "Counterattack" },
  { ID = 2643020, Name = "Blitz" },
  { ID = 2643021, Name = "Guard" ,       Usefulness = item_usefulness.progression },
  { ID = 2643022, Name = "Dodge Roll" },
  { ID = 2643023, Name = "MP Haste" },
  { ID = 2643024, Name = "MP Rage" },
  { ID = 2643025, Name = "Second Chance" },
  { ID = 2643026, Name = "Berserk" },
  { ID = 2643027, Name = "Jackpot" },
  { ID = 2643028, Name = "Lucky Strike" },
  { ID = 2643029, Name = "Charge" },
  { ID = 2643030, Name = "Rocket" },
  { ID = 2643031, Name = "Tornado" },
  { ID = 2643032, Name = "MP Gift" },
  { ID = 2643033, Name = "Raging Boar" },
  { ID = 2643034, Name = "Asp's Bite" },
  { ID = 2643035, Name = "Healing Herb" },
  { ID = 2643036, Name = "Wind Armor" },
  { ID = 2643037, Name = "Crescent" },
  { ID = 2643038, Name = "Sandstorm" },
  { ID = 2643039, Name = "Applause!" },
  { ID = 2643040, Name = "Blazing Fury" },
  { ID = 2643041, Name = "Icy Terror" },
  { ID = 2643042, Name = "Bolts of Sorrow" },
  { ID = 2643043, Name = "Ghostly Scream" },
  { ID = 2643044, Name = "Humming Bird" },
  { ID = 2643045, Name = "Time-Out" },
  { ID = 2643046, Name = "Storm's Eye" },
  { ID = 2643047, Name = "Ferocious Lunge" },
  { ID = 2643048, Name = "Furious Bellow" },
  { ID = 2643049, Name = "Spiral Wave" },
  { ID = 2643050, Name = "Thunder Potion" },
  { ID = 2643051, Name = "Cure Potion" },
  { ID = 2643052, Name = "Aero Potion" },
  { ID = 2643053, Name = "Slapshot" },
  { ID = 2643054, Name = "Sliding Dash" },
  { ID = 2643055, Name = "Hurricane Blast" },
  { ID = 2643056, Name = "Ripple Drive" },
  { ID = 2643057, Name = "Stun Impact" },
  { ID = 2643058, Name = "Gravity Break" },
  { ID = 2643059, Name = "Zantetsuken" },
  { ID = 2643060, Name = "Tech Boost" },
  { ID = 2643061, Name = "Encounter Plus" },
  { ID = 2643062, Name = "Leaf Bracer" },
  { ID = 2643063, Name = "Evolution" },
  { ID = 2643064, Name = "EXP Zero" },
  { ID = 2643065, Name = "Combo Master" },

  --Stats Up
  { ID = 2644001, Name = "Max HP Increase" },
  { ID = 2644002, Name = "Max MP Increase" },
  { ID = 2644003, Name = "Max AP Increase" },
  { ID = 2644004, Name = "Strength Increase" },
  { ID = 2644005, Name = "Defense Increase" },
  { ID = 2644006, Name = "Accessory Slot Increase" },
  { ID = 2644007, Name = "Item Slot Increase" },

  --Summons
  { ID = 2645000, Name = "Dumbo" ,          Usefulness = item_usefulness.progression },
  { ID = 2645001, Name = "Bambi" ,          Usefulness = item_usefulness.progression },
  { ID = 2645002, Name = "Genie" ,          Usefulness = item_usefulness.progression },
  { ID = 2645003, Name = "Tinker Bell" ,    Usefulness = item_usefulness.progression },
  { ID = 2645004, Name = "Mushu" ,          Usefulness = item_usefulness.progression },
  { ID = 2645005, Name = "Simba" ,          Usefulness = item_usefulness.progression },

  --Magic
  { ID = 2646001, Name = "Progressive Fire",     Usefulness = item_usefulness.progression },
  { ID = 2646002, Name = "Progressive Blizzard", Usefulness = item_usefulness.progression },
  { ID = 2646003, Name = "Progressive Thunder",  Usefulness = item_usefulness.progression },
  { ID = 2646004, Name = "Progressive Cure",     Usefulness = item_usefulness.progression },
  { ID = 2646005, Name = "Progressive Gravity",  Usefulness = item_usefulness.progression },
  { ID = 2646006, Name = "Progressive Stop",     Usefulness = item_usefulness.progression },
  { ID = 2646007, Name = "Progressive Aero",     Usefulness = item_usefulness.progression },

  --World unlocks
  { ID = 2647002, Name = "Wonderland",       Usefulness = item_usefulness.progression },
  { ID = 2647003, Name = "Olympus Coliseum", Usefulness = item_usefulness.progression },
  { ID = 2647004, Name = "Deep Jungle",      Usefulness = item_usefulness.progression },
  { ID = 2647005, Name = "Agrabah",          Usefulness = item_usefulness.progression },
  { ID = 2647006, Name = "Halloween Town",   Usefulness = item_usefulness.progression },
  { ID = 2647007, Name = "Atlantica",        Usefulness = item_usefulness.progression },
  { ID = 2647008, Name = "Neverland",        Usefulness = item_usefulness.progression },
  { ID = 2647009, Name = "Hollow Bastion",   Usefulness = item_usefulness.progression },
  { ID = 2647010, Name = "End of the World", Usefulness = item_usefulness.progression },
  { ID = 2647011, Name = "Monstro",          Usefulness = item_usefulness.progression },

  --Trinities
  { ID = 2648001, Name = "Blue Trinity",   Usefulness = item_usefulness.progression },
  { ID = 2648002, Name = "Red Trinity",    Usefulness = item_usefulness.progression },
  { ID = 2648003, Name = "Green Trinity",  Usefulness = item_usefulness.progression },
  { ID = 2648004, Name = "Yellow Trinity", Usefulness = item_usefulness.progression },
  { ID = 2648005, Name = "White Trinity",  Usefulness = item_usefulness.progression },

  --Cups
  { ID = 2649001, Name = "Phil Cup",     Usefulness = item_usefulness.progression },
  { ID = 2649002, Name = "Pegasus Cup",  Usefulness = item_usefulness.progression },
  { ID = 2649003, Name = "Hercules Cup", Usefulness = item_usefulness.progression },
  { ID = 2649004, Name = "Hades Cup",    Usefulness = item_usefulness.progression },
}
    return items
end

local items = define_items()

function get_item_by_id(item_id)
  for i = 1, #items do
    if items[i].ID == item_id then
      return items[i]
    end
  end
end

function define_world_progress_location_threshholds()
    --[[Defines an array of location_ids based on thressholds on story progress bytes.
    This information is being obtained from https://retroachievements.org/codenotes.php?g=2780]]
    
    world_progress_location_threshholds = {}
    
    --Traverse Town
    world_progress_location_threshholds[1] = {
        {0x31, 2656011}  --Dodge Roll
       ,{0x31, 2656012}  --Fire
       ,{0x31, 2656013}  --Blue Trinity
       ,{0x31, 2656016}  --Brave Warrior
       ,{0x3e, 2656014}  --Earthshine
       ,{0x8c, 2656015}} --Oathkeeper
    
    --Deep Jungle
    world_progress_location_threshholds[2] = {
        {0x42, 2656021}  --White Fang
       ,{0x56, 2656022}  --Cure
       ,{0x6e, 2656023}  --Jungle King
       ,{0x6e, 2656024}} --Red Trinity
    
    --Olympus Coliseum
    world_progress_location_threshholds[3] = {
        {0x0D, 2656031}}  --Thunder
    
    --Wonderland
    world_progress_location_threshholds[4] = {
        {0x2E, 2656041}  --Blizzard
       ,{0x2E, 2656042}} --Ifrit's Horn
    
    --Agrabah
    world_progress_location_threshholds[5] = {
        {0x35, 2656051}  --Ray of Light
       ,{0x49, 2656052}  --Blizzard
       ,{0x5A, 2656053}  --Fire
       ,{0x78, 2656054}  --Genie
       ,{0x78, 2656055}  --Three Wishes
       ,{0x78, 2656056}} --Green Trinity
    
    --Monstro
    world_progress_location_threshholds[6] = {
        {0x2E, 2656061}  --Goofy Cheer
       ,{0x46, 2656062}} --Stop
    
    --Atlantica
    world_progress_location_threshholds[7] = {
        {0x53, 2656071}  --Mermaid Kick
       ,{0x5D, 2656072}  --Thunder
       ,{0x64, 2656073}} --Crabclaw
    
    --Unused
    world_progress_location_threshholds[8] = {}
    
    --Halloween Town
    world_progress_location_threshholds[9] = {
        {0x62, 2656081}  --Holy Circlet
       ,{0x6A, 2656082}  --Gravity
       ,{0x6E, 2656083}} --Pumpkinhead
    
    --Neverland
    world_progress_location_threshholds[10] = {
        {0x35, 2656091}  --Raven's Claw
       ,{0x3F, 2656092}  --Cure
       ,{0x56, 2656097}  --Ars Arcanum
       ,{0x6E, 2656093}  --Fairy Harp
       ,{0x6E, 2656094}  --Tinker Bell
       ,{0x6E, 2656095}  --Glide
       ,{0x96, 2656096}} --Stop
    
    --Hollow Bastion
    world_progress_location_threshholds[11] = {
        {0x32, 2656101}  --White Trinity
       ,{0x5A, 2656102}  --Donald Cheer
       ,{0x6E, 2656103}  --Fireglow
       ,{0x82, 2656104}  --Ragnarok
       ,{0xB9, 2656105}  --Omega Arts
       ,{0xC3, 2656106}} --Fire

    --End of the World
    world_progress_location_threshholds[12] = {
        {0x33, 2656111}} --Superglide
    
    --Extra Traverse Town Progress
    world_progress_location_threshholds[13] = {
        {0x14, 2656131}} --Aero
    
    return world_progress_location_threshholds
end

world_progress_location_threshholds = define_world_progress_location_threshholds()

function read_chests_opened_array()
    --Reads an array of bits which represent which chests have been opened by the player
    chests_opened_address = 0x2DE5F9C - offset
    chest_array = ReadArray(chests_opened_address, 509)
    return chest_array
end

function read_soras_level()
    --[[Reads Sora's Current Level]]
    soras_level_address = 0x2DE5A08 - offset
    return ReadShort(soras_level_address)
end

function read_soras_stats_array()
    --[[Reads an array of Sora's stats]]
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
    --[[Reads the current check number by getting the sum total of the 3 AP items]]
    gummi_address = 0x2DF1848 - offset
    check_number_item_address = gummi_address + 0x77
    return ReadArray(check_number_item_address, 3)
end

function read_world()
    --[[Gets the numeric value of the currently occupied world]]
    world_address = 0x233CADC - offset
    return ReadByte(world_address)
end

function read_ansems_secret_reports()
    --[[Reads an array of the bytes who's bits correspond to which Secret Reports have 
    been unlocked in Jiminy's Journal]]
    ansems_secret_reports = 0x2DE7390 - offset
    ansems_secret_reports_array = ReadArray(ansems_secret_reports, 2)
    return ansems_secret_reports_array
end

function read_olympus_cups_array()
    --[[Reads an array of the bytes which correspond to which Olympus Coliseum
    cups have been unlocked.]]
    olympus_cups_address = 0x2DE77D0 - offset
    return ReadArray(olympus_cups_address, 4)
end

function read_world_progress_array()
    --[[Reads an array of world progress bytes that correspond to Sora's progress through
    each world.  The order of worlds are as follows:
    Traverse Town, Deep Jungle, Olympus Coliseum, Wonderland, Agrabah, Monstro,
    Atlantica, Halloween Town, Neverland, Hollow Bastion, End of the World]]
    world_progress_address = 0x2DE65D0 - 0x200 + 0xB04 - offset
    world_progress_array = ReadArray(world_progress_address, 12)
    extra_traverse_town_progress_address = world_progress_address + 0xE
    world_progress_array[13] = ReadByte(extra_traverse_town_progress_address)
    return world_progress_array
end

function read_postcards_mailed()
    --[[Reads a byte that tracks how many postcards have been mailed]]
    postcards_mailed_address = 0x2DE78C0 - 0x231 - offset
    postcards_mailed = ReadByte(postcards_mailed_address)
    return postcards_mailed
end

function read_cup_locations_checked_array(ansems_secret_reports_array)
    cup_locations_checked = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    cup_complete_address = 0x2DE78BF + 0x15C47 - offset
    cup_rewards_address = 0x2DFD517 - offset
    cup_complete_array = ReadArray(cup_complete_address, 4)
    for i=1,#cup_complete_array do
        for j=1,cup_complete_array[i] do
            cup_locations_checked[((i-1)*3) + j] = 1
        end
    end
    cup_rewards_array = ReadArray(cup_rewards_address, 4)
    cup_locations_checked[13] = cup_rewards_array[1]
    cup_locations_checked[14] = cup_rewards_array[2]
    cup_locations_checked[15] = cup_rewards_array[3]
    cup_locations_checked[16] = cup_rewards_array[4]
    cup_locations_checked[17] = 0
    if toBits(ansems_secret_reports_array[1])[1] == 1 then
        cup_locations_checked[17] = 1
    end
    if cup_complete_array[3] > 0 then
        cup_locations_checked[18] = 1
        cup_locations_checked[19] = 1
    end
    return cup_locations_checked
end

function read_atlantica_clams()
    atlantica_clams_bits_array = {}
    atlantica_clams_address = 0x2DE738F + 0x3EA - offset
    atlantica_clams_bytes_array = ReadArray(atlantica_clams_address, 2)
    atlantica_byte_1_bits = toBits(atlantica_clams_bytes_array[1])
    atlantica_byte_2_bits = toBits(atlantica_clams_bytes_array[2])
    for i=1,8 do
        if atlantica_byte_1_bits[i] ~= nil then 
            atlantica_clams_bits_array[i] = atlantica_byte_1_bits[i]
        else
            atlantica_clams_bits_array[i] = 0
        end
    end
    for i=1,8 do
        if atlantica_byte_2_bits[i] ~= nil then 
            atlantica_clams_bits_array[8+i] = atlantica_byte_2_bits[i]
        else
            atlantica_clams_bits_array[8+i] = 0
        end
    end
    return atlantica_clams_bits_array
end

function read_magic_items()
    gummi_address = 0x2DF1848 - offset
    magic_item_address = gummi_address + 0x90
    magic_items_array = ReadArray(magic_item_address, 7)
    return magic_items_array
end

function read_world_items()
    gummi_address = 0x2DF1848 - offset
    world_item_address = gummi_address + 0x7B
    world_items_array = ReadArray(world_item_address, 2)
    return world_items_array
end

function read_summon_item()
    summon_bits = {0,0,0,0,0,0}
    gummi_address = 0x2DF1848 - offset
    summon_item_address = gummi_address + 0x7E
    summon_item_value = ReadByte(summon_item_address)
    summon_item_bits = toBits(summon_item_value)
    for k=0,#summon_item_bits do
        summon_bits[k] = summon_item_bits[k]
    end
    return summon_bits
end

function read_trinity_item()
    gummi_address = 0x2DF1848 - offset
    trinity_item_address = gummi_address + 0x7D
    trinity_item_value = ReadByte(trinity_item_address)
    return toBits(trinity_item_value)
end

function read_olympus_cups_item()
    gummi_address = 0x2DF1848 - offset
    cup_item_address = gummi_address + 0x97
    olympus_cups_item_value = ReadByte(cup_item_address)
    return toBits(olympus_cups_item_value)
end

function read_victory_item()
    gummi_address = 0x2DF1848 - offset
    victory_item_address = gummi_address + 0x7F
    return ReadByte(victory_item_address)
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

function read_required_reports()
    if file_exists(client_communication_path .. "required_reports.cfg") then
        file = io.open(client_communication_path .. "required_reports.cfg", "r")
        io.input(file)
        required_reports = tonumber(io.read())
        io.close(file)
    end
end

function read_misc_checks()
    --[[Reads checks that are scattered throughout memory]]
    location_ids = {}
    lookup_table = {
         {0x2DE66F8 - offset, 2656300, 0, 0x1}
        ,{0x2DE66F9 - offset, 2656301, 0, 0x1}
        ,{0x2DE66FA - offset, 2656302, 0, 0x1}
        ,{0x2DE66FF - offset, 2656303, 0, 0x1}
        ,{0x2DE6705 - offset, 2656310, 0, 0x1}
        ,{0x2DE6708 - offset, 2656311, 0, 0x1}
        ,{0x2DE6709 - offset, 2656312, 0, 0x1}
        ,{0x2DE670A - offset, 2656313, 0, 0x1}
        ,{0x2DE680C - offset, 2656314, 0, 0x1}
        ,{0x2DE680D - offset, 2656315, 0, 0x1}
        ,{0x2DE680E - offset, 2656316, 0, 0x1}
        ,{0x2DE680F - offset, 2656317, 0, 0x1}
        ,{0x2DE6810 - offset, 2656318, 0, 0x1}
      --,{0x2DE6810 - offset, 2656319, 0, 0x1} Torn Page
        ,{0x2DE6811 - offset, 2656320, 0, 0x1}
        ,{0x2DE6812 - offset, 2656321, 0, 0x1}
        ,{0x2DE6813 - offset, 2656322, 0, 0x1}
        ,{0x2DE6814 - offset, 2656324, 0, 0x1}
        ,{0x2DE6815 - offset, 2656326, 0, 0x1}
        ,{0x2DE6815 - offset, 2656327, 0, 0x1}
        ,{0x2DE68D2 - offset, 2656032, 0, 0x1}
        ,{0x2DE693A - offset, 2656328, 0, 0x1}
        ,{0x2DE6939 - offset, 2656329, 0, 0x1}
        ,{0x2DE77E3 - offset, 2656330, 0, 0x1}
        ,{0x2DE77A0 - offset, 2656331, 2, 0x0}
        ,{0x2DE7832 - offset, 2656344, 2, 0x0}
        ,{0x2DE6DD2 - offset, 2656345, 0, 0x2}
        ,{0x2DE6DD3 - offset, 2656346, 0, 0x2}
        ,{0x2DE6DD4 - offset, 2656347, 0, 0x2}
        ,{0x2DE6DD5 - offset, 2656348, 0, 0x2}
        ,{0x2DE6DD6 - offset, 2656349, 0, 0x2}
        ,{0x2DE6DDF - offset, 2656350, 0, 0x1}
        ,{0x2DE6DE0 - offset, 2656351, 0, 0x1}
        ,{0x2DE6DE1 - offset, 2656352, 0, 0x1}
        ,{0x2DE6DE2 - offset, 2656353, 0, 0x1}
        ,{0x2DE6DE3 - offset, 2656354, 0, 0x1}
        ,{0x2DE6DE4 - offset, 2656355, 0, 0x1}
        ,{0x2DE6DF6 - offset, 2656356, 0, 0x4}
        ,{0x2DE7713 - offset, 2656357, 0, 0x4}
        ,{0x2DE7714 - offset, 2656358, 0, 0x4}
        ,{0x2DE7715 - offset, 2656359, 0, 0x4}
        ,{0x2DE7716 - offset, 2656360, 0, 0x4}
        ,{0x2DE76EF - offset, 2656361, 0, 0x1}
        ,{0x2DE76E9 - offset, 2656362, 0, 0x1}
        ,{0x2DE76F7 - offset, 2656363, 0, 0x1}
        ,{0x2DE6BDD - offset, 2656364, 0, 0x1}
        ,{0x2DE6BDE - offset, 2656365, 0, 0x1}
        ,{0x2DE6BDF - offset, 2656366, 0, 0x1}
        ,{0x2DE6BE0 - offset, 2656367, 0, 0x1}
        ,{0x2DE6BE1 - offset, 2656368, 0, 0x1}
        ,{0x2DE7779 - offset, 2656369, 0, 0x1}
        ,{0x2DE7709 - offset, 2656370, 0, 0x1}
        ,{0x2DE770A - offset, 2656371, 0, 0x1}
        ,{0x2DE770B - offset, 2656372, 0, 0x1}
        ,{0x2DE770C - offset, 2656373, 0, 0x1}
        ,{0x2DE7705 - offset, 2656374, 0, 0x1}}
    for k,v in pairs(lookup_table) do
        value = ReadByte(v[1])
        if v[3] == 0 and value >= v[4] then
            table.insert(location_ids, v[2])
        elseif v[3] > 0 and (value%(2^v[3]) >= 2^(v[3]-1)) then
            table.insert(location_ids, v[2])
        end
    end
    return location_ids
end

function read_synth()
    location_ids = {}
    stock_address = 0x2DE5E69 + 0xC0 - offset
    synth_array = ReadArray(stock_address, 6)
    for k,v in pairs(synth_array) do
        if v >= 1 then
            location_ids[#location_ids+1] = 2656400 + k
        end
    end
    return location_ids
end

function write_world_lines()
    --[[Opens all world connections on the world map]]
    world_map_lines_address = 0x2DE78E2 - offset
    WriteArray(world_map_lines_address, {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF})
end

function write_rewards()
    --[[Removes all obtained items from rewards]]
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
    --[[Removes all obtained items from chests]]
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
    --[[Writes unlocked worlds.  Array of 11 values, one for each world
    TT, WL, OC, DJ, AG, AT, HT, NL, HB, EW, MS
    00 is invisible
    01 is visible/unvisited
    02 is selectable/unvisited
    03 is incomplete
    04 is complete]]
    world_status_address = 0x2DE78C0 - offset
    monstro_status_addresss = world_status_address + 0xA
    WriteArray(world_status_address, unlocked_worlds_array)
    WriteByte(monstro_status_addresss, monstro_unlocked)
end

function write_synth_requirements()
    --[[Writes to the synth requirements array, making the first 20 items require
    an unobtainable material, preventing the player from synthing.]]
    synth_requirements_address = 0x544320 - offset
    synth_items_address =  0x544320 + 0x1E0 - offset
    synth_items_array = {}
    synth_array = {}
    local i = 0
    while i < 1 do --First 6 items become DI items to send checks
        synth_array[(i*4) + 1] = 0xBA --Requirement (material)
        synth_array[(i*4) + 2] = 0x00 --Blank
        synth_array[(i*4) + 3] = 0x01 --Number of items needed
        synth_array[(i*4) + 4] = 0x00 --Blank
        i = i + 1
    end
    while i < 2 do --First 20 items should be enough to prevent player from unlocking more recipes
        synth_array[(i*4) + 1] = 0xE8 --Requirement (unobtainable)
        synth_array[(i*4) + 2] = 0x00 --Blank
        synth_array[(i*4) + 3] = 0x01 --Number of items needed
        synth_array[(i*4) + 4] = 0x00 --Blank
        i = i + 1
    end
    i = 0
    while i < 6 do --First 6 items become DI items to send checks
        synth_items_array[(i*10) + 1] = 0xC0 + i--Item
        synth_items_array[(i*10) + 2] = 0x00
        synth_items_array[(i*10) + 3] = 0x00 --Offset
        synth_items_array[(i*10) + 4] = 0x01 --Number of items needed
        synth_items_array[(i*10) + 5] = 0x00
        synth_items_array[(i*10) + 6] = 0x00
        synth_items_array[(i*10) + 7] = 0x00
        synth_items_array[(i*10) + 8] = 0x00
        synth_items_array[(i*10) + 9] = 0x00
        synth_items_array[(i*10) + 10] = 0x00
        i = i + 1
    end
    while i < 20 do --First 20 items should be enough to prevent player from unlocking more recipes
        synth_items_array[(i*10) + 1] = 0xE8 --Item
        synth_items_array[(i*10) + 2] = 0x00
        synth_items_array[(i*10) + 3] = 0x01 --Offset
        synth_items_array[(i*10) + 4] = 0x01 --Number of items needed
        synth_items_array[(i*10) + 5] = 0x00
        synth_items_array[(i*10) + 6] = 0x00
        synth_items_array[(i*10) + 7] = 0x00
        synth_items_array[(i*10) + 8] = 0x00
        synth_items_array[(i*10) + 9] = 0x00
        synth_items_array[(i*10) + 10] = 0x00
        i = i + 1
    end
    WriteArray(synth_requirements_address, synth_array)
    WriteArray(synth_items_address, synth_items_array)
end

function write_soras_stats(soras_stats_array)
    --[[Writes Sora's calculated stats back to memory]]
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
    --[[Writes the correct number of "check" unused gummi items. Used for syncing game with server]]
    gummi_address = 0x2DF1848 - offset
    check_number_item_address = gummi_address + 0x77
    WriteArray(check_number_item_address, check_array)
end

function write_item(item_offset)
    --[[Grants the players a specific item defined by the offset]]
    inventory_address = 0x2DE5E69 - offset
    WriteByte(inventory_address + item_offset, math.min(ReadByte(inventory_address + item_offset) + 1, 99))
end

function write_sora_ability(ability_value)
    --[[Grants the player a specific ability defined by the ability value]]
    abilities_address = 0x2DE5A13 - offset
    local i = 1
    while ReadByte(abilities_address + i) ~= 0 do
        i = i + 1
    end
    if i <= 48 then
        WriteByte(abilities_address + i, ability_value + 128)
    end
end

function write_shared_ability(shared_ability_value)
    --[[Writes the player's unlocked shared abilities]]
    shared_abilities_address = 0x2DE5F68 - offset
    local i = 1
    while ReadByte(shared_abilities_address + i) ~= 0 do
        i = i + 1
    end
    if i <= 4 then
        WriteByte(shared_abilities_address + i, shared_ability_value + 128)
    end
end

function write_summons_array(summons_array)
    --[[Writes the player's unlocked summons]]
    summons_address = 0x2DE61A0 - offset
    WriteArray(summons_address, summons_array)
end

function write_magic(magic_unlocked_bits, magic_levels_array)
    --[[Writes the players unlocked magic]]
    magic_unlocked_address = 0x2DE5A44 - offset
    magic_levels_offset = 0x41E
    WriteByte(magic_unlocked_address,
        (1 * magic_unlocked_bits[1]) + (2 * magic_unlocked_bits[2]) + (4 * magic_unlocked_bits[3]) + (8 * magic_unlocked_bits[4])
        + (16 * magic_unlocked_bits[5]) + (32 * magic_unlocked_bits[6]) + (64 * magic_unlocked_bits[7]))
    WriteArray(magic_unlocked_address + magic_levels_offset, magic_levels_array)
end

function write_trinities(trinity_bits)
    --[[Writes the players unlocked trinities]]
    trinities_unlocked_address = 0x2DE75EB - offset
    WriteByte(trinities_unlocked_address, (1 * trinity_bits[1]) + (2 * trinity_bits[2]) + (4 * trinity_bits[3]) + (8 * trinity_bits[4]) + (16 * trinity_bits[5]))
end

function write_olympus_cups(olympus_cups_array)
    --[[Writes the player's unlocked Olympus Coliseum cups]]
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
    --[[Removes level up rewards from the game, as they will be handled by the server]]
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
    --[[Chests in the game grant the player "e", which is item value 0.
    We clear this out, as the player can't hold more than 99]]
    inventory_address = 0x2DE5E69 - offset
    WriteByte(inventory_address, 0)
end

function write_summon_item(summon_bit_number)
    --[[Writes a gummi item who's bits represent a summon being unlocked]]
    summon_bits = {0,0,0,0,0,0}
    gummi_address = 0x2DF1848 - offset
    summon_item_address = gummi_address + 0x7E
    summon_item_value = ReadByte(summon_item_address)
    summon_item_bits = toBits(summon_item_value)
    for k=1,#summon_item_bits do
        summon_bits[k] = summon_item_bits[k]
    end
    if summon_bits[summon_bit_number+1] == 0 then
        WriteByte(summon_item_address, summon_item_value + 2^summon_bit_number)
    end
end

function write_magic_item(magic_item_number)
    --[[Writes a gummi item who's value represent a spell's level (0 being locked)]]
    gummi_address = 0x2DF1848 - offset
    magic_item_address = gummi_address + 0x8F + magic_item_number
    magic_item_value = ReadByte(magic_item_address)
    if magic_item_value < 3 then
        WriteByte(magic_item_address, magic_item_value + 1)
    end
end

function write_world_item(world_bit_number)
    --[[Writes a gummi item who's bits represent a world being unlocked]]
    world_bits = {0,0,0,0,0,0,0,0}
    gummi_address = 0x2DF1848 - offset
    world_item_address = gummi_address + 0x7B
    if world_bit_number > 8 then
        world_item_address = world_item_address + 1
        world_bit_number = world_bit_number % 8
    end
    world_item_value = ReadByte(world_item_address)
    world_item_bits = toBits(world_item_value)
    for k=1,#world_item_bits do
        world_bits[k] = world_item_bits[k]
    end
    if world_bits[world_bit_number] == 0 then
        WriteByte(world_item_address, world_item_value + 2^(world_bit_number-1))
    end
end

function write_trinity_item(trinity_bit_number)
    --[[Writes a gummi item who's bits represent a trinity being unlocked]]
    trinity_bits = {0,0,0,0,0}
    gummi_address = 0x2DF1848 - offset
    trinity_item_address = gummi_address + 0x7D
    trinity_item_value = ReadByte(trinity_item_address)
    trinity_item_bits = toBits(trinity_item_value)
    for k=0,#trinity_item_bits do
        trinity_bits[k] = trinity_item_bits[k]
    end
    if trinity_bits[trinity_bit_number] == 0 then
        WriteByte(trinity_item_address, trinity_item_value + 2^(trinity_bit_number-1))
    end
end

function write_olympus_cups_item(cup_bit_number)
    --[[Writes a gummi item who's bits represent a Olympus Coliseum cup being unlocked]]
    cup_bits = {0,0,0}
    gummi_address = 0x2DF1848 - offset
    cup_item_address = gummi_address + 0x97
    cup_item_value = ReadByte(cup_item_address)
    cup_item_bits = toBits(cup_item_value)
    for k=0,#cup_item_bits do
        cup_bits[k] = cup_item_bits[k]
    end
    if cup_bits[cup_bit_number] == 0 then
        WriteByte(cup_item_address, cup_item_value + 2^(cup_bit_number-1))
    end
end

function write_victory_item()
    --[[Writes a gummi item who's value represents the player having completed their goal]]
    gummi_address = 0x2DF1848 - offset
    victory_item_address = gummi_address + 0x7F
    WriteByte(victory_item_address, 1)
end

function write_material()
    material_byte_array = {0x37, 0x45, 0x58, 0x49, 0x56, 0x4D, 0x45, 0x50, 0x00}
    material_name_pointer_address = 0x4D3650 - offset
    material_name_pointer_offsets = {0x8,0x8,0x60,0x904}
    current_address = GetPointer(material_name_pointer_address, 0x108)
    for k,ptr_offset in pairs(material_name_pointer_offsets) do
        current_address = GetPointer(current_address, ptr_offset, true)
    end
    WriteArray(current_address, material_byte_array, true)
end

function write_puppy(puppy_id)
    --[[Handles writing one or more puppies to the acquired puppy list, tracked in the journal]]
    puppy_array_address = 0x2DE70D3 - offset
    byte_bases = {0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01}
    puppies_to_write = {}
    if puppy_id <= 99 then
        table.insert(puppies_to_write,puppy_id)
    elseif puppy_id >= 101 and puppy_id <= 133 then
        puppy_id = (puppy_id % 100) * 3
        for j = 0, 2 do
            table.insert(puppies_to_write, puppy_id - j)
        end
    elseif puppy_id == 140 then
        for j = 1, 99 do
            table.insert(puppies_to_write, j)
        end
    end
    for k,puppy_num in pairs(puppies_to_write) do
        byte_offset = (puppy_num-1)//8
        bit_offset = ((puppy_num-1)%8) + 1
        byte_base = byte_bases[bit_offset]
        puppy_byte_value = ReadByte(puppy_array_address + byte_offset)
        if byte_base == 0x80 then
            if puppy_byte_value < 0x80 then
                puppy_byte_value = puppy_byte_value + 0x80
            end
        elseif puppy_byte_value % byte_bases[bit_offset-1] < byte_base then
            puppy_byte_value = puppy_byte_value + byte_base
        end
        WriteByte(puppy_array_address + byte_offset, puppy_byte_value)
    end
end

function write_geppetto_conditions()
    darkball_defeated_address =             0x2DE61DE - offset
    all_summons_address =                   0x2DE66FF - offset
    times_entered_geppettos_house_address = 0x2DE6707 - offset
    
    
    WriteShort(darkball_defeated_address, 5000)
    WriteByte(times_entered_geppettos_house_address, 30)
    
    summons_address = 0x2DE61A0 - offset
    summons_array = ReadArray(summons_address, 6)
    number_of_summons_obtained = 0
    for k,v in pairs(summons_array) do
        if v < 255 then
            number_of_summons_obtained = number_of_summons_obtained + 1
        end
    end
    if number_of_summons_obtained == 6 then
        WriteByte(all_summons_address, 1)
    end
end

function final_ansem_defeated()
    --[[Checks if the player is on the results screen, meaning that they defeated Final Ansem]]
    world = 0x233CADC - offset
    room = world + 0x68
    cutscene_flags_address = 0x2DE65D0 - 0x200 + 0xB04 - offset
    return (ReadByte(world) == 0x10 and ReadByte(room) == 0x20 and ReadByte(cutscene_flags_address + 0xB) == 0x9B)
end

function parse_world_progress_array(world_progress_array)
    --[[Parses the world progress array to pull location ids out]]
    found_location_ids = {}
    for world,flags in pairs(world_progress_array) do
        for threshhold_num,threshhold in pairs(world_progress_location_threshholds[world]) do
            if flags >= threshhold[1] then --If we've progressed to or passed the thresshold
                found_location_ids[#found_location_ids+1] = threshhold[2] --Store the location_id
            end
        end
    end
    return found_location_ids
end

function increment_check_array(check_array)
    --[[Correctly increments the check items, as the player can't hold more than 
    255 of one check item]]
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
    --[[Calculates sora's stats by incrementing the stat based on the stat_increases array]]
    stat_increases = {3, 1, 2, 2, 2, 1, 1}
    soras_stats_array = read_soras_stats_array()
    soras_stats_array[value] = soras_stats_array[value] + stat_increases[value]
    write_soras_stats(soras_stats_array)
end

function fix_shortcuts()
    --[[Ensures that the player never has a shortcut set for a spell they don't posses]]
    shortcuts_address = 0x2DE6214 - offset
    shortcuts = ReadArray(shortcuts_address, 3)
    shortcuts_changed = false
    local i = 1
    while i <= 3 do
        if magic_unlocked_bits[shortcuts[i]+1] ~= 1 then
            shortcuts[i] = 255
            shortcuts_changed = true
        end
        i = i + 1
    end
    if shortcuts_changed then
        WriteArray(shortcuts_address, shortcuts)
    end
end

function receive_items()
    --[[Main function for receiving incremental items, like non-shared abilities, weapons
    consumables, and accessories]]
    check_array = read_check_array()
    i = check_array[1] + check_array[2] + check_array[3] + 1
    while file_exists(client_communication_path .. "AP_" .. tostring(i) .. ".item") do
        file = io.open(client_communication_path .. "AP_" .. tostring(i) .. ".item", "r")
        io.input(file)
        received_item_id = tonumber(io.read())
        io.close(file)
        if not initializing and read_world() ~= 0 then
            local item = get_item_by_id(received_item_id) or { Name = "UNKNOWN ITEM", ID = -1}
            table.insert(message_cache.items, item)
        end
        if received_item_id == 2640000 then
            write_victory_item()
        elseif received_item_id >= 2641000 and received_item_id < 2642000 then
            write_item(received_item_id % 2641000)
        elseif received_item_id >= 2642000 and received_item_id < 2642100 then
            write_shared_ability(received_item_id % 2642000)
        elseif received_item_id >= 2642100 and received_item_id < 2643000 then
            write_puppy(received_item_id % 2642100)
        elseif received_item_id >= 2643000 and received_item_id < 2644000 then
            write_sora_ability(received_item_id % 2643000)
        elseif received_item_id >= 2644000 and received_item_id < 2645000 then
            add_to_soras_stats(received_item_id % 2644000)
        elseif received_item_id >= 2645000 and received_item_id < 2646000 then
            write_summon_item(received_item_id % 2645000)
        elseif received_item_id >= 2646000 and received_item_id < 2647000 then
            write_magic_item(received_item_id % 2646000)
        elseif received_item_id >= 2647000 and received_item_id < 2648000 then
            write_world_item(received_item_id % 2647000)
        elseif received_item_id >= 2648000 and received_item_id < 2649000 then
            write_trinity_item(received_item_id % 2648000)
        elseif received_item_id >= 2649000 and received_item_id < 2650000 then
            write_olympus_cups_item(received_item_id % 2649000)
        end
        check_array = increment_check_array(check_array)
        i = i + 1
    end
    initializing = false
    write_check_array(check_array)
end

function calculate_full()
    --[[Main function for calculating values which need to be overwritten consistently, in
    order to remove things the game might give the player.  These include magic, trinities, etc]]
    
    --Handle Magic
    magic_unlocked_bits = {0, 0, 0, 0, 0, 0, 0}
    magic_levels_array  = {1, 1, 1, 1, 1, 1, 1}
    magic_items_array = read_magic_items()
    for i=1,#magic_items_array do
        if magic_items_array[i] >= 1 then
            magic_unlocked_bits[i] = 1
        end
        magic_levels_array[i] = math.max(magic_items_array[i],1)
    end
    write_magic(magic_unlocked_bits, magic_levels_array)
    --End Handle Magic
    
    --Handle Worlds
    worlds_unlocked_array = {3, 0, 0, 0, 0, 0, 0, 0, 0}
    monstro_unlocked = 0
    world_item_array = read_world_items()
    world_byte_1_bits = toBits(world_item_array[1])
    world_byte_2_bits = toBits(world_item_array[2])
    for i=2,8 do
        if world_byte_1_bits[i] ~= nil then
            worlds_unlocked_array[i] = world_byte_1_bits[i] * 3
        end
    end
    if world_byte_2_bits[1] ~= nil then
        worlds_unlocked_array[9] = world_byte_2_bits[1] * 3
    end
    if read_report_qty() >= required_reports then
        worlds_unlocked_array[10] = 3
    else
        worlds_unlocked_array[10] = 0
    end
    if world_byte_2_bits[3] ~= nil then
        monstro_unlocked = world_byte_2_bits[3] * 3
    end
    --End Handle Worlds
    
    --Handle Summons
    summons_array = {255, 255, 255, 255, 255, 255}
    summon_item_array = read_summon_item()
    j = 1
    for i=1,#summon_item_array do
        if summon_item_array[i] == 1 then
            summons_array[j] = i - 1
            j = j + 1
        end
    end
    write_summons_array(summons_array)
    --End Handle Summons
    
    --Handle Trinities
    trinity_bits = {0,0,0,0,0}
    trinity_item_bits = read_trinity_item()
    for i=1,#trinity_item_bits do
        trinity_bits[i] = trinity_item_bits[i]
    end
    --End Handle Trinities
    
    --Handle Olympus Cups
    olympus_cups_array = {0, 0, 0, 0}
    olympus_cups_bits = read_olympus_cups_item()
    for i=1,#olympus_cups_bits do
        olympus_cups_array[i] = olympus_cups_bits[i] * 10
    end
    if olympus_cups_array[1] == 10 and olympus_cups_array[2] == 10 and olympus_cups_array[3] == 10 then
        olympus_cups_array[4] = 10
    end
    write_olympus_cups(olympus_cups_array)
    --End Handle Olympus Cups
    
    --Handle Victory
    victory_item_value = read_victory_item()
    victory = victory_item_value > 0
    --End Handle Victory
    return victory
end

function send_locations()
    --[[Communicates with the client which locations have been checked]]
    chest_array = read_chests_opened_array()
    world_progress_array = read_world_progress_array()
    world_progress_location_ids = parse_world_progress_array(world_progress_array)
    ansems_secret_reports_array = read_ansems_secret_reports()
    misc_location_ids = read_misc_checks()
    synth_location_ids = read_synth()
    soras_level = read_soras_level()
    postcards_mailed = read_postcards_mailed()
    cup_locations_checked = read_cup_locations_checked_array(ansems_secret_reports_array)
    atlantica_clam_bits = read_atlantica_clams()
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
    for k,v in pairs(world_progress_location_ids) do
        if not file_exists(client_communication_path .. "send" .. tostring(v)) then
                file = io.open(client_communication_path .. "send" .. tostring(v), "w")
                io.output(file)
                io.write("")
                io.close(file)
        end
    end
    for k,v in pairs(misc_location_ids) do
        if not file_exists(client_communication_path .. "send" .. tostring(v)) then
                file = io.open(client_communication_path .. "send" .. tostring(v), "w")
                io.output(file)
                io.write("")
                io.close(file)
        end
    end
    for k,v in pairs(synth_location_ids) do
        if not file_exists(client_communication_path .. "send" .. tostring(v)) then
                file = io.open(client_communication_path .. "send" .. tostring(v), "w")
                io.output(file)
                io.write("")
                io.close(file)
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
    for j=1,postcards_mailed do
        location_id = 2656119 + j
        if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
            file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end
    for j=1,#cup_locations_checked do
        if cup_locations_checked[j] == 1 then
            location_id = 2659000 + j
            if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
                file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
                io.output(file)
                io.write("")
                io.close(file)
            end
        end
    end
    for j=1,#atlantica_clam_bits do
        if atlantica_clam_bits[j] == 1 then
            location_id = 2656200 + j
            if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
                file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
                io.output(file)
                io.write("")
                io.close(file)
            end
        end
    end
    if final_ansem_defeated() then
        location_id = 2659999
        if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
            file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
            io.output(file)
            io.write("")
            io.close(file)
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

--MESSAGE HANDLING BLOCK BY KRUJO--

function receive_sent_msgs()
    --[[Written by Krujo.  Handles the messages coming directly from the server for 
    messages involving sending items to other players]]
    local filename = client_communication_path .. "sent"
    if file_exists(filename) then
        local lines = {}
        local file = io.open(filename, "r")
        local line = file:read("*line")
        while line do
            table.insert(lines, line)
            line = file:read("*line")
        end
        file:close()
        if message_cache.locationID ~= lines[4] then --If the last sent prompt we parsed does not share a location id with this prompt we're reading
            table.insert(message_cache.sent, lines)
            message_cache.locationID = lines[4]
        end
    end
end

function GetKHSCII(INPUT)
    local _charTable = {
        [' '] =  0x01,
        ['\n'] =  0x02,
        ['-'] =  0x6E,
        ['!'] =  0x5F,
        ['?'] =  0x60,
        ['%'] =  0x62,
        ['/'] =  0x66,
        ['.'] =  0x68,
        [','] =  0x69,
        [';'] =  0x6C,
        [':'] =  0x6B,
        ['\''] =  0x71,
        ['('] =  0x74,
        [')'] =  0x75,
        ['['] =  0x76,
        [']'] =  0x77,
        ['¡'] =  0xCA,
        ['¿'] =  0xCB,
        ['À'] =  0xCC,
        ['Á'] =  0xCD,
        ['Â'] =  0xCE,
        ['Ä'] =  0xCF,
        ['Ç'] =  0xD0,
        ['È'] =  0xD1,
        ['É'] =  0xD2,
        ['Ê'] =  0xD3,
        ['Ë'] =  0xD4,
        ['Ì'] =  0xD5,
        ['Í'] =  0xD6,
        ['Î'] =  0xD7,
        ['Ï'] =  0xD8,
        ['Ñ'] =  0xD9,
        ['Ò'] =  0xDA,
        ['Ó'] =  0xDB,
        ['Ô'] =  0xDC,
        ['Ö'] =  0xDD,
        ['Ù'] =  0xDE,
        ['Ú'] =  0xDF,
        ['Û'] =  0xE0,
        ['Ü'] =  0xE1,
        ['ß'] =  0xE2,
        ['à'] =  0xE3,
        ['á'] =  0xE4,
        ['â'] =  0xE5,
        ['ä'] =  0xE6,
        ['ç'] =  0xE7,
        ['è'] =  0xE8,
        ['é'] =  0xE9,
        ['ê'] =  0xEA,
        ['ë'] =  0xEB,
        ['ì'] =  0xEC,
        ['í'] =  0xED,
        ['î'] =  0xEE,
        ['ï'] =  0xEF,
        ['ñ'] =  0xF0,
        ['ò'] =  0xF1,
        ['ó'] =  0xF2,
        ['ô'] =  0xF3,
        ['ö'] =  0xF4,
        ['ù'] =  0xF5,
        ['ú'] =  0xF6,
        ['û'] =  0xF7,
        ['ü'] =  0xF8
    }

    local _returnArray = {}

    local i = 1
    local z = 1

    while z <= #INPUT do
        local _char = INPUT:sub(z, z)

        if _char >= 'a' and _char <= 'z' then
            _returnArray[i] = string.byte(_char) - 0x1C
            z = z + 1
        elseif _char >= 'A' and _char <= 'Z' then
            _returnArray[i] = string.byte(_char) - 0x16
            z = z + 1
        elseif _char >= '0' and _char <= '9' then
            _returnArray[i] = string.byte(_char) - 0x0F
            z = z + 1
        elseif _char == '{' then
            local _str =
            {
                INPUT:sub(z + 1, z + 1),
                INPUT:sub(z + 2, z + 2),
                INPUT:sub(z + 3, z + 3),
                INPUT:sub(z + 4, z + 4),
                INPUT:sub(z + 5, z + 5)
            }

            if _str[1] == '0' and _str[2] == 'x' and _str[5] == '}' then

                local _s = _str[3] .. _str[4]

                _returnArray[i] = tonumber(_s, 16)
                z = z + 6
            end
        else
            if _charTable[_char] ~= nil then
                _returnArray[i] = _charTable[_char]
                z = z + 1
            else
                _returnArray[i] = 0x01
                z = z + 1
            end
        end

        i = i + 1
    end

    table.insert(_returnArray, 0x00)
    return _returnArray
end

function usefulness_to_colour(usefulness)
    --Written by Krujo.  Gets color values for a particular
    --defined usefulness
    if usefulness == item_usefulness.useless then
        return prompt_colours.green_mint
    elseif usefulness == item_usefulness.normal then
        return prompt_colours.red_sora
    elseif usefulness == item_usefulness.progression then
        return prompt_colours.purple_evil
    elseif usefulness == item_usefulness.special then
        return prompt_colours.red_rose
    elseif usefulness == item_usefulness.trap then
        return prompt_colours.red_trap
    end
end

function show_prompt_for_item(item)
    --[[Written by Krujo.  Wrapper for show_prompt.  Pulls output
    color information and formats text accordingly.]]
    local text_1 = ""
    local text_2 = { { item.Name } }
    local category = item_categories.consumables;
    local smallId = item.ID - 2640000
    if smallId > 1000 and smallId < 1009 then
        category = item_categories.consumable
    elseif smallId > 1008 and smallId < 1017 then
        category = item_categories.synthesis
    elseif smallId > 1016 and smallId < 1136 then
        category = item_categories.equipment
    elseif smallId > 2000 and smallId < 4001 then
        if smallId > 2100 and smallId < 2400 then
            category = item_categories.unlock
        else
            category = item_categories.ability
        end
    elseif smallId > 4000 and smallId < 5000 then
        category = item_categories.statsUp
    elseif smallId > 5000 and smallId < 6000 then
        category = item_categories.summon
    elseif smallId > 6000 and smallId < 7000 then
        category = item_categories.magic
    elseif smallId > 8000 and smallId < 9000 then
        category = item_categories.trinity
    elseif smallId > 5000 and smallId < 6000 then
        category = item_categories.summon
    elseif smallId > 7000 and smallId < 10000 then
        category = item_categories.unlock
    end
    local catUsefulness = item_usefulness.useless
    if category == item_categories.consumable then
        text_1 = "Consumable"
        catUsefulness = item_usefulness.useless
    elseif category == item_categories.synthesis then
        text_1 = "Synthesis"
        catUsefulness = item_usefulness.useless
    elseif category == item_categories.equipment then
        text_1 = "Equipment"
        catUsefulness = item_usefulness.normal
    elseif category == item_categories.ability then
        text_1 = "Ability"
        catUsefulness = item_usefulness.normal
    elseif category == item_categories.statsUp then
        text_1 = "Stat Up"
        catUsefulness = item_usefulness.normal
    elseif category == item_categories.summon then
        text_1 = "Summon"
        catUsefulness = item_usefulness.normal
    elseif category == item_categories.magic then
        text_1 = "Magic"
        catUsefulness = item_usefulness.normal
    elseif category == item_categories.trinity then
        text_1 = "Trinity"
        catUsefulness = item_usefulness.progression
    elseif category == item_categories.unlock then
        text_1 = "Unlock"
        catUsefulness = item_usefulness.progression
    end
    local colour = prompt_colours.red_sora;
    if item.Usefulness == nil then
        item.Usefulness = catUsefulness
    end
    colour = usefulness_to_colour(item.Usefulness)
    show_prompt({ text_1 }, text_2, null, colour)
end

function show_prompt(input_title, input_party, duration, colour)
    --[[Writes to memory the message to be displayed in a Level Up prompt.]]
    if colour == nil then
        colour = prompt_colours.red_sora
    end
    local _boxMemory = 0x249740A
    local _textMemory = 0x2A1379A;

    local _partyOffset = 0x3A20;

    for i = 1, #input_title do
        if input_title[i] then
            WriteArray(_textMemory + 0x20 * (i - 1), GetKHSCII(input_title[i]))
        end
    end

    for z = 1, 3 do
        local _boxArray = input_party[z];

        local _colorBox  = 0x018408A + colour
        local _colorText = 0x01840CA + colour

        if _boxArray then
            local _textAddress = (_textMemory + 0x70) + (0x140 * (z - 1)) + (0x40 * 0)
            local _boxAddress = _boxMemory + (_partyOffset * (z - 1)) + (0xBA0 * 0)

            -- Write the box count.
            WriteInt(0x24973FA + 0x04 * (z - 1), 1)

            -- Write the Title Pointer.
            WriteLong(_boxAddress + 0x30, BASE_ADDR  + _textMemory + 0x20 * (z - 1))

            if _boxArray[2] then
                -- String Count is 2.
                WriteInt(_boxAddress + 0x18, 0x02)

                -- Second Line Text.
                WriteArray(_textAddress + 0x20, GetKHSCII(_boxArray[2]))
                WriteLong(_boxAddress + 0x28, BASE_ADDR  + _textAddress + 0x20)
            else
                -- String Count is 1
                WriteInt(_boxAddress + 0x18, 0x01)
            end

            -- First Line Text
            WriteArray(_textAddress, GetKHSCII(_boxArray[1]))
            WriteLong(_boxAddress + 0x20, BASE_ADDR  + _textAddress)

            -- Reset box timers.
            WriteInt(_boxAddress + 0x0C, duration)
            WriteFloat(_boxAddress + 0xB80, 1)

            -- Set box colors.
            WriteLong(_boxAddress + 0xB88, BASE_ADDR  + _colorBox)
            WriteLong(_boxAddress + 0xB90, BASE_ADDR  + _colorText)

            -- Show the box.
            WriteInt(_boxAddress, 0x01)
        end
    end
end

function handle_messages()
    --[[Written by Krujo.  Handles received messages in a queue system,
    sending 1 message in the message_cache every main() iteration and removing
    it from the cache.]]
    local msg = message_cache.items[1]
    if msg ~= nil then
        show_prompt_for_item(msg)
        table.remove(message_cache.items, 1)
        return
    end
    msg = message_cache.sent[1]
    if msg ~= nil then
        table.remove(message_cache.sent, 1)
        local info = {
            item = msg[1],
            reciver = msg[2],
            usefulness = math.tointeger(msg[3]),
        }
        --Link's Ocarina
        local item_msg = tostring(info.reciver);
        if (string.sub(item_msg, -1) == 's') then
            item_msg = item_msg .. "'"
        else
            item_msg = item_msg .. "'s"
        end
        item_msg = item_msg .. ' ' .. info.item
        local usefulness;
        if info.usefulness == 0 then
            usefulness = item_usefulness.useless
        elseif info.usefulness == 1 then
            usefulness = item_usefulness.progression
        elseif info.usefulness == 2 then
            usefulness = item_usefulness.normal
        elseif info.usefulness == 4 then
            usefulness = item_usefulness.trap
        end
        local colour = usefulness_to_colour(usefulness)
        show_prompt({ "Multiworld" }, { { item_msg } }, null, colour)
    end
end

--END MESSAGE HANDLING BLOCK BY KRUJO--

function main()
    --Main functions
    read_required_reports()
    receive_sent_msgs()
    receive_items()
    victory = calculate_full()
    send_locations(victory)

    --Cleaning up static things
    write_synth_requirements()
    write_chests()
    write_rewards()
    write_world_lines()
    write_level_up_rewards()
    write_e()
    write_material()
    write_geppetto_conditions()
    
    --Written by Krujo for handling messages
    handle_messages()
end

function test()
    bits = toBits(1)
    ConsolePrint(bits[1])
    ConsolePrint(bits[2])
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
    end
    frame_count = frame_count + 1
    
    --Few things that need to happen every frame rather than every 2 seconds.
    write_unlocked_worlds(worlds_unlocked_array, monstro_unlocked)
    fix_shortcuts()
    write_trinities(trinity_bits)
end