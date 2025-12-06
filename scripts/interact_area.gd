extends Area2D

@export var interact_text = "INTERACT"
var game = null

func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "PlayerGround":
		game.current_interaction_area = self

func _on_body_exited(body: Node2D) -> void:
	if body.get_name() == "PlayerGround":
		if game.current_interaction_area == self: game.current_interaction_area = null
