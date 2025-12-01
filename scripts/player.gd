extends RigidBody2D

var health = 1000
var time_since_last_collision = 0

func _physics_process(delta: float) -> void:
	var axis = Input.get_axis("turn_left", "turn_right")
	
	angular_velocity = deg_to_rad(180 * axis)
	
	var new_velocity = transform.y * Input.get_axis("forward", "backward") * 512
	
	if new_velocity.length() > linear_velocity.length() - 12:
		linear_velocity = transform.y * Input.get_axis("forward", "backward") * 512
