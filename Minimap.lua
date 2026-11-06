-- MagePlan: minimap-knapp med meny.
-- Vänsterklick: planfönstret. Högerklick: meny. Dra: flytta runt minimappen.
local _, ns = ...

local btn, menu
local rows = {}
local hints = {}

local function Run(cmd)
  local fn = ns.commands[cmd]
  if fn then
    local ok, err = pcall(fn, "")
    if not ok then ns.Print(ns.T("ERROR", tostring(err))) end
  end
end

local function Val(s) return "|cff69ccf0" .. s .. "|r" end

local ITEMS = {
  { key = "MM_PLAN", check = function() return ns.mainFrame and ns.mainFrame:IsShown() end, func = function() ns.ToggleMain() end },
  { key = "MM_CRAFT", check = function() return ns.craftWindow and ns.craftWindow:IsShown() end, func = function() Run("craft") end },
  { key = "MM_SHATTER", check = function() return not ns.db.shatterOff end, func = function() Run("shatter") end },
  { key = "MM_MOVE", check = function() return ns.db.shatterUnlocked end, func = function() Run("move") end },
  { key = "MM_TT", check = function() return not ns.db.tooltipOff end, func = function() Run("tooltip") end },
  { key = "MM_UPGRADE", check = function() return not ns.db.upgradeOff end, func = function() Run("upgrade") end },
  { key = "MM_POLY", check = function() return not ns.db.polyOff end, func = function() Run("poly") end },
  { key = "MM_XP", check = function() return not ns.db.xpOff end, func = function() Run("xp") end },
  { key = "MM_ZONE", check = function() return not ns.db.zoneTipsOff end, func = function() Run("zonetips") end },
  { key = "MM_QUEST", check = function() return not ns.db.questOff end, func = function() Run("quest") end },
  { key = "MM_DRINK", check = function() return not ns.db.drinkOff end, func = function() Run("drink") end },
  { key = "MM_LOCK", check = function() return ns.db.locked end, func = function() Run("lock") end },
  { separator = true },
  { textFn = function() return ns.T("MM_PLANSEL") .. " " .. Val(ns.T("PLAN_" .. ns.PlanKey())) end, func = function() ns.CyclePlan() end },
  { textFn = function() return ns.T("MM_THEME") .. " " .. Val(ns.T("THEME_" .. ns.CurrentTheme().key)) end, func = function() ns.CycleTheme() end },
  { textFn = function() return ns.T("MM_FONT") .. " " .. Val(ns.T("FONT_" .. ns.CurrentFont().key)) end, func = function() ns.CycleFontSize() end },
  { textFn = function() return ns.T("MM_LANG") .. " " .. Val(ns.Lang() == "svSE" and "Svenska" or "English") end, func = function() ns.CycleLang() end },
  { hint = "MM_HINT" },
  { separator = true },
  { key = "MM_RANKS", func = function() Run("ranks") end, close = true },
  { key = "MM_DE", func = function() Run("de") end, close = true },
  { key = "MM_ALL", func = function() Run("all") end, close = true },
  { key = "MM_RECIPES", func = function() Run("recipes") end, close = true },
  { key = "MM_RESET", func = function() Run("reset") end, close = true },
  { separator = true },
  { key = "MM_HIDE", func = function() Run("minimap") end, close = true },
}

---------------------------------------------------------------------------
-- Knappen
---------------------------------------------------------------------------
local function UpdatePosition()
  local a = math.rad(ns.db.minimapAngle or 225)
  local r = (Minimap:GetWidth() / 2) + 5
  btn:ClearAllPoints()
  btn:SetPoint("CENTER", Minimap, "CENTER", math.cos(a) * r, math.sin(a) * r)
end

local atan2 = math.atan2 or function(y, x) return math.atan(y, x) end

local function OnDragUpdate()
  local mx, my = Minimap:GetCenter()
  local px, py = GetCursorPosition()
  local s = Minimap:GetEffectiveScale()
  px, py = px / s, py / s
  ns.db.minimapAngle = math.deg(atan2(py - my, px - mx))
  UpdatePosition()
end

---------------------------------------------------------------------------
-- Menyn
---------------------------------------------------------------------------
local function RefreshMenu()
  for _, row in ipairs(rows) do
    if row.item.check then
      local ok, on = pcall(row.item.check)
      row.checkTex:SetShown(ok and on and true or false)
    end
    if row.item.textFn then
      local ok, t = pcall(row.item.textFn)
      if ok and t then row.label:SetText(t) end
    elseif row.item.key then
      row.label:SetText(ns.T(row.item.key))
    end
  end
  for _, h in ipairs(hints) do h:SetText(ns.T(h.key)) end
end
ns.RefreshMenu = function() if menu and menu:IsShown() then RefreshMenu() end end

local function CreateMenu()
  menu = CreateFrame("Frame", "MagePlanMenu", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
  menu:SetFrameStrata("DIALOG")
  menu:SetClampedToScreen(true)
  menu:EnableMouse(true)
  table.insert(ns.themedFrames, menu)
  ns.ApplyTheme(menu)
  table.insert(UISpecialFrames, "MagePlanMenu") -- Esc stänger menyn

  local title = menu:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  title:SetPoint("TOPLEFT", 10, -8)
  title:SetText("|cff69ccf0MagePlan|r")

  local width, y = 240, -26
  for _, item in ipairs(ITEMS) do
    if item.separator then
      local line = menu:CreateTexture(nil, "ARTWORK")
      line:SetColorTexture(1, 1, 1, 0.15)
      line:SetPoint("TOPLEFT", 10, y - 4)
      line:SetSize(width - 20, 1)
      y = y - 9
    elseif item.hint then
      local h = menu:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
      h:SetPoint("TOPLEFT", 28, y - 2)
      h:SetWidth(width - 36)
      h:SetJustifyH("LEFT")
      h.key = item.hint
      h:SetText(ns.T(item.hint))
      table.insert(hints, h)
      y = y - 16
    else
      local row = CreateFrame("Button", nil, menu)
      row:SetSize(width - 12, 18)
      row:SetPoint("TOPLEFT", 6, y)
      row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")

      local check = row:CreateTexture(nil, "ARTWORK")
      check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
      check:SetSize(16, 16)
      check:SetPoint("LEFT", 2, 0)
      check:Hide()
      row.checkTex = check

      local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      label:SetPoint("LEFT", 22, 0)
      label:SetText(item.key and ns.T(item.key) or "")
      row.label = label

      row.item = item
      row:SetScript("OnClick", function()
        local ok, err = pcall(item.func)
        if not ok then ns.Print(ns.T("ERROR", tostring(err))) end
        if item.close then menu:Hide() else RefreshMenu() end
      end)
      table.insert(rows, row)
      y = y - 18
    end
  end
  menu:SetSize(width, -y + 8)

  -- Stäng när musen varit utanför menyn och knappen en stund.
  local away = 0
  menu:SetScript("OnShow", function() away = 0; RefreshMenu() end)
  menu:SetScript("OnUpdate", function(self, elapsed)
    if self:IsMouseOver() or btn:IsMouseOver() then
      away = 0
    else
      away = away + elapsed
      if away > 1.5 then self:Hide() end
    end
  end)
  menu:Hide()
end

local function ToggleMenu()
  if menu:IsShown() then menu:Hide(); return end
  GameTooltip:Hide()
  menu:ClearAllPoints()
  menu:SetPoint("TOPRIGHT", btn, "BOTTOMLEFT", 8, 8)
  menu:Show()
end

local function CreateButton()
  btn = CreateFrame("Button", "MagePlanMinimapButton", Minimap)
  btn:SetSize(31, 31)
  btn:SetFrameStrata("MEDIUM")
  btn:SetFrameLevel(8)
  btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  btn:RegisterForDrag("LeftButton")
  btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

  local bg = btn:CreateTexture(nil, "BACKGROUND")
  bg:SetSize(20, 20)
  bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
  bg:SetPoint("TOPLEFT", 7, -5)

  local icon = btn:CreateTexture(nil, "ARTWORK")
  icon:SetSize(17, 17)
  icon:SetTexture("Interface\\Icons\\Spell_Frost_FrostBolt02")
  icon:SetPoint("TOPLEFT", 7, -6)

  local border = btn:CreateTexture(nil, "OVERLAY")
  border:SetSize(53, 53)
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  border:SetPoint("TOPLEFT")

  btn:SetScript("OnClick", function(_, mouse)
    if mouse == "RightButton" then
      ToggleMenu()
    else
      ns.ToggleMain()
    end
  end)
  btn:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", OnDragUpdate)
  end)
  btn:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
  end)
  btn:SetScript("OnEnter", function(self)
    if menu:IsShown() then return end
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("|cff69ccf0MagePlan|r")
    GameTooltip:AddLine(ns.T("MM_TIP_LEFT"), 1, 1, 1)
    GameTooltip:AddLine(ns.T("MM_TIP_RIGHT"), 1, 1, 1)
    GameTooltip:AddLine(ns.T("MM_TIP_DRAG"), 0.7, 0.7, 0.7)
    GameTooltip:Show()
  end)
  btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

  UpdatePosition()
  if ns.db.minimapHidden then btn:Hide() end
end

ns.RegisterModule(function()
  CreateButton()
  CreateMenu()
end)

ns.RegisterCommand("minimap", true, function()
  ns.db.minimapHidden = not ns.db.minimapHidden
  if ns.db.minimapHidden then
    btn:Hide()
    ns.Print(ns.T("MM_HIDDEN"))
  else
    btn:Show()
    ns.Print(ns.T("MM_SHOWN"))
  end
end)
