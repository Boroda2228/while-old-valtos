#define DISCONNECTED 0
#define CLAMPED_OFF 1
#define OPERATING 2

// Powersink - used to drain station power

/obj/item/powersink
	name = "power sink"
	desc = "A nulling power sink which drains energy from electrical systems."
	icon = 'icons/obj/device.dmi'
	icon_state = "powersink0"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	flags_1 = CONDUCT_1
	item_flags = NO_PIXEL_RANDOM_DROP
	throwforce = 5
	throw_speed = 1
	throw_range = 2
	custom_materials = list(/datum/material/iron=750)
	var/drain_rate = 2000000	// amount of power to drain per tick
	var/power_drained = 0 		// has drained this much power
	var/max_power = 6e8		// maximum power that can be drained before exploding
	var/mode = 0		// 0 = off, 1=clamped (off), 2=operating
	var/admins_warned = FALSE // stop spam, only warn the admins once that we are about to boom

	var/obj/structure/cable/attached		// the attached cable

/obj/item/powersink/update_icon_state()
	. = ..()
	icon_state = "powersink[mode == OPERATING]"

/obj/item/powersink/set_anchored(anchorvalue)
	. = ..()
	set_density(anchorvalue)

/obj/item/powersink/proc/set_mode(value)
	if(value == mode)
		return
	switch(value)
		if(DISCONNECTED)
			attached = null
			if(mode == OPERATING)
				STOP_PROCESSING(SSobj, src)
			set_anchored(FALSE)

		if(CLAMPED_OFF)
			if(!attached)
				return
			if(mode == OPERATING)
				STOP_PROCESSING(SSobj, src)
			set_anchored(TRUE)

		if(OPERATING)
			if(!attached)
				return
			START_PROCESSING(SSobj, src)
			set_anchored(TRUE)

	mode = value
	update_icon()
	set_light(0)

/obj/item/powersink/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		if(mode == DISCONNECTED)
			var/turf/T = loc
			if(isturf(T) && !T.intact)
				attached = locate() in T
				if(!attached)
					to_chat(user, span_warning("<b>[capitalize(src)]</b> must be placed over an exposed, powered cable node!"))
				else
					set_mode(CLAMPED_OFF)
					user.visible_message( \
						"[user] attaches <b>[src.name]</b> to the cable.", \
						span_notice("You bolt <b>[src.name]</b> into the floor and connect it to the cable.") ,
						span_hear("You hear some wires being connected to something."))
			else
				to_chat(user, span_warning("<b>[capitalize(src)]</b> must be placed over an exposed, powered cable node!"))
		else
			set_mode(DISCONNECTED)
			user.visible_message( \
				"[user] detaches <b>[src.name]</b> from the cable.", \
				span_notice("You unbolt <b>[src.name]</b> from the floor and detach it from the cable.") ,
				span_hear("You hear some wires being disconnected from something."))

	else if(I.tool_behaviour == TOOL_SCREWDRIVER)
		user.visible_message( \
			"[user] messes with <b>[src.name]</b> for a bit.", \
			span_notice("You can't fit the screwdriver into <b>[src.name]</b>'s bolts! Try using a wrench."))
	else
		return ..()

/obj/item/powersink/attack_paw()
	return

/obj/item/powersink/attack_ai()
	return

/obj/item/powersink/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	switch(mode)
		if(DISCONNECTED)
			..()

		if(CLAMPED_OFF)
			user.visible_message( \
				"[user] activates <b>[src.name]</b>!", \
				span_notice("You activate <b>[src.name]</b>.") ,
				span_hear("You hear a click."))
			message_admins("Power sink activated by [ADMIN_LOOKUPFLW(user)] at [ADMIN_VERBOSEJMP(src)]")
			log_game("Power sink activated by [key_name(user)] at [AREACOORD(src)]")
			set_mode(OPERATING)

		if(OPERATING)
			user.visible_message( \
				"[user] deactivates <b>[src.name]</b>!", \
				span_notice("You deactivate <b>[src.name]</b>.") ,
				span_hear("You hear a click."))
			set_mode(CLAMPED_OFF)

/obj/item/powersink/process()
	if(!attached)
		set_mode(DISCONNECTED)
		return

	var/datum/powernet/PN = attached.powernet
	if(PN)
		set_light(5)

		// found a powernet, so drain up to max power from it

		var/drained = min ( drain_rate, attached.newavail() )
		attached.add_delayedload(drained)
		power_drained += drained

		// if tried to drain more than available on powernet
		// now look for APCs and drain their cells
		if(drained < drain_rate)
			for(var/obj/machinery/power/terminal/T in PN.nodes)
				if(istype(T.master, /obj/machinery/power/apc))
					var/obj/machinery/power/apc/A = T.master
					if(A.operating && A.cell)
						A.cell.charge = max(0, A.cell.charge - 50)
						power_drained += 50
						if(A.charging == 2) // If the cell was full
							A.charging = 1 // It's no longer full
				if(drained >= drain_rate)
					break

	if(power_drained > max_power * 0.98)
		if (!admins_warned)
			admins_warned = TRUE
			message_admins("Power sink at ([x],[y],[z] - <A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>) is 95% full. Explosion imminent.")
		playsound(src, 'sound/effects/screech.ogg', 100, TRUE, TRUE)

	if(power_drained >= max_power)
		STOP_PROCESSING(SSobj, src)
		explosion(src, devastation_range = 4, heavy_impact_range = 8, light_impact_range = 16, flash_range = 32)
		qdel(src)

#undef DISCONNECTED
#undef CLAMPED_OFF
#undef OPERATING