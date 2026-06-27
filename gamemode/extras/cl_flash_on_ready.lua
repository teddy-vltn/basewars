
local function flashOnInitPostEntity()
	if not system.HasFocus() then
		system.FlashWindow()
	end
end
hook.Add( "InitPostEntity", "FlashOnGameLoad", flashOnInitPostEntity )
