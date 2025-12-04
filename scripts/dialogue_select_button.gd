extends Button

var game = null


func _on_pressed() -> void:
	get_tree().quit()

func _input(event: InputEvent) -> void:
	if has_focus() and (event.is_action_pressed("interact") or event.is_action_pressed("dialogue_continue")):
		_on_pressed()
