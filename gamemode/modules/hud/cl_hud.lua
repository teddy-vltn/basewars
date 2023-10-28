-- Définissez d'abord les polices que vous allez utiliser
surface.CreateFont("HUDFont", {
    font = "Tahoma",
    size = 24,
    weight = 500,
    antialias = true,
    shadow = false,
})

local function DrawTextWithShadow(text, font, x, y, color, shadowColor, offsetX, offsetY)
    draw.SimpleText(text, font, x + offsetX, y + offsetY, shadowColor)
    draw.SimpleText(text, font, x, y, color)
end

-- Puis, dessinez le HUD
local function DrawHUD()
    local client = LocalPlayer()
    if not IsValid(client) then return end

    local health = client:Health()
    local armor = client:Armor()

    local screenW = ScrW()
    local screenH = ScrH()

    local baseX = 10
    local baseY = screenH - 30

    surface.SetFont("HUDFont")

    -- Dessinez la vie
    DrawTextWithShadow("Vie: " .. health, "HUDFont", baseX, baseY, Color(255, 0, 0), Color(0, 0, 0), 1, 1)

    -- Dessinez l'armure (à gauche de la vie)
    local healthTextWidth = surface.GetTextSize("Vie: " .. health)
    DrawTextWithShadow("Armure: " .. armor, "HUDFont", baseX + healthTextWidth + 20, baseY, Color(0, 0, 255), Color(0, 0, 0), 1, 1)

    local armorTextWidth = surface.GetTextSize("Armure: " .. armor)
    local money = client:GetMoney()

    -- Dessinez l'argent (à gauche de l'armure)
    DrawTextWithShadow("Argent: " .. money, "HUDFont", baseX + healthTextWidth + armorTextWidth + 30, baseY, Color(0, 255, 0), Color(0, 0, 0), 1, 1)

end

-- Enfin, associez votre dessin au HUD
hook.Add("HUDPaint", "DrawCustomHUD", DrawHUD)

-- Cachez le HUD par défaut de Garry's Mod pour la vie et l'armure
hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)
    if name == "CHudHealth" or name == "CHudBattery" then
        return false
    end
end)
