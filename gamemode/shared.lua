AddCSLuaFile()

GM.Name 		= ""
GM.Author 		= ""
GM.Email 		= ""
GM.Website 		= ""

DeriveGamemode("sandbox")

BaseWars = BaseWars or {}

function recursiveInclusion( scanDirectory, isGamemode )
	-- Null-coalescing for optional argument
	isGamemode = isGamemode or false
	
	local queue = { scanDirectory }
	
	-- Loop until queue is cleared
	while #queue > 0 do
		-- For each directory in the queue...
		for _, directory in pairs( queue ) do
			-- print( "Scanning directory: ", directory )
			
			local files, directories = file.Find( directory .. "/*", "LUA" )
			
			-- Include files within this directory
			for _, fileName in pairs( files ) do
				if fileName != "shared.lua" and fileName != "init.lua" and fileName != "cl_init.lua" then
					-- print( "Found: ", fileName )
					
					-- Create a relative path for inclusion functions
					-- Also handle pathing case for including gamemode folders
					local relativePath = directory .. "/" .. fileName
					if isGamemode then
						relativePath = string.gsub( directory .. "/" .. fileName, GM.FolderName .. "/gamemode/", "" )
					end
					
					-- Include server files
					if string.match( fileName, "^sv" ) then
						if SERVER then
							include( relativePath )
						end
					end
					
					-- Include shared files
					if string.match( fileName, "^sh" ) then
						AddCSLuaFile( relativePath )
						include( relativePath )
					end
					
					-- Include client files
					if string.match( fileName, "^cl" ) then
						AddCSLuaFile( relativePath )
						
						if CLIENT then
							include( relativePath )
						end
					end
				end
			end
			
			-- Append directories within this directory to the queue
			for _, subdirectory in pairs( directories ) do
				-- print( "Found directory: ", subdirectory )
				table.insert( queue, directory .. "/" .. subdirectory )
			end
			
			-- Remove this directory from the queue
			table.RemoveByValue( queue, directory )
		end
	end
end

recursiveInclusion( GM.FolderName .. "/gamemode", true )

function BaseWars.LoadPrinterConfiguration()
    for printerClassName, printerConfig in pairs(BaseWars.Config.Printers) do
        local BasePrinter = scripted_ents.Get("bw_base_moneyprinter")
        if not BasePrinter then
            ErrorNoHalt("Failed to find base printer entity!")
            return
        end
        local ENT = table.Copy(BasePrinter)
        
        ENT.Type = "anim"
        ENT.PrintName = printerConfig.PrintName
        ENT.Model = printerConfig.Model
        ENT.ClassName = printerClassName
        
        scripted_ents.Register(ENT, ENT.ClassName)
        print("Registered printer " .. ENT.ClassName .. " with config " .. printerConfig.PrintName)
    end
end

function GM:Initialize()
	if SERVER then
		BaseWars.Faction.Initialize()
	end
	
	BaseWars.LoadPrinterConfiguration()
end
