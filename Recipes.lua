-- MagePlan: recipe check. When you open a profession window, it saves the crafted
-- gear you know with its real required level, so the plan can be checked against
-- the live game. /mp recipes prints what's saved.
local _, ns = ...

local KEYWORDS = {
  "Silky", "Frothing", "Netherfroth", "Pearly", "Golden", "Manaflare", "Archmage", "Arcanist",
  "Staff", "Wand", "Orb", "Frozen Heart", "Rod",
}

local function Relevant(name)
  if type(name) ~= "string" then return false end
  for _, k in ipairs(KEYWORDS) do
    if name:find(k, 1, true) then return true end
  end
  return false
end

local function Store(prof, name, link)
  if type(prof) ~= "string" or prof == "" or prof == "UNKNOWN" or not link then return end
  ns.db.recipes = ns.db.recipes or {}
  ns.db.recipes[prof] = ns.db.recipes[prof] or {}
  local ok, _, _, _, ilvl, minLevel = pcall(ns.ItemInfo, link)
  ns.db.recipes[prof][name] = {
    link = link,
    level = ok and minLevel or nil,
    ilvl = ok and ilvl or nil,
  }
end

local function ScanModern()
  if not (C_TradeSkillUI and C_TradeSkillUI.GetAllRecipeIDs and C_TradeSkillUI.GetRecipeInfo) then return end
  local prof
  if C_TradeSkillUI.GetTradeSkillLine then
    local a, b = C_TradeSkillUI.GetTradeSkillLine()
    prof = type(a) == "string" and a or b
  end
  for _, id in ipairs(C_TradeSkillUI.GetAllRecipeIDs() or {}) do
    local info = C_TradeSkillUI.GetRecipeInfo(id)
    if info and info.learned and Relevant(info.name) and C_TradeSkillUI.GetRecipeItemLink then
      Store(prof, info.name, C_TradeSkillUI.GetRecipeItemLink(id))
    end
  end
end

local function ScanTradeSkill()
  if not (GetNumTradeSkills and GetTradeSkillInfo and GetTradeSkillLine and GetTradeSkillItemLink) then return end
  local prof = GetTradeSkillLine()
  for i = 1, (GetNumTradeSkills() or 0) do
    local name, kind = GetTradeSkillInfo(i)
    if kind ~= "header" and Relevant(name) then Store(prof, name, GetTradeSkillItemLink(i)) end
  end
end

local function ScanCraft()
  if not (GetNumCrafts and GetCraftInfo and GetCraftDisplaySkillLine and GetCraftItemLink) then return end
  local prof = GetCraftDisplaySkillLine()
  for i = 1, (GetNumCrafts() or 0) do
    local name, _, kind = GetCraftInfo(i)
    if kind ~= "header" and Relevant(name) then Store(prof, name, GetCraftItemLink(i)) end
  end
end

local function Scan()
  pcall(ScanModern)
  pcall(ScanTradeSkill)
  pcall(ScanCraft)
end

local function PrintRecipes()
  local any = false
  for prof, list in pairs(ns.db.recipes or {}) do
    local names = {}
    for name in pairs(list) do table.insert(names, name) end
    table.sort(names)
    if #names > 0 then
      any = true
      ns.Print("|cffffd100" .. ns.T("REC_HDR", prof) .. "|r")
      for _, name in ipairs(names) do
        local r = list[name]
        -- Look the item up again: it may not have been loaded when it was saved.
        local ok, _, _, _, ilvl, minLevel = pcall(ns.ItemInfo, r.link)
        local level = (ok and minLevel) or r.level
        ns.Print("  " .. ns.T("REC_LINE", r.link or name, level and tostring(level) or "?", (ok and ilvl) or r.ilvl or "?"))
      end
    end
  end
  if not any then ns.Print(ns.T("REC_NONE")) end
end

ns.RegisterModule(function()
  local ev = CreateFrame("Frame")
  for _, e in ipairs({ "TRADE_SKILL_SHOW", "TRADE_SKILL_UPDATE", "TRADE_SKILL_LIST_UPDATE", "CRAFT_SHOW", "CRAFT_UPDATE" }) do
    pcall(ev.RegisterEvent, ev, e)
  end
  ev:SetScript("OnEvent", function() ns.Debounce("recipes", 0.5, Scan) end)
end)

ns.RegisterCommand("recipes", true, PrintRecipes)
