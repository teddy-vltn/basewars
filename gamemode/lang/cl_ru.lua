BaseWars = BaseWars or {}

local L = {}

L.MoneyCurrency = "$"

L.Debug = "Отладка"
L.DebugIsEnabled = "Режим отладки включен."

L.Yes = "Да"
L.No = "Нет"

L.Error = "Ошибка"
L.Success = "Успех"
L.Submit = "Отправить"
L.Page = "Страница"
L.AreYouSure = "Вы уверены?"
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

L.Health = "Здоровье"
L.Armor = "Броня"
L.Ammo = "Боеприпасы"

L.Bank = "Банк"

L.Power = "Энергия"
L.PowerCapacity = "Емкость энергии"
L.PowerConsumption = "Потребление энергии"
L.PowerGeneration = "Генерация энергии"

L.Name = "Имя"
L.Color = "Цвет"
L.Icon = "Иконка"

L.Members = "Члены"

L.Next = "Следующий"
L.Previous = "Предыдущий"
L.Current = "Текущий"

L.PayOutForPlaying = "Вам выплачено %s за игру на сервере."

L.Faction = "Фракция"
L.FactionPassword = "Пароль фракции"
L.FactionName = "Название фракции"
L.FactionDescription = "Описание фракции"
L.FactionColor = "Цвет фракции"
L.FactionLeader = "Лидер фракции"
L.FactionMembers = "Члены фракции"
L.FactionCreate = "Создать фракцию"
L.FactionJoin = "Вступить в фракцию"
L.FactionLeave = "Покинуть фракцию"
L.FactionKick = "Исключить из фракции"
L.FactionPasswordNeeded = "Требуется пароль"
L.FactionPasswordIncorrect = "Неверный пароль."
L.FactionPleaseInputPassword = "Пожалуйста, введите пароль фракции."
L.FactionLeaveAreYouSure = "Вы уверены, что хотите покинуть фракцию %s?"

L.Cost = "Стоимость"
L.Value = "Значение"
L.Buy = "Купить"
L.Sell = "Продать"
L.Upgrade = "Улучшить"
L.UpgradeLevel = "Уровень улучшения"

L.AreYouSureYouWannaBuy = "Вы уверены, что хотите купить %s за %s?"
L.AreYouSureYouWannaSell = "Вы уверены, что хотите продать %s за %s?"
L.AreYouSureYouWannaUpgrade = "Вы уверены, что хотите улучшить %s за %s?"

L.NotEnoughMoneyToBuyUpgrade = "У вас недостаточно денег для покупки этого улучшения."
L.CantSellThisEntity = "Вы не можете продать эту сущность."
L.CantSellOtherPlayersEntities = "Вы не можете продавать сущности других игроков."

L.Refresh = "Обновить"

L.Search = "Поиск"

L.Optionnal = "Необязательно"

L.RaidableEntities = "Можно атаковать сущности"

L.Welcome = "Добро пожаловать в %s !"
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

L.Raid = "Рейд"
L.Raiding = "Рейд"
L.RaidingSuccess = "Вы успешно провели рейд на %s."
L.RaidingFailed = "Вам не удалось провести рейд на %s."
L.RaidingSomeone = "На вас нападают %s."
L.RaidingEnded = "Рейд между %s и %s закончился."
L.RaidingStarted = "Рейд между %s и %s начался."
L.RaidingWillBeginIn = "Рейд между %s и %s начнется через %s."
L.RaidingAttackerLostTickets = "Атакующий потерял все свои билеты."
L.RaidingAttackerHasLostSomeTickets = "Атакующий потерял %s билетов."
L.RaidingTimeLeft = "Осталось времени: %s"
L.RaidingAlready = "Вы уже нападаете на %s."
L.RaidingIsOnCooldown = "Вы не можете сейчас нападать на %s."
L.RaidingIsOnCooldownFor = "Вы не можете нападать на %s в течение %s."
L.RaidingIsOnCooldownForAll = "Вы не можете нападать ни на кого в течение %s."

L.Research = "Исследование"
L.Researching = "Исследование"
L.ResearchingSuccess = "Вы успешно исследовали %s."
L.ResearchingFailed = "Вам не удалось исследовать %s."
L.ResearchingTimeLeft = "Осталось времени: %s"

L.EntityHasBeenBought = "Вы купили сущность (%s) за %s."
L.EntityHasBeenDestroyed = "Ваша сущность (%s) была уничтожена. Вам выплачено %s."
L.EntityHasBeenDestroyedBy = "Ваша сущность (%s) была уничтожена %s. Вам выплачено %s."
L.EntityHasBeenDestroyedBySomeone = "Ваша сущность (%s) была уничтожена кем-то. Вам выплачено %s."

L.TooFarAwayToInteract = "Вы слишком далеко, чтобы взаимодействовать с этой сущностью."

L.SpawnMenu = "Меню появления"
L.UpgradedEntity = "Вы улучшили вашу сущность (%s) до уровня %s."
L.SoldEntity = "Вы продали вашу сущность (%s) за %s."
L.BoughtEntity = "Вы купили сущность (%s) за %s."
L.LimitReached = "Вы достигли лимита для этой сущности. %s / %s"
L.EntityDoesntExist = "Сущность (%s) не существует??? Пожалуйста, свяжитесь с администратором."
L.SuccessfullySpawnedEntity = "Успешно создана сущность."
L.NotEnoughMoney = "У вас недостаточно денег, чтобы купить эту сущность."
L.NotEnoughLevel = "У вас недостаточный уровень, чтобы купить эту сущность."

L.BoughtWeapon = "Вы купили оружие (%s) за %s."
L.AutoBuy = "Автопокупка"
L.AutoBuyAreYouSure = "Вы уверены, что хотите включить автопокупку для этого оружия?"
L.ActivatedBuyOnRespawn = "Вы активировали покупку при возрождении для оружия (%s)."
L.DeactivatedBuyOnRespawn = "Вы деактивировали покупку при возрождении для всех оружий."

L.ActivatedSpawnpoint = "Теперь вы будете возрождаться в этой точке возрождения."
L.DeactivatedSpawnpoint = "Вы больше не будете возрождаться в этой точке возрождения."

L.YouMustBeAPlayerToUseThis = "Вы должны быть игроком, чтобы использовать это."

L.PickedMoney = "Вы подобрали %s."
L.PickedMoneyError = "Вы не можете подобрать деньги прямо сейчас."

L.PlayerPayOut = "Вам выплачено %s."
L.PlayerPayOutError = "Вы не можете получить выплату прямо сейчас."

-- General shop translations
L.Printer = "Принтер"
L.Printers = "Принтеры"
L.Generator = "Генератор"
L.Generators = "Генераторы"
L.Turret = "Турель"
L.Turrets = "Турели"
L.Tesla = "Тесла"
L.Teslas = "Теслы"
L.Dispenser = "Дозатор"
L.Dispensers = "Дозаторы"
L.Basic = "Базовый"
L.Advanced = "Продвинутый"
L.Elite = "Элитный"
L.Basics = "Основы"
L.Fun = "Развлечения"
L.Weapons = "Оружие"
L.General = "Общее"
L.Farm = "Ферма"
L.VIP = "VIP"
L.Pistol = "Пистолет"
L.Pistols = "Пистолеты"
L.Rifle = "Винтовка"
L.Rifles = "Винтовки"
L.Shotgun = "Дробовик"
L.Shotguns = "Дробовики"
L.Sniper = "Снайпер"
L.Snipers = "Снайперы"
L.Machinegun = "Пулемет"
L.Machineguns = "Пулеметы"
L.Explosive = "Взрывчатка"
L.Explosives = "Взрывчатые вещества"
L.Melee = "Ближний бой"
L.Spawn = "Появление"
L.SpawnPoint = "Точка появления"

BaseWars.RegisterLanguage("RU", L)