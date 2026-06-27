
BaseWars.Config.MaxShopRecursiveDepth = 5

BaseWars.Config.Navigation = {
    {
        Name = BaseWars.Lang("Props"),
        Color = Color(255, 0, 0),
        Icon = "icon16/bricks.png",
        Panel = function(parent)
            return CreatePropsPanel(parent)
        end
    },
    {
        Name = BaseWars.Lang("Tools"),
        Color = Color(0, 0, 255),
        Icon = "icon16/cart.png",
        Panel = function(parent)
            return CreateToolsPanel(parent)
        end
    },
    {
        Name = BaseWars.Lang("Shop"),
        Color = Color(255, 255, 0),
        Icon = "icon16/cart.png",
        Panel = function(parent)
            return CreateBoutiquePanel(parent)
        end
    },
    {
        Name = BaseWars.Lang("Faction"),
        Color = Color(255, 0, 0),
        Icon = "icon16/box.png",
        Panel = function(parent)
            return CreateFactionPanel(parent)
        end
    },
    {
        Name = BaseWars.Lang("Leaderboard"),
        Color = Color(0, 255, 0),
        Icon = "icon16/award_star_gold_1.png",
        Panel = function(parent)
            return CreateLeaderboardPanel(parent)
        end
    },
    {
        Name = BaseWars.Lang("Settings"),
        Color = Color(0, 0, 255),
        Icon = "icon16/wrench.png",
        Panel = function(parent)
            return CreateSettingsPanel(parent)
        end
    },
}

BaseWars.Config.Sounds = {
    Accept = "buttons/button14.wav",
    Deny = "buttons/button11.wav",

    Click = "buttons/button15.wav",
    Hover = "buttons/lightswitch2.wav",

    Open = "doors/door1_move.wav",
    Close = "doors/door1_stop.wav",
}

BaseWars.Config.Colors = {
    GREEN = Color(0, 255, 0),
    RED = Color(255, 0, 0),
    BLUE = Color(0, 0, 255),
    WHITE = Color(255, 255, 255),
    YELLOW = Color(255, 255, 0),
}

BaseWars.Config.UI = {
    HeaderColor = Color(40, 40, 40, 110),
    HeaderLineColor = Color(200, 200, 200, 255),

    BodyColor = Color(255, 255, 255, 255),

    CloseBtnTextColor = Color(200, 50, 80, 255),
    TitleTextColor = Color(244, 244, 244, 255),

    Accent = Color(0, 0, 0, 255),

    h2 = Color(0, 0, 0, 255),
    h3 = Color(0, 0, 0, 255),
    h4 = Color(0, 0, 0, 255),
}

