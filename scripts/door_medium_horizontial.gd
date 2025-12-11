extends StaticBody2D

@export var open: bool = false

func set_open(value: bool) -> void:
	open = value
	
	if open:
		$Occluder.position.y = INF
		$Sprite.animation = "open"
	else:
		$Occluder.position.y = 0
		$Sprite.animation = "default"
	
	$CollisionShape.disabled = open
		
	$Sprite.play()
	
func _ready() -> void:
	set_open(open)
