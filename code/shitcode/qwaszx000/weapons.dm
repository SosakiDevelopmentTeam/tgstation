/*
Arrow&bow
*/
/obj/item/reagent_containers/syringe/arrow
	name = "Arrow"
	desc = "A arrow that can hold up to 5 units."
	icon = 'icons/obj/projectiles.dmi'
	item_state = "arrow"
	icon_state = "arrow"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list()
	volume = 5
	mode = SYRINGE_DRAW
	busy = FALSE
	proj_piercing = 0
	materials = list(MAT_METAL=10, MAT_GLASS=20)
	container_type = TRANSPARENT

/obj/item/reagent_containers/syringe/arrow/update_icon()
	cut_overlays()

/obj/item/projectile/bullet/dart/syringe/bow//Arrow
	name = "arrow"
	icon_state = "bolter"
	damage = 10
	piercing = FALSE

/obj/item/ammo_casing/syringegun/bow//Bow chamber
	name = "Arrow"
	desc = "A high-power spring that throws arrows."
	projectile_type = /obj/item/projectile/bullet/dart/syringe/bow
	firing_effect_type = null
/obj/item/gun/syringe/bow//Bow
	name = "Bow"
	desc = "Bow"
	icon_state = "bow_unloaded"
	item_state = "bow_unloaded"
	force = 10

/obj/item/gun/syringe/bow/examine(mob/user)
	..()
	to_chat(user, "Can hold [max_syringes] arrow\s. Has [syringes.len] arrow\s remaining.")

/obj/item/gun/syringe/bow/Initialize()
	. = ..()

	chambered = new /obj/item/ammo_casing/syringegun/bow(src)

/obj/item/gun/syringe/bow/attackby(obj/item/A, mob/user, params, show_msg = TRUE)
	if(istype(A, /obj/item/reagent_containers/syringe/arrow))
		if(syringes.len < max_syringes)
			if(!user.transferItemToLoc(A, src))
				return FALSE
			to_chat(user, "<span class='notice'>You load [A] into \the [src].</span>")
			syringes += A
			recharge_newshot()
			return TRUE
		else
			to_chat(user, "<span class='warning'>[src] cannot hold more syringes!</span>")
	return FALSE

/datum/crafting_recipe/bow_h
	name = "Bow"
	result = /obj/item/gun/syringe/bow
	reqs = list(/obj/item/stack/cable_coil = 5,/obj/item/stack/sheet/mineral/wood = 10)
	time = 100
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/arrow_h
	name = "Arrow"
	result = /obj/item/reagent_containers/syringe/arrow
	reqs = list(/obj/item/stack/rods = 1)
	tools = list(TOOL_WIRECUTTER)
	time = 25
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON
