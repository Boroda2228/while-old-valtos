/obj/item/holochip
	name = "голочип с кредитами"
	desc = "Чип, на котором хранится определенная сумма кредитов. Это современная замена физических монет и купюр. Их также можно конвертировать в виртуальную валюту и наоборот. Держать подальше от магнитов."
	icon = 'icons/obj/economy.dmi'
	icon_state = "holochip"
	throwforce = 0
	force = 0
	w_class = WEIGHT_CLASS_TINY
	var/credits = 0

/obj/item/holochip/Initialize(mapload, amount)
	. = ..()
	if(amount)
		credits = amount
	update_icon()

/obj/item/holochip/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>It's loaded with [credits] credit[( credits > 1 ) ? "s" : ""]</span>\n"+\
	"<hr><span class='notice'>ПКМ to split.</span>"

/obj/item/holochip/get_item_credit_value()
	return credits

/obj/item/holochip/update_icon()
	. = ..()
	name = "\improper голочип с [credits] кредитами"
	var/rounded_credits = credits
	switch(credits)
		if(1 to 999)
			icon_state = "holochip"
		if(1000 to 999999)
			icon_state = "holochip_kilo"
			rounded_credits = round(rounded_credits * 0.001)
		if(1000000 to 999999999)
			icon_state = "holochip_mega"
			rounded_credits = round(rounded_credits * 0.000001)
		if(1000000000 to INFINITY)
			icon_state = "holochip_giga"
			rounded_credits = round(rounded_credits * 0.000000001)
	var/overlay_color = "#914792"
	switch(rounded_credits)
		if(0 to 4)
			overlay_color = "#8E2E38"
		if(5 to 9)
			overlay_color = "#914792"
		if(10 to 19)
			overlay_color = "#BF5E0A"
		if(20 to 49)
			overlay_color = "#358F34"
		if(50 to 99)
			overlay_color = "#676767"
		if(100 to 199)
			overlay_color = "#009D9B"
		if(200 to 499)
			overlay_color = "#0153C1"
		if(500 to INFINITY)
			overlay_color = "#2C2C2C"
	cut_overlays()
	var/mutable_appearance/holochip_overlay = mutable_appearance('icons/obj/economy.dmi', "[icon_state]-color")
	holochip_overlay.color = overlay_color
	add_overlay(holochip_overlay)

/obj/item/holochip/proc/spend(amount, pay_anyway = FALSE)
	if(credits >= amount)
		credits -= amount
		if(credits == 0)
			qdel(src)
		update_icon()
		return amount
	else if(pay_anyway)
		qdel(src)
		return credits
	else
		return 0

/obj/item/holochip/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/holochip))
		var/obj/item/holochip/H = I
		credits += H.credits
		to_chat(user, span_notice("Вставляю кредиты в [src]."))
		update_icon()
		qdel(H)

/obj/item/holochip/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)))
		return
	var/split_amount = round(input(user,"Сколько кредитов вы хотите изъять из голочипа?") as null|num)
	if(split_amount == null || split_amount <= 0 || !user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, !iscyborg(user)))
		return
	else
		var/new_credits = spend(split_amount, TRUE)
		var/obj/item/holochip/H = new(user ? user : drop_location(), new_credits)
		if(user)
			if(!user.put_in_hands(H))
				H.forceMove(user.drop_location())
			add_fingerprint(user)
		H.add_fingerprint(user)
		to_chat(user, span_notice("Извлек [split_amount] кредитов, формируя новый голочип."))

/obj/item/holochip/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	var/wipe_chance = 60 / severity
	if(prob(wipe_chance))
		visible_message(span_warning("[capitalize(src.name)] fizzles and disappears!"))
		qdel(src) //rip cash

/obj/item/holochip/thousand
	credits = 1000