/obj/item/clothing/head/rabbitears
	name = "Rabbit Ears"
	desc = "Wearing these makes you looks useless, and only good for your sex appeal."
	icon_state = "bunny"
	flags = FPRINT | TABLEPASS | HEADSPACE

/obj/item/clothing/head/kitty
	name = "Kitty Ears"
	desc = "Meow?"
	icon_state = "kitty"
	flags = FPRINT | TABLEPASS | HEADSPACE
	var/icon/mob
	var/icon/mob2

	update_icon(var/mob/living/carbon/human/user)
		if(!istype(user)) return
		mob = new/icon("icon" = 'head.dmi', "icon_state" = "kitty")
		mob2 = new/icon("icon" = 'head.dmi', "icon_state" = "kitty2")
		mob.Blend(rgb(user.r_hair, user.g_hair, user.b_hair), ICON_ADD)
		mob2.Blend(rgb(user.r_hair, user.g_hair, user.b_hair), ICON_ADD)

		var/icon/earbit = new/icon("icon" = 'head.dmi', "icon_state" = "kittyinner")
		var/icon/earbit2 = new/icon("icon" = 'head.dmi', "icon_state" = "kittyinner2")
		mob.Blend(earbit, ICON_OVERLAY)
		mob2.Blend(earbit2, ICON_OVERLAY)

/obj/item/clothing/head/helmet/space/santahat
	name = "Santa's hat"
	icon_state = "santahat"

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"
	slowdown = 1
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL | SUITSPACE

/obj/item/clothing/shoes/red
	name = "red shoes"
	icon_state = "red"

/obj/item/clothing/mask/owl_mask
	name = "Owl mask"
	desc = "Twoooo!"
	icon_state = "owl"

/obj/item/clothing/under/owl
	name = "Owl uniform"
	desc = "Twoooo!"
	icon_state = "owl"
	colour = "owl"

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1

/obj/item/clothing/mask/gas/cyborg
	name = "cyborg visor"
	desc = "Beep boop"
	icon_state = "death"

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	icon_state = "boots"

/obj/item/clothing/suit/cyborg_suit
	name = "cyborg suit"
	icon_state = "death"
	item_state = "death"
	flags = FPRINT | TABLEPASS | CONDUCT
	fire_resist = T0C+5200

/*/obj/item/clothing/under/nazi1
	name = "Nazi uniform"
	desc = "SIEG HEIL!"
	icon_state = "nazi"
	colour = "nazi1"*/ //no direction sprites

/obj/item/clothing/suit/greatcoat
	name = "great coat"
	desc = "A Nazi great coat"
	icon_state = "nazi"
	item_state = "nazi"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/johnny
	name = "Johnny~~"
	desc = "Johnny~~"
	icon_state = "johnny"
	colour = "johnny"

/obj/item/clothing/suit/johnny_coat
	name = "Johnny~~"
	desc = "Johnny~~"
	icon_state = "johnny"
	item_state = "johnny"
	flags = FPRINT | TABLEPASS


/obj/item/clothing/under/rainbow
	name = "rainbow"
	desc = "rainbow"
	icon_state = "rainbow"
	colour = "rainbow"

/obj/item/clothing/under/cloud
	name = "cloud"
	desc = "cloud"
	icon_state = "cloud"
	colour = "cloud"

/*/obj/item/clothing/under/yay
	name = "yay"
	desc = "Yay!"
	icon_state = "yay"
	colour = "yay"*/ // no sprite --errorage

// UNUSED colourS

/obj/item/clothing/under/psyche
	name = "psychedelic"
	desc = "Groovy!"
	icon_state = "psyche"
	colour = "psyche"

/*
/obj/item/clothing/under/maroon
	name = "maroon"
	desc = "maroon"
	icon_state = "maroon"
	colour = "maroon"*/ // no sprite -- errorage

/obj/item/clothing/under/lightblue
	name = "lightblue"
	desc = "lightblue"
	icon_state = "lightblue"
	colour = "lightblue"

/obj/item/clothing/under/aqua
	name = "aqua"
	desc = "aqua"
	icon_state = "aqua"
	colour = "aqua"

/obj/item/clothing/under/purple
	name = "purple"
	desc = "purple"
	icon_state = "purple"
	colour = "purple"

/obj/item/clothing/under/lightpurple
	name = "lightpurple"
	desc = "lightpurple"
	icon_state = "lightpurple"
	colour = "lightpurple"

/obj/item/clothing/under/lightgreen
	name = "lightgreen"
	desc = "lightgreen"
	icon_state = "lightgreen"
	colour = "lightgreen"

/obj/item/clothing/under/lightblue
	name = "lightblue"
	desc = "lightblue"
	icon_state = "lightblue"
	colour = "lightblue"

/obj/item/clothing/under/lightbrown
	name = "lightbrown"
	desc = "lightbrown"
	icon_state = "lightbrown"
	colour = "lightbrown"

/obj/item/clothing/under/brown
	name = "brown"
	desc = "brown"
	icon_state = "brown"
	colour = "brown"

/obj/item/clothing/under/yellowgreen
	name = "yellowgreen"
	desc = "yellowgreen"
	icon_state = "yellowgreen"
	colour = "yellowgreen"

/obj/item/clothing/under/darkblue
	name = "darkblue"
	desc = "darkblue"
	icon_state = "darkblue"
	colour = "darkblue"

/obj/item/clothing/under/lightred
	name = "lightred"
	desc = "lightred"
	icon_state = "lightred"
	colour = "lightred"

/obj/item/clothing/under/darkred
	name = "darkred"
	desc = "darkred"
	icon_state = "darkred"
	colour = "darkred"

// STEAMPUNK STATION

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol

/obj/item/clothing/under/gimmick/rank/captain/suit
	name = "Captain's Suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon_state = "green_suit"
	item_state = "dg_suit"
	colour = "green_suit"

/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit
	name = "Head of Personnel's Suit"
	desc = "A teal suit and yellow necktie. An authoritative yet tacky ensemble."
	icon_state = "teal_suit"
	item_state = "g_suit"
	colour = "teal_suit"

/obj/item/clothing/under/suit_jacket
	name = "Black Suit"
	desc = "A black suit and red tie. Very formal."
	icon_state = "black_suit"
	item_state = "bl_suit"
	colour = "black_suit"

/obj/item/clothing/under/suit_jacket/red
	name = "Red Suit"
	desc = "A red suit and blue tie. Somewhat formal."
	icon_state = "red_suit"
	item_state = "r_suit"
	colour = "red_suit"

/obj/item/clothing/under/blackskirt
	name = "Black skirt"
	desc = "A black skirt, very fancy!"
	icon_state = "blackskirt"
	colour = "blackskirt"

/obj/item/clothing/under/schoolgirl
	name = "schoolgirl uniform"
	desc = "It's just like one of my Japanese animes!"
	icon_state = "schoolgirl"
	item_state = "schoolgirl"
	colour = "schoolgirl"

/obj/item/clothing/under/gimmick/rank/police
	name = "Police Uniform"
	desc = "Move along, nothing to see here."
	icon_state = "police"
	item_state = "b_suit"
	colour = "police"

/obj/item/clothing/head/helmet/bobby
	name = "Custodian Helmet"
	desc = "Heh. Lookit dat fukken helmet."
	icon_state = "policehelm"
	item_state = "helmet"

/obj/item/clothing/head/flatcap
	name = "flat cap"
	desc = "A working man's cap."
	icon_state = "flat_cap"
	item_state = "detective"

/obj/item/clothing/under/overalls
	name = "Laborer's Overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state = "lb_suit"
	colour = "overalls"

/obj/item/weapon/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	flags = FPRINT | ONBELT | TABLEPASS
	force = 10

/obj/item/clothing/under/pirate
	name = "Pirate Outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	colour = "pirate"

/obj/item/clothing/head/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"

/obj/item/clothing/suit/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state = "eyepatch"

/obj/item/clothing/head/bandana
	name = "pirate bandana"
	desc = "Yarr."
	icon_state = "bandana"
	item_state = "bandana"

/obj/item/clothing/under/soviet
	name = "soviet uniform"
	desc = "For the Motherland!"
	icon_state = "soviet"
	item_state = "soviet"
	colour = "soviet"

/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = "ushankadown"
	item_state = "ushankadown"

/* no left/right sprites
/obj/item/clothing/under/mario
	name = "Mario costume"
	desc = "Worn by Italian plumbers everywhere.  Probably."
	icon_state = "mario"
	item_state = "mario"
	colour = "mario"

/obj/item/clothing/under/luigi
	name = "Mario costume"
	desc = "Player two.  Couldn't you get the first controller?"
	icon_state = "luigi"
	item_state = "luigi"
	colour = "luigi"
*/

