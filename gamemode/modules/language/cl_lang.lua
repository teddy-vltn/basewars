BaseWars.Languages = BaseWars.Languages or {}

function BaseWars.Languages.SetCached(value)
	local phrases = BaseWars.Languages[value]

    print("Setting language to " .. value)

    if not phrases then 
        value = BaseWars.Config.Globals.DefaultLanguage:upper()
        phrases = BaseWars.Languages[value]

        if not phrases then 
            value = "EN"
            phrases = BaseWars.Languages[value]

            if not phrases then 
                BaseWars.Log("YOU ARE THE BIGGEST RAT ON THIS PLANET, YOU HAVE NO LANGUAGE FILES!!!!!!!!!!!!!!!!!!")

                return
            end
        end
    end

    print("Set cached")

    BaseWars.Languages._Cached = phrases
end

function BaseWars.GetLocalPlayerLanguage()
    return GetConVar("gmod_language"):GetString():upper()
end


-- There a convar handler that should handle this, but at this point it's not initialized yet.
-- So it will double initialize the language, but it's not a big deal overall.
-- At least we are sure that the language is set.
local defaultLanguage = BaseWars.GetLocalPlayerLanguage()

BaseWars.Languages.SetCached( defaultLanguage )