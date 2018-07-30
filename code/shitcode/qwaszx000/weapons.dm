/*
Melee
*/
/obj/item/melee/sword_h
	icon_state = "sword1"
	item_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	name = "Sword"
	desc = "Very old weapon!"
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	block_chance = 30
	force = 15
	sharpness = IS_SHARP
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/datum/crafting_recipe/sword_h
	name = "Sword"
	result = /obj/item/melee/sword_h
	reqs = list(/obj/item/restraints/handcuffs/cable = 1,
				/obj/item/stack/sheet/metal = 20,
				/obj/item/stack/rods = 1,
				/obj/item/stack/packageWrap = 5)
	time = 100
	category= CAT_WEAPONRY
	subcategory = CAT_WEAPON
