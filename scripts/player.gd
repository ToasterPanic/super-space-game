extends RigidBody2D

var health = 1000
var boost = 100
var time_since_last_fire = 0
var time_since_last_collision = 1
var camera_shake_power = 0
var boosting = false
var hyperboosting = false

var laser_scene = preload("res://scenes/laser.tscn")

func _process(delta: float) -> void:
	modulate.g = health / 1000.0
	modulate.b = health / 1000.0
	
	$Camera.offset.x = randi_range(-camera_shake_power, camera_shake_power)
	$Camera.offset.y = randi_range(-camera_shake_power, camera_shake_power)
	
	var screen_size = get_viewport().get_visible_rect()
	
	$Camera.zoom.x = ((screen_size.size.x / 1600) + (screen_size.size.y / 900)) / 2.5
	$Camera.zoom.y = $Camera.zoom.x
	
	time_since_last_fire -= delta
	
	if (time_since_last_fire <= 0) and Input.is_action_pressed("fire"):
		time_since_last_fire = 0.25
		
		$Fire.play()
		
		var laser = laser_scene.instantiate() 
		
		laser.creator = self 
		
		laser.position = position 
		laser.rotation = rotation
		
		get_parent().get_node("Unloadables").add_child(laser)
	
	$BoostParticles.emitting = boosting
	
	if boosting:
		if Input.is_action_pressed("boost"):
			boost -= delta * 40
			
			if camera_shake_power < 2:
				camera_shake_power = 2
			
			if boost <= 0:
				boost = 0
				boosting = false
				$BoostFinish.play()
		else:
			boosting = false
			$BoostFinish.play()
	else:
		boost += delta * 40
		if boost > 100: boost = 100
		
		$Boost.stop()
		if Input.is_action_just_pressed("boost") and (boost > 33):
			boosting = true
			$Boost.play()
	
	if boost < 100:
		$BoostMeter.modulate = Color(1, 1, 1, 1)
	else:
		$BoostMeter.modulate.a -= delta * 2
	$BoostMeter.value = boost 
	$BoostMeter/Label.text = str(floori(boost))
		
	if health < 100:
		$HealthMeter.modulate = Color(1, 1, 1, 1)
	else:
		$HealthMeter.modulate.a -= delta * 2
	$HealthMeter.value = health / 10 
	$HealthMeter/Label.text = str(floori(health / 10))
	
	if camera_shake_power > 0:
		camera_shake_power -= delta * 20
		
	if camera_shake_power < 0:
		camera_shake_power = 0
	
	if time_since_last_collision <= 1:
		time_since_last_collision += delta
		
	if hyperboosting:
		if (global.stats.navigation_goal.point.global_position - global_position).length() < 3000:
			hyperboosting = false

func _physics_process(delta: float) -> void:
	var axis = Input.get_axis("turn_left", "turn_right")
	var movement_axis = Input.get_axis("forward", "backward")
	
	angular_velocity = deg_to_rad(180 * axis)
	
	var final_speed = 512
	
	if boosting:
		movement_axis = -1
		final_speed = 1024
		
	if hyperboosting:
		movement_axis = -1
		final_speed = 4096
		
		angular_velocity = 0
		
		look_at(global.stats.navigation_goal.point.global_position)
		
		rotation_degrees += 90
		
		global.stats.fuel -= delta * 7
		
		$CollisionShape.disabled = true
		$Hitbox.monitoring = false
	else:
		$CollisionShape.disabled = false
		$Hitbox.monitoring = true
		
	
	# Slow down on collision and gradually speed up
	if time_since_last_collision < 0.85: final_speed *= (time_since_last_collision + 0.15)
	
	var new_velocity = transform.y * movement_axis * final_speed
	
	if (new_velocity.length() > linear_velocity.length() - 12):
		linear_velocity = new_velocity


func _on_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	var hit_velocity = linear_velocity.length()
	if "linear_velocity" in body:
		hit_velocity = body.linear_velocity.length() + linear_velocity.length()
		
	if hit_velocity > 256:
		camera_shake_power = 4 
		
		$Collision.play()
		
		time_since_last_collision = 0
