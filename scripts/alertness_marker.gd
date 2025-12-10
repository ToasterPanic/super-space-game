extends Sprite2D

@export var enemy: Node2D = null

func _process(delta: float) -> void:
	if !enemy: 
		queue_free()
		return
		
	$Point.value = enemy.reaction_timer / enemy.reaction_time
	
	look_at(enemy.global_position)
	
	rotation_degrees += 90
