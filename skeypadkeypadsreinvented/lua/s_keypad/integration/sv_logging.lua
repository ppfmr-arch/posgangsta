
if GAS and GAS.Logging then
    local granted = GAS.Logging:MODULE()

    granted.Category = sKeypad.languages[sKeypad.config.Language]["tool_name"]
    granted.Name = sKeypad.languages[sKeypad.config.Language]["access_granted"]
    granted.Colour = Color(0, 255, 0)

    granted:Setup(function()
        granted:Hook("sK:AccessGranted", "sK:bLogSupport", function(ply, ent)
            if !IsValid(ply) then return end
            granted:Log(sKeypad.languages[sKeypad.config.Language]["log_granted"], GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
        end)
    end)

    GAS.Logging:AddModule(success)


    local denied = GAS.Logging:MODULE()

    denied.Category = sKeypad.languages[sKeypad.config.Language]["tool_name"]
    denied.Name = sKeypad.languages[sKeypad.config.Language]["access_denied"]
    denied.Colour = Color(255, 0, 0)

    denied:Setup(function()
        denied:Hook("sK:AccessDenied", "sK:bLogSupport", function(ply, ent)
            if !IsValid(ply) then return end
            denied:Log(sKeypad.languages[sKeypad.config.Language]["log_denied"], GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatEntity(ent))
        end)
    end)

    GAS.Logging:AddModule(denied)
end

if mLogs then
    mLogs.addCategory(
        sKeypad.languages[sKeypad.config.Language]["tool_name"],
        "skeypad",
        sKeypad.config.UI["accentcolor"],
        function()
            return true
        end
    )

    local access_granted = sKeypad.languages[sKeypad.config.Language]["log_granted"]
    access_granted = string.Replace(access_granted, "{1}", "ply")
    access_granted = string.Replace(access_granted, "{2}", "ent")

    local access_denied = sKeypad.languages[sKeypad.config.Language]["log_denied"]
    access_denied = string.Replace(access_denied, "{1}", "ply")
    access_denied = string.Replace(access_denied, "{2}", "ent")

    mLogs.addCategoryDefinitions("skeypad", {
        mylogger = function(data) return mLogs.doLogReplace({"^player1", "connected"}, data) end,
        accessgranted = function(data) return mLogs.doLogReplace(access_granted, data) end,
        accessdenied = function(data) return mLogs.doLogReplace(access_denied, data) end
    })

    local category = "skeypad"

    mLogs.addLogger(sKeypad.languages[sKeypad.config.Language]["access_granted"], "accessgranted", category)
    mLogs.addHook("sK:AccessGranted", category, function(ply, ent)
        if !IsValid(ply) then return end
        mLogs.log("accessgranted", category, {ply=mLogs.logger.getPlayerData(ply),ent=mLogs.logger.getEntityData(ent)})
    end)

    mLogs.addLogger(sKeypad.languages[sKeypad.config.Language]["access_denied"], "accessdenied", category)
    mLogs.addHook("sK:AccessDenied", category, function(ply, ent)
        if !IsValid(ply) then return end
        mLogs.log("accessdenied", category, {ply=mLogs.logger.getPlayerData(ply),ent=mLogs.logger.getEntityData(ent)})
    end)
end

-- vk.com/urbanichka