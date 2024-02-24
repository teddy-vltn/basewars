-- basewars/config.lua

BaseWars = BaseWars or {}
BaseWars.Config = BaseWars.Config or {}

BaseWars.Config.Debug = true

BaseWars.Config.Globals = {

    DefaultLanguage = "en",

    FreezePlaterWhenDataLoadingError = false,

    DefaultMoney = 1000,
    DefaultLevel = 1,
    DefaultXP = 0,

    PercentageOfMoneyLostOnSell = 0.5,

    MoneyPerMinute = 100,
    MinuteBeforePayout = 1 * 60,

    DefaultWeapons = {
        "weapon_physgun",
        "weapon_physcannon",
        "gmod_tool",
        "gmod_camera",
    },
}

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

-- resarch have time to complete, level, max level, cost, name, description, icon
BaseWars.Config.Research = {
    ["bw_research_health"] = {
        Name = "Health",
        Description = "Increase your health",
        Icon = "icon16/heart.png",
        MaxLevel = 10,
        time = function(level) return 5 * (level + 1) end,
        cost = function(level) return 100 * (level + 1) end,
        Apply = function(ply, level) 
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
        {Name = "Caisse", Price = 5, Model = "models/props_junk/wood_crate001a.mdl"},
        {Name = "Tonneau", Price = 15, Model = "models/props_c17/oildrum001.mdl"},
        {Name = "Palette", Price = 5, Model = "models/props_junk/wood_pallet001a.mdl"},
        {Name = "Conteneur", Price = 30, Model = "models/props_junk/ShippingContainer01a.mdl"},
        {Name = "Échelle", Price = 20, Model = "models/props_c17/metalladder001.mdl"},
        {Name = "Poubelle", Price = 5, Model = "models/props_junk/TrashBin01a.mdl"},
        {Name = "Banc", Price = 10, Model = "models/props_c17/bench01a.mdl"},
    },
    ["Plaque"] = {
        Icon = "icon16/bricks.png",
        {Name = "Plaque 1", Price = 10, Model = "models/props_c17/gravestone003a.mdl"},
        {Name = "Plaque 2", Price = 10, Model = "models/hunter/plates/plate1x2.mdl"},
        {Name = "Plaque 3", Price = 15, Model = "models/hunter/plates/plate2x2.mdl"},
        {Name = "Plaque 4", Price = 20, Model = "models/hunter/plates/plate2x4.mdl"},
        {Name = "Plaque 5", Price = 25, Model = "models/hunter/plates/plate4x4.mdl"},
        {Name = "Plaque 6", Price = 30, Model = "models/hunter/plates/plate4x8.mdl"},
    },
    ["Construction"] = {
        Icon = "icon16/wrench.png",
        {Name = "Poutre", Price = 15, Model = "models/props_c17/trussbeam01.mdl"},
        {Name = "Poutre 2", Price = 20, Model = "models/props_c17/Ibeam02b.mdl"},
        {Name = "Escalier", Price = 25, Model = "models/props_c17/stairs01a.mdl"},
        {Name = "Escalier Métal", Price = 30, Model = "models/props_c17/MetalStairs001a.mdl"},
        {Name = "Porte", Price = 20, Model = "models/props_doors/door03_slotted_left.mdl"},
    },
    ["Décoratif"] = {
        Icon = "icon16/heart.png",
        {Name = "Lampe", Price = 15, Model = "models/props_c17/lampShade001a.mdl"},
        {Name = "Arbre", Price = 50, Model = "models/props_foliage/tree_deciduous_01a.mdl"},
        {Name = "Buisson", Price = 30, Model = "models/props_foliage/bush01.mdl"},
        {Name = "Table", Price = 20, Model = "models/props_c17/furnitureTable002a.mdl"},
        {Name = "Chaise", Price = 10, Model = "models/props_c17/FurnitureChair001a.mdl"},
    },
    ["Véhicules"] = {
        Icon = "icon16/car.png",
        {Name = "Voiture", Price = 200, Model = "models/props_vehicles/car004b_physics.mdl"},
        {Name = "Camion", Price = 300, Model = "models/props_vehicles/truck003a.mdl"},
        {Name = "Hélicoptère", Price = 500, Model = "models/props_junk/helicopter001a.mdl"},
    },
}


BaseWars.Config.Shop = {
    ["Entités"] = {
        Icon = "icon16/bricks.png",
        ["Imprimantes"] = {
            Icon = "icon16/printer.png",

            ["T1"] = { 
                --{Name = "Basic Printer", Price = 10, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_base_moneyprinter"},
                {Name = "Emerald Printer", Price = 100, Level = 0, Model = "models/props_lab/reciever01a.mdl", ClassName = "bw_printer_emerald", Limit = 1},
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
            {Name = "Rifle", Price = 50, Model = "models/weapons/w_rif_ak47.mdl", ClassName = "bw_weapon_ak47_uncommon", Weapon = true},

        },
    },
    ["Fun"] = {
        Icon = "icon16/heart.png",

        {Name = "Bouncy Ball", Price = 10, Model = "models/maxofs2d/balloon_classic.mdl", ClassName = "gmod_balloon"},
        
    },
}




