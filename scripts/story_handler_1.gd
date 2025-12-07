extends Node2D

var game = null
@onready var player = null

func _ground_ready() -> void:
	
	
	player = game.get_node("PlayerGround")
	
	if global.stats.story_progress == 0:
		game.get_node("Uglyburger").stop()
		game.get_node("HeartMonitor").play()
		
		game.set_vignette_parameter("radius", 0)
		game.set_vignette_parameter("softness", 0)
		
		player.position = game.get_node("PlayerSpawnIntro").global_position
		player.busy = true
			
		await get_tree().create_timer(0.5).timeout
		
		await game.dialogue("ugh...", "player_woozy", false)
		
		await get_tree().create_timer(1).timeout
		
		game.end_dialogue()
		
		var i = 0
		while i < 5:
			await get_tree().create_timer(0.2).timeout
			
			game.set_vignette_parameter("softness", i * 0.02)
			
			i += 1
			
		while i > 0:
			await get_tree().create_timer(0.2).timeout
			
			game.set_vignette_parameter("softness", i * 0.02)
			
			i -= 1
			
		await game.dialogue("Is he concious..?", "doctor_1", false)
		
		await get_tree().create_timer(2).timeout
		
		await game.dialogue("Franky, I doubt it. You know the recovery rates.", "doctor_2", false)
		
		await get_tree().create_timer(1.5).timeout
		
		await game.dialogue("Monitor's probably just bugging out, per the usual...", "doctor_2", false)
		
		var choice_1 = await game.make_choice({
			"what": "...what..?",
			"huh": "...huh..?",
			"whhngh": "...whhngh..."
		})
		
		if choice_1 == "what":
			await game.dialogue("...what...", "player_woozy", false)
		elif choice_1 == "huh":
			await game.dialogue("...huh..?", "player_woozy", false)
		elif choice_1 == "whhngh":
			await game.dialogue("...whhngh...", "player_woozy", false)
			
		await game.dialogue("Wait... can you hear me?", "doctor_2", false)
		
		var choice_2 = await game.make_choice({
			"yeah": "...yeah..?",
			"yeah2": "...yea..."
		})
		
		if choice_2 == "yeah":
			await game.dialogue("...yeah..?", "player_woozy", false)
		elif choice_2 == "yeah2":
			await game.dialogue("...yea...", "player_woozy", false)
		
		await get_tree().create_timer(0.5).timeout
		
		while i < 5:
			await get_tree().create_timer(0.2).timeout
			
			game.set_vignette_parameter("softness", i * 0.02)
			
			i += 1
			
		await game.dialogue("Woah, that's...", "doctor_1", false)
		
		while i < 10:
			await get_tree().create_timer(0.2).timeout
			
			game.set_vignette_parameter("softness", i * 0.02)
			
			i += 1
		
		await get_tree().create_timer(1.5).timeout
			
		await game.dialogue("...well, what do we do now?", "doctor_2", false)
		
		await get_tree().create_timer(2).timeout
			
		await game.dialogue("I can handle it if you want.", "doctor_1", false)
		
		await get_tree().create_timer(1.5).timeout
			
		await game.dialogue("Well, if you need any help, ping me.", "doctor_2", false)
		
		await get_tree().create_timer(1).timeout
		
		await game.dialogue("Don't worry, I won't.", "doctor_1", false)
		
		i = 0
		
		while i < 35:
			await get_tree().create_timer(0.2).timeout
			
			game.set_vignette_parameter("softness", i * 0.04)
			
			i += 2
		
		var choice_3 = await game.make_choice({
			"where_am_i": "...where am I?",
			"who_are_you": "...who are you?"
		})
		
		if choice_3 == "where_am_i":
			await game.dialogue("...where am I..?", "player_slow", false)
		
			await get_tree().create_timer(0.5).timeout
		elif choice_3 == "who_are_you":
			await game.dialogue("...who are you..?", "player_slow", false)
		
			await get_tree().create_timer(0.5).timeout
			
			await game.dialogue("Well, I'm Doctor Hohm.", "doctor_1")
			
		await game.dialogue("You're currently in the Rosenhein Memorial Intergalatic Hospital.", "doctor_1")
			
		await game.dialogue("You've been in a... coma-like state for the past four weeks.", "doctor_1")
		
		
		var choice_4 = null
		
		while choice_4 != "whats_next":
			choice_4 = await game.make_choice({
				"space": "I'm in space...?",
				"coma": "Coma...?",
				"whats_next": "What's next...?",
			})
			
			print(choice_4)
			
			if choice_4 == "space":
				await game.dialogue("Hold on... intergalactic... I'm in space?", "player_slow", false)
				
				await get_tree().create_timer(0.5).timeout
				
				await game.dialogue("Yes, you're in space.", "doctor_1")
				
				await game.dialogue("...how the hell did I get here?", "player_slow")
				
				await game.dialogue("Well, I don't know..", "doctor_1")
				await game.dialogue("The story is that you collapsed trying to buy a pack of Twizzlers at the Galacta store.", "doctor_1")
				await game.dialogue("Thankfully, we're right next to the Galacta store.", "doctor_1")
			elif choice_4 == "coma":
				await game.dialogue("A coma..?", "player_slow", false)
				
				await get_tree().create_timer(0.5).timeout
				
				await game.dialogue("Well, it's not actually a coma.", "doctor_1")
				
				await game.dialogue("It's called Intergalactic Processing Disorder.", "doctor_1")
				
				await game.dialogue("People with certain genetics are prone to have that happen under extreme, prolonged stress.", "doctor_1")
				
				await game.dialogue("Most people don't wake up again. You got lucky.", "doctor_1")
				
		await game.dialogue("So, what's next?", "player_slow")
				
		await game.dialogue("Well, we're going to give you a minute to fully regain your abilities.", "doctor_1")
				
		await game.dialogue("Then we'll make sure you're fit to leave.", "doctor_1")
		
		await game.dialogue("Once that's done, you'll be discharged.", "doctor_1")
		
		await game.dialogue("Feel free to get up and walk around, by the way.", "doctor_1")
		
		await game.dialogue("When you're feeling ready, I'll be at the end of the hall.", "doctor_1")
		
		await game.get_node("Doctor").navigate_to(game.get_node("DoctorHallWaypoint").position)
		
		game.get_node("Doctor").global_position = game.get_node("DoctorDeskWaypoint").position
		
		global.stats.story_progress = 1
		
		player.busy = false
		
		while i < 100:
			await get_tree().create_timer(0.2).timeout
			
			game.set_vignette_parameter("softness", i * 0.04)
			
			i += 2
			
		game.get_node("UI/Control/MoveTutorial").visible = true
		
		while player.velocity.length() == 0:
			await get_tree().create_timer(0.1).timeout
			
		await get_tree().create_timer(1).timeout
		
		print("end")
		
		game.get_node("UI/Control/MoveTutorial").visible = false
		
	elif global.stats.story_progress == 1:
		pass
	elif global.stats.story_progress == 2:
		game.get_node("Uglyburger").stop()
		
		game.get_node("IntrusionAlarm").play()
		
		game.get_node("Map").modulate = Color(0.5, 0.35, 0.35)
		
		game.get_node("Doctor/InteractArea").monitoring = false
		
		player.global_position = game.get_node("Checkpoint1PlayerSpawn").global_position
		game.get_node("Doctor").global_position = game.get_node("Checkpoint1DoctorSpawn").global_position
		
		game.get_node("Doctor").checkpoint_1()
	else:
		game.save_game()
