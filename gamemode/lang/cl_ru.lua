BaseWars = BaseWars or {}

local L = {}

L.MoneyCurrency = "$"

L.Debug = "Отладка"
L.DebugIsEnabled = "Режим отладки включен."

L.Error = "Ошибка"
L.AnErrorOccured = "Произошла ошибка."
L.AnErrorOccuredWhileLoadingData = "Произошла ошибка при загрузке ваших данных. Пожалуйста, свяжитесь с администратором."
L.AnErrorOccuredWhileSavingData = "Произошла ошибка при сохранении ваших данных. Пожалуйста, свяжитесь с администратором."

L.InvalidPlayer = "Неверный игрок"

L.Props = "Объекты"
L.Entities = "Сущности"
L.Tools = "Инструменты"
L.Leaderboard = "Таблица лидеров"
L.Shop = "Магазин"
L.Settings = "Настройки"

L.Money = "Деньги"
L.PayOut = "Выплата"
L.Level = "Уровень"
L.XP = "Опыт"
L.XPToNextLevel = "Опыт до следующего уровня"

L.Printer = "Принтер"
L.Generator = "Генератор"
L.Turret = "Турель"
L.Tesla = "Тесла"
L.Dispenser = "Дозатор"

L.Health = "Здоровье"
L.Armor = "Броня"
L.Ammo = "Боеприпасы"

L.Faction = "Фракция"
L.FactionPassword = "Пароль фракции"
L.FactionName = "Название фракции"
L.FactionDescription = "Описание фракции"
L.FactionColor = "Цвет фракции"
L.FactionLeader = "Лидер фракции"
L.FactionMembers = "Члены фракции"
L.FactionCreate = "Создать фракцию"
L.FactionJoin = "Присоединиться к фракции"
L.FactionLeave = "Покинуть фракцию"
L.FactionKick = "Исключить из фракции"
L.FactionPasswordIncorrect = "Пароль неверный."

L.Buy = "Купить"
L.Sell = "Продать"
L.Upgrade = "Улучшить"

L.Refresh = "Обновить"

L.Search = "Поиск"

L.Optionnal = "Необязательно"

L.RaidableEntities = "Объекты для рейда"

L.Welcome = "Добро пожаловать в %s!"
L.CreatedFaction = "Вы создали фракцию %s."
L.FactionAlreadyExists = "Фракция %s уже существует."
L.FactionLeft = "Вы покинули фракцию %s."
L.FactionDeleted = "Вы удалили фракцию %s."
L.FactionKicked = "Вас исключили из фракции %s."
L.FactionCannotKickOwner = "Вы не можете исключить владельца фракции."
L.FactionKickedPlayer = "Вы исключили %s из фракции."
L.FactionNotMember = "Вы не являетесь членом фракции."
L.FactionPlayerNotMemberOfThisFaction = "%s не является членом фракции."
L.FactionNotOwner = "Вы не являетесь владельцем фракции."
L.FactionAlreadyMember = "Вы уже являетесь членом фракции."
L.FactionDoesntExist = "Фракция %s не существует."
L.FactionCantCreate = "Вы не можете создать фракцию."
L.FactionCantJoin = "Вы не можете присоединиться к фракции %s."
L.FactionCantLeave = "Вы не можете покинуть фракцию %s."
L.FactionCantKick = "Вы не можете исключить %s из фракции."
L.JoinedFaction = "Вы присоединились к фракции %s."
L.NotInFaction = "Вы не в фракции."
L.NameCannotBeEmpty = "Имя не может быть пустым."
L.NameIsTooShort = "Имя слишком короткое. Минимум 3 символа."
L.NameIsTooLong = "Имя слишком длинное. Максимум 32 символа."
L.PasswordIsTooLong = "Пароль слишком длинный. Максимум 32 символа."
L.NameContainsInvalidCharacters = "Имя содержит недопустимые символы."
L.ColorCannotBeEmpty = "Цвет не может быть пустым."
L.IconCannotBeEmpty = "Иконка не может быть пустой."

L.PlayerPayOut = "Вам выплачено %s."
L.PlayerPayOutError = "Вы не можете получить выплату сейчас."

BaseWars.RegisterLanguage("RU", L)
