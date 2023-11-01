util.AddNetworkString("AddNotification")

-- Fonction pour envoyer une notification à un joueur spécifique
function BaseWars.Notify.Send(ply, title, message, color)
    net.Start("AddNotification")
        net.WriteString(title)
        net.WriteString(message)
        net.WriteColor(color or Color(255, 255, 255))
    net.Send(ply)
end

-- Fonction pour envoyer une notification à tous les joueurs
function BaseWars.Notify.Broadcast(title, message, color)
    net.Start("AddNotification")
    net.WriteString(title)
    net.WriteString(message)
    net.WriteColor(color or Color(255, 255, 255))
    net.Broadcast()
end
