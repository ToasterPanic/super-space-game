extends "res://scripts/character_ground.gd"

var last_aim_direction = Vector2(0, 0)
var processing_death = false
var camera_shake_power = 0

func _ready() -> void:
	super()
	
	if global.stats.gun_holstered:
		set_ground_gun(null)
	else:
		set_ground_gun(global.stats.equipped_ground_gun)

func _process(delta: float) -> void:
	super(delta)
	
	var screen_size = get_viewport().get_visible_rect()
	
	$Camera.zoom.x = ((screen_size.size.x / 1600) + (screen_size.size.y / 900)) / 2.5
	$Camera.zoom.y = $Camera.zoom.x
	
	camera_shake_power -= delta * 20
	if camera_shake_power < 0:
		camera_shake_power = 0
	
	$Camera.offset.x = randi_range(-camera_shake_power, camera_shake_power)
	$Camera.offset.y = randi_range(-camera_shake_power, camera_shake_power)
	
	if dead:
		if processing_death: return
		
		processing_death = true
		
		AudioServer.set_bus_effect_enabled(1, 0, true)
		AudioServer.set_bus_effect_enabled(2, 0, true)
		
		AudioServer.set_bus_volume_linear(3, AudioServer.get_bus_volume_linear(2))
		
		if global.stats.story_progress == 0:
			$Knockout.play()
		else:
			$Death.play()
		
		var i = 21
		while i > -1:
			await get_tree().create_timer(0.05).timeout
			
			get_parent().set_vignette_parameter("softness", i * 0.05)
			
			i -= 1
		
		
		if global.stats.story_progress == 0:
			await get_tree().create_timer(2).timeout
			
			global.stats.location = "ahma_hideout"
			global.stats.story_progress = 1
		else:
			await get_tree().create_timer(4).timeout
			
			global.load_game()
		
		AudioServer.set_bus_effect_enabled(1, 0, false)
		AudioServer.set_bus_effect_enabled(2, 0, false)
		
		get_parent().set_vignette_parameter("softness", 0)
		
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
		if global.stats.equipped_ground_gun:
			global.stats.gun_holstered = !global.stats.gun_holstered
			
			if global.stats.gun_holstered:
				set_ground_gun(null)
			else:
				set_ground_gun(global.stats.equipped_ground_gun)
		else:
			global.stats.gun_holstered = true
			
			set_ground_gun(null)
			
	
	firing = Input.is_action_pressed("fire")
