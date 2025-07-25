local superadminRanks = {
   ["superadmin"]    = true,
}

local function isSuperAdmin(ply)
     return superadminRanks[ply:GetUserGroup()]
end

TEAM_BANNED = DarkRP.createJob("Забаненый", {
   color = Color(0, 255,242, 255),
   model = {"models/player/charple.mdl"},
   description = [[Профессия забаненого]],
   weapons = {},
   command = "zabanen",
   max = 0,
   salary = 0,
   admin = 0,
   vote = false,
   candemote = false,
   category = "NonRP",
   customCheck = isSuperAdmin,
   CustomCheckFailMsg = "Вы хотите стать забаненым:?"
})



-- Создание категории в которой будет находится забаненный
DarkRP.createCategory{ 
   name = "NonRP",
   categorises = "jobs",
   startExpanded = false,
   color = Color(18, 135, 0, 255),
   canSee = function(ply) return true end,
   sortOrder = 10,
}