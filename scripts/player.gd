extends RigidBody2D

var health = 1000
var boost = 100
var time_since_last_collision = 1
var camera_shake_power = 0
var boosting = false

func _process(delta: float) -> void:
	$Camera.offset.x = randi_range(-camera_shake_power, camera_shake_power)
	$Camera.offset.y = randi_range(-camera_shake_power, camera_shake_power)
	
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
		boost += delta * 25
		if boost > 100: boost = 100
		
		$Boost.stop()
		if Input.is_action_just_pressed("boost") and (boost > 33):
			boosting = true
			$Boost.play()
	
	if camera_shake_power > 0:
		camera_shake_power -= delta * 20
		
	if camera_shake_power < 0:
		camera_shake_power = 0
	
	if time_since_last_collision <= 1:
		time_since_last_collision += delta

func _physics_process(delta: float) -> void:
	var axis = Input.get_axis("turn_left", "turn_right")
	var movement_axis = Input.get_axis("forward", "backward")
	
	angular_velocity = deg_to_rad(180 * axis)
	
	var final_speed = 512
	
	if boosting:
		movement_axis = -1
		final_speed = 1024
	
	# Slow down on collision and gradually speed up
	if time_since_last_collision < 0.85: final_speed *= (time_since_last_collision + 0.15)
	
	var new_velocity = transform.y * movement_axis * final_speed
	
	if (new_velocity.length() > linear_velocity.length() - 12):
		linear_velocity = new_velocity


func _on_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.linear_velocity.length() + linear_velocity.length() > 256:
		health -= 100
		camera_shake_power = 4 
		
		$Collision.play()
		
		time_since_last_collision = 0
