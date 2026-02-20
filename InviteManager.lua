-- ==========================================================
-- ADDON: InviteManager (ex-Grupinho)
-- VERSÃO: 1.0
-- AUTOR: Bannion & ThePeregris(c)
-- COMPATIBILIDADE: Turtle WoW / Vanilla 1.12.1
-- PROPÓSITO: Dissolver completamente e reagrupar
-- ==========================================================

if not InviteManager_Config then InviteManager_Config = {} end
if InviteManager_Config.useYell == nil then InviteManager_Config.useYell = true end
if not InviteManager_Config.recallTime then InviteManager_Config.recallTime = 47 end

local readyList = {}
local inviteQueue = {}
local kickQueue = {}

local run = false
local clk = nil
local stp = {}

local inviteTimer = 0
local kickTimer = 0

-- ==========================================================
-- MASS KICK PREPARADO (REAL)
-- ==========================================================
local function PrepareMassKick()
    kickQueue = {}

    if GetNumRaidMembers() > 0 then
        for i = 1, 40 do
            local n = GetRaidRosterInfo(i)
            if n and n ~= UnitName("player") then
                table.insert(kickQueue, n)
            end
        end
    else
        for i = 1, 4 do
            local n = UnitName("party"..i)
            if n then table.insert(kickQueue, n) end
        end
    end
end

-- ==========================================================
-- JANELA PRINCIPAL
-- ==========================================================
local f = CreateFrame("Frame", "InviteManagerFrame", UIParent)
f:SetWidth(200); f:SetHeight(520)
f:SetPoint("CENTER", 0, 0)
f:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", function() f:StartMoving() end)
f:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)
f:Show()

local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOP", 0, -15)
title:SetText("InviteManager")

local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", -2, -2)
close:SetScript("OnClick", function() f:Hide() end)

-- ==========================================================
-- INPUT DE NOMES
-- ==========================================================
local eb = CreateFrame("EditBox", "InviteManagerInput", f, "InputBoxTemplate")
eb:SetWidth(160); eb:SetHeight(30)
eb:SetPoint("TOP", 0, -45)
eb:SetAutoFocus(false)

-- Capturar grupo atual
local bCap = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
bCap:SetWidth(80); bCap:SetHeight(22)
bCap:SetPoint("TOPLEFT", 15, -85)
bCap:SetText("Capturar")
bCap:SetScript("OnClick", function()
    local s = ""
    if GetNumRaidMembers() > 0 then
        for i=1,40 do
            local n = GetRaidRosterInfo(i)
            if n and n ~= UnitName("player") then s = s .. n .. " " end
        end
    else
        for i=1,4 do
            local n = UnitName("party"..i)
            if n then s = s .. n .. " " end
        end
    end
    eb:SetText(s)
end)

local bClear = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
bClear:SetWidth(80); bClear:SetHeight(22)
bClear:SetPoint("TOPRIGHT", -15, -85)
bClear:SetText("Limpar")
bClear:SetScript("OnClick", function() eb:SetText("") end)

-- ==========================================================
-- FORMAR GRUPO (COM FILA)
-- ==========================================================
local bForm = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
bForm:SetWidth(170); bForm:SetHeight(30)
bForm:SetPoint("TOP", 0, -125)
bForm:SetText("Formar Grupo")
bForm:SetScript("OnClick", function()
    inviteQueue = {}
    for n in string.gfind(eb:GetText(), "([^%s,;]+)") do
        table.insert(inviteQueue, n)
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00InviteManager:|r Enviando convites...")
end)

-- ==========================================================
-- READY CHECK
-- ==========================================================
local bReady = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
bReady:SetWidth(170); bReady:SetHeight(30)
bReady:SetPoint("TOP", 0, -165)
bReady:SetText("Todos Prontos?")
bReady:SetScript("OnClick", function()
    readyList = {}
    local chan = (GetNumRaidMembers() > 0) and "RAID" or "PARTY"
    SendChatMessage("READY CHECK: usem /train", chan)
end)

-- ==========================================================
-- INICIAR PROTOCOLO (DISSOLVE REAL)
-- ==========================================================
local bProto = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
bProto:SetWidth(170); bProto:SetHeight(30)
bProto:SetPoint("TOP", 0, -205)
bProto:SetText("Iniciar Protocolo")
bProto:SetScript("OnClick", function()
    PrepareMassKick()
    inviteQueue = {}
    readyList = {}
    run = true
    clk = 0
    stp = {}
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000InviteManager:|r Protocolo iniciado.")
end)

-- ==========================================================
-- SLIDER
-- ==========================================================
local sText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
sText:SetPoint("TOP", 0, -245)

local slider = CreateFrame("Slider", "InviteManagerSlider", f, "OptionsSliderTemplate")
slider:SetPoint("TOP", 0, -265)
slider:SetWidth(160)
slider:SetMinMaxValues(30, 55)
slider:SetValueStep(1)
slider:SetScript("OnValueChanged", function()
    local v = slider:GetValue()
    InviteManager_Config.recallTime = v
    sText:SetText("Reconvite em: "..v.."s")
end)

-- ==========================================================
-- CHECKBOX YELL
-- ==========================================================
local cb = CreateFrame("CheckButton", "InviteManagerCheckYell", f, "UICheckButtonTemplate")
cb:SetPoint("TOPLEFT", 20, -310)
getglobal(cb:GetName().."Text"):SetText("Contagem Gritada")
cb:SetScript("OnClick", function()
    InviteManager_Config.useYell = InviteManagerCheckYell:GetChecked()
end)

-- ==========================================================
-- LOOP CENTRAL
-- ==========================================================
f:SetScript("OnUpdate", function()
    -- Kick queue (REAL dissolve)
    if table.getn(kickQueue) > 0 then
        kickTimer = kickTimer + arg1
        if kickTimer >= 0.15 then
            UninviteByName(table.remove(kickQueue, 1))
            kickTimer = 0
        end
        if table.getn(kickQueue) == 0 then LeaveParty() end
    end

    -- Invite queue
    if table.getn(inviteQueue) > 0 then
        inviteTimer = inviteTimer + arg1
        if inviteTimer >= 0.2 then
            InviteByName(table.remove(inviteQueue, 1))
            inviteTimer = 0
        end
    end

    -- Timer do protocolo
    if run and clk then
        clk = clk + arg1
        local t = InviteManager_Config.recallTime
        local chan = InviteManager_Config.useYell and "YELL"
            or ((GetNumRaidMembers() > 0) and "RAID" or "PARTY")

        if clk >= t and not stp.fill then
            for n in string.gfind(eb:GetText(), "([^%s,;]+)") do
                table.insert(inviteQueue, n)
            end
            SendChatMessage("Reconvidando em 6...", chan)
            stp.fill = true
        end

        for i=1,5 do
            if clk >= (t+i) and not stp[i] then
                SendChatMessage((6-i).."...", chan)
                stp[i] = true
            end
        end

        if clk >= (t+6) then
            SendChatMessage("AVANTE!", chan)
            run = false
            clk = nil
        end
    end
end)

-- ==========================================================
-- EVENTOS
-- ==========================================================
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
f:SetScript("OnEvent", function()
    if event == "VARIABLES_LOADED" then
        slider:SetValue(InviteManager_Config.recallTime)
        InviteManagerCheckYell:SetChecked(InviteManager_Config.useYell)
    elseif event == "CHAT_MSG_TEXT_EMOTE" then
        if arg1 and (string.find(arg1, "train") or string.find(arg1, "comboio")) then
            readyList[arg2] = true
        end
    end
end)

-- ==========================================================
-- SLASH COMMAND
-- ==========================================================
SLASH_INVITEMANAGER1 = "/imap"
SlashCmdList["INVITEMANAGER"] = function()
    if f:IsShown() then f:Hide() else f:Show() end
end
