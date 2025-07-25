DarkRP.createShipment("Desert eagle", {
    model = "models/weapons/w_pist_deagle.mdl",
    entity = "swb_deagle",
    price = 21500,
    amount = 10,
    separate = true,
    pricesep = 2500,
    noship = true,
    allowed = {TEAM_GUN},
    category = "Pistols",
})

DarkRP.createShipment("Fiveseven", {
    model = "models/weapons/w_pist_fiveseven.mdl",
    entity = "swb_fiveseven",
    price = 10000,
    amount = 10,
    separate = true,
    pricesep = 2150,
    noship = true,
    allowed = {TEAM_GUN},
    category = "Pistols",
})

DarkRP.createShipment("Glock", {
    model = "models/weapons/w_pist_glock18.mdl",
    entity = "swb_glock",
    price = 15000,
    amount = 10,
    separate = true,
    pricesep = 2500,
    noship = true,
    allowed = {TEAM_GUN},
    category = "Pistols",
})

DarkRP.createShipment("P228", {
    model = "models/weapons/w_pist_p228.mdl",
    entity = "swb_p228",
    price = 17000,
    amount = 10,
    separate = true,
    pricesep = 2100,
    noship = true,
    allowed = {TEAM_GUN},
    category = "Pistols",
})

DarkRP.createShipment("AK47", {
    model = "models/weapons/w_rif_ak47.mdl",
    entity = "swb_ak47",
    price = 245000,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles",
})

DarkRP.createShipment("MP5", {
    model = "models/weapons/w_smg_mp5.mdl",
    entity = "swb_mp5",
    price = 140000,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles",
})

DarkRP.createShipment("M4", {
    model = "models/weapons/w_rif_m4a1.mdl",
    entity = "swb_m4a1",
    price = 245000,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Rifles",
})

DarkRP.createShipment("Mac 10", {
    model = "models/weapons/w_smg_mac10.mdl",
    entity = "swb_mac10",
    price = 145000,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_GUN}
})

DarkRP.createShipment("Pump shotgun", {
    model = "models/weapons/w_shot_m3super90.mdl",
    entity = "swb_m3super90",
    price = 175000,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Shotguns",
})

DarkRP.createShipment("Sniper rifle", {
    model = "models/weapons/w_snip_g3sg1.mdl",
    entity = "swb_g3sg1",
    price = 375000,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_GUN},
    category = "Snipers",
})

DarkRP.createEntity("Кликер денег BRONZE", { -- The name of the money clicker
    ent = "money_clicker", -- Do not change this class
    model = "models/props_c17/consolebox01a.mdl", -- Do not change this model
    price = 10000,
    max = 4,
    cmd = "buymoneyclicker", -- This has to be a unique command for each Money Clicker
    mClickerInfo = {
        pointsPerCycle = 10,     -- How many points you get per cycle
        moneyPerCycle = 200,       -- How much money you get per cycle
        maxPoints = 50000,        -- The base points capacity
        maxMoney = 5000000,         -- The base money capacity
        health = 100,            -- How much health it has, a crowbar deals 25 damage
        indestructible = false,  -- Can not be destroyed
        repairHealthCost = 1000,  -- Repair health price in points
        maxCycles = 2000,         -- Amount of cycles before it breaks, set to 0 to disable
        repairBrokenCost = 1000, -- Repair price in money for when the clicker breaks down

        -- The stats the clickers have per upgrade level, each starts at level 1
        -- For example, when you first spawn in a clicker, it will auto click at
        -- a rate of 0 clicks/s which means no auto clicking at all.
        -- With no upgrades to click power, it will increase the progress by 10
        -- each click.
        -- The first entry for the prices is for the second upgrade, as the first
        -- upgrade is the one you have when the clicker is spawned.
        upgrades = {
            autoClick = {
                name = "Professional Idler",     -- The display name of the upgrade
                stats = { 5, 10, 15, 25, 30 },       -- Clicks per second, set per upgrade level
                prices = { 200, 300, 400, 500 }, -- Prices for the second upgrade and up (starts with first upgrade)
            },
            clickPower = {
                name = "Power Clicker",         -- The display name of the upgrade
                stats = { 10, 12, 14, 16 },     -- Progress per click, set per upgrade level
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
            cooling = {
                name = "Cooler Master",         -- The display name of the upgrade
                stats = { 5, 10, 15, 20 },   -- Cooling per 0.25 seconds. For reference, max heat is 100
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
            storage = {
                name = "Hardcore Hoarder",      -- The display name of the upgrade
                stats = { 1, 2, 3, 4 },         -- Storage modifier, starts at 1x storage
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
        },

        enableHeat = true, -- Make the clicker heat up when clicking it too much, will not blow it up but will disable it for a while
        heatPerClick = 20, -- Max heat is 100

    	colorPrimary = Color(127, 63, 63),  -- The primary color that is used for the entire model
    	colorSecondary = Color(255, 87, 34), -- The secondary color, AKA accent color, used for details
        colorText = Color(255, 255, 255),    -- The color of the text
        colorHealth = Color(255, 100, 100),  -- The color of the health icon
    },
})

DarkRP.createEntity("Кликер денег SEREBRO", { -- The name of the money clicker
    ent = "money_clicker", -- Do not change this class
    model = "models/props_c17/consolebox01a.mdl", -- Do not change this model
    price = 5000000,
    max = 2,
    cmd = "buymoneyclickersrb", -- This has to be a unique command for each Money Clicker
    mClickerInfo = {
        pointsPerCycle = 10,     -- How many points you get per cycle
        moneyPerCycle = 2000,       -- How much money you get per cycle
        maxPoints = 50000,        -- The base points capacity
        maxMoney = 5000000,         -- The base money capacity
        health = 500,            -- How much health it has, a crowbar deals 25 damage
        indestructible = false,  -- Can not be destroyed
        repairHealthCost = 1000,  -- Repair health price in points
        maxCycles = 5000,         -- Amount of cycles before it breaks, set to 0 to disable
        repairBrokenCost = 1000, -- Repair price in money for when the clicker breaks down

        -- The stats the clickers have per upgrade level, each starts at level 1
        -- For example, when you first spawn in a clicker, it will auto click at
        -- a rate of 0 clicks/s which means no auto clicking at all.
        -- With no upgrades to click power, it will increase the progress by 10
        -- each click.
        -- The first entry for the prices is for the second upgrade, as the first
        -- upgrade is the one you have when the clicker is spawned.
        upgrades = {
            autoClick = {
                name = "Professional Idler",     -- The display name of the upgrade
                stats = { 10, 20, 30, 35, 40 },       -- Clicks per second, set per upgrade level
                prices = { 200, 300, 400, 500 }, -- Prices for the second upgrade and up (starts with first upgrade)
            },
            clickPower = {
                name = "Power Clicker",         -- The display name of the upgrade
                stats = { 20, 25, 30, 35 },     -- Progress per click, set per upgrade level
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
            cooling = {
                name = "Cooler Master",         -- The display name of the upgrade
                stats = { 10, 30, 40, 80 },   -- Cooling per 0.25 seconds. For reference, max heat is 100
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
            storage = {
                name = "Hardcore Hoarder",      -- The display name of the upgrade
                stats = { 1, 2, 3, 4 },         -- Storage modifier, starts at 1x storage
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
        },

        enableHeat = true, -- Make the clicker heat up when clicking it too much, will not blow it up but will disable it for a while
        heatPerClick = 20, -- Max heat is 100

    	colorPrimary = Color(255, 255, 255),  -- The primary color that is used for the entire model
    	colorSecondary = Color(255, 87, 34), -- The secondary color, AKA accent color, used for details
        colorText = Color(0, 0, 0),    -- The color of the text
        colorHealth = Color(255, 100, 100),  -- The color of the health icon
    },
})

DarkRP.createEntity("Кликер денег GOLD", { -- The name of the money clicker
    ent = "money_clicker", -- Do not change this class
    model = "models/props_c17/consolebox01a.mdl", -- Do not change this model
    price = 30000000,
    max = 1,
    cmd = "buymoneyclickergld", -- This has to be a unique command for each Money Clicker
    mClickerInfo = {
        pointsPerCycle = 5,     -- How many points you get per cycle
        moneyPerCycle = 5000,       -- How much money you get per cycle
        maxPoints = 50000,        -- The base points capacity
        maxMoney = 50000000,         -- The base money capacity
        health = 1000,            -- How much health it has, a crowbar deals 25 damage
        indestructible = false,  -- Can not be destroyed
        repairHealthCost = 1000,  -- Repair health price in points
        maxCycles = 2500,         -- Amount of cycles before it breaks, set to 0 to disable
        repairBrokenCost = 1000, -- Repair price in money for when the clicker breaks down

        -- The stats the clickers have per upgrade level, each starts at level 1
        -- For example, when you first spawn in a clicker, it will auto click at
        -- a rate of 0 clicks/s which means no auto clicking at all.
        -- With no upgrades to click power, it will increase the progress by 10
        -- each click.
        -- The first entry for the prices is for the second upgrade, as the first
        -- upgrade is the one you have when the clicker is spawned.
        upgrades = {
            autoClick = {
                name = "Professional Idler",     -- The display name of the upgrade
                stats = { 20, 40, 60, 70, 90 },       -- Clicks per second, set per upgrade level
                prices = { 200, 300, 400, 500 }, -- Prices for the second upgrade and up (starts with first upgrade)
            },
            clickPower = {
                name = "Power Clicker",         -- The display name of the upgrade
                stats = { 20, 25, 30, 35 },     -- Progress per click, set per upgrade level
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
            cooling = {
                name = "Cooler Master",         -- The display name of the upgrade
                stats = { 250, 500, 1000, 2000 },   -- Cooling per 0.25 seconds. For reference, max heat is 100
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
            storage = {
                name = "Hardcore Hoarder",      -- The display name of the upgrade
                stats = { 1, 2, 3, 4 },         -- Storage modifier, starts at 1x storage
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
        },

        enableHeat = true, -- Make the clicker heat up when clicking it too much, will not blow it up but will disable it for a while
        heatPerClick = 20, -- Max heat is 100

    	colorPrimary = Color(255, 191, 0),  -- The primary color that is used for the entire model
    	colorSecondary = Color(255, 87, 34), -- The secondary color, AKA accent color, used for details
        colorText = Color(255, 255, 255),    -- The color of the text
        colorHealth = Color(255, 100, 100),  -- The color of the health icon
    },
})

DarkRP.createEntity("Кликер денег RUBY", { -- The name of the money clicker
    ent = "money_clicker", -- Do not change this class
    model = "models/props_c17/consolebox01a.mdl", -- Do not change this model
    price = 750000000,
    max = 1,
    cmd = "buymoneyclickerrb", -- This has to be a unique command for each Money Clicker
    mClickerInfo = {
        pointsPerCycle = 5,     -- How many points you get per cycle
        moneyPerCycle = 50000,       -- How much money you get per cycle
        maxPoints = 50000,        -- The base points capacity
        maxMoney = 50000000,         -- The base money capacity
        health = 1000,            -- How much health it has, a crowbar deals 25 damage
        indestructible = false,  -- Can not be destroyed
        repairHealthCost = 1000,  -- Repair health price in points
        maxCycles = 25000,         -- Amount of cycles before it breaks, set to 0 to disable
        repairBrokenCost = 1000, -- Repair price in money for when the clicker breaks down

        -- The stats the clickers have per upgrade level, each starts at level 1
        -- For example, when you first spawn in a clicker, it will auto click at
        -- a rate of 0 clicks/s which means no auto clicking at all.
        -- With no upgrades to click power, it will increase the progress by 10
        -- each click.
        -- The first entry for the prices is for the second upgrade, as the first
        -- upgrade is the one you have when the clicker is spawned.
        upgrades = {
            autoClick = {
                name = "Professional Idler",     -- The display name of the upgrade
                stats = { 200, 400, 600, 700, 900 },       -- Clicks per second, set per upgrade level
                prices = { 200, 300, 400, 500 }, -- Prices for the second upgrade and up (starts with first upgrade)
            },
            clickPower = {
                name = "Power Clicker",         -- The display name of the upgrade
                stats = { 200, 250, 300, 350 },     -- Progress per click, set per upgrade level
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
            cooling = {
                name = "Cooler Master",         -- The display name of the upgrade
                stats = { 25000000000, 50000000000, 100000000000, 2000000000000 },   -- Cooling per 0.25 seconds. For reference, max heat is 100
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
            storage = {
                name = "Hardcore Hoarder",      -- The display name of the upgrade
                stats = { 1, 2, 3, 4 },         -- Storage modifier, starts at 1x storage
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
        },

        enableHeat = true, -- Make the clicker heat up when clicking it too much, will not blow it up but will disable it for a while
        heatPerClick = 20, -- Max heat is 100

    	colorPrimary = Color(255, 0, 97),  -- The primary color that is used for the entire model
    	colorSecondary = Color(255, 87, 34), -- The secondary color, AKA accent color, used for details
        colorText = Color(255, 255, 255),    -- The color of the text
        colorHealth = Color(255, 100, 100),  -- The color of the health icon
    },
})

DarkRP.createCategory{
    name = "Other",
    categorises = "entities",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 255,
}

DarkRP.createCategory{
    name = "Other",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 255,
}

DarkRP.createCategory{
    name = "Rifles",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Shotguns",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 101,
}

DarkRP.createCategory{
    name = "Snipers",
    categorises = "shipments",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 102,
}

DarkRP.createCategory{
    name = "Pistols",
    categorises = "weapons",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Other",
    categorises = "weapons",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 255,
}

DarkRP.createCategory{
    name = "Other",
    categorises = "vehicles",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 255,
}
