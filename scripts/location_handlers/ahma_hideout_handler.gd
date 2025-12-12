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
		
		await get_tree().create_timer(1).timeout
	
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
			
			await game.dialogue("Yeah, unfortunately...", "zmg_doctor_1", true, game.get_node("ZMGHideoutCaptain"))
		
			await game.dialogue("It's probably wise to tell you where you are.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
			
			await game.dialogue("You're currently in an ZMG hideout.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		elif option_0 == "where":
			await game.dialogue("... where am I ...", "player", true, player)
			
			await game.dialogue("Well, you're currently in an ZMG hideout.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		
		await game.dialogue("While we were attempting to stop a terrorist attack on Space Station 01,", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("we found you on the ground, riddled with bullet holes.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("The majority of them have healed.", "zmg_doctor_1", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("You've been out for... nearing three earth weeks?", "zmg_doctor_1", true, game.get_node("ZMGHideoutCaptain"))
		
		await game.dialogue("Curie, if you could wait a second, I'd like to ask them a question.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
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
		
		await game.dialogue("If you're not aware, we're a military for the nation of Atlana.", "zmg_hideout_captain", true, game.get_node("ZMGHideoutCaptain"))
		
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
func _handle_1():
	var i = 0
	while i < 5:
		await get_tree().create_timer(0.2).timeout
		
		game.set_vignette_parameter("softness", i * 0.02)
		
		i += 1
		

func _handle_2():
	var i = 15
	while i < 25:
		await get_tree().create_timer(0.2).timeout
		
		game.set_vignette_parameter("softness", i * 0.02)
		
		i += 1
