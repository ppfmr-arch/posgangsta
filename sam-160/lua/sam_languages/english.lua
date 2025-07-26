return {
	You = "Вы",
	Yourself = "Себя",
	Themself = "Себя",
	Everyone = "Все",

	cant_use_as_console = "Вы должны быть игроком, чтобы использовать команду {S Red}!",
	no_permission = "У вас нет прав для использования '{S Red}'!",

	cant_target_multi_players = "Вы не можете выбрать нескольких игроков для этой команды!",
	invalid_id = "Неверный id ({S Red})!",
	cant_target_player = "Вы не можете выбрать {S Red}!",
	cant_target_self = "Вы не можете выбрать себя для команды {S Red}!",
	player_id_not_found = "Игрок с id {S Red} не найден!",
	found_multi_players = "Найдено несколько игроков: {T}!",
	cant_find_target = "Не удалось найти игрока для выбора ({S Red})!",

	invalid = "Неверно {S} ({S_2 Red})",
	default_reason = "нет",

	menu_help = "Открыть меню админа.",

	-- Chat Commands
	pm_to = "ЛС для {T}: {V}",
	pm_from = "ЛС от {A}: {V}",
	pm_help = "Отправить личное сообщение (ЛС) игроку.",

	to_admins = "{A} для админов: {V}",
	asay_help = "Отправить сообщение администраторам.",

	mute = "{A} заглушил {T} на {V}. ({V_2})",
	mute_help = "Запретить игроку(ам) писать в чат.",

	unmute = "{A} снял мут с {T}.",
	unmute_help = "Разрешить игроку(ам) писать в чат.",

	you_muted = "Вы заглушены.",

	gag = "{A} запретил говорить {T} на {V}. ({V_2})",
	gag_help = "Запретить игроку(ам) говорить.",

	ungag = "{A} разрешил говорить {T}.",
	ungag_help = "Разрешить игроку(ам) говорить.",

	-- Fun Commands
	slap = "{A} шлёпнул {T}.",
	slap_damage = "{A} шлёпнул {T} с уроном {V}.",
	slap_help = "Шлёпнуть игрока.",

	slay = "{A} убил {T}.",
	slay_help = "Убить игрока.",

	set_hp = "{A} установил здоровье для {T} на {V}.",
	hp_help = "Установить здоровье игроку.",

	set_armor = "{A} установил броню для {T} на {V}.",
	armor_help = "Установить броню игроку.",

	ignite = "{A} поджёг {T} на {V}.",
	ignite_help = "Поджечь игрока.",

	unignite = "{A} потушил {T}.",
	unignite_help = "Потушить игрока.",

	god = "{A} включил режим бога для {T}.",
	god_help = "Включить режим бога для игрока.",

	ungod = "{A} выключил режим бога для {T}.",
	ungod_help = "Выключить режим бога для игрока.",

	freeze = "{A} заморозил {T}.",
	freeze_help = "Заморозить игрока.",

	unfreeze = "{A} разморозил {T}.",
	unfreeze_help = "Разморозить игрока.",

	cloak = "{A} сделал невидимым {T}.",
	cloak_help = "Сделать игрока невидимым.",

	uncloak = "{A} сделал видимым {T}.",
	uncloak_help = "Сделать игрока видимым.",

	jail = "{A} посадил {T} в тюрьму на {V}. ({V_2})",
	jail_help = "Посадить игрока в тюрьму.",

	unjail = "{A} выпустил {T} из тюрьмы.",
	unjail_help = "Выпустить игрока из тюрьмы.",

	strip = "{A} забрал оружие у {T}.",
	strip_help = "Забрать оружие у игрока.",

	respawn = "{A} возродил {T}.",
	respawn_help = "Возродить игрока.",

	setmodel = "{A} сменил модель для {T} на {V}.",
	setmodel_help = "Сменить модель игрока.",

	giveammo = "{A} выдал {T} {V} патронов.",
	giveammo_help = "Выдать патроны игроку.",

	scale = "{A} изменил размер модели для {T} на {V}.",
	scale_help = "Изменить размер игрока.",

	freezeprops = "{A} заморозил все пропы.",
	freezeprops_help = "Заморозить все пропы на карте.",

	-- Teleport Commands
	dead = "Вы мертвы!",
	leave_car = "Сначала выйдите из машины!",

	bring = "{A} телепортировал {T}.",
	bring_help = "Телепортировать игрока к себе.",

	goto = "{A} телепортировался к {T}.",
	goto_help = "Телепортироваться к игроку.",

	no_location = "Нет предыдущего места для возврата {T}.",
	returned = "{A} вернул {T}.",
	return_help = "Вернуть игрока на прежнее место.",

	-- User Management Commands
	setrank = "{A} установил ранг для {T} на {V} на {V_2}.",
	setrank_help = "Установить ранг игроку.",
	setrankid_help = "Установить ранг игроку по steamid/steamid64.",

	addrank = "{A} создал новый ранг {V}.",
	addrank_help = "Создать новый ранг.",

	removerank = "{A} удалил ранг {V}.",
	removerank_help = "Удалить ранг.",

	super_admin_access = "superadmin имеет доступ ко всему!",

	giveaccess = "{A} выдал доступ {V} для {T}.",
	givepermission_help = "Выдать разрешение рангу.",

	takeaccess = "{A} забрал доступ {V} у {T}.",
	takepermission_help = "Забрать разрешение у ранга.",

	renamerank = "{A} переименовал ранг {T} в {V}.",
	renamerank_help = "Переименовать ранг.",

	changeinherit = "{A} изменил наследование ранга для {T} на {V}.",
	changeinherit_help = "Изменить наследование ранга.",

	rank_immunity = "{A} изменил иммунитет ранга {T} на {V}.",
	changerankimmunity_help = "Изменить иммунитет ранга.",

	rank_ban_limit = "{A} изменил лимит бана ранга {T} на {V}.",
	changerankbanlimit_help = "Изменить лимит бана ранга.",

	changeranklimit = "{A} изменил лимит {V} для {T} на {V_2}.",
	changeranklimit_help = "Изменить лимиты ранга.",

	-- Utility Commands
	map_change = "{A} сменит карту на {V} через 10 секунд.",
	map_change2 = "{A} сменит карту на {V} с режимом {V_2} через 10 секунд.",
	map_help = "Сменить карту и режим.",

	map_restart = "{A} перезапустит карту через 10 секунд.",
	map_restart_help = "Перезапустить карту.",

	mapreset = "{A} сбросил карту.",
	mapreset_help = "Сбросить карту.",

	kick = "{A} кикнул {T}. Причина: {V}.",
	kick_help = "Кикнуть игрока.",

	ban = "{A} забанил {T} на {V} ({V_2}).",
	ban_help = "Забанить игрока.",

	banid = "{A} забанил ${T} на {V} ({V_2}).",
	banid_help = "Забанить игрока по steamid.",

	-- ban message when admin name doesn't exists
	ban_message = [[


		Вы забанены: {S}

		Причина: {S_2}

		Разбан через: {S_3}]],

	-- ban message when admin name exists
	ban_message_2 = [[


		Вы забанены: {S} ({S_2})

		Причина: {S_3}

		Разбан через: {S_4}]],

	unban = "{A} разбанил {T}.",
	unban_help = "Разбанить игрока по steamid.",

	noclip = "{A} включил noclip для {T}.",
	noclip_help = "Включить noclip для игрока.",

	cleardecals = "{A} удалил тряпки и декали для всех игроков.",
	cleardecals_help = "Удалить тряпки и декали для всех игроков.",

	stopsound = "{A} остановил все звуки.",
	stopsound_help = "Остановить все звуки для всех игроков.",

	not_in_vehicle = "Вы не в машине!",
	not_in_vehicle2 = "{S Blue} не в машине!",
	exit_vehicle = "{A} заставил {T} выйти из машины.",
	exit_vehicle_help = "Выгнать игрока из машины.",

	time_your = "Ваше общее время: {V}.",
	time_player = "Общее время {T}: {V}.",
	time_help = "Проверить время игрока.",

	admin_help = "Включить режим админа.",
	unadmin_help = "Выключить режим админа.",

	buddha = "{A} включил режим будды для {T}.",
	buddha_help = "Игрок не может умереть, когда здоровье 1.",

	unbuddha = "{A} выключил режим будды для {T}.",
	unbuddha_help = "Отключить режим будды для игрока.",

	give = "{A} выдал {T} {V}.",
	give_help = "Выдать оружие/предмет игроку.",

	-- DarkRP Commands
	arrest = "{A} арестовал {T} навсегда.",
	arrest2 = "{A} арестовал {T} на {V} секунд.",
	arrest_help = "Арестовать игрока.",

	unarrest = "{A} освободил {T}.",
	unarrest_help = "Освободить игрока.",

	setmoney = "{A} установил деньги для {T} на {V}.",
	setmoney_help = "Установить деньги игроку.",

	addmoney = "{A} добавил {V} для {T}.",
	addmoney_help = "Добавить деньги игроку.",

	door_invalid = "Неверная дверь для продажи.",
	door_no_owner = "У двери нет владельца.",

	selldoor = "{A} продал дверь/транспорт для {T}.",
	selldoor_help = "Продать дверь/транспорт, на который вы смотрите.",

	sellall = "{A} продал все двери/транспорт для {T}.",
	sellall_help = "Продать все двери/транспорт игрока.",

	s_jail_pos = "{A} установил новую позицию тюрьмы.",
	setjailpos_help = "Сбросить все позиции тюрьмы и установить новую на вашей позиции.",

	a_jail_pos = "{A} добавил новую позицию тюрьмы.",
	addjailpos_help = "Добавить позицию тюрьмы на вашей позиции.",

	setjob = "{A} сменил работу {T} на {V}.",
	setjob_help = "Сменить работу игрока.",

	shipment = "{A} заспавнил поставку {V}.",
	shipment_help = "Заспавнить поставку.",

	forcename = "{A} сменил имя {T} на {V}.",
	forcename_taken = "Имя уже занято. ({V})",
	forcename_help = "Сменить имя игрока.",

	report_claimed = "{A} взял репорт от {T}.",
	report_closed = "{A} закрыл репорт от {T}.",
	report_aclosed = "Ваш репорт закрыт. (Время истекло)",

	rank_expired = "Ранг {V} для {T} истёк.",

	-- TTT Commands
	setslays = "{A} установил количество автокиллов для {T} на {V}.",
	setslays_help = "Установить количество раундов для автокилла игрока.",

	setslays_slayed = "{T} был автокиллен, осталось: {V}.",

	removeslays = "{A} убрал автокиллы для {T}.",
	removeslays_help = "Убрать автокиллы для игрока."
}