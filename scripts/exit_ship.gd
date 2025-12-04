extends Sprite2D

func _interact(_player: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
