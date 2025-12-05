extends Button

var game = null

func _on_pressed() -> void:
	game.choice_made.emit(get_name())
