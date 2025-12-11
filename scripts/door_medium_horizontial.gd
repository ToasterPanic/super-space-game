extends StaticBody2D

@export var open: bool = false

func set_open(value: bool) -> void:
	open = value
	
	if open:
		$Occluder.position.y = INF
		$Sprite.animation = "open"
		$Occluder.occluder_light_mask = 1
	else:
		$Occluder.position.y = 0
		$Sprite.animation = "default"
		$Occluder.occluder_light_mask = 0
		
	$Sprite.play()
	
func _ready() -> void:
	set_open(open)
