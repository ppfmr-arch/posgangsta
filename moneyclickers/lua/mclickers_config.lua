MCLICKERS = {}

MCLICKERS.clickDelay = 0.1       -- 0.1 seconds delay before being able to click again. This is to prevent auto-clickers.
MCLICKERS.clickRange = 80        -- Range in units that people can click.
MCLICKERS.wireUserEnabled = true -- Can the Wire User be used to withdraw money?
MCLICKERS.antiAutoClick = true   -- After a random amount of clicks, force the user to look away from the clicker.
MCLICKERS.useWorkshop = false    -- Use workshop downloading instead of FastDL for textures

MCLICKERS.SOUND_UI_HOVER = "garrysmod/ui_hover.wav"
MCLICKERS.SOUND_UI_CLICK = "garrysmod/ui_click.wav"
MCLICKERS.SOUND_CLICK    = "buttons/lightswitch2.wav"
MCLICKERS.SOUND_CYCLE    = "garrysmod/content_downloaded.wav"

MCLICKERS.MESSAGE_BREAK = "Money clicker break"
MCLICKERS.MESSAGE_UPGRADE_INSUFFICIENT = "Money clicker upgrade insufficient"
MCLICKERS.MESSAGE_REPAIR_INSUFFICIENT = "Money clicker repair insufficient"
MCLICKERS.MESSAGE_WITHDRAW = "Withdraw %s"
MCLICKERS.MESSAGE_DEFAULT_UPGRADE_ALLOWED = "Default upgrade allowed"


--[[ 

DarkRP.createEntity("Money clicker", { -- The name of the money clicker
    ent = "money_clicker", -- Do not change this class
    model = "models/props_c17/consolebox01a.mdl", -- Do not change this model
    price = 10000,
    max = 3,
    cmd = "buymoneyclicker", -- This has to be a unique command for each Money Clicker
    mClickerInfo = {
        pointsPerCycle = 10,     -- How many points you get per cycle
        moneyPerCycle = 7,       -- How much money you get per cycle
        maxPoints = 50000,        -- The base points capacity
        maxMoney = 5000000,         -- The base money capacity
        health = 100,            -- How much health it has, a crowbar deals 25 damage
        indestructible = false,  -- Can not be destroyed
        repairHealthCost = 1000,  -- Repair health price in points
        maxCycles = 100,         -- Amount of cycles before it breaks, set to 0 to disable
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
                stats = { 0, 1, 2, 3, 4 },       -- Clicks per second, set per upgrade level
                prices = { 200, 300, 400, 500 }, -- Prices for the second upgrade and up (starts with first upgrade)

                -- OPTIONAL: Lua function to check if a player is allowed to purchase the next upgrade
                --           Check examples below for job and group whitelist
                --           Remove if you want all upgrade levels to be available to everyone
                customCheck = function(ply, upgrade, data, current, max)
                    -- Custom check, return true to prevent purchasing upgrade
                    return true, "Optional custom message"
                end,
            },
            clickPower = {
                name = "Power Clicker",         -- The display name of the upgrade
                stats = { 10, 12, 14, 16 },     -- Progress per click, set per upgrade level
                prices = { 200, 300, 400 },     -- Prices for the second upgrade and up (starts with first upgrade)
            },
            cooling = {
                name = "Cooler Master",         -- The display name of the upgrade
                stats = { 1.7, 2.2, 3.5, 5 },   -- Cooling per 0.25 seconds. For reference, max heat is 100
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

    	colorPrimary = Color(139, 195, 74),  -- The primary color that is used for the entire model
    	colorSecondary = Color(255, 87, 34), -- The secondary color, AKA accent color, used for details
        colorText = Color(255, 255, 255),    -- The color of the text
        colorHealth = Color(255, 100, 100),  -- The color of the health icon
    },
})

--]]