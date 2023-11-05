-- Fonction pour envoyer une notification à un joueur spécifique
function BaseWars.Notify.Send(ply, title, message, color)
    BaseWars.Net.SendToPlayer(ply, BaseWars.Notify.Net.AddNotification, {
        title = title,
        message = message,
        color = color or Color(255, 255, 255)
    })
end

-- Fonction pour envoyer une notification à un groupe de joueurs
function BaseWars.Notify.Group(group, title, message, color)
    BaseWars.Net.SendToGroup(group, BaseWars.Notify.Net.AddNotification, {
        title = title,
        message = message,
        color = color or Color(255, 255, 255)
    })
end

-- Fonction pour envoyer une notification à tous les joueurs d'une faction
function BaseWars.Notify.Faction(faction, title, message, color)
    local faction = BaseWars.Faction.Factions[faction]
    if not faction then return end

    local members = faction:GetMembers()

    BaseWars.Net.SendToGroup(members, BaseWars.Notify.Net.AddNotification, {
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
