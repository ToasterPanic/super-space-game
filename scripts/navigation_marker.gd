extends Sprite2D

@export var destination: Node2D = null

func _process(delta: float) -> void:
	if !destination: return
	
	look_at(destination.global_position)
	rotation += deg_to_rad(90)
