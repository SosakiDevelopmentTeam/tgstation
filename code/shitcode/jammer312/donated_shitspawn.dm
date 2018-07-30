//По заказу ноунейма выдавалка ролей, ресов под них


//доступ малость костыльный через обращение к боту
//если кто-нибудь хочет переделать это под серверную БД - флаг вам в руки
GLOBAL_LIST_INIT(ones_allowed_to_shitspawn,null)
/proc/check_shitspawn_rights()
	if(!GLOB.ones_allowed_to_shitspawn)
		to_chat(usr, "Wait a bit, updating access list")
		var/response = world.Export("[CONFIG_GET(string/webhook_address)]?key=[CONFIG_GET(string/webhook_key)]&method=data_request&data={\"data\": \"shitspawn_list\"}")
		if(!response || response["STATUS"] != 200 || !response["CONTENT"])
			GLOB.ones_allowed_to_shitspawn = list()
			log_admin("Failed to receive shitspawn rights list: [response?"[response["STATUS"]] [response["CONTENT"]]":"failed to connect"]")
			return FALSE
		GLOB.ones_allowed_to_shitspawn = splittext(file2text(response["CONTENT"])," ")
	return usr.client && (usr.client.ckey in GLOB.ones_allowed_to_shitspawn)

/*
/client/verb/vv_self()
	set name = "vv self"
	set desc = "VV your mob (if any)"
	set category = "OOC"

	if(!check_shitspawn_rights())
		to_chat(usr,"You have no rights to do it")
		return
	if(!mob)
		to_chat(usr,"You have no mob")
		return

	donated_debug_variables(mob)

/client/verb/vv_self_mind()
	set name = "vv self mind"
	set desc = "VV your mob's mind (if any)"
	set category = "OOC"

	if(!check_shitspawn_rights())
		to_chat(usr,"You have no rights to do it")
		return
	if(!mob)
		to_chat(usr,"You have no mob")
		return
	if(!mob.mind)
		to_chat(usr,"You have no mind")
		return

	donated_debug_variables(mob.mind)


/client/proc/donated_debug_variables(datum/D in world)
	//idk what is the purpose of this but probably it's safer to keep it differing from usual debug variables
	var/static/cookieoffset = rand(10000, 19999) //to force cookies to reset after the round.

	if(!D)
		return

	if(!usr.client || !check_shitspawn_rights() || !(D==mob || (mob && (D==mob.mind)))) //The usr vs src abuse in this proc is intentional and must not be changed
		to_chat(usr, "<span class='danger'>You have no rights to access this.</span>")
		return


	var/title = ""
	var/refid = REF(D)
	var/icon/sprite
	var/hash

	var/type = D.type



	if(istype(D, /atom))
		var/atom/AT = D
		if(AT.icon && AT.icon_state)
			sprite = new /icon(AT.icon, AT.icon_state)
			hash = md5(AT.icon)
			hash = md5(hash + AT.icon_state)
			src << browse_rsc(sprite, "vv[hash].png")

	title = "[D] ([REF(D)]) = [type]"

	var/sprite_text
	if(sprite)
		sprite_text = "<img src='vv[hash].png'></td><td>"
	var/list/atomsnowflake = list()
	if(istype(D, /atom))
		var/atom/A = D
		if(isliving(A))
			atomsnowflake += "<a href='?_src_=vars;[HrefToken()];rename=[refid]'><b>[D]</b></a>"
			if(A.dir)
				atomsnowflake += "<br><font size='1'><a href='?_src_=vars;[HrefToken()];rotatedatum=[refid];rotatedir=left'><<</a> <a href='?_src_=vars;[HrefToken()];datumedit=[refid];varnameedit=dir'>[dir2text(A.dir)]</a> <a href='?_src_=vars;[HrefToken()];rotatedatum=[refid];rotatedir=right'>>></a></font>"
			var/mob/living/M = A
			atomsnowflake += {"
				<br><font size='1'><a href='?_src_=vars;[HrefToken()];datumedit=[refid];varnameedit=ckey'>[M.ckey ? M.ckey : "No ckey"]</a> / <a href='?_src_=vars;[HrefToken()];datumedit=[refid];varnameedit=real_name'>[M.real_name ? M.real_name : "No real name"]</a></font>
				<br><font size='1'>
					BRUTE:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=brute'>[M.getBruteLoss()]</a>
					FIRE:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=fire'>[M.getFireLoss()]</a>
					TOXIN:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=toxin'>[M.getToxLoss()]</a>
					OXY:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=oxygen'>[M.getOxyLoss()]</a>
					CLONE:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=clone'>[M.getCloneLoss()]</a>
					BRAIN:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=brain'>[M.getBrainLoss()]</a>
					STAMINA:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=stamina'>[M.getStaminaLoss()]</a>
				</font>
			"}
		else
			atomsnowflake += "<a href='?_src_=vars;[HrefToken()];datumedit=[refid];varnameedit=name'><b>[D]</b></a>"
			if(A.dir)
				atomsnowflake += "<br><font size='1'><a href='?_src_=vars;[HrefToken()];rotatedatum=[refid];rotatedir=left'><<</a> <a href='?_src_=vars;[HrefToken()];datumedit=[refid];varnameedit=dir'>[dir2text(A.dir)]</a> <a href='?_src_=vars;rotatedatum=[refid];rotatedir=right'>>></a></font>"

	var/formatted_type = replacetext("[type]", "/", "<wbr>/")
	var/marked
	var/varedited_line = ""
	if(D.datum_flags & DF_VAR_EDITED)
		varedited_line = "<br><font size='1' color='red'><b>Var Edited</b></font>"

	var/list/dropdownoptions = D.vv_get_dropdown()
	var/list/dropdownoptions_html = list()

	for (var/name in dropdownoptions)
		var/link = dropdownoptions[name]
		if (link)
			dropdownoptions_html += "<option value='[link]'>[name]</option>"
		else
			dropdownoptions_html += "<option value>[name]</option>"

	var/list/names = list()
	for (var/V in D.vars)
		names += V
	sleep(1)//For some reason, without this sleep, VVing will cause client to disconnect on certain objects.

	var/list/variable_html = list()
	names = sortList(names)
	for (var/V in names)
		if(D.can_vv_get(V))
			variable_html += D.vv_get_var(V)

	var/html = {"
<html>
	<head>
		<title>[title]</title>
		<style>
			body {
				font-family: Verdana, sans-serif;
				font-size: 9pt;
			}
			.value {
				font-family: "Courier New", monospace;
				font-size: 8pt;
			}
		</style>
	</head>
	<body onload='selectTextField(); updateSearch()' onkeydown='return checkreload()' onkeyup='updateSearch()'>
		<script type="text/javascript">
			function checkreload() {
				if(event.keyCode == 116){	//F5 (to refresh properly)
					document.getElementById("refresh_link").click();
					event.preventDefault ? event.preventDefault() : (event.returnValue = false)
					return false;
				}
				return true;
			}
			function updateSearch(){
				var filter_text = document.getElementById('filter');
				var filter = filter_text.value.toLowerCase();
				if(event.keyCode == 13){	//Enter / return
					var vars_ol = document.getElementById('vars');
					var lis = vars_ol.getElementsByTagName("li");
					for ( var i = 0; i < lis.length; ++i )
					{
						try{
							var li = lis\[i\];
							if ( li.style.backgroundColor == "#ffee88" )
							{
								alist = lis\[i\].getElementsByTagName("a")
								if(alist.length > 0){
									location.href=alist\[0\].href;
								}
							}
						}catch(err) {   }
					}
					return
				}
				if(event.keyCode == 38){	//Up arrow
					var vars_ol = document.getElementById('vars');
					var lis = vars_ol.getElementsByTagName("li");
					for ( var i = 0; i < lis.length; ++i )
					{
						try{
							var li = lis\[i\];
							if ( li.style.backgroundColor == "#ffee88" )
							{
								if( (i-1) >= 0){
									var li_new = lis\[i-1\];
									li.style.backgroundColor = "white";
									li_new.style.backgroundColor = "#ffee88";
									return
								}
							}
						}catch(err) {  }
					}
					return
				}
				if(event.keyCode == 40){	//Down arrow
					var vars_ol = document.getElementById('vars');
					var lis = vars_ol.getElementsByTagName("li");
					for ( var i = 0; i < lis.length; ++i )
					{
						try{
							var li = lis\[i\];
							if ( li.style.backgroundColor == "#ffee88" )
							{
								if( (i+1) < lis.length){
									var li_new = lis\[i+1\];
									li.style.backgroundColor = "white";
									li_new.style.backgroundColor = "#ffee88";
									return
								}
							}
						}catch(err) {  }
					}
					return
				}

				//This part here resets everything to how it was at the start so the filter is applied to the complete list. Screw efficiency, it's client-side anyway and it only looks through 200 or so variables at maximum anyway (mobs).
				if(complete_list != null && complete_list != ""){
					var vars_ol1 = document.getElementById("vars");
					vars_ol1.innerHTML = complete_list
				}
				document.cookie="[refid][cookieoffset]search="+encodeURIComponent(filter);
				if(filter == ""){
					return;
				}else{
					var vars_ol = document.getElementById('vars');
					var lis = vars_ol.getElementsByTagName("li");
					for ( var i = 0; i < lis.length; ++i )
					{
						try{
							var li = lis\[i\];
							if ( li.innerText.toLowerCase().indexOf(filter) == -1 )
							{
								vars_ol.removeChild(li);
								i--;
							}
						}catch(err) {   }
					}
				}
				var lis_new = vars_ol.getElementsByTagName("li");
				for ( var j = 0; j < lis_new.length; ++j )
				{
					var li1 = lis\[j\];
					if (j == 0){
						li1.style.backgroundColor = "#ffee88";
					}else{
						li1.style.backgroundColor = "white";
					}
				}
			}
			function selectTextField() {
				var filter_text = document.getElementById('filter');
				filter_text.focus();
				filter_text.select();
				var lastsearch = getCookie("[refid][cookieoffset]search");
				if (lastsearch) {
					filter_text.value = lastsearch;
					updateSearch();
				}
			}
			function loadPage(list) {
				if(list.options\[list.selectedIndex\].value == ""){
					return;
				}
				location.href=list.options\[list.selectedIndex\].value;
			}
			function getCookie(cname) {
				var name = cname + "=";
				var ca = document.cookie.split(';');
				for(var i=0; i<ca.length; i++) {
					var c = ca\[i\];
					while (c.charAt(0)==' ') c = c.substring(1,c.length);
					if (c.indexOf(name)==0) return c.substring(name.length,c.length);
				}
				return "";
			}

		</script>
		<div align='center'>
			<table width='100%'>
				<tr>
					<td width='50%'>
						<table align='center' width='100%'>
							<tr>
								<td>
									[sprite_text]
									<div align='center'>
										[atomsnowflake.Join()]
									</div>
								</td>
							</tr>
						</table>
						<div align='center'>
							<b><font size='1'>[formatted_type]</font></b>
							[marked]
							[varedited_line]
						</div>
					</td>
					<td width='50%'>
						<div align='center'>
							<a id='refresh_link' href='?_src_=vars;[HrefToken()];datumrefresh=[refid]'>Refresh</a>
							<form>
								<select name="file" size="1"
									onchange="loadPage(this.form.elements\[0\])"
									target="_parent._top"
									onmouseclick="this.focus()"
									style="background-color:#ffffff">
									<option value selected>Select option</option>
									[dropdownoptions_html.Join()]
								</select>
							</form>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<hr>
		<font size='1'>
			<b>E</b> - Edit, tries to determine the variable type by itself.<br>
			<b>C</b> - Change, asks you for the var type first.<br>
			<b>M</b> - Mass modify: changes this variable for all objects of this type.<br>
		</font>
		<hr>
		<table width='100%'>
			<tr>
				<td width='20%'>
					<div align='center'>
						<b>Search:</b>
					</div>
				</td>
				<td width='80%'>
					<input type='text' id='filter' name='filter_text' value='' style='width:100%;'>
				</td>
			</tr>
		</table>
		<hr>
		<ol id='vars'>
			[variable_html.Join()]
		</ol>
		<script type='text/javascript'>
			var vars_ol = document.getElementById("vars");
			var complete_list = vars_ol.innerHTML;
		</script>
	</body>
</html>
"}
	src << browse(html, "window=variables[refid];size=475x650")
*/

/client/verb/dasp()
	set name = "DASP"
	set desc = "Show donated antag shitspawn panel"
	set category = "OOC"

	if(!check_shitspawn_rights())
		to_chat(usr,"You have no rights to do it")
		return
	if(!mob)
		to_chat(usr,"You have no mob")
		return
	if(!mob.mind)
		to_chat(usr,"You have no mind")
		return

	mob.mind.donated_traitor_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Donated Traitor Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/mind/proc/donated_traitor_panel() //slightly modified
	if(!SSticker.HasRoundStarted())
		alert("Not before round-start!", "Alert")
		return
	if(QDELETED(src))
		alert("This mind doesn't have a mob, or is deleted! For some reason!", "Edit Memory")
		return

	var/out = "<B>[name]</B>[(current && (current.real_name!=name))?" (as [current.real_name])":""]<br>"
	out += "Mind currently owned by key: [key] [active?"(synced)":"(not synced)"]<br>"
	out += "Assigned role: [assigned_role]. <a href='?src=[REF(src)];role_edit=1'>Edit</a><br>"
	out += "Faction and special role: <b><font color='red'>[special_role]</font></b><br>"

	var/special_statuses = get_special_statuses()
	if(length(special_statuses))
		out += get_special_statuses() + "<br>"

	if(!GLOB.antag_prototypes)
		GLOB.antag_prototypes = list()
		for(var/antag_type in subtypesof(/datum/antagonist))
			var/datum/antagonist/A = new antag_type
			var/cat_id = A.antagpanel_category
			if(!GLOB.antag_prototypes[cat_id])
				GLOB.antag_prototypes[cat_id] = list(A)
			else
				GLOB.antag_prototypes[cat_id] += A
	sortTim(GLOB.antag_prototypes,/proc/cmp_text_asc,associative=TRUE)

	var/list/sections = list()
	var/list/priority_sections = list()

	for(var/antag_category in GLOB.antag_prototypes)
		var/category_header = "<i><b>[antag_category]:</b></i>"
		var/list/antag_header_parts = list(category_header)

		var/datum/antagonist/current_antag
		var/list/possible_admin_antags = list()

		for(var/datum/antagonist/prototype in GLOB.antag_prototypes[antag_category])
			var/datum/antagonist/A = has_antag_datum(prototype.type)
			if(A)
				//We got the antag
				if(!current_antag)
					current_antag = A
				else
					continue //Let's skip subtypes of what we already shown.
			else if(prototype.show_in_antagpanel)
				if(prototype.can_be_owned(src))
					possible_admin_antags += "<a href='?src=[REF(src)];add_antag=[prototype.type]' title='[prototype.type]'>[prototype.name]</a>"
				else
					possible_admin_antags += "<a class='linkOff'>[prototype.name]</a>"
			else
				//We don't have it and it shouldn't be shown as an option to be added.
				continue

		if(!current_antag) //Show antagging options
			if(possible_admin_antags.len)
				antag_header_parts += "<span class='highlight'>None</span>"
				antag_header_parts += possible_admin_antags
			else
				//If there's no antags to show in this category skip the section completely
				continue
		else //Show removal and current one
			priority_sections |= antag_category
			antag_header_parts += "<span class='bad'>[current_antag.name]</span>"
			antag_header_parts += "<a href='?src=[REF(src)];remove_antag=[REF(current_antag)]'>Remove</a>"


		//We aren't antag of this category, grab first prototype to check the prefs (This is pretty vague but really not sure how else to do this)
		var/datum/antagonist/pref_source = current_antag
		if(!pref_source)
			for(var/datum/antagonist/prototype in GLOB.antag_prototypes[antag_category])
				if(!prototype.show_in_antagpanel)
					continue
				pref_source = prototype
				break
		if(pref_source.job_rank)
			antag_header_parts += pref_source.enabled_in_preferences(src) ? "Enabled in Prefs" : "Disabled in Prefs"

		//Traitor : None | Traitor | IAA
		//	Command1 | Command2 | Command3
		//	Secret Word : Banana
		//	Objectives:
		//		1.Do the thing [a][b]
		//		[a][b]
		//	Memory:
		//		Uplink Code: 777 Alpha
		var/cat_section = antag_header_parts.Join(" | ") + "<br>"
		if(current_antag)
			cat_section += current_antag.antag_panel()
		sections[antag_category] = cat_section

	for(var/s in priority_sections)
		out += sections[s]
	for(var/s in sections - priority_sections)
		out += sections[s]

	out += "<br>"

	//Uplink
	if(ishuman(current))
		var/uplink_info = "<i><b>Uplink</b></i>:"
		var/datum/component/uplink/U = find_syndicate_uplink()
		if(U)
			uplink_info += "<a href='?src=[REF(src)];common=takeuplink'>take</a>"
			uplink_info += ", <a href='?src=[REF(src)];common=crystals'>[U.telecrystals]</a> TC"
		else
			uplink_info += "<a href='?src=[REF(src)];common=uplink'>give</a>"
		uplink_info += "." //hiel grammar

		out += uplink_info + "<br>"
	//Common Memory
	var/common_memory = "<span>Common Memory:</span>"
	common_memory += memory
	common_memory += "<a href='?src=[REF(src)];memory_edit=1'>Edit Memory</a>"
	out += common_memory + "<br>"

	var/datum/browser/panel = new(usr, "dtraitorpanel", "", 600, 600)
	panel.set_content(out)
	panel.open()
	return


/datum/mind/Topic(href, href_list)
	if(!check_shitspawn_rights())
		return ..() //usual topic

	var/self_antagging = usr == current

	if(href_list["add_antag"])
		add_antag_wrapper(text2path(href_list["add_antag"]),usr)
	if(href_list["remove_antag"])
		var/datum/antagonist/A = locate(href_list["remove_antag"]) in antag_datums
		if(!istype(A))
			to_chat(usr,"<span class='warning'>Invalid antagonist ref to be removed.</span>")
			return
		A.admin_remove(usr)

	if (href_list["role_edit"])
		var/new_role = input("Select new role", "Assigned role", assigned_role) as null|anything in get_all_jobs()
		if (!new_role)
			return
		assigned_role = new_role

	else if (href_list["memory_edit"])
		var/new_memo = copytext(sanitize(input("Write new memory", "Memory", memory) as null|message),1,MAX_MESSAGE_LEN)
		if (isnull(new_memo))
			return
		memory = new_memo

	else if (href_list["obj_edit"] || href_list["obj_add"])
		var/datum/objective/objective
		var/objective_pos
		var/def_value

		var/datum/antagonist/target_antag

		if (href_list["obj_edit"])
			objective = locate(href_list["obj_edit"])
			if (!objective)
				return

			for(var/datum/antagonist/A in antag_datums)
				if(objective in A.objectives)
					target_antag = A
					objective_pos = A.objectives.Find(objective)
					break

			if(!target_antag) //Shouldn't happen anymore
				stack_trace("objective without antagonist found")
				objective_pos = objectives.Find(objective)

			//Text strings are easy to manipulate. Revised for simplicity.
			var/temp_obj_type = "[objective.type]"//Convert path into a text string.
			def_value = copytext(temp_obj_type, 19)//Convert last part of path into an objective keyword.
			if(!def_value)//If it's a custom objective, it will be an empty string.
				def_value = "custom"
		else
			//We're adding this objective
			if(href_list["target_antag"])
				var/datum/antagonist/X = locate(href_list["target_antag"]) in antag_datums
				if(X)
					target_antag = X
			if(!target_antag)
				switch(antag_datums.len)
					if(0)
						target_antag = add_antag_datum(/datum/antagonist/custom)
					if(1)
						target_antag = antag_datums[1]
					else
						var/datum/antagonist/target = input("Which antagonist gets the objective:", "Antagonist", def_value) as null|anything in antag_datums + "(new custom antag)"
						if (QDELETED(target))
							return
						else if(target == "(new custom antag)")
							target_antag = add_antag_datum(/datum/antagonist/custom)
						else
							target_antag = target

		var/new_obj_type = input("Select objective type:", "Objective type", def_value) as null|anything in list("assassinate", "maroon", "debrain", "protect", "destroy", "prevent", "hijack", "escape", "survive", "martyr", "steal", "download", "nuclear", "capture", "absorb", "custom")
		if (!new_obj_type)
			return

		var/datum/objective/new_objective = null

		switch (new_obj_type)
			if ("assassinate","protect","debrain","maroon")
				var/list/possible_targets = list("Free objective")
				for(var/datum/mind/possible_target in SSticker.minds)
					if ((possible_target != src) && ishuman(possible_target.current))
						possible_targets += possible_target.current

				var/mob/def_target = null
				var/list/objective_list = typecacheof(list(/datum/objective/assassinate, /datum/objective/protect, /datum/objective/debrain, /datum/objective/maroon))
				if (is_type_in_typecache(objective, objective_list) && objective.target)
					def_target = objective.target.current

				var/mob/new_target = input("Select target:", "Objective target", def_target) as null|anything in possible_targets
				if (!new_target)
					return

				var/objective_path = text2path("/datum/objective/[new_obj_type]")
				if (new_target == "Free objective")
					new_objective = new objective_path
					new_objective.owner = src
					new_objective.target = null
					new_objective.explanation_text = "Free objective"
				else
					new_objective = new objective_path
					new_objective.owner = src
					new_objective.target = new_target.mind
					//Will display as special role if the target is set as MODE. Ninjas/commandos/nuke ops.
					new_objective.update_explanation_text()

			if ("destroy")
				var/list/possible_targets = active_ais(1)
				if(possible_targets.len)
					var/mob/new_target = input("Select target:", "Objective target") as null|anything in possible_targets
					new_objective = new /datum/objective/destroy
					new_objective.target = new_target.mind
					new_objective.owner = src
					new_objective.update_explanation_text()
				else
					to_chat(usr, "No active AIs with minds")

			if ("prevent")
				new_objective = new /datum/objective/block
				new_objective.owner = src

			if ("hijack")
				new_objective = new /datum/objective/hijack
				new_objective.owner = src

			if ("escape")
				new_objective = new /datum/objective/escape
				new_objective.owner = src

			if ("survive")
				new_objective = new /datum/objective/survive
				new_objective.owner = src

			if("martyr")
				new_objective = new /datum/objective/martyr
				new_objective.owner = src

			if ("nuclear")
				new_objective = new /datum/objective/nuclear
				new_objective.owner = src

			if ("steal")
				if (!istype(objective, /datum/objective/steal))
					new_objective = new /datum/objective/steal
					new_objective.owner = src
				else
					new_objective = objective
				var/datum/objective/steal/steal = new_objective
				if (!steal.select_target())
					return

			if("download","capture","absorb")
				var/def_num
				if(objective&&objective.type==text2path("/datum/objective/[new_obj_type]"))
					def_num = objective.target_amount

				var/target_number = input("Input target number:", "Objective", def_num) as num | null
				if (isnull(target_number))//Ordinarily, you wouldn't need isnull. In this case, the value may already exist.
					return

				switch(new_obj_type)
					if("download")
						new_objective = new /datum/objective/download
						new_objective.explanation_text = "Download [target_number] research node\s."
					if("capture")
						new_objective = new /datum/objective/capture
						new_objective.explanation_text = "Capture [target_number] lifeforms with an energy net. Live, rare specimens are worth more."
					if("absorb")
						new_objective = new /datum/objective/absorb
						new_objective.explanation_text = "Absorb [target_number] compatible genomes."
				new_objective.owner = src
				new_objective.target_amount = target_number

			if ("custom")
				var/expl = stripped_input(usr, "Custom objective:", "Objective", objective ? objective.explanation_text : "")
				if (!expl)
					return
				new_objective = new /datum/objective
				new_objective.owner = src
				new_objective.explanation_text = expl

		if (!new_objective)
			return

		if (objective)
			if(target_antag)
				target_antag.objectives -= objective
			objectives -= objective
			target_antag.objectives.Insert(objective_pos, new_objective)
			message_admins("[key_name_admin(usr)] edited [current]'s objective to [new_objective.explanation_text]")
			log_admin("[key_name(usr)] edited [current]'s objective to [new_objective.explanation_text]")
		else
			if(target_antag)
				target_antag.objectives += new_objective
			objectives += new_objective
			message_admins("[key_name_admin(usr)] added a new objective for [current]: [new_objective.explanation_text]")
			log_admin("[key_name(usr)] added a new objective for [current]: [new_objective.explanation_text]")

	else if (href_list["obj_delete"])
		var/datum/objective/objective = locate(href_list["obj_delete"])
		if(!istype(objective))
			return

		for(var/datum/antagonist/A in antag_datums)
			if(objective in A.objectives)
				A.objectives -= objective
				break
		objectives -= objective
		message_admins("[key_name_admin(usr)] removed an objective for [current]: [objective.explanation_text]")
		log_admin("[key_name(usr)] removed an objective for [current]: [objective.explanation_text]")

	else if(href_list["obj_completed"])
		var/datum/objective/objective = locate(href_list["obj_completed"])
		if(!istype(objective))
			return
		objective.completed = !objective.completed
		log_admin("[key_name(usr)] toggled the win state for [current]'s objective: [objective.explanation_text]")

	else if (href_list["silicon"])
		switch(href_list["silicon"])
			if("unemag")
				var/mob/living/silicon/robot/R = current
				if (istype(R))
					R.SetEmagged(0)
					message_admins("[key_name_admin(usr)] has unemag'ed [R].")
					log_admin("[key_name(usr)] has unemag'ed [R].")

			if("unemagcyborgs")
				if(isAI(current))
					var/mob/living/silicon/ai/ai = current
					for (var/mob/living/silicon/robot/R in ai.connected_robots)
						R.SetEmagged(0)
					message_admins("[key_name_admin(usr)] has unemag'ed [ai]'s Cyborgs.")
					log_admin("[key_name(usr)] has unemag'ed [ai]'s Cyborgs.")

	else if (href_list["common"])
		switch(href_list["common"])
			if("undress")
				for(var/obj/item/W in current)
					current.dropItemToGround(W, TRUE) //The 1 forces all items to drop, since this is an admin undress.
			if("takeuplink")
				take_uplink()
				memory = null//Remove any memory they may have had.
				log_admin("[key_name(usr)] removed [current]'s uplink.")
			if("crystals")
				var/datum/component/uplink/U = find_syndicate_uplink()
				if(U)
					var/crystals = input("Amount of telecrystals for [key]","Syndicate uplink", U.telecrystals) as null | num
					if(!isnull(crystals))
						U.telecrystals = crystals
						message_admins("[key_name_admin(usr)] changed [current]'s telecrystal count to [crystals].")
						log_admin("[key_name(usr)] changed [current]'s telecrystal count to [crystals].")
			if("uplink")
				if(!equip_traitor())
					to_chat(usr, "<span class='danger'>Equipping a syndicate failed!</span>")
					log_admin("[key_name(usr)] tried and failed to give [current] an uplink.")
				else
					log_admin("[key_name(usr)] gave [current] an uplink.")

	else if (href_list["obj_announce"])
		announce_objectives()

	//Something in here might have changed your mob
	if(self_antagging && (!usr || !usr.client) && current.client)
		usr = current
	donated_traitor_panel()

/*
/client/view_var_Topic(href, href_list, hsrc)
	if( (usr.client != src) || !check_shitspawn_rights() || src.holder)
		return ..()
	if(href_list["Vars"])
		donated_debug_variables(locate(href_list["Vars"]))

	else if(href_list["datumrefresh"])
		var/datum/DAT = locate(href_list["datumrefresh"])
		if(!DAT) //can't be an istype() because /client etc aren't datums
			return
		src.donated_debug_variables(DAT)

	else if(href_list["regenerateicons"])
		var/mob/M = locate(href_list["regenerateicons"]) in GLOB.mob_list
		if(!ismob(M))
			to_chat(usr, "This can only be done to instances of type /mob")
			return
		M.regenerate_icons()

	if(href_list["rename"])
		var/mob/M = locate(href_list["rename"]) in GLOB.mob_list
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		var/new_name = stripped_input(usr,"What would you like to name this mob?","Input a name",M.real_name,MAX_NAME_LEN)
		if( !new_name || !M )
			return

		message_admins("Donated shitspawner [key_name_admin(usr)] renamed [key_name_admin(M)] to [new_name].")
		M.fully_replace_character_name(M.real_name,new_name)
		href_list["datumrefresh"] = href_list["rename"]

	else if(href_list["varnameedit"] && href_list["datumedit"])

		var/D = locate(href_list["datumedit"])
		if(!istype(D, /datum))
			to_chat(usr, "This can only be used on datums")
			return

		donated_modify_variables(D, href_list["varnameedit"], 1)

	else if(href_list["varnamechange"] && href_list["datumchange"])
		var/D = locate(href_list["datumchange"])
		if(!istype(D, /datum))
			to_chat(usr, "This can only be used on datums")
			return

		donated_modify_variables(D, href_list["varnamechange"], 0)

	else if(href_list["give_spell"])
		var/mob/M = locate(href_list["give_spell"]) in GLOB.mob_list
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.give_spell(M)
		href_list["datumrefresh"] = href_list["give_spell"]

	else if(href_list["remove_spell"])
		var/mob/M = locate(href_list["remove_spell"]) in GLOB.mob_list
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		remove_spell(M)
		href_list["datumrefresh"] = href_list["remove_spell"]

	else if(href_list["give_disease"])
		var/mob/M = locate(href_list["give_disease"]) in GLOB.mob_list
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.give_disease(M)
		href_list["datumrefresh"] = href_list["give_spell"]

	else if(href_list["gib"])
		var/mob/M = locate(href_list["gib"]) in GLOB.mob_list
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.cmd_admin_gib(M,1)

	else if (href_list["modarmor"])
		var/obj/O = locate(href_list["modarmor"])
		if(!istype(O))
			to_chat(usr, "This can only be used on instances of type /obj")
			return

		var/list/pickerlist = list()
		var/list/armorlist = O.armor.getList()

		for (var/i in armorlist)
			pickerlist += list(list("value" = armorlist[i], "name" = i))

		var/list/result = presentpicker(usr, "Modify armor", "Modify armor: [O]", Button1="Save", Button2 = "Cancel", Timeout=FALSE, Type = "text", values = pickerlist)

		if (islist(result))
			if (result["button"] == 2) // If the user pressed the cancel button
				return
			// text2num conveniently returns a null on invalid values
			O.armor = O.armor.setRating(melee = text2num(result["values"]["melee"]),\
		                  bullet = text2num(result["values"]["bullet"]),\
		                  laser = text2num(result["values"]["laser"]),\
		                  energy = text2num(result["values"]["energy"]),\
		                  bomb = text2num(result["values"]["bomb"]),\
		                  bio = text2num(result["values"]["bio"]),\
		                  rad = text2num(result["values"]["rad"]),\
		                  fire = text2num(result["values"]["fire"]),\
		                  acid = text2num(result["values"]["acid"]))
			log_admin("[key_name(usr)] modified the armor on [O] ([O.type]) to melee: [O.armor.melee], bullet: [O.armor.bullet], laser: [O.armor.laser], energy: [O.armor.energy], bomb: [O.armor.bomb], bio: [O.armor.bio], rad: [O.armor.rad], fire: [O.armor.fire], acid: [O.armor.acid]")
			message_admins("<span class='notice'>[key_name_admin(usr)] modified the armor on [O] ([O.type]) to melee: [O.armor.melee], bullet: [O.armor.bullet], laser: [O.armor.laser], energy: [O.armor.energy], bomb: [O.armor.bomb], bio: [O.armor.bio], rad: [O.armor.rad], fire: [O.armor.fire], acid: [O.armor.acid]</span>")
		else
			return

	else if(href_list["addreagent"])
		var/atom/A = locate(href_list["addreagent"])

		if(!A.reagents)
			var/amount = input(usr, "Specify the reagent size of [A]", "Set Reagent Size", 50) as num
			if(amount)
				A.create_reagents(amount)

		if(A.reagents)
			var/chosen_id
			var/list/reagent_options = sortList(GLOB.chemical_reagents_list)
			switch(alert(usr, "Choose a method.", "Add Reagents", "Enter ID", "Choose ID"))
				if("Enter ID")
					var/valid_id
					while(!valid_id)
						chosen_id = stripped_input(usr, "Enter the ID of the reagent you want to add.")
						if(!chosen_id) //Get me out of here!
							break
						for(var/ID in reagent_options)
							if(ID == chosen_id)
								valid_id = 1
						if(!valid_id)
							to_chat(usr, "<span class='warning'>A reagent with that ID doesn't exist!</span>")
				if("Choose ID")
					chosen_id = input(usr, "Choose a reagent to add.", "Choose a reagent.") as null|anything in reagent_options
			if(chosen_id)
				var/amount = input(usr, "Choose the amount to add.", "Choose the amount.", A.reagents.maximum_volume) as num
				if(amount)
					A.reagents.add_reagent(chosen_id, amount)
					log_admin("[key_name(usr)] has added [amount] units of [chosen_id] to \the [A]")
					message_admins("<span class='notice'>[key_name(usr)] has added [amount] units of [chosen_id] to \the [A]</span>")

		href_list["datumrefresh"] = href_list["addreagent"]

	else if(href_list["editorgans"])
		var/mob/living/carbon/C = locate(href_list["editorgans"]) in GLOB.mob_list
		if(!istype(C))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		manipulate_organs(C)
		href_list["datumrefresh"] = href_list["editorgans"]

	else if(href_list["givetrauma"])
		var/mob/living/carbon/C = locate(href_list["givetrauma"]) in GLOB.mob_list
		if(!istype(C))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		var/list/traumas = subtypesof(/datum/brain_trauma)
		var/result = input(usr, "Choose the brain trauma to apply","Traumatize") as null|anything in traumas
		if(!usr)
			return
		if(QDELETED(C))
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(result)
			C.gain_trauma(result)

		href_list["datumrefresh"] = href_list["givetrauma"]

	else if(href_list["curetraumas"])
		var/mob/living/carbon/C = locate(href_list["curetraumas"]) in GLOB.mob_list
		if(!istype(C))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		C.cure_all_traumas(TRAUMA_RESILIENCE_ABSOLUTE)

		href_list["datumrefresh"] = href_list["curetraumas"]

	else if(href_list["hallucinate"])
		var/mob/living/carbon/C = locate(href_list["hallucinate"]) in GLOB.mob_list
		if(!istype(C))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
			return

		var/list/hallucinations = subtypesof(/datum/hallucination)
		var/result = input(usr, "Choose the hallucination to apply","Send Hallucination") as null|anything in hallucinations
		if(!usr)
			return
		if(QDELETED(C))
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(result)
			new result(C, TRUE)

	else if(href_list["setspecies"])
		var/mob/living/carbon/human/H = locate(href_list["setspecies"]) in GLOB.mob_list
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		var/result = input(usr, "Please choose a new species","Species") as null|anything in GLOB.species_list

		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		if(result)
			var/newtype = GLOB.species_list[result]
			admin_ticket_log("[key_name_admin(usr)] has modified the bodyparts of [H] to [result]")
			H.set_species(newtype)

	else if(href_list["adjustDamage"] && href_list["mobToDamage"])
		var/mob/living/L = locate(href_list["mobToDamage"]) in GLOB.mob_list
		if(!istype(L))
			return

		var/Text = href_list["adjustDamage"]

		var/amount =  input("Deal how much damage to mob? (Negative values here heal)","Adjust [Text]loss",0) as num

		if(!L)
			to_chat(usr, "Mob doesn't exist anymore")
			return

		switch(Text)
			if("brute")
				L.adjustBruteLoss(amount)
			if("fire")
				L.adjustFireLoss(amount)
			if("toxin")
				L.adjustToxLoss(amount)
			if("oxygen")
				L.adjustOxyLoss(amount)
			if("brain")
				L.adjustBrainLoss(amount)
			if("clone")
				L.adjustCloneLoss(amount)
			if("stamina")
				L.adjustStaminaLoss(amount)
			else
				to_chat(usr, "You caused an error. DEBUG: Text:[Text] Mob:[L]")
				return

		if(amount != 0)
			log_admin("[key_name(usr)] dealt [amount] amount of [Text] damage to [L] ")
			var/msg = "<span class='notice'>[key_name(usr)] dealt [amount] amount of [Text] damage to [L] </span>"
			message_admins(msg)
			admin_ticket_log(L, msg)
			href_list["datumrefresh"] = href_list["mobToDamage"]

/client/proc/donated_modify_variables(atom/O, param_var_name = null, autodetect_class = 0)
	if(!check_shitspawn_rights() || (O != mob && !(mob && O == mob.mind)))
		to_chat(usr, "You have no rights to do it")
		return

	var/class
	var/variable
	var/var_value

	if(param_var_name)
		if(!param_var_name in O.vars)
			to_chat(src, "A variable with this name ([param_var_name]) doesn't exist in this datum ([O])")
			return
		variable = param_var_name

	else
		var/list/names = list()
		for (var/V in O.vars)
			names += V

		names = sortList(names)

		variable = input("Which var?","Var") as null|anything in names
		if(!variable)
			return

	if(!O.can_vv_get(variable))
		return

	var_value = O.vars[variable]

	if(variable in GLOB.VVlocked)
		if(!check_rights(R_DEBUG))
			return
	if(variable in GLOB.VVckey_edit)
		if(!check_rights(R_SPAWN|R_DEBUG))
			return
	if(variable in GLOB.VVicon_edit_lock)
		if(!check_rights(R_FUN|R_DEBUG))
			return
	if(istype(O, /datum/armor))
		var/prompt = alert(src, "Editing this var changes this value on potentially thousands of items that share the same combination of armor values. If you want to edit the armor of just one item, use the \"Modify armor values\" dropdown item", "DANGER", "ABORT ", "Continue", " ABORT")
		if (prompt != "Continue")
			return
	if(variable in GLOB.VVpixelmovement)
		if(!check_rights(R_DEBUG))
			return
		var/prompt = alert(src, "Editing this var may irreparably break tile gliding for the rest of the round. THIS CAN'T BE UNDONE", "DANGER", "ABORT ", "Continue", " ABORT")
		if (prompt != "Continue")
			return


	var/default = vv_get_class(variable, var_value)

	if(isnull(default))
		to_chat(src, "Unable to determine variable type.")
	else
		to_chat(src, "Variable appears to be <b>[uppertext(default)]</b>.")

	to_chat(src, "Variable contains: [var_value]")

	if(default == VV_NUM)
		var/dir_text = ""
		if(var_value > 0 && var_value < 16)
			if(var_value & 1)
				dir_text += "NORTH"
			if(var_value & 2)
				dir_text += "SOUTH"
			if(var_value & 4)
				dir_text += "EAST"
			if(var_value & 8)
				dir_text += "WEST"

		if(dir_text)
			to_chat(src, "If a direction, direction is: [dir_text]")

	if(autodetect_class && default != VV_NULL)
		if (default == VV_TEXT)
			default = VV_MESSAGE
		class = default

	var/list/value = vv_get_value(class, default, var_value, extra_classes = list(VV_LIST), var_name = variable)
	class = value["class"]

	if (!class)
		return
	var/var_new = value["value"]

	if(class == VV_MESSAGE)
		class = VV_TEXT

	var/original_name = "[O]"

	switch(class)
		if(VV_LIST)
			if(!islist(var_value))
				mod_list(list(), O, original_name, variable)

			mod_list(var_value, O, original_name, variable)
			return

		if(VV_RESTORE_DEFAULT)
			var_new = initial(O.vars[variable])

		if(VV_TEXT)
			var/list/varsvars = vv_parse_text(O, var_new)
			for(var/V in varsvars)
				var_new = replacetext(var_new,"\[[V]]","[O.vars[V]]")


	if (O.vv_edit_var(variable, var_new) == FALSE)
		to_chat(src, "Your edit was rejected by the object.")
		return
	log_world("### VarEdit by [key_name(src)]: [O.type] [variable]=[var_value] => [var_new]")
	log_admin("[key_name(src)] modified [original_name]'s [variable] from [rhtml_encode("[var_value]")] to [rhtml_encode("[var_new]")]")
	var/msg = "[key_name_admin(src)] modified [original_name]'s [variable] from [var_value] to [var_new]"
	message_admins(msg)
	admin_ticket_log(O, msg)
*/