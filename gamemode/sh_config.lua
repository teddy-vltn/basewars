-- basewars/config.lua

BaseWars = BaseWars or {}
BaseWars.Config = BaseWars.Config or {}

BaseWars.Config.Shop = {
    ["Entités"] = {
        Icon = "icon16/bricks.png",
        ["Imprimantes"] = {
            Icon = "icon16/printer.png",

            {Name = "Basic Printer", Price = 10, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_base_moneyprinter"},
        },
        ["Générateurs"] = {
            Icon = "icon16/lightning.png",

            {Name = "Basic Generator", Price = 50, Model = "models/props_lab/reciever01b.mdl", ClassName = "bw_base_generator"},
        },
    },
    ["Armes"] = {
        Icon = "icon16/gun.png",

        ["Pistolets"] = {
            {Name = "Pistol", Price = 10, Model = "models/weapons/w_pistol.mdl", ClassName = "weapon_pistol"},
        },
        ["Fusils"] = {
            {Name = "Rifle", Price = 50, Model = "models/weapons/w_rif_ak47.mdl", ClassName = "weapon_ak47"},
        },
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
    {
        Name = "Faction",
        Icon = "icon16/box.png",
        Panel = function(parent)
            CreateFactionPanel(parent)
        end
    },
}