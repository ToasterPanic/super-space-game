extends RigidBody2D

var health = 1000
var time_since_last_collision = 1
var camera_shake_power = 0

func _process(delta: float) -> void:
	$Camera.offset.x = randi_range(-camera_shake_power, camera_shake_power)
	$Camera.offset.y = randi_range(-camera_shake_power, camera_shake_power)
	
	if camera_shake_power > 0:
		camera_shake_power -= delta * 20
		
	if camera_shake_power < 0:
		camera_shake_power = 0
	
	if time_since_last_collision <= 1:
		time_since_last_collision += delta

func _physics_process(delta: float) -> void:
	var axis = Input.get_axis("turn_left", "turn_right")
	
	angular_velocity = deg_to_rad(180 * axis)
	
	var new_velocity = transform.y * Input.get_axis("forward", "backward") * 512
	
	if (new_velocity.length() > linear_velocity.length() - 12) :
		linear_velocity = transform.y * Input.get_axis("forward", "backward") * 512
		if time_since_last_collision < 1:
			linear_velocity *= (time_since_last_collision + 0.15) * 2


func _on_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.linear_velocity.length() + linear_velocity.length() > 256:
		health -= 100
		camera_shake_power = 4 
		
		$Collision.play()
		
		time_since_last_collision = 0
