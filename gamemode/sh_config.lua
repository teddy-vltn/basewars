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

local function Category(...)
    return BaseWars.Category(...)
end

local function Item(...)
    return BaseWars.Item(...)
end

local function Weapon(...)
    return BaseWars.Weapon(...)
end

BaseWars.Config.Shop = {
    Entities = Category("Entities", "icon16/bricks.png", {
        Printers = Category("Printers", "icon16/printer.png", {
            Item("Emerald Printer", "bw_printer_emerald", "models/props_lab/reciever01a.mdl", 1000, 1),
            Item("Diamond Printer", "bw_printer_diamond", "models/props_lab/reciever01a.mdl", 2000, 1),
            Item("Ruby Printer", "bw_printer_ruby", "models/props_lab/reciever01a.mdl", 3000, 1),
        }),
        Turrets = Category("Turrets", "icon16/flag_red.png", {
            Item("Turret", "bw_turret", "models/combine_turrets/floor_turret.mdl", 1000, 1),
        }),
        Teslas = Category("Teslas", "icon16/lightning.png", {
            Item("Tesla", "bw_tesla", "models/props_c17/FurnitureBoiler001a.mdl", 1000, 1),
        }),
        SpawnPoints = Category("Spawn Points", "icon16/user.png", {
            Item("Spawn Point", "bw_spawnpoint", "models/props_trainstation/trainstation_clock001.mdl", 1000, 1),
        }),
    }),
    Weapons = Category("Weapons", "icon16/gun.png", {
        Uncommon = Category("Uncommon", "icon16/medal_silver_3.png", {
            Weapon("Uncommon AK-47", "bw_weapon_ak47_uncommon", "models/weapons/w_ak47_m9k.mdl", 1000),
        }),
        Rare = Category("Rare", "icon16/medal_gold_3.png", {
            Weapon("Rare M4A1", "bw_weapon_m4a1_rare", "models/weapons/w_m4a1_iron.mdl", 2000),
        }),
        VeryRare = Category("Very Rare", "icon16/medal_gold_2.png", {
            Weapon("Very Rare M249", "bw_weapon_m249_veryrare", "models/weapons/w_m249_machine_gun.mdl", 3000),
        }),
        Legendary = Category("Legendary", "icon16/medal_gold_1.png", {
            Weapon("Legendary M249", "bw_weapon_m249_legendary", "models/weapons/w_m249_machine_gun.mdl", 4000),
        }),
    }),
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









