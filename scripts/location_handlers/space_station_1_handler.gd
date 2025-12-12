extends Node2D

var game = null
@onready var player = null

func _ground_ready() -> void:
	player = game.get_node("PlayerGround")
	
	if global.stats.story_progress == 0:
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
	
		await game.dialogue("... he's been here for two months!", "doctor_2", false)
		
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
	
		var option_0 = await game.make_choice({
			"what": "...what?",
			"huh": "...huh?",
			"magic": "...magic?"
		})
		
		if option_0 == "what":
			await game.dialogue("...what?", "player", true, player)
		elif option_0 == "huh":
			await game.dialogue("...huh?", "player", true, player)
		elif option_0 == "magic":
			await game.dialogue("...magic?", "player", true, player)
	
		await game.dialogue("Ha!", "doctor_1", false, game.get_node("Doctor1"))
		await game.dialogue("What???", "doctor_2", true, game.get_node("Doctor2"))
		
		game.end_dialogue(game.get_node("Doctor1"))
		
		await game.dialogue("...", "doctor_2", true, game.get_node("Doctor2"))
		
		await game.dialogue("I can't say that's bad.", "doctor_2", true, game.get_node("Doctor2"))
		
		await game.dialogue("Yes???", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("You should probably treat him.", "doctor_2", true, game.get_node("Doctor2"))
		
		await game.dialogue("After that? You do it!", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("Just treat him, Christ.", "doctor_2", true, game.get_node("Doctor2"))
		
		game.get_node("Doctor2").navigate_to(game.get_node("Waypoints/Doctor2Waypoint1").global_position)
		
		await game.dialogue("You just yelled at me for...!", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("Ugh.", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("Sorry for the rough wakeup...", "doctor_1", true, game.get_node("Doctor1"))
	
		var option_1 = await game.make_choice({
			"where": "Where am I..?",
			"who": "Who are you..?",
			"bundle_of_joy": "Bundle of joy, huh?"
		})
		
		if option_1 == "who":
			await game.dialogue("Who are you..?", "player", true, player)
				
			await game.dialogue("I'm Doctor Rosenheim.", "doctor_1", true, game.get_node("Doctor1"))
		elif option_1 == "bundle_of_joy":
			await game.dialogue("He seems like a bundle of joy.", "player", true, player)
			
			await game.dialogue("Yeah. Irritable, greedy bastard.", "doctor_1", true, game.get_node("Doctor1"))
			await game.dialogue("It's a wonder he's kept his job, to be honest...", "doctor_1", true, game.get_node("Doctor1"))
			await game.dialogue("...anyways, I should probably explain why you're here.", "doctor_1", true, game.get_node("Doctor1"))
			
		await game.dialogue("You're currently in the Helios Memorial Medical Centre aboard Space Station 01.", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("You've been in a coma-like state for the past two months.", "doctor_1", true, game.get_node("Doctor1"))

		var option_2 = null 
		while option_2 != "whats_next":
			option_2 = await game.make_choice({
				"space": "Space?",
				"coma": "Coma?",
				"whats_next": "What now?"
			})
			
			if option_2 == "coma":
				await game.dialogue("A coma?", "player", true, player)
				
				await game.dialogue("It's not exactly a coma. A condition called Space Overstimulation Syndrome.", "doctor_1", true, game.get_node("Doctor1"))
				
				await game.dialogue("Caused by extreme long-term exposure to zero-gravity.", "doctor_1", true, game.get_node("Doctor1"))
				
				await game.dialogue("At its worst, such as in your case, it causes limb spasms,", "doctor_1", true, game.get_node("Doctor1"))
				
				await game.dialogue("alongside short-term memory loss, intermittent unconciousness,", "doctor_1", true, game.get_node("Doctor1"))
				
				await game.dialogue("and an inability to think clearly.", "doctor_1", true, game.get_node("Doctor1"))
				
				await game.dialogue("It can also cause severe long-term memory loss in some cases.", "doctor_1", true, game.get_node("Doctor1"))
			if option_2 == "space":
				await game.dialogue("I'm in space???", "player", true, player)
				
				await game.dialogue("Yes, you are in space.", "doctor_1", true, game.get_node("Doctor1"))
				
				await game.dialogue("We actually found you in the nearby Galacta convenience store.", "doctor_1", true, game.get_node("Doctor1"))
				
				await game.dialogue("Thankfully for you, that's literally next door to us.", "doctor_1", true, game.get_node("Doctor1"))
				
				await game.dialogue("You'd think I would remember that, though...", "player", true, player)
				
				await game.dialogue("The condition you have likely caused long-term memory loss.", "doctor_1", true, game.get_node("Doctor1"))
				
				await game.dialogue("That's probably why you don't remember.", "doctor_1", true, game.get_node("Doctor1"))
				
		await game.dialogue("So, what now?", "player", true, player)
		
		await game.dialogue("Well, I'm going to go to my desk to do paperwork.", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("Once you feel ready, you can come up to my desk and I'll get you discharged.", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("Yell for me if you need anything.", "doctor_1", true, game.get_node("Doctor1"))
		
		_handle_1()
		
		await get_tree().create_timer(1.25).timeout
		
		player.busy = false
		
		player.speed = 64
		
		game.get_node("UI/Control/MoveTutorial").visible = true
		
		while player.velocity.length() < 32:
			if i < 100:
				await get_tree().create_timer(0.2).timeout
				
				game.set_vignette_parameter("softness", i * 0.02)
				
				i += 1
		
		await get_tree().create_timer(1.25).timeout

		game.get_node("UI/Control/MoveTutorial").visible = false
		
		while i < 100:
			await get_tree().create_timer(0.2).timeout
			
			game.set_vignette_parameter("softness", i * 0.02)
			
			i += 1
			
func _handle_1():
	await game.get_node("Doctor1").navigate_to(game.get_node("Waypoints/Doctor1Waypoint1").global_position)
	
	game.get_node("RosenheimOfficeDoor1").set_open(true)
		
	await game.get_node("Doctor1").navigate_to(game.get_node("Waypoints/Doctor1Waypoint2").global_position)
			
	game.get_node("RosenheimOfficeDoor1").set_open(false)


func _on_speed_up_area_entered(body: Node2D) -> void:
	if body.get_parent() == player:
		player.speed = 128

func _interact(player: Node2D, area: Area2D):
	if area.get_name() == "Doctor1DeskInteract":
		player.busy = true
		
		area.monitoring = false
		
		await game.dialogue("Ready to leave?", "doctor_1", false, game.get_node("Doctor1"))
		
		var option_0 = await game.make_choice({
			"yes": "Yes",
			"no": "No"
		})
		
		if option_0 == "no":
			await game.dialogue("Okay, I'll be here when you're ready.", "doctor_1", true, game.get_node("Doctor1"))
			
			player.busy = false
			
			area.monitoring = true
			
			return
			
		
		await game.dialogue("Okay! But first...", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("I'm going to need your name.", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("If you remember it, of course.", "doctor_1", true, game.get_node("Doctor1"))
		
		var option_1 = await game.make_choice({
			"kendall": "Kendall..."
		})
		
		await game.dialogue("Kendall...", "player", true, player)
		
		await game.dialogue("And last name?", "doctor_1", true, game.get_node("Doctor1"))
	
		var option_2 = await game.make_choice({
			"kian": "Kian?",
			"no_clue": "No clue"
		})
		
		if option_2 == "kian":
			await game.dialogue("Kian...?", "player", true, player)
			
			await game.dialogue("Got it.", "doctor_1", true, game.get_node("Doctor1"))
		else:
			await game.dialogue("I have no clue, sorry.", "player", true, player)
			
			await game.dialogue("Ah. Unfortunate.", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("Still woozy?", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("A little bit.", "player", true, player)
		
		await game.dialogue("Okay. You'll be able to sit down", "doctor_1", false, game.get_node("Doctor1"))
		
		game.end_dialogue(game.get_node("Doctor1"))
		
		$DistantGunshots.play()
		
		game.get_node("Doctor2").navigate_to(game.get_node("Waypoints/Doctor2Waypoint2").global_position)
		
		await get_tree().create_timer(1.5).timeout
		
		await game.dialogue("What in the...?", "doctor_1", false, game.get_node("Doctor1"))
		
		await get_tree().create_timer(1.5).timeout
		
		$IntrusionAlarm.play()
		
		await get_tree().create_timer(0.75).timeout
		
		await game.dialogue("Oh, great.", "doctor_1", false, game.get_node("Doctor1"))
		
		await get_tree().create_timer(1).timeout
		
		$DoorBang.play()
		
		await get_tree().create_timer(2).timeout
		
		game.dialogue("The hell?!", "doctor_2", false, game.get_node("Doctor2"))
		
		await game.dialogue("?!", "doctor_1", true, game.get_node("Doctor1"))
		
		game.end_dialogue(game.get_node("Doctor2"))
		
		await game.dialogue("You take them somewhere safe, I'll go see who it is.", "doctor_2", true, game.get_node("Doctor2"))
		
		await game.dialogue("There were just gunshots!", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("Are you trying to get yourself killed?!", "doctor_1", true, game.get_node("Doctor1"))
		
		await game.dialogue("I know you'd want that, stop whining.", "doctor_2", true, game.get_node("Doctor2"))
		
		game.get_node("Doctor2").navigate_to(game.get_node("Waypoints/Doctor2Waypoint3").global_position)
		
		await game.dialogue("...you need to come with me.", "doctor_1", true, game.get_node("Doctor1"))
		
		player.busy = false
		
		await game.get_node("Doctor1").navigate_to(game.get_node("Waypoints/Doctor1Waypoint3").global_position)
		
		game.get_node("RosenheimOfficeDoor1").set_open(true)
		
		while (player.global_position - game.get_node("Doctor1").global_position).length() > 56: await get_tree().create_timer(0.1).timeout
		
		await game.get_node("Doctor1").navigate_to(game.get_node("Waypoints/Doctor1Waypoint4").global_position)
		
		while (player.global_position - game.get_node("Doctor1").global_position).length() > 56: await get_tree().create_timer(0.1).timeout
		
		game.get_node("RosenheimOfficeDoor1").set_open(false)
		
		await game.get_node("Doctor1").navigate_to(game.get_node("Waypoints/Doctor1Waypoint5").global_position)
		
		while (player.global_position - game.get_node("Doctor1").global_position).length() > 56: await get_tree().create_timer(0.1).timeout
		
		await game.get_node("Doctor1").navigate_to(game.get_node("Waypoints/Doctor1Waypoint6").global_position)
		
		while (player.global_position - game.get_node("Doctor1").global_position).length() > 56: await get_tree().create_timer(0.1).timeout
		
		await game.get_node("Doctor1").navigate_to(game.get_node("Waypoints/Doctor1Waypoint7").global_position)
		
		while (player.global_position - game.get_node("Doctor1").global_position).length() > 56: await get_tree().create_timer(0.1).timeout
		
		await game.dialogue("Stay close.", "doctor_1", false, game.get_node("Doctor1"))
		
		await get_tree().create_timer(1.75).timeout
		
		await game.end_dialogue(game.get_node("Doctor1"))
		
		await game.get_node("Doctor1").navigate_to(game.get_node("Waypoints/Doctor1Waypoint8").global_position)
		
		while (player.global_position - game.get_node("Doctor1").global_position).length() > 56: await get_tree().create_timer(0.1).timeout
