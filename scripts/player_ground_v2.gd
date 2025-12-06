extends CharacterBody2D

## Is the player busy in an interaction?
var busy = false

func _ready() -> void:
	$Sprite.play()

func _process(delta: float) -> void:
	if "_process_2" in self: _process_2(delta)
	
	var horizontial_movement = Input.get_axis("ground_left", "ground_right")
	var vertical_movement = Input.get_axis("ground_up", "ground_down")
	
	if busy:
		velocity = Vector2()
	else:
		velocity = Vector2(256 * horizontial_movement, 256 * vertical_movement)
		
	if horizontial_movement > 0.1:
		$Sprite.scale.x = -2
	if horizontial_movement < -0.1:
		$Sprite.scale.x = 2
	
	if velocity.length() > 8:
		$Sprite.animation = "walk"
		if abs(horizontial_movement) > abs(vertical_movement): $Sprite.speed_scale = abs(horizontial_movement)
		else: $Sprite.speed_scale = abs(vertical_movement)
	else:
		$Sprite.animation = "idle"
		
	
	move_and_slide()
