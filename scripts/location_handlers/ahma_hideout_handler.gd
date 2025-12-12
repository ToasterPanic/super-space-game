extends Node2D

var game = null
@onready var player = null

func _ground_ready() -> void:
	player = game.get_node("PlayerGround")
	
	if global.stats.story_progress == 1:
		game.set_vignette_parameter("radius", 0)
		game.set_vignette_parameter("softness", 0)
		
		player.position = game.get_node("Waypoints/PlayerIntroSpawn").global_position
		player.busy = true
		
		await get_tree().create_timer(3).timeout
	
		await game.dialogue("... are we just gonna let him go?", "zmg_doctor_1", true)
	
		await game.dialogue("No reason not to.", "zmg_head_manager", true)
		
		_handle_1()
	
		await game.dialogue("You might as well make an offer.", "zmg_doctor_1", true)
	
		await game.dialogue("It's not like they have anything going for them.", "zmg_doctor_1", true)
	
		await game.dialogue("You do have a point, but...", "zmg_hideout_captain", true)
	
		await game.dialogue("They're a SOD survivor with no contacts!", "zmg_doctor_1", true)
	
		await game.dialogue("Where are they expected to go to after this?", "zmg_doctor_1", true)
		
		await game.dialogue("Ehhhh...", "zmg_hideout_captain", true)
	
		await game.dialogue("You know what? Sure.", "zmg_hideout_captain")
		
		var i = 0
		while i < 15:
			await get_tree().create_timer(0.2).timeout
			
			game.set_vignette_parameter("softness", i * 0.02)
			
			i += 1
			
		_handle_2()
	
		await game.dialogue("Oh, they're awake!", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
	
		await game.dialogue("Wow, this soon?", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		var option_0 = await game.make_choice({
			"where": "... where am I ...",
			"dont_hurt_me": "... don't hurt me ...",
			"again": "... again ...?",
		})
		
		if option_0 == "dont_hurt_me":
			await game.dialogue("... don't hurt me ...", "player", true, player)
			
			await game.dialogue("Don't worry, we won't.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
			await game.dialogue("We aren't the ones who attacked you.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
			
			await game.dialogue("...it's probably wise to tell you where you are, though.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
			
			await game.dialogue("You're currently in an ZMG hideout.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		elif option_0 == "again":
			await game.dialogue("... again ..?", "player", true, player)
			
			await game.dialogue("Yeah, unfortunately...", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
			await game.dialogue("...well, it's probably wise to tell you where you are.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
			
			await game.dialogue("You're currently in an ZMG hideout.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		elif option_0 == "where":
			await game.dialogue("... where am I ...", "player", true, player)
			
			await game.dialogue("Well, you're currently in an ZMG hideout.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		
		await game.dialogue("While we were attempting to stop a terrorist attack on Space Station 01,", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("we found you on the ground, riddled with bullet holes.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("The majority of them have healed.", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		await game.dialogue("You've been out for... almost four earth days?", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		await game.dialogue("Carie, if you could wait a second, I'd like to ask them a question.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("Do you remember anything from your past life?", "zmg_hideout_captain", false, game.get_node("ZMGHideoutCaptain"))
		
		var option_1 = await game.make_choice({
			"uhhh": "Uhhhhh...",
			"no": "No...",
		})
		
		if option_1 == "uhhh":
			await game.dialogue("I will take that as a no.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		elif option_1 == "no":
			await game.dialogue("That's what I thought.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("I'd like to make you a deal.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("If you're not aware, we're a military contractor for the Atlana Alliance.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("We'll try and find people from your past life.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("We can give you a place to sleep, a ship, as well as plenty of food and water.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("In return, I'd like you to work for us for a while.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("If you don't want to take the offer,", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("we'll just give you a ride to the nearest space station.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("Is that a deal or no?", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		var option_2 = await game.make_choice({
			"yes": "Yes",
			"no": "No",
		})
		
		if option_2 == "no":
			await game.dialogue("Ehhhh, not sure I want to take that.", "player", true, player)
			
			await game.dialogue("Are you sure? That might not be the wisest choice.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
			
			await game.dialogue("You have no contacts, it'll be a struggle to go on your own.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
			
			var option_3 = await game.make_choice({
				"take_offer": "Take the offer",
				"leave": "Don't take it",
			})
			
			if option_3 == "take_offer":
				await game.dialogue("Actually... I'll take it.", "player", true, player)
				
				await game.dialogue("Wise choice.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
			elif option_3 == "leave":
				await game.dialogue("I think I'm making the right choice.", "player", true, player)
				
				await game.dialogue("Understood. We'll get a ride ready for you in a few minutes.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
			
				await game.dialogue("You probably won't see me again, so...", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
				
				await game.dialogue("Good luck out there.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
				
				return
		elif option_2 == "yes":
			await game.dialogue("Good, good.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
			
		await game.dialogue("I don't think I ever got a name.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("It's Kendall.", "player", true, player)
		
		await game.dialogue("Well, I'm Captain Arcten.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("And I'm Dr. Carie.", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		await game.dialogue("I can't wait to see you in my office soon, Kendall.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		_handle_4()
		
		await get_tree().create_timer(2).timeout
		
		await game.dialogue("I think we should probably get you up.", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		await game.dialogue("You'll need to get used to walking again if you're staying here.", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		await game.dialogue("It's also in your best interest if you get acquainted with everyone else here.", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		await game.dialogue("I guarantee you'll be seeing them a lot.", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		await game.dialogue("You think you can get up on your own?", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		await game.dialogue("Only one way to find out.", "player", true, player)
		
		await game.dialogue("Well, I can help if needed.", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		player.speed = 64
		player.busy = false
		
		game.get_node("ZMGDoctor1").navigate_to(game.get_node("Waypoints/DoctorPoint1").global_position)
		
		await game.dialogue("Try it.", "zmg_doctor_1", false, game.get_node("ZMGDoctor1"))
		
		_handle_3()
		
		while (player.global_position - game.get_node("ZMGDoctor1").global_position).length() > 48:
			await get_tree().create_timer(0.2).timeout
			
		player.busy = true
		
		await game.dialogue("Got the hang of it?", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		await game.dialogue("Starting to.", "player", true, player)
		
		await game.dialogue("Anything hurt?", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		await game.dialogue("Nope.", "player", true, player)
		
		await game.dialogue("Alright, good. I think I'll let you walk around now.", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		await game.dialogue("Once you're ready, you need to go talk to the Captain.", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
		
		await game.dialogue("He'll give you a room and whatnot.", "zmg_doctor_1", true, game.get_node("ZMGDoctor1"))
			
		game.stats.story_progress = 2
		
		game.save_game()
			
		player.busy = false
		player.speed = 128
		
func _handle_1():
	var i = 0
	while i < 5:
		await get_tree().create_timer(0.2).timeout
		
		game.set_vignette_parameter("softness", i * 0.02)
		
		i += 1
		

func _handle_2():
	var i = 5
	while i < 25:
		await get_tree().create_timer(0.2).timeout
		
		game.set_vignette_parameter("softness", i * 0.02)
		
		i += 1

func _handle_3():
	var i = 25
	while i < 100:
		await get_tree().create_timer(0.2).timeout
		
		game.set_vignette_parameter("softness", i * 0.04)
		
		i += 2

func _handle_4():
	await game.get_node("ZMGHideoutCaptain").navigate_to(game.get_node("Waypoints/CaptainPoint1").global_position)
	
	game.get_node("CaptainDoor1").set_open(true)
	
	await game.get_node("ZMGHideoutCaptain").navigate_to(game.get_node("Waypoints/CaptainPoint2").global_position)
	
	game.get_node("CaptainDoor1").set_open(false)


func _on_speed_up_area_entered(area: Area2D) -> void:
	if area.get_parent() == player:
		player.speed = 256
