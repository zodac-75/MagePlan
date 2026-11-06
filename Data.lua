-- MagePlan data: the leveling plan, per level.
-- Text entries are either a plain string or { "English", "Svenska" }.
local _, ns = ...

-- Main professions until you pick or learn others.
ns.DEFAULT_PROFS = { "Tailoring", "Enchanting" }

-- Talent point per level (Frost leveling, 10/0/41 at 50, then 10 in Arcane).
-- Checked against the live tree (build 1.60.1.70755).
ns.talents = {
  [10] = "Improved Frostbolt 1/5", [11] = "Improved Frostbolt 2/5",
  [12] = "Improved Frostbolt 3/5", [13] = "Improved Frostbolt 4/5",
  [14] = "Improved Frostbolt 5/5",
  [15] = "Frostbite 1/3", [16] = "Frostbite 2/3",
  [17] = "Ice Shards 1/5", [18] = "Ice Shards 2/5", [19] = "Ice Shards 3/5",
  [20] = "Ice Lance 1/1",
  [21] = "Frost Channeling 1/3", [22] = "Frost Channeling 2/3",
  [23] = "Frost Channeling 3/3",
  [24] = "Improved Blizzard 1/3",
  -- Improved Frost Nova before Shatter, in case Shatter still requires it (as in Classic).
  [25] = "Improved Frost Nova 1/2", [26] = "Improved Frost Nova 2/2",
  [27] = "Shatter 1/3", [28] = "Shatter 2/3", [29] = "Shatter 3/3",
  [30] = "Fingers of Frost 1/2",
  [31] = "Ice Block 1/1",
  [32] = "Fingers of Frost 2/2",
  [33] = "Cold Snap 1/1",
  [34] = "Improved Cone of Cold 1/3", [35] = "Improved Cone of Cold 2/3",
  [36] = "Winter's Chill 1/5", [37] = "Winter's Chill 2/5",
  [38] = "Winter's Chill 3/5", [39] = "Winter's Chill 4/5",
  [40] = "Ice Barrier 1/1",
  [41] = "Winter's Chill 5/5",
  [42] = "Frostbite 3/3",
  [43] = "Precision 1/3", [44] = "Precision 2/3", [45] = "Precision 3/3",
  [46] = "Arctic Reach 1/2", [47] = "Arctic Reach 2/2",
  [48] = "Ice Shards 4/5", [49] = "Ice Shards 5/5",
  [50] = "Improved Blizzard 2/3",
  -- 51-60: Arcane. Row 1 (5 points) opens row 2, where Arcane Concentration gives Clearcasting.
  [51] = "Arcane Resilience 1/3", [52] = "Arcane Resilience 2/3", [53] = "Arcane Resilience 3/3",
  [54] = "Wand Specialization 1/2", [55] = "Wand Specialization 2/2",
  [56] = "Arcane Concentration 1/5", [57] = "Arcane Concentration 2/5",
  [58] = "Arcane Concentration 3/5", [59] = "Arcane Concentration 4/5",
  [60] = "Arcane Concentration 5/5",
}

-- Crafted gear that becomes available at the level.
ns.gear = {
  [5]  = { "Lesser Magic Wand (Enchanting)" },
  [10] = { { "Novice Arcanist's Sash (Tailoring, belt)", "Novice Arcanist's Sash (Tailoring, bälte)" } },
  [12] = { { "Silky boots (Tailoring)", "Silky-stövlar (Tailoring)" } },
  [13] = { "Greater Magic Wand (Enchanting)" },
  [15] = { { "Silky gloves (Tailoring)", "Silky-handskar (Tailoring)" },
           { "Filigreed Silky Gown (Tailoring 75, pattern from SFK/Deadmines)", "Filigreed Silky Gown (Tailoring 75, mönster från SFK/Deadmines)" } },
  [17] = { { "Silky belt (Tailoring)", "Silky-bälte (Tailoring)" } },
  [20] = { { "Silky hood (Tailoring)", "Silky-huva (Tailoring)" },
           { "Filigreed Silky Leggings (Tailoring 100, pattern from SFK)", "Filigreed Silky Leggings (Tailoring 100, mönster från SFK)" } },
  [22] = { { "Silky robe (Tailoring) - only if better than the Gown", "Silky-robe (Tailoring) - bara om bättre än Gown" } },
  [25] = { { "Silky pants / Filigreed Silky hood (Tailoring)", "Silky-byxor / Filigreed Silky-huva (Tailoring)" },
           "Glimmering Staff (Enchanting 140, +34 spell dmg)",
           "Orb of Mystic Insight (Enchanting 140, off-hand)" },
  [30] = { { "Frothing boots (Tailoring)", "Frothing-stövlar (Tailoring)" },
           { "Icefury Wand (mage class quest)", "Icefury Wand (mage-klassquest)" } },
  [35] = { { "Frothing gloves (Tailoring)", "Frothing-handskar (Tailoring)" } },
  [40] = { { "Frothing belt (Tailoring)", "Frothing-bälte (Tailoring)" } },
  [42] = { { "Netherfroth shoulders (Tailoring)", "Netherfroth-axlar (Tailoring)" } },
  [45] = { { "Netherfroth bracers (Tailoring)", "Netherfroth-armband (Tailoring)" },
           "Radiant Staff (Enchanting, +56 spell dmg)" },
  [47] = { { "Frothing piece (Tailoring, check the slot in game)", "Frothing-del (Tailoring, kolla slot i spelet)" } },
  [50] = { { "Frothing gloves/boots (Tailoring)", "Frothing-handskar/-stövlar (Tailoring)" },
           "Frozen Heart of the Mountain (Enchanting, trinket)" },
  [55] = { "Brilliant Wand (Enchanting 275)" },
  [60] = { "Robe of the Archmage (Tailoring)",
           { "Manaflare piece (Tailoring 300, Mount Hyjal)", "Manaflare-del (Tailoring 300, Mount Hyjal)" },
           { "RESPEC to Arcane 32/16/3 before raids (Dec 9)", "RESPECCA till Arcane 32/16/3 inför raid 9 dec" } },
}

-- Spells to train (exact spell names, so the addon can check what you already know).
ns.spells = {
  [4]  = { "Frostbolt", "Conjure Water" },
  [6]  = { "Conjure Food" },
  [8]  = { "Polymorph", "Arcane Missiles" },
  [10] = { "Frost Nova" },
  [14] = { "Arcane Explosion" },
  [16] = { "Flamestrike" },
  [20] = { "Blizzard", "Blink", "Teleport: Stormwind", "Teleport: Ironforge" },
  [24] = { "Counterspell" },
  [26] = { "Cone of Cold" },
  [30] = { "Ice Armor", "Teleport: Darnassus" },
}

-- Profession goals: at this level you want at least this skill.
ns.profTargets = {
  { level = 10, skill = 50,  note = { "Train Journeyman (Stormwind)", "Träna Journeyman (Stormwind)" } },
  { level = 15, skill = 75,  note = { "Needed for Filigreed Silky Gown", "Krävs för Filigreed Silky Gown" } },
  { level = 20, skill = 125, note = { "Train Expert (Georgio Bolero / Kitta Firewind)", "Träna Expert (Georgio Bolero / Kitta Firewind)" } },
  { level = 35, skill = 200, note = { "Train Artisan (Theramore / Annora in Uldaman)", "Träna Artisan (Theramore / Annora i Uldaman)" } },
  { level = 50, skill = 260, note = { "Keep pace towards 300", "Håll takten mot 300" } },
  { level = 58, skill = 300, note = { "300 needed for Manaflare", "300 krävs för Manaflare" } },
}
