extends "res://scripts/character_ground.gd"

var last_aim_direction = Vector2(0, 0)

@export var starting_gun: String = &"pistol"

func _ready() -> void:
	super()
	
	set_ground_gun(starting_gun)

func _process(delta: float) -> void:
	super(delta)
	
	if input_icon.using_gamepad:
		if !((Input.get_axis("aim_left", "aim_right") == 0) and (Input.get_axis("aim_up", "aim_down") == 0)):
			$HeldItem.rotation = Vector2(
				Input.get_axis("aim_left", "aim_right"),
				Input.get_axis("aim_up", "aim_down")
			).angle()
		
		if ($HeldItem.rotation_degrees < -90) or ($HeldItem.rotation_degrees > 90):
			$HeldItem/Sprite.scale.y = -1
		else:
			$HeldItem/Sprite.scale.y = 1
	else:
		$HeldItem.look_at(get_global_mouse_position())
	
	horizontial_movement = Input.get_axis("ground_left", "ground_right")
	vertical_movement = Input.get_axis("ground_up", "ground_down")
	
	firing = Input.is_action_pressed("fire")
