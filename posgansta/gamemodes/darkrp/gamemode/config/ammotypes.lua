DarkRP.createAmmoType("pistol", {
    name = "Pistol ammo",
    model = "models/Items/BoxSRounds.mdl",
    price = 30,
    amountGiven = 24
})

DarkRP.createAmmoType("buckshot", {
    name = "Shotgun ammo",
    model = "models/Items/BoxBuckshot.mdl",
    price = 50,
    amountGiven = 8
})

DarkRP.createAmmoType("smg1", {
    name = "Rifle ammo",
    model = "models/Items/BoxMRounds.mdl",
    price = 80,
    amountGiven = 30
})

DarkRP.createAmmoType("Rifle", {
    name = "Rifle ammo (swb)",
    model = "models/Items/BoxMRounds.mdl",
    price = 80,
    amountGiven = 30
})

DarkRP.createAmmoType("ar2", {
    name = "AR2 ammo",
    model = "models/Items/BoxMRounds.mdl",
    price = 100,
    amountGiven = 30
})

DarkRP.createAmmoType("357", {
    name = "357 ammo",
    model = "models/Items/BoxMRounds.mdl",
    price = 120,
    amountGiven = 12
})

DarkRP.createAmmoType("item_ammo_pistol", {
    name = "Pistol ammo (item)",
    model = "models/Items/BoxMRounds.mdl",
    price = 30,
    amountGiven = 24
})

DarkRP.createAmmoType("item_ammo_smg1", {
    name = "SMG1 ammo (item)",
    model = "models/Items/BoxMRounds.mdl",
    price = 80,
    amountGiven = 30
})

DarkRP.createAmmoType("item_box_buckshot", {
    name = "Buckshot box",
    model = "models/Items/BoxMRounds.mdl",
    price = 50,
    amountGiven = 8
})

DarkRP.createAmmoType("item_ammo_smg1_grenade", {
    name = "SMG1 Grenade",
    model = "models/Items/BoxMRounds.mdl",
    price = 200,
    amountGiven = 1
})

DarkRP.createAmmoType("SniperPenetratedRound", {
    name = "Sniper Ammo",
    model = "models/Items/BoxMRounds.mdl",
    price = 200,
    amountGiven = 30
})

DarkRP.createCategory{
    name = "Other",
    categorises = "ammo",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 255,
}
