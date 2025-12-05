extends RigidBody2D

var health = 500
var boost = 100
var speed = 372
var time_since_last_collision = 1
var time_since_last_fire = 0
var boosting = false
var firing = true
var dead = false

var axis = 0
var movement_axis = -1
var evade_direction = 1

var stress = 0

var AI_MODE_ATTACK = 1

var ai_mode = AI_MODE_ATTACK

var AI_STATE_EVADE_OBJECT = 1
var AI_STATE_TRACK_ENEMY = 2
var AI_STATE_EVADE_ENEMY_AIM = 3
var AI_STATE_STATIONARY_ENEMY = 4

var object_to_evade = null
var last_ai_state_before_evasion = AI_STATE_TRACK_ENEMY

var ai_state = AI_STATE_TRACK_ENEMY
var target_rotation = 0
var target_rotation_speed = 1

var boost_pressed = false

var ai_tick = 0.1
@onready var player = get_parent().get_node("Player")

var laser_scene = preload("res://scenes/laser.tscn")

func cast(angle):
	$SightCast.rotation_degrees = angle
	$SightCast.force_raycast_update()
	
	return $SightCast.get_collider()
	
func check_front():
	var front_cast = cast(0)
	if !front_cast:
		$SightCast.position.x = -20
		front_cast = cast(0)
		
		if !front_cast:
			$SightCast.position.x = 20
			front_cast = cast(0)
			
	$SightCast.position.x = 0
			
	if front_cast:
		$SightCast.position.x = -20
		$SightCast.force_raycast_update()
		var cast_left = $SightCast.get_collision_point()
		
		$SightCast.position.x = 20
		$SightCast.force_raycast_update()
		var cast_right = $SightCast.get_collision_point()
		
		$SightCast.position.x = 0
		
		if (cast_left - $SightCast.position).length() > (cast_right - $SightCast.position).length(): return -1
		else: return 1
		
	return 1

func _process(delta: float) -> void:
	if dead: return
	
	modulate.g = health / 1000.0
	modulate.b = health / 1000.0
	
	if health <= 0:
		dead = true
		
		modulate = Color(1,1,1)
		
		$Explode.play()
		$Explosion.play()
		
		$Sprite.queue_free()
		$CollisionShape.queue_free()
		linear_velocity = Vector2()
		
		
		await get_tree().create_timer(10.5).timeout
	
	ai_tick -= delta
	
	if boosting:
		if boost_pressed:
			boost -= delta * 40
			
			if boost <= 0:
				boost = 0
				boosting = false
				$BoostFinish.play()
		else:
			boosting = false
			$BoostFinish.play()
	else:
		boost += delta * 25
		if boost > 75: boost = 75
		
		$Boost.stop()
		if boost_pressed and (boost > 33):
			boosting = true
			$Boost.play()
			
	time_since_last_fire -= delta
	
	if (time_since_last_fire <= 0) and firing:
		time_since_last_fire = 0.25
		
		var laser = laser_scene.instantiate() 
		
		laser.creator = self 
		
		laser.position = position 
		laser.rotation = rotation
		
		get_parent().get_node("Unloadables").add_child(laser)
	
	if time_since_last_collision <= 1:
		time_since_last_collision += delta
		
	if ai_tick < 0:
		ai_tick = 0.25
		
		movement_axis = -1
		
		var player_distance = (player.position - position).length()
		
		var front_cast = cast(0)
		if !front_cast:
			$SightCast.position.x = -20
			front_cast = cast(0)
			
			if !front_cast:
				$SightCast.position.x = 20
				front_cast = cast(0)
		
		$SightCast.position.x = 0
		
		if ai_mode == AI_MODE_ATTACK:
			firing = false
			
			if !front_cast and (player_distance > 720):
				boost_pressed = true
			else:
				boost_pressed = false
				
			var direction_to_player = global_position.direction_to(player.position).angle() + deg_to_rad(270)
			
			if ai_state == AI_STATE_TRACK_ENEMY:
				target_rotation = direction_to_player
				
				if (player.linear_velocity.length() < 256) and (player_distance < 256):
					ai_state = AI_STATE_STATIONARY_ENEMY
				
			if ai_state == AI_STATE_STATIONARY_ENEMY:
				target_rotation = direction_to_player
				movement_axis = 0
				boost_pressed = false
				
				if (player.linear_velocity.length() > 256) or (player_distance > 320):
					ai_state = AI_STATE_TRACK_ENEMY
					
			var direction = (player.position - position).normalized()

		# Optionally, you can get the angle if needed
			var angle = direction.angle() + deg_to_rad(90)
		
			var angular_target = wrapf(angle - rotation, -PI, PI)
					
			if abs(rad_to_deg(angle - angular_target)) < 25:
				if player_distance > 480: boost_pressed = true
				
				firing = true
		if front_cast:
			var front_cast_distance = ($SightCast.get_collision_point() - position).length()
			
			if (front_cast_distance < 160 * (speed / 300.0)) and (front_cast_distance < player_distance) and (ai_state != AI_STATE_STATIONARY_ENEMY):
				if ai_state != AI_STATE_EVADE_OBJECT: last_ai_state_before_evasion = ai_state 
				
				ai_state = AI_STATE_EVADE_OBJECT
				target_rotation += deg_to_rad(45) * check_front()
				
				object_to_evade = front_cast
				
		target_rotation_speed = 0.8
			
		if ai_state == AI_STATE_EVADE_OBJECT:
			if not front_cast:
				ai_state = last_ai_state_before_evasion
			else:
				var front_cast_distance = ($SightCast.get_collision_point() - position).length()
				if front_cast_distance > 160 * (speed / 300):
					ai_state = last_ai_state_before_evasion

func _physics_process(delta: float) -> void:
	axis = 0
	
	if dead: return
	
	var difference = fmod(target_rotation, deg_to_rad(360)) - fmod(rotation, deg_to_rad(360)) 
	var normalized_difference = fmod(difference + deg_to_rad(180), deg_to_rad(360)) - deg_to_rad(180)
	var target_distance = normalized_difference
	
	if target_distance < 0:
		axis = target_rotation_speed
	if target_distance > 0:
		axis = -target_rotation_speed
	
	angular_velocity = deg_to_rad(180 * axis)
	
	var final_speed = speed
	
	if boosting:
		movement_axis = -1
		final_speed = 1024
	
	# Slow down on collision and gradually speed up
	if time_since_last_collision < 0.85: final_speed *= (time_since_last_collision + 0.15)
	
	var new_velocity = transform.y * movement_axis * final_speed
	
	if (new_velocity.length() > linear_velocity.length() - 12):
		linear_velocity = new_velocity


func _on_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not "linear_velocity" in body: return
	
	if body.linear_velocity.length() + linear_velocity.length() > 256:
		$Collision.play()
		
		time_since_last_collision = 0
