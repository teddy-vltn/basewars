-- Structure de notification
BaseWars = BaseWars or {}
BaseWars.Notify = BaseWars.Notify or {}

BaseWars.Notify.Net = BaseWars.Notify.Net or {
    AddNotification = "Notify_AddNotification"
}

BaseWars.Net.Register(BaseWars.Notify.Net.AddNotification, { title = "table", message = "table", color = "color" })

if CLIENT then
    BaseWars.Notify.Notifications = {}
end
