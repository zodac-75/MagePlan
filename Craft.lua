-- MagePlan: crafting-assistent. Visar nästa steg i Tailoring och Enchanting,
-- vad du har och saknar i väskor och bank, och hur mycket cloth det motsvarar.
local _, ns = ...

local win

local function StepFor(route, skill)
  for i, s in ipairs(route) do
    if skill < s.to then return s, route[i + 1] end
  end
end

local function Remaining(s, skill)
  if s.batch then return s.crafts end
  local span = s.to - s.from
  if span <= 0 then return s.crafts end
  local frac = (s.to - math.max(skill, s.from)) / span
  return math.max(1, math.ceil(s.crafts * frac))
end

-- Behöver nuvarande eller nästa Enchanting-steg detta item?
function ns.EnchantNeedsMat(itemID)
  local skill = ns.GetProfSkill("Enchanting")
  if not skill or skill >= 300 then return false end
  local s, nxt = StepFor(ns.ROUTES.Enchanting, skill)
  for _, step in ipairs({ s, nxt }) do
    if step then
      for _, m in ipairs(step.mats) do
        if m[1] == itemID then return true end
      end
    end
  end
  return false
end

local function MatLine(m, crafts)
  local id, per, fallback = m[1], m[2], m[3]
  local need = per * crafts
  local have = ns.ItemCount(id)
  local color = have >= need and "|cff60ff60" or "|cffff6060"
  local line = string.format("    %s%s %d/%d|r", color, ns.ItemName(id, fallback), have, need)
  local bolt = ns.BOLTS[id]
  if bolt and have < need then
    local rawNeed = (need - have) * bolt.ratio
    local rawHave = ns.ItemCount(bolt.raw)
    local c = rawHave >= rawNeed and "|cff60ff60" or "|cffaaaaaa"
    line = line .. " " .. c .. ns.T("CR_EQUALS", rawNeed, bolt.name, rawHave) .. "|r"
  end
  return line
end

local function ProfSection(prof, lines)
  local skill, maxRank = ns.GetProfSkill(prof)
  table.insert(lines, "|cffffffff" .. prof .. "|r")
  if not skill then
    table.insert(lines, "  |cff888888" .. ns.T("CR_NOT_LEARNED") .. "|r")
    return
  end
  if skill >= 300 then
    table.insert(lines, "  |cff60ff60" .. ns.T("CR_DONE") .. "|r")
    return
  end
  local header = "  " .. (maxRank and maxRank > 0 and ns.T("CR_SKILL", skill, maxRank) or ("Skill " .. skill))
  if maxRank and maxRank < 300 and skill >= maxRank - 25 then
    local lvl = ns.RANK_LEVEL[maxRank]
    header = header .. "  |cffff9900" .. (lvl and ns.T("CR_TRAIN_LVL", lvl) or ns.T("CR_TRAIN")) .. "|r"
  end
  table.insert(lines, header)

  local s, nxt = StepFor(ns.ROUTES[prof], skill)
  if not s then return end
  local crafts = Remaining(s, skill)
  local what = s.batch and ns.T("CR_BATCH", crafts) or ns.T("CR_LEFT", crafts)
  table.insert(lines, string.format("  |cffffd100%d-%d:|r %s, %s", s.from, s.to, s.craft, what))
  for _, m in ipairs(s.mats) do table.insert(lines, MatLine(m, crafts)) end
  if s.note then table.insert(lines, "    |cffaaaaaa" .. ns.Tx(s.note) .. "|r") end
  if nxt then
    table.insert(lines, "  |cff888888" .. ns.T("CR_THEN", nxt.from, nxt.to, nxt.craft) .. "|r")
  end
end

local function Build()
  local lines = { "|cff69ccf0" .. ns.T("CR_TITLE") .. "|r" }
  ProfSection("Tailoring", lines)
  ProfSection("Enchanting", lines)

  local cloth = {}
  for _, c in ipairs(ns.CLOTH) do
    local n = ns.ItemCount(c[1])
    if n > 0 then table.insert(cloth, c[2] .. " " .. n) end
  end
  table.insert(lines, "|cffffffff" .. ns.T("CR_CLOTH") .. "|r " .. (#cloth > 0 and table.concat(cloth, ", ") or ns.T("CR_NONE")))
  table.insert(lines, "|cff888888" .. ns.T("CR_BANK") .. "|r")
  return table.concat(lines, "\n")
end

function ns.RefreshCraft()
  if win and win:IsShown() then win:SetContent(Build()) end
end

ns.RegisterModule(function()
  win = ns.MakeWindow("MagePlanCraftFrame", 380, "craftPos", { "RIGHT", "RIGHT", -400, 120 })
  win.closeButton:SetScript("OnClick", function()
    win:Hide()
    ns.db.craftShown = false
  end)
  ns.craftWindow = win
  ns.windows = ns.windows or {}
  table.insert(ns.windows, win)
  if ns.db.craftShown then win:Show() else win:Hide() end

  local ev = CreateFrame("Frame")
  ev:RegisterEvent("BAG_UPDATE")
  ev:RegisterEvent("BANKFRAME_OPENED")
  ev:RegisterEvent("SKILL_LINES_CHANGED")
  ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
  ev:SetScript("OnEvent", function()
    ns.Debounce("craft", 1, ns.RefreshCraft)
  end)
  ns.RefreshCraft()
end)

ns.RegisterCommand("craft", true, function()
  if win:IsShown() then
    win:Hide(); ns.db.craftShown = false
  else
    win:Show(); ns.db.craftShown = true; ns.RefreshCraft()
  end
end)
