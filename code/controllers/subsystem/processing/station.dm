PROCESSING_SUBSYSTEM_DEF(station)
	name = "Станция"
	init_order = INIT_ORDER_STATION
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	wait = 5 SECONDS

	///A list of currently active station traits
	var/list/station_traits = list()
	///Assoc list of trait type || assoc list of traits with weighted value. Used for picking traits from a specific category.
	var/list/selectable_traits_by_types = list(STATION_TRAIT_POSITIVE = list(), STATION_TRAIT_NEUTRAL = list(), STATION_TRAIT_NEGATIVE = list())
	///Currently active announcer. Starts as a type but gets initialized after traits are selected
	var/datum/centcom_announcer/announcer = /datum/centcom_announcer/default

/datum/controller/subsystem/processing/station/Initialize()

	//If doing unit tests we don't do none of that trait shit ya know?
	// Autowiki also wants consistent outputs, for example making sure the vending machine page always reports the normal products
	#if !defined(UNIT_TESTS) && !defined(AUTOWIKI)
	SetupTraits()
	#endif

	var/datum/centcom_announcer/announcer_datum = pick(
		/datum/centcom_announcer/default,
		/datum/centcom_announcer/va,
		/datum/centcom_announcer/xrenoid,
		/datum/centcom_announcer/intern,
		/datum/centcom_announcer/gayse)

	announcer = new announcer_datum

	return SS_INIT_SUCCESS

///Rolls for the amount of traits and adds them to the traits list
/datum/controller/subsystem/processing/station/proc/SetupTraits()
	for(var/i in subtypesof(/datum/station_trait))
		var/datum/station_trait/trait_typepath = i

		// If forced, (probably debugging), just set it up now, keep it out of the pool.
		if(initial(trait_typepath.force))
			setup_trait(trait_typepath)
			continue

		if(initial(trait_typepath.trait_flags) & STATION_TRAIT_ABSTRACT)
			continue //Dont add abstract ones to it
		selectable_traits_by_types[initial(trait_typepath.trait_type)][trait_typepath] = initial(trait_typepath.weight)

	var/positive_trait_count = pick(20;0, 5;1, 1;2)
	var/neutral_trait_count = pick(10;0, 10;1, 3;2)
	var/negative_trait_count = pick(20;0, 5;1, 1;2)

	pick_traits(STATION_TRAIT_POSITIVE, positive_trait_count)
	pick_traits(STATION_TRAIT_NEUTRAL, neutral_trait_count)
	pick_traits(STATION_TRAIT_NEGATIVE, negative_trait_count)

///Picks traits of a specific category (e.g. bad or good) and a specified amount, then initializes them and adds them to the list of traits.
/datum/controller/subsystem/processing/station/proc/pick_traits(trait_sign, amount)
	if(!amount)
		return
	for(var/iterator in 1 to amount)
		var/datum/station_trait/trait_type = pick_weight(selectable_traits_by_types[trait_sign]) //Rolls from the table for the specific trait type
		setup_trait(trait_type)

///Creates a given trait of a specific type, while also removing any blacklisted ones from the future pool.
/datum/controller/subsystem/processing/station/proc/setup_trait(datum/station_trait/trait_type)
	var/datum/station_trait/trait_instance = new trait_type()
	station_traits += trait_instance
	if(!trait_instance.blacklist)
		return
	for(var/i in trait_instance.blacklist)
		var/datum/station_trait/trait_to_remove = i
		selectable_traits_by_types[initial(trait_to_remove.trait_type)] -= trait_to_remove