extends RigidBody2D

func _ready() -> void:
	var variants = $Variants.get_children()
	var variant = variants[randi_range(0, variants.size() - 1)]
	
	$Variants.remove_child(variant)
	
	add_child(variant)
	
	var collision_shape = variant.get_node("CollisionShape")
	variant.remove_child(collision_shape)
	add_child(collision_shape)
	
	$Variants.queue_free()
