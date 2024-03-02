/// Keys are [/datum/air_alarm_mode] paths
/// Values are their respective instances.
GLOBAL_LIST_INIT(air_alarm_modes, init_air_alarm_modes())

/proc/init_air_alarm_modes()
	var/list/ret = list()
	for(var/mode_path in subtypesof(/datum/air_alarm_mode))
		ret[mode_path] = new mode_path
	return ret

/// Various modes that an [/obj/machinery/airalarm] can assume.
/datum/air_alarm_mode
	/// Name of the mode.
	var/name
	/// More detail on the mode.
	var/desc
	/// TRUE if this mode can be dangerous if selected.
	var/danger
	/// TRUE if the air alarm needs to be emagged for this to be selected.
	var/emag = FALSE

/** The proc that runs when this air alarm mode is selected.
 *
 * Arguments:
 * * applied - which area will we apply this mode to.
 */
/datum/air_alarm_mode/proc/apply(area/applied)
	return

/datum/air_alarm_mode/proc/replace(area/applied, pressure)
	return

/// The default.
/datum/air_alarm_mode/filtering
	name = "Фильтрация"
	desc = "откачивает все вредные газы"
	danger = FALSE

/datum/air_alarm_mode/filtering/apply(area/applied)
	for (var/obj/machinery/atmospherics/components/unary/vent_pump/vent as anything in applied.air_vents)
		vent.on = TRUE
		vent.pressure_checks = ATMOS_EXTERNAL_BOUND
		vent.external_pressure_bound = ONE_ATMOSPHERE
		vent.pump_direction = ATMOS_DIRECTION_RELEASING
		vent.update_appearance(UPDATE_ICON)

	for (var/obj/machinery/atmospherics/components/unary/vent_scrubber/scrubber as anything in applied.air_scrubbers)
		scrubber.on = TRUE
		scrubber.filter_types = list(/datum/gas/carbon_dioxide)
		scrubber.set_scrubbing(ATMOS_DIRECTION_SCRUBBING)
		scrubber.set_widenet(FALSE)

/datum/air_alarm_mode/contaminated
	name = "Чистка"
	desc = "откачивает все вредные газы БЫСТРО"
	danger = FALSE

/datum/air_alarm_mode/contaminated/apply(area/applied)
	for (var/obj/machinery/atmospherics/components/unary/vent_pump/vent as anything in applied.air_vents)
		vent.on = TRUE
		vent.pressure_checks = ATMOS_EXTERNAL_BOUND
		vent.external_pressure_bound = ONE_ATMOSPHERE
		vent.pump_direction = ATMOS_DIRECTION_RELEASING
		vent.update_appearance(UPDATE_ICON)

	var/list/filtered = subtypesof(/datum/gas)
	filtered -= list(/datum/gas/oxygen, /datum/gas/nitrogen)
	for (var/obj/machinery/atmospherics/components/unary/vent_scrubber/scrubber as anything in applied.air_scrubbers)
		scrubber.on = TRUE
		scrubber.filter_types = filtered.Copy()
		scrubber.set_scrubbing(ATMOS_DIRECTION_SCRUBBING)
		scrubber.set_widenet(TRUE)

/datum/air_alarm_mode/draught
	name = "Перекачка"
	desc = "откачивает воздух, пока вкачивает новый"
	danger = FALSE

/datum/air_alarm_mode/draught/apply(area/applied)
	for (var/obj/machinery/atmospherics/components/unary/vent_pump/vent as anything in applied.air_vents)
		vent.on = TRUE
		vent.pressure_checks = ATMOS_EXTERNAL_BOUND
		vent.external_pressure_bound = ONE_ATMOSPHERE * 2
		vent.pump_direction = ATMOS_DIRECTION_RELEASING
		vent.update_appearance(UPDATE_ICON)

	for (var/obj/machinery/atmospherics/components/unary/vent_scrubber/scrubber as anything in applied.air_scrubbers)
		scrubber.on = TRUE
		scrubber.set_widenet(FALSE)
		scrubber.set_scrubbing(ATMOS_DIRECTION_SIPHONING)

/datum/air_alarm_mode/refill
	name = "Закачка х3"
	desc = "тройная скорость наполнения"
	danger = TRUE

/datum/air_alarm_mode/refill/apply(area/applied)
	for (var/obj/machinery/atmospherics/components/unary/vent_pump/vent as anything in applied.air_vents)
		vent.on = TRUE
		vent.pressure_checks = ATMOS_EXTERNAL_BOUND
		vent.external_pressure_bound = ONE_ATMOSPHERE * 3
		vent.pump_direction = ATMOS_DIRECTION_RELEASING
		vent.update_appearance(UPDATE_ICON)

	for (var/obj/machinery/atmospherics/components/unary/vent_scrubber/scrubber as anything in applied.air_scrubbers)
		scrubber.on = TRUE

		scrubber.filter_types = list(/datum/gas/carbon_dioxide)
		scrubber.set_widenet(FALSE)
		scrubber.set_scrubbing(ATMOS_DIRECTION_SCRUBBING)

/datum/air_alarm_mode/cycle
	name = "Цикл"
	desc = "откачивает весь воздух и потом наполняет"
	danger = TRUE

/// Same as [/datum/air_alarm_mode/siphon/apply]
/datum/air_alarm_mode/cycle/apply(area/applied)
	for (var/obj/machinery/atmospherics/components/unary/vent_pump/vent as anything in applied.air_vents)
		vent.on = FALSE
		vent.update_appearance(UPDATE_ICON)

	for (var/obj/machinery/atmospherics/components/unary/vent_scrubber/scrubber as anything in applied.air_scrubbers)
		scrubber.on = TRUE
		scrubber.set_widenet(TRUE)
		scrubber.set_scrubbing(ATMOS_DIRECTION_SIPHONING)

/// Special case for cycles. Cycles need to refill the air again after it's scrubbed out so this proc is called.
/// Same as [/datum/air_alarm_mode/filtering/apply]
/datum/air_alarm_mode/cycle/replace(area/applied, pressure)
	if(pressure >= ONE_ATMOSPHERE * 0.05)
		return

	for (var/obj/machinery/atmospherics/components/unary/vent_pump/vent as anything in applied.air_vents)
		vent.on = TRUE
		vent.pressure_checks = ATMOS_EXTERNAL_BOUND
		vent.external_pressure_bound = ONE_ATMOSPHERE
		vent.pump_direction = ATMOS_DIRECTION_RELEASING
		vent.update_appearance(UPDATE_ICON)

	for (var/obj/machinery/atmospherics/components/unary/vent_scrubber/scrubber as anything in applied.air_scrubbers)
		scrubber.on = TRUE
		scrubber.filter_types = list(/datum/gas/carbon_dioxide)
		scrubber.set_scrubbing(ATMOS_DIRECTION_SCRUBBING)
		scrubber.set_widenet(FALSE)

/datum/air_alarm_mode/siphon
	name = "Откачка"
	desc = "откачивает воздух из помещения"
	danger = TRUE

/datum/air_alarm_mode/siphon/apply(area/applied)
	for (var/obj/machinery/atmospherics/components/unary/vent_pump/vent as anything in applied.air_vents)
		vent.on = FALSE
		vent.update_appearance(UPDATE_ICON)

	for (var/obj/machinery/atmospherics/components/unary/vent_scrubber/scrubber as anything in applied.air_scrubbers)
		scrubber.on = TRUE
		scrubber.set_widenet(FALSE)
		scrubber.set_scrubbing(ATMOS_DIRECTION_SIPHONING)

/datum/air_alarm_mode/panic_siphon
	name = "Быстрая откачка"
	desc = "откачивает воздух быстро"
	danger = TRUE

/datum/air_alarm_mode/panic_siphon/apply(area/applied)
	for (var/obj/machinery/atmospherics/components/unary/vent_pump/vent as anything in applied.air_vents)
		vent.on = FALSE
		vent.update_appearance(UPDATE_ICON)

	for (var/obj/machinery/atmospherics/components/unary/vent_scrubber/scrubber as anything in applied.air_scrubbers)
		scrubber.on = TRUE
		scrubber.set_widenet(TRUE)
		scrubber.set_scrubbing(ATMOS_DIRECTION_SIPHONING)

/datum/air_alarm_mode/off
	name = "Выключить"
	desc = "отключает вентиляцию полностью"
	danger = FALSE

/datum/air_alarm_mode/off/apply(area/applied)
	for (var/obj/machinery/atmospherics/components/unary/vent_pump/vent as anything in applied.air_vents)
		vent.on = FALSE
		vent.update_appearance(UPDATE_ICON)

	for (var/obj/machinery/atmospherics/components/unary/vent_scrubber/scrubber as anything in applied.air_scrubbers)
		scrubber.on = FALSE
		scrubber.update_appearance(UPDATE_ICON)

/datum/air_alarm_mode/flood
	name = "Заполнение"
	desc = "Выключает фильтры и включает вентиляцию на полную"
	danger = TRUE
	emag = TRUE

/datum/air_alarm_mode/flood/apply(area/applied)
	for (var/obj/machinery/atmospherics/components/unary/vent_pump/vent as anything in applied.air_vents)
		vent.on = TRUE
		vent.pressure_checks = ATMOS_INTERNAL_BOUND
		vent.internal_pressure_bound = 0
		vent.pump_direction = ATMOS_DIRECTION_RELEASING
		vent.update_appearance(UPDATE_ICON)

	for (var/obj/machinery/atmospherics/components/unary/vent_scrubber/scrubber as anything in applied.air_scrubbers)
		scrubber.on = FALSE
		scrubber.update_appearance(UPDATE_ICON)

/datum/air_alarm_mode/vent_siphon
	name = "В вентиляцию"
	desc = "Выключает фильтры и ставит вентиляцию в режим откачки"
	danger = TRUE
	emag = TRUE // siphoning things with vents can horribly fuck up distro, even if its surprisingly fast

/datum/air_alarm_mode/vent_siphon/apply(area/applied)
	for (var/obj/machinery/atmospherics/components/unary/vent_pump/vent as anything in applied.air_vents)
		vent.on = TRUE
		vent.pressure_checks = NONE
		vent.internal_pressure_bound = 0
		vent.external_pressure_bound = 0
		vent.pump_direction = ATMOS_DIRECTION_SIPHONING
		vent.update_appearance(UPDATE_ICON)

	for (var/obj/machinery/atmospherics/components/unary/vent_scrubber/scrubber as anything in applied.air_scrubbers)
		scrubber.on = FALSE
		scrubber.update_appearance(UPDATE_ICON)
