-- basewars/config.lua

BaseWars = BaseWars or {}
BaseWars.Config = BaseWars.Config or {}

-- resarch have time to complete, level, max level, cost, name, description, icon
BaseWars.Config.Research = {
    ["bw_research_health"] = {
        Name = "Health",
        Description = "Increase your health",
        Icon = "icon16/heart.png",
        MaxLevel = 10,
        time = function(level) return 100 * (level + 1) end,
        cost = function(level) return 100 * (level + 1) end,
        effects = function(ply, level) 
            ply:SetMaxHealth(ply:GetMaxHealth() + 10 * level)
            ply:SetHealth(ply:GetMaxHealth())
        end
    }
}

BaseWars.Config.Weapons = {
    Uncommon = {
        ["bw_weapon_ak47_uncommon"] = {
            BaseWeapon = "m9k_ak47",
            PrintName = "Uncommon AK-47",
            Model = "models/weapons/w_ak47_m9k.mdl",
            CustomAttributes = {
                Primary = {
                    Damage = 30,
                    ClipSize = 40,
                    RPM = 3000
                },
            },
        },
    },
    Rare = {
        ["bw_weapon_m4a1_rare"] = {
            BaseWeapon = "m9k_m4a1",
            PrintName = "Rare M4A1",
            Model = "models/weapons/w_m4a1_iron.mdl",
            CustomAttributes = {
                Primary = {
                    Damage = 40,
                    ClipSize = 40,
                    RPM = 3000
                },
            },
        },
    },
    VeryRare = {
        ["bw_weapon_m249_veryrare"] = {
            BaseWeapon = "m9k_m14sp",
            PrintName = "Very Rare M249",
            Model = "models/weapons/w_m249_machine_gun.mdl",
            CustomAttributes = {
                Primary = {
                    Damage = 50,
                    ClipSize = 40,
                    RPM = 3000
                },
            },
        },
    },
    Legendary = {
        ["bw_weapon_m249_legendary"] = {
            BaseWeapon = "m9k_m14sp",
            PrintName = "Legendary M249",
            Model = "models/weapons/w_m249_machine_gun.mdl",
            CustomAttributes = {
                Primary = {
                    Damage = 60,
                    ClipSize = 40,
                    RPM = 3000
                },
            },
        },
    },
    -- ... other categories if needed
}

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

-- only for props replacing the default one
BaseWars.Config.Props = {
    ["Basique"] = {
        Icon = "icon16/bricks.png",

        {Name = "Grille", Price = 10, Model = "models/props_c17/fence01a.mdl"},
        {Name = "Barrière", Price = 10, Model = "models/props_c17/fence02a.mdl"},
        {Name = "Barrière 2", Price = 10, Model = "models/props_c17/fence03a.mdl"},
        {Name = "Barrière 3", Price = 10, Model = "models/props_c17/fence04a.mdl"},
        {Name = "Barrière 4", Price = 10, Model = "models/props_c17/fence05a.mdl"},
        {Name = "Barrière 5", Price = 10, Model = "models/props_c17/fence06a.mdl"},
    },
    ["Plaque"] = {
        Icon = "icon16/bricks.png",

        {Name = "Plaque 1", Price = 10, Model = "models/props_c17/gravestone003a.mdl"},
    }
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

            {Name = "Dispenser Health", Price = 2000, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_dispenser_health"},
            {Name = "Dispenser Ammo", Price = 50, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_dispenser_ammo", VIP = true},
            {Name = "Dispenser Armor", Price = 50, Level = 3, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_dispenser_armor"},
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

BaseWars.Config.Raid = {
    AttackerCooldown = 300,
    DefenderCooldown = 300,
}

BaseWars.Config.Navigation = {
    {
        Name = "Props",
        Color = Color(255, 0, 0),
        Icon = "icon16/bricks.png",
        Panel = function(parent)
            CreatePropsPanel(parent)
        end
    },
    {
        Name = "Tools",
        Color = Color(0, 0, 255),
        Icon = "icon16/cart.png",
        Panel = function(parent)
            CreateToolsPanel(parent)
        end
    },
    {
        Name = "Boutique",
        Color = Color(255, 255, 0),
        Icon = "icon16/cart.png",
        Panel = function(parent)
            CreateBoutiquePanel(parent)
        end
    },
    {
        Name = "Faction",
        Color = Color(255, 0, 0),
        Icon = "icon16/box.png",
        Panel = function(parent)
            CreateFactionPanel(parent)
        end
    },
    {
        Name = "Leaderboard",
        Color = Color(0, 255, 0),
        Icon = "icon16/award_star_gold_1.png",
        Panel = function(parent)
            CreateLeaderboardPanel(parent)
        end
    },
    {
        Name = "Settings",
        Color = Color(0, 0, 255),
        Icon = "icon16/wrench.png",
        Panel = function(parent)
            CreateSettingsPanel(parent)
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

BaseWars.Config.Colors = {
    GREEN = Color(0, 255, 0),
    RED = Color(255, 0, 0),
    BLUE = Color(0, 0, 255),
    WHITE = Color(255, 255, 255),
    YELLOW = Color(255, 255, 0),
}

BaseWars.Config.UI = {
    HeaderColor = Color(40, 40, 40, 110),
    HeaderLineColor = Color(200, 200, 200, 255),

    BodyColor = Color(255, 255, 255, 255),

    CloseBtnTextColor = Color(200, 50, 80, 255),
    TitleTextColor = Color(244, 244, 244, 255),

    Accent = Color(0, 0, 0, 255),

    h2 = Color(0, 0, 0, 255),
    h3 = Color(0, 0, 0, 255),
    h4 = Color(0, 0, 0, 255),
}



