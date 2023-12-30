BaseWars.Persist = BaseWars.Persist or {}
local Persist = BaseWars.Persist

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

function Persist.GetPlayer(ply, retry)
    if retry == nil then retry = true end
    local steamid = GetPlayerID(ply)

    print("SteamID: ", steamid)

    http.Fetch(api .. "/player/" .. steamid,
        function(body, len, headers, code)
            if code == 404 then
                local data = util.JSONToTable(body)
                if data.code == '2' then
                    -- Player not found, create a new player
                    print(Persist.CreatePlayer(ply))
                end
            else
                local player = util.JSONToTable(body)
                -- Process player data here
                PrintTable(player)
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
            print("New Player Created: ", player)
        end,
        function(error)
            -- Handle error
            print("Error creating player: ", error)
        end
    )
end

function Persist.SetPlayerVar(ply, var, value)
    local steamid = GetPlayerID(ply)
    local data = {
        [var] = value
    }

    http.Post(api .. "/player/" .. steamid .. "/set", 
        data,
        function(body, len, headers, code)
            -- Success callback
            print("Variable updated successfully")
        end,
        function(error)
            -- Error callback
            print("Error updating player variable: ", error)
        end
    )
end

print(Persist.GetPlayers())
print(Persist.Test())
