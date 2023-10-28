concommand.Add("gm_spawnsent", function(ply, cmd, args)
    if not args[1] then return end
    local entName = args[1]

    if not ply:IsAdmin() then  -- Optionnel : vérifiez si le joueur est un administrateur
        ply:ChatPrint("Vous n'avez pas la permission de faire cela!")
        return
    end

    local ent = ents.Create(entName)
    if not IsValid(ent) then return end

    ent:SetPos(ply:GetEyeTrace().HitPos)

    -- initialize modules
    if ent.InitializeModules then
        ent:InitializeModules()

        -- initialize upgrade module
        for _, module in pairs(ent.Modules) do
            if module.Initialize then
                module:Initialize(ent)
            end
        end
    end

    ent:Spawn()

end)