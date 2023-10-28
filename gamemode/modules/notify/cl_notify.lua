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

local NOTIF_HEIGHT = 50
local NOTIF_MARGIN = 10

net.Receive("AddNotification", function()
    local title = net.ReadString()
    local message = net.ReadString()
    local color = net.ReadColor()

    local notif = {
        title = title,
        message = message,
        color = color,
        time = CurTime()
    }

    table.insert(BaseWars.Notify.Notifications, notif)
end)

local function DrawNotifications()
    local startX = 10
    local startY = 10

    for i, notif in ipairs(BaseWars.Notify.Notifications) do
        if CurTime() - notif.time > 5 then -- Disparaît après 5 secondes
            table.remove(BaseWars.Notify.Notifications, i)
        else

            local NOTIF_WIDTH = surface.GetTextSize(notif.title) + 10 or 0
            if surface.GetTextSize(notif.message) + 10 > NOTIF_WIDTH then
                NOTIF_WIDTH = surface.GetTextSize(notif.message) + 10
            end
            -- Dessine le fond
            draw.RoundedBox(4, startX, startY + (i-1) * (NOTIF_HEIGHT + NOTIF_MARGIN), NOTIF_WIDTH, NOTIF_HEIGHT, Color(40, 40, 40, 220))
            
            -- Dessine le titre et le message
            draw.SimpleText(notif.title, "NotificationTitle", startX + 5, startY + (i-1) * (NOTIF_HEIGHT + NOTIF_MARGIN) + 5, notif.color)
            draw.SimpleText(notif.message, "NotificationText", startX + 5, startY + (i-1) * (NOTIF_HEIGHT + NOTIF_MARGIN) + 30, notif.color)
        end
    end
end

hook.Add("HUDPaint", "DrawNotifications", DrawNotifications)
