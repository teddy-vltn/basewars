-- Fonction pour envoyer une notification à un joueur spécifique
function BaseWars.Notify.Send(ply, title, message, color)
    BaseWars.Net.SendToPlayer(ply, BaseWars.Notify.Net.AddNotification, {
        title = title,
        message = message,
        color = color or Color(255, 255, 255)
    })
end

-- Fonction pour envoyer une notification à tous les joueurs
function BaseWars.Notify.Broadcast(title, message, color)
    BaseWars.Net.Broadcast(BaseWars.Notify.Net.AddNotification, {
        title = title,
        message = message,
        color = color or Color(255, 255, 255)
    })
end
