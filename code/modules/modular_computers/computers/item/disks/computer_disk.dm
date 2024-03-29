/obj/item/computer_disk
	name = "диск для записи данных ПК"
	desc = "Съёмный диск, используемый для хранения данных. Вмещает до 32 ГБ данных."
	icon = 'icons/obj/module.dmi'
	icon_state = "datadisk6"
	w_class = WEIGHT_CLASS_TINY
	///The amount of storage space is on the disk
	var/max_capacity = 32
	///The amount of storage space we've got filled
	var/used_capacity = 0
	///List of stored files on this drive. DO NOT MODIFY DIRECTLY!
	var/list/datum/computer_file/stored_files = list()

	///List of all programs that the disk should start with.
	var/list/datum/computer_file/starting_programs = list()

/obj/item/computer_disk/Initialize(mapload)
	. = ..()
	for(var/programs in starting_programs)
		var/datum/computer_file/program/program_type = new programs
		add_file(program_type)

/**
 * add_file
 *
 * Attempts to add an already existing file to the computer disk, then adds that capacity to the used capicity.
 */
/obj/item/computer_disk/proc/add_file(datum/computer_file/file)
	if((file.size + used_capacity) > max_capacity)
		return FALSE
	stored_files.Add(file)
	used_capacity += file.size
	return TRUE

/**
 * remove_file
 *
 * Removes an app from the stored_files list, then removes their size from the capacity.
 */
/obj/item/computer_disk/proc/remove_file(datum/computer_file/file)
	if(!(file in stored_files))
		return FALSE
	stored_files.Remove(file)
	used_capacity -= file.size
	return TRUE

/obj/item/computer_disk/advanced
	name = "продвинутый диск для записи данных ПК"
	desc = "Съёмный диск, используемый для хранения данных. Вмещает до 64 ГБ данных."
	icon_state = "datadisk5"
	max_capacity = 64

/obj/item/computer_disk/super
	name = "супер диск для записи данных ПК"
	desc = "Съёмный диск, используемый для хранения данных. Вмещает до 128 ГБ данных."
	icon_state = "datadisk3"
	max_capacity = 128

/obj/item/computer_disk/ultra
	name = "ультра диск для записи данных ПК"
	desc = "Съёмный диск, используемый для хранения данных. Вмещает до 256 ГБ данных."
	icon_state = "datadisk8"
	max_capacity = 256
