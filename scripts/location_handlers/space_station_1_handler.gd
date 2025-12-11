extends Node2D

var game = null
@onready var player = null

func _ground_ready() -> void:
	player = game.get_node("PlayerGround")
	
	if global.stats.story_progress < 999:
		#game.get_node("HeartMonitor").play()
		
		game.set_vignette_parameter("radius", 0)
		game.set_vignette_parameter("softness", 0)
		
		player.position = game.get_node("Waypoints/PlayerIntroSpawn").global_position
		player.busy = true
		
		await get_tree().create_timer(1).timeout
	
		game.dialogue("... we don't even ... their family ... !", "doctor_1", false)
		
		player.position = game.get_node("Waypoints/PlayerIntroSpawn").global_position
		
		var i = 0
		while i < 8:
			await get_tree().create_timer(0.2).timeout
			
			game.set_vignette_parameter("softness", i * 0.02)
			
			i += 1
			
		while i > 0:
			await get_tree().create_timer(0.2).timeout
			
			game.set_vignette_parameter("softness", i * 0.02)
			
			i -= 1
		
		await get_tree().create_timer(2).timeout
		
		game.end_dialogue()
	
		game.dialogue("... and we don't have infinite resources ...", "doctor_2", false)
		
		await get_tree().create_timer(3).timeout
	
		game.dialogue("... please! ...", "doctor_1", false)
		
		await get_tree().create_timer(1).timeout
	
		await game.dialogue("... he's been here for five months!", "doctor_2", false)
		
		await get_tree().create_timer(1.5).timeout
	
		game.dialogue("I can't bleed station money for this one guy!", "doctor_2", false)
		
		i = 0
		while i < 5:
			await get_tree().create_timer(0.2).timeout
			
			game.set_vignette_parameter("softness", i * 0.02)
			
			i += 1
		
		await get_tree().create_timer(3).timeout
	
		game.dialogue("If he doesn't magically wake up in the next five seconds...", "doctor_2", false)
		
		while i < 25:
			await get_tree().create_timer(0.2).timeout
			
			game.set_vignette_parameter("softness", i * 0.02)
			
			i += 1
	
		await game.make_choice({
			"what": "...what?",
			"huh": "...huh?",
			"magic": "...magic?"
		})
	
		await game.dialogue("Ha!", "doctor_1", false, game.get_node("Doctor1"))
		await game.dialogue("What???", "doctor_2", true, game.get_node("Doctor2"))
