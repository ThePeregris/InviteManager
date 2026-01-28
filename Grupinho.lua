-- ==========================================================
-- ADDON: GRUPINHO (Versão Final - Commander Edition)
-- DESENVOLVIDO PARA: Turtle WoW (Client 1.12.1)
-- ==========================================================

-- 1. CONFIGURAÇÕES E MEMÓRIA
if not Grupinho_Config then Grupinho_Config = {} end
if Grupinho_Config.useYell == nil then Grupinho_Config.useYell = true end
if not Grupinho_Config.recallTime then Grupinho_Config.recallTime = 47 end

local readyList = {} -- Controla quem deu OK no Ready Check

local function SaveConfig()
    local point, _, relPoint, x, y = GrupinhoFrame:GetPoint()
    Grupinho_Config.point, Grupinho_Config.relPoint = point, relPoint
    Grupinho_Config.x, Grupinho_Config.y = x, y
end

-- 2. JANELA PRINCIPAL
local f = CreateFrame("Frame", "GrupinhoFrame", UIParent)
f:SetWidth(200); f:SetHeight(480) 
f:SetPoint("CENTER", 0, 0)
f:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", function() f:StartMoving() end)
f:SetScript("OnDragStop", function() f:StopMovingOrSizing(); SaveConfig() end)
f:Show() -- Inicia aberto

-- Título e Botão Fechar
local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
t:SetPoint("TOP", 0, -15); t:SetText("Addon Grupinho")
local exit = CreateFrame("Button", nil, f, "UIPanelCloseButton")
exit:SetPoint("TOPRIGHT", -2, -2); exit:SetScript("OnClick", function() f:Hide() end)

-- 3. INTERFACE DE CONTROLE
local cb = CreateFrame("CheckButton", "GrupinhoCheckYell", f, "UICheckButtonTemplate")
cb:SetPoint("TOPLEFT", 20, -35)
getglobal(cb:GetName().."Text"):SetText("Usar Grito (/y)")
cb:SetScript("OnClick", function() Grupinho_Config.useYell = cb:GetChecked() end)

-- Slider de Tempo
local sText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
sText:SetPoint("TOP", 0, -85)
local slider = CreateFrame("Slider", "GrupinhoSlider", f, "OptionsSliderTemplate")
slider:SetPoint("TOP", 0, -105); slider:SetWidth(160); slider:SetMinMaxValues(30, 55); slider:SetValueStep(1)
slider:SetScript("OnValueChanged", function()
    local v = slider:GetValue(); sText:SetText("Convite em: |cffffffff"..v.."s|r")
    Grupinho_Config.recallTime = v
end)

-- 4. PAINEL LATERAL (STATUS DE PRONTIDÃO)
local side = CreateFrame("Frame", "GrupinhoSide", f)
side:SetWidth(160); side:SetHeight(480); side:SetPoint("LEFT", f, "RIGHT", -5, 0)
side:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
local sTitle = side:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
sTitle:SetPoint("TOP", 0, -15); sTitle:SetText("STATUS DO GRUPO")
local sList = side:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
sList:SetPoint("TOPLEFT", 12, -40); sList:SetJustifyH("LEFT")

local function UpdateStatusUI()
    local d = ""
    local numR = GetNumRaidMembers()
    if numR > 0 then
        for i=1, numR do
            local name = GetRaidRosterInfo(i)
            if name then
                local color = readyList[name] and "|cff00ff00[OK] |r" or "|cffff0000[..] |r"
                d = d .. color .. name .. "\n"
            end
        end
    else
        local myName = UnitName("player")
        local myColor = readyList[myName] and "|cff00ff00[OK] |r" or "|cffff0000[..] |r"
        d = d .. myColor .. myName .. "\n"
        for i=1, GetNumPartyMembers() do
            local name = UnitName("party"..i)
            if name then
                local color = readyList[name] and "|cff00ff00[OK] |r" or "|cffff0000[..] |r"
                d = d .. color .. name .. "\n"
            end
        end
    end
    sList:SetText(d)
end

-- 5. CAIXA DE TEXTO (INPUT DE NOMES)
local eb = CreateFrame("EditBox", "GrupinhoInput", f, "InputBoxTemplate")
eb:SetWidth(160); eb:SetHeight(30); eb:SetPoint("TOP", 0, -145); eb:SetAutoFocus(false)

-- 6. BOTÕES DE AÇÃO
local bG = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
bG:SetWidth(80); bG:SetHeight(22); bG:SetPoint("TOPLEFT", 15, -185); bG:SetText("Capturar")
bG:SetScript("OnClick", function()
    local s = ""
    for i=1, GetNumRaidMembers() do local n = GetRaidRosterInfo(i); if n and n ~= UnitName("player") then s = s .. n .. " " end end
    if s == "" then for i=1, GetNumPartyMembers() do local n = UnitName("party"..i); if n then s = s .. n .. " " end end end
    eb:SetText(s)
end)

local bC = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
bC:SetWidth(80); bC:SetHeight(22); bC:SetPoint("TOPRIGHT", -15, -185); bC:SetText("Limpar")
bC:SetScript("OnClick", function() eb:SetText("") end)

-- Lógica do Refresh Estratégico
local run, clk, stp = false, 0, {}
local bRef = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
bRef:SetWidth(170); bRef:SetHeight(30); bRef:SetPoint("TOP", 0, -220); bRef:SetText("Refresh Estratégico")
bRef:SetScript("OnClick", function() LeaveParty(); run, clk, stp = true, 0, {} end)

f:SetScript("OnUpdate", function()
    if run then
        clk = clk + arg1
        local target = Grupinho_Config.recallTime
        local chan = (not Grupinho_Config.useYell) and (GetNumRaidMembers() > 0 and "RAID" or "PARTY") or "YELL"
        if clk >= (target - 2) and not stp["ding"] then PlaySound("ReadyCheck"); stp["ding"]=true end
        if clk >= target and not stp["inv"] then
            for n in string.gfind(eb:GetText(), "([^%s,;]+)") do InviteByName(n) end
            SendChatMessage("Reconvidando em: 6...", chan); stp["inv"]=true
        end
        for i=1, 5 do if clk >= (target + i) and not stp[i] then SendChatMessage((6-i).."...", chan); stp[i]=true end end
        if clk >= (target + 6) then SendChatMessage("AVANTE!", chan); DoEmote("CHARGE"); run = false end
    end
    UpdateStatusUI()
end)

-- Botões de Ready Check e Formação
local bRC = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
bRC:SetWidth(170); bRC:SetHeight(30); bRC:SetPoint("TOP", 0, -260); bRC:SetText("Pedir Ready Check")
bRC:SetScript("OnClick", function() 
    readyList = {} 
    local chan = GetNumRaidMembers() > 0 and "RAID" or "PARTY"
    SendChatMessage("READY CHECK: Usem /train para confirmar!", chan) 
end)

local bMine = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
bMine:SetWidth(170); bMine:SetHeight(30); bMine:SetPoint("TOP", 0, -295); bMine:SetText("Meu OK (/train)")
bMine:SetScript("OnClick", function() DoEmote("TRAIN") end)

local bForm = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
bForm:SetWidth(170); bForm:SetHeight(30); bForm:SetPoint("TOP", 0, -330); bForm:SetText("Formar Grupo")
bForm:SetScript("OnClick", function()
    local c = 0
    for n in string.gfind(eb:GetText(), "([^%s,;]+)") do InviteByName(n); c = c + 1 end
    if c > 5 then ConvertToRaid() end
end)

-- 7. EVENTOS E CARREGAMENTO
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
f:SetScript("OnEvent", function()
    if event == "VARIABLES_LOADED" then
        if Grupinho_Config.x then f:ClearAllPoints(); f:SetPoint(Grupinho_Config.point, UIParent, Grupinho_Config.relPoint, Grupinho_Config.x, Grupinho_Config.y) end
        slider:SetValue(Grupinho_Config.recallTime)
        cb:SetChecked(Grupinho_Config.useYell)
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Grupinho Carregado! Use /grupinho.|r")
    elseif event == "CHAT_MSG_TEXT_EMOTE" then
        if arg1 and (string.find(arg1, "train") or string.find(arg1, "comboio")) then
            readyList[arg2] = true 
        end
    end
end)

-- 8. COMANDO SLASH
SLASH_GRUPINHO1 = "/grupinho"
SlashCmdList["GRUPINHO"] = function() if GrupinhoFrame:IsShown() then f:Hide() else f:Show() end end