SUBSYSTEM_DEF(autosave)
	name = "Autosave"
	wait = 3 HOURS
	next_fire = 3 HOURS	// To prevent saving upon start.

	var/saving = 0
	var/announced = 0

/datum/controller/subsystem/autosave/stat_entry()
	var/minutes = (next_fire - world.time) / (1 MINUTE)

	if(!announced && (minutes <= 5))
		to_world("<font size=4 color='green'>Autosave in 5 Minutes!</font>")
		announced = 1

	if(announced == 1 && (minutes <= 1))
		to_world("<font size=4 color='green'>Autosave in 1 Minute!</font>")
		announced = 2
		
	if(minutes > 5)
		announced = 0
	
	..(saving ? "Currently Saving" : "Next autosave in [round(minutes, 0.1)] minutes.")
	

/datum/controller/subsystem/autosave/fire()
	Save()

/datum/controller/subsystem/autosave/proc/Save()
	if(saving)
		message_admins(SPAN_DANGER("Attempted to save while already saving!"))
	else
		saving = 1
		for(var/datum/controller/subsystem/S in Master.subsystems)
			S.disable()
		Save_World()
		for(var/datum/controller/subsystem/S in Master.subsystems)
			S.enable()
		saving = 0