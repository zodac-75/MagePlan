-- MagePlan crafting data: leveling routes, cloth and disenchant tables.
-- The routes follow ConquestCapped's Tailoring and Enchanting guides (1-300).
-- mats = { {itemID, amount per craft, name}, ... }
-- batch = true: the whole batch is needed for later steps (bolts).
local _, ns = ...

-- Bolts -> råtyg (för att räkna ut hur mycket cloth som saknas).
ns.BOLTS = {
  [2996]  = { raw = 2589,  ratio = 2, name = "Linen Cloth" },
  [2997]  = { raw = 2592,  ratio = 3, name = "Wool Cloth" },
  [4305]  = { raw = 4306,  ratio = 4, name = "Silk Cloth" },
  [4339]  = { raw = 4338,  ratio = 5, name = "Mageweave Cloth" },
  [14048] = { raw = 14047, ratio = 4, name = "Runecloth" },
}

-- Cloth som visas i sammanfattningen.
ns.CLOTH = {
  { 2589,  "Linen" }, { 2592, "Wool" }, { 4306, "Silk" },
  { 4338,  "Mageweave" }, { 14047, "Runecloth" },
}

ns.ROUTES = {}

ns.ROUTES.Tailoring = {
  { from = 1,   to = 30,  crafts = 30,  craft = "Bolt of Linen Cloth", mats = { {2589, 2, "Linen Cloth"} }, note = { "Save the bolts for Linen Belt", "Spara bolts till Linen Belt" } },
  { from = 30,  to = 55,  crafts = 28,  craft = "Linen Belt", mats = { {2996, 1, "Bolt of Linen Cloth"}, {2320, 1, "Coarse Thread"} } },
  { from = 55,  to = 80,  crafts = 45,  craft = "Bolt of Woolen Cloth", batch = true, mats = { {2592, 3, "Wool Cloth"} }, note = { "Train Journeyman first (lvl 10)", "Träna Journeyman först (lvl 10)" } },
  { from = 80,  to = 85,  crafts = 6,   craft = "Woolen Cape", mats = { {2997, 1, "Bolt of Woolen Cloth"}, {2321, 1, "Fine Thread"} } },
  { from = 85,  to = 95,  crafts = 11,  craft = "Gray Woolen Shirt", mats = { {2997, 2, "Bolt of Woolen Cloth"}, {2321, 1, "Fine Thread"}, {4340, 1, "Gray Dye"} } },
  { from = 95,  to = 100, crafts = 5,   craft = "Double-stitched Woolen Shoulders", mats = { {2997, 3, "Bolt of Woolen Cloth"}, {2321, 2, "Fine Thread"} } },
  { from = 100, to = 120, crafts = 170, craft = "Bolt of Silk Cloth", batch = true, mats = { {4306, 4, "Silk Cloth"} }, note = { "All 170 bolts get used up to 180", "Alla 170 bolts går åt fram till 180" } },
  { from = 120, to = 135, crafts = 17,  craft = "Azure Silk Hood", mats = { {4305, 2, "Bolt of Silk Cloth"}, {6260, 2, "Blue Dye"}, {2321, 1, "Fine Thread"} }, note = { "Train Expert at 125 (lvl 20)", "Träna Expert vid 125 (lvl 20)" } },
  { from = 135, to = 140, crafts = 5,   craft = "Formal White Shirt", mats = { {4305, 3, "Bolt of Silk Cloth"}, {2324, 2, "Bleach"}, {2321, 1, "Fine Thread"} } },
  { from = 140, to = 150, crafts = 192, craft = "Bolt of Mageweave", batch = true, mats = { {4338, 5, "Mageweave Cloth"} }, note = { "All bolts get used up to 225", "Alla bolts går åt fram till 225" } },
  { from = 150, to = 170, crafts = 20,  craft = "Crimson Silk Vest", mats = { {4305, 4, "Bolt of Silk Cloth"}, {2604, 2, "Red Dye"}, {2321, 2, "Fine Thread"} } },
  { from = 170, to = 180, crafts = 10,  craft = "Crimson Silk Pantaloons", mats = { {4305, 4, "Bolt of Silk Cloth"}, {2604, 2, "Red Dye"}, {4291, 2, "Silken Thread"} } },
  { from = 180, to = 190, crafts = 12,  craft = "Orange Mageweave Shirt", mats = { {4339, 1, "Bolt of Mageweave"}, {6261, 1, "Orange Dye"}, {8343, 1, "Heavy Silken Thread"} } },
  { from = 190, to = 215, crafts = 38,  craft = "Black Mageweave Gloves", mats = { {4339, 2, "Bolt of Mageweave"}, {8343, 2, "Heavy Silken Thread"} } },
  { from = 215, to = 230, crafts = 33,  craft = "Mageweave Bag", mats = { {4339, 4, "Bolt of Mageweave"}, {4291, 2, "Silken Thread"} }, note = { "Train Artisan at 200 (lvl 35, Theramore)", "Träna Artisan vid 200 (lvl 35, Theramore)" } },
  { from = 230, to = 235, crafts = 12,  craft = "Black Mageweave Headband", mats = { {4339, 3, "Bolt of Mageweave"}, {8343, 2, "Heavy Silken Thread"} } },
  { from = 235, to = 240, crafts = 12,  craft = "Red Mageweave Bag", mats = { {4339, 4, "Bolt of Mageweave"}, {2604, 2, "Red Dye"}, {8343, 2, "Heavy Silken Thread"} } },
  { from = 240, to = 243, crafts = 4,   craft = "Admiral's Hat", mats = { {4339, 3, "Bolt of Mageweave"}, {4589, 6, "Long Elegant Feather"}, {8343, 2, "Heavy Silken Thread"} } },
  { from = 243, to = 255, crafts = 18,  craft = "Earthenweave Boots", mats = { {14048, 4, "Bolt of Runecloth"}, {7076, 2, "Essence of Earth"}, {8170, 2, "Rugged Leather"}, {14341, 1, "Rune Thread"} } },
  { from = 255, to = 260, crafts = 6,   craft = "Earthenweave Mantle", mats = { {14048, 6, "Bolt of Runecloth"}, {7076, 1, "Essence of Earth"}, {14341, 1, "Rune Thread"} } },
  { from = 260, to = 267, crafts = 8,   craft = "Earthenweave Leggings", mats = { {14048, 6, "Bolt of Runecloth"}, {7076, 2, "Essence of Earth"}, {14341, 1, "Rune Thread"} } },
  { from = 267, to = 270, crafts = 4,   craft = "Runecloth Cuffs", mats = { {14048, 5, "Bolt of Runecloth"}, {14227, 1, "Ironweb Spider Silk"}, {14341, 1, "Rune Thread"} } },
  { from = 270, to = 285, crafts = 21,  craft = "Earthenweave Cuffs", mats = { {14048, 5, "Bolt of Runecloth"}, {7076, 1, "Essence of Earth"}, {14341, 1, "Rune Thread"} } },
  { from = 285, to = 296, crafts = 24,  craft = "Earthenweave Crown", mats = { {14048, 6, "Bolt of Runecloth"}, {7076, 3, "Essence of Earth"}, {14341, 1, "Rune Thread"} } },
  { from = 296, to = 300, crafts = 6,   craft = "Mooncloth Boots", mats = { {14048, 6, "Bolt of Runecloth"}, {14342, 4, "Mooncloth"}, {7971, 2, "Black Pearl"}, {14341, 1, "Rune Thread"} } },
}

ns.ROUTES.Enchanting = {
  { from = 1,   to = 2,   crafts = 1,  craft = "Runed Copper Rod", mats = { {6217, 1, "Copper Rod"}, {247786, 1, "Mote of Magic"} }, note = { "Keep all rods", "Spara alla rods" } },
  { from = 2,   to = 20,  crafts = 18, craft = "Enchant Bracer - Inferior Stamina", mats = { {247786, 1, "Mote of Magic"} } },
  { from = 20,  to = 70,  crafts = 50, craft = "Enchant Chest - Inferior Stamina", mats = { {10940, 1, "Strange Dust"} }, note = { "Disenchant low greens instead of buying dust", "Disenchanta låga gröna istället för att köpa dust" } },
  { from = 70,  to = 130, crafts = 67, craft = "Greater Magic Wand", mats = { {4470, 1, "Simple Wood"}, {10938, 2, "Lesser Magic Essence"} }, note = { "Vendor the wands (~15s). Journeyman first (lvl 10)", "Vendora wandsen (~15s). Journeyman först (lvl 10)" } },
  { from = 130, to = 131, crafts = 1,  craft = "Runed Silver Rod", mats = { {6338, 1, "Silver Rod"}, {10940, 3, "Strange Dust"}, {10938, 4, "Lesser Magic Essence"}, {1210, 1, "Shadowgem"} } },
  { from = 131, to = 150, crafts = 19, craft = "Enchant Bracer - Lesser Stamina", mats = { {11083, 1, "Soul Dust"} }, note = { "Expert at 125 (lvl 20, Tower of Azora). Buy the Bracer - Lesser Strength formula from Dalria, Ashenvale", "Expert vid 125 (lvl 20, Tower of Azora). Köp formel Bracer - Lesser Strength hos Dalria, Ashenvale" } },
  { from = 150, to = 151, crafts = 1,  craft = "Runed Golden Rod", mats = { {11128, 1, "Golden Rod"}, {5500, 1, "Iridescent Pearl"}, {11082, 1, "Greater Astral Essence"}, {11083, 1, "Soul Dust"} } },
  { from = 151, to = 165, crafts = 14, craft = "Enchant Bracer - Lesser Strength", mats = { {11083, 1, "Soul Dust"} } },
  { from = 165, to = 185, crafts = 22, craft = "Enchant Boots - Lesser Agility", mats = { {11083, 1, "Soul Dust"} } },
  { from = 185, to = 200, crafts = 15, craft = "Enchant Bracer - Strength", mats = { {11137, 1, "Vision Dust"} } },
  { from = 200, to = 201, crafts = 1,  craft = "Runed Truesilver Rod", mats = { {11144, 1, "Truesilver Rod"}, {7971, 1, "Black Pearl"}, {11135, 1, "Greater Mystic Essence"}, {11137, 1, "Vision Dust"} }, note = { "Artisan from Annora in Uldaman (lvl 35)", "Artisan hos Annora i Uldaman (lvl 35)" } },
  { from = 201, to = 220, crafts = 35, craft = "Enchant Bracer - Strength", mats = { {11137, 1, "Vision Dust"} } },
  { from = 220, to = 230, crafts = 10, craft = "Cloak Greater Defense / Gloves Agility", mats = { {11137, 1, "Vision Dust"} } },
  { from = 230, to = 235, crafts = 5,  craft = "Enchant Boots - Stamina", mats = { {11137, 2, "Vision Dust"} } },
  { from = 235, to = 250, crafts = 20, craft = "Enchant Chest - Superior Stamina", mats = { {11137, 3, "Vision Dust"} } },
  { from = 250, to = 265, crafts = 20, craft = "Lesser Mana Oil", mats = { {11176, 1, "Dream Dust"}, {8831, 1, "Purple Lotus"}, {8925, 1, "Crystal Vial"} }, note = { "Formula from Kania in Silithus", "Formel hos Kania i Silithus" } },
  { from = 265, to = 294, crafts = 32, craft = "Enchant Shield - Greater Stamina", mats = { {11176, 6, "Dream Dust"} }, note = { "Formula from Mythrin'dir in Darnassus", "Formel hos Mythrin'dir i Darnassus" } },
  { from = 294, to = 295, crafts = 1,  craft = "Runed Arcanite Rod", mats = { {16206, 1, "Arcanite Rod"}, {13926, 1, "Golden Pearl"}, {16204, 10, "Illusion Dust"}, {16203, 4, "Greater Eternal Essence"}, {14343, 4, "Small Brilliant Shard"}, {14344, 2, "Large Brilliant Shard"} }, note = { "Formula from Lorelae Wintersong, Moonglade", "Formel hos Lorelae Wintersong, Moonglade" } },
  { from = 295, to = 300, crafts = 5,  craft = "Enchant Cloak - Superior Defense", mats = { {16204, 8, "Illusion Dust"} } },
}

-- Rang-tak -> level som krävs för nästa rang.
ns.RANK_LEVEL = { [75] = 10, [150] = 20, [225] = 35 }

-- Disenchant-utfall per item level (Classic-tabeller; Forever kan avvika).
-- dust/ess = {itemID, min, max}; pd/pe/ps = chans för dust/essence/shard (armor).
-- Vapen byter chans mellan dust och essence. rare = shard från blå föremål.
ns.DE_BRACKETS = {
  { max = 15,  req = 1,   dust = {10940, 1, 2}, ess = {10938, 1, 2}, pd = 0.80, pe = 0.20, ps = 0,    rare = 10978 },
  { max = 20,  req = 1,   dust = {10940, 2, 3}, ess = {10939, 1, 2}, pd = 0.75, pe = 0.20, ps = 0.05, shard = 10978, rare = 10978 },
  { max = 25,  req = 25,  dust = {10940, 4, 6}, ess = {10998, 1, 2}, pd = 0.75, pe = 0.15, ps = 0.10, shard = 10978, rare = 10978 },
  { max = 30,  req = 50,  dust = {11083, 1, 2}, ess = {11082, 1, 2}, pd = 0.75, pe = 0.20, ps = 0.05, shard = 11084, rare = 11084 },
  { max = 35,  req = 75,  dust = {11083, 2, 5}, ess = {11134, 1, 2}, pd = 0.75, pe = 0.20, ps = 0.05, shard = 11138, rare = 11138 },
  { max = 40,  req = 100, dust = {11137, 1, 2}, ess = {11135, 1, 2}, pd = 0.75, pe = 0.20, ps = 0.05, shard = 11139, rare = 11139 },
  { max = 45,  req = 125, dust = {11137, 2, 5}, ess = {11174, 1, 2}, pd = 0.75, pe = 0.20, ps = 0.05, shard = 11177, rare = 11177 },
  { max = 50,  req = 150, dust = {11176, 1, 2}, ess = {11175, 1, 2}, pd = 0.75, pe = 0.20, ps = 0.05, shard = 11178, rare = 11178 },
  { max = 55,  req = 175, dust = {11176, 2, 5}, ess = {16202, 1, 2}, pd = 0.75, pe = 0.20, ps = 0.05, shard = 14343, rare = 14343 },
  { max = 60,  req = 200, dust = {16204, 1, 2}, ess = {16203, 1, 2}, pd = 0.75, pe = 0.20, ps = 0.05, shard = 14344, rare = 14344 },
  { max = 999, req = 225, dust = {16204, 2, 5}, ess = {16203, 2, 3}, pd = 0.75, pe = 0.20, ps = 0.05, shard = 14344, rare = 14344 },
}
