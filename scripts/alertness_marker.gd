extends Sprite2D

@export var enemy: Node2D = null

func _ready() -> void:
	if !enemy: 
		queue_free()
		return
		
	while enemy.reaction_timer > 0:
		look_at(enemy.global_position)
		
	#if enemy.get_node("LineOfSight").get_collider().get_name() == "PlayerGround": #modulate = 
		
	queue_free()
