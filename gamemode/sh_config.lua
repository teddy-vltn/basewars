-- basewars/config.lua

BaseWars = BaseWars or {}
BaseWars.Config = BaseWars.Config or {}

BaseWars.Config.Shop = {
    ["Entités"] = {
        ["Imprimantes"] = {
            {Name = "Basic Printer", Price = 10, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_base_moneyprinter"},
        },
        ["Générateurs"] = {
            {Name = "Basic Generator", Price = 50, Model = "models/props_lab/reciever01b.mdl", ClassName = "bw_base_generator"},
        },
    },
    ["Armes"] = {
    }
}

BaseWars.Config.MaxShopRecursiveDepth = 3

BaseWars.Config.Navigation = {
    {
        Name = "Accueil",
        Icon = "icon16/house.png",
        Panel = function(parent)
        end
    },
    {
        Name = "Boutique",
        Icon = "icon16/cart.png",
        Panel = function(parent)
            CreateBoutiquePanel(parent)
        end
    },
}