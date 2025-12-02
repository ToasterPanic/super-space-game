extends Sprite2D

var game = get_parent()

func _on_enter_hitbox_area_entered(area: Area2D) -> void:
	if area.get_name() == "Player":
		game.enter_physical(get_name())
