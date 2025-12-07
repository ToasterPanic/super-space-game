extends "res://scripts/character_ground.gd"

var last_aim_direction = Vector2(0, 0)

func _ready() -> void:
	super()
	
	if global.stats.gun_holstered:
		set_ground_gun(null)
	else:
		set_ground_gun(global.stats.equipped_ground_gun)

func _process(delta: float) -> void:
	super(delta)
	
	if dead:
		if global.checkpoint:
			global.load_game()
			get_tree().change_scene_to_file("res://scenes/ground.tscn")
	
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
	
	if $HeldItem/Cast.get_collision_point():
		$HeldItem/Crosshair.visible = true
		$HeldItem/Line.visible = true
		
		$HeldItem/Crosshair.global_position = $HeldItem/Cast.get_collision_point()
		$HeldItem/Line.points[1].x = ($HeldItem/Cast.get_collision_point() - global_position).length()
	else:
		$HeldItem/Crosshair.visible = false
		$HeldItem/Line.visible = false
		
	if Input.is_action_just_pressed("toggle_holster"):
		global.stats.gun_holstered = !global.stats.gun_holstered
		
		if global.stats.gun_holstered:
			set_ground_gun(null)
		else:
			set_ground_gun(global.stats.equipped_ground_gun)
			
	
	firing = Input.is_action_pressed("fire")
