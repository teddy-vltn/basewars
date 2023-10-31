-- basewars/config.lua

BaseWars = BaseWars or {}
BaseWars.Config = BaseWars.Config or {}

BaseWars.Config.Level = {

    MaxLevel = 100,

    -- Do not change these values unless you know how to use the formula
    -- https://blog.jakelee.co.uk/converting-levels-into-xp-vice-versa/#:~:text=First%2C%20come%20up%20with%20a,%3D%20larger%20gaps%20between%20levels).
    FormulaX = 0.3,
    FormulaY = 2,

}

BaseWars.Config.Printers = {
    ["bw_printer_emerald"] = {
        PrintName = "Emerald Printer",
        Model = "models/props_lab/reciever01a.mdl",
        BaseCapacity = 2000,
        BasePrintRate = 20,
        BasePrintCoolDown = 1,
        PowerUsage = 20,
        PowerCapacity = 200,
        PrinterColor = Color(0, 255, 0),
    },
    ["bw_printer_diamond"] = {
        PrintName = "Diamond Printer",
        Model = "models/props_lab/reciever01a.mdl",
        BaseCapacity = 4000,
        BasePrintRate = 40,
        BasePrintCoolDown = 1,
        PowerUsage = 40,
        PowerCapacity = 400,
        PrinterColor = Color(0, 0, 255),
    },
    ["bw_printer_ruby"] = {
        PrintName = "Ruby Printer",
        Model = "models/props_lab/reciever01a.mdl",
        BaseCapacity = 8000,
        BasePrintRate = 80,
        BasePrintCoolDown = 1,
        PowerUsage = 80,
        PowerCapacity = 800,
        PrinterColor = Color(255, 0, 0),
    },
    -- ... add other printers with their respective classnames and properties
}

BaseWars.Config.Shop = {
    ["Entités"] = {
        Icon = "icon16/bricks.png",
        ["Imprimantes"] = {
            Icon = "icon16/printer.png",

            ["T1"] = { 
                --{Name = "Basic Printer", Price = 10, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_base_moneyprinter"},
                {Name = "Emerald Printer", Price = 100, Level = 0, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_printer_emerald"},
                {Name = "Diamond Printer", Price = 200, Level = 0, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_printer_diamond"},
                {Name = "Ruby Printer", Price = 400, Level = 0, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_printer_ruby"},
            }
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
    },
    ["Fun"] = {
        Icon = "icon16/heart.png",

        {Name = "Bouncy Ball", Price = 10, Model = "models/maxofs2d/balloon_classic.mdl", ClassName = "gmod_balloon"},
        
    },
}

BaseWars.Config.MaxShopRecursiveDepth = 5

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