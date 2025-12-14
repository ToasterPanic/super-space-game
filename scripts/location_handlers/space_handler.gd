extends Node2D

@onready var game = get_parent()
@onready var player = game.get_node("Player")

func _ready() -> void:
	if global.stats.story_progress == 3:
		await get_tree().create_timer(0.5).timeout
		
		game.get_node("UI/Control/MoveTutorial").visible = true
		
		await game.dialogue("Use the sticks to go around that corner.", "zmg_hideout_captain")
		
		while !game.get_node("Orbits/TrainingCourse/TutorialHitbox1").get_overlapping_bodies().has(player):
			await get_tree().create_timer(0.2).timeout
		
		game.get_node("UI/Control/MoveTutorial").visible = false
		
		await game.dialogue("Boosting lets you move faster for a short time.", "zmg_hideout_captain")
		
		game.get_node("UI/Control/BoostTutorial").visible = true
		
		while !player.boosting:
			await get_tree().create_timer(0.1).timeout
			
		game.get_node("Orbits/TrainingCourse/Barrier1").queue_free()
		
		while !game.get_node("Orbits/TrainingCourse/TutorialHitbox2").get_overlapping_bodies().has(player):
			await get_tree().create_timer(0.2).timeout
		
		game.get_node("UI/Control/BoostTutorial").visible = false
		
		await game.dialogue("Proceed further.", "zmg_hideout_captain")
		
		while !game.get_node("Orbits/TrainingCourse/TutorialHitbox3").get_overlapping_bodies().has(player):
			await get_tree().create_timer(0.2).timeout
		
		await game.dialogue("Destroy the target ship.", "zmg_hideout_captain")
		
		game.get_node("UI/Control/FireTutorial").visible = true
		
		while !game.get_node("Enemies/TargetPractice").health > 0:
			await get_tree().create_timer(0.2).timeout
		
		game.get_node("UI/Control/FireTutorial").visible = false
		
		await game.dialogue("Not bad. Proceed further.", "zmg_hideout_captain")
