extends "res://scripts/character_ground.gd"

@onready var game = get_parent()

func _ready() -> void:
	equipped_ground_gun = "docgun"
	
	super()
	
	health = 999

func _on_state_1_body_entered(body: Node2D) -> void:
	if body != game.get_node("PlayerGround"): return
		
	global.stats.mission_progress = 3
	
	game.get_node("HospitalEscapeD2State1").monitoring = false
	
	print("test")
	
	vertical_movement = -1
	horizontial_movement = -1
	
	while global_position.y > -1376.0: await get_tree().create_timer(0.1).timeout
	
	vertical_movement = 0
	horizontial_movement = 0
		
	await game.dialogue("Get over here!", "doctor_2", false)

func _on_state_2_body_entered(body: Node2D) -> void:
	if body != game.get_node("PlayerGround"): return
	
	game.get_node("HospitalEscapeD2State2").monitoring = false
	game.get_node("HospitalEscapeD2State2").queue_free()
	
	firing = true
	
	while game.get_node("Camper1").health > 0:
		$HeldItem.look_at(game.get_node("Camper1").global_position)
		
		await get_tree().create_timer(0.2).timeout
		
	while game.get_node("Camper2").health > 0:
		$HeldItem.look_at(game.get_node("Camper2").global_position)
		
		await get_tree().create_timer(0.2).timeout
		
	while game.get_node("Camper4").health > 0:
		$HeldItem.look_at(game.get_node("Camper4").global_position)
		
		await get_tree().create_timer(0.2).timeout
	
	firing = false
	
	await get_tree().create_timer(0.666).timeout
	
	set_ground_gun(null)
	
	game.get_node("Dnbd").playing = false
	game.get_node("IntrusionAlarm").play()
	
	await game.dialogue("You need to go, now.", "doctor_2", true)
	
	await navigate_to(game.get_node("Doctor2DoorWaypoint").global_position)
	
	var player = game.get_node("PlayerGround")
	
	if (global_position - player.global_position).length() > 200:
		await game.dialogue("Come.", "doctor_2", false)
		
		while (global_position - player.global_position).length() > 200: await get_tree().create_timer(0.25).timeout
	
	player.busy = true
	
	await game.dialogue("Is the other doctor dead?", "doctor_2", false)
	
	var option = await game.make_choice({
		"yes": "Yes",
		"no": "No"
	})
	
	if option == "yes":
		await game.dialogue("Shit. I liked hating him.", "doctor_2", true)
	else:
		await game.dialogue("Damnit. Was hoping he was.", "doctor_2", true)
	
	await game.dialogue("Anyways, there's probably some of those bastards in there, so be careful.", "doctor_2", true)
	
	await game.dialogue("Your ship is on the first row, furthest to the left.", "doctor_2", false)
	
	var option_2 = null
	
	while option_2 != "got_it":
		option_2 = await game.make_choice({
			"whoarethey": "Who are they?",
			"whataboutyou": "What about you?",
			"got_it": "Got it",
		})
		
		if option_2 == "whoarethey":
			await game.dialogue("Who are these people, anyways?", "player", true)
			
			await game.dialogue("You don't know?... oh wait, that makes sense.", "doctor_2", true)
			await game.dialogue("Those guys are from HADA, the Humble Anarchist's Defense Alliance.", "doctor_2", true)
			await game.dialogue("Nasty people. They do a lot of things...", "doctor_2", true)
			await game.dialogue("but they also iketo try and destroy anything they see as a threat to their ideals.", "doctor_2", true)
			await game.dialogue("They almost never fully succeed, but that doesn't mean they don't leave a mark.", "doctor_2", true)
		elif option_2 == "whataboutyou":
			await game.dialogue("What are you going to do?", "player", true)
			
			await game.dialogue("I will be camping it out.", "doctor_2", true)
			await game.dialogue("I live here. If I left all my stuff behind like this, I would hate myself.", "doctor_2", true)
			await game.dialogue("That's not something you should worry about excessively, though. You don't even know me.", "doctor_2", true)
			
		global.stats.story_progress = 3
		
		game.save_game()
		
		checkpoint_2()

func checkpoint_2():
	game.get_node("Dnbd").playing = false
	game.get_node("IntrusionAlarm").play()
	
	var player = game.get_node("PlayerGround")
	
	player.busy = true 
	
	await game.dialogue("I wish you luck.", "doctor_2", true)
	
	game.get_node("Dnbd").playing = true
	
	player.health = 100
	
	game.get_node("Camper5").global_position = game.get_node("CamperSpawn3").global_position
	game.get_node("Camper6").global_position = game.get_node("CamperSpawn4").global_position
	
	player.busy = false
	
	game.get_node("Doctor2DoorToOpen").set_open(true)
	


func _on_state_3_body_entered(body: Node2D) -> void:
	game.get_node("Doctor2DoorToOpen").set_open(false)
	
