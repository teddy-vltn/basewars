-- Define the fonts
surface.CreateFont("HUDMainFont", {
    font = "Tahoma",
    size = 20,
    weight = 500,
    antialias = true
})

surface.CreateFont("HUDSmallFont", {
    font = "Tahoma",
    size = 16,
    weight = 500,
    antialias = true
})

local prevMoney = 0
local moneyNotifications = {}

local function DrawBar(x, y, w, h, color, value, maxValue)

    if not value then value = 1 maxValue = 1 end

    surface.SetDrawColor(50, 50, 50, 200) -- Background
    surface.DrawRect(x, y, w, h)
    local barWidth = w * math.min(value / maxValue, 1)
    surface.SetDrawColor(color)
    surface.DrawRect(x, y, barWidth, h)
end

local function DrawHUD()
    local client = LocalPlayer()
    if not IsValid(client) then return end

    local health = math.max(client:Health(), 0)
    local armor = math.max(client:Armor(), 0)
    local money = client:GetMoney() or 0
    local level = client:GetLevel() or 0
    local xp = client:GetXP() or 0
    local xpForLevel = client:GetXPForNextLevel() or 100

    local screenW, screenH = ScrW(), ScrH()
    local baseX = 10
    local baseY = screenH - 40
    local spacing = 10
    local barWidth = 200
    local barHeight = 20

    -- Draw the background
    DrawBar(baseX, baseY, barWidth, barHeight, Color(50, 50, 50))

    -- Health
    DrawBar(baseX, baseY, barWidth, barHeight, Color(255, 50, 50), health, 100)
    draw.SimpleText("Vie: " .. health, "HUDMainFont", baseX + 5, baseY + barHeight / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Armor
    local armorX = baseX + barWidth + spacing
    DrawBar(armorX, baseY, barWidth, barHeight, Color(50, 50, 255), armor, 100)
    draw.SimpleText("Armure: " .. armor, "HUDMainFont", armorX + 5, baseY + barHeight / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Money, Level, and XP in a more compact format
    local infoY = baseY - barHeight - spacing
    draw.SimpleText("Argent: $" .. money .. " | Niveau: " .. level .. " | XP: " .. xp .. "/" .. xpForLevel, "HUDSmallFont", baseX, infoY, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Money notifications
    local moneyDifference = client:GetMoney() - prevMoney
    if moneyDifference ~= 0 then
        table.insert(moneyNotifications, {
            value = moneyDifference,
            positive = moneyDifference > 0,
            x = screenW / 2,
            y = screenH / 2 - 100,
            alpha = 255,
            time = CurTime()
        })
        prevMoney = client:GetMoney()
    end

    -- Draw money notifications with improved visuals
    for i, notif in ipairs(moneyNotifications) do
        local fadeTime = 2 -- seconds
        local elapsedTime = CurTime() - notif.time
        if elapsedTime > fadeTime then
            table.remove(moneyNotifications, i)
        else
            local alphaDecay = (fadeTime - elapsedTime) / fadeTime
            notif.alpha = 255 * alphaDecay
            notif.y = notif.y - 1 -- Make the notification rise faster
            local color = notif.positive and Color(50, 255, 50, notif.alpha) or Color(255, 50, 50, notif.alpha)
            local prefix = notif.positive and "+" or "-"
            draw.SimpleText(prefix .. notif.value .. "$", "HUDMainFont", notif.x, notif.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

hook.Add("HUDPaint", "DrawCustomHUD", DrawHUD)

-- Entity information display with minor adjustments for consistency
hook.Add("HUDPaint", "EntityInfoDisplay", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local traceData = {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:GetAimVector() * 1000,
        filter = ply
    }

    local trace = util.TraceLine(traceData)
    local ent = trace.Entity
    if not IsValid(ent) then return end

    local name = ent.PrintName or ent:GetClass()
    local health = ent:Health()

    draw.SimpleText("Name: " .. name, "HUDSmallFont", ScrW() * 0.5, ScrH() * 0.7, color_white, TEXT_ALIGN_CENTER)
    draw.SimpleText("Health: " .. health, "HUDSmallFont", ScrW() * 0.5, ScrH() * 0.72, color_white, TEXT_ALIGN_CENTER)
end)

-- Hide default HUD elements
hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)
    if name == "CHudHealth" or name == "CHudBattery" then
        return false
    end
end)
