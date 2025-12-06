extends CharacterBody2D

var horizontial_movement = 0
var vertical_movement = 0
var speed = 256

## Is the player busy in an interaction?
var busy = false

func _ready() -> void:
	$Sprite.play()

func _process(delta: float) -> void:
	if busy:
		velocity = Vector2()
	else:
		velocity = Vector2(speed * horizontial_movement, speed * vertical_movement)
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
