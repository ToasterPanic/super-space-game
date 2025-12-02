extends RigidBody2D

var creator = null
var lifetime = 0
var has_collided = false

func _ready() -> void:
	if creator.get_name() == "Player":
		$Hitbox/Small.free()
	else:
		$Hitbox/Large.free()

func _process(delta: float) -> void:
	if has_collided: return
	
	linear_velocity =  transform.y * -1 * 2048


func _on_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body != creator:
		has_collided = true
		
		linear_velocity = Vector2()
		
		$Sprite.visible = false 
		$Trail.visible = false
		
		if "health" in body:
			body.health -= 75
		
		await get_tree().create_timer(1.0).timeout
		
		queue_free()
