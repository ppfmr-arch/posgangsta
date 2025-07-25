-- Люди часто копируют профессии. Когда они это делают, таблица GM больше не существует.
-- Эта строка позволяет коду профессий работать как внутри, так и вне файлов игрового режима.
-- Не копируйте эту строку в свой код.
local GAMEMODE = GAMEMODE or GM
--[[--------------------------------------------------------
Стандартные команды. Пожалуйста, не редактируйте этот файл. Используйте вместо этого дополнение darkrpmod.
--------------------------------------------------------]]
TEAM_CITIZEN = DarkRP.createJob("Гражданин", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/player/Group01/Female_01.mdl",
        "models/player/Group01/Female_02.mdl",
        "models/player/Group01/Female_03.mdl",
        "models/player/Group01/Female_04.mdl",
        "models/player/Group01/Female_06.mdl",
        "models/player/group01/male_01.mdl",
        "models/player/Group01/Male_02.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/Male_04.mdl",
        "models/player/Group01/Male_05.mdl",
        "models/player/Group01/Male_06.mdl",
        "models/player/Group01/Male_07.mdl",
        "models/player/Group01/Male_08.mdl",
        "models/player/Group01/Male_09.mdl"
    },
    description = [[Гражданин — это самый базовый уровень общества, который вы можете занимать, не будучи бомжом. У вас нет определённой роли в жизни города.]],
    weapons = {},
    command = "citizen",
    max = 0,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Гражданские",
})

TEAM_POLICE = DarkRP.createJob("Полицейский", {
    color = Color(25, 25, 170, 255),
    model = {"models/player/police.mdl", "models/player/police_fem.mdl"},
    description = [[Защитник каждого гражданина, живущего в городе.
        Вы имеете право арестовывать преступников и защищать невиновных.
        Ударьте игрока дубинкой для ареста, чтобы посадить его в тюрьму.
        Ударьте игрока электродубинкой, чтобы он научился слушаться закон.
        Таран может выбить дверь преступника при наличии ордера на арест.
        Таран также может разморозить замороженные предметы (если включено).
        Введите /wanted <имя>, чтобы объявить игрока в розыск.]],
    weapons = {"arrest_stick", "unarrest_stick", "m9k_usp", "stunstick", "door_ram", "weaponchecker", "m9k_m16a4_acog"},
    command = "cp",
    max = 4,
    salary = GAMEMODE.Config.normalsalary * 1.45,
    admin = 0,
    vote = false,
    hasLicense = true,
    ammo = {
        ["pistol"] = 60,
    },
    category = "Правоохранительные органы",
})

TEAM_GANG = DarkRP.createJob("YellowTrusGetto", {
    color = Color(255, 255, 0, 255),
    model = {
        "models/gtasa/lsv1pm.mdl",
        "models/gtasa/lsv2pm.mdl",
        "models/gtasa/lsv3pm.mdl"},
    description = [[Самый низкий преступник.
        Обычно гангстер работает на босса мафии, который управляет преступной семьёй.
        Босс мафии ставит вам задачи, и вы должны их выполнять, иначе вас могут наказать.]],
    weapons = {},
    command = "gangster",
    max = 3,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Бандиты",
})

TEAM_KABLUK = DarkRP.createJob("KablukStreetGansta", {
    color = Color(255, 0, 255, 255),
    model = {
        "models/sentry/senfembal/sentrybal3male1pm.mdl",
        "models/sentry/senfembal/sentrybal2male3pm.mdl",
        "models/sentry/senfembal/sentrybal1male3pm.mdl"
    },
    description = [[Самый низкий преступник.
        Обычно гангстер работает на босса мафии, который управляет преступной семьёй.
        Босс мафии ставит вам задачи, и вы должны их выполнять, иначе вас могут наказать.]],
    weapons = {},
    command = "kablukstreetgansta",
    max = 3,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Бандиты",
})

TEAM_GOMODRILL = DarkRP.createJob("Gomodrill", {
    color = Color(139, 69, 19, 255), -- коричневый цвет
    model = "models/player/chimp/chimp.mdl",
    description = [[Гомодрил.]],
    weapons = {},
    command = "gomodrill",
    max = 3,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Бандиты",
})


TEAM_CHIEF = DarkRP.createJob("Шеф полиции", {
    color = Color(20, 20, 255, 255),
    model = "models/player/combine_soldier_prisonguard.mdl",
    description = [[Шеф — глава полицейского подразделения.
        Координируйте работу полиции для поддержания порядка в городе.
        Ударьте игрока дубинкой для ареста, чтобы посадить его в тюрьму.
        Ударьте игрока электродубинкой, чтобы он научился слушаться закон.
        Таран может выбить дверь преступника при наличии ордера на арест.
        Введите /wanted <имя>, чтобы объявить игрока в розыск.
        Введите /jailpos для установки позиции тюрьмы.]],
    weapons = {"arrest_stick", "unarrest_stick", "m9k_m29satan", "stunstick", "door_ram", "weaponchecker", "m9k_m4a4"},
    command = "chief",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 1.67,
    admin = 0,
    vote = false,
    hasLicense = true,
    chief = true,
    NeedToChangeFrom = TEAM_POLICE,
    ammo = {
        ["pistol"] = 60,
    },
    category = "Правоохранительные органы",
})

TEAM_MAYOR = DarkRP.createJob("Мэр", {
    color = Color(150, 20, 20, 255),
    model = "models/player/breen.mdl",
    description = [[Мэр города создаёт законы для управления городом.
    Если вы мэр, вы можете создавать и одобрять ордера.
    Введите /wanted <имя> для выдачи ордера на игрока.
    Введите /jailpos для установки позиции тюрьмы.
    Введите /lockdown для начала комендантского часа.
    Все должны быть в помещениях во время комендантского часа.
    Полиция патрулирует город.
    /unlockdown для отмены комендантского часа.]],
    weapons = {},
    command = "mayor",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 1.89,
    admin = 0,
    vote = true,
    hasLicense = false,
    mayor = true,
    category = "Правоохранительные органы",
})

if not DarkRP.disabledDefaults["modules"]["hungermod"] then
    TEAM_COOK = DarkRP.createJob("Повар", {
        color = Color(238, 99, 99, 255),
        model = "models/player/mossman.mdl",
        description = [[Как повар, вы обязаны кормить других жителей города.
            Вы можете купить микроволновку и продавать приготовленную еду:
            /buymicrowave]],
        weapons = {},
        command = "cook",
        max = 2,
        salary = 45,
        admin = 0,
        vote = false,
        hasLicense = false,
        cook = true
    })
end

-- Совместимость, если стандартные команды отключены
TEAM_CITIZEN = TEAM_CITIZEN  or -1
TEAM_POLICE  = TEAM_POLICE   or -1
TEAM_GANG    = TEAM_GANG     or -1
TEAM_MOB     = TEAM_MOB      or -1
TEAM_GUN     = TEAM_GUN      or -1
TEAM_MEDIC   = TEAM_MEDIC    or -1
TEAM_CHIEF   = TEAM_CHIEF    or -1
TEAM_MAYOR   = TEAM_MAYOR    or -1
TEAM_HOBO    = TEAM_HOBO     or -1
TEAM_COOK    = TEAM_COOK     or -1

-- Группы дверей
AddDoorGroup("Только полиция и мэр", TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR)
AddDoorGroup("Только оружейник", TEAM_GUN)


-- Повестки
DarkRP.createAgenda("Повестка бандитов", TEAM_MOB, {TEAM_GANG})
DarkRP.createAgenda("Повестка полиции", {TEAM_MAYOR, TEAM_CHIEF}, {TEAM_POLICE})

-- Групповые чаты
DarkRP.createGroupChat(function(ply) return ply:isCP() end)
DarkRP.createGroupChat(TEAM_MOB, TEAM_GANG)
DarkRP.createGroupChat(function(listener, ply) return not ply or ply:Team() == listener:Team() end)

-- Команда по умолчанию при первом входе
GAMEMODE.DefaultTeam = TEAM_CITIZEN

-- Команды, относящиеся к полиции
GAMEMODE.CivilProtection = {
    [TEAM_POLICE] = true,
    [TEAM_CHIEF] = true,
    [TEAM_MAYOR] = true,
}

-- Команда наёмников
DarkRP.addHitmanTeam(TEAM_MOB)

-- Группы для демота
DarkRP.createDemoteGroup("Полиция", {TEAM_POLICE, TEAM_CHIEF})
DarkRP.createDemoteGroup("Бандиты", {TEAM_GANG, TEAM_MOB})

-- Категории по умолчанию
DarkRP.createCategory{
    name = "Гражданские",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Правоохранительные органы",
    categorises = "jobs",
    startExpanded = true,
    color = Color(25, 25, 170, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 101,
}

DarkRP.createCategory{
    name = "Бандиты",
    categorises = "jobs",
    startExpanded = true,
    color = Color(75, 75, 75, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 101,
}

DarkRP.createCategory{
    name = "Другое",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 255,
}
