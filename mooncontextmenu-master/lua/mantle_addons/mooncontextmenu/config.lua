// Конфиг сделан под ШколуРП. Но можете запроста изменить под DarkRP

MoonContextMenu.config_cmds = {
    {
        items = {
            {
                name = 'Админка',
                func = function()
                    RunConsoleCommand('sam', 'menu')
                end,
                icon = 'wrench'
            },
            {
                name = 'Логи',
                func = function()
                    RunConsoleCommand('say', '!plogs')
                end,
                icon = 'logs'
            }
        },
        check = function()
            return LocalPlayer():getJobTable().command == 'job_admin'
        end
    },
    {
        items = {
            {
                name = 'Банды',
                func = function()
                    RunConsoleCommand('fated_gang_open')
                end,
                icon = 'gangs'
            },
            {
                name = 'Законы',
                func = function()
                    RunConsoleCommand('simplelaws_open')
                end,
                icon = 'schedule'
            },
            {
                name = 'Купить патроны',
                func = function()
                    local lply = LocalPlayer()
                    local wep = lply:GetActiveWeapon()
                    if not IsValid(wep) then return end
                    local prim = wep.Primary and wep.Primary.Ammo or game.GetAmmoName(wep:GetPrimaryAmmoType())
                    if not prim or prim == "" then return end
                    RunConsoleCommand("darkrp", "buyammo", prim)
                end,
                icon = 'gun'
            }
        }
    },
    {
        items = {
            {
                name = 'Выкинуть оружие',
                func = function()
                    RunConsoleCommand('darkrp', 'dropweapon')
                end,
                icon = 'gun'
            },
            {
                name = 'Выбросить деньги',
                func = function()
                    Mantle.ui.text_box('Выбросить деньги', 'Сколько желаете?', function(s)
                        RunConsoleCommand('darkrp', 'dropmoney', s)
                    end)
                end,
                icon = 'drop_money'
            },
            {
                name = 'Передать игроку деньги',
                func = function()
                    Mantle.ui.text_box('Передать деньги', 'Сколько желаете?', function(s)
                        RunConsoleCommand('darkrp', 'give', s)
                    end)
                end,
                icon = 'give_money'
            },
            {
                name = 'Сменить ник',
                func = function()
                    Mantle.ui.text_box('Сменить ник', 'Какой хотите поставить?', function(s)
                        RunConsoleCommand('darkrp', 'rpname', s)
                    end)
                end,
                icon = 'nick'
            },
            {
                name = 'Продать все двери',
                func = function()
                    RunConsoleCommand('darkrp', 'unownalldoors')
                end,
                icon = 'doors'
            },
            {
                name = 'Написать объявление',
                func = function()
                    Mantle.ui.text_box('Написать объявление', 'Что планируете рекламировать?', function(s)
                        RunConsoleCommand('say', '/advert ' .. s)
                    end)
                end,
                icon = 'advert'
            },
            {
                name = 'Кинуть ролл',
                func = function()
                    RunConsoleCommand('say', '/roll')
                end,
                icon = 'roll'
            }
        }
    },
    {
        items = {
            {
                name = 'Назначить розыск',
                func = function()
                    Mantle.ui.player_selector(function(pl)
                        Mantle.ui.text_box('Назначить розыск', 'Какова причина?', function(s)
                            RunConsoleCommand('darkrp', 'wanted', pl:Name(), s)
                        end)
                    end, function(pl)
                        return pl:getJobTable().adult
                    end)
                end,
                icon = 'wanted'
            },
            {
                name = 'Снять розыск',
                func = function()
                    Mantle.ui.player_selector(function(pl)
                        RunConsoleCommand('darkrp', 'unwanted', pl:Name())
                    end, function(pl)
                        return pl:getJobTable().adult
                    end)
                end,
                icon = 'unwanted'
            },
            {
                name = 'Получить орден',
                func = function()
                    Mantle.ui.player_selector(function(pl)
                        Mantle.ui.text_box('Получить орден', 'Какова причина?', function(s)
                            RunConsoleCommand('darkrp', 'warrant', pl:Name(), s)
                        end)
                    end, function(pl)
                        return pl:getJobTable().adult
                    end)
                end,
                icon = 'warrant'
            },
            {
                name = 'Устав',
                func = function()
                    RunConsoleCommand('simplelaws_open')
                end,
                icon = 'schedule'
            }
        },
        check = function()
            return LocalPlayer():getJobTable().adult
        end
    },
    {
        items = {
            {
                name = 'Вызвать админа',
                func = function()
                    Mantle.ui.text_box('Вызвать админа', 'Какова причина?', function(s)
                        RunConsoleCommand('say', '@ ',s)
                end)
            end,
                icon = 'help'
            },
            {
                name = 'Вкл/Выкл третье лицо',
                func = function()
                    RunConsoleCommand('third_person_toggle')
                end,
                icon = 'thirdperson_toggle'
            },
            {
                name = 'Остановить все звуки',
                func = function()
                    RunConsoleCommand('stopsound')
                end,
                icon = 'sounds'
            }
        }  
    }
}
