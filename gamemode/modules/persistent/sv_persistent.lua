BaseWars.Persist = BaseWars.Persist or {}
local Persist = BaseWars.Persist

local ply = FindMetaTable("Player")

local api = "http://172.20.10.2:5000"

local function GetPlayerID(ply)
    return ply:SteamID64()
end

-- unsure the "/" is working
function Persist.Test()
    http.Fetch(api .. "/",
        function(body, len, headers, code)
            print("Test: ", body)
        end,
        function(error)
            print("Error: ", error)
        end
    )
end

function Persist.GetPlayers()
    http.Fetch(api .. "/players",
        function(body, len, headers, code)
            local players = util.JSONToTable(body)
            -- Process players data here
            -- Example: Print each player's data
            for _, player in ipairs(players) do
                print("Player: ", player)
            end
        end,
        function(error)
            -- Handle error
            print("Error fetching players: ", error)
        end
    )
end

function Persist.GetPlayer(ply, load)
    if load == nil then
        load = false
    end
    local steamid = GetPlayerID(ply)

    http.Fetch(api .. "/player/" .. steamid,
        function(body, len, headers, code)
            if code == 404 then
                local data = util.JSONToTable(body)
                if data.code == '2' then
                    
                    return Persist.CreatePlayer(ply)
                end
            else
                local player = util.JSONToTable(body)
                -- Process player data here
                -- Load player data into the game
                if load then
                    ply:SetNWInt("money", player[2])
                end
            end
        end,
        function(error)
            -- Handle error
            print("Error fetching player: ", error)
        end
    )
end

function Persist.CreatePlayer(ply)
    local steamid = GetPlayerID(ply)
    
    http.Post(api .. "/player/create/" .. steamid, {},
        function(body, len, headers, code)
            local player = util.JSONToTable(body)
            -- Process newly created player data here
            return player
        end,
        function(error)
            -- Handle error
            print("Error creating player: ", error)
        end
    )
end

function Persist.SetPlayerVar(ply, var, value)
    local steamid = GetPlayerID(ply)

    -- Prepare the data as a JSON string
    local jsonData = util.TableToJSON({
        ["var"] = var,
        ["value"] = value
    })

    -- Set up the HTTP request
    HTTP({
        url = api .. "/player/" .. steamid .. "/set",
        method = "POST",
        headers = {
            
        },
        type = "application/json",
        body = jsonData, 
        success = function(code, body, headers)
            print("Player var set successfully: " .. body)
        end,
        failed = function(error)
            print("Error setting player var: " .. error)
        end
    })
end



function Persist.SavePlayer(ply, body)
    local steamid = GetPlayerID(ply)

    print("Saving player: ", body)

    http.Post(api .. "/player/" .. steamid .. "/save", 
        body,
        function(body, len, headers, code)
            -- Success callback
            print("Player saved successfully")
        end,
        function(error)
            -- Error callback
            print("Error saving player: ", error)
        end,
        {["Content-Type"] = "application/json"}
    )
end


function Persist.LoadFromDatabase(ply)
    local plyData = Persist.GetPlayer(ply, true)
end

    
function Persist.SaveToDatabase(ply)
    local plyData = {
        ["money"] = ply:GetNWInt("money")
    }

    BaseWars.Log("Saving player: " .. ply:Nick() .. " (" .. ply:SteamID() .. ")")

    Persist.SetPlayerVar(ply, "money", ply:GetNWInt("money"))
end

print(Persist.Test())