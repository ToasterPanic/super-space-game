extends Sprite2D

@onready var game = get_parent()

func _on_enter_hitbox_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		game.enter_physical(get_name())
