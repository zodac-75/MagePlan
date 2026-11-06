-- MagePlan: selectable talent plans. Frost leveling comes from Data.lua.
-- Every plan is checked against the live tree (build 1.60.1.70755): a talent is
-- only taken once its row has enough points spent in that tree.
local _, ns = ...

-- Builds a level -> "Talent n/max" table from steps of { name, maxRank, count }.
local function Build(startLevel, steps)
  local t, lvl, have = {}, startLevel, {}
  for _, s in ipairs(steps) do
    local name, max, n = s[1], s[2], s[3] or s[2]
    for _ = 1, n do
      have[name] = (have[name] or 0) + 1
      t[lvl] = string.format("%s %d/%d", name, have[name], max)
      lvl = lvl + 1
    end
  end
  return t
end

ns.PLANS = {
  frost = { talents = ns.talents },

  -- Fire leveling. 10-37 follows the most common community order; 38-60 is adapted
  -- for launch (Precision has 3 ranks, Piercing Ice is gone, Incineration was buffed).
  fire = { talents = Build(10, {
    { "Accelerant", 5 }, { "Ignite", 5 }, { "Flame Throwing", 2, 1 }, { "Burning Soul", 3 },
    { "Pyroblast", 1 }, { "Improved Scorch", 3 }, { "Heating Up", 1 }, { "Master of Elements", 3 },
    { "Critical Mass", 3 }, { "Fire Power", 3 }, { "Precision", 3 }, { "Incineration", 5 },
    { "Flame Throwing", 2, 1 }, { "Improved Fire Blast", 2 }, { "Blast Wave", 1 }, { "Impact", 3 },
    { "Combustion", 1 }, { "Improved Flamestrike", 3 }, { "Improved Fire Ward", 2 },
    { "Wand Specialization", 2 },
  }) },

  -- Arcane raid, 32/16/3 (arc-fire). The split and the Fire picks (Heating Up,
  -- Improved Fire Blast) match MythicSim's reference build; the exact Arcane picks
  -- aren't published, so this is filled from the live tree.
  arcane = { talents = Build(10, {
    { "Improved Channeling", 5 }, { "Arcane Concentration", 5 }, { "Arcane Subtlety", 2 },
    { "Missile Barrage", 2 }, { "Arcane Impact", 3 }, { "Arcane Blast", 1 }, { "Arcane Meditation", 3 },
    { "Arcane Wrath", 1 }, { "Arcane Mind", 5 }, { "Presence of Mind", 1 }, { "Arcane Instability", 3 },
    { "Arcane Power", 1 },
    { "Incineration", 5 }, { "Ignite", 5 }, { "Improved Fire Blast", 2 }, { "Burning Soul", 3 },
    { "Heating Up", 1 },
    { "Precision", 3 },
  }) },
}
ns.PLAN_ORDER = { "frost", "fire", "arcane" }

function ns.PlanKey()
  local k = ns.db and ns.db.plan
  if k and ns.PLANS[k] then return k end
  return "frost"
end

function ns.ApplyPlan()
  ns.talents = ns.PLANS[ns.PlanKey()].talents
end

function ns.CyclePlan()
  local cur, nextKey = ns.PlanKey(), ns.PLAN_ORDER[1]
  for i, k in ipairs(ns.PLAN_ORDER) do
    if k == cur then nextKey = ns.PLAN_ORDER[(i % #ns.PLAN_ORDER) + 1] end
  end
  ns.db.plan = nextKey
  ns.ApplyPlan()
  ns.Print(ns.T("PLAN_SET", ns.T("PLAN_" .. nextKey)))
  ns.RefreshMain()
  if ns.RefreshTalentGlow then ns.RefreshTalentGlow() end
  if ns.RefreshMenu then ns.RefreshMenu() end
end

ns.RegisterModule(function() ns.ApplyPlan() end)
ns.RegisterCommand("plan", true, function() ns.CyclePlan() end)
