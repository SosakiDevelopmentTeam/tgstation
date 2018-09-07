#define ROT_ 0
#define ANAL_ 1
#define vag_nal 2
#define otsos_ 3
#define SCACAT_A 4
#define SCACAT_B 5
#define Droch_ 6

/mob/living/verb/erp_panel()
	set category = "IC"
	set src in usr.loc//src - target   usr - source
	var/mob/living/user = usr
	var/mob/living/target = src
	var/list/dat = list()
	dat += "<table>"
	dat += "<tr><td><center><b>ERP System</b></center></td></tr>"
	dat += "<tr><td><b>User: [user.gender]</b></td></tr>"
	dat += "<tr><td><b>Target: [target.gender]</b></td></tr>"
	//-------------
	if(istype(user) && istype(target)){
		if(user != target){
			if(user.gender == "male")
			{
				dat += "<tr><td><B><A href='?src=[REF(src)];erp=[ROT_]'>Â ðîòèê</A></B></td></tr>"
				dat += "<tr><td><B><A href='?src=[REF(src)];erp=[ANAL_]'>Â æîïó</A></B></td></tr>"
			}
			if(target.gender != "male")
			{
				dat += "<tr><td><B><A href='?src=[REF(src)];erp=[vag_nal]'>Â ïèçäó</A></B></td></tr>"
			}



			if(target.gender == "male")
			{
				dat += "<tr><td><B><A href='?src=[REF(src)];erp=[otsos_]'>Îòñîñàòü</A></B></td></tr>"
			}

			if(user.gender != "male")
			{
				if(target.gender == "male")
				{
					dat += "<tr><td><B><A href='?src=[REF(src)];erp=[SCACAT_A]'>Æîïîé íà õóé</A></B></td></tr>"
					dat += "<tr><td><B><A href='?src=[REF(src)];erp=[SCACAT_B]'>Ïèçäîé íà õóé</A></B></td></tr>"
				}
			}
		}
		if(user == target)
		{
			dat += "<tr><td><B><A href='?src=[REF(src)];erp=[Droch_]'>Äðî÷èòü</A></B></td></tr>"
		}
	}
	dat += "</table>"
	var/datum/browser/popup = new/datum/browser(user, "mob[REF(target)]", "[target]", 440, 510)
	popup.set_content(dat.Join())
	popup.open()
