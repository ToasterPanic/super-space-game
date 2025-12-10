extends TileMapLayer

func _ready() -> void:
	return
	
	var occlusion_map = duplicate()
	
	occlusion_map.set_material(preload("res://scenes/fov_hide_material.tres").instantiate())
	occlusion_map.z_index = -1000
	
	var tile_map = occlusion_map.tile_set.duplicate()
	#tile_map.occlusion_layer_0/light_mask
	
	get_parent().add_child(occlusion_map)
