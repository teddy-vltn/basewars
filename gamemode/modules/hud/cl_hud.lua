-- Définir les polices
surface.CreateFont("HUDFont", {
    font = "Tahoma",
    size = 20,
    weight = 500,
    antialias = true,
    shadow = true,
})

local prevMoney = 0
local moneyNotifications = {}

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

    local moneyDifference = client:GetMoney() - prevMoney
    if moneyDifference ~= 0 then
        table.insert(moneyNotifications, {
            value = moneyDifference,
            positive = moneyDifference > 0, -- Stocke si c'était un gain ou une perte
            x = baseX + surface.GetTextSize(money),
            y = baseY - 30,
            alpha = 255,
            time = CurTime()
        })
        prevMoney = client:GetMoney()
    end

    -- Dessiner les notifications d'argent
    for i, notif in ipairs(moneyNotifications) do
        local fadeTime = 2 -- seconds
        local elapsedTime = CurTime() - notif.time
        if elapsedTime > fadeTime then
            table.remove(moneyNotifications, i)
        else
            local alphaDecay = (fadeTime - elapsedTime) / fadeTime
            notif.alpha = 255 * alphaDecay
            notif.y = notif.y - 1 -- Fait monter la notification plus rapidement
            notif.x = notif.x + math.random(-2, 2) -- Mouvement aléatoire horizontal plus prononcé
            local color = notif.positive and Color(50, 255, 50, notif.alpha) or Color(255, 50, 50, notif.alpha)
            local prefix = notif.positive and "+" or ""
            draw.SimpleText(prefix .. notif.value .. "$", "HUDFont", notif.x, notif.y, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end
    end
end

hook.Add("HUDPaint", "DrawCustomHUD", DrawHUD)

hook.Add("HUDPaint", "EntityInfoDisplay", function()
    -- Obtenez le joueur local
    local ply = LocalPlayer()
    
    -- Vérifiez si le joueur est valide
    if not IsValid(ply) then return end

    -- Créez une structure de données pour la trace
    local traceData = {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 1000, -- 1000 est la distance maximale pour détecter une entité
        filter = ply
    }

    -- Effectuez la trace
    local trace = util.TraceLine(traceData)

    -- Vérifiez si la trace a touché une entité valide
    local ent = trace.Entity
    if not IsValid(ent) then return end

    -- Récupérez les informations de l'entité
    local name = ent.PrintName or ent:GetClass()
    local health = ent:Health()

    -- Affichez les informations
    draw.SimpleText("Name: " .. name, "Default", ScrW() * 0.5, ScrH() * 0.7, color_white, TEXT_ALIGN_CENTER)
    draw.SimpleText("Health: " .. health, "Default", ScrW() * 0.5, ScrH() * 0.72, color_white, TEXT_ALIGN_CENTER)
end)


hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)
    if name == "CHudHealth" or name == "CHudBattery" then
        return false
    end
end)
