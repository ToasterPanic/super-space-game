extends CharacterBody2D

@export var up: bool = false
@export var health: int = 1e10

func set_up(value: bool):
	up = value
	
	if up:
		$Sprite.animation = "up"
	else:
		$Sprite.animation = "down"
	
	$Hitbox/CollisionShape.disabled = !up
		
	$Sprite.play()
	
func _ready() -> void:
	set_up(up)
	
func _process(delta: float) -> void:
	if up and (health <= 0):
		set_up(false)
		health = 1e10
