AddCSLuaFile()

GM.Name 		= ""
GM.Author 		= ""
GM.Email 		= ""
GM.Website 		= ""

DeriveGamemode("sandbox")

BaseWars = BaseWars or {}

local colorRed = Color(255, 0, 0)
local colorBlue = Color(0, 0, 255)
local colorWhite = Color(255, 255, 255)

function BaseWars.Log(...)

	MsgC(SERVER and colorRed or colorBlue, "[BASEWARS] -		 ", colorWhite, ...)
	MsgN("")
end

function BaseWars.Color(code)
	return BaseWars.Config.Colors[code]
end

function BaseWars.NumberFormat(n)
	if not n then return "0" end

	if n >= 1e14 then return tostring(n) end
	n = tostring(n)
	local sep = sep or ","
	local dp = string.find(n, "%.") or #n + 1

	for i = dp - 4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i + 1)
	end

	return n
end

function BaseWars.FormatMoney(n)
	return "$" .. BaseWars.NumberFormat(n)
end


function BaseWars.CreateFakeDerivatedScriptedEnt(baseEntity, printName, model, ClassName)
	local ENT = table.Copy(baseEntity)
	
	ENT.Type = "anim"
	ENT.PrintName = printName
	ENT.Model = model
	ENT.ClassName = ClassName

	scripted_ents.Register(ENT, ENT.ClassName)

	return true 
end

function BaseWars.LoadEntityConfiguration()

	if not BaseWars.Config.Entities then
		BaseWars.Log("No entity configuration found!!!!!!! What have you done?????")
		return
	end

    for category, categoryConfig in pairs(BaseWars.Config.Entities) do
        local baseEntityName = categoryConfig.BaseEntity
        local baseEntity = scripted_ents.Get(baseEntityName)
        
        if not baseEntity then
            ErrorNoHalt("Failed to find base entity: " .. baseEntityName)
            return
        end

        for entityClassName, entityConfig in pairs(categoryConfig.Entities) do

			local printName = entityConfig.PrintName
			local model = entityConfig.Model
			local ClassName = entityClassName

			BaseWars.Log("Creating entity: " .. ClassName .. "from base entity: " .. baseEntityName)

			if BaseWars.CreateFakeDerivatedScriptedEnt(baseEntity, printName, model, ClassName) then
				BaseWars.Log("Created entity: " .. ClassName .. "from base entity: " .. baseEntityName)
			end
        end
    end
end

include("sh_config.lua")

include("modules/sh_modules.lua")

if SERVER then
	AddCSLuaFile("sh_config.lua")

    AddCSLuaFile("modules/sh_modules.lua")

end

function GM:Initialize()
	if SERVER then
		BaseWars.Faction.Initialize()
	end

	BaseWars.LoadEntityConfiguration()
end

function GM:PlayerSpawnProp(ply, model)

	self.BaseClass.PlayerSpawnProp(self, ply, model)

	-- logic prop

end
