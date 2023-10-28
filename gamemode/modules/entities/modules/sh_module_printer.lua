local BW_PRINTER_MODULE = {}

BW_PRINTER_MODULE.Name = "Printer"
BW_PRINTER_MODULE.Description = "Allows you to print money"

BW_PRINTER_MODULE.NetworkVars = {
    {"Money", 0, "Int"},
    {"Capacity", 0, "Int"},
    {"PrintRate", 0, "Int"},
    {"PrintCoolDown", 0, "Int"}
}

function BW_PRINTER_MODULE.Initialize(ent)
    print("Printer module initialized")
end

function BW_PRINTER_MODULE.OnThink(ent)
    if CLIENT then return end

    local money = ent:GetMoney()
    local capacity = ent:GetCapacity()
    local printRate = ent:GetPrintRate()
    local LastTimePrinted = ent.LastTimePrinted
    local PrintCoolDown = ent:GetPrintCoolDown()

    if money < capacity and CurTime() - LastTimePrinted >= PrintCoolDown then
        ent:SetMoney(money + printRate)
        ent.LastTimePrinted = CurTime()
    end

end

BaseWars.Entity.Modules:Add(BW_PRINTER_MODULE.Name, BW_PRINTER_MODULE)


