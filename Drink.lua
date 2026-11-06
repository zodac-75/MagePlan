-- MagePlan: drink reminder. Out of combat with low mana and not drinking: show a nudge.
local _, ns = ...

local f, txt
local DRINK_BUFFS = { ["Drink"] = true, ["Food & Drink"] = true, ["Refreshment"] = true }

local function Check()
  if not f then return end
  if ns.db.drinkOff or UnitAffectingCombat("player") or (UnitIsDeadOrGhost and UnitIsDeadOrGhost("player")) then
    f:Hide()
    return
  end
  local max = UnitPowerMax and UnitPowerMax("player", 0) or 0
  if not max or max <= 0 then f:Hide() return end
  local pct = (UnitPower("player", 0) or 0) / max * 100
  local drinking = ns.ForEachAura("player", "HELPFUL", function(n) return DRINK_BUFFS[n] end)
  if pct < (ns.db.drinkPct or 40) and not drinking then
    txt:SetText("|cff66ccff" .. ns.T("DRINK", math.floor(pct)) .. "|r")
    f:Show()
  else
    f:Hide()
  end
end

ns.RegisterModule(function()
  f = CreateFrame("Frame", "MagePlanDrinkFrame", UIParent)
  f:SetSize(300, 24)
  f:SetPoint("TOP", _G.MagePlanShatterFrame or UIParent, _G.MagePlanShatterFrame and "BOTTOM" or "CENTER", 0, _G.MagePlanShatterFrame and -6 or -210)
  txt = f:CreateFontString(nil, "OVERLAY")
  txt:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
  txt:SetPoint("CENTER")
  f:Hide()

  local ev = CreateFrame("Frame")
  ev:RegisterEvent("PLAYER_REGEN_ENABLED")
  ev:RegisterEvent("PLAYER_REGEN_DISABLED")
  ev:RegisterEvent("UNIT_POWER_UPDATE")
  ev:RegisterEvent("UNIT_AURA")
  ev:RegisterEvent("PLAYER_ENTERING_WORLD")
  ev:SetScript("OnEvent", function(_, event, unit)
    if (event == "UNIT_POWER_UPDATE" or event == "UNIT_AURA") and unit ~= "player" then return end
    ns.Debounce("drink", 0.2, Check)
  end)
end)

ns.RegisterCommand("drink", true, function()
  ns.db.drinkOff = not ns.db.drinkOff
  ns.Print(ns.db.drinkOff and ns.T("DRINK_OFF") or ns.T("DRINK_ON"))
  pcall(Check)
end)

ns.RegisterCommand("drinkat", true, function(rest)
  local n = tonumber((rest or ""):match("(%d+)"))
  if n and n > 0 and n < 100 then
    ns.db.drinkPct = n
    ns.Print(ns.T("DRINK_SET", n))
    pcall(Check)
  end
end)
