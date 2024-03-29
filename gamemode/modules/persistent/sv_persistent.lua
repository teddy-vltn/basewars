BaseWars.Persist = BaseWars.Persist or {}
local Persist = BaseWars.Persist

local API_URL = "http://172.20.10.2:5000"

local function buildEndpoint(endpoint)
    return API_URL .. endpoint
end

function Persist.HTTP(endpoint, method, data, headers, callback)
    local url = buildEndpoint(endpoint)
    local data = data and util.TableToJSON(data) or nil

    HTTP({
        url = url,
        method = method,
        headers = headers or {},
        type = "application/json; charset=utf-8",
        body = data,
        success = function(code, body, headers)
            callback(body)
        end,
        failed = function(reason)
            BaseWars.Log("HTTP request failed: " .. reason .. " (" .. url .. ")" )

            callback(nil)
        end
    })
end

function Persist.Get(endpoint, callback)
    Persist.HTTP(endpoint, "GET", nil, nil, callback)
end

function Persist.Post(endpoint, data, callback)
    Persist.HTTP(endpoint, "POST", data, {
        ["Content-Type"] = "application/json"
    }, callback)
end

function Persist.Test()
    Persist.Get("/test", function(body)
        BaseWars.Log(body)
    end)
end

function Persist.CreatePlayer(ply, callback)
    Persist.Post("/player/" .. ply:SteamID64() .. "/create", {}, function(body)
        callback(util.JSONToTable(body))
    end)
end

function Persist.GetPlayerData(ply, callback)

    Persist.Get("/player/" .. ply:SteamID64(), function(body)

        if not body then
            callback(nil)
            return
        end

        local data = util.JSONToTable(body)

        if data.code == "2" then
            Persist.CreatePlayer(ply, callback)
        else
            callback(data)
        end 
    end)
end

function Persist.SetPlayerVariable(ply, var, value, callback)

    -- {"var": "money", "value": 100}
    local data = {
        var = var,
        value = value
    }

    Persist.Post("/player/" .. ply:SteamID64() .. "/set", data, function(body)
        callback(util.JSONToTable(body))
    end)
end

function Persist.SaveToDatabase(ply)

    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    -- Check if data has not been flagged as corrupted
    if ply.CorruptedData then 
        
        BaseWars.Log("Player " .. ply:Nick() .. " (" .. ply:SteamID() .. ") has corrupted data. Skipping save.")
        BaseWars.Notify.Send(ply, BaseWars.Lang("Error"),  BaseWars.Lang("AnErrorOccuredWhileSavingData"), Color(255, 0, 0))


        return 
    end

    -- money = ?, level = ?, xp = ?, lastseen = ?, playtime = ?
    local data = {
        money = ply:GetMoney(),
        level = ply:GetLevel(),
        xp = ply:GetXP(),
        lastseen = os.time(),
        playtime = 0
    }

    Persist.Post("/player/" .. ply:SteamID64() .. "/save", data, function(body)
        if not body then
            BaseWars.Log("Failed to save player " .. ply:Nick() .. " (" .. ply:SteamID() .. ") to database.")

            BaseWars.Notify.Send(ply, BaseWars.Lang("Error"), BaseWars.Lang("AnErrorOccuredWhileSavingData"), Color(255, 0, 0))

            ply:Freeze(true)
            return
        end

        BaseWars.Log("Saved player " .. ply:Nick() .. " (" .. ply:SteamID() .. ") to database.")
    end)
end

function Persist.GetTopPlayers(page, callback)
    Persist.Get("/top/money/" .. page, function(body)
        callback(util.JSONToTable(body))
    end)
end

local function test_endpoint_pcall()
    local success, err = pcall(function()
        Persist.Get("/", function(body)
            print(body)
        end)
    end)

    if not success then
        print(err)
    end
end

test_endpoint_pcall()

