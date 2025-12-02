extends CharacterBody2D

func _process(delta: float) -> void:
	var horizontial_movement = Input.get_axis("ground_left", "ground_right")
	var vertical_movement = Input.get_axis("ground_up", "ground_down")
	
	velocity = Vector2(256 * horizontial_movement, 256 * vertical_movement)
	
	move_and_slide()
