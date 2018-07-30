/*
VAZHNOE (ili ne osobo) PRIMECHANIE\/\/\/
***
File s kartoy nahoditsya po pyti _maps/RandomRuins/LavaRuins/doom_slayer_lavaland.dmm
***
VAZHNOE (ili ne osobo) PRIMECHANIE/\/\/\
*/

/obj/effect/mob_spawn/human/doom_slayer
	name = "doom slayer sleeper"
	desc = "Sleeper with the Doom Slayer in it. Prepare for the hell."
	mob_name = "doom slayer"
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	mob_species = /datum/species/human
	outfit = /datum/outfit/doom_slayer
	roundstart = FALSE
	death = FALSE
	anchored = FALSE
	density = FALSE
	flavour_text = "<span class='big bold'>You are the <b>Doom Guy</b>.</span><span class='big'> Your only mission is to kill every single demon.<p>You landed in the Lavaland Wastes. You see that there are a lot of monsters that needs to be eliminated. You can co-operate with someone who landed there like you but not killing them.</span>"
	assignedrole = "Doom Slayer"

/obj/effect/mob_spawn/human/doom_slayer/special(mob/living/new_spawn)
	new_spawn.real_name = "Doom Slayer"

	new_spawn.grant_language(/datum/language/common)
	var/datum/language_holder/holder = new_spawn.get_language_holder()
	holder.selected_default_language = /datum/language/common

	//if(ishuman(new_spawn))
		//var/mob/living/carbon/human/H = new_spawn
		//H.underwear = "Nude"
		//H.update_body()

/obj/effect/mob_spawn/human/doom_slayer/Initialize(mapload)
	. = ..()

/obj/item/clothing/head/helmet/space/hostile_environment/doom_slayer  //hlemet
	name = "Doom Slayer helmet"
	desc = "Helmet that protects Doom Slayer from most of the damage."
	icon_state = "hostile_env"
	item_state = "hostile_env"
	w_class = WEIGHT_CLASS_NORMAL
	max_heat_protection_temperature = FIRE_IMMUNITY_HELM_MAX_TEMP_PROTECT
	item_flags = NODROP
	clothing_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE | NOSLIP | LAVAPROTECT
	armor = list("melee" = 90, "bullet" = 90, "laser" = 90, "energy" = 90, "bomb" = 90, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = FIRE_PROOF | LAVA_PROOF | ACID_PROOF | INDESTRUCTIBLE | FREEZE_PROOF




/obj/item/clothing/suit/space/hostile_environment/doom_slayer //suit
	name = "Doom Slayer suit"
	desc = "Praetor suit that protects Doom Slayer from most of the damage."
	icon_state = "hostile_env"
	item_state = "hostile_env"
	clothing_flags = THICKMATERIAL | STOPSPRESSUREDAMAGE | NOSLIP | LAVAPROTECT
	max_heat_protection_temperature = FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT
	item_flags = NODROP
	resistance_flags = FIRE_PROOF | LAVA_PROOF | ACID_PROOF | INDESTRUCTIBLE | FREEZE_PROOF
	slowdown = 0
	armor = list("melee" = 90, "bullet" = 90, "laser" = 90, "energy" = 90, "bomb" = 90, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	allowed = list(/obj/item/tank/internals)

/obj/item/clothing/mask/gas/doom_slayer //mask
	name = "Doom Slayer mask"
	desc = "Praetor mask that gives Doom Slayer access to oxygen in space."
	item_flags = NODROP

/obj/item/clothing/shoes/doom_slayer //boots
	name = "Doom Slayer boots"
	desc = "Praetor boots that protects from slip and damage"
	clothing_flags = NOSLIP
	item_flags = NODROP
	armor = list("melee" = 90, "bullet" = 90, "laser" = 90, "energy" = 90, "bomb" = 90, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = FIRE_PROOF | LAVA_PROOF | ACID_PROOF | INDESTRUCTIBLE | FREEZE_PROOF
	icon = 'icons/obj/clothing/shoes.dmi'
	icon_state = "jackboots"
	item_color = "jackboots"

/obj/item/storage/backpack/doom_slayer
	name = "Doom Slayer backpack"
	desc = "Praetor backpack that holds bullets for shotgun."

/obj/item/storage/backpack/doom_slayer/ComponentInitialize()
	. = ..()
	GET_COMPONENT(STR, /datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_GIGANTIC
	STR.max_items = 600
	STR.can_hold = typecacheof(list(
		/obj/item/storage/box/lethalshot
	))

/datum/outfit/doom_slayer
	name ="Doom Slayer"
	suit_store = /obj/item/tank/internals/emergency_oxygen/double
	head = /obj/item/clothing/head/helmet/space/hostile_environment/doom_slayer
	uniform = /obj/item/clothing/under/suit_jacket/white
	suit = /obj/item/clothing/suit/space/hostile_environment/doom_slayer
	mask = /obj/item/clothing/mask/gas/doom_slayer
	shoes = /obj/item/clothing/shoes/doom_slayer
	back = /obj/item/storage/backpack/doom_slayer
	l_hand = /obj/item/gun/ballistic/shotgun/automatic/combat
	l_pocket = /obj/item/flashlight/seclite



/datum/map_template/ruin/lavaland/doom_slayer
	name = "Doom Slayer Shuttle"
	id = "ds_shuttle"
	description = "Shuttle with Doom Slayer inside. Prepare for hell."
	suffix = "doom_slayer_lavaland.dmm"
	always_place = TRUE