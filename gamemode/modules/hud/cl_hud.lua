-- Définir les polices
surface.CreateFont("HUDFont", {
    font = "Tahoma",
    size = 20,
    weight = 500,
    antialias = true,
    shadow = true,
})

local function DrawHUD()
    local client = LocalPlayer()
    if not IsValid(client) then return end

    local health = client:Health()
    local armor = client:Armor()
    local money = client:GetMoney() or 0
    local level = client:GetLevel() or 0
    local xp = client:GetXP() or 0
    local xpForLevel = client:GetXPForNextLevel() or 100

    local screenW, screenH = ScrW(), ScrH()
    local baseX = 10
    local baseY = screenH - 3
    local spacing = 15

    -- Dessinez le fond
    surface.SetDrawColor(30, 30, 30, 252)
    surface.DrawRect(0, screenH - 30, screenW, 30)

    -- Dessinez la vie
    draw.SimpleText("Vie:", "HUDFont", baseX, baseY, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    baseX = baseX + surface.GetTextSize("Vie: ") + spacing
    draw.SimpleText(health, "HUDFont", baseX, baseY, Color(255, 50, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    baseX = baseX + surface.GetTextSize(health) + spacing

    -- Dessinez l'armure
    draw.SimpleText("Armure:", "HUDFont", baseX, baseY, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    baseX = baseX + surface.GetTextSize("Armure: ") + spacing
    draw.SimpleText(armor, "HUDFont", baseX, baseY, Color(50, 50, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    baseX = baseX + surface.GetTextSize(armor) + spacing

    -- Dessinez l'argent
    draw.SimpleText("Argent:", "HUDFont", baseX, baseY, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    baseX = baseX + surface.GetTextSize("Argent: $") + spacing
    draw.SimpleText(money, "HUDFont", baseX, baseY, Color(50, 255, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    baseX = baseX + surface.GetTextSize(money) + spacing

    -- Dessinez le niveau et l'XP
    draw.SimpleText("Niveau:", "HUDFont", baseX, baseY, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    baseX = baseX + surface.GetTextSize("Niveau: ") + spacing
    draw.SimpleText(level, "HUDFont", baseX, baseY, Color(255, 255, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    baseX = baseX + surface.GetTextSize(level) + spacing

    draw.SimpleText("XP:", "HUDFont", baseX, baseY, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    baseX = baseX + surface.GetTextSize("XP: ") + spacing
    draw.SimpleText(xp .. "/" .. xpForLevel, "HUDFont", baseX, baseY, Color(255, 255, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
end

hook.Add("HUDPaint", "DrawCustomHUD", DrawHUD)

hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)
    if name == "CHudHealth" or name == "CHudBattery" then
        return false
    end
end)
