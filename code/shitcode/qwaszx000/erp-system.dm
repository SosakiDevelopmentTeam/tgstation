#define ROT_ 0
#define ANAL_ 1
#define vag_nal 2
#define otsos_ 3
#define SCACAT_A 4
#define SCACAT_B 5
#define Droch_ 6
/*/mob/living/MouseDrop_T(mob/living/target, mob/user)
	var/list/dat = list()
	dat += "<table>"
	dat += "<tr><td><center><b>ERP System</b></center></td></tr>"
	dat += "<tr><td><b>User: [user.gender]</b></td></tr>"
	dat += "<tr><td><b>Target: [target.gender]</b></td></tr>"//user gender = target gender/ whi?
	//-------------
	if(user.gender == "male")
	{
		dat += "<tr><td><B><A href='?src=[REF(src)];erp=[ROT_]'>В ротик</A></B></td></tr>"
		//if(istype(target, /mob/living/carbon/human)){
		dat += "<tr><td><B><A href='?src=[REF(src)];erp=[ANAL_]'>В жопу</A></B></td></tr>"
		if(target.gender != "male"){
			dat += "<tr><td><B><A href='?src=[REF(src)];erp=[vag_nal]'>В пизду</A></B></td></tr>"
		}
		//}
	}

	if(target.gender == "male"){
		dat += "<tr><td><B><A href='?src=[REF(src)];erp=[otsos_]'>Отсосать</A></B></td></tr>"
	}

	if(user.gender != "male"){
		if(target.gender == "male"){
			dat += "<tr><td><B><A href='?src=[REF(src)];erp=[SCACAT_A]'>Жопой на хуй</A></B></td></tr>"
			dat += "<tr><td><B><A href='?src=[REF(src)];erp=[SCACAT_B]'>Пиздой на хуй</A></B></td></tr>"
		}
	}
	dat += "</table>"
	var/datum/browser/popup = new/datum/browser(user, "mob[REF(target)]", "[target]", 440, 510)
	popup.set_content(dat.Join())
	popup.open()*/

/mob/living/verb/erp_panel()
	set category = "IC"
	set src in usr.loc//src - target   usr - source
	var/mob/user = usr
	var/mob/target = src
	//to_chat(src, "You are src")
	//to_chat(usr, "You are usr")
	var/list/dat = list()
	dat += "<table>"
	dat += "<tr><td><center><b>ERP System</b></center></td></tr>"
	dat += "<tr><td><b>User: [user.gender]</b></td></tr>"
	dat += "<tr><td><b>Target: [target.gender]</b></td></tr>"//user gender = target gender/ whi?
	//-------------
	if(user != target){
		if(user.gender == "male")
		{
			dat += "<tr><td><B><A href='?src=[REF(src)];erp=[ROT_]'>В ротик</A></B></td></tr>"
			dat += "<tr><td><B><A href='?src=[REF(src)];erp=[ANAL_]'>В жопу</A></B></td></tr>"
		}
		if(target.gender != "male")
		{
			dat += "<tr><td><B><A href='?src=[REF(src)];erp=[vag_nal]'>В пизду</A></B></td></tr>"
		}



		if(target.gender == "male")
		{
			dat += "<tr><td><B><A href='?src=[REF(src)];erp=[otsos_]'>Отсосать</A></B></td></tr>"
		}

		if(user.gender != "male")
		{
			if(target.gender == "male")
			{
				dat += "<tr><td><B><A href='?src=[REF(src)];erp=[SCACAT_A]'>Жопой на хуй</A></B></td></tr>"
				dat += "<tr><td><B><A href='?src=[REF(src)];erp=[SCACAT_B]'>Пиздой на хуй</A></B></td></tr>"
			}
		}
	}
	if(user == target)
	{
		dat += "<tr><td><B><A href='?src=[REF(src)];erp=[Droch_]'>Дрочить</A></B></td></tr>"
	}
	dat += "</table>"
	var/datum/browser/popup = new/datum/browser(user, "mob[REF(target)]", "[target]", 440, 510)
	popup.set_content(dat.Join())
	popup.open()