extends "res://scripts/character_ground.gd"

func _process(delta: float) -> void:
	super(delta)
	
	horizontial_movement = Input.get_axis("ground_left", "ground_right")
	vertical_movement = Input.get_axis("ground_up", "ground_down")
