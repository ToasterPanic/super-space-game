extends Panel

@onready var game = get_parent().get_parent().get_parent()

func _resume() -> void:
	while Input.is_action_pressed("pause"):
		await get_tree().create_timer(0).timeout
		
	visible = false
	get_tree().paused = false


func _on_resume_pressed() -> void:
	_resume()

func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("pause"): _resume()
