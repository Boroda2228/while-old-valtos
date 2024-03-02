/turf/open
	var/destination_z
	var/destination_x
	var/destination_y

/turf/open/space
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	name = "космос"
	intact = 0

	initial_temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000

	var/static/datum/gas_mixture/immutable/space/space_gas = new
	// We do NOT want atmos adjacent turfs
	init_air = FALSE
	run_later = TRUE
	plane = PLANE_SPACE
	layer = SPACE_LAYER
	light_power = 0.75
	light_color = COLOR_STARLIGHT
	space_lit = TRUE
	bullet_bounce_sound = null
	vis_flags = VIS_INHERIT_ID	//when this be added to vis_contents of something it be associated with something on clicking, important for visualisation of turf in openspace and interraction with openspace that show you turf.

	force_no_gravity = TRUE

/turf/open/space/basic/New() //Do not convert to Initialize
	SHOULD_CALL_PARENT(FALSE)
	//This is used to optimize the map loader
	return

/**
 * Space Initialize
 *
 * Doesn't call parent, see [/atom/proc/Initialize].
 * When adding new stuff to /atom/Initialize, /turf/Initialize, etc
 * don't just add it here unless space actually needs it.
 *
 * There is a lot of work that is intentionally not done because it is not currently used.
 * This includes stuff like smoothing, blocking camera visibility, etc.
 * If you are facing some odd bug with specifically space, check if it's something that was
 * intentionally ommitted from this implementation.
 */
/turf/open/space/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	icon_state = SPACE_ICON_STATE(x, y, z)
	if(!space_gas)
		space_gas = new
	air = space_gas
	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	// We make the assumption that the space plane will never be blacklisted, as an optimization
	if(SSmapping.max_plane_offset)
		plane = PLANE_SPACE - (PLANE_RANGE * SSmapping.z_level_to_plane_offset[z])

	var/area/our_area = loc
	if(!our_area.area_has_base_lighting && space_lit) //Only provide your own lighting if the area doesn't for you
		// Intentionally not add_overlay for performance reasons.
		// add_overlay does a bunch of generic stuff, like creating a new list for overlays,
		// queueing compile, cloning appearance, etc etc etc that is not necessary here.
		overlays += GLOB.fullbright_overlays[GET_TURF_PLANE_OFFSET(src) + 1]

	if (!mapload)
		if(SSmapping.max_plane_offset)
			var/turf/T = SSmapping.get_turf_above(src)
			if(T)
				T.multiz_turf_new(src, DOWN)
			T = SSmapping.get_turf_below(src)
			if(T)
				T.multiz_turf_new(src, UP)

	return INITIALIZE_HINT_NORMAL

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/turf/open/attack_ghost(mob/dead/observer/user)
	if(destination_z)
		var/turf/T = locate(destination_x, destination_y, destination_z)
		user.forceMove(T)

/turf/open/space/Initalize_Atmos(times_fired)
	return

/turf/open/space/TakeTemperature(temp)

/turf/open/space/RemoveLattice()
	return

/turf/open/space/AfterChange()
	..()
	atmos_overlay_types = null

/turf/open/space/Assimilate_Air()
	return

//IT SHOULD RETURN NULL YOU MONKEY, WHY IN TARNATION WHAT THE FUCKING FUCK
/turf/open/space/remove_air(amount)
	return null

/turf/open/space/proc/update_starlight()
	for(var/t in RANGE_TURFS(1,src)) //RANGE_TURFS is in code\__HELPERS\game.dm
		// I've got a lot of cordons near spaceturfs, be good kids
		if(isspaceturf(t) || istype(t, /turf/cordon))
			//let's NOT update this that much pls
			continue
		enable_starlight()
		return TRUE
	set_light(0)
	return FALSE

/// Turns on the stars, if they aren't already
/turf/open/space/proc/enable_starlight()
	if(!light_range)
		set_light(2)

/turf/open/space/attack_paw(mob/user)
	return attack_hand(user)

/turf/open/space/proc/CanBuildHere()
	return TRUE

/turf/open/space/handle_slip()
	return

/turf/open/space/attackby(obj/item/C, mob/user, params)
	..()
	if(!CanBuildHere())
		return
	if(istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		var/obj/structure/lattice/catwalk/W = locate(/obj/structure/lattice/catwalk, src)
		if(W)
			to_chat(user, span_warning("Тут уже есть мостик!"))
			return
		if(L)
			if(R.use(1))
				qdel(L)
				to_chat(user, span_notice("Строю мостик."))
				playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
				new/obj/structure/lattice/catwalk(src)
			else
				to_chat(user, span_warning("Надо бы побольше прутьев для постройки мостика!"))
			return
		if(R.use(1))
			to_chat(user, span_notice("Строю решетку."))
			playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
			ReplaceWithLattice()
		else
			to_chat(user, span_warning("Надо бы побольше прутьев для постройки решетки."))
		return
	if(istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			if(S.use(1))
				qdel(L)
				playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
				to_chat(user, span_notice("Покрываю обшивкой."))
				PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			else
				to_chat(user, span_warning("Надо бы плиточку!"))
		else
			to_chat(user, span_warning("Надо бы опору сначала сделать. Подойдёт несколько прутьев."))

/turf/open/space/Entered(atom/movable/arrived)
	. = ..()
	if(!arrived || src != arrived.loc)
		return

	if(destination_z && destination_x && destination_y && !arrived.pulledby && !arrived.currently_z_moving)
		var/tx = destination_x
		var/ty = destination_y
		var/turf/DT = locate(tx, ty, destination_z)
		var/itercount = 0
		while(DT.density || istype(DT.loc,/area/shuttle)) // Extend towards the center of the map, trying to look for a better place to arrive
			if (itercount++ >= 100)
				log_game("SPACE Z-TRANSIT ERROR: Could not find a safe place to land [arrived] within 100 iterations.")
				break
			if (tx < 128)
				tx++
			else
				tx--
			if (ty < 128)
				ty++
			else
				ty--
			DT = locate(tx, ty, destination_z)

		arrived.zMove(null, DT, ZMOVE_ALLOW_BUCKLED)

		var/atom/movable/current_pull = arrived.pulling
		while (current_pull)
			var/turf/target_turf = get_step(current_pull.pulledby.loc, REVERSE_DIR(current_pull.pulledby.dir)) || current_pull.pulledby.loc
			current_pull.zMove(null, target_turf, ZMOVE_ALLOW_BUCKLED)
			current_pull = current_pull.pulling

/turf/open/space/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return

/turf/open/space/singularity_act()
	return

/turf/open/space/can_have_cabling()
	if(locate(/obj/structure/lattice/catwalk, src))
		return TRUE
	return FALSE

/turf/open/space/is_transition_turf()
	if(destination_x || destination_y || destination_z)
		return TRUE


/turf/open/space/acid_act(acidpwr, acid_volume)
	return FALSE

/turf/open/space/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	generate_space_underlay(underlay_appearance, asking_turf)
	return TRUE


/turf/open/space/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(!CanBuildHere())
		return FALSE

	switch(the_rcd.mode)
		if(RCD_FLOORWALL)
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
			if(L)
				return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 1)
			else
				return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 3)
	return FALSE

/turf/open/space/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, span_notice("Строю пол."))
			PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			return TRUE
	return FALSE

/turf/open/space/ReplaceWithLattice()
	var/dest_x = destination_x
	var/dest_y = destination_y
	var/dest_z = destination_z
	..()
	destination_x = dest_x
	destination_y = dest_y
	destination_z = dest_z

/turf/open/space/openspace
	icon = 'icons/turf/floors.dmi'
	icon_state = "invisible"
	plane = FLOOR_PLANE

/turf/open/space/openspace/Initialize(mapload) // handle plane and layer here so that they don't cover other obs/turfs in Dream Maker
	. = ..()
	icon_state = "invisible"
	return INITIALIZE_HINT_LATELOAD

/turf/open/space/openspace/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency)

/turf/open/space/openspace/zAirIn()
	return TRUE

/turf/open/space/openspace/zAirOut()
	return TRUE

/turf/open/space/openspace/zPassIn(atom/movable/A, direction, turf/source)
	if(direction == DOWN)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_IN_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_IN_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/space/openspace/zPassOut(atom/movable/A, direction, turf/destination)
	if(A.anchored)
		return FALSE
	if(direction == DOWN)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_OUT_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_OUT_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/space/openspace/enable_starlight()
	var/turf/below = SSmapping.get_turf_below(src)
	// Override = TRUE beacuse we could have our starlight updated many times without a failure, which'd trigger this
	RegisterSignal(below, COMSIG_TURF_CHANGE, PROC_REF(on_below_change), override = TRUE)
	if(!isspaceturf(below))
		return
	set_light(2)

/turf/open/space/openspace/update_starlight()
	. = ..()
	if(.)
		return
	// If we're here, the starlight is not to be
	var/turf/below = SSmapping.get_turf_below(src)
	UnregisterSignal(below, COMSIG_TURF_CHANGE)

/turf/open/space/openspace/proc/on_below_change(turf/source, path, list/new_baseturfs, flags, list/post_change_callbacks)
	SIGNAL_HANDLER
	if(isspaceturf(source) && !ispath(path, /turf/open/space))
		set_light(2)
	else if(!isspaceturf(source) && ispath(path, /turf/open/space))
		set_light(0)