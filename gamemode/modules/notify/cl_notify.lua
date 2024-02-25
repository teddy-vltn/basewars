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

    BaseWars.Log("Received notification: " .. title.phrase .. " - " .. message.phrase .. " - " .. color.r .. " " .. color.g .. " " .. color.b)

    title = BaseWars.Lang(title.phrase, title.args)
    message = BaseWars.Lang(message.phrase, message.args) 
    
    surface.SetFont("NotificationTitle")
    local titleWidth, titleHeight = surface.GetTextSize(title)
    surface.SetFont("NotificationText")
    local msgWidth, msgHeight = surface.GetTextSize(message)
    
    local notifWidth = math.max(titleWidth, msgWidth) + 60 -- Add extra space for padding and color strip
    
    local notif = {
        title = title,
        message = message,
        color = color,
        time = CurTime(),
        width = notifWidth -- Save the width here
    }

    table.insert(BaseWars.Notify.Notifications, notif)
end)

local function DrawNotifications()
    local startX = 15
    local startY = 15

    -- Set the font outside of the loop to avoid repeated calls
    surface.SetFont("NotificationTitle")
    surface.SetFont("NotificationText")

    for i, notif in ipairs(BaseWars.Notify.Notifications) do
        local elapsed = CurTime() - notif.time
        if elapsed > 5 then -- Disappear after 5 seconds
            table.remove(BaseWars.Notify.Notifications, i)
        else
            local alpha = 255
            if elapsed > 5 - NOTIF_FADE_TIME then
                alpha = 255 * (1 - (elapsed - (5 - NOTIF_FADE_TIME)) / NOTIF_FADE_TIME)
            end

            local notifX = startX
            local notifY = startY + (i-1) * (NOTIF_HEIGHT + NOTIF_MARGIN)

            -- Recalculate title and message height each time in case of font changes
            surface.SetFont("NotificationTitle")
            local titleWidth, titleHeight = surface.GetTextSize(notif.title)
            surface.SetFont("NotificationText")
            local msgWidth, msgHeight = surface.GetTextSize(notif.message)

            -- Use the saved width for each notification
            local notifWidth = notif.width

            -- Draw the background with rounded corners
            draw.RoundedBox(8, notifX, notifY, notifWidth, NOTIF_HEIGHT, Color(0, 0, 0, alpha * 0.7))

            -- Draw the color strip
            draw.RoundedBox(0, notifX, notifY, 20, NOTIF_HEIGHT, Color(notif.color.r, notif.color.g, notif.color.b, alpha))

            -- Set the positions for title and message
            local textX = notifX + 30 -- Start after the color strip
            local titleY = notifY + (NOTIF_HEIGHT / 2) - ((titleHeight + msgHeight) / 2) -- Centered vertically
            local messageY = titleY + titleHeight -- Space between title and message

            -- Draw the title and message with shadows
            draw.SimpleText(notif.title, "NotificationTitle", textX, titleY, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT)
            draw.SimpleText(notif.message, "NotificationText", textX, messageY, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT)
        end
    end
end

hook.Add("HUDPaint", "DrawNotifications", DrawNotifications)

