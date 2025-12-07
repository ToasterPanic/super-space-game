extends "res://scripts/character_ground.gd"

@onready var game = get_parent()

func _ready() -> void:
	super()
	
	health = 50

func _interact(player: Node2D) -> void:
	player.get_node("Camera").enabled = false
	$Camera.enabled = true
	$InteractArea.monitoring = false
	
	player.busy = true
	
	await game.dialogue("Ready to leave?", "doctor", false)
	
	var option = await game.make_choice({
		"yes": "Yes",
		"no": "No"
	})
	
	if option == "yes":
		await game.dialogue("Alrighty!", "doctor")
		
		await game.dialogue("We have your stuff back here, let me go grab it real quick...", "doctor")
		
		
		await game.dialogue("Here's your bag.", "doctor")
		
		await game.dialogue("Should have everything - tablet, ship keys, a pistol...", "doctor")
		
		game.get_node("DistantGunshots1").play()
		
		await get_tree().create_timer(2).timeout
		
		await game.dialogue("...the hell?", "doctor", false)
		
		await get_tree().create_timer(1.5).timeout
		
		game.get_node("IntrusionAlarm").play()
		
		game.get_node("Map").modulate = Color(0.5, 0.35, 0.35)
		
		await get_tree().create_timer(1).timeout
		
		await game.dialogue("Oh, no.", "doctor", true)
		
		await get_tree().create_timer(0.5).timeout
		
		await game.dialogue("We need to leave. Now.", "doctor", true)
		
		await get_tree().create_timer(0.5).timeout
		
		$Camera.enabled = false
		player.get_node("Camera").enabled = true
		
		player.busy = false
		
		await game.dialogue("Follow me.", "doctor", false)
		
		await navigate_to(game.get_node("DoctorEscapeWaypoint1").position)
		
		while !game.get_node("DoctorEscapeWaypoint1/Area").get_overlapping_bodies().has(player): await get_tree().create_timer(0.2).timeout
		
		player.busy = true
		
		await game.dialogue("You good with that gun?", "doctor", true)
		
		var option_2 = await game.make_choice({
			"yes": "Yes",
			"no": "No"
		})
		
		if option_2 == "yes": await game.dialogue("Good to know.", "doctor", true)
		else: await game.dialogue("Well, you're still probably better than I would be.", "doctor", true)
		
		global.stats.story_progress = 2
		
		game.save_game()
		
		checkpoint_1()
		
	elif option == "no":
		await game.dialogue("Well, I'm here whenever you need me.", "doctor")
		
	
	player.get_node("Camera").enabled = true
	$Camera.enabled = false
	$InteractArea.monitoring = true
	
	player.busy = false
	
	return


func checkpoint_1():
	var player = game.get_node("PlayerGround")
	
	await game.dialogue("You should probably get it out.", "doctor", false)
		
	player.busy = false
	
	global.stats.equipped_ground_gun = "pistol"
	
	game.get_node("UI/Control/UnholsterTutorial").visible = true
	
	while global.stats.gun_holstered: await get_tree().create_timer(0.2).timeout
	
	game.get_node("UI/Control/UnholsterTutorial").visible = false
	
	await game.dialogue("Let's go.", "doctor", false)
	
	game.checkpoint()
	
	await navigate_to(game.get_node("DoctorEscapeWaypoint2").position)
	
	while !game.get_node("DoctorEscapeWaypoint2/Area").get_overlapping_bodies().has(player): await get_tree().create_timer(0.2).timeout
	
	await game.dialogue("RUN!", "doctor", false)
	
	game.get_node("MedbayDoorLargeVertical").free()
	
	vertical_movement = 0.1
	
	game.get_node("Camper1/HeldItem").look_at(global_position)
	game.get_node("Camper2/HeldItem").look_at(global_position)
	
	game.get_node("Camper1").firing = true
	await get_tree().create_timer(0.06).timeout
	game.get_node("Camper2").firing = true
	
	while health > 0: await get_tree().create_timer(0.2).timeout
	
	await game.end_dialogue()
	
	game.get_node("Camper1").firing = false
	await get_tree().create_timer(0.06).timeout
	game.get_node("Camper2").firing = false
	
	await get_tree().create_timer(0.333).timeout
	
	game.get_node("Camper1").concious = true
	game.get_node("Camper2").concious = true
	
	game.get_node("Camper3").global_position = game.get_node("CamperSpawn1").global_position
