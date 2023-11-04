surface.CreateFont("NotificationTitle", {
    font = "Tahoma",
    size = 30,
    weight = 700,
    antialias = true,
    shadow = true,
})

surface.CreateFont("NotificationText", {
    font = "Tahoma",
    size = 20,
    weight = 500,
    antialias = true,
    shadow = true,
})

local NOTIF_HEIGHT = 60
local NOTIF_MARGIN = 15
local NOTIF_FADE_TIME = 1 -- Durée de l'animation de disparition en secondes

net.Receive(BaseWars.Notify.Net.AddNotification, function()
    local data = BaseWars.Net.Read(BaseWars.Notify.Net.AddNotification)
    local title, message, color = data.title, data.message, data.color
    
    local notif = {
        title = title,
        message = message,
        color = color,
        time = CurTime()
    }

    table.insert(BaseWars.Notify.Notifications, notif)
end)

local function DrawNotifications()
    local startX = 15
    local startY = 15

    for i, notif in ipairs(BaseWars.Notify.Notifications) do
        local elapsed = CurTime() - notif.time
        if elapsed > 5 then -- Disparaît après 5 secondes
            table.remove(BaseWars.Notify.Notifications, i)
        else
            local alpha = 255
            if elapsed > 5 - NOTIF_FADE_TIME then
                alpha = 255 * (1 - (elapsed - (5 - NOTIF_FADE_TIME)) / NOTIF_FADE_TIME)
            end

            local titleWidth, titleHeight = surface.GetTextSize(notif.title) or 0, 0
            local msgWidth, msgHeight = surface.GetTextSize(notif.message) or 0, 0
            local NOTIF_WIDTH = math.max(titleWidth, msgWidth) + 20
            
            -- Dessine le fond
            draw.RoundedBox(8, startX, startY + (i-1) * (NOTIF_HEIGHT + NOTIF_MARGIN), NOTIF_WIDTH, NOTIF_HEIGHT, Color(40, 40, 40, alpha))
            
            -- Dessine le titre et le message
            local titleY = startY + (i-1) * (NOTIF_HEIGHT + NOTIF_MARGIN) + 5
            local messageY = titleY + titleHeight + 2
            draw.SimpleText(notif.title, "NotificationTitle", startX + 10, titleY, Color(notif.color.r, notif.color.g, notif.color.b, alpha))
            draw.SimpleText(notif.message, "NotificationText", startX + 10, messageY, Color(notif.color.r, notif.color.g, notif.color.b, alpha))
        end
    end
end

hook.Add("HUDPaint", "DrawNotifications", DrawNotifications)
