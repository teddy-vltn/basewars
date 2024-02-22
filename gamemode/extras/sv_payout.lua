-- Timer to give money for playing
timer.Create("BaseWars_MoneyTimer", BaseWars.Config.Globals.MinuteBeforePayout, 0, function()
    for k, v in pairs(player.GetAll()) do
        if not IsValid(v) then continue end
        if not v:IsPlayer() then continue end

        v:AddMoney(BaseWars.Config.Globals.MoneyPerMinute) 

        BaseWars.Notify.Send(v, "Money", "You have been given $" .. BaseWars.Config.Globals.MoneyPerMinute .. " for playing.", Color(0, 255, 0))
    end
end)
