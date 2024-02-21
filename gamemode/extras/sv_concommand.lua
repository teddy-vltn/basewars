-- Command to force a player to join a faction (for testing purposes)
concommand.Add("bw_forcejoin", function(ply, cmd, args)
    if not args[1] then return end
    local faction = args[1]

    if not ply:IsAdmin() then
        ply:ChatPrint("You do not have permission to do that!")
        return
    end

    local target = ply:GetEyeTrace().Entity
    if not IsValid(target) or not target:IsPlayer() then
        ply:ChatPrint("You must be looking at a player to use this command!")
        return
    end

    BaseWars.Faction.SetFaction(target, faction)
end)

-- Force all players to join a faction except for the player who runs the command
concommand.Add("bw_forcejoinall", function(ply, cmd, args)
    if not args[1] then return end
    local faction = args[1]

    if not ply:IsAdmin() then
        ply:ChatPrint("You do not have permission to do that!")
        return
    end

    for k, v in pairs(player.GetAll()) do
        if v == ply then continue end
        BaseWars.Faction.SetFaction(v, faction)
    end
end)