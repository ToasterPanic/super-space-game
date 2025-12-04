extends CharacterBody2D

@onready var game = get_parent()

func _interact(player: Node2D) -> void:
	player.get_node("Camera").enabled = false
	$Camera.enabled = true
	$InteractArea.monitoring = false
	
	player.busy = true
	
	await game.dialogue("How may I help you?")
	
	await game.make_choice({
		"refuel": "Refuel ship",
		"buy": "Buy items",
		"exit": "Exit"
	})
	
	return
