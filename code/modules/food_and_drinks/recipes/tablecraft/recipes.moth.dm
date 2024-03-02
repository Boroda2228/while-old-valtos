/datum/crafting_recipe/food/herby_cheese
	name = "Сыр с травами"
	reqs = list(
		/obj/item/food/curd_cheese = 1,
		/obj/item/food/grown/herbs = 4
	)
	result = /obj/item/food/herby_cheese
	category = CAT_MOTH

/datum/crafting_recipe/food/mothic_salad
	name = "Салат для молей"
	reqs = list(
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/onion_slice/red = 2,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/mothic_salad
	category = CAT_MOTH

/datum/crafting_recipe/food/toasted_seeds
	name = "Поджаренные семена"
	reqs = list(
		/obj/item/seeds/sunflower = 1,
		/obj/item/seeds/pumpkin = 1,
		/obj/item/seeds/poppy = 1,
		/datum/reagent/consumable/quality_oil = 2
	)
	result = /obj/item/food/toasted_seeds
	category = CAT_MOTH

/datum/crafting_recipe/food/engine_fodder
	name = "Закуска для инженеров"
	reqs = list(
		/obj/item/food/toasted_seeds = 1,
		/obj/item/food/cnds = 1,
		/obj/item/food/popcorn = 1,
		/obj/item/food/peanuts = 1,
		/obj/item/food/chips = 1
	)
	result = /obj/item/food/engine_fodder
	category = CAT_MOTH

/datum/crafting_recipe/food/squeaking_stir_fry
	name = "Skeklitmischtpoppl (Стир фрай)"
	reqs = list(
		/obj/item/food/cheese_curds = 1,
		/obj/item/food/tofu = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/salad/boiledrice = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/onion_slice = 1
	)
	result = /obj/item/food/squeaking_stir_fry
	category = CAT_MOTH

/datum/crafting_recipe/food/sweet_chili_cabbage_wrap
	name = "Капустный ролл с чили"
	reqs = list(
		/obj/item/food/grilled_cheese = 1,
		/obj/item/food/mothic_salad = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/cabbage = 1,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/food/sweet_chili_cabbage_wrap
	category = CAT_MOTH

/datum/crafting_recipe/food/loaded_curds
	name = "Ozlsettitæloskekllön ede pommes (Творожный сыр во фритюре)"
	reqs = list(
		/obj/item/food/cheese_curds = 1,
		/obj/item/food/soup/vegetarian_chili = 1,
		/obj/item/food/onion_slice = 1,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/fries = 1
	)
	result = /obj/item/food/loaded_curds
	category = CAT_MOTH

/datum/crafting_recipe/food/baked_cheese_platter
	name = "Мольское фондю"
	reqs = list(
		/obj/item/food/baked_cheese = 1,
		/obj/item/food/griddle_toast = 3
	)
	result = /obj/item/food/baked_cheese_platter
	category = CAT_MOTH

/datum/crafting_recipe/food/raw_green_lasagne
	name = "Сырая зеленая лазанья аль Форно"
	reqs = list(
		/obj/item/food/pesto = 1,
		/obj/item/food/spaghetti/boiledspaghetti = 2,
		/obj/item/food/bechamel_sauce = 1,
		/obj/item/food/firm_cheese = 1
	)
	result = /obj/item/food/raw_green_lasagne
	category = CAT_MOTH

/datum/crafting_recipe/food/raw_baked_rice
	name = "Сырой плов по Мольски"
	reqs = list(
		/obj/item/food/salad/boiledrice = 2,
		/obj/item/food/soup/vegetable = 1,
		/obj/item/food/grown/potato = 2,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/herbs = 1
	)
	result = /obj/item/food/raw_baked_rice
	category = CAT_MOTH

/datum/crafting_recipe/food/buttered_baked_corn
	name = "Запеченная кукуруза с маслом"
	reqs = list(
		/obj/item/food/oven_baked_corn = 1,
		/obj/item/food/butter = 1
	)
	result = /obj/item/food/buttered_baked_corn
	category = CAT_MOTH

/datum/crafting_recipe/food/fiesta_corn_skillet
	name = "Кукурузная фиеста на сковороде"
	reqs = list(
		/obj/item/food/oven_baked_corn = 1,
		/obj/item/food/cornchips = 1,
		/obj/item/food/grown/chili = 2,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/onion_slice = 2,
		/obj/item/food/cheesewedge = 1
	)
	result = /obj/item/food/fiesta_corn_skillet
	category = CAT_MOTH

/datum/crafting_recipe/food/ratatouille
	name = "Рататуй"
	reqs = list(
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/onion/red = 1,
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/roasted_bell_pepper = 1
	)
	result = /obj/item/food/raw_ratatouille
	category = CAT_MOTH

/datum/crafting_recipe/food/mozzarella_sticks
	name = "Палочки из моцареллы во фритюре"
	reqs = list(
		/obj/item/food/mozzarella = 1,
		/obj/item/food/breadslice = 2,
		/obj/item/food/tomato_sauce = 1
	)
	result = /obj/item/food/mozzarella_sticks
	category = CAT_MOTH

/datum/crafting_recipe/food/raw_stuffed_peppers
	name = "Voltölpapriken (Фаршированные перцы)"
	reqs = list(
		/obj/item/food/grown/bell_pepper = 1,
		/obj/item/food/herby_cheese = 1,
		/obj/item/food/onion_slice = 2
	)
	result = /obj/item/food/raw_stuffed_peppers
	category = CAT_MOTH

/datum/crafting_recipe/food/fueljacks_lunch
	name = "Обед заправщика"
	reqs = list(
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/onion_slice = 2,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/firm_cheese_slice = 1
	)
	result = /obj/item/food/fueljacks_lunch
	category = CAT_MOTH

/datum/crafting_recipe/food/mac_balls
	name = "Macheronirölen (Макаронные шарики с сыром)"
	reqs = list(
		/obj/item/food/ready_donk/warm/mac_n_cheese = 1,
		/obj/item/food/tomato_sauce = 1,
		/datum/reagent/consumable/cornmeal_batter = 5
	)
	result = /obj/item/food/mac_balls
	category = CAT_MOTH

/datum/crafting_recipe/food/moth_cotton_soup
	name = "Flöfrölenmæsch (Суп с клёцками из хлопка )"
	reqs = list(
		/obj/item/grown/cotton = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/oven_baked_corn = 1,
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1
	)
	result = /obj/item/food/soup/moth_cotton_soup
	category = CAT_MOTH

/datum/crafting_recipe/food/moth_cheese_soup
	name = "Ælosterrmæsch (Сырный суп)"
	reqs = list(
		/obj/item/food/cheesewedge = 2,
		/obj/item/food/butter = 1,
		/obj/item/food/grown/potato/sweet = 1,
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/milk = 5,
		/obj/item/reagent_containers/glass/bowl = 1
	)
	result = /obj/item/food/soup/moth_cheese_soup
	category = CAT_MOTH

/datum/crafting_recipe/food/moth_seed_soup
	name = "Misklmæsch (Суп с семянами)"
	reqs = list(
		/obj/item/seeds/sunflower = 1,
		/obj/item/seeds/poppy/lily = 1,
		/obj/item/seeds/ambrosia = 1,
		/datum/reagent/water = 10,
		/datum/reagent/consumable/vinegar = 5,
		/obj/item/reagent_containers/glass/bowl = 1
	)
	result = /obj/item/food/soup/moth_seed_soup
	category = CAT_MOTH

/datum/crafting_recipe/food/moth_bean_stew
	name = "Prickeldröndolhaskl (Острая тушеная фасоль)"
	reqs = list(
		/obj/item/food/canned/beans = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/oven_baked_corn = 1,
		/datum/reagent/water = 5,
		/obj/item/reagent_containers/glass/bowl = 1
	)
	result = /obj/item/food/soup/moth_bean_stew
	category = CAT_MOTH

/datum/crafting_recipe/food/moth_oat_stew
	name = "Häfmisklhaskl (Овсяное рагу)"
	reqs = list(
		/obj/item/food/grown/oat = 1,
		/obj/item/food/grown/potato/sweet = 1,
		/obj/item/food/grown/parsnip = 1,
		/obj/item/food/grown/carrot = 1,
		/datum/reagent/water = 5,
		/obj/item/reagent_containers/glass/bowl = 1
	)
	result = /obj/item/food/soup/moth_oat_stew
	category = CAT_MOTH

/datum/crafting_recipe/food/moth_fire_soup
	name = "Tömpröttkrakklmæsch (Изжоговый суп)"
	reqs = list(
		/obj/item/food/grown/ghost_chili = 1,
		/obj/item/food/tofu = 1,
		/datum/reagent/consumable/yoghurt = 10,
		/datum/reagent/consumable/vinegar = 2,
		/obj/item/reagent_containers/glass/bowl = 1
	)
	result = /obj/item/food/soup/moth_fire_soup
	category = CAT_MOTH

/datum/crafting_recipe/food/rice_porridge
	name = "Рисовая каша"
	reqs = list(
		/obj/item/food/salad/ricebowl = 1,
		/datum/reagent/water = 10,
		/datum/reagent/consumable/salt = 2
	)
	result = /obj/item/food/soup/rice_porridge
	category = CAT_MOTH

/datum/crafting_recipe/food/hua_mulan_congee
	name = "Отвар Хуа Мулань"
	reqs = list(
		/obj/item/food/soup/rice_porridge = 1,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/friedegg = 2
	)
	result = /obj/item/food/soup/hua_mulan_congee
	category = CAT_MOTH

/datum/crafting_recipe/food/toechtauese_rice_porridge
	name = "Острая рисовая каша"
	reqs = list(
		/obj/item/food/soup/rice_porridge = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/toechtauese_syrup = 5
	)
	result = /obj/item/food/soup/toechtauese_rice_porridge
	category = CAT_MOTH

/datum/crafting_recipe/food/cornmeal_porridge
	name = "Кукурузная каша"
	reqs = list(
		/datum/reagent/consumable/cornmeal = 10,
		/datum/reagent/water = 10,
		/obj/item/reagent_containers/glass/bowl = 1
	)
	result = /obj/item/food/soup/cornmeal_porridge
	category = CAT_MOTH

/datum/crafting_recipe/food/cheesy_porridge
	name = "Сырная каша"
	reqs = list(
		/obj/item/food/soup/cornmeal_porridge = 1,
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/firm_cheese = 1,
		/obj/item/food/curd_cheese = 1,
		/obj/item/food/butter = 1
	)
	result = /obj/item/food/soup/cheesy_porridge
	category = CAT_MOTH

/datum/crafting_recipe/food/fried_eggplant_polenta
	name = "Жареные баклажаны с полентой"
	reqs = list(
		/obj/item/food/soup/cheesy_porridge = 1,
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/breadslice = 2,
		/obj/item/food/tomato_sauce = 1,
		/obj/item/food/mozzarella = 1
	)
	result = /obj/item/food/soup/fried_eggplant_polenta
	category = CAT_MOTH

/datum/crafting_recipe/food/caprese_salad
	name = "Салат Капрезе"
	reqs = list(
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/mozzarella = 1,
		/obj/item/food/grown/herbs = 1,
		/datum/reagent/consumable/quality_oil = 2,
		/datum/reagent/consumable/vinegar = 2
	)
	result = /obj/item/food/caprese_salad
	category = CAT_MOTH

/datum/crafting_recipe/food/fleet_salad
	name = "Lörtonknusksolt (Салат \"Флит\")"
	reqs = list(
		/obj/item/food/mothic_salad = 1,
		/obj/item/food/grilled_cheese = 1,
		/obj/item/food/breadslice = 1,
		/obj/item/food/grown/carrot = 1,
		/datum/reagent/consumable/quality_oil = 2,
		/datum/reagent/consumable/vinegar = 2
	)
	result = /obj/item/food/salad/fleet_salad
	category = CAT_MOTH

/datum/crafting_recipe/food/cotton_salad
	name = "Flöfrölenknusksolt (Салат из хлопка)"
	reqs = list(
		/obj/item/food/mothic_salad = 1,
		/obj/item/grown/cotton = 2,
		/obj/item/food/grown/carrot = 1,
		/datum/reagent/consumable/quality_oil = 2,
		/datum/reagent/consumable/vinegar = 2
	)
	result = /obj/item/food/salad/fleet_salad
	category = CAT_MOTH

/datum/crafting_recipe/food/moth_kachumbari
	name = "Качумбари (Кенийский салат)"
	reqs = list(
		/obj/item/food/oven_baked_corn = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/onion/red = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/herbs = 1,
		/datum/reagent/consumable/limejuice = 2
	)
	result = /obj/item/food/salad/moth_kachumbari
	category = CAT_MOTH

/datum/crafting_recipe/food/raw_mothic_margherita
	name = "Пицца Маргарита для молей"
	reqs = list(
		/obj/item/food/mothic_pizza_dough = 1,
		/obj/item/food/tomato_sauce = 1,
		/obj/item/food/mozzarella = 1,
		/obj/item/food/firm_cheese = 1,
		/obj/item/food/grown/herbs = 1
	)
	result = /obj/item/food/raw_mothic_margherita
	category = CAT_MOTH

/datum/crafting_recipe/food/raw_mothic_firecracker
	name = "Огненная пицца для молей"
	reqs = list(
		/obj/item/food/mothic_pizza_dough = 1,
		/datum/reagent/consumable/bbqsauce = 10,
		/obj/item/food/firm_cheese = 1,
		/obj/item/food/oven_baked_corn = 1,
		/obj/item/food/grown/ghost_chili = 1
	)
	result = /obj/item/food/raw_mothic_firecracker
	category = CAT_MOTH

/datum/crafting_recipe/food/raw_mothic_five_cheese
	name = "Пицца \"4+1 сыра\" для молей"
	reqs = list(
		/obj/item/food/mothic_pizza_dough = 1,
		/obj/item/food/tomato_sauce = 1,
		/obj/item/food/firm_cheese = 1,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/mozzarella = 1,
		/obj/item/food/herby_cheese = 1,
		/obj/item/food/cheese_curds = 1
	)
	result = /obj/item/food/raw_mothic_five_cheese
	category = CAT_MOTH

/datum/crafting_recipe/food/raw_mothic_white_pie
	name = "Пицца \"Бьянко\" для молей"
	reqs = list(
		/obj/item/food/mothic_pizza_dough = 1,
		/obj/item/food/bechamel_sauce = 1,
		/obj/item/food/firm_cheese = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/mozzarella = 1,
		/obj/item/food/grown/herbs = 1
	)
	result = /obj/item/food/raw_mothic_white_pie
	category = CAT_MOTH

/datum/crafting_recipe/food/raw_mothic_pesto
	name = "Пицца с соусом песто для молей"
	reqs = list(
		/obj/item/food/mothic_pizza_dough = 1,
		/obj/item/food/pesto = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/mozzarella = 1
	)
	result = /obj/item/food/raw_mothic_pesto
	category = CAT_MOTH

/datum/crafting_recipe/food/raw_mothic_garlic
	name = "Чесночная пицца для молей"
	reqs = list(
		/obj/item/food/mothic_pizza_dough = 1,
		/obj/item/food/butter = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/grown/herbs = 1
	)
	result = /obj/item/food/raw_mothic_garlic
	category = CAT_MOTH

/datum/crafting_recipe/food/moth_cheese_cakes
	name = "Ælorölen (Шарики из чизкейка)"
	reqs = list(
		/obj/item/food/curd_cheese = 1,
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/food/moth_cheese_cakes
	category = CAT_MOTH

/datum/crafting_recipe/food/mothmallow
	name = "Зефирки для молей" //Mothmallows = marshmallows + moth. Если нужна игра слов, то нужно думать
	reqs = list(
		/obj/item/food/grown/soybeans = 1,
		/datum/reagent/consumable/vanilla = 5,
		/datum/reagent/consumable/sugar = 15,
		/datum/reagent/consumable/ethanol/rum = 5
	)
	result = /obj/item/food/cake/mothmallow
	category = CAT_MOTH

/datum/crafting_recipe/food/red_porridge
	name = "Eltsløsk ül a priktæolk (Свекольная каша с йогуртом)"
	reqs = list(
		/obj/item/food/grown/redbeet = 1,
		/datum/reagent/consumable/vanilla = 5,
		/datum/reagent/consumable/yoghurt = 10,
		/datum/reagent/consumable/sugar = 5
	)
	result = /obj/item/food/soup/red_porridge
	category = CAT_MOTH