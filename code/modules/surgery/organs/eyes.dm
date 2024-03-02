/obj/item/organ/eyes
	name = "глаза"
	icon_state = "eyeballs"
	desc = "Я тебя вижу!"
	zone = BODY_ZONE_PRECISE_EYES
	slot = ORGAN_SLOT_EYES
	gender = PLURAL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY
	maxHealth = 0.5 * STANDARD_ORGAN_THRESHOLD		//half the normal health max since we go blind at 30, a permanent blindness at 50 therefore makes sense unless medicine is administered
	high_threshold = 0.3 * STANDARD_ORGAN_THRESHOLD	//threshold at 30
	low_threshold = 0.2 * STANDARD_ORGAN_THRESHOLD	//threshold at 20

	low_threshold_passed = span_info("Далекие объекты становятся менее ощутимыми.")
	high_threshold_passed = span_info("Все становится менее ясным.")
	now_failing = span_warning("Тьма окутывает меня, глаза слепнут!")
	now_fixed = span_info("Цвет и формы снова ощутимы.")
	high_threshold_cleared = span_info("Зрение снова функционирует нормально.")
	low_threshold_cleared = span_info("Зрение очищено от недугов.")

	var/sight_flags = 0
	/// changes how the eyes overlay is applied, makes it apply over the lighting layer
	var/overlay_ignore_lighting = FALSE
	var/see_in_dark = 2
	var/tint = 0
	var/eye_color_left = "" //set to a hex code to override a mob's left eye color
	var/eye_color_right = "" //set to a hex code to override a mob's right eye color
	var/eye_icon_state = "eyes"
	var/old_eye_color_left = "fff"
	var/old_eye_color_right = "fff"
	var/flash_protect = FLASH_PROTECTION_NONE
	var/see_invisible = SEE_INVISIBLE_LIVING
	var/lighting_alpha
	var/no_glasses
	var/damaged	= FALSE	//damaged indicates that our eyes are undergoing some level of negative effect
	/// Native FOV that will be applied if a config is enabled
	var/native_fov = FOV_90_DEGREES

/obj/item/organ/eyes/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = FALSE, initialising)
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		old_eye_color_left = human_owner.eye_color_left
		old_eye_color_right = human_owner.eye_color_right
		if(eye_color_left)
			human_owner.eye_color_left = eye_color_left
			human_owner.regenerate_icons()
		else
			eye_color_left = human_owner.eye_color_left
		if(eye_color_right)
			human_owner.eye_color_right = eye_color_right
		else
			eye_color_right = human_owner.eye_color_right
		if(HAS_TRAIT(human_owner, TRAIT_NIGHT_VISION) && !lighting_alpha)
			lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT
		if(CONFIG_GET(flag/native_fov) && native_fov)
			human_owner.add_fov_trait(type, native_fov)
	M.update_tint()
	owner.update_sight()
	if(M.has_dna() && ishuman(M))
		M.dna.species.handle_body(M) //updates eye icon

/obj/item/organ/eyes/proc/refresh()
	if(ishuman(owner))
		var/mob/living/carbon/human/affected_human = owner
		old_eye_color_left = affected_human.eye_color_left
		old_eye_color_right = affected_human.eye_color_right
		if(eye_color_left)
			affected_human.eye_color_left = eye_color_left
		else
			eye_color_left = affected_human.eye_color_left
		if(eye_color_right)
			affected_human.eye_color_right = eye_color_right
			affected_human.regenerate_icons()
		else
			eye_color_right = affected_human.eye_color_right
		if(HAS_TRAIT(affected_human, TRAIT_NIGHT_VISION) && !lighting_alpha)
			lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT
	owner.update_tint()
	owner.update_sight()
	if(owner.has_dna() && ishuman(owner))
		var/mob/living/carbon/human/affected_human = owner
		affected_human.dna.species.handle_body(affected_human) //updates eye icon


/obj/item/organ/eyes/Remove(mob/living/carbon/eye_owner, special = 0)
	..()
	if(ishuman(eye_owner))
		var/mob/living/carbon/human/human_owner = eye_owner
		if(eye_color_left)
			human_owner.eye_color_left = old_eye_color_left
		if(eye_color_right)
			human_owner.eye_color_right = old_eye_color_right
		human_owner.regenerate_icons()
		if(native_fov)
			eye_owner.remove_fov_trait(type)
	eye_owner.cure_blind(EYE_DAMAGE)
	eye_owner.cure_nearsighted(EYE_DAMAGE)
	eye_owner.set_blindness(0)
	eye_owner.set_blurriness(0)
	eye_owner.clear_fullscreen("eye_damage", 0)
	eye_owner.update_sight()

#define OFFSET_X 1
#define OFFSET_Y 2

/// This proc generates a list of overlays that the eye should be displayed using for the given parent
/obj/item/organ/eyes/proc/generate_body_overlay(mob/living/carbon/human/parent)
	if(!istype(parent) || parent.getorgan(/obj/item/organ/eyes) != src)
		CRASH("Generating a body overlay for [src] targeting an invalid parent '[parent]'.")

	var/mutable_appearance/eye_left = mutable_appearance('icons/mob/human_face.dmi', "[eye_icon_state]_l", -BODY_LAYER)
	var/mutable_appearance/eye_right = mutable_appearance('icons/mob/human_face.dmi', "[eye_icon_state]_r", -BODY_LAYER)

	if(EYECOLOR in parent.dna?.species.species_traits)
		eye_right.color = "#[eye_color_right]"
		eye_left.color = "#[eye_color_left]"

	if(OFFSET_FACE in parent.dna?.species.offset_features)
		var/offset = parent.dna.species.offset_features[OFFSET_FACE]
		eye_left.pixel_x += offset[OFFSET_X]
		eye_right.pixel_x += offset[OFFSET_X]
		eye_left.pixel_y += offset[OFFSET_Y]
		eye_right.pixel_y += offset[OFFSET_Y]

	var/obscured = parent.check_obscured_slots(TRUE)
	if(overlay_ignore_lighting && !(obscured & ITEM_SLOT_EYES))
		eye_left.overlays += emissive_appearance(eye_left.icon, eye_left.icon_state, parent, alpha = eye_left.alpha)
		eye_right.overlays += emissive_appearance(eye_right.icon, eye_right.icon_state, parent, alpha = eye_right.alpha)

	return list(eye_left, eye_right)

#undef OFFSET_X
#undef OFFSET_Y

//Gotta reset the eye color, because that persists
/obj/item/organ/eyes/enter_wardrobe()
	. = ..()
	eye_color_left = initial(eye_color_left)
	eye_color_right = initial(eye_color_right)

/obj/item/organ/eyes/on_life(delta_time, times_fired)
	..()
	var/mob/living/carbon/eye_owner = owner
	//various degrees of "oh fuck my eyes", from "point a laser at your eye" to "staring at the Sun" intensities
	if(damage > 20)
		damaged = TRUE
		if((organ_flags & ORGAN_FAILING))
			eye_owner.become_blind(EYE_DAMAGE)
			return

		var/obj/item/clothing/glasses/eyewear = eye_owner.glasses
		var/has_prescription_glasses = istype(eyewear) && eyewear.vision_correction

		if(has_prescription_glasses)
			return

		var/severity = damage > 30 ? 2 : 1
		eye_owner.overlay_fullscreen("eye_damage", /atom/movable/screen/fullscreen/impaired, severity)
		return

	//called once since we don't want to keep clearing the screen of eye damage for people who are below 20 damage
	if(damaged)
		damaged = FALSE
		eye_owner.clear_fullscreen("eye_damage")
		eye_owner.cure_blind(EYE_DAMAGE)

/obj/item/organ/eyes/night_vision
	name = "теневые глаза"
	desc = "Жуткие глаза, способные видеть в темноте."
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	actions_types = list(/datum/action/item_action/organ_action/use)
	var/night_vision = TRUE

/obj/item/organ/eyes/night_vision/ui_action_click()
	sight_flags = initial(sight_flags)
	switch(lighting_alpha)
		if (LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	owner.update_sight()

/obj/item/organ/eyes/night_vision/alien
	name = "чужеродные глаза"
	desc = "Оказалось, они все-таки были!"
	sight_flags = SEE_MOBS

/obj/item/organ/eyes/night_vision/zombie
	name = "глаза нежити"
	desc = "Как ни странно, у этих полусгнивших глаз на самом деле зрение лучше, чем у живого человека."

/obj/item/organ/eyes/night_vision/nightmare
	name = "горящие красные глаза"
	desc = "Даже без их призрачного хозяина, глядя в эти глаза, вы испытываете чувство страха."
	icon_state = "burning_eyes"

/obj/item/organ/eyes/night_vision/mushroom
	name = "грибоглаза"
	desc = "Хотя снаружи они выглядят инертными и мертвыми, глаза грибных людей на самом деле очень развиты."

///Robotic

/obj/item/organ/eyes/robotic
	name = "глаза робота"
	icon_state = "cybernetic_eyeballs"
	desc = "Моё зрение аугментировано."
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/eyes/robotic/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	if(prob(10 * severity))
		return
	to_chat(owner, span_warning("Статика затуманивает моё зрение!"))
	owner.flash_act(visual = 1)

/obj/item/organ/eyes/robotic/xray
	name = "рентгеновские глаза"
	desc = "Эти кибернетические глаза дадут вам рентгеновское зрение. Моргать бесполезно."
	eye_color_left = "000"
	eye_color_right = "000"
	see_in_dark = 8
	sight_flags = SEE_MOBS | SEE_OBJS | SEE_TURFS

/obj/item/organ/eyes/robotic/thermals
	name = "термальные глаза"
	desc = "Эти кибернетические глазные имплантаты дадут вам тепловое зрение. Зрачок с вертикальной щелью включен."
	eye_color_left = "FC0"
	eye_color_right = "FC0"
	sight_flags = SEE_MOBS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	flash_protect = FLASH_PROTECTION_SENSITIVE
	see_in_dark = 8

/obj/item/organ/eyes/robotic/flashlight
	name = "глаза фонарики"
	desc = "Это два фонарика, соединенных проволокой. Зачем вы вбиваете это кому-то в голову?"
	eye_color_left ="fee5a3"
	eye_color_right ="fee5a3"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight_eyes"
	flash_protect = FLASH_PROTECTION_WELDER
	tint = INFINITY
	var/obj/item/flashlight/eyelight/eye

/obj/item/organ/eyes/robotic/flashlight/emp_act(severity)
	return

/obj/item/organ/eyes/robotic/flashlight/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = FALSE)
	..()
	if(!eye)
		eye = new /obj/item/flashlight/eyelight()
	eye.on = TRUE
	eye.forceMove(M)
	eye.update_brightness(M)
	M.become_blind("flashlight_eyes")


/obj/item/organ/eyes/robotic/flashlight/Remove(mob/living/carbon/M, special = 0)
	eye.on = FALSE
	eye.update_brightness(M)
	eye.forceMove(src)
	M.cure_blind("flashlight_eyes")
	..()

//  ЧБ глаза
/obj/item/organ/eyes/robotic/basic
	name = "базовые кибернетические глаза"
	desc = "Примитивный прототип протеза глаз способный видеть мир лишь в черно-белых оттенках, однако люди полностью лишенные зрения будут рады и такому."
	eye_color_left ="000000"
	eye_color_right ="000000"
	flash_protect = FLASH_PROTECTION_SENSITIVE

/obj/item/organ/eyes/robotic/basic/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = FALSE)
	..()
	M.add_client_colour(/datum/client_colour/monochrome)

/obj/item/organ/eyes/robotic/basic/Remove(mob/living/carbon/M, special = 0)
	..()
	M.remove_client_colour(/datum/client_colour/monochrome)

// Welding shield implant
/obj/item/organ/eyes/robotic/shield
	name = "кибернетические глаза"
	desc = "Встроенные светофильтры защитят вас от сварки и вспышек, не ограничивая обзор."
	flash_protect = FLASH_PROTECTION_WELDER

/obj/item/organ/eyes/robotic/shield/emp_act(severity)
	return

#define RGB2EYECOLORSTRING(definitionvar) ("[copytext_char(definitionvar, 2, 3)][copytext_char(definitionvar, 4, 5)][copytext_char(definitionvar, 6, 7)]")

/obj/item/organ/eyes/robotic/glow
	name = "люминесцирующие глаза"
	desc = "Особые светящиеся глаза, так же играют роль фонариков, однако не могут быть выключены. Цвет свечения можно изменять."
	eye_color_left = "000"
	eye_color_right = "000"
	actions_types = list(/datum/action/item_action/organ_action/use, /datum/action/item_action/organ_action/toggle)
	var/current_color_string = "#ffffff"
	var/active = FALSE
	var/max_light_beam_distance = 5
	var/light_beam_distance = 5
	var/light_object_range = 2
	var/light_object_power = 2
	var/list/obj/effect/abstract/eye_lighting/eye_lighting
	var/obj/effect/abstract/eye_lighting/on_mob
	var/image/mob_overlay
	var/datum/component/mobhook

/obj/item/organ/eyes/robotic/glow/Initialize(mapload)
	. = ..()
	mob_overlay = image('icons/mob/human_face.dmi', "eyes_glow_gs")

/obj/item/organ/eyes/robotic/glow/Destroy()
	terminate_effects()
	. = ..()

/obj/item/organ/eyes/robotic/glow/Remove(mob/living/carbon/M, special = FALSE)
	terminate_effects()
	. = ..()

/obj/item/organ/eyes/robotic/glow/proc/terminate_effects()
	if(owner && active)
		deactivate()
	active = FALSE
	clear_visuals(TRUE)
	STOP_PROCESSING(SSfastprocess, src)

/obj/item/organ/eyes/robotic/glow/ui_action_click(owner, action)
	if(istype(action, /datum/action/item_action/organ_action/toggle))
		toggle_active()
	else if(istype(action, /datum/action/item_action/organ_action/use))
		prompt_for_controls(owner)

/obj/item/organ/eyes/robotic/glow/proc/toggle_active()
	if(active)
		deactivate()
	else
		activate()

/obj/item/organ/eyes/robotic/glow/proc/prompt_for_controls(mob/user)
	var/C = input(owner, "Цвет", "Цвет?", "#ffffff") as color|null
	if(!C || QDELETED(src) || QDELETED(user) || QDELETED(owner) || owner != user)
		return
	var/range = input(user, "Радиус (0 - [max_light_beam_distance])", "Радиус?", 0) as null|num
	var/old_active = active // Get old active because set_distance() -> clear_visuals()  will set it to FALSE.
	set_distance(clamp(range, 0, max_light_beam_distance))
	assume_rgb(C)
	// Reactivate if eyes were already active for real time colour swapping!
	if(old_active)
		activate(FALSE)

/obj/item/organ/eyes/robotic/glow/proc/assume_rgb(newcolor)
	current_color_string = newcolor
	eye_color_left = RGB2EYECOLORSTRING(current_color_string)
	eye_color_right = eye_color_left
	if(!QDELETED(owner) && ishuman(owner))		//Other carbon mobs don't have eye color.
		owner.dna.species.handle_body(owner)

/obj/item/organ/eyes/robotic/glow/proc/cycle_mob_overlay()
	remove_mob_overlay()
	mob_overlay.color = current_color_string
	add_mob_overlay()

/obj/item/organ/eyes/robotic/glow/proc/add_mob_overlay()
	if(!QDELETED(owner))
		owner.add_overlay(mob_overlay)

/obj/item/organ/eyes/robotic/glow/proc/remove_mob_overlay()
	if(!QDELETED(owner))
		owner.cut_overlay(mob_overlay)

/obj/item/organ/eyes/robotic/glow/emp_act()
	. = ..()
	if(!active || . & EMP_PROTECT_SELF)
		return
	deactivate(silent = TRUE)

/obj/item/organ/eyes/robotic/glow/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = FALSE)
	. = ..()
	RegisterSignal(M, COMSIG_ATOM_DIR_CHANGE, PROC_REF(update_visuals))

/obj/item/organ/eyes/robotic/glow/Remove(mob/living/carbon/M, special = FALSE)
	. = ..()
	UnregisterSignal(M, COMSIG_ATOM_DIR_CHANGE)

/obj/item/organ/eyes/robotic/glow/Destroy()
	QDEL_NULL(mobhook) // mobhook is not our component
	return ..()

/obj/item/organ/eyes/robotic/glow/proc/activate(silent = FALSE)
	start_visuals()
	if(!silent)
		to_chat(owner, span_warning("Мои [src.name] щёлкают, перед тем как выпустить жёсткий луч света!"))
	cycle_mob_overlay()

/obj/item/organ/eyes/robotic/glow/proc/deactivate(silent = FALSE)
	clear_visuals()
	if(!silent)
		to_chat(owner, span_warning("Мои [src.name] вырубаются!"))
	remove_mob_overlay()

/obj/item/organ/eyes/robotic/glow/proc/update_visuals(datum/source, olddir, newdir)
	if(!active)
		return // Don't update if we're not active!
	if((LAZYLEN(eye_lighting) < light_beam_distance) || !on_mob)
		regenerate_light_effects()
	var/turf/scanfrom = get_turf(owner)
	var/scandir = owner.dir
	if (newdir && scandir != newdir) // COMSIG_ATOM_DIR_CHANGE happens before the dir change, but with a reference to the new direction.
		scandir = newdir
	if(!istype(scanfrom))
		clear_visuals()
	var/turf/scanning = scanfrom
	var/stop = FALSE
	on_mob.set_light_flags(on_mob.light_flags & ~LIGHT_ATTACHED)
	on_mob.forceMove(scanning)
	for(var/i in 1 to light_beam_distance)
		scanning = get_step(scanning, scandir)
		if(IS_OPAQUE_TURF(scanning))
			stop = TRUE
		var/obj/effect/abstract/eye_lighting/L = LAZYACCESS(eye_lighting, i)
		if(stop)
			L.forceMove(src)
		else
			L.forceMove(scanning)

/obj/item/organ/eyes/robotic/glow/proc/clear_visuals(delete_everything = FALSE)
	if(delete_everything)
		QDEL_LIST(eye_lighting)
		QDEL_NULL(on_mob)
	else
		for(var/i in eye_lighting)
			var/obj/effect/abstract/eye_lighting/L = i
			L.forceMove(src)
		if(!QDELETED(on_mob))
			on_mob.set_light_flags(on_mob.light_flags | LIGHT_ATTACHED)
			on_mob.forceMove(src)
	active = FALSE

/obj/item/organ/eyes/robotic/glow/proc/start_visuals()
	if(!islist(eye_lighting))
		eye_lighting = list()
		regenerate_light_effects()
	if((eye_lighting.len < light_beam_distance) || !on_mob)
		regenerate_light_effects()
	sync_light_effects()
	active = TRUE
	update_visuals()

/obj/item/organ/eyes/robotic/glow/proc/set_distance(dist)
	light_beam_distance = dist
	regenerate_light_effects()

/obj/item/organ/eyes/robotic/glow/proc/regenerate_light_effects()
	clear_visuals(TRUE)
	on_mob = new (src, light_object_range, light_object_power, current_color_string, LIGHT_ATTACHED)
	for(var/i in 1 to light_beam_distance)
		LAZYADD(eye_lighting, new /obj/effect/abstract/eye_lighting(src, light_object_range, light_object_power, current_color_string))
	sync_light_effects()


/obj/item/organ/eyes/robotic/glow/proc/sync_light_effects()
	for(var/e in eye_lighting)
		var/obj/effect/abstract/eye_lighting/eye_lighting = e
		eye_lighting.set_light_color(current_color_string)
	on_mob?.set_light_color(current_color_string)


/obj/effect/abstract/eye_lighting
	light_system = MOVABLE_LIGHT
	var/obj/item/organ/eyes/robotic/glow/parent


/obj/effect/abstract/eye_lighting/Initialize(mapload, light_object_range, light_object_power, current_color_string, light_flags)
	. = ..()
	parent = loc
	if(!istype(parent))
		stack_trace("/obj/effect/abstract/eye_lighting added to improper parent ([loc]). Deleting.")
		return INITIALIZE_HINT_QDEL
	if(!isnull(light_object_range))
		set_light_range(light_object_range)
	if(!isnull(light_object_power))
		set_light_power(light_object_power)
	if(!isnull(current_color_string))
		set_light_color(current_color_string)
	if(!isnull(light_flags))
		set_light_flags(light_flags)


/obj/item/organ/eyes/moth
	name = "глаза мотылька"
	desc = "Эти глаза, кажется, имеют повышенную чувствительность к яркому свету без улучшения зрения при слабом освещении."
	flash_protect = FLASH_PROTECTION_SENSITIVE

/obj/item/organ/eyes/snail
	name = "глаза улитки"
	desc = "Кажется, что эти глаза имеют большой диапазон, но могут быть громоздкими с очками."
	eye_icon_state = "snail_eyes"
	icon_state = "snail_eyeballs"

/obj/item/organ/eyes/fly
	name = "глаза мухи"
	desc = "Эти глаза, кажется, смотрят в ответ независимо от того, с какой стороны вы смотрите на них."
	eye_icon_state = "flyeyes"
	icon_state = "eyeballs-fly"
	flash_protect = FLASH_PROTECTION_HYPER_SENSITIVE
	native_fov = NONE //flies can see all around themselves.

/obj/item/organ/eyes/fly/Insert(mob/living/carbon/M, special = FALSE)
	. = ..()
	ADD_TRAIT(M, TRAIT_FLASH_SENSITIVE, ORGAN_TRAIT)

/obj/item/organ/eyes/fly/Remove(mob/living/carbon/M, special = FALSE)
	REMOVE_TRAIT(M, TRAIT_FLASH_SENSITIVE, ORGAN_TRAIT)
	return ..()

/obj/item/organ/eyes/night_vision/maintenance_adapted
	name = "adapted eyes"
	desc = "These red eyes look like two foggy marbles. They give off a particularly worrying glow in the dark."
	flash_protect = FLASH_PROTECTION_HYPER_SENSITIVE
	eye_color_left = "f00"
	eye_color_right = "f00"
	icon_state = "adapted_eyes"
	eye_icon_state = "eyes_glow"
	overlay_ignore_lighting = TRUE
	var/obj/item/flashlight/eyelight/adapted/adapt_light

/obj/item/organ/eyes/night_vision/maintenance_adapted/Initialize(mapload)
	. = ..()

/obj/item/organ/eyes/night_vision/maintenance_adapted/Insert(mob/living/carbon/adapted, special = FALSE)
	. = ..()
	//add lighting
	if(!adapt_light)
		adapt_light = new /obj/item/flashlight/eyelight/adapted()
	adapt_light.on = TRUE
	adapt_light.forceMove(adapted)
	adapt_light.update_brightness(adapted)
	//traits
	ADD_TRAIT(adapted, TRAIT_FLASH_SENSITIVE, ORGAN_TRAIT)
	ADD_TRAIT(adapted, TRAIT_CULT_EYES, ORGAN_TRAIT)

/obj/item/organ/eyes/night_vision/maintenance_adapted/on_life(delta_time, times_fired)
	var/turf/owner_turf = get_turf(owner)
	var/lums = owner_turf.get_lumcount()
	if(lums > 0.5) //we allow a little more than usual so we can produce light from the adapted eyes
		to_chat(owner, span_danger("Your eyes! They burn in the light!"))
		applyOrganDamage(10) //blind quickly
		playsound(owner, 'sound/machines/grill/grillsizzle.ogg', 50)
	else
		applyOrganDamage(-10) //heal quickly
	. = ..()

/obj/item/organ/eyes/night_vision/maintenance_adapted/Remove(mob/living/carbon/unadapted, special = FALSE)
	//remove lighting
	adapt_light.on = FALSE
	adapt_light.update_brightness(unadapted)
	adapt_light.forceMove(src)
	//traits
	REMOVE_TRAIT(unadapted, TRAIT_FLASH_SENSITIVE, ORGAN_TRAIT)
	REMOVE_TRAIT(unadapted, TRAIT_CULT_EYES, ORGAN_TRAIT)
	return ..()