/world/proc/load_mode()
	var/text = file2text("data/mode.txt")
	if (text)
		var/list/lines = dd_text2list(text, "\n")
		if (lines[1])
			master_mode = lines[1]
			diary << "Saved mode is '[master_mode]'"

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/world/proc/load_motd()
	join_motd = file2text("config/motd.txt")

/world/proc/load_rules()
	rules = file2text("config/rules.html")
	if (!rules)
		rules = "<html><head><title>Rules</title><body>There are no rules! Go nuts!</body></html>"

/world/proc/load_admins_txt()
	var/text = file2text("config/admins.txt")
	if (!text)
		diary << "Failed to load config/admins.txt\n"
	else
		var/list/lines = dd_text2list(text, "\n")
		for(var/line in lines)
			if (!line)
				continue

			if (copytext(line, 1, 2) == ";")
				continue

			var/pos = findtext(line, " - ", 1, null)
			if (pos)
				var/m_key = copytext(line, 1, pos)
				var/a_lev = copytext(line, pos + 3, length(line) + 1)
				admins[m_key] = a_lev
				diary << ("ADMIN: [m_key] = [a_lev]")

/world/proc/load_admins()
	var/DBConnection/dbcon = new()
	dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
	if(dbcon.IsConnected())
		var/DBQuery/query = dbcon.NewQuery("SELECT ckey,rank FROM `admins`")
		if(query.Execute())
			while(query.NextRow())
				var/rank = world.convert_ranks(text2num(query.item[2]))
				diary << ("ADMIN: [query.item[1]] = [rank]")
				admins[query.item[1]] = rank
		else
			load_admins_txt()
		dbcon.Disconnect()
	else
		load_admins_txt()

/world/proc/convert_ranks(var/nym as num)
	switch(nym)
		if(0) return "Admin Observer"
		if(1) return "Moderator"
		if(2) return "Temporary Admin"
		if(3) return "Admin Candidate"
		if(4) return "Trial Admin"
		if(5) return "Badmin"
		if(6) return "Game Admin"
		if(7) return "Game Master"
		else  return "Banned"

/world/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.loadsql("config/dbconfig.txt")
	// apply some settings from config..
	abandon_allowed = config.respawn

/world/New()
	src.load_configuration()

	if (config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	src.load_mode()
	src.load_motd()
	src.load_rules()
	src.load_admins()

	src.update_status()

	makepowernets()

	sun = new /datum/sun()

	vote = new /datum/vote()

	radio_controller = new /datum/controller/radio()
	//main_hud1 = new /obj/hud()
	data_core = new /obj/datacore()

	..()

	sleep(50)

	plmaster = new /obj/overlay(  )
	plmaster.icon = 'tile_effects.dmi'
	plmaster.icon_state = "plasma"
	plmaster.layer = FLY_LAYER
	plmaster.mouse_opacity = 0

	slmaster = new /obj/overlay(  )
	slmaster.icon = 'tile_effects.dmi'
	slmaster.icon_state = "sleeping_agent"
	slmaster.layer = FLY_LAYER
	slmaster.mouse_opacity = 0

	src.update_status()

	master_controller = new /datum/controller/game_controller()
	spawn(-1) master_controller.setup()
	return

//Crispy fullban
/world/Reboot(var/reason)
	spawn(0)
		world << sound(pick('newroundsexy.ogg','newroundsexy2.ogg')) // Skie
		//if(prob(40))
		//	for(var/mob/M in world)
		//		if(M.client)
		//			M << sound('NewRound2.ogg')
		//else
		//	for(var/mob/M in world)
		//		if(M.client)
		//			M << sound('NewRound.ogg')

	for(var/client/C)
		if (config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C <<link("byond://[config.server]")
		else
			C << link("byond://[world.address]:[world.port]")

//	sleep(10) // wait for sound to play
	..(reason)

/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/living/silicon/ai))
		return 1
	return

/atom/proc/on_reagent_change()
	return

/atom/proc/Bumped(AM as mob|obj)
	return

/atom/movable/Bump(var/atom/A as mob|obj|turf|area, yes)
	spawn( 0 )
		if ((A && yes))
			A.last_bumped = world.time
			A.Bumped(src)
		return
	..()
	return

// **** Note in 40.93.4, split into obj/mob/turf point verbs, no area

/atom/verb/point()
	set name = "Point To"
	set category = "Object"
	set src in oview()
	var/atom/this = src//detach proc from src
	src = null

	if (!usr || !isturf(usr.loc))
		return
	else if (usr.stat != 0 || usr.restrained())
		return

	var/tile = get_turf(this)
	if (!tile)
		return

	var/P = new /obj/decal/point(tile)
	spawn (20)
		del(P)

	usr.visible_message("<b>[usr]</b> points to [this]")

/obj/decal/point/point()
	set src in oview()
	set hidden = 1
	return