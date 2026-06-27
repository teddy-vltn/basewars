BaseWars = BaseWars or {}
BaseWars.Config = BaseWars.Config or {}
BaseWars.Config.Entities = {}

BaseWars.AddBaseEntity("Printers", {
    BaseEntity = "bw_base_moneyprinter",
    Configurables = {
        PrintName = "String",
        Model = "String",
        PrinterColor = "Color",
        BasePrintRate = "Number",
    }
})

BaseWars.AddBaseEntity("Turrets", {
    BaseEntity = "bw_base_turret",
})

BaseWars.AddBaseEntity("Teslas", {
    BaseEntity = "bw_base_tesla",
})

BaseWars.AddBaseEntity("SpawnPoints", {
    BaseEntity = "bw_base_spawnpoint",
})

BaseWars.AddBaseEntity("Generators", {
    BaseEntity = "bw_base_generator",
})

BaseWars.AddBaseEntity("Dispensers", {
    BaseEntity = "bw_base_dispenser",
})

BaseWars.AddDerivedEntity("Printers", "bw_printer_emerald", {
    PrintName = "Emerald Printer",
    Model = "models/props_lab/reciever01a.mdl",
    PrinterColor = Color(0, 255, 0),
    BasePrintRate = 200,
    -- Add more properties as needed
})

BaseWars.AddDerivedEntity("Printers", "bw_printer_diamond", {
    PrintName = "Diamond Printer",
    Model = "models/props_lab/reciever01a.mdl",
    PrinterColor = Color(0, 0, 255),
    BasePrintRate = 300,
    -- Add more properties as needed
})

