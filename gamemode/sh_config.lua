-- basewars/config.lua

BaseWars = BaseWars or {}
BaseWars.Config = BaseWars.Config or {}

BaseWars.Config.Entities = {
    Printers = {
        BaseEntity = "bw_base_moneyprinter",
        Entities = {
            ["bw_printer_emerald"] = {
                PrintName = "Emerald Printer",
                Model = "models/props_lab/reciever01a.mdl",
                PrinterColor = Color(0, 255, 0),
                BasePrintRate = 200,
                -- ... autres propriétés
            },
            ["bw_printer_diamond"] = {
                PrintName = "Diamond Printer",
                Model = "models/props_lab/reciever01a.mdl",
                PrinterColor = Color(0, 0, 255),
                -- ... autres propriétés
            },
            -- ... autres imprimantes
        },
    },
    Generators = {
        BaseEntity = "bw_base_generator",
        Entities = {
            ["bw_generator_coal"] = {
                PrintName = "Coal Generator",
                Model = "models/props_lab/reciever01b.mdl",
                -- ... autres propriétés
            },
        },
    },
    Turrets = {
        BaseEntity = "bw_base_turret",
        Entities = {
            ["bw_turret"] = {
                PrintName = "Turret",
                Model = "models/combine_turrets/floor_turret.mdl",
                -- ... autres propriétés
            },
        },
    },
    Teslas = {
        BaseEntity = "bw_base_tesla",
        Entities = {
            ["bw_tesla"] = {
                PrintName = "Tesla",
                Model = "models/props_c17/FurnitureBoiler001a.mdl",
                -- ... autres propriétés
            },
        },
    },
    SpawnPoints = {
        BaseEntity = "bw_base_spawnpoint",
        Entities = {
            ["bw_spawnpoint"] = {
                PrintName = "Spawn Point",
                Model = "models/props_trainstation/trainstation_clock001.mdl",
                -- ... autres propriétés
            },
        },
    },
    Dispensers = {
        BaseEntity = "bw_base_dispenser",
        Entities = {
            ["bw_dispenser_health"] = {
                PrintName = "Dispenser Health",
                Model = "models/props_lab/reciever01a.mdl",
                DispenseType = "Health",
                BaseDispenseCoolDown = 1,
                BaseDispenseRate = 10,
                BaseDispenseCapacity = 100,
            },
            ["bw_dispenser_ammo"] = {
                PrintName = "Dispenser Ammo",
                Model = "models/props_lab/reciever01a.mdl",
                DispenseType = "Ammo",
                BaseDispenseCoolDown = 1,
                BaseDispenseRate = 100,
                BaseDispenseCapacity = 1000,
            },
            ["bw_dispenser_armor"] = {
                PrintName = "Dispenser Armor",
                Model = "models/props_lab/reciever01a.mdl",
                DispenseType = "Armor",
                BaseDispenseCoolDown = 1,
                BaseDispenseRate = 30,
                BaseDispenseCapacity = 100,
            },
        },
    },
    -- ... autres catégories
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
            },

            ["VIP"] = {
                ["T1"] = {

                }
            }
        },
        ["Générateurs"] = {
            Icon = "icon16/lightning.png",

            {Name = "Basic Generator", Price = 50, Model = "models/props_lab/reciever01b.mdl", ClassName = "bw_base_generator"},
            {Name = "Coal Generator", Price = 50, Model = "models/props_lab/reciever01b.mdl", ClassName = "bw_generator_coal"},
        },
        ["Tourelle"] = {

            {Name = "Tourelle Basique", Price = 50, Model = "models/combine_turrets/floor_turret.mdl", ClassName = "bw_turret"},
            {Name = "Tesla Basique", Price = 50, Model = "models/props_c17/FurnitureBoiler001a.mdl", ClassName = "bw_tesla"},
        },
        ["Base"] = {
            {Name = "Spawn Point", Price = 50, Model = "models/props_trainstation/trainstation_clock001.mdl", ClassName = "bw_spawnpoint"},
        },
        ["Dispenser"] = {
            Icon = "icon16/heart.png",

            {Name = "Dispenser Health", Price = 50, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_dispenser_health"},
            {Name = "Dispenser Ammo", Price = 50, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_dispenser_ammo"},
            {Name = "Dispenser Armor", Price = 50, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_dispenser_armor"},
        },
    },
    ["Armes"] = {
        Icon = "icon16/gun.png",

        ["Pistolets"] = {
            {Name = "Pistol", Price = 10, Model = "models/weapons/w_pistol.mdl", ClassName = "weapon_pistol", Weapon = true},
        },
        ["Fusils"] = {
            {Name = "Rifle", Price = 50, Model = "models/weapons/w_rif_ak47.mdl", ClassName = "weapon_ak47", Weapon = true},
        },
    },
    ["Fun"] = {
        Icon = "icon16/heart.png",

        {Name = "Bouncy Ball", Price = 10, Model = "models/maxofs2d/balloon_classic.mdl", ClassName = "gmod_balloon"},
        
    },
}

BaseWars.Config.MaxShopRecursiveDepth = 5

BaseWars.Config.Level = {

    MaxLevel = 100,

    -- Do not change these values unless you know how to use the formula
    -- https://blog.jakelee.co.uk/converting-levels-into-xp-vice-versa/#:~:text=First%2C%20come%20up%20with%20a,%3D%20larger%20gaps%20between%20levels).
    FormulaX = 0.3,
    FormulaY = 2,

}

BaseWars.Config.Navigation = {
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

BaseWars.Config.Sounds = {
    Accept = "buttons/button14.wav",
    Deny = "buttons/button11.wav",

    Click = "buttons/button15.wav",
    Hover = "buttons/lightswitch2.wav",

    Open = "doors/door1_move.wav",
    Close = "doors/door1_stop.wav",
}