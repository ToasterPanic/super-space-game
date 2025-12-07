extends CharacterBody2D

@onready var game = get_parent()

func _interact(player: Node2D) -> void:
	player.get_node("Camera").enabled = false
	$Camera.enabled = true
	$InteractArea.monitoring = false
	
	player.busy = true
	
	await game.dialogue("How may I help you?")
	
	var option = await game.make_choice({
		"refuel": "Refuel ship",
		"buy": "Buy items",
		"exit": "Exit"
	})
	
	if option == "refuel":
		await game.dialogue("How much?")
		
		var price_per_percentage = 0.433
		var price_full = floori((100 - global.stats.fuel) * price_per_percentage)
		var price_half = floori((50 - global.stats.fuel) * price_per_percentage)
		var price_quarter = floori((25 - global.stats.fuel) * price_per_percentage)
		
		var options = {
			"full": "Refuel Tank (" + str(price_full)+ "¤)"
		}
		
		if price_half > 0:
			options.half = "Refuel to 50% (" + str(price_half) + "¤)"
		if price_quarter > 0:
			options.quarter = "Refuel to 25% (" + str(price_quarter) + "¤)"
			
		options.exit = "Nevermind"
		
		var fuel_option = await game.make_choice(options)
		
		if fuel_option == "full":
			if price_full <= global.stats.marks:
				global.stats.fuel = 100
				global.stats.marks -= price_full
				
				await game.dialogue("Okay, your tank should be filled to 100%.")
			else:
				await game.dialogue("Sorry, but you don't have enough marks for that.")
		elif fuel_option == "half":
			if price_half <= global.stats.marks:
				global.stats.fuel = 50
				global.stats.marks -= price_half
				
				await game.dialogue("Okay, your tank should be filled to 50%.")
			else:
				await game.dialogue("Sorry, but you don't have enough marks for that.")
		elif fuel_option == "quarter":
			if price_quarter <= global.stats.marks:
				global.stats.fuel = 25
				global.stats.marks -= price_quarter
				
				await game.dialogue("Okay, your tank should be filled to 25%.")
			else:
				await game.dialogue("Sorry, but you don't have enough marks for that.")
				
		game.save_game()
	
	player.get_node("Camera").enabled = true
	$Camera.enabled = false
	$InteractArea.monitoring = true
	
	player.busy = false
	
	return
