extends StaticBody2D

@export var open: bool = false

func set_open(value: bool) -> void:
	open = value
	if open:
		$CollisionShape.disabled = true
		$Sprite.animation = "open"
		
	else:
		$CollisionShape.disabled = false
		$Sprite.animation = "default"
		
	$Sprite.play()
	
func _ready() -> void:
	set_open(open)
