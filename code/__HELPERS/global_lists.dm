
//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/makeDatumRefLists()
	//markings
	init_sprite_accessory_subtypes(/datum/sprite_accessory/body_markings, marking_styles_list)
	//head accessory
	init_sprite_accessory_subtypes(/datum/sprite_accessory/head_accessory, head_accessory_styles_list)
	//hair
	init_sprite_accessory_subtypes(/datum/sprite_accessory/hair, hair_styles_public_list, hair_styles_male_list, hair_styles_female_list, hair_styles_full_list)
	//facial hair
	init_sprite_accessory_subtypes(/datum/sprite_accessory/facial_hair, facial_hair_styles_list, facial_hair_styles_male_list, facial_hair_styles_female_list)
	//underwear
	init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear, underwear_list, underwear_m, underwear_f)
	//undershirt
	init_sprite_accessory_subtypes(/datum/sprite_accessory/undershirt, undershirt_list, undershirt_m, undershirt_f)
	//socks
	init_sprite_accessory_subtypes(/datum/sprite_accessory/socks, socks_list, socks_m, socks_f)
	//alt heads
	init_sprite_accessory_subtypes(/datum/sprite_accessory/alt_heads, alt_heads_list)

	init_subtypes(/datum/surgery_step, surgery_steps)

	for(var/path in (subtypesof(/datum/surgery)))
		surgeries_list += new path()

	init_datum_subtypes(/datum/job, joblist, list(/datum/job/ai, /datum/job/cyborg), "title")
	init_datum_subtypes(/datum/superheroes, all_superheroes, null, "name")
	init_datum_subtypes(/datum/nations, all_nations, null, "default_name")
	init_datum_subtypes(/datum/language, all_languages, null, "name")

	for(var/language_name in all_languages)
		var/datum/language/L = all_languages[language_name]
		if(!(L.flags & NONGLOBAL))
			language_keys[":[lowertext(L.key)]"] = L
			language_keys[".[lowertext(L.key)]"] = L
			language_keys["#[lowertext(L.key)]"] = L

	var/list/paths = subtypesof(/datum/species)
	var/rkey = 0
	for(var/T in paths)
		var/datum/species/S = new T
		S.race_key = ++rkey //Used in mob icon caching.
		all_species[S.name] = S

		if(IS_WHITELISTED in S.species_traits)
			whitelisted_species += S.name

	init_subtypes(/datum/crafting_recipe, crafting_recipes)

	//RPD pipe list building
	var/list/temp_pipe_list = list()
	init_subtypes(/datum/pipes/atmospheric, temp_pipe_list)
	init_subtypes(/datum/pipes/disposal, temp_pipe_list)
	for(var/datum/pipes/P in temp_pipe_list) //Yes I know the list(list(...)) thing looks weird, but it allows us to group pipe metadata into ordered lists instead of being one big list
		GLOB.construction_pipe_list += list(list("pipename" = P.pipename, "pipeid" = P.pipeid, "atmosordisposals" = P.pipetype, "category" = P.category, "orientations" = P.orientations, "icon" = P.previewicon, "bendy" = P.bendy))

	return 1

/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for(var/reaction in chemical_reactions_list)
		. += "chemical_reactions_list\[\"[reaction]\"\] = \"[chemical_reactions_list[reaction]]\"\n"
		if(islist(chemical_reactions_list[reaction]))
			var/list/L = chemical_reactions_list[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	to_chat(world, .)
*/


//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	if(!istype(L))	L = list()
	for(var/path in subtypesof(prototype))
		L += new path()
	return L

/proc/init_datum_subtypes(prototype, list/L, list/pexempt, assocvar)
	if(!istype(L))	L = list()
	for(var/path in subtypesof(prototype) - pexempt)
		var/datum/D = new path()
		if(istype(D))
			var/assoc
			if(D.vars["[assocvar]"]) //has the var
				assoc = D.vars["[assocvar]"] //access value of var
			if(assoc) //value gotten
				L["[assoc]"] = D //put in association
	return L
