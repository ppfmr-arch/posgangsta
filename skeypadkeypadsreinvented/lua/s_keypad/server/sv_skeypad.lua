sKeypad = sKeypad or {}

sKeypad.FunctionWraps = sKeypad.FunctionWraps or {}

util.AddNetworkString("sK:Handeler")

local netlimit = {}

net.Receive("sK:Handeler", function(_, ply)
    if netlimit[ply] and netlimit[ply] > CurTime() then return end
    netlimit[ply] = CurTime() + .1


    local action = net.ReadUInt(2)
    local plypos = ply:GetPos()

    if action == 1 then
        local code = net.ReadUInt(14)
        local ent = ply:GetEyeTraceNoCursor().Entity
        if !IsValid(ent) or ent:GetClass() ~= "s_keypad" then return end

        if ent:GetPos():DistToSqr(plypos) > sKeypad.config.MaxDistance then return end

        ent:AttemptAuthenticate(ply, code)
    elseif action == 2 then
        local keypad = net.ReadEntity()
        local upgrade = net.ReadString()

        if !IsValid(keypad) or keypad:GetClass() ~= "s_keypad" or sKeypad.config.Upgrades[upgrade].price <= -1 or keypad.data.upgrades[upgrade] then return end

        if keypad:GetPos():DistToSqr(plypos) > sKeypad.config.MaxDistance then return end

        if !table.IsEmpty(sKeypad.config.Upgrades[upgrade].groups) and !sKeypad.config.Upgrades[upgrade].groups[ply:GetUserGroup()] then sKeypad.Notify(ply, sKeypad.languages[sKeypad.config.Language]["insufficient_rank"]) return end

        ply:addMoney(-sKeypad.config.Upgrades[upgrade].price)


        keypad.data.upgrades[upgrade] = true

        keypad:SyncSettings(ply)
    elseif action == 3 then
        local keypad = net.ReadEntity()
        if !IsValid(keypad) or keypad:GetClass() ~= "s_keypad" then return end
        if (!keypad:IsAuthorized(ply) or !keypad.data.canauthedit) and keypad.data.owner ~= ply:SteamID() then return end

        if keypad:GetPos():DistToSqr(plypos) > sKeypad.config.MaxDistance then return end
        local specific = net.ReadString()
        local oldData = table.Copy(keypad.data)
        local data
        if specific then
            if specific == "upgrades" then ply:Kick(sKeypad.config.Prefix..sKeypad.languages[sKeypad.config.Language]["exploit_attempt"]) return end
            local type = net.ReadUInt(2)
            if type == 1 then
                data = net.ReadUInt(14)
            elseif type == 2 then
                data = net.ReadString()
                if data ~= nil then
                    data = util.JSONToTable(data)
                end
            elseif type == 3 then
                data = net.ReadBool()
            end

            keypad.data[specific] = data
        else
            local chunksize = net.ReadUInt(32)
            local data = util.Decompress(net.ReadData(chunksize))
            data = util.JSONToTable(data)

            keypad.data = data
        end

        keypad.data.mode = math.Clamp(keypad.data["mode"], 0, 1)
        keypad.data.timer = math.Clamp(keypad.data["timer"], sKeypad.config.GrantedDelay.min, sKeypad.config.GrantedDelay.max)
        keypad.data.code = math.Clamp(keypad.data["code"], 0, 9999)
        keypad.data.upgrades = oldData.upgrades
        keypad:SetBodygroup(2, keypad.data["mode"])

        keypad:CloseDoor()
    end
end)

sKeypad.Notify = function(ply, str, format)
    if !IsValid(ply) then return end
    str = string.format(str, format)
    net.Start("sK:Handeler")
    net.WriteUInt(3, 2)
    net.WriteString(str)
    net.Send(ply)
end

local function isObscuring(door)
    local pos = door:GetPos()
		
    local tracedata = {}
    tracedata.start = pos
    tracedata.endpos = pos
    tracedata.filter = function(ent) return ent:IsPlayer() end
    tracedata.mins = door:OBBMins()
    tracedata.maxs = door:OBBMaxs()
    local trace = util.TraceHull( tracedata )
    
    return IsValid(trace.Entity)
end

sKeypad.fadeDoor = function(door)
    if door.sKData then return end
	door.sKData = {}
	door.sKData["collisiongroup"] = door:GetCollisionGroup()
	door.sKData["material"] = door:GetMaterial()

	door:SetCollisionGroup(COLLISION_GROUP_VEHICLE_CLIP)
	door:SetMaterial(sKeypad.config.FadeMaterial)
end

sKeypad.unFadeDoor = function(door, keypad, force)
    if !door.sKData then return end
    if isObscuring(door) and IsValid(keypad) and !force then keypad:EmitSound(sKeypad.config.DoorObscuredSound) keypad:SetSkin(2) timer.Simple(2, function() if !IsValid(door) or !IsValid(keypad) then return end keypad:SetSkin(0) sKeypad.unFadeDoor(door, keypad) end) return end
	door:SetCollisionGroup(door.sKData["collisiongroup"])
	door:SetMaterial(door.sKData["material"])

	door.sKData = nil
end

local function wrapSWEPFunction(classname, funcname, func)
    local swep = weapons.GetStored(classname)
    
    if !swep then return end
    if !swep[funcname.."Old"] then
        swep[funcname.."Old"] = swep[funcname]
    end

    swep[funcname] = function(ent) local result = func(ent) if isfunction(swep[funcname.."Old"]) and !result then swep[funcname.."Old"](ent) end  end
end


timer.Simple(3, function()
    wrapSWEPFunction("weapon_keypadchecker", "PrimaryAttack", function(ent) --- Add integration to keypad admin checker!
        local ply = ent:GetOwner()
        if !IsValid(ply) or !ply:IsPlayer() then return end
        local targetEnt = ply:GetEyeTraceNoCursor().Entity

        local data = {}
        
        if targetEnt.keypads then
            for k,v in pairs(targetEnt.keypads) do
                targetEnt = k
                break
            end
        end

        local indextable = targetEnt:GetClass() == "s_keypad" and targetEnt.data.doors or targetEnt.keypads or {}

        if !table.IsEmpty(indextable) then
            table.insert(data, {ent = targetEnt})
        else
            net.Start("DarkRP_keypadData")
            net.WriteTable(indextable)
            net.Send(ply)
            return nil
        end

        for k,v in pairs(indextable) do
            if !v or !k then continue end
            table.insert(data, {ent = k})
        end

        net.Start("DarkRP_keypadData")
        net.WriteTable(data)
        net.Send(ply)

        return true
    end)

    wrapSWEPFunction("keypad_cracker", "PrimaryAttack", function(ent) --- Add alarm funcionality to the keypad cracker :)
        local ply = ent:GetOwner()
        if !IsValid(ply) or !ply:IsPlayer() then return end
        local keypad = ply:GetEyeTraceNoCursor().Entity

        if keypad:GetClass() == "s_keypad" then
            ent.keypadCracking = keypad
        end
    end)

    wrapSWEPFunction("keypad_cracker", "Fail", function(ent) --- Add alarm funcionality to the keypad cracker :)
        local ply = ent:GetOwner()
        if !IsValid(ply) or !ply:IsPlayer() then return end

        if IsValid(ent.keypadCracking) then ent.keypadCracking:Alarm() end
    end)
end)

-- vk.com/urbanichka