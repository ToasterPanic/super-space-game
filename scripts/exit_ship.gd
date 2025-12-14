extends Sprite2D

func _interact(player: Node2D = null, area: Node2D = null) -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
