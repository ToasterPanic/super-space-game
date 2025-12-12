extends CharacterBody2D

var horizontial_movement = 0
var vertical_movement = 0
var speed = 256
var health = 100
var max_health: float = 100
var dead = false

var fire_delay = 0

## Is the player busy in an interaction?
var busy = false

var firing = false
var sprinting = false

var equipped_ground_gun = "pistol"
var ammo_in_mag = 12

var game = null

func set_ground_gun(value):
	equipped_ground_gun = value
	
	if value:
		$HeldItem/Sprite.texture = load("res://textures/" + equipped_ground_gun + ".png")
		ammo_in_mag = global.ground_guns
	
func navigate_to(goal: Vector2):
	if has_node("Navigation/Agent"):
		$Navigation/Agent.target_position = goal
		
		while !$Navigation/Agent.is_navigation_finished():
			var next_position = $Navigation/Agent.get_next_path_position()
			next_position.y -= 32
			
			var axes = global_position.direction_to(next_position)
			
			horizontial_movement = axes.x
			vertical_movement = axes.y
			
			# This is a bad way to do this, to be honest. However, I am lazy
			await get_tree().create_timer(0.05).timeout
			
		horizontial_movement = 0
		vertical_movement = 0

func _ready() -> void:
	$Sprite.play()
	
	if has_node("HeldItem") and (equipped_ground_gun != null): 
		set_ground_gun(equipped_ground_gun)
		$HeldItem/Cast.add_exception(self)

func _process(delta: float) -> void:
	if dead:
		velocity /= 1.3
		$Sprite.rotation_degrees = -90
		$Sprite.position.y = 64
		$Sprite.animation = "idle"
		
		if has_node("HeldItem"): $HeldItem.visible = false
		
		return
	
	if !$Sprite.is_playing():
		$Sprite.play()
		
	$Sprite.modulate.g = health / max_health
	$Sprite.modulate.b = health / max_health
	
	if health <= 0:
		dead = true
		
		$CollisionShape.queue_free()
		$Hitbox.queue_free()
		
		if randi_range(0, 1) == 0:
			$Sprite.rotation_degrees = -90
		else:
			$Sprite.rotation_degrees = 90
		
	if busy:
		velocity = Vector2()
	else:
		velocity = Vector2(speed * horizontial_movement, speed * vertical_movement)
	if horizontial_movement > 0.1:
		$Sprite.scale.x = -2
	if horizontial_movement < -0.1:
		$Sprite.scale.x = 2
	
	if velocity.length() > 8:
		$Sprite.animation = "walk"
		if abs(horizontial_movement) > abs(vertical_movement): $Sprite.speed_scale = abs(horizontial_movement)
		else: $Sprite.speed_scale = abs(vertical_movement)
	else:
		$Sprite.animation = "idle"
		
	fire_delay -= delta
	if has_node("HeldItem"):
		if !equipped_ground_gun:
			$HeldItem.visible = false
		else:
			$HeldItem.visible = true
			
			if firing and (fire_delay < 0):
				$HeldItem/Cast.force_raycast_update()
				
				var hit_target = $HeldItem/Cast.get_collider()
				
				if hit_target:
					if "health" in hit_target.get_parent():
						hit_target.get_parent().health -= global.ground_guns[equipped_ground_gun].damage
						
						var blood = preload("res://scenes/particles/blood.tscn").instantiate() 
						blood.global_position = $HeldItem/Cast.get_collision_point()
						
						get_parent().add_child(blood)
						
						blood.play()
					else:
						var bullet_impact = preload("res://scenes/particles/bullet_impact.tscn").instantiate() 
						bullet_impact.global_position = $HeldItem/Cast.get_collision_point()
						
						get_parent().add_child(bullet_impact)
				
				
						bullet_impact.play()
				
				var bullet_trail = preload("res://scenes/particles/bullet_trail.tscn").instantiate()
				bullet_trail.global_position = $HeldItem/Sprite.global_position
				
				bullet_trail.points[1] = ($HeldItem/Cast.get_collision_point() - bullet_trail.global_position)
				
				get_parent().add_child(bullet_trail)
				
				bullet_trail.play()
				
				$HeldItem/Gunshot.play()
				
				if game:
					if game.get_node("PlayerGround").camera_shake_power <= 2:
						game.get_node("PlayerGround").camera_shake_power = 2
				
				fire_delay = global.ground_guns[equipped_ground_gun].fire_rate
	
	move_and_slide()
