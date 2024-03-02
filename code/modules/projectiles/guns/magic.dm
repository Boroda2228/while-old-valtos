/obj/item/gun/magic
	name = "посох ничего"
	desc = "За этим посохом скучно наблюдать, потому что, хотя он появился первым, вы видели все, что он может делать в других посохах в течение многих лет."
	icon = 'icons/obj/guns/magic.dmi'
	icon_state = "staffofnothing"
	inhand_icon_state = "staff"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi' //not really a gun and some toys use these inhands
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	fire_sound = 'sound/weapons/emitter.ogg'
	flags_1 =  CONDUCT_1
	w_class = WEIGHT_CLASS_HUGE
	///what kind of magic is this
	var/school = SCHOOL_EVOCATION
	var/checks_antimagic = TRUE
	var/max_charges = 6
	var/charges = 0
	var/recharge_rate = 8
	var/charge_timer = 0
	var/can_charge = TRUE
	var/ammo_type
	var/no_den_usage
	clumsy_check = 0
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL // Has no trigger at all, uses magic instead
	pin = /obj/item/firing_pin/magic

/obj/item/gun/magic/make_jamming()
	return

/obj/item/gun/magic/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(no_den_usage)
		var/area/A = get_area(user)
		if(istype(A, /area/wizard_station))
			add_fingerprint(user)
			to_chat(user, span_warning("Чем нарушать безопасность логова, лучше стоит остановиться. [capitalize(src.name)] ещё пригодится, но не здесь."))
			return
		else
			no_den_usage = 0
	if(checks_antimagic && user.anti_magic_check(TRUE, FALSE, FALSE, 0, TRUE))
		add_fingerprint(user)
		to_chat(user, span_warning("Что-то мешает [src.name]."))
		return
	. = ..()

/obj/item/gun/magic/can_shoot()
	return charges

/obj/item/gun/magic/recharge_newshot()
	if (charges && chambered && !chambered.loaded_projectile)
		chambered.newshot()

/obj/item/gun/magic/handle_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE, atom/shooter = null)
	if(chambered && !chambered.loaded_projectile) //if loaded_projectile is null, i.e the shot has been fired...
		charges--//... drain a charge
		recharge_newshot()

/obj/item/gun/magic/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_MAGICALLY_CHARGED, PROC_REF(on_magic_charge))

	charges = max_charges
	chambered = new ammo_type(src)
	if(can_charge)
		START_PROCESSING(SSobj, src)

	RegisterSignal(src, COMSIG_ITEM_RECHARGED, PROC_REF(instant_recharge))

/obj/item/gun/magic/proc/on_magic_charge(datum/source, datum/action/cooldown/spell/spell, mob/living/caster)
	charges = max_charges
	recharge_newshot()


/obj/item/gun/magic/fire_sounds()
	var/frequency_to_use = sin((90/max_charges) * charges)
	if(suppressed)
		playsound(src, suppressed_sound, suppressed_volume, vary_fire_sound, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0, frequency = frequency_to_use)
	else
		playsound(src, fire_sound, fire_sound_volume, vary_fire_sound, frequency = frequency_to_use)

/obj/item/gun/magic/Destroy()
	if(can_charge)
		STOP_PROCESSING(SSobj, src)
	return ..()


/obj/item/gun/magic/process(delta_time)
	if (charges >= max_charges)
		charge_timer = 0
		return
	charge_timer += delta_time
	if(charge_timer < recharge_rate)
		return 0
	charge_timer = 0
	charges++
	if(charges == 1)
		recharge_newshot()
	return 1


/obj/item/gun/magic/shoot_with_empty_chamber(mob/living/user as mob|obj)
	to_chat(user, span_warning("<b>[capitalize(name)]</b> тихо свистит."))

/obj/item/gun/magic/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is twisting [src] above [user.ru_ego()] head, releasing a magical blast! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, fire_sound, 50, TRUE, -1)
	return (FIRELOSS)

/obj/item/gun/magic/vv_edit_var(var_name, var_value)
	. = ..()
	switch(var_name)
		if(NAMEOF(src, charges))
			recharge_newshot()

/obj/item/gun/magic/proc/instant_recharge()
	SIGNAL_HANDLER
	charges = max_charges
	recharge_newshot()
	update_appearance()