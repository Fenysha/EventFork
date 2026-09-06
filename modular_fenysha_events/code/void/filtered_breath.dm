/*
 * Masks that clean the air on the way in.
 *
 * Kept whole in one file, define included, because nothing outside the module
 * reads the trait - core's own smoke check still has its hardcoded confessor
 * case and is left alone.
 *
 * The trait is granted through a component rather than by overriding equipped()
 * and dropped(), because both masks already define those in core and DM will
 * not take a second definition of the same proc on the same type.
 */

/// Whatever is worn over the face cleans the air on its way in - what hangs in
/// it does not reach the lungs.
#define TRAIT_FILTERED_BREATH "Filtered Breath"

/datum/component/filtered_breath

/datum/component/filtered_breath/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/component/filtered_breath/proc/on_equip(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER

	// Only over the face. The plague mask also hangs from a belt, and a mask on
	// someone's hip is not filtering anything.
	if(slot != SLOT_WEAR_MASK)
		return
	ADD_TRAIT(equipper, TRAIT_FILTERED_BREATH, REF(parent))

/datum/component/filtered_breath/proc/on_drop(datum/source, mob/user)
	SIGNAL_HANDLER

	REMOVE_TRAIT(user, TRAIT_FILTERED_BREATH, REF(parent))

/*
 * The masks themselves. Initialize is free on both of these types in core, so
 * these are additions rather than overrides of anything.
 */

/obj/item/clothing/mask/rogue/facemask/steel/confessor/Initialize()
	. = ..()
	// The copper taste the description mentions is the mask working.
	AddComponent(/datum/component/filtered_breath)

/obj/item/clothing/mask/rogue/physician/Initialize()
	. = ..()
	// The beak is stuffed for exactly this reason.
	AddComponent(/datum/component/filtered_breath)
