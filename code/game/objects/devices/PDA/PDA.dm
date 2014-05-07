
//The advanced pea-green monochrome lcd of tomorrow.

/obj/item/device/pda
	name = "PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'pda.dmi'
	icon_state = "pda"
	item_state = "electronic"
	w_class = 2.0
	flags = FPRINT | TABLEPASS | ONBELT

	//Main variables
	var/owner = null
	var/default_cartridge = 0 // Access level defined by cartridge
	var/obj/item/weapon/cartridge/cartridge = null //current cartridge
	var/mode = 0 //Controls what menu the PDA will display. 0 is hub; the rest are either built in or based on cartridge.

	//Secondary variables
	var/scanmode = 0 //1 is medical scanner, 2 is forensics, 3 is reagent scanner.
	var/fon = 0 //Is the flashlight function on?
	var/f_lum = 4 //Luminosity for the flashlight function
	var/silent = 0 //To beep or not to beep, that is the question
	var/toff = 0 //If 1, messenger disabled
	var/tnote = null //Current Texts
	var/last_text //No text spamming
	var/last_honk //Also no honk spamming that's bad too
	var/ttone = "beep" //The ringtone!
	var/honkamt = 0 //How many honks left when infected with honk.exe
	var/mimeamt = 0 //How many silence left when infected with mime.exe
	var/note = "Congratulations, your station has chosen the Thinktronic 5100 Personal Data Assistant!" //Current note in the notepad function.
	var/cart = "" //A place to stick cartridge menu information

	var/obj/item/weapon/integrated_uplink/uplink = null

	var/obj/item/weapon/card/id/id = null //Making it possible to slot an ID card into the PDA so it can function as both.
	var/ownjob = null //related to above

/obj/item/device/pda/medical
	default_cartridge = /obj/item/weapon/cartridge/medical
	icon_state = "pda-m"

/obj/item/device/pda/engineering
	default_cartridge = /obj/item/weapon/cartridge/engineering
	icon_state = "pda-e"

/obj/item/device/pda/security
	default_cartridge = /obj/item/weapon/cartridge/security
	icon_state = "pda-s"

/obj/item/device/pda/janitor
	default_cartridge = /obj/item/weapon/cartridge/janitor
	icon_state = "pda-j"
	ttone = "slip"

/obj/item/device/pda/toxins
	default_cartridge = /obj/item/weapon/cartridge/signal/toxins
	icon_state = "pda-tox"
	ttone = "boom"

/obj/item/device/pda/clown
	default_cartridge = /obj/item/weapon/cartridge/clown
	icon_state = "pda-clown"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. The surface is coated with polytetrafluoroethylene and banana drippings."
	ttone = "honk"

/obj/item/device/pda/mime
	default_cartridge = /obj/item/weapon/cartridge/mime
	icon_state = "pda-mime"
	silent = 1
	ttone = "silence"

/obj/item/device/pda/heads
	default_cartridge = /obj/item/weapon/cartridge/head
	icon_state = "pda-h"

/obj/item/device/pda/captain
	default_cartridge = /obj/item/weapon/cartridge/captain
	icon_state = "pda-c"
	toff = 1

/obj/item/device/pda/quartermaster
	default_cartridge = /obj/item/weapon/cartridge/quartermaster
	icon_state = "pda-q"

/obj/item/device/pda/syndicate
	default_cartridge = /obj/item/weapon/cartridge/syndicate
	icon_state = "pda-syn"
	name = "Military PDA"
	owner = "John Doe"
	toff = 1

/obj/item/device/pda/chaplain
	icon_state = "pda-holy"
	ttone = "holy"

/*
 *	The Actual PDA
 */
/obj/item/device/pda/pickup(mob/user)
	if (fon)
		sd_SetLuminosity(0)
		user.sd_SetLuminosity(user.luminosity + f_lum)

/obj/item/device/pda/dropped(mob/user)
	if (fon)
		user.sd_SetLuminosity(user.luminosity - f_lum)
		sd_SetLuminosity(f_lum)

/obj/item/device/pda/New()
	..()
	spawn(3)
	if (default_cartridge)
		cartridge = new default_cartridge(src)

//NOTE: graphic resources are loaded on client login
/obj/item/device/pda/attack_self(mob/user as mob)
	user.machine = src

	var/dat = "<html><head><title>Personal Data Assistant</title></head><body bgcolour=\"#808000\"><style>a, a:link, a:visited, a:active, a:hover { colour: #000000; }img {border-style:none;}</style>"

	dat += "<a href='byond://?src=\ref[src];choice=Close'><img src=pda_exit.png> Close</a>"

	if ((!isnull(cartridge)) && (mode == 0))
		dat += " | <a href='byond://?src=\ref[src];choice=Eject'><img src=pda_eject.png> Eject [cartridge]</a>"
	if (mode)
		dat += " | <a href='byond://?src=\ref[src];choice=Return'><img src=pda_menu.png> Return</a>"
	dat += " | <a href='byond://?src=\ref[src];choice=Refresh'><img src=pda_refresh.png> Refresh</a>"

	dat += "<br>"

	if (!owner)
		dat += "Warning: No owner information entered.  Please swipe card.<br><br>"
		dat += "<a href='byond://?src=\ref[src];choice=Refresh'><img src=pda_refresh.png> Retry</a>"
	else
		switch (mode)
			if (0)
				dat += "<h2>PERSONAL DATA ASSISTANT</h2>"
				dat += "Owner: [owner], [ownjob]<br>"
				dat += text("ID: <A href='?src=\ref[];choice=Authenticate'>[]</A><br>", src, (id ? "[id.registered], [id.assignment]" : "----------"))
				dat += "Station Time: [round(world.time / 36000)+12]:[(world.time / 600 % 60) < 10 ? add_zero(world.time / 600 % 60, 1) : world.time / 600 % 60]"//:[world.time / 100 % 6][world.time / 100 % 10]"

				dat += "<br><br>"

				dat += "<h4>General Functions</h4>"
				dat += "<ul>"
				dat += "<li><a href='byond://?src=\ref[src];choice=1'><img src=pda_notes.png> Notekeeper</a></li>"
				dat += "<li><a href='byond://?src=\ref[src];choice=2'><img src=pda_mail.png> Messenger</a></li>"

				if (cartridge)
					if (cartridge.access_clown)
						dat += "<li><a href='byond://?src=\ref[src];choice=Honk'><img src=pda_honk.png> Honk Synthesizer</a></li>"
					if (cartridge.access_manifest)
						dat += "<li><a href='byond://?src=\ref[src];choice=41'><img src=pda_notes.png> View Crew Manifest</a></li>"
					if(cartridge.access_status_display)
						dat += "<li><a href='byond://?src=\ref[src];choice=42'><img src=pda_status.png> Set Status Display</a></li>"
					dat += "</ul>"
					if (cartridge.access_engine)
						dat += "<h4>Engineering Functions</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=\ref[src];choice=43'><img src=pda_power.png> Power Monitor</a></li>"
						dat += "</ul>"
					if (cartridge.access_medical)
						dat += "<h4>Medical Functions</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=\ref[src];choice=44'><img src=pda_medical.png> Medical Records</a></li>"
						dat += "<li><a href='byond://?src=\ref[src];choice=Medical Scan'><img src=pda_scanner.png> [scanmode == 1 ? "Disable" : "Enable"] Medical Scanner</a></li>"
						dat += "</ul>"
					if (cartridge.access_security)
						dat += "<h4>Security Functions</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=\ref[src];choice=45'><img src=pda_cuffs.png> Security Records</A></li>"
						dat += "<li><a href='byond://?src=\ref[src];choice=Forensic Scan'><img src=pda_scanner.png> [scanmode == 2 ? "Disable" : "Enable"] Forensic Scanner</a></li>"
					if(istype(cartridge.radio, /obj/item/radio/integrated/beepsky))
						dat += "<li><a href='byond://?src=\ref[src];choice=46'><img src=pda_cuffs.png> Security Bot Access</a></li>"
						dat += "</ul>"
					else	dat += "</ul>"
					if(cartridge.access_quartermaster)
						dat += "<h4>Quartermaster Functions:</h4>"
						dat += "<ul>"
						dat += "<li><a href='byond://?src=\ref[src];choice=47'><img src=pda_crate.png> Supply Records</A></li>"
						dat += "<li><a href='byond://?src=\ref[src];choice=48'><img src=pda_mule.png> Delivery Bot Control</A></li>"
						dat += "</ul>"
				dat += "</ul>"

				dat += "<h4>Utilities</h4>"
				dat += "<ul>"
				if (cartridge)
					if (cartridge.access_janitor)
						dat += "<li><a href='byond://?src=\ref[src];choice=49'><img src=pda_bucket.png> Equipment Locator</a></li>"
					if (istype(cartridge.radio, /obj/item/radio/integrated/signal))
						dat += "<li><a href='byond://?src=\ref[src];choice=40'><img src=pda_signaler.png> Signaler System</a></li>"
					if (cartridge.access_reagent_scanner)
						dat += "<li><a href='byond://?src=\ref[src];choice=Reagent Scan'><img src=pda_reagent.png> [scanmode == 3 ? "Disable" : "Enable"] Reagent Scanner</a></li>"
					if (cartridge.access_remote_door)
						dat += "<li><a href='byond://?src=\ref[src];choice=Toggle Door'><img src=pda_rdoor.png> Toggle Remote Door</a></li>"
				dat += "<li><a href='byond://?src=\ref[src];choice=3'><img src=pda_atmos.png> Atmospheric Scan</a></li>"
				dat += "<li><a href='byond://?src=\ref[src];choice=Light'><img src=pda_flashlight.png> [fon ? "Disable" : "Enable"] Flashlight</a></li>"
				dat += "</ul>"

			if (1)
				dat += "<h4><img src=pda_notes.png> Notekeeper V2.1</h4>"
				if ((!isnull(uplink)) && (uplink.active))
					dat += "<a href='byond://?src=\ref[src];choice=Lock'> Lock</a><br>"
				else
					dat += "<a href='byond://?src=\ref[src];choice=Edit'> Edit</a><br>"
				dat += note

			if (2)
				dat += "<h4><img src=pda_mail.png> SpaceMessenger V3.9.4</h4>"
				dat += "<a href='byond://?src=\ref[src];choice=Toggle Ringer'><img src=pda_bell.png> Ringer: [silent == 1 ? "Off" : "On"]</a> | "
				dat += "<a href='byond://?src=\ref[src];choice=Toggle Messenger'><img src=pda_mail.png> Send / Receive: [toff == 1 ? "Off" : "On"]</a> | "
				dat += "<a href='byond://?src=\ref[src];choice=Ringtone'><img src=pda_bell.png> Set Ringtone</a> | "
				dat += "<a href='byond://?src=\ref[src];choice=21'><img src=pda_mail.png> Messages</a><br>"

				if (istype(cartridge, /obj/item/weapon/cartridge/syndicate))
					dat += "<h4><a href='byond://?src=\ref[src];choice=22'> Hidden Menu</a><h4>"

				if (istype(cartridge, /obj/item/weapon/cartridge/clown))
					dat += "<h4><a href='byond://?src=\ref[src];choice=23'> Hidden Menu</a><h4>"

				if (istype(cartridge, /obj/item/weapon/cartridge/mime))
					dat += "<h4><a href='byond://?src=\ref[src];choice=24'> Hidden Menu</a><h4>"

				dat += "<h4><img src=pda_menu.png> Detected PDAs</h4>"

				dat += "<ul>"

				var/count = 0

				if (!toff)
					for (var/obj/item/device/pda/P in world)
						if (!P.owner||P.toff||P == src)	continue
						dat += "<li><a href='byond://?src=\ref[src];choice=\ref[P]'>[P]</a>"
						dat += "</li>"
						count++
				dat += "</ul>"
				if (count == 0)
					dat += "None detected.<br>"

			if(21)
				dat += "<h4><img src=pda_mail.png> SpaceMessenger V3.9.4</h4>"
				dat += "<a href='byond://?src=\ref[src];choice=Clear'><img src=pda_blank.png> Clear Messages</a>"

				dat += "<h4><img src=pda_mail.png> Messages</h4>"

				dat += tnote
				dat += "<br>"

			if(22)
				dat += "<h4><img src=pda_mail.png> Datomatix</h4>"
				dat += "<b>[cartridge:shock_charges] detonation charges left.</b><HR>"
				dat += "<h4><img src=pda_menu.png> Detected PDAs</h4>"
				dat += "<ul>"
				var/count = 0
				for (var/obj/item/device/pda/P in world)
					if (!P.owner||P.toff||P == src)	continue
					dat += " (<a href='byond://?src=\ref[src];choice=\ref[P]'><img src=pda_boom.png> <i>[P]</i> *Detonate*</a>)"
					dat += "</li>"
					count++
				dat += "</ul>"
				if (count == 0)
					dat += "None detected.<br>"

			if(23)
				dat += "<h4><img src=pda_mail.png> Honk Attack!!</h4>"
				dat += "<b>[cartridge:honk_charges] viral files left.</b><HR>"
				dat += "<h4><img src=pda_menu.png> Detected PDAs</h4>"
				dat += "<ul>"
				var/count = 0
				for (var/obj/item/device/pda/P in world)
					if (!P.owner||P.toff||P == src)	continue
					dat += " (<a href='byond://?src=\ref[src];choice=\ref[P]'><img src=pda_honk.png> <i>[P]</i> *Send Virus*</a>)"
					dat += "</li>"
					count++
				dat += "</ul>"
				if (count == 0)
					dat += "None detected.<br>"

			if(24)
				dat += "<h4><img src=pda_mail.png> Silent but Deadly...</h4>"
				dat += "<b>[cartridge:mime_charges] viral files left.</b><HR>"
				dat += "<h4><img src=pda_menu.png> Detected PDAs</h4>"
				dat += "<ul>"
				var/count = 0
				for (var/obj/item/device/pda/P in world)
					if (!P.owner||P.toff||P == src)	continue
					dat += " (<a href='byond://?src=\ref[src];choice=\ref[P]'> <i>[P]</i> *Send Virus*</a>)"
					dat += "</li>"
					count++
				dat += "</ul>"
				if (count == 0)
					dat += "None detected.<br>"

			if (3)
				dat += "<h4><img src=pda_atmos.png> Atmospheric Readings</h4>"

				var/turf/T = get_turf_or_move(user.loc)
				if (isnull(T))
					dat += "Unable to obtain a reading.<br>"
				else
					var/datum/gas_mixture/environment = T.return_air()

					var/pressure = environment.return_pressure()
					var/total_moles = environment.total_moles()

					dat += "Air Pressure: [round(pressure,0.1)] kPa<br>"

					if (total_moles)
						var/o2_level = environment.oxygen/total_moles
						var/n2_level = environment.nitrogen/total_moles
						var/co2_level = environment.carbon_dioxide/total_moles
						var/plasma_level = environment.toxins/total_moles
						var/unknown_level =  1-(o2_level+n2_level+co2_level+plasma_level)
						dat += "Nitrogen: [round(n2_level*100)]%<br>"
						dat += "Oxygen: [round(o2_level*100)]%<br>"
						dat += "Carbon Dioxide: [round(co2_level*100)]%<br>"
						dat += "Plasma: [round(plasma_level*100)]%<br>"
						if(unknown_level > 0.01)
							dat += "OTHER: [round(unknown_level)]%<br>"
					dat += "Temperature: [round(environment.temperature-T0C)]&deg;C<br>"
				dat += "<br>"
			else//Else it links to the cart menu proc. Although, it really uses menu hub 4--menu 4 doesn't really exist as it simply redirects to hub.
				dat += cart

	dat += "</body></html>"
	user << browse(dat, "window=pda;size=400x444;border=1;can_resize=0;can_close=0;can_minimize=0")
	onclose(user, "pda", src)

/obj/item/device/pda/Topic(href, href_list)
	..()
	var/mob/living/U = usr
	if (U.contents.Find(src) || U.contents.Find(master) || (istype(loc, /turf) && get_dist(src, U) <= 1))
		if (U.stat || U.restrained())
			U << browse(null, "window=pda")
			return
		else
			add_fingerprint(U)
			U.machine = src

			switch(href_list["choice"])

//BASIC FUNCTIONS===================================

				if("Close")//Self explanatory
					U << browse(null, "window=pda")
					return
				if("Refresh")//Refresh, goes to the end of the proc.
				if("Return")//Return
					if(mode<=9)
						mode = 0
					else
						mode = round(mode/10)
						if(mode==4)//Fix for cartridges. Redirects to hub.
							mode = 0
						else if(mode==44||mode==45)//Fix for cartridges. Redirects to refresh the menu.
							cartridge.mode = mode
							cartridge.unlock()
				if ("Authenticate")//Checks for ID
					if (id)
						if (istype(loc, /mob))
							var/obj/item/W = loc:equipped()
							var/emptyHand = (W == null)
							if(emptyHand)
								id.DblClick()
								if(!istype(id.loc, /obj/item/device/pda))
									id = null
						else
							id.loc = loc
							id = null
					else
						var/obj/item/I = U.equipped()
						if (istype(I, /obj/item/weapon/card/id))
							U.drop_item()
							I.loc = src
							id = I
				if("Eject")//Ejects the cart, only done from hub.
					if (!isnull(cartridge))
						var/turf/T = loc
						if(ismob(T))
							T = T.loc
						cartridge.loc = T
						scanmode = 0
						if (cartridge.radio)
							cartridge.radio.hostpda = null
						cartridge = null

//MENU FUNCTIONS===================================

				if("0")//Hub
					mode = 0
				if("1")//Notes
					mode = 1
				if("2")//Messenger
					mode = 2
				if("21")//Read messeges
					mode = 21
				if("22")//Detonate PDAs
					mode = 22
				if("23")//Send honk virus
					mode = 23
				if("24")//Send silence virus
					mode = 24
				if("3")//Atmos scan
					mode = 3
				if("4")//Redirects to hub
					mode = 0

//MAIN FUNCTIONS===================================

				if("Light")
					fon = (!fon)
					if (contents.Find(src))
						if (fon)
							sd_SetLuminosity(U.luminosity + f_lum)
						else
							sd_SetLuminosity(U.luminosity - f_lum)
					else
						sd_SetLuminosity(fon * f_lum)
					updateUsrDialog()
				if("Medical Scan")
					if(scanmode == 1)
						scanmode = 0
					else if((!isnull(cartridge)) && (cartridge.access_medical))
						scanmode = 1
					updateUsrDialog()//What is this even used for?
				if("Forensic Scan")
					if(scanmode == 2)
						scanmode = 0
					else if((!isnull(cartridge)) && (cartridge.access_security))
						scanmode = 2
					updateUsrDialog()
				if("Reagent Scan")
					if(scanmode == 3)
						scanmode = 0
					else if((!isnull(cartridge)) && (cartridge.access_reagent_scanner))
						scanmode = 3
					updateUsrDialog()
				if("Honk")
					if ( !(last_honk && world.time < last_honk + 20) )
						playsound(loc, 'bikehorn.ogg', 50, 1)
						last_honk = world.time

//MESSENGER/NOTE FUNCTIONS===================================

				if ("Edit")
					var/n = input(U, "Please enter message", name, note) as message
					if (in_range(src, U) && loc == U)
						n = copytext(adminscrub(n), 1, MAX_MESSAGE_LEN)
						if (mode == 1)
							note = n
					else
						U << browse(null, "window=pda")
						return
				if("Toggle Messenger")
					toff = !toff
				if("Toggle Ringer")//If viewing texts then erase them, if not then toggle silent status
					silent = !silent
					updateUsrDialog()
				if("Clear")//Clears messages
					tnote = null
					updateUsrDialog()
				if("Ringtone")
					var/t = input(U, "Please enter new ringtone", name, ttone) as text
					if (in_range(src, U) && loc == U)
						if (t)
							if ((uplink) && (cmptext(t,uplink.lock_code)) && (!uplink.active))
								U << "The PDA softly beeps."
								uplink.unlock()
							else
								t = copytext(sanitize(t), 1, 20)
								ttone = t
					else
						U << browse(null, "window=pda")
						return

//SYNDICATE FUNCTIONS===================================

				if("Door")
					if(!isnull(cartridge) && cartridge.access_remote_door)
						for(var/obj/machinery/door/poddoor/M in machines)
							if(M.id == cartridge.remote_door_id)
								if(M.density)
									spawn(0)
										M.open()
								else
									spawn(0)
										M.close()
				if("Lock")
					if(uplink)
						uplink.active = 0
						note = uplink.orignote
						updateUsrDialog()

//LINK FUNCTIONS===================================

				else//Else, redirects based on current menu
					switch(mode)
						if(0)//Cartridge menu linking
							mode = text2num(href_list["choice"])
							cartridge.mode = mode
							cartridge.unlock()
						if(2)//Message people.
							var/t = input(U, "Please enter message", name, null) as text
							t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
							if (!t)
								return
							if (!in_range(src, U) && loc != U)
								return

							var/obj/item/device/pda/P = locate(href_list["choice"])

							if (isnull(P)||P.toff || toff)
								return

							if (last_text && world.time < last_text + 5)
								return

							last_text = world.time

							for (var/obj/machinery/message_server/MS in world)
								MS.send_pda_message("[P.owner]","[owner]","[t]")

							tnote += "<i><b>&rarr; To [P.owner]:</b></i><br>[t]<br>"
							P.tnote += "<i><b>&larr; From <a href='byond://?src=\ref[P];editnote=\ref[src]'>[owner]</a>:</b></i><br>[t]<br>"

							if (prob(15)) //Give the AI a chance of intercepting the message
								for (var/mob/living/silicon/ai/A in world)
									A.show_message("<i>Intercepted message from <b>[P:owner]</b>: [t]</i>")

							if (!P.silent)
								playsound(P.loc, 'twobeep.ogg', 50, 1)
								for (var/mob/O in hearers(3, P.loc))
									O.show_message(text("\icon[P] *[P.ttone]*"))

							P.overlays = null
							P.overlays += image('pda.dmi', "pda-r")
						if(22)//Detonate PDA
							if(istype(cartridge, /obj/item/weapon/cartridge/syndicate))
								var/obj/item/device/pda/P = locate(href_list["choice"])
								if(!isnull(P))
									if (!P.toff && cartridge:shock_charges > 0)
										cartridge:shock_charges--

										var/difficulty = 0

										if (!isnull(P.cartridge))
											difficulty += P.cartridge.access_medical
											difficulty += P.cartridge.access_security
											difficulty += P.cartridge.access_engine
											difficulty += P.cartridge.access_clown
											difficulty += P.cartridge.access_janitor
											difficulty += P.cartridge.access_manifest * 2
										else
											difficulty += 2

										if ((prob(difficulty * 12)) || (P.uplink))
											U.show_message("\red An error flashes on your [src].", 1)
										else if (prob(difficulty * 3))
											U.show_message("\red Energy feeds back into your [src]!", 1)
											explode()
										else
											U.show_message("\blue Success!", 1)
											P.explode()
									updateUsrDialog()
								else
									U << "PDA not found."
							else
								U << browse(null, "window=pda")
								return
						if(23)//Honk virus
							if(istype(cartridge, /obj/item/weapon/cartridge/clown))
								var/obj/item/device/pda/P = locate(href_list["choice"])
								if(!isnull(P))
									if (!P.toff && cartridge:honk_charges > 0)
										cartridge:honk_charges--
										U.show_message("\blue Virus sent!", 1)
										P.honkamt = (rand(15,20))
									updateUsrDialog()
								else
									U << "PDA not found."
							else
								U << browse(null, "window=pda")
								return
						if(24)//Silent virus
							if(istype(cartridge, /obj/item/weapon/cartridge/mime))
								var/obj/item/device/pda/P = locate(href_list["choice"])
								if(!isnull(P))
									if (!P.toff && cartridge:mime_charges > 0)
										cartridge:mime_charges--
										U.show_message("\blue Virus sent!", 1)
										P.silent = 1
										P.ttone = "silence"
									updateUsrDialog()
								else
									U << "PDA not found."
							else
								U << browse(null, "window=pda")
								return

//EXTRA FUNCTIONS===================================

	if (mode == 2||mode == 21)
		overlays = null

	if ((honkamt > 0) && (prob(60)))
		honkamt--
		playsound(loc, 'bikehorn.ogg', 30, 1)

	for (var/mob/M in viewers(1, loc))
		if (M.client && M.machine == src)
			attack_self(M)
//	attack_self(U)
	return

// access to status display signals
/obj/item/device/pda/attackby(obj/item/weapon/C as obj, mob/user as mob)
	..()
	if (istype(C, /obj/item/weapon/cartridge) && isnull(src.cartridge))
		user.drop_item()
		C.loc = src
		user << "\blue You insert [C] into [src]."
		src.cartridge = C
		if (C:radio)
			C:radio.hostpda = src
		src.updateUsrDialog()

	else if (istype(C, /obj/item/weapon/card/id) && C:registered)
		if(!src.owner)
			src.owner = C:registered
			src.ownjob = C:assignment
			src.name = "PDA-[src.owner] ([src.ownjob])"
			user << "\blue Card scanned."
			src.updateSelfDialog()
			return
		if(!(src.owner == C:registered))
			user << "\blue Name on card does not match registered name. Please try again."
			src.updateSelfDialog()
			return
		if((src.owner == C:registered) && (src.ownjob == C:assignment))
			user << "\blue Rank is up to date."
			src.updateSelfDialog()
			return
		if((src.owner == C:registered) && (src.ownjob != C:assignment))
			src.ownjob = C:assignment
			src.name = "PDA-[src.owner] ([src.ownjob])"
			user << "\blue Rank updated."
			src.updateSelfDialog()
			return


/obj/item/device/pda/attack(mob/C as mob, mob/user as mob)
	if (istype(C, /mob/living/carbon))
		switch(scanmode)
			if(1)

				for (var/mob/O in viewers(C, null))
					O.show_message("\red [user] has analyzed [C]'s vitals!", 1)

				user.show_message("\blue Analyzing Results for [C]:")
				user.show_message("\blue \t Overall Status: [C.stat > 1 ? "dead" : "[C.health]% healthy"]", 1)
				user.show_message("\blue \t Damage Specifics: [C.oxyloss > 50 ? "\red" : "\blue"][C.oxyloss]-[C.toxloss > 50 ? "\red" : "\blue"][C.toxloss]-[C.fireloss > 50 ? "\red" : "\blue"][C.fireloss]-[C.bruteloss > 50 ? "\red" : "\blue"][C.bruteloss]", 1)
				user.show_message("\blue \t Key: Suffocation/Toxin/Burns/Brute", 1)
				user.show_message("\blue \t Body Temperature: [C.bodytemperature-T0C]&deg;C ([C.bodytemperature*1.8-459.67]&deg;F)", 1)
				if(C.virus)
					user.show_message(text("\red <b>Warning Virus Detected.</b>\nName: [C.virus.name].\nType: [C.virus.spread].\nStage: [C.virus.stage]/[C.virus.max_stages].\nPossible Cure: [C.virus.cure]"))

			if(2)
				if (!istype(C:dna, /datum/dna) || !isnull(C:gloves))
					user << "\blue No fingerprints found on [C]"
				else
					user << text("\blue [C]'s Fingerprints: [md5(C:dna.uni_identity)]")
				if ( !(C:blood_DNA) )
					user << "\blue No blood found on [C]"
				else
					user << "\blue Blood found on [C]. Analysing..."
					spawn(15)
						user << "\blue Blood type: [C:blood_type]\nDNA: [C:blood_DNA]"

/obj/item/device/pda/afterattack(atom/A as mob|obj|turf|area, mob/user as mob)
	switch(scanmode)
		if(2)
			if (!A.fingerprints)
				user << "\blue Unable to locate any fingerprints on [A]!"
			else
				var/list/L = params2list(A:fingerprints)
				user << "\blue Isolated [L.len] fingerprints."
				for(var/i in L)
					user << "\blue \t [i]"

		if(3)
			if(!isnull(A.reagents))
				if(A.reagents.reagent_list.len > 0)
					var/reagents_length = A.reagents.reagent_list.len
					user << "\blue [reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found."
					for (var/re in A.reagents.reagent_list)
						user << "\blue \t [re]"
				else
					user << "\blue No active chemical agents found in [A]."
			else
				user << "\blue No significant chemical agents found in [A]."

	if (!scanmode && istype(A, /obj/item/weapon/paper) && owner)
		if ((!isnull(uplink)) && (uplink.active))
			uplink.orignote = A:info
		else
			note = A:info
		user << "\blue Paper scanned." //concept of scanning paper copyright brainoblivion 2009

/obj/item/device/pda/proc/explode() //This needs tuning.

	var/turf/T = get_turf(src.loc)

	if (ismob(loc))
		var/mob/M = loc
		M.show_message("\red Your [src] explodes!", 1)

	if(T)
		T.hotspot_expose(700,125)

		explosion(T, -1, -1, 2, 3)

	del(src)
	return

/obj/item/device/pda/Del()
	if (src.id)
		if(istype(src.loc, /mob))
			src.id.loc = src.loc.loc
		else src.id.loc = src.loc
	..()

/obj/item/device/pda/clown/HasEntered(AM as mob|obj) //Clown PDA is slippery.
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if ((istype(M, /mob/living/carbon/human) && (istype(M:shoes, /obj/item/clothing/shoes) && M:shoes.flags&NOSLIP)) || M.m_intent == "walk")
			return

		if ((istype(M, /mob/living/carbon/human) && (M.real_name != src.owner) && (istype(src.cartridge, /obj/item/weapon/cartridge/clown))))
			if (src.cartridge:honk_charges < 5)
				src.cartridge:honk_charges++

		M.pulling = null
		M << "\blue You slipped on the PDA!"
		playsound(src.loc, 'slip.ogg', 50, 1, -3)
		M.stunned = 4
		M.weakened = 2


//AI verb and proc for sending PDA messages.

/mob/living/silicon/ai/verb/cmd_send_pdamesg()
	set category = "AI Commands"
	set name = "Send PDA Message"
	var/list/names = list()
	var/list/plist = list()
	var/list/namecounts = list()

	if(usr.stat == 2)
		usr << "You can't send PDA messages because you are dead!"
		return

	for (var/obj/item/device/pda/P in world)
		if (!P.owner)
			continue
		else if (P == src)
			continue
		else if (P.toff)
			continue

		var/name = P.owner
		if (name in names)
			namecounts[name]++
			name = text("[name] ([namecounts[name]])")
		else
			names.Add(name)
			namecounts[name] = 1

		plist[text("[name]")] = P

	var/c = input(usr, "Please select a PDA") as null|anything in plist

	if (!c)
		return

	var/selected = plist[c]
	ai_send_pdamesg(selected)

/mob/living/silicon/ai/proc/ai_send_pdamesg(obj/selected as obj)
	var/t = input(usr, "Please enter message", src.name, null) as text
	t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
	if (!t)
		return

	if (selected:toff)
		return

	usr.show_message("<i>PDA message to <b>[selected:owner]</b>: [t]</i>")
	selected:tnote += "<i><b>&larr; From (AI) [usr.name]:</b></i><br>[t]<br>"

	if (!selected:silent)
		playsound(selected.loc, 'twobeep.ogg', 50, 1)
		for (var/mob/O in hearers(3, selected.loc))
			O.show_message(text("\icon[selected] *[selected:ttone]*"))

	selected.overlays = null
	selected.overlays += image('pda.dmi', "pda-r")


//Some spare PDAs in a box

/obj/item/weapon/storage/PDAbox
	name = "spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'pda.dmi'
	icon_state = "pdabox"
	item_state = "syringe_kit"

/obj/item/weapon/storage/PDAbox/New()
	..()
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)

	var/newcart = pick(1,2,3,4)
	switch(newcart)
		if(1)
			new /obj/item/weapon/cartridge/janitor(src)
		if(2)
			new /obj/item/weapon/cartridge/security(src)
		if(3)
			new /obj/item/weapon/cartridge/medical(src)
		if(4)
			new /obj/item/weapon/cartridge/head(src)

	new /obj/item/weapon/cartridge/signal/toxins(src)