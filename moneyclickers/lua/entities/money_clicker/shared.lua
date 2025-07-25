ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Clicker"
ENT.Author = "Metamist"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Category = "Money Clickers"

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "owning_ent")

    self:NetworkVar("String", 0, "ClickerInfo")
    self:NetworkVar("String", 1, "ClickerUpgradeInfo")
    self:NetworkVar("String", 2, "ClickerName")
    self:NetworkVar("String", 3, "OwnerName")

    self:NetworkVar("Int", 0, "Points")
    self:NetworkVar("Int", 1, "Money")

    self:NetworkVar("Int", 2, "UpgradeAutoClick")
    self:NetworkVar("Int", 3, "UpgradeClickPower")
    self:NetworkVar("Int", 4, "UpgradeCooling")
    self:NetworkVar("Int", 5, "UpgradeStorage")

    self:NetworkVar("Bool", 0, "Broken")
    self:NetworkVar("Bool", 1, "LookAway")

    self:NetworkVar("Float", 0, "RepairWaitTime")

    if SERVER then
    	self:SetMoney(0)
        self:SetPoints(0)
        self:SetClickerName("Money Clicker")
        self:SetBroken(false)
        self:SetLookAway(false)

        self:SetUpgradeAutoClick(1)
        self:SetUpgradeClickPower(1)
        self:SetUpgradeCooling(1)
        self:SetUpgradeStorage(1)
    end
end

function ENT:IsOverheating()
    return self:GetNWBool("Overheating", false)
end

function ENT:GetUpgradeData(upgrade)
    local data = self.info.upgrades[upgrade]
    if data then
        return data
    else
        MsgC("Missing upgrade ", upgrade, " in config\n")
        return
    end
end

function ENT:GetUpgradeLevel(upgrade)
    if upgrade == "autoClick" then
        return self:GetUpgradeAutoClick()
    elseif upgrade == "clickPower" then
        return self:GetUpgradeClickPower()
    elseif upgrade == "cooling" then
        return self:GetUpgradeCooling()
    elseif upgrade == "storage" then
        return self:GetUpgradeStorage()
    else
        MsgC("Missing upgrade ", upgrade, " in config\n")
        return
    end
end


local function NWAccessorFunc(ent, funcSuffix, nwVar, fallback, type, min, max)
    if SERVER then
        ent["Set" .. funcSuffix] = function(self, x)
    		if type == "float" then
    			self:SetNWFloat(nwVar, x)
    		elseif type == "int" then
    			self:SetNWInt(nwVar, x)
            elseif type == "string" then
                self:SetNWString(nwVar, x)
    		end
    	end
    end

	ent["Get" .. funcSuffix] = function(self)
		if type == "float" then
			return self:GetNWFloat(nwVar, fallback)
		elseif type == "int" then
			return self:GetNWInt(nwVar, fallback)
        elseif type == "string" then
            return self:GetNWString(nwVar, fallback)
		end
	end
end

NWAccessorFunc(ENT, "Progress", "Progress", 0, "float")
NWAccessorFunc(ENT, "Heat", "Heat", 0, "float")

-- vk.com/urbanichka