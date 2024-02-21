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

/*
	@description
	Logs a message to the console.

	@param {any} ... - The message to log.
*/
function BaseWars.Log(...)

	MsgC(SERVER and colorRed or colorBlue, "[BASEWARS] -		 ", colorWhite, ...)
	MsgN("")
end

/*
	@description
	Loads a module.

	@param {string} name - The name of the module to load.
*/
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

/*
	@description
	Formats a number into a money string.

	@param {number} n - The number to format.
*/
function BaseWars.FormatMoney(n)
	return "$" .. BaseWars.NumberFormat(n)
end

/*
	@description
	Registers a new entity based on an existing entity. Fake registering without having to create a new file.

	@param {string} baseEntity - The base entity to derive from.
	@param {string} printName - The name of the entity.
	@param {string} model - The model of the entity.
	@param {string} ClassName - The class name of the entity.
*/
function BaseWars.CreateFakeDerivatedScriptedEnt(baseEntity, printName, model, ClassName)
	local ENT = table.Copy(baseEntity)
	
	ENT.Type = "anim"
	ENT.PrintName = printName
	ENT.Model = model
	ENT.ClassName = ClassName

	scripted_ents.Register(ENT, ENT.ClassName)

	return true 
end


/*
	@description
	Registers a new weapon based on an existing weapon. Fake registering without having to create a new file.

	@param {string} baseWeapon - The base weapon to derive from.
	@param {string} newPrintName - The name of the weapon.
	@param {string} newClassName - The class name of the weapon.
	@param {function} customizations - A function to customize the weapon.
*/
function BaseWars.CreateFakeDerivedWeapon(baseWeapon, newPrintName, newClassName, customizations)
    local SWEP = weapons.GetStored(baseWeapon)

    if not SWEP then
        print("Base weapon not found:", baseWeapon)
        return false
    end

    local newSWEP = table.Copy(SWEP)
    newSWEP.PrintName = newPrintName
    newSWEP.ClassName = newClassName

    -- Apply any customizations
    if customizations and type(customizations) == "function" then
        customizations(newSWEP)
    end

    weapons.Register(newSWEP, newClassName)
    return true
end


/*
	@description
	Loads Entity configuration from the config file, in order to create entities.
*/
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

function BaseWars.LoadWeaponConfiguration()
    if not BaseWars.Config.Weapons then
        BaseWars.Log("No weapon configuration found!!!!!!! What have you done?????")
        return
    end

    for category, weps in pairs(BaseWars.Config.Weapons) do
        for weaponClassName, weaponConfig in pairs(weps) do
            local baseWeaponName = weaponConfig.BaseWeapon
            local printName = weaponConfig.PrintName
            local ClassName = weaponClassName

            BaseWars.Log("Creating weapon: " .. ClassName .. " from base weapon: " .. baseWeaponName)

            local success = BaseWars.CreateFakeDerivedWeapon(
                baseWeaponName, 
                printName, 
                ClassName, 
                function(newSWEP)
                    -- Apply custom attributes from weaponConfig
                    if weaponConfig.CustomAttributes then
                        for key, value in pairs(weaponConfig.CustomAttributes) do
                            for k, v in pairs(value) do
								newSWEP[key][k] = v
							end
                        end
                    end
                end
            )

            if success then
                BaseWars.Log("Created weapon: " .. ClassName .. " from base weapon: " .. baseWeaponName)
            end
        end
    end
end

if CLIENT then
	-- create some fonts for everyhting to use
	local font = "Roboto"

	-- loop for creating every size from 12 to 32 with this name format: "BaseWars_12"
	-- two increments because we want to create a bold font too
	for i = 12, 32, 2 do
		surface.CreateFont("BaseWars_" .. i, {
			font = font,
			size = i,
			weight = 500,
		})

		surface.CreateFont("BaseWars_" .. i .. "_Bold", {
			font = font,
			size = i,
			weight = 1000,
		})

		BaseWars.Log("Created font: " .. "BaseWars_" .. i)
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
	BaseWars.LoadWeaponConfiguration()
end
