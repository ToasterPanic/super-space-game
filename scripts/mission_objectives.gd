extends VBoxContainer

var last_mission_progres = -1

func _process(delta: float) -> void:
	if global.stats.active_mission:
		visible = true
		
		var mission = global.missions[global.stats.active_mission]
		
		if last_mission_progres != global.stats.mission_progress:
			last_mission_progres = global.stats.mission_progress
			
			
		if  mission.objectives.values().size() - 1 < global.stats.mission_progress:
			global.stats.completed_missions.push_front(global.stats.active_mission)
			global.stats.mission_progress = 0
			global.stats.active_mission = null
			
			return 
			
		$Label.text = mission.name
		$Label2.text = "- " + mission.objectives.values()[global.stats.mission_progress]
	else:
		visible = false
